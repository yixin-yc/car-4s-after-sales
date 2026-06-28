package com.car4s.controller;

import com.car4s.model.*;
import com.car4s.service.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.math.BigDecimal;
import java.util.Calendar;
import java.util.Date;
import javax.servlet.http.HttpSession;

@Controller
@RequestMapping("/admin")
public class AdminController {

    @Autowired
    private UserService userService;

    @Autowired
    private VehicleService vehicleService;

    @Autowired
    private OrderService orderService;

    @Autowired
    private PartService partService;

    @Autowired
    private MessageService messageService;

    @Autowired
    private ComplaintService complaintService;

    @Autowired
    private AsyncStatisticsService asyncStatisticsService;

    @GetMapping("/dashboard")
    public String dashboard(Model model) {
        model.addAttribute("userCount", userService.getAllUsers().size());
        model.addAttribute("ownerCount", userService.getUsersByRole("owner").size());
        model.addAttribute("mechanicCount", userService.getUsersByRole("mechanic").size());
        model.addAttribute("vehicleCount", vehicleService.getAllVehicles().size());
        model.addAttribute("orderCount", orderService.getAllOrders().size());
        model.addAttribute("pendingOrderCount", orderService.getOrdersByStatus("pending").size());
        model.addAttribute("unrepliedMessageCount", messageService.getUnrepliedMessages().size());
        model.addAttribute("unhandledComplaintCount", complaintService.getUnhandledComplaints().size());

        model.addAttribute("recentOrders", orderService.getAllOrders().stream().limit(10).toArray());
        return "admin/dashboard";
    }

    @GetMapping("/users")
    public String users(Model model) {
        model.addAttribute("owners", userService.getUsersByRole("owner"));
        model.addAttribute("mechanics", userService.getUsersByRole("mechanic"));
        return "admin/users";
    }

    @GetMapping("/user/add")
    public String addUserPage() {
        return "admin/user_add";
    }

    @PostMapping("/user/add")
    public String addUser(User user) {
        userService.register(user);
        return "redirect:/admin/users";
    }

    @GetMapping("/user/edit/{id}")
    public String editUser(@PathVariable Integer id, Model model) {
        model.addAttribute("user", userService.getUserById(id));
        return "admin/user_edit";
    }

    @PostMapping("/user/update")
    public String updateUser(User user) {
        userService.updateUser(user);
        return "redirect:/admin/users";
    }

    @GetMapping("/user/delete/{id}")
    public String deleteUser(@PathVariable Integer id) {
        userService.deleteUser(id);
        return "redirect:/admin/users";
    }

    @GetMapping("/parts")
    public String parts(Model model) {
        model.addAttribute("parts", partService.getAllParts());
        return "admin/parts";
    }

    @GetMapping("/part/add")
    public String addPartPage() {
        return "admin/part_add";
    }

    @PostMapping("/part/add")
    public String addPart(Part part) {
        partService.addPart(part);
        return "redirect:/admin/parts";
    }

    @GetMapping("/part/edit/{id}")
    public String editPart(@PathVariable Integer id, Model model) {
        model.addAttribute("part", partService.getPartById(id));
        return "admin/part_edit";
    }

    @PostMapping("/part/update")
    public String updatePart(Part part) {
        partService.updatePart(part);
        return "redirect:/admin/parts";
    }

    @GetMapping("/part/delete/{id}")
    public String deletePart(@PathVariable Integer id) {
        partService.deletePart(id);
        return "redirect:/admin/parts";
    }

    @GetMapping("/orders")
    public String orders(@RequestParam(defaultValue = "1") int page,
                         @RequestParam(defaultValue = "10") int pageSize,
                         Model model) {
        model.addAttribute("orders", orderService.getOrdersWithPage(page, pageSize));
        int totalCount = orderService.getTotalOrderCount();
        model.addAttribute("totalCount", totalCount);
        model.addAttribute("totalPages", (int) Math.ceil((double) totalCount / pageSize));
        model.addAttribute("currentPage", page);
        model.addAttribute("pageSize", pageSize);
        return "admin/orders";
    }

    @GetMapping("/order/detail/{id}")
    public String orderDetail(@PathVariable Integer id, Model model) {
        model.addAttribute("order", orderService.getOrderById(id));
        return "admin/order_detail";
    }

    @GetMapping("/order/complete/{id}")
    public String completeOrder(@PathVariable Integer id) {
        orderService.completeOrder(id);
        return "redirect:/admin/orders";
    }

    @GetMapping("/order/statistics")
    public String orderStatistics(Model model) {
        int totalOrders = orderService.getAllOrders().size();
        int pendingOrders = orderService.getOrdersByStatus("pending").size();
        int processingOrders = orderService.getOrdersByStatus("processing").size();
        int completedOrders = orderService.getOrdersByStatus("completed").size();

        model.addAttribute("totalOrders", totalOrders);
        model.addAttribute("pendingOrders", pendingOrders);
        model.addAttribute("processingOrders", processingOrders);
        model.addAttribute("completedOrders", completedOrders);

        Calendar cal = Calendar.getInstance();
        int currentYear = cal.get(Calendar.YEAR);

        int[] allMonthly = orderService.getMonthlyOrderCounts(currentYear);
        int[] monthlyData = new int[6];
        for (int i = 0; i < 6; i++) {
            monthlyData[i] = allMonthly[i];
        }
        model.addAttribute("monthlyData", monthlyData);

        int pendingPercent = totalOrders > 0 ? (int) Math.round((double) pendingOrders / totalOrders * 100) : 0;
        int processingPercent = totalOrders > 0 ? (int) Math.round((double) processingOrders / totalOrders * 100) : 0;
        model.addAttribute("pendingPercent", pendingPercent);
        model.addAttribute("processingPercent", processingPercent);

        cal.set(Calendar.DAY_OF_MONTH, 1);
        cal.set(Calendar.HOUR_OF_DAY, 0);
        cal.set(Calendar.MINUTE, 0);
        cal.set(Calendar.SECOND, 0);
        cal.set(Calendar.MILLISECOND, 0);
        Date monthStart = cal.getTime();
        cal.add(Calendar.MONTH, 1);
        Date monthEnd = cal.getTime();
        model.addAttribute("monthlyRevenue", orderService.getRevenueByDateRange(monthStart, monthEnd));

        cal.set(Calendar.MONTH, ((cal.get(Calendar.MONTH) / 3) * 3));
        Date quarterStart = cal.getTime();
        cal.add(Calendar.MONTH, 3);
        Date quarterEnd = cal.getTime();
        model.addAttribute("quarterlyRevenue", orderService.getRevenueByDateRange(quarterStart, quarterEnd));

        cal.set(Calendar.MONTH, Calendar.JANUARY);
        Date yearStart = cal.getTime();
        cal.add(Calendar.YEAR, 1);
        Date yearEnd = cal.getTime();
        model.addAttribute("yearlyRevenue", orderService.getRevenueByDateRange(yearStart, yearEnd));

        return "admin/order_statistics";
    }

    @GetMapping("/order/statistics/async")
    @ResponseBody
    public String orderStatisticsAsync() {
        asyncStatisticsService.computeOrderStatistics();
        return "任务已提交";
    }

    @GetMapping("/complaints")
    public String complaints(Model model) {
        model.addAttribute("complaints", complaintService.getAllComplaints());
        model.addAttribute("unhandledComplaints", complaintService.getUnhandledComplaints());
        return "admin/complaints";
    }

    @PostMapping("/complaint/handle")
    public String handleComplaint(@RequestParam Integer id, @RequestParam String reply) {
        complaintService.handleComplaint(id, reply);
        return "redirect:/admin/complaints";
    }

    @GetMapping("/complaint/delete/{id}")
    public String deleteComplaint(@PathVariable Integer id) {
        complaintService.deleteComplaint(id);
        return "redirect:/admin/complaints";
    }

    @GetMapping("/messages")
    public String messages(Model model) {
        model.addAttribute("messages", messageService.getAllMessages());
        model.addAttribute("unrepliedMessages", messageService.getUnrepliedMessages());
        return "admin/messages";
    }

    @PostMapping("/message/reply")
    public String replyMessage(@RequestParam Integer id, @RequestParam String reply) {
        messageService.replyMessage(id, reply);
        return "redirect:/admin/messages";
    }

    @GetMapping("/message/delete/{id}")
    public String deleteMessage(@PathVariable Integer id) {
        messageService.deleteMessage(id);
        return "redirect:/admin/messages";
    }

    @GetMapping("/profile")
    public String profile(HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        model.addAttribute("user", userService.getUserById(user.getId()));
        return "admin/profile";
    }

    @PostMapping("/profile/update")
    public String updateProfile(User user, HttpSession session) {
        User currentUser = (User) session.getAttribute("user");
        user.setId(currentUser.getId());
        userService.updateProfile(user);
        User updatedUser = userService.getUserById(currentUser.getId());
        session.setAttribute("user", updatedUser);
        return "redirect:/admin/profile";
    }
}