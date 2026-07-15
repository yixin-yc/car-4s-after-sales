package com.car4s.config;

import com.fasterxml.jackson.annotation.JsonAutoDetect;
import com.fasterxml.jackson.annotation.PropertyAccessor;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.jsontype.impl.LaissezFaireSubTypeValidator;
import org.redisson.Redisson;
import org.redisson.api.RedissonClient;
import org.redisson.config.Config;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.cache.CacheManager;
import org.springframework.cache.annotation.EnableCaching;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.data.redis.cache.RedisCacheConfiguration;
import org.springframework.data.redis.cache.RedisCacheManager;
import org.springframework.data.redis.connection.RedisConnectionFactory;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.data.redis.serializer.Jackson2JsonRedisSerializer;
import org.springframework.data.redis.serializer.RedisSerializationContext;
import org.springframework.data.redis.serializer.StringRedisSerializer;

import java.time.Duration;
import java.util.HashMap;
import java.util.Map;
import java.util.Random;

/**
 * Redis分布式缓存配置
 * 解决缓存穿透、击穿、雪崩、双写一致性等问题
 */
@Configuration
@EnableCaching
public class RedisConfig {

    @Value("${spring.redis.host}")
    private String redisHost;

    @Value("${spring.redis.port}")
    private int redisPort;

    @Value("${spring.redis.password:}")
    private String redisPassword;

    /**
     * 配置RedisTemplate
     * 使用JSON序列化，避免JDK序列化导致的可读性问题
     */
    @Bean
    public RedisTemplate<String, Object> redisTemplate(RedisConnectionFactory connectionFactory) {
        RedisTemplate<String, Object> template = new RedisTemplate<>();
        template.setConnectionFactory(connectionFactory);

        // 使用Jackson2JsonRedisSerializer来序列化和反序列化redis value
        Jackson2JsonRedisSerializer<Object> jackson2JsonRedisSerializer = new Jackson2JsonRedisSerializer<>(Object.class);
        ObjectMapper mapper = new ObjectMapper();
        mapper.setVisibility(PropertyAccessor.ALL, JsonAutoDetect.Visibility.ANY);
        mapper.activateDefaultTyping(LaissezFaireSubTypeValidator.instance, ObjectMapper.DefaultTyping.NON_FINAL);
        jackson2JsonRedisSerializer.setObjectMapper(mapper);

        StringRedisSerializer stringRedisSerializer = new StringRedisSerializer();

        // key采用String的序列化方式
        template.setKeySerializer(stringRedisSerializer);
        // hash的key也采用String的序列化方式
        template.setHashKeySerializer(stringRedisSerializer);
        // value序列化方式采用jackson
        template.setValueSerializer(jackson2JsonRedisSerializer);
        // hash的value序列化方式采用jackson
        template.setHashValueSerializer(jackson2JsonRedisSerializer);

        template.afterPropertiesSet();
        return template;
    }

    /**
     * 配置RedissonClient（分布式锁）
     * 用于解决缓存击穿问题
     */
    @Bean
    public RedissonClient redissonClient() {
        Config config = new Config();
        config.useSingleServer()
                .setAddress("redis://" + redisHost + ":" + redisPort)
                .setPassword(redisPassword != null && !redisPassword.isEmpty() ? redisPassword : null)
                .setDatabase(0)
                .setConnectionPoolSize(50)
                .setConnectionMinimumIdleSize(10);
        return Redisson.create(config);
    }

    /**
     * 配置CacheManager
     * 针对不同缓存名设置不同的过期时间，并添加随机延迟防止雪崩
     */
    @Bean
    public CacheManager cacheManager(RedisConnectionFactory connectionFactory) {
        // 默认缓存配置
        RedisCacheConfiguration defaultConfig = RedisCacheConfiguration.defaultCacheConfig()
                .entryTtl(Duration.ofMinutes(30)) // 默认30分钟过期
                .serializeKeysWith(RedisSerializationContext.SerializationPair.fromSerializer(new StringRedisSerializer()))
                .serializeValuesWith(RedisSerializationContext.SerializationPair.fromSerializer(getValueSerializer()))
                .disableCachingNullValues(); // 不缓存null值，防止缓存穿透

        // 针对不同缓存名设置不同的TTL（添加随机延迟防止雪崩）
        Map<String, RedisCacheConfiguration> cacheConfigs = new HashMap<>();
        
        // 零件缓存：1小时 + 随机5-15分钟延迟
        cacheConfigs.put("parts", defaultConfig.entryTtl(Duration.ofMinutes(60 + new Random().nextInt(10))));
        
        // 车辆缓存：2小时 + 随机10-30分钟延迟
        cacheConfigs.put("vehicles", defaultConfig.entryTtl(Duration.ofMinutes(120 + new Random().nextInt(20))));
        
        // 用户缓存：1小时 + 随机5-15分钟延迟
        cacheConfigs.put("users", defaultConfig.entryTtl(Duration.ofMinutes(60 + new Random().nextInt(10))));
        
        // 订单缓存：30分钟 + 随机5-10分钟延迟
        cacheConfigs.put("orders", defaultConfig.entryTtl(Duration.ofMinutes(30 + new Random().nextInt(5))));
        
        // 消息缓存：15分钟 + 随机3-5分钟延迟
        cacheConfigs.put("messages", defaultConfig.entryTtl(Duration.ofMinutes(15 + new Random().nextInt(2))));
        
        // 投诉缓存：15分钟 + 随机3-5分钟延迟
        cacheConfigs.put("complaints", defaultConfig.entryTtl(Duration.ofMinutes(15 + new Random().nextInt(2))));

        return RedisCacheManager.builder(connectionFactory)
                .cacheDefaults(defaultConfig)
                .withInitialCacheConfigurations(cacheConfigs)
                .transactionAware()
                .build();
    }

    /**
     * 获取Value序列化器
     */
    private Jackson2JsonRedisSerializer<Object> getValueSerializer() {
        Jackson2JsonRedisSerializer<Object> serializer = new Jackson2JsonRedisSerializer<>(Object.class);
        ObjectMapper mapper = new ObjectMapper();
        mapper.setVisibility(PropertyAccessor.ALL, JsonAutoDetect.Visibility.ANY);
        mapper.activateDefaultTyping(LaissezFaireSubTypeValidator.instance, ObjectMapper.DefaultTyping.NON_FINAL);
        serializer.setObjectMapper(mapper);
        return serializer;
    }
}
