package com.car4s.util;

import org.redisson.api.RLock;
import org.redisson.api.RedissonClient;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.stereotype.Component;

import java.util.concurrent.TimeUnit;
import java.util.function.Supplier;

/**
 * Redis工具类
 * 封装缓存操作，解决穿透、击穿、雪崩等问题
 */
@Component
public class RedisUtil {

    private static final Logger logger = LoggerFactory.getLogger(RedisUtil.class);

    /**
     * 空值标记，用于解决缓存穿透
     */
    private static final String NULL_VALUE = "NULL_VALUE";

    /**
     * 空值过期时间（秒）
     */
    private static final long NULL_VALUE_EXPIRE_TIME = 60;

    @Autowired
    private RedisTemplate<String, Object> redisTemplate;

    @Autowired
    private RedissonClient redissonClient;

    /**
     * 获取缓存数据
     * 解决缓存穿透：缓存空值
     *
     * @param key 缓存键
     * @param clazz 数据类型
     * @return 缓存数据
     */
    public <T> T get(String key, Class<T> clazz) {
        Object value = redisTemplate.opsForValue().get(key);
        
        if (value == null) {
            return null;
        }
        
        // 检查是否是空值标记
        if (NULL_VALUE.equals(value.toString())) {
            logger.debug("缓存命中空值标记，key: {}", key);
            return null;
        }
        
        if (clazz.isInstance(value)) {
            return clazz.cast(value);
        }
        
        return null;
    }

    /**
     * 设置缓存数据
     * 解决缓存雪崩：添加随机过期时间
     *
     * @param key 缓存键
     * @param value 缓存值
     * @param expireTime 过期时间（秒）
     */
    public void set(String key, Object value, long expireTime) {
        if (value == null) {
            // 缓存空值，解决穿透问题
            redisTemplate.opsForValue().set(key, NULL_VALUE, NULL_VALUE_EXPIRE_TIME, TimeUnit.SECONDS);
        } else {
            // 添加随机延迟（0-300秒），解决雪崩问题
            long randomDelay = (long) (Math.random() * 300);
            redisTemplate.opsForValue().set(key, value, expireTime + randomDelay, TimeUnit.SECONDS);
        }
    }

    /**
     * 设置缓存数据（无过期时间）
     *
     * @param key 缓存键
     * @param value 缓存值
     */
    public void set(String key, Object value) {
        if (value == null) {
            redisTemplate.opsForValue().set(key, NULL_VALUE, NULL_VALUE_EXPIRE_TIME, TimeUnit.SECONDS);
        } else {
            redisTemplate.opsForValue().set(key, value);
        }
    }

    /**
     * 删除缓存
     * 用于双写一致性：更新数据库时删除缓存
     *
     * @param key 缓存键
     */
    public void delete(String key) {
        redisTemplate.delete(key);
    }

    /**
     * 批量删除缓存
     *
     * @param keys 缓存键集合
     */
    public void deleteBatch(java.util.Collection<String> keys) {
        redisTemplate.delete(keys);
    }

    /**
     * 判断key是否存在
     *
     * @param key 缓存键
     * @return 是否存在
     */
    public boolean hasKey(String key) {
        return Boolean.TRUE.equals(redisTemplate.hasKey(key));
    }

    /**
     * 带分布式锁的缓存查询
     * 解决缓存击穿：使用互斥锁重建缓存
     *
     * @param key 缓存键
     * @param clazz 数据类型
     * @param dbQuery 数据库查询逻辑
     * @param expireTime 过期时间（秒）
     * @return 数据
     */
    public <T> T getWithLock(String key, Class<T> clazz, Supplier<T> dbQuery, long expireTime) {
        // 1. 先从缓存获取
        T value = get(key, clazz);
        if (value != null) {
            return value;
        }

        // 2. 缓存未命中，获取分布式锁
        String lockKey = "lock:" + key;
        RLock lock = redissonClient.getLock(lockKey);
        
        try {
            // 尝试获取锁，最多等待3秒，持有锁10秒
            boolean acquired = lock.tryLock(3, 10, TimeUnit.SECONDS);
            
            if (acquired) {
                try {
                    // 3. 双重检查：再次从缓存获取（可能其他线程已经重建了缓存）
                    value = get(key, clazz);
                    if (value != null) {
                        return value;
                    }

                    // 4. 从数据库查询
                    logger.info("缓存未命中，从数据库查询，key: {}", key);
                    value = dbQuery.get();

                    // 5. 写入缓存
                    set(key, value, expireTime);
                    
                    return value;
                } finally {
                    // 6. 释放锁
                    if (lock.isHeldByCurrentThread()) {
                        lock.unlock();
                    }
                }
            } else {
                // 7. 获取锁失败，等待后重试
                logger.warn("获取分布式锁失败，等待重试，key: {}", key);
                Thread.sleep(50);
                return getWithLock(key, clazz, dbQuery, expireTime);
            }
        } catch (InterruptedException e) {
            logger.error("获取分布式锁被中断，key: {}", key, e);
            Thread.currentThread().interrupt();
            return null;
        }
    }

    /**
     * 更新缓存（双写一致性）
     * 采用Cache-Aside模式：先更新数据库，再删除缓存
     *
     * @param key 缓存键
     * @param dbUpdate 数据库更新逻辑
     */
    public void updateWithCacheInvalidation(String key, Runnable dbUpdate) {
        // 1. 先更新数据库
        dbUpdate.run();
        
        // 2. 再删除缓存（保证一致性）
        delete(key);
        logger.info("缓存已失效，key: {}", key);
    }

    /**
     * 删除缓存（双写一致性）
     *
     * @param key 缓存键
     * @param dbDelete 数据库删除逻辑
     */
    public void deleteWithCacheInvalidation(String key, Runnable dbDelete) {
        // 1. 先删除数据库
        dbDelete.run();
        
        // 2. 再删除缓存
        delete(key);
        logger.info("缓存已失效，key: {}", key);
    }

    /**
     * 设置过期时间
     *
     * @param key 缓存键
     * @param expireTime 过期时间（秒）
     */
    public void expire(String key, long expireTime) {
        redisTemplate.expire(key, expireTime, TimeUnit.SECONDS);
    }

    /**
     * 获取过期时间
     *
     * @param key 缓存键
     * @return 过期时间（秒）
     */
    public long getExpire(String key) {
        Long expire = redisTemplate.getExpire(key, TimeUnit.SECONDS);
        return expire != null ? expire : -1;
    }
}
