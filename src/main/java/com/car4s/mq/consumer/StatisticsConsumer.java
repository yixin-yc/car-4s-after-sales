package com.car4s.mq.consumer;

import com.car4s.config.RabbitMQConfig;
import com.car4s.mq.event.OrderEvent;
import com.car4s.service.OrderService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.amqp.rabbit.annotation.RabbitListener;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

/**
 * 订单统计消费者
 * 异步处理订单统计，替代原有的@Async方式
 */
@Component
public class StatisticsConsumer {

    private static final Logger logger = LoggerFactory.getLogger(StatisticsConsumer.class);

    @Autowired
    private OrderService orderService;

    /**
     * 处理订单统计事件
     * 监听所有订单事件（order.*），异步更新统计数据
     */
    @RabbitListener(queues = RabbitMQConfig.ORDER_STATISTICS_QUEUE)
    public void handleOrderStatistics(OrderEvent event) {
        try {
            logger.info("收到订单统计事件: eventType={}, orderId={}",
                    event.getEventType(), event.getOrderId());

            // 异步计算订单统计数据
            computeStatistics(event);

        } catch (Exception e) {
            logger.error("处理订单统计失败: orderId={}, error={}",
                    event.getOrderId(), e.getMessage(), e);
            throw e;
        }
    }

    /**
     * 计算并记录统计数据
     */
    private void computeStatistics(OrderEvent event) {
        // 获取订单统计信息
        int total = orderService.getAllOrders().size();
        int pending = orderService.getOrdersByStatus("pending").size();
        int processing = orderService.getOrdersByStatus("processing").size();
        int completed = orderService.getOrdersByStatus("completed").size();

        logger.info("📊 [订单统计] 触发事件: {}, 总数: {}, 待处理: {}, 处理中: {}, 已完成: {}",
                event.getEventType(), total, pending, processing, completed);

        // TODO: 实际业务逻辑
        // 1. 将统计数据写入Redis缓存
        // 2. 或写入统计日志表
        // 3. 或更新仪表盘数据
    }
}
