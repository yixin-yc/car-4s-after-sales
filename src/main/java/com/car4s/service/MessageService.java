package com.car4s.service;

import com.car4s.model.Message;
import com.car4s.mapper.MessageMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.List;

@Service
public class MessageService {

    @Autowired
    private MessageMapper messageMapper;

    public List<Message> getMessagesByOwner(Integer ownerId) {
        return messageMapper.findByOwnerId(ownerId);
    }

    public List<Message> getAllMessages() {
        return messageMapper.findAll();
    }

    public List<Message> getUnrepliedMessages() {
        return messageMapper.findUnreplied();
    }

    public Message getMessageById(Integer id) {
        return messageMapper.findById(id);
    }

    public void addMessage(Message message) {
        message.setStatus(0);
        messageMapper.insert(message);
    }

    public void updateMessage(Message message) {
        messageMapper.update(message);
    }

    public void deleteMessage(Integer id) {
        messageMapper.delete(id);
    }

    public void replyMessage(Integer id, String reply) {
        messageMapper.reply(id, reply);
    }
}