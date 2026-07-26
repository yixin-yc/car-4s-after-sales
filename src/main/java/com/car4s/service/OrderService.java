package com.car4s.service;

import com.car4s.model.ServiceOrder;
import com.car4s.model.Evaluation;
import com.car4s.mapper.OrderMapper;
import com.car4s.mapper.EvaluationMapper;
import com.car4s.util.RedisUtil;
import com.car4s.mq.event.OrderEvent;
import com.car4s.mq.producer.OrderEventProducer;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Date;
import java.math.BigDecimal;
import java.util.Calendar;

@Service
public class OrderService {

    private static final Logger logger = LoggerFactory.getLogger(OrderService.class);

    /**
     * 订单缓存过期时间（秒）：30分钟
     */
    private static final long ORDER_CACHE_EXPIRE_TIME = 1800;

    @Autowired
    private OrderMapper orderMapper;

    @Autowired
    private EvaluationMapper evaluationMapper;

    @Autowired
    private RedisUtil redisUtil;

    @Autowired
    private OrderEventProducer orderEventProducer;

    /**
     * 创建订单
     * 双写一致性：先写数据库，不缓存
     * MQ集成：发送订单创建事件
     */
    public void createOrder(ServiceOrder order) {
        order.setOrderNo("ORD" + System.currentTimeMillis());
        order.setStatus("pending");
        orderMapper.insert(order);
        logger.info("创建订单成功，orderNo: {}", order.getOrderNo());

        // 发送订单创建事件到MQ
        OrderEvent event = new OrderEvent("created", order.getId(), order.getOrderNo());
        event.setOwnerId(order.getOwnerId());
        event.setServiceType(order.getServiceType());
        event.setStatus("pending");
        orderEventProducer.sendOrderCreated(event);
    }

    /**
     * 根据ID查询订单
     * 使用Redis缓存，解决缓存穿透、击穿问题
     */
    public ServiceOrder getOrderById(Integer id) {
        String cacheKey = "order:" + id;
        return redisUtil.getWithLock(
                cacheKey,
                ServiceOrder.class,
                () -> orderMapper.findById(id),
                ORDER_CACHE_EXPIRE_TIME
        );
    }

    public List<ServiceOrder> getOrdersByOwner(Integer ownerId) {
        return orderMapper.findByOwnerId(ownerId);
    }

    public List<ServiceOrder> getOrdersByMechanic(Integer mechanicId) {
        return orderMapper.findByMechanicId(mechanicId);
    }

    public List<ServiceOrder> getAllOrders() {
        return orderMapper.findAll();
    }

    public List<ServiceOrder> getOrdersWithPage(int page, int pageSize) {
        int offset = (page - 1) * pageSize;
        return orderMapper.findAllWithPage(offset, pageSize);
    }

    public int getTotalOrderCount() {
        return orderMapper.countAll();
    }

    public List<ServiceOrder> getOrdersByStatus(String status) {
        return orderMapper.findByStatus(status);
    }

    /**
     * 更新订单
     * 双写一致性：先更新数据库，再删除缓存
     */
    public void updateOrder(ServiceOrder order) {
        String cacheKey = "order:" + order.getId();
        redisUtil.updateWithCacheInvalidation(
                cacheKey,
                () -> orderMapper.update(order)
        );
    }

    /**
     * 删除订单
     * 双写一致性：先删除数据库，再删除缓存
     */
    public void deleteOrder(Integer id) {
        String cacheKey = "order:" + id;
        redisUtil.deleteWithCacheInvalidation(
                cacheKey,
                () -> orderMapper.delete(id)
        );
    }

    public int getOrderCountByOwner(Integer ownerId) {
        return orderMapper.getOrderCountByOwner(ownerId);
    }

    public List<ServiceOrder> getRecentOrdersByOwner(Integer ownerId, Integer limit) {
        return orderMapper.getRecentOrdersByOwner(ownerId, limit);
    }

    /**
     * 接受订单
     * 双写一致性：先更新数据库，再删除缓存
     * MQ集成：发送订单接受事件
     */
    public void acceptOrder(Integer orderId, Integer mechanicId) {
        ServiceOrder order = orderMapper.findById(orderId);
        if (order != null) {
            order.setMechanicId(mechanicId);
            order.setStatus("processing");
            String cacheKey = "order:" + orderId;
            redisUtil.updateWithCacheInvalidation(
                    cacheKey,
                    () -> orderMapper.update(order)
            );
            logger.info("订单已接受，orderId: {}, mechanicId: {}", orderId, mechanicId);

            // 发送订单接受事件到MQ
            OrderEvent event = new OrderEvent("accepted", orderId, order.getOrderNo());
            event.setOwnerId(order.getOwnerId());
            event.setMechanicId(mechanicId);
            event.setStatus("processing");
            orderEventProducer.sendOrderAccepted(event);
        }
    }

    /**
     * 完成订单
     * 双写一致性：先更新数据库，再删除缓存
     * MQ集成：发送订单完成事件
     */
    public void completeOrder(Integer orderId) {
        ServiceOrder order = orderMapper.findById(orderId);
        if (order != null) {
            order.setStatus("completed");
            order.setCompleteTime(new Date());
            String cacheKey = "order:" + orderId;
            redisUtil.updateWithCacheInvalidation(
                    cacheKey,
                    () -> orderMapper.update(order)
            );
            logger.info("订单已完成，orderId: {}", orderId);

            // 发送订单完成事件到MQ
            OrderEvent event = new OrderEvent("completed", orderId, order.getOrderNo());
            event.setOwnerId(order.getOwnerId());
            event.setAmount(order.getAmount());
            event.setStatus("completed");
            orderEventProducer.sendOrderCompleted(event);
        }
    }

    public void addEvaluation(Evaluation evaluation) {
        evaluationMapper.insert(evaluation);
    }

    public int[] getMonthlyOrderCounts(int year) {
        int[] counts = new int[12];
        for (int i = 0; i < 12; i++) {
            counts[i] = orderMapper.countByMonth(year, i + 1);
        }
        return counts;
    }

    public BigDecimal getRevenueByDateRange(Date startDate, Date endDate) {
        return orderMapper.sumAmountByDateRange(startDate, endDate);
    }

    public Boolean cancelOrder(Integer orderId, Integer ownerId) {
        ServiceOrder order = orderMapper.findById(orderId);
        if (order == null) {
            logger.warn("取消订单失败，订单不存在，orderId: {}", orderId);
            return false;
        }
        if (!order.getStatus().equals("pending")) {
            logger.warn("取消订单失败，订单状态不是待处理，orderId: {}", orderId);
            return false;
        }
        if (!order.getOwnerId().equals(ownerId)) {
            logger.warn("取消订单失败，订单不属于当前用户，orderId: {}", orderId);
            return false;
        }

        String cacheKey = "order:" + orderId;
        redisUtil.updateWithCacheInvalidation(
                cacheKey,
                () -> orderMapper.cancelOrder(orderId)
        );
        logger.info("订单已取消，orderId: {}", orderId);

        OrderEvent event = new OrderEvent("cancelled", orderId, order.getOrderNo());
        event.setOwnerId(order.getOwnerId());
        event.setStatus("cancelled");
        orderEventProducer.sendOrderCancelled(event);
        return true;
    }
}