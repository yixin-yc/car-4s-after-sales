package com.car4s.controller;

import com.car4s.mapper.OrderMapper;
import com.car4s.model.*;
import com.car4s.service.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;
import java.util.*;

@Controller
@RequestMapping("/mechanic")
public class MechanicController {

    @Autowired
    private OrderService orderService;

    @Autowired
    private MessageService messageService;

    @Autowired
    private VehicleService vehicleService;

    @Autowired
    private PartService partService;

    @Autowired
    private OrderMapper orderMapper;

    @GetMapping("/dashboard")
    public String dashboard(HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        List<ServiceOrder> pendingOrders = orderService.getOrdersByStatus("pending");
        List<ServiceOrder> myOrders = orderService.getOrdersByMechanic(user.getId());

        model.addAttribute("pendingOrders", pendingOrders);
        model.addAttribute("myOrders", myOrders);
        model.addAttribute("pendingCount", pendingOrders.size());
        model.addAttribute("processingCount", orderService.getOrdersByStatus("processing").size());

        return "mechanic/dashboard";
    }

    @GetMapping("/orders")
    public String orders(HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        model.addAttribute("pendingOrders", orderService.getOrdersByStatus("pending"));
        model.addAttribute("processingOrders", orderService.getOrdersByStatus("processing"));
        model.addAttribute("completedOrders", orderService.getOrdersByStatus("completed"));
        model.addAttribute("myOrders", orderService.getOrdersByMechanic(user.getId()));
        return "mechanic/orders";
    }

    @GetMapping("/order/accept/{id}")
    public String acceptOrder(@PathVariable Integer id, HttpSession session) {
        User user = (User) session.getAttribute("user");
        orderService.acceptOrder(id, user.getId());
        return "redirect:/mechanic/orders";
    }

    @GetMapping("/order/process/{id}")
    public String processOrder(@PathVariable Integer id, Model model) {
        ServiceOrder order = orderService.getOrderById(id);
        List<Part> parts = partService.getAllParts();
        model.addAttribute("order", order);
        model.addAttribute("parts", parts);
        return "mechanic/process_order";
    }

    @PostMapping("/order/complete")
    public String completeOrder(@RequestParam Integer orderId,
                                @RequestParam String serviceContent,
                                @RequestParam Double amount,
                                @RequestParam(required = false) Integer[] partIds,
                                @RequestParam(required = false) Integer[] partQuantities) {

        ServiceOrder order = orderService.getOrderById(orderId);
        if (order != null) {
            order.setServiceContent(serviceContent);
            order.setAmount(new java.math.BigDecimal(amount));  // 设置金额
            order.setStatus("completed");
            order.setCompleteTime(new Date());

            // 更新配件库存（如果有使用配件）
            if (partIds != null && partQuantities != null && partIds.length > 0) {
                List<Integer> ids = new ArrayList<>();
                for (Integer id : partIds) {
                    if (id != null) ids.add(id);
                }
                Map<Integer, Part> partMap = new HashMap<>();
                if (!ids.isEmpty()) {
                    for (Part p : orderMapper.findPartsByIds(ids)) {
                        partMap.put(p.getId(), p);
                    }
                }
                for (int i = 0; i < partIds.length; i++) {
                    if (partIds[i] != null && partQuantities[i] != null) {
                        Part part = partMap.get(partIds[i]);
                        if (part != null) {
                            int newStock = part.getStock() - partQuantities[i];
                            partService.updateStock(partIds[i], newStock);
                        }
                    }
                }
            }

            orderService.updateOrder(order);
        }

        return "redirect:/mechanic/orders";
    }

    @GetMapping("/order/detail/{id}")
    public String orderDetail(@PathVariable Integer id, Model model) {
        model.addAttribute("order", orderService.getOrderById(id));
        return "mechanic/order_detail";
    }

    @GetMapping("/messages")
    public String messages(Model model) {
        model.addAttribute("unrepliedMessages", messageService.getUnrepliedMessages());
        model.addAttribute("allMessages", messageService.getAllMessages());
        return "mechanic/messages";
    }

    @PostMapping("/message/reply")
    public String replyMessage(@RequestParam Integer id, @RequestParam String reply) {
        messageService.replyMessage(id, reply);
        return "redirect:/mechanic/messages";
    }

    @GetMapping("/message/view/{id}")
    public String viewMessage(@PathVariable Integer id, Model model) {
        Message message = messageService.getMessageById(id);
        model.addAttribute("message", message);
        return "mechanic/message_view";
    }

    @GetMapping("/maintenance-reminder")
    public String maintenanceReminder(Model model) {
        List<Vehicle> vehicles = vehicleService.getAllVehicles();

        // 计算统计数据
        int urgentCount = 0;
        int warningCount = 0;
        int normalCount = 0;

        Date now = new Date();
        long millisPerDay = 24 * 60 * 60 * 1000;

        for (Vehicle vehicle : vehicles) {
            if (vehicle.getLastMaintenance() != null) {
                long daysSinceLastMaintenance = (now.getTime() - vehicle.getLastMaintenance().getTime()) / millisPerDay;
                long nextMaintenanceMillis = vehicle.getLastMaintenance().getTime() +
                        (vehicle.getMaintenanceCycle() * 30 * millisPerDay);
                long daysUntilNextMaintenance = (nextMaintenanceMillis - now.getTime()) / millisPerDay;

                if (daysUntilNextMaintenance < 0) {
                    urgentCount++;
                } else if (daysUntilNextMaintenance <= 7) {
                    warningCount++;
                } else {
                    normalCount++;
                }
            }
        }

        model.addAttribute("vehicles", vehicles);
        model.addAttribute("urgentCount", urgentCount);
        model.addAttribute("warningCount", warningCount);
        model.addAttribute("normalCount", normalCount);

        return "mechanic/maintenance_reminder";
    }
}