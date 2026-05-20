package com.car4s.controller;

import com.car4s.model.*;
import com.car4s.service.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;
import java.util.List;

@Controller
@RequestMapping("/owner")
public class OwnerController {

    @Autowired
    private VehicleService vehicleService;

    @Autowired
    private OrderService orderService;

    @Autowired
    private MessageService messageService;

    @Autowired
    private ComplaintService complaintService;

    @GetMapping("/dashboard")
    public String dashboard(HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        List<Vehicle> vehicles = vehicleService.getVehiclesByOwner(user.getId());
        List<ServiceOrder> recentOrders = orderService.getRecentOrdersByOwner(user.getId(), 5);

        model.addAttribute("vehicles", vehicles);
        model.addAttribute("recentOrders", recentOrders);
        model.addAttribute("vehicleCount", vehicles.size());
        model.addAttribute("orderCount", orderService.getOrderCountByOwner(user.getId()));

        return "owner/dashboard";
    }

    @GetMapping("/vehicles")
    public String vehicles(HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        model.addAttribute("vehicles", vehicleService.getVehiclesByOwner(user.getId()));
        return "owner/vehicles";
    }

    @PostMapping("/vehicle/add")
    public String addVehicle(Vehicle vehicle, HttpSession session) {
        User user = (User) session.getAttribute("user");
        vehicle.setOwnerId(user.getId());
        vehicleService.addVehicle(vehicle);
        return "redirect:/owner/vehicles";
    }

    @PostMapping("/vehicle/update")
    public String updateVehicle(Vehicle vehicle) {
        vehicleService.updateVehicle(vehicle);
        return "redirect:/owner/vehicles";
    }

    @GetMapping("/vehicle/delete/{id}")
    public String deleteVehicle(@PathVariable Integer id) {
        vehicleService.deleteVehicle(id);
        return "redirect:/owner/vehicles";
    }

    @GetMapping("/appointment")
    public String appointmentPage(HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        model.addAttribute("vehicles", vehicleService.getVehiclesByOwner(user.getId()));
        return "owner/appointment";
    }

    @PostMapping("/appointment/submit")
    public String submitAppointment(ServiceOrder order, HttpSession session) {
        User user = (User) session.getAttribute("user");
        order.setOwnerId(user.getId());
        orderService.createOrder(order);
        return "redirect:/owner/orders";
    }

    @GetMapping("/orders")
    public String orders(HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        model.addAttribute("orders", orderService.getOrdersByOwner(user.getId()));
        return "owner/orders";
    }

    @GetMapping("/order/detail/{id}")
    public String orderDetail(@PathVariable Integer id, Model model) {
        ServiceOrder order = orderService.getOrderById(id);
        model.addAttribute("order", order);

        // 如果订单已完成，获取评价信息
        if (order != null && "completed".equals(order.getStatus())) {
            // 这里需要添加获取评价的逻辑
            // Evaluation evaluation = evaluationService.findByOrderId(id);
            // model.addAttribute("evaluation", evaluation);
        }

        return "owner/order_detail";
    }

    @GetMapping("/messages")
    public String messages(HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        model.addAttribute("messages", messageService.getMessagesByOwner(user.getId()));
        return "owner/messages";
    }

    @PostMapping("/message/add")
    public String addMessage(Message message, HttpSession session) {
        User user = (User) session.getAttribute("user");
        message.setOwnerId(user.getId());
        messageService.addMessage(message);
        return "redirect:/owner/messages";
    }

    @GetMapping("/message/delete/{id}")
    public String deleteMessage(@PathVariable Integer id) {
        messageService.deleteMessage(id);
        return "redirect:/owner/messages";
    }

    @GetMapping("/complaints")
    public String complaints(HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        model.addAttribute("complaints", complaintService.getComplaintsByOwner(user.getId()));
        return "owner/complaints";
    }

    @PostMapping("/complaint/add")
    public String addComplaint(Complaint complaint, HttpSession session) {
        User user = (User) session.getAttribute("user");
        complaint.setOwnerId(user.getId());
        complaintService.addComplaint(complaint);
        return "redirect:/owner/complaints";
    }

    @GetMapping("/evaluate/{orderId}")
    public String evaluatePage(@PathVariable Integer orderId, Model model) {
        model.addAttribute("order", orderService.getOrderById(orderId));
        return "owner/evaluate";
    }

    @PostMapping("/evaluation/submit")
    public String submitEvaluation(Evaluation evaluation, HttpSession session) {
        User user = (User) session.getAttribute("user");
        evaluation.setOwnerId(user.getId());
        orderService.addEvaluation(evaluation);
        return "redirect:/owner/orders";
    }
}