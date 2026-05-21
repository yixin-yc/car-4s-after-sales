-- ============================================
-- 汽车4S店售后管理系统 - 数据库脚本
-- 包含：建表语句 + 测试数据 + 优化索引
-- ============================================

-- 1. 创建数据库
CREATE DATABASE IF NOT EXISTS car4s_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

USE car4s_db;

-- ============================================
-- 2. 创建表结构
-- ============================================

-- 用户表
DROP TABLE IF EXISTS user;
CREATE TABLE user (
                      id INT PRIMARY KEY AUTO_INCREMENT,
                      username VARCHAR(50) UNIQUE NOT NULL,
                      password VARCHAR(100) NOT NULL,
                      real_name VARCHAR(50),
                      phone VARCHAR(20),
                      email VARCHAR(100),
                      role ENUM('owner', 'mechanic', 'admin') DEFAULT 'owner',
                      status TINYINT DEFAULT 1,
                      create_time DATETIME DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 车辆信息表
DROP TABLE IF EXISTS vehicle;
CREATE TABLE vehicle (
                         id INT PRIMARY KEY AUTO_INCREMENT,
                         vehicle_no VARCHAR(50) UNIQUE NOT NULL,
                         owner_id INT NOT NULL,
                         plate_number VARCHAR(20) NOT NULL,
                         model VARCHAR(50),
                         purchase_date DATE,
                         vin VARCHAR(50) UNIQUE,
                         maintenance_cycle INT COMMENT '保养周期（月）',
                         last_maintenance DATE,
                         create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
                         FOREIGN KEY (owner_id) REFERENCES user(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 维修保养订单表
DROP TABLE IF EXISTS service_order;
CREATE TABLE service_order (
                               id INT PRIMARY KEY AUTO_INCREMENT,
                               order_no VARCHAR(50) UNIQUE NOT NULL,
                               owner_id INT NOT NULL,
                               vehicle_id INT NOT NULL,
                               mechanic_id INT,
                               appointment_time DATETIME,
                               service_type ENUM('maintenance', 'repair', 'inspection'),
                               service_content TEXT,
                               amount DECIMAL(10,2),
                               status ENUM('pending', 'processing', 'completed', 'cancelled') DEFAULT 'pending',
                               create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
                               complete_time DATETIME,
                               FOREIGN KEY (owner_id) REFERENCES user(id),
                               FOREIGN KEY (vehicle_id) REFERENCES vehicle(id),
                               FOREIGN KEY (mechanic_id) REFERENCES user(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 配件信息表
DROP TABLE IF EXISTS part;
CREATE TABLE part (
                      id INT PRIMARY KEY AUTO_INCREMENT,
                      part_no VARCHAR(50) UNIQUE NOT NULL,
                      part_name VARCHAR(100) NOT NULL,
                      specification VARCHAR(100),
                      price DECIMAL(10,2),
                      stock INT DEFAULT 0,
                      supplier VARCHAR(100)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 评价表
DROP TABLE IF EXISTS evaluation;
CREATE TABLE evaluation (
                            id INT PRIMARY KEY AUTO_INCREMENT,
                            order_id INT NOT NULL,
                            owner_id INT NOT NULL,
                            rating INT CHECK (rating >= 1 AND rating <= 5),
                            comment TEXT,
                            create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
                            FOREIGN KEY (order_id) REFERENCES service_order(id),
                            FOREIGN KEY (owner_id) REFERENCES user(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 留言咨询表
DROP TABLE IF EXISTS message;
CREATE TABLE message (
                         id INT PRIMARY KEY AUTO_INCREMENT,
                         owner_id INT NOT NULL,
                         title VARCHAR(200),
                         content TEXT,
                         reply TEXT,
                         status TINYINT DEFAULT 0 COMMENT '0-未回复 1-已回复',
                         create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
                         reply_time DATETIME,
                         FOREIGN KEY (owner_id) REFERENCES user(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 投诉处理表
DROP TABLE IF EXISTS complaint;
CREATE TABLE complaint (
                           id INT PRIMARY KEY AUTO_INCREMENT,
                           owner_id INT NOT NULL,
                           order_id INT,
                           content TEXT,
                           reply TEXT,
                           status TINYINT DEFAULT 0,
                           create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
                           handle_time DATETIME,
                           FOREIGN KEY (owner_id) REFERENCES user(id),
                           FOREIGN KEY (order_id) REFERENCES service_order(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================
-- 3. 插入测试数据
-- ============================================

-- 用户数据
INSERT INTO user (username, password, real_name, phone, email, role) VALUES
                                                                         ('admin', '123456', '系统管理员', '13800138001', 'admin@car4s.com', 'admin'),
                                                                         ('mechanic1', '123456', '张师傅', '13800138002', 'zhang@car4s.com', 'mechanic'),
                                                                         ('mechanic2', '123456', '李师傅', '13800138003', 'li@car4s.com', 'mechanic'),
                                                                         ('owner1', '123456', '王车主', '13800138004', 'wang@163.com', 'owner'),
                                                                         ('owner2', '123456', '赵车主', '13800138005', 'zhao@163.com', 'owner');

-- 配件数据
INSERT INTO part (part_no, part_name, specification, price, stock, supplier) VALUES
                                                                                 ('P001', '机油', '5W-30 4L', 280.00, 50, '壳牌'),
                                                                                 ('P002', '机油滤清器', '通用型', 45.00, 100, '博世'),
                                                                                 ('P003', '空气滤清器', '通用型', 65.00, 80, '曼牌'),
                                                                                 ('P004', '刹车片', '前轮', 320.00, 30, '菲罗多'),
                                                                                 ('P005', '火花塞', '铱金', 120.00, 60, 'NGK');

-- ============================================
-- 4. 三高优化索引（性能优化新增）
-- ============================================

-- 订单表：按创建时间排序分页查询（优化列表页性能）
CREATE INDEX idx_service_order_create_time
    ON service_order(create_time DESC);

-- 订单表：按车主查询（优化我的工单查询）
CREATE INDEX idx_service_order_owner_id
    ON service_order(owner_id);

-- 订单表：按状态查询（优化待处理工单统计）
CREATE INDEX idx_service_order_status
    ON service_order(status);

-- 车辆表：按车主查询（优化车辆列表）
CREATE INDEX idx_vehicle_owner_id
    ON vehicle(owner_id);

-- 用户表：按角色查询（优化角色筛选）
CREATE INDEX idx_user_role
    ON user(role);

-- 配件表：按名称搜索（优化配件查找）
CREATE INDEX idx_part_part_name
    ON part(part_name);

-- 评价表：按订单查询
CREATE INDEX idx_evaluation_order_id
    ON evaluation(order_id);

-- 留言表：按状态查询
CREATE INDEX idx_message_status
    ON message(status);

-- 投诉表：按状态查询
CREATE INDEX idx_complaint_status
    ON complaint(status);

-- ============================================
-- 5. 执行完成提示
-- ============================================

SELECT '✅ 数据库初始化完成！' AS message;