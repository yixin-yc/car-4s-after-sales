package com.car4s.service;

import com.car4s.model.Vehicle;
import com.car4s.mapper.VehicleMapper;
import com.car4s.util.RedisUtil;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.List;

@Service
public class VehicleService {

    private static final Logger logger = LoggerFactory.getLogger(VehicleService.class);

    /**
     * 车辆缓存过期时间（秒）：2小时
     */
    private static final long VEHICLE_CACHE_EXPIRE_TIME = 7200;

    @Autowired
    private VehicleMapper vehicleMapper;

    @Autowired
    private RedisUtil redisUtil;

    public List<Vehicle> getVehiclesByOwner(Integer ownerId) {
        return vehicleMapper.findByOwnerId(ownerId);
    }

    /**
     * 根据ID查询车辆
     * 使用Redis缓存，解决缓存穿透、击穿问题
     */
    public Vehicle getVehicleById(Integer id) {
        String cacheKey = "vehicle:" + id;
        return redisUtil.getWithLock(
                cacheKey,
                Vehicle.class,
                () -> vehicleMapper.findById(id),
                VEHICLE_CACHE_EXPIRE_TIME
        );
    }

    /**
     * 添加车辆
     * 双写一致性：先写数据库，不缓存
     */
    public void addVehicle(Vehicle vehicle) {
        vehicle.setVehicleNo("V" + System.currentTimeMillis());
        vehicleMapper.insert(vehicle);
        logger.info("添加车辆成功，vehicleNo: {}", vehicle.getVehicleNo());
    }

    /**
     * 更新车辆
     * 双写一致性：先更新数据库，再删除缓存
     */
    public void updateVehicle(Vehicle vehicle) {
        String cacheKey = "vehicle:" + vehicle.getId();
        redisUtil.updateWithCacheInvalidation(
                cacheKey,
                () -> vehicleMapper.update(vehicle)
        );
    }

    /**
     * 删除车辆
     * 双写一致性：先删除数据库，再删除缓存
     */
    public void deleteVehicle(Integer id) {
        String cacheKey = "vehicle:" + id;
        redisUtil.deleteWithCacheInvalidation(
                cacheKey,
                () -> vehicleMapper.delete(id)
        );
    }

    public List<Vehicle> getAllVehicles() {
        return vehicleMapper.findAll();
    }

    public Vehicle findByPlateNumber(String plateNumber) {
        return vehicleMapper.findByPlateNumber(plateNumber);
    }
}