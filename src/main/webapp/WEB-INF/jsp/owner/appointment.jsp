<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>预约服务 - 汽车4S店售后管理系统</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        body {
            font-family: 'Microsoft YaHei', Arial, sans-serif;
            background-color: #f4f7fc;
        }
        .header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 15px 30px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .header h1 {
            font-size: 24px;
        }
        .user-info {
            display: flex;
            align-items: center;
            gap: 20px;
        }
        .user-info a {
            color: white;
            text-decoration: none;
            padding: 5px 15px;
            border: 1px solid rgba(255,255,255,0.3);
            border-radius: 4px;
        }
        .nav {
            background: white;
            padding: 0 30px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.05);
        }
        .nav a {
            display: inline-block;
            color: #666;
            text-decoration: none;
            padding: 15px 25px;
        }
        .nav a:hover {
            color: #667eea;
        }
        .nav a.active {
            color: #667eea;
            border-bottom: 3px solid #667eea;
        }
        .container {
            padding: 30px;
            max-width: 800px;
            margin: 0 auto;
        }
        .appointment-form {
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.05);
        }
        .appointment-form h2 {
            color: #333;
            margin-bottom: 20px;
            padding-bottom: 15px;
            border-bottom: 2px solid #667eea;
        }
        .form-group {
            margin-bottom: 20px;
        }
        .form-group label {
            display: block;
            margin-bottom: 8px;
            color: #555;
            font-weight: 500;
        }
        .form-group select,
        .form-group input,
        .form-group textarea {
            width: 100%;
            padding: 10px 15px;
            border: 1px solid #ddd;
            border-radius: 5px;
            font-size: 15px;
        }
        .form-group select:focus,
        .form-group input:focus,
        .form-group textarea:focus {
            border-color: #667eea;
            outline: none;
            box-shadow: 0 0 0 3px rgba(102,126,234,0.1);
        }
        .form-group textarea {
            height: 100px;
            resize: vertical;
        }
        .btn {
            display: inline-block;
            padding: 12px 30px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            text-decoration: none;
            border-radius: 5px;
            border: none;
            cursor: pointer;
            font-size: 16px;
            font-weight: 500;
        }
        .btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(102,126,234,0.4);
        }
        .btn-secondary {
            background: #95a5a6;
            margin-left: 10px;
        }
        .btn-secondary:hover {
            background: #7f8c8d;
        }
        .form-actions {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-top: 30px;
        }
        .service-type {
            display: flex;
            gap: 20px;
            margin-top: 5px;
        }
        .service-type label {
            display: flex;
            align-items: center;
            gap: 5px;
            font-weight: normal;
            cursor: pointer;
        }
        .service-type input[type="radio"] {
            width: auto;
            margin-right: 5px;
        }
    </style>
</head>
<body>
<div class="header">
    <h1>汽车4S店售后管理系统</h1>
    <div class="user-info">
        <span>欢迎，${sessionScope.user.realName} (车主)</span>
        <a href="${pageContext.request.contextPath}/logout">退出</a>
    </div>
</div>

<div class="nav">
    <a href="${pageContext.request.contextPath}/owner/dashboard">首页</a>
    <a href="${pageContext.request.contextPath}/owner/vehicles">车辆管理</a>
    <a href="${pageContext.request.contextPath}/owner/appointment" class="active">预约服务</a>
    <a href="${pageContext.request.contextPath}/owner/orders">订单查询</a>
    <a href="${pageContext.request.contextPath}/owner/messages">留言咨询</a>
    <a href="${pageContext.request.contextPath}/owner/complaints">投诉建议</a>
</div>

<div class="container">
    <div class="appointment-form">
        <h2>预约维修保养服务</h2>

        <form action="${pageContext.request.contextPath}/owner/appointment/submit" method="post">
            <div class="form-group">
                <label>选择车辆：</label>
                <select name="vehicleId" required>
                    <option value="">请选择车辆</option>
                    <c:forEach items="${vehicles}" var="vehicle">
                        <option value="${vehicle.id}" ${param.vehicleId == vehicle.id ? 'selected' : ''}>
                                ${vehicle.plateNumber} - ${vehicle.model}
                        </option>
                    </c:forEach>
                </select>
            </div>

            <div class="form-group">
                <label>服务类型：</label>
                <div class="service-type">
                    <label>
                        <input type="radio" name="serviceType" value="maintenance" checked> 保养
                    </label>
                    <label>
                        <input type="radio" name="serviceType" value="repair"> 维修
                    </label>
                    <label>
                        <input type="radio" name="serviceType" value="inspection"> 检测
                    </label>
                </div>
            </div>

            <div class="form-group">
                <label>预约时间：</label>
                <input type="datetime-local" name="appointmentTime" required>
            </div>

            <div class="form-group">
                <label>服务内容描述：</label>
                <textarea name="serviceContent" placeholder="请详细描述您需要的服务内容..."></textarea>
            </div>

            <div class="form-actions">
                <a href="${pageContext.request.contextPath}/owner/dashboard" class="btn btn-secondary">返回</a>
                <button type="submit" class="btn">提交预约</button>
            </div>
        </form>
    </div>
</div>

<script>
    // 设置预约时间的最小值为当前时间
    document.addEventListener('DOMContentLoaded', function() {
        var now = new Date();
        var year = now.getFullYear();
        var month = String(now.getMonth() + 1).padStart(2, '0');
        var day = String(now.getDate()).padStart(2, '0');
        var hours = String(now.getHours()).padStart(2, '0');
        var minutes = String(now.getMinutes()).padStart(2, '0');

        var minDateTime = year + '-' + month + '-' + day + 'T' + hours + ':' + minutes;
        document.querySelector('input[type="datetime-local"]').min = minDateTime;
    });
</script>
</body>
</html>