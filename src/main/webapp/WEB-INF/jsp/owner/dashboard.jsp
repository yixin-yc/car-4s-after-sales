<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <title>车主首页 - 汽车4S店售后管理系统</title>
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
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
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
            transition: all 0.3s;
        }
        .user-info a:hover {
            background: rgba(255,255,255,0.2);
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
            font-weight: 500;
            transition: all 0.3s;
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
            max-width: 1200px;
            margin: 0 auto;
        }
        .welcome-card {
            background: white;
            padding: 30px;
            border-radius: 10px;
            margin-bottom: 30px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.05);
        }
        .welcome-card h2 {
            color: #333;
            margin-bottom: 15px;
        }
        .welcome-card p {
            color: #666;
            line-height: 1.6;
        }
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }
        .stat-card {
            background: white;
            padding: 25px;
            border-radius: 10px;
            text-align: center;
            box-shadow: 0 2px 10px rgba(0,0,0,0.05);
            transition: all 0.3s;
        }
        .stat-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 5px 20px rgba(0,0,0,0.1);
        }
        .stat-card h3 {
            color: #999;
            font-size: 16px;
            margin-bottom: 10px;
            font-weight: 400;
        }
        .stat-card .number {
            color: #667eea;
            font-size: 42px;
            font-weight: 700;
        }
        .section {
            background: white;
            padding: 25px;
            border-radius: 10px;
            margin-bottom: 30px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.05);
        }
        .section h2 {
            color: #333;
            margin-bottom: 20px;
            padding-bottom: 15px;
            border-bottom: 2px solid #667eea;
            font-size: 20px;
        }
        .section-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }
        table {
            width: 100%;
            border-collapse: collapse;
        }
        th {
            background: #f8f9fa;
            padding: 15px;
            text-align: left;
            color: #555;
            font-weight: 600;
        }
        td {
            padding: 15px;
            border-bottom: 1px solid #eee;
            color: #666;
        }
        tr:hover {
            background: #f8f9fa;
        }
        .btn {
            display: inline-block;
            padding: 8px 20px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            text-decoration: none;
            border-radius: 5px;
            font-size: 14px;
            transition: all 0.3s;
            border: none;
            cursor: pointer;
        }
        .btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(102,126,234,0.4);
        }
        .btn-small {
            padding: 5px 15px;
            font-size: 13px;
        }
        .btn-outline {
            background: transparent;
            border: 1px solid #667eea;
            color: #667eea;
        }
        .btn-outline:hover {
            background: #667eea;
            color: white;
        }
        .status-badge {
            display: inline-block;
            padding: 3px 10px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 500;
        }
        .status-pending {
            background: #fff3cd;
            color: #856404;
        }
        .status-processing {
            background: #cce5ff;
            color: #004085;
        }
        .status-completed {
            background: #d4edda;
            color: #155724;
        }
        .empty-message {
            text-align: center;
            padding: 40px;
            color: #999;
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
    <a href="${pageContext.request.contextPath}/owner/dashboard" class="active">首页</a>
    <a href="${pageContext.request.contextPath}/owner/vehicles">车辆管理</a>
    <a href="${pageContext.request.contextPath}/owner/appointment">预约服务</a>
    <a href="${pageContext.request.contextPath}/owner/orders">订单查询</a>
    <a href="${pageContext.request.contextPath}/owner/messages">留言咨询</a>
    <a href="${pageContext.request.contextPath}/owner/complaints">投诉建议</a>
</div>

<div class="container">
    <div class="welcome-card">
        <h2>欢迎使用售后管理系统</h2>
        <p>您可以通过本系统管理您的车辆信息、预约维修保养服务、查询维修记录等。我们将为您提供专业、便捷的售后服务。</p>
    </div>

    <div class="stats-grid">
        <div class="stat-card">
            <h3>我的车辆</h3>
            <div class="number">${vehicleCount}</div>
        </div>
        <div class="stat-card">
            <h3>服务订单</h3>
            <div class="number">${orderCount}</div>
        </div>
        <div class="stat-card">
            <h3>待处理订单</h3>
            <div class="number">0</div>
        </div>
        <div class="stat-card">
            <h3>待评价订单</h3>
            <div class="number">0</div>
        </div>
    </div>

    <div class="section">
        <div class="section-header">
            <h2>我的车辆</h2>
            <a href="${pageContext.request.contextPath}/owner/vehicles" class="btn btn-small btn-outline">查看全部</a>
        </div>

        <c:if test="${empty vehicles}">
            <div class="empty-message">
                您还没有添加车辆信息，<a href="${pageContext.request.contextPath}/owner/vehicles" style="color: #667eea;">立即添加</a>
            </div>
        </c:if>

        <c:if test="${not empty vehicles}">
            <table>
                <thead>
                <tr>
                    <th>车牌号码</th>
                    <th>车型</th>
                    <th>购买时间</th>
                    <th>上次保养</th>
                    <th>操作</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach items="${vehicles}" var="vehicle" varStatus="status" begin="0" end="4">
                    <tr>
                        <td>${vehicle.plateNumber}</td>
                        <td>${vehicle.model}</td>
                        <td><fmt:formatDate value="${vehicle.purchaseDate}" pattern="yyyy-MM-dd"/></td>
                        <td><fmt:formatDate value="${vehicle.lastMaintenance}" pattern="yyyy-MM-dd"/></td>
                        <td>
                            <a href="${pageContext.request.contextPath}/owner/appointment?vehicleId=${vehicle.id}" class="btn btn-small">预约</a>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </c:if>
    </div>

    <div class="section">
        <div class="section-header">
            <h2>最近订单</h2>
            <a href="${pageContext.request.contextPath}/owner/orders" class="btn btn-small btn-outline">查看全部</a>
        </div>

        <c:if test="${empty recentOrders}">
            <div class="empty-message">
                暂无服务订单，<a href="${pageContext.request.contextPath}/owner/appointment" style="color: #667eea;">立即预约</a>
            </div>
        </c:if>

        <c:if test="${not empty recentOrders}">
            <table>
                <thead>
                <tr>
                    <th>订单编号</th>
                    <th>车辆</th>
                    <th>服务类型</th>
                    <th>预约时间</th>
                    <th>状态</th>
                    <th>操作</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach items="${recentOrders}" var="order">
                    <tr>
                        <td>${order.orderNo}</td>
                        <td>${order.vehicle.plateNumber}</td>
                        <td>
                            <c:choose>
                                <c:when test="${order.serviceType == 'maintenance'}">保养</c:when>
                                <c:when test="${order.serviceType == 'repair'}">维修</c:when>
                                <c:when test="${order.serviceType == 'inspection'}">检测</c:when>
                            </c:choose>
                        </td>
                        <td><fmt:formatDate value="${order.appointmentTime}" pattern="yyyy-MM-dd HH:mm"/></td>
                        <td>
                            <c:choose>
                                <c:when test="${order.status == 'pending'}">
                                    <span class="status-badge status-pending">待处理</span>
                                </c:when>
                                <c:when test="${order.status == 'processing'}">
                                    <span class="status-badge status-processing">处理中</span>
                                </c:when>
                                <c:when test="${order.status == 'completed'}">
                                    <span class="status-badge status-completed">已完成</span>
                                </c:when>
                            </c:choose>
                        </td>
                        <td>
                            <c:if test="${order.status == 'completed'}">
                                <a href="${pageContext.request.contextPath}/owner/evaluate/${order.id}" class="btn btn-small">评价</a>
                            </c:if>
                            <c:if test="${order.status == 'pending'}">
                                <span>等待接单</span>
                            </c:if>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </c:if>
    </div>
</div>
</body>
</html>