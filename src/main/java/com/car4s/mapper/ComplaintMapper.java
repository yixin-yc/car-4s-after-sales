package com.car4s.mapper;

import com.car4s.model.Complaint;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import java.util.List;

@Mapper
public interface ComplaintMapper {
    Complaint findById(@Param("id") Integer id);
    List<Complaint> findByOwnerId(@Param("ownerId") Integer ownerId);
    List<Complaint> findAll();
    List<Complaint> findUnhandled();
    void insert(Complaint complaint);
    void update(Complaint complaint);
    void delete(@Param("id") Integer id);
    void handle(@Param("id") Integer id, @Param("reply") String reply);
}