package com.car4s;

import org.mybatis.spring.annotation.MapperScan;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.builder.SpringApplicationBuilder;
import org.springframework.boot.web.servlet.support.SpringBootServletInitializer;
import org.springframework.cache.annotation.EnableCaching;

@SpringBootApplication
@MapperScan("com.car4s.mapper")
@EnableCaching
public class Application extends SpringBootServletInitializer {

    @Override
    protected SpringApplicationBuilder configure(SpringApplicationBuilder builder) {
        return builder.sources(Application.class);
    }

    public static void main(String[] args) {
        SpringApplication.run(Application.class, args);
        System.out.println("\n=========================================");
        System.out.println("   汽车4S店售后管理系统启动成功！");
        System.out.println("   访问地址：http://localhost:8080/car4s/");
        System.out.println("   测试账号：");
        System.out.println("   管理员 - admin/123456");
        System.out.println("   维修人员 - mechanic1/123456");
        System.out.println("   车主 - owner1/123456");
        System.out.println("=========================================\n");
    }
}