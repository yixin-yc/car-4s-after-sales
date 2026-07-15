package com.car4s.service;

import com.car4s.model.User;
import com.car4s.mapper.UserMapper;
import com.car4s.util.RedisUtil;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.List;

@Service
public class UserService {

    private static final Logger logger = LoggerFactory.getLogger(UserService.class);

    /**
     * 用户缓存过期时间（秒）：1小时
     */
    private static final long USER_CACHE_EXPIRE_TIME = 3600;

    @Autowired
    private UserMapper userMapper;

    @Autowired
    private RedisUtil redisUtil;

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
        logger.info("用户注册成功，username: {}", user.getUsername());
        return true;
    }

    /**
     * 根据ID查询用户
     * 使用Redis缓存，解决缓存穿透、击穿问题
     */
    public User getUserById(Integer id) {
        String cacheKey = "user:" + id;
        return redisUtil.getWithLock(
                cacheKey,
                User.class,
                () -> userMapper.findById(id),
                USER_CACHE_EXPIRE_TIME
        );
    }

    public List<User> getAllUsers() {
        return userMapper.findAll();
    }

    public List<User> getUsersByRole(String role) {
        return userMapper.findByRole(role);
    }

    /**
     * 更新用户
     * 双写一致性：先更新数据库，再删除缓存
     */
    public void updateUser(User user) {
        String cacheKey = "user:" + user.getId();
        redisUtil.updateWithCacheInvalidation(
                cacheKey,
                () -> userMapper.update(user)
        );
    }

    /**
     * 更新个人资料
     * 双写一致性：先更新数据库，再删除缓存
     */
    public void updateProfile(User user) {
        String cacheKey = "user:" + user.getId();
        redisUtil.updateWithCacheInvalidation(
                cacheKey,
                () -> userMapper.updateProfile(user)
        );
    }

    /**
     * 删除用户
     * 双写一致性：先删除数据库，再删除缓存
     */
    public void deleteUser(Integer id) {
        String cacheKey = "user:" + id;
        redisUtil.deleteWithCacheInvalidation(
                cacheKey,
                () -> userMapper.delete(id)
        );
    }

    public User findByUsername(String username) {
        return userMapper.findByUsername(username);
    }
}