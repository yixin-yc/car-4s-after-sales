package com.car4s.mapper;

import com.car4s.model.Part;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import java.util.List;

@Mapper
public interface PartMapper {
    Part findById(@Param("id") Integer id);
    Part findByPartNo(@Param("partNo") String partNo);
    List<Part> findAll();  // 确保有这个方�?
    List<Part> findLowStock();
    void insert(Part part);
    void update(Part part);
    void delete(@Param("id") Integer id);
    void updateStock(@Param("id") Integer id, @Param("stock") Integer stock);
}