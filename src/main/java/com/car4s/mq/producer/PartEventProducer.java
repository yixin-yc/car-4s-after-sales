package com.car4s.mq.producer;

import com.car4s.config.RabbitMQConfig;
import com.car4s.mq.event.PartStockEvent;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.amqp.rabbit.core.RabbitTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

/**
 * 配件库存事件生产者
 * 负责发送库存变更和预警事件到RabbitMQ
 */
@Component
public class PartEventProducer {

    private static final Logger logger = LoggerFactory.getLogger(PartEventProducer.class);

    @Autowired
    private RabbitTemplate rabbitTemplate;

    /**
     * 发送库存更新事件
     */
    public void sendStockUpdated(PartStockEvent event) {
        event.setEventType("stock_updated");
        event.setDescription("配件库存已更新");
        sendMessage(RabbitMQConfig.PART_STOCK_UPDATED_KEY, event);
    }

    /**
     * 发送库存更新事件（简化版）
     */
    public void sendStockUpdated(Integer partId, String partNo, String partName, Integer currentStock) {
        PartStockEvent event = new PartStockEvent(partId, partNo, partName, currentStock);
        sendStockUpdated(event);
    }

    /**
     * 发送库存事件到交换机
     */
    private void sendMessage(String routingKey, PartStockEvent event) {
        try {
            rabbitTemplate.convertAndSend(RabbitMQConfig.PART_EXCHANGE, routingKey, event);
            logger.info("配件事件已发送: eventType={}, partId={}, partNo={}, currentStock={}",
                    event.getEventType(), event.getPartId(), event.getPartNo(), event.getCurrentStock());

            // 如果是低库存，额外记录警告日志
            if (event.isLowStock()) {
                logger.warn("⚠️ 配件库存预警: partNo='{}', partName='{}', 当前库存={}, 阈值={}",
                        event.getPartNo(), event.getPartName(), event.getCurrentStock(), event.getStockThreshold());
            }
        } catch (Exception e) {
            logger.error("配件事件发送失败: eventType={}, partId={}, error={}",
                    event.getEventType(), event.getPartId(), e.getMessage(), e);
        }
    }
}
