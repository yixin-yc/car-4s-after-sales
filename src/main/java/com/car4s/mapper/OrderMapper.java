package com.car4s.mapper;

import com.car4s.model.Part;
import com.car4s.model.ServiceOrder;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import java.util.List;

@Mapper
public interface OrderMapper {
    ServiceOrder findById(@Param("id") Integer id);
    ServiceOrder findByOrderNo(@Param("orderNo") String orderNo);
    List<ServiceOrder> findByOwnerId(@Param("ownerId") Integer ownerId);
    List<ServiceOrder> findByMechanicId(@Param("mechanicId") Integer mechanicId);
    List<ServiceOrder> findAll();
    List<ServiceOrder> findByStatus(@Param("status") String status);
    void insert(ServiceOrder order);
    void update(ServiceOrder order);
    void delete(@Param("id") Integer id);
    int getOrderCountByOwner(@Param("ownerId") Integer ownerId);
    List<ServiceOrder> getRecentOrdersByOwner(@Param("ownerId") Integer ownerId, @Param("limit") Integer limit);
    List<Part> findPartsByIds(@Param("ids") List<Integer> ids);
}