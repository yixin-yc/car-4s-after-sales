package com.car4s.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;

@Service
public class AsyncStatisticsService {

    @Autowired
    private OrderService orderService;

    @Async
    public void computeOrderStatistics() {
        int total = orderService.getAllOrders().size();
        int pending = orderService.getOrdersByStatus("pending").size();
        int processing = orderService.getOrdersByStatus("processing").size();
        int completed = orderService.getOrdersByStatus("completed").size();
        System.out.println("[AsyncStatistics] total=" + total + " pending=" + pending
                + " processing=" + processing + " completed=" + completed);
    }
}
