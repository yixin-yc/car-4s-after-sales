package com.car4s.config;

import org.springframework.amqp.core.*;
import org.springframework.amqp.support.converter.Jackson2JsonMessageConverter;
import org.springframework.amqp.support.converter.MessageConverter;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

/**
 * RabbitMQ配置类
 * 定义交换机、队列、绑定关系
 */
@Configuration
public class RabbitMQConfig {

    // ==================== 交换机定义 ====================

    /**
     * 订单交换机（Topic类型）
     */
    public static final String ORDER_EXCHANGE = "order.exchange";

    /**
     * 配件交换机（Topic类型）
     */
    public static final String PART_EXCHANGE = "part.exchange";

    /**
     * 消息通知交换机（Topic类型）
     */
    public static final String MESSAGE_EXCHANGE = "message.exchange";

    /**
     * 统计交换机（Direct类型）
     */
    public static final String STATISTICS_EXCHANGE = "statistics.exchange";

    // ==================== 队列定义 ====================

    /**
     * 订单通知队列
     */
    public static final String ORDER_NOTIFICATION_QUEUE = "order.notification.queue";

    /**
     * 订单统计队列
     */
    public static final String ORDER_STATISTICS_QUEUE = "order.statistics.queue";

    /**
     * 库存预警队列
     */
    public static final String PART_STOCK_ALERT_QUEUE = "part.stock.alert.queue";

    /**
     * 消息通知队列
     */
    public static final String MESSAGE_NOTIFY_QUEUE = "message.notify.queue";

    /**
     * 投诉通知队列
     */
    public static final String COMPLAINT_NOTIFY_QUEUE = "complaint.notify.queue";

    // ==================== Routing Key定义 ====================

    /**
     * 订单创建
     */
    public static final String ORDER_CREATED_KEY = "order.created";

    /**
     * 订单接受
     */
    public static final String ORDER_ACCEPTED_KEY = "order.accepted";

    /**
     * 订单完成
     */
    public static final String ORDER_COMPLETED_KEY = "order.completed";

    /**
     * 库存更新
     */
    public static final String PART_STOCK_UPDATED_KEY = "part.stock.updated";

    /**
     * 消息创建
     */
    public static final String MESSAGE_CREATED_KEY = "message.created";

    /**
     * 投诉创建
     */
    public static final String COMPLAINT_CREATED_KEY = "complaint.created";

    // ==================== Bean定义 ====================

    /**
     * JSON消息转换器
     */
    @Bean
    public MessageConverter jsonMessageConverter() {
        return new Jackson2JsonMessageConverter();
    }

    // ---------- 订单相关 ----------

    @Bean
    public TopicExchange orderExchange() {
        return new TopicExchange(ORDER_EXCHANGE, true, false);
    }

    @Bean
    public Queue orderNotificationQueue() {
        return QueueBuilder.durable(ORDER_NOTIFICATION_QUEUE).build();
    }

    @Bean
    public Queue orderStatisticsQueue() {
        return QueueBuilder.durable(ORDER_STATISTICS_QUEUE).build();
    }

    @Bean
    public Binding orderCreatedBinding(Queue orderNotificationQueue, TopicExchange orderExchange) {
        return BindingBuilder.bind(orderNotificationQueue).to(orderExchange).with(ORDER_CREATED_KEY);
    }

    @Bean
    public Binding orderAcceptedBinding(Queue orderNotificationQueue, TopicExchange orderExchange) {
        return BindingBuilder.bind(orderNotificationQueue).to(orderExchange).with(ORDER_ACCEPTED_KEY);
    }

    @Bean
    public Binding orderCompletedBinding(Queue orderNotificationQueue, TopicExchange orderExchange) {
        return BindingBuilder.bind(orderNotificationQueue).to(orderExchange).with(ORDER_COMPLETED_KEY);
    }

    @Bean
    public Binding orderStatisticsBinding(Queue orderStatisticsQueue, TopicExchange orderExchange) {
        return BindingBuilder.bind(orderStatisticsQueue).to(orderExchange).with("order.*");
    }

    // ---------- 配件相关 ----------

    @Bean
    public TopicExchange partExchange() {
        return new TopicExchange(PART_EXCHANGE, true, false);
    }

    @Bean
    public Queue partStockAlertQueue() {
        return QueueBuilder.durable(PART_STOCK_ALERT_QUEUE).build();
    }

    @Bean
    public Binding partStockAlertBinding(Queue partStockAlertQueue, TopicExchange partExchange) {
        return BindingBuilder.bind(partStockAlertQueue).to(partExchange).with(PART_STOCK_UPDATED_KEY);
    }

    // ---------- 消息通知相关 ----------

    @Bean
    public TopicExchange messageExchange() {
        return new TopicExchange(MESSAGE_EXCHANGE, true, false);
    }

    @Bean
    public Queue messageNotifyQueue() {
        return QueueBuilder.durable(MESSAGE_NOTIFY_QUEUE).build();
    }

    @Bean
    public Queue complaintNotifyQueue() {
        return QueueBuilder.durable(COMPLAINT_NOTIFY_QUEUE).build();
    }

    @Bean
    public Binding messageNotifyBinding(Queue messageNotifyQueue, TopicExchange messageExchange) {
        return BindingBuilder.bind(messageNotifyQueue).to(messageExchange).with(MESSAGE_CREATED_KEY);
    }

    @Bean
    public Binding complaintNotifyBinding(Queue complaintNotifyQueue, TopicExchange messageExchange) {
        return BindingBuilder.bind(complaintNotifyQueue).to(messageExchange).with(COMPLAINT_CREATED_KEY);
    }
}
