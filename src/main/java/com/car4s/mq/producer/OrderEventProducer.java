package com.car4s.mq.producer;

import com.car4s.config.RabbitMQConfig;
import com.car4s.mq.event.OrderEvent;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.amqp.rabbit.core.RabbitTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

/**
 * 订单事件生产者
 * 负责发送订单相关事件到RabbitMQ
 */
@Component
public class OrderEventProducer {

    private static final Logger logger = LoggerFactory.getLogger(OrderEventProducer.class);

    @Autowired
    private RabbitTemplate rabbitTemplate;

    /**
     * 发送订单创建事件
     */
    public void sendOrderCreated(OrderEvent event) {
        event.setEventType("created");
        event.setDescription("新订单已创建");
        sendMessage(RabbitMQConfig.ORDER_CREATED_KEY, event);
    }

    /**
     * 发送订单取消事件
     */
    public void sendOrderCancelled(OrderEvent event) {
        event.setEventType("cancelled");
        event.setDescription("订单已取消");
        sendMessage(RabbitMQConfig.ORDER_CANCELLED_KEY, event);
    }

    /**
     * 发送订单接受事件
     */
    public void sendOrderAccepted(OrderEvent event) {
        event.setEventType("accepted");
        event.setDescription("订单已被技师接受");
        sendMessage(RabbitMQConfig.ORDER_ACCEPTED_KEY, event);
    }

    /**
     * 发送订单完成事件
     */
    public void sendOrderCompleted(OrderEvent event) {
        event.setEventType("completed");
        event.setDescription("订单已完成");
        sendMessage(RabbitMQConfig.ORDER_COMPLETED_KEY, event);
    }

    /**
     * 发送订单事件到交换机
     */
    private void sendMessage(String routingKey, OrderEvent event) {
        try {
            rabbitTemplate.convertAndSend(RabbitMQConfig.ORDER_EXCHANGE, routingKey, event);
            logger.info("订单事件已发送: eventType={}, orderId={}, orderNo={}",
                    event.getEventType(), event.getOrderId(), event.getOrderNo());
        } catch (Exception e) {
            logger.error("订单事件发送失败: eventType={}, orderId={}, error={}",
                    event.getEventType(), event.getOrderId(), e.getMessage(), e);
        }
    }
}
