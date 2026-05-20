package com.car4s.mapper;

import com.car4s.model.User;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import java.util.List;

@Mapper
public interface UserMapper {
    User findById(@Param("id") Integer id);
    User findByUsername(@Param("username") String username);
    User login(@Param("username") String username, @Param("password") String password);
    List<User> findAll();
    List<User> findByRole(@Param("role") String role);
    void insert(User user);
    void update(User user);
    void delete(@Param("id") Integer id);
}