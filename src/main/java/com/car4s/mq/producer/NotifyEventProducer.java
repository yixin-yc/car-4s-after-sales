package com.car4s.mq.producer;

import com.car4s.config.RabbitMQConfig;
import com.car4s.mq.event.NotifyEvent;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.amqp.rabbit.core.RabbitTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

/**
 * 消息通知生产者
 * 负责发送消息/投诉通知事件到RabbitMQ
 */
@Component
public class NotifyEventProducer {

    private static final Logger logger = LoggerFactory.getLogger(NotifyEventProducer.class);

    @Autowired
    private RabbitTemplate rabbitTemplate;

    /**
     * 发送新消息通知
     */
    public void sendMessageCreated(NotifyEvent event) {
        event.setEventType("message_created");
        sendMessage(RabbitMQConfig.MESSAGE_EXCHANGE, RabbitMQConfig.MESSAGE_CREATED_KEY, event);
    }

    /**
     * 发送新投诉通知
     */
    public void sendComplaintCreated(NotifyEvent event) {
        event.setEventType("complaint_created");
        sendMessage(RabbitMQConfig.MESSAGE_EXCHANGE, RabbitMQConfig.COMPLAINT_CREATED_KEY, event);
    }

    /**
     * 发送通知事件到交换机
     */
    private void sendMessage(String exchange, String routingKey, NotifyEvent event) {
        try {
            rabbitTemplate.convertAndSend(exchange, routingKey, event);
            logger.info("通知事件已发送: eventType={}, recordId={}, ownerId={}, title='{}'",
                    event.getEventType(), event.getRecordId(), event.getOwnerId(), event.getTitle());
        } catch (Exception e) {
            logger.error("通知事件发送失败: eventType={}, recordId={}, error={}",
                    event.getEventType(), event.getRecordId(), e.getMessage(), e);
        }
    }
}
