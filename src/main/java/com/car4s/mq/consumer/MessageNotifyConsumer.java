package com.car4s.mq.consumer;

import com.car4s.config.RabbitMQConfig;
import com.car4s.mq.event.NotifyEvent;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.amqp.rabbit.annotation.RabbitListener;
import org.springframework.stereotype.Component;

/**
 * 消息通知消费者
 * 处理消息和投诉的通知
 */
@Component
public class MessageNotifyConsumer {

    private static final Logger logger = LoggerFactory.getLogger(MessageNotifyConsumer.class);

    /**
     * 处理消息通知
     */
    @RabbitListener(queues = RabbitMQConfig.MESSAGE_NOTIFY_QUEUE)
    public void handleMessageNotify(NotifyEvent event) {
        try {
            logger.info("收到消息通知事件: recordId={}, ownerId={}, title='{}'",
                    event.getRecordId(), event.getOwnerId(), event.getTitle());

            // 处理消息通知
            logger.info("📩 [新消息通知] 消息ID: {}, 车主ID: {}, 标题: '{}'",
                    event.getRecordId(), event.getOwnerId(), event.getTitle());

            // TODO: 实际业务逻辑
            // 1. 发送站内信通知维修人员
            // 2. 发送短信/邮件通知管理员
            // 3. 更新未读消息计数
        } catch (Exception e) {
            logger.error("处理消息通知失败: recordId={}, error={}",
                    event.getRecordId(), e.getMessage(), e);
            throw e;
        }
    }

    /**
     * 处理投诉通知
     */
    @RabbitListener(queues = RabbitMQConfig.COMPLAINT_NOTIFY_QUEUE)
    public void handleComplaintNotify(NotifyEvent event) {
        try {
            logger.info("收到投诉通知事件: recordId={}, ownerId={}, title='{}'",
                    event.getRecordId(), event.getOwnerId(), event.getTitle());

            // 处理投诉通知
            logger.warn("🚨 [新投诉通知] 投诉ID: {}, 车主ID: {}, 标题: '{}'",
                    event.getRecordId(), event.getOwnerId(), event.getTitle());

            // TODO: 实际业务逻辑
            // 1. 发送紧急通知给管理员
            // 2. 发送短信提醒
            // 3. 记录到投诉处理日志
        } catch (Exception e) {
            logger.error("处理投诉通知失败: recordId={}, error={}",
                    event.getRecordId(), e.getMessage(), e);
            throw e;
        }
    }
}
