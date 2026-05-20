package com.car4s.service;

import com.car4s.model.Part;
import com.car4s.mapper.PartMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.List;

@Service
public class PartService {

    @Autowired
    private PartMapper partMapper;

    public List<Part> getAllParts() {
        return partMapper.findAll();
    }

    public Part getPartById(Integer id) {
        return partMapper.findById(id);
    }

    public Part getPartByNo(String partNo) {
        return partMapper.findByPartNo(partNo);
    }

    public void addPart(Part part) {
        partMapper.insert(part);
    }

    public void updatePart(Part part) {
        partMapper.update(part);
    }

    public void deletePart(Integer id) {
        partMapper.delete(id);
    }

    public List<Part> getLowStockParts() {
        return partMapper.findLowStock();
    }

    public void updateStock(Integer id, Integer stock) {
        partMapper.updateStock(id, stock);
    }
}