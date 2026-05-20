package com.car4s.mapper;

import com.car4s.model.Vehicle;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import java.util.List;

@Mapper
public interface VehicleMapper {
    Vehicle findById(@Param("id") Integer id);
    List<Vehicle> findByOwnerId(@Param("ownerId") Integer ownerId);
    List<Vehicle> findAll();
    void insert(Vehicle vehicle);
    void update(Vehicle vehicle);
    void delete(@Param("id") Integer id);
    Vehicle findByPlateNumber(@Param("plateNumber") String plateNumber);
}