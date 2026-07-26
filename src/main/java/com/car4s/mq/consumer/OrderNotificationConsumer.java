package com.car4s.mq.consumer;

import com.car4s.config.RabbitMQConfig;
import com.car4s.mq.event.OrderEvent;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.amqp.rabbit.annotation.RabbitListener;
import org.springframework.stereotype.Component;

/**
 * 订单通知消费者
 * 处理订单状态变更通知
 */
@Component
public class OrderNotificationConsumer {

    private static final Logger logger = LoggerFactory.getLogger(OrderNotificationConsumer.class);

    /**
     * 处理订单创建事件
     */
    @RabbitListener(queues = RabbitMQConfig.ORDER_NOTIFICATION_QUEUE)
    public void handleOrderNotification(OrderEvent event) {
        try {
            logger.info("收到订单通知事件: eventType={}, orderId={}, orderNo={}",
                    event.getEventType(), event.getOrderId(), event.getOrderNo());

            switch (event.getEventType()) {
                case "created":
                    handleOrderCreated(event);
                    break;
                case "accepted":
                    handleOrderAccepted(event);
                    break;
                case "completed":
                    handleOrderCompleted(event);
                    break;
                case "cancelled":
                    handleOrderCancelled(event);
                    break;
                default:
                    logger.warn("未知的订单事件类型: {}", event.getEventType());
            }
        } catch (Exception e) {
            logger.error("处理订单通知失败: orderId={}, error={}",
                    event.getOrderId(), e.getMessage(), e);
            throw e; // 抛出异常触发重试机制
        }
    }

    /**
     * 处理订单创建通知
     * 实际业务：可以发送短信/邮件通知车主，或通知技师有新订单
     */
    private void handleOrderCreated(OrderEvent event) {
        logger.info("📋 [订单创建通知] 订单号: {}, 车主ID: {}, 服务类型: {}",
                event.getOrderNo(), event.getOwnerId(), event.getServiceType());
        // TODO: 实际业务逻辑 - 发送通知给车主确认订单已提交
        // 例如：sendSms(ownerPhone, "您的维修订单已提交成功，订单号：" + event.getOrderNo());
    }

    /**
     * 处理订单取消通知
     */
    private void handleOrderCancelled(OrderEvent event) {
        logger.info("❌ [订单取消通知] 订单号: {}, 车主ID: {}",
                event.getOrderNo(), event.getOwnerId());
        // TODO: 实际业务逻辑 - 通知技师订单已取消
    }

    /**
     * 处理订单接受通知
     * 实际业务：通知车主订单已被技师接受
     */
    private void handleOrderAccepted(OrderEvent event) {
        logger.info("🔧 [订单接受通知] 订单号: {}, 技师ID: {}",
                event.getOrderNo(), event.getMechanicId());
        // TODO: 实际业务逻辑 - 发送通知给车主
        // 例如：sendSms(ownerPhone, "您的订单已被技师接受，技师ID：" + event.getMechanicId());
    }

    /**
     * 处理订单完成通知
     * 实际业务：通知车主可以取车，并邀请评价
     */
    private void handleOrderCompleted(OrderEvent event) {
        logger.info("✅ [订单完成通知] 订单号: {}, 金额: {}",
                event.getOrderNo(), event.getAmount());
        // TODO: 实际业务逻辑 - 发送通知给车主
        // 例如：sendSms(ownerPhone, "您的车辆维修已完成，可以取车。请对本次服务进行评价。");
    }
}
