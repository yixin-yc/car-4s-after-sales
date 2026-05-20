package com.car4s.mapper;

import com.car4s.model.Evaluation;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import java.util.List;

@Mapper
public interface EvaluationMapper {
    Evaluation findById(@Param("id") Integer id);
    Evaluation findByOrderId(@Param("orderId") Integer orderId);
    List<Evaluation> findByOwnerId(@Param("ownerId") Integer ownerId);
    List<Evaluation> findAll();
    void insert(Evaluation evaluation);
    void update(Evaluation evaluation);
    void delete(@Param("id") Integer id);
    Double getAverageRatingByMechanic(@Param("mechanicId") Integer mechanicId);
}