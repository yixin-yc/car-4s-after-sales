package com.car4s.service;

import com.car4s.model.ServiceOrder;
import com.car4s.model.Evaluation;
import com.car4s.mapper.OrderMapper;
import com.car4s.mapper.EvaluationMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.List;
import java.util.Date;

@Service
public class OrderService {

    @Autowired
    private OrderMapper orderMapper;

    @Autowired
    private EvaluationMapper evaluationMapper;

    public void createOrder(ServiceOrder order) {
        order.setOrderNo("ORD" + System.currentTimeMillis());
        order.setStatus("pending");
        orderMapper.insert(order);
    }

    public ServiceOrder getOrderById(Integer id) {
        return orderMapper.findById(id);
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

    public void updateOrder(ServiceOrder order) {
        orderMapper.update(order);
    }

    public void deleteOrder(Integer id) {
        orderMapper.delete(id);
    }

    public int getOrderCountByOwner(Integer ownerId) {
        return orderMapper.getOrderCountByOwner(ownerId);
    }

    public List<ServiceOrder> getRecentOrdersByOwner(Integer ownerId, Integer limit) {
        return orderMapper.getRecentOrdersByOwner(ownerId, limit);
    }

    public void acceptOrder(Integer orderId, Integer mechanicId) {
        ServiceOrder order = orderMapper.findById(orderId);
        if (order != null) {
            order.setMechanicId(mechanicId);
            order.setStatus("processing");
            orderMapper.update(order);
        }
    }

    public void completeOrder(Integer orderId) {
        ServiceOrder order = orderMapper.findById(orderId);
        if (order != null) {
            order.setStatus("completed");
            order.setCompleteTime(new Date());
            orderMapper.update(order);
        }
    }

    public void addEvaluation(Evaluation evaluation) {
        evaluationMapper.insert(evaluation);
    }
}