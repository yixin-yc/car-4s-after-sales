package com.car4s.mq.event;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Date;

/**
 * 订单事件消息
 * 用于RabbitMQ传递订单状态变更信息
 */
public class OrderEvent implements Serializable {

    private static final long serialVersionUID = 1L;

    /**
     * 事件类型：created/accepted/completed
     */
    private String eventType;

    /**
     * 订单ID
     */
    private Integer orderId;

    /**
     * 订单编号
     */
    private String orderNo;

    /**
     * 车主ID
     */
    private Integer ownerId;

    /**
     * 技师ID
     */
    private Integer mechanicId;

    /**
     * 订单状态
     */
    private String status;

    /**
     * 服务类型
     */
    private String serviceType;

    /**
     * 订单金额
     */
    private BigDecimal amount;

    /**
     * 事件时间
     */
    private Date eventTime;

    /**
     * 事件描述
     */
    private String description;

    public OrderEvent() {
        this.eventTime = new Date();
    }

    public OrderEvent(String eventType, Integer orderId, String orderNo) {
        this.eventType = eventType;
        this.orderId = orderId;
        this.orderNo = orderNo;
        this.eventTime = new Date();
    }

    // Getters and Setters
    public String getEventType() {
        return eventType;
    }

    public void setEventType(String eventType) {
        this.eventType = eventType;
    }

    public Integer getOrderId() {
        return orderId;
    }

    public void setOrderId(Integer orderId) {
        this.orderId = orderId;
    }

    public String getOrderNo() {
        return orderNo;
    }

    public void setOrderNo(String orderNo) {
        this.orderNo = orderNo;
    }

    public Integer getOwnerId() {
        return ownerId;
    }

    public void setOwnerId(Integer ownerId) {
        this.ownerId = ownerId;
    }

    public Integer getMechanicId() {
        return mechanicId;
    }

    public void setMechanicId(Integer mechanicId) {
        this.mechanicId = mechanicId;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getServiceType() {
        return serviceType;
    }

    public void setServiceType(String serviceType) {
        this.serviceType = serviceType;
    }

    public BigDecimal getAmount() {
        return amount;
    }

    public void setAmount(BigDecimal amount) {
        this.amount = amount;
    }

    public Date getEventTime() {
        return eventTime;
    }

    public void setEventTime(Date eventTime) {
        this.eventTime = eventTime;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    @Override
    public String toString() {
        return "OrderEvent{" +
                "eventType='" + eventType + '\'' +
                ", orderId=" + orderId +
                ", orderNo='" + orderNo + '\'' +
                ", status='" + status + '\'' +
                ", eventTime=" + eventTime +
                '}';
    }
}
