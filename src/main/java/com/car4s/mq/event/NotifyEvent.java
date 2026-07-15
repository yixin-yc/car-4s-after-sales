package com.car4s.mq.event;

import java.io.Serializable;
import java.util.Date;

/**
 * 消息通知事件
 * 用于RabbitMQ传递消息/投诉通知
 */
public class NotifyEvent implements Serializable {

    private static final long serialVersionUID = 1L;

    /**
     * 事件类型：message_created/complaint_created
     */
    private String eventType;

    /**
     * 记录ID（消息ID或投诉ID）
     */
    private Integer recordId;

    /**
     * 车主ID
     */
    private Integer ownerId;

    /**
     * 标题
     */
    private String title;

    /**
     * 内容
     */
    private String content;

    /**
     * 事件时间
     */
    private Date eventTime;

    public NotifyEvent() {
        this.eventTime = new Date();
    }

    public NotifyEvent(String eventType, Integer recordId, Integer ownerId, String title) {
        this.eventType = eventType;
        this.recordId = recordId;
        this.ownerId = ownerId;
        this.title = title;
        this.eventTime = new Date();
    }

    // Getters and Setters
    public String getEventType() {
        return eventType;
    }

    public void setEventType(String eventType) {
        this.eventType = eventType;
    }

    public Integer getRecordId() {
        return recordId;
    }

    public void setRecordId(Integer recordId) {
        this.recordId = recordId;
    }

    public Integer getOwnerId() {
        return ownerId;
    }

    public void setOwnerId(Integer ownerId) {
        this.ownerId = ownerId;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public Date getEventTime() {
        return eventTime;
    }

    public void setEventTime(Date eventTime) {
        this.eventTime = eventTime;
    }

    @Override
    public String toString() {
        return "NotifyEvent{" +
                "eventType='" + eventType + '\'' +
                ", recordId=" + recordId +
                ", ownerId=" + ownerId +
                ", title='" + title + '\'' +
                ", eventTime=" + eventTime +
                '}';
    }
}
