package com.car4s.service;

import com.car4s.model.User;
import com.car4s.mapper.UserMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.List;

@Service
public class UserService {

    @Autowired
    private UserMapper userMapper;

    public User login(String username, String password) {
        return userMapper.login(username, password);
    }

    public boolean register(User user) {
        User existingUser = userMapper.findByUsername(user.getUsername());
        if (existingUser != null) {
            return false;
        }
        if (user.getRole() == null) {
            user.setRole("owner");
        }
        userMapper.insert(user);
        return true;
    }

    public User getUserById(Integer id) {
        return userMapper.findById(id);
    }

    public List<User> getAllUsers() {
        return userMapper.findAll();
    }

    public List<User> getUsersByRole(String role) {
        return userMapper.findByRole(role);
    }

    public void updateUser(User user) {
        userMapper.update(user);
    }

    public void deleteUser(Integer id) {
        userMapper.delete(id);
    }

    public User findByUsername(String username) {
        return userMapper.findByUsername(username);
    }
}