package com.car4s.service;

import com.car4s.model.Part;
import com.car4s.mapper.PartMapper;
import com.car4s.util.RedisUtil;
import com.car4s.mq.producer.PartEventProducer;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cache.annotation.CacheEvict;
import org.springframework.cache.annotation.CachePut;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.stereotype.Service;
import java.util.List;

@Service
public class PartService {

    private static final Logger logger = LoggerFactory.getLogger(PartService.class);

    /**
     * 零件缓存过期时间（秒）：1小时
     */
    private static final long PART_CACHE_EXPIRE_TIME = 3600;

    @Autowired
    private PartMapper partMapper;

    @Autowired
    private RedisUtil redisUtil;

    @Autowired
    private PartEventProducer partEventProducer;

    public List<Part> getAllParts() {
        return partMapper.findAll();
    }

    /**
     * 根据ID查询零件
     * 使用Redis缓存，解决缓存穿透、击穿问题
     */
    public Part getPartById(Integer id) {
        String cacheKey = "part:" + id;
        return redisUtil.getWithLock(
                cacheKey,
                Part.class,
                () -> partMapper.findById(id),
                PART_CACHE_EXPIRE_TIME
        );
    }

    public Part getPartByNo(String partNo) {
        return partMapper.findByPartNo(partNo);
    }

    /**
     * 添加零件
     * 双写一致性：先写数据库，不缓存（避免脏数据）
     */
    public void addPart(Part part) {
        partMapper.insert(part);
        logger.info("添加零件成功，partNo: {}", part.getPartNo());
    }

    /**
     * 更新零件
     * 双写一致性：先更新数据库，再删除缓存（Cache-Aside模式）
     */
    public void updatePart(Part part) {
        String cacheKey = "part:" + part.getId();
        redisUtil.updateWithCacheInvalidation(
                cacheKey,
                () -> partMapper.update(part)
        );
    }

    /**
     * 删除零件
     * 双写一致性：先删除数据库，再删除缓存
     */
    public void deletePart(Integer id) {
        String cacheKey = "part:" + id;
        redisUtil.deleteWithCacheInvalidation(
                cacheKey,
                () -> partMapper.delete(id)
        );
    }

    public List<Part> getLowStockParts() {
        return partMapper.findLowStock();
    }

    /**
     * 更新库存
     * 双写一致性：先更新数据库，再删除缓存
     * MQ集成：发送库存更新事件，触发库存预警检查
     */
    public void updateStock(Integer id, Integer stock) {
        String cacheKey = "part:" + id;
        redisUtil.updateWithCacheInvalidation(
                cacheKey,
                () -> partMapper.updateStock(id, stock)
        );

        // 发送库存更新事件到MQ，触发库存预警检查
        Part part = partMapper.findById(id);
        if (part != null) {
            partEventProducer.sendStockUpdated(id, part.getPartNo(), part.getPartName(), stock);
        }
    }
}