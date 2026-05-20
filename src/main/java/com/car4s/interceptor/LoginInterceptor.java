package com.car4s.interceptor;

import com.car4s.model.User;
import org.springframework.web.servlet.HandlerInterceptor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class LoginInterceptor implements HandlerInterceptor {

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/");
            return false;
        }

        String requestURI = request.getRequestURI();
        String role = user.getRole();

        if (requestURI.contains("/owner/") && !"owner".equals(role) && !"admin".equals(role)) {
            response.sendRedirect(request.getContextPath() + "/");
            return false;
        }

        if (requestURI.contains("/mechanic/") && !"mechanic".equals(role) && !"admin".equals(role)) {
            response.sendRedirect(request.getContextPath() + "/");
            return false;
        }

        if (requestURI.contains("/admin/") && !"admin".equals(role)) {
            response.sendRedirect(request.getContextPath() + "/");
            return false;
        }

        return true;
    }
}