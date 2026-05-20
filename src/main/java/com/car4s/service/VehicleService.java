package com.car4s.service;

import com.car4s.model.Vehicle;
import com.car4s.mapper.VehicleMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.stereotype.Service;
import java.util.List;

@Service
public class VehicleService {

    @Autowired
    private VehicleMapper vehicleMapper;

    public List<Vehicle> getVehiclesByOwner(Integer ownerId) {
        return vehicleMapper.findByOwnerId(ownerId);
    }

    @Cacheable(value = "vehicles", key = "#id", unless = "#result == null")
    public Vehicle getVehicleById(Integer id) {
        return vehicleMapper.findById(id);
    }

    public void addVehicle(Vehicle vehicle) {
        vehicle.setVehicleNo("V" + System.currentTimeMillis());
        vehicleMapper.insert(vehicle);
    }

    public void updateVehicle(Vehicle vehicle) {
        vehicleMapper.update(vehicle);
    }

    public void deleteVehicle(Integer id) {
        vehicleMapper.delete(id);
    }

    public List<Vehicle> getAllVehicles() {
        return vehicleMapper.findAll();
    }

    public Vehicle findByPlateNumber(String plateNumber) {
        return vehicleMapper.findByPlateNumber(plateNumber);
    }
}