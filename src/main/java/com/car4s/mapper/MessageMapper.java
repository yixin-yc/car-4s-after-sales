package com.car4s.mapper;

import com.car4s.model.Message;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import java.util.List;

@Mapper
public interface MessageMapper {
    Message findById(@Param("id") Integer id);
    List<Message> findByOwnerId(@Param("ownerId") Integer ownerId);
    List<Message> findAll();
    List<Message> findUnreplied();
    void insert(Message message);
    void update(Message message);
    void delete(@Param("id") Integer id);
    void reply(@Param("id") Integer id, @Param("reply") String reply);
}