package com.car4s.mq.event;

import java.io.Serializable;

/**
 * 配件库存事件消息
 * 用于RabbitMQ传递库存变更信息
 */
public class PartStockEvent implements Serializable {

    private static final long serialVersionUID = 1L;

    /**
     * 配件ID
     */
    private Integer partId;

    /**
     * 配件编号
     */
    private String partNo;

    /**
     * 配件名称
     */
    private String partName;

    /**
     * 当前库存
     */
    private Integer currentStock;

    /**
     * 库存阈值（低于此值触发预警）
     */
    private Integer stockThreshold;

    /**
     * 事件类型：stock_updated/low_stock
     */
    private String eventType;

    /**
     * 事件描述
     */
    private String description;

    public PartStockEvent() {
    }

    public PartStockEvent(Integer partId, String partNo, String partName, Integer currentStock) {
        this.partId = partId;
        this.partNo = partNo;
        this.partName = partName;
        this.currentStock = currentStock;
        this.stockThreshold = 10; // 默认阈值
    }

    /**
     * 判断是否为低库存
     */
    public boolean isLowStock() {
        return currentStock != null && stockThreshold != null && currentStock <= stockThreshold;
    }

    // Getters and Setters
    public Integer getPartId() {
        return partId;
    }

    public void setPartId(Integer partId) {
        this.partId = partId;
    }

    public String getPartNo() {
        return partNo;
    }

    public void setPartNo(String partNo) {
        this.partNo = partNo;
    }

    public String getPartName() {
        return partName;
    }

    public void setPartName(String partName) {
        this.partName = partName;
    }

    public Integer getCurrentStock() {
        return currentStock;
    }

    public void setCurrentStock(Integer currentStock) {
        this.currentStock = currentStock;
    }

    public Integer getStockThreshold() {
        return stockThreshold;
    }

    public void setStockThreshold(Integer stockThreshold) {
        this.stockThreshold = stockThreshold;
    }

    public String getEventType() {
        return eventType;
    }

    public void setEventType(String eventType) {
        this.eventType = eventType;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    @Override
    public String toString() {
        return "PartStockEvent{" +
                "partId=" + partId +
                ", partNo='" + partNo + '\'' +
                ", partName='" + partName + '\'' +
                ", currentStock=" + currentStock +
                ", stockThreshold=" + stockThreshold +
                ", eventType='" + eventType + '\'' +
                '}';
    }
}
