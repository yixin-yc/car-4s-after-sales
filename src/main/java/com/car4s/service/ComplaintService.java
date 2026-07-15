package com.car4s.service;

import com.car4s.model.Complaint;
import com.car4s.mapper.ComplaintMapper;
import com.car4s.util.RedisUtil;
import com.car4s.mq.event.NotifyEvent;
import com.car4s.mq.producer.NotifyEventProducer;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.List;

@Service
public class ComplaintService {

    private static final Logger logger = LoggerFactory.getLogger(ComplaintService.class);

    /**
     * 投诉缓存过期时间（秒）：15分钟
     */
    private static final long COMPLAINT_CACHE_EXPIRE_TIME = 900;

    @Autowired
    private ComplaintMapper complaintMapper;

    @Autowired
    private RedisUtil redisUtil;

    @Autowired
    private NotifyEventProducer notifyEventProducer;

    public List<Complaint> getComplaintsByOwner(Integer ownerId) {
        return complaintMapper.findByOwnerId(ownerId);
    }

    public List<Complaint> getAllComplaints() {
        return complaintMapper.findAll();
    }

    public List<Complaint> getUnhandledComplaints() {
        return complaintMapper.findUnhandled();
    }

    /**
     * 根据ID查询投诉
     * 使用Redis缓存，解决缓存穿透、击穿问题
     */
    public Complaint getComplaintById(Integer id) {
        String cacheKey = "complaint:" + id;
        return redisUtil.getWithLock(
                cacheKey,
                Complaint.class,
                () -> complaintMapper.findById(id),
                COMPLAINT_CACHE_EXPIRE_TIME
        );
    }

    /**
     * 添加投诉
     * 双写一致性：先写数据库，不缓存
     * MQ集成：发送投诉创建事件，紧急通知管理员
     */
    public void addComplaint(Complaint complaint) {
        complaint.setStatus(0);
        complaintMapper.insert(complaint);
        logger.info("添加投诉成功，orderId: {}", complaint.getOrderId());

        // 发送投诉创建事件到MQ
        NotifyEvent event = new NotifyEvent("complaint_created", complaint.getId(), complaint.getOwnerId(), "新投诉 - 订单ID: " + complaint.getOrderId());
        event.setContent(complaint.getContent());
        notifyEventProducer.sendComplaintCreated(event);
    }

    /**
     * 更新投诉
     * 双写一致性：先更新数据库，再删除缓存
     */
    public void updateComplaint(Complaint complaint) {
        String cacheKey = "complaint:" + complaint.getId();
        redisUtil.updateWithCacheInvalidation(
                cacheKey,
                () -> complaintMapper.update(complaint)
        );
    }

    /**
     * 删除投诉
     * 双写一致性：先删除数据库，再删除缓存
     */
    public void deleteComplaint(Integer id) {
        String cacheKey = "complaint:" + id;
        redisUtil.deleteWithCacheInvalidation(
                cacheKey,
                () -> complaintMapper.delete(id)
        );
    }

    /**
     * 处理投诉
     * 双写一致性：先更新数据库，再删除缓存
     */
    public void handleComplaint(Integer id, String reply) {
        String cacheKey = "complaint:" + id;
        redisUtil.updateWithCacheInvalidation(
                cacheKey,
                () -> complaintMapper.handle(id, reply)
        );
        logger.info("投诉已处理，complaintId: {}", id);
    }
}