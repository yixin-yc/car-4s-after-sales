package com.car4s.service;

import com.car4s.model.Message;
import com.car4s.mapper.MessageMapper;
import com.car4s.util.RedisUtil;
import com.car4s.mq.event.NotifyEvent;
import com.car4s.mq.producer.NotifyEventProducer;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.List;

@Service
public class MessageService {

    private static final Logger logger = LoggerFactory.getLogger(MessageService.class);

    /**
     * 消息缓存过期时间（秒）：15分钟
     */
    private static final long MESSAGE_CACHE_EXPIRE_TIME = 900;

    @Autowired
    private MessageMapper messageMapper;

    @Autowired
    private RedisUtil redisUtil;

    @Autowired
    private NotifyEventProducer notifyEventProducer;

    public List<Message> getMessagesByOwner(Integer ownerId) {
        return messageMapper.findByOwnerId(ownerId);
    }

    public List<Message> getAllMessages() {
        return messageMapper.findAll();
    }

    public List<Message> getUnrepliedMessages() {
        return messageMapper.findUnreplied();
    }

    /**
     * 根据ID查询消息
     * 使用Redis缓存，解决缓存穿透、击穿问题
     */
    public Message getMessageById(Integer id) {
        String cacheKey = "message:" + id;
        return redisUtil.getWithLock(
                cacheKey,
                Message.class,
                () -> messageMapper.findById(id),
                MESSAGE_CACHE_EXPIRE_TIME
        );
    }

    /**
     * 添加消息
     * 双写一致性：先写数据库，不缓存
     * MQ集成：发送消息创建事件，通知维修人员
     */
    public void addMessage(Message message) {
        message.setStatus(0);
        messageMapper.insert(message);
        logger.info("添加消息成功，title: {}", message.getTitle());

        // 发送消息创建事件到MQ
        NotifyEvent event = new NotifyEvent("message_created", message.getId(), message.getOwnerId(), message.getTitle());
        event.setContent(message.getContent());
        notifyEventProducer.sendMessageCreated(event);
    }

    /**
     * 更新消息
     * 双写一致性：先更新数据库，再删除缓存
     */
    public void updateMessage(Message message) {
        String cacheKey = "message:" + message.getId();
        redisUtil.updateWithCacheInvalidation(
                cacheKey,
                () -> messageMapper.update(message)
        );
    }

    /**
     * 删除消息
     * 双写一致性：先删除数据库，再删除缓存
     */
    public void deleteMessage(Integer id) {
        String cacheKey = "message:" + id;
        redisUtil.deleteWithCacheInvalidation(
                cacheKey,
                () -> messageMapper.delete(id)
        );
    }

    /**
     * 回复消息
     * 双写一致性：先更新数据库，再删除缓存
     */
    public void replyMessage(Integer id, String reply) {
        String cacheKey = "message:" + id;
        redisUtil.updateWithCacheInvalidation(
                cacheKey,
                () -> messageMapper.reply(id, reply)
        );
        logger.info("消息已回复，messageId: {}", id);
    }
}