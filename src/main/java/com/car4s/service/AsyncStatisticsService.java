package com.car4s.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;

/**
 * 异步统计服务
 * 注意：此服务已被 RabbitMQ 的 StatisticsConsumer 替代
 * 保留此类用于向后兼容，但建议使用 MQ 消费者进行异步统计
 *
 * @deprecated 使用 {@link com.car4s.mq.consumer.StatisticsConsumer} 替代
 */
@Service
@Deprecated
public class AsyncStatisticsService {

    @Autowired
    private OrderService orderService;

    /**
     * 计算订单统计数据
     * @deprecated 已被 RabbitMQ StatisticsConsumer 替代，建议使用 MQ 异步处理
     */
    @Async
    @Deprecated
    public void computeOrderStatistics() {
        int total = orderService.getAllOrders().size();
        int pending = orderService.getOrdersByStatus("pending").size();
        int processing = orderService.getOrdersByStatus("processing").size();
        int completed = orderService.getOrdersByStatus("completed").size();
        System.out.println("[AsyncStatistics] total=" + total + " pending=" + pending
                + " processing=" + processing + " completed=" + completed);
        System.out.println("[AsyncStatistics] 提示：此方法已被 RabbitMQ StatisticsConsumer 替代");
    }
}
