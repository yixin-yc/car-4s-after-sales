package com.car4s.mq.consumer;

import com.car4s.config.RabbitMQConfig;
import com.car4s.mq.event.PartStockEvent;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.amqp.rabbit.annotation.RabbitListener;
import org.springframework.stereotype.Component;

/**
 * 配件库存预警消费者
 * 处理库存变更和预警通知
 */
@Component
public class PartStockAlertConsumer {

    private static final Logger logger = LoggerFactory.getLogger(PartStockAlertConsumer.class);

    /**
     * 处理库存更新事件
     */
    @RabbitListener(queues = RabbitMQConfig.PART_STOCK_ALERT_QUEUE)
    public void handleStockAlert(PartStockEvent event) {
        try {
            logger.info("收到库存更新事件: partId={}, partNo={}, currentStock={}",
                    event.getPartId(), event.getPartNo(), event.getCurrentStock());

            // 检查是否为低库存
            if (event.isLowStock()) {
                handleLowStock(event);
            } else {
                handleNormalStock(event);
            }
        } catch (Exception e) {
            logger.error("处理库存预警失败: partId={}, error={}",
                    event.getPartId(), e.getMessage(), e);
            throw e;
        }
    }

    /**
     * 处理低库存预警
     */
    private void handleLowStock(PartStockEvent event) {
        logger.warn("⚠️ [库存预警] 配件编号: {}, 配件名称: {}, 当前库存: {}, 阈值: {}",
                event.getPartNo(), event.getPartName(),
                event.getCurrentStock(), event.getStockThreshold());

        // TODO: 实际业务逻辑
        // 1. 发送采购提醒给管理员
        // 2. 记录到预警日志表
        // 3. 发送钉钉/企业微信通知
        // 例如：sendAlert(admin, "配件 " + event.getPartName() + " 库存不足，请及时采购！");
    }

    /**
     * 处理正常库存更新
     */
    private void handleNormalStock(PartStockEvent event) {
        logger.info("📦 [库存更新] 配件编号: {}, 配件名称: {}, 当前库存: {}",
                event.getPartNo(), event.getPartName(), event.getCurrentStock());
        // 正常库存更新，记录日志即可
    }
}
