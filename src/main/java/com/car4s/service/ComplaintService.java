package com.car4s.service;

import com.car4s.model.Complaint;
import com.car4s.mapper.ComplaintMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.List;

@Service
public class ComplaintService {

    @Autowired
    private ComplaintMapper complaintMapper;

    public List<Complaint> getComplaintsByOwner(Integer ownerId) {
        return complaintMapper.findByOwnerId(ownerId);
    }

    public List<Complaint> getAllComplaints() {
        return complaintMapper.findAll();
    }

    public List<Complaint> getUnhandledComplaints() {
        return complaintMapper.findUnhandled();
    }

    public Complaint getComplaintById(Integer id) {
        return complaintMapper.findById(id);
    }

    public void addComplaint(Complaint complaint) {
        complaint.setStatus(0);
        complaintMapper.insert(complaint);
    }

    public void updateComplaint(Complaint complaint) {
        complaintMapper.update(complaint);
    }

    public void deleteComplaint(Integer id) {
        complaintMapper.delete(id);
    }

    public void handleComplaint(Integer id, String reply) {
        complaintMapper.handle(id, reply);
    }
}