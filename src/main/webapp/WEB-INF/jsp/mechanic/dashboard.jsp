<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <title>维修人员首页 - 汽车4S店售后管理系统</title>
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
    </style>
</head>
<body>
<div class="header">
    <h1>汽车4S店售后管理系统</h1>
    <div class="user-info">
        <span>欢迎，${sessionScope.user.realName} (维修人员)</span>
        <a href="${pageContext.request.contextPath}/logout">退出</a>
    </div>
</div>

<div class="nav">
    <a href="${pageContext.request.contextPath}/mechanic/dashboard" class="active">首页</a>
    <a href="${pageContext.request.contextPath}/mechanic/orders">订单管理</a>
    <a href="${pageContext.request.contextPath}/mechanic/messages">留言回复</a>
    <a href="${pageContext.request.contextPath}/mechanic/maintenance-reminder">保养提醒</a>
</div>

<div class="container">
    <div class="welcome-card">
        <h2>欢迎回来，${sessionScope.user.realName}师傅</h2>
        <p>您可以通过本系统处理维修订单、回复客户咨询、设置保养提醒等。</p>
    </div>

    <div class="stats-grid">
        <div class="stat-card">
            <h3>待接单</h3>
            <div class="number">${pendingCount}</div>
        </div>
        <div class="stat-card">
            <h3>处理中</h3>
            <div class="number">${processingCount}</div>
        </div>
        <div class="stat-card">
            <h3>已完成</h3>
            <div class="number">0</div>
        </div>
        <div class="stat-card">
            <h3>待回复留言</h3>
            <div class="number">0</div>
        </div>
    </div>

    <div class="section">
        <div class="section-header">
            <h2>待接单列表</h2>
            <a href="${pageContext.request.contextPath}/mechanic/orders" class="btn btn-small btn-outline">查看全部</a>
        </div>

        <c:if test="${empty pendingOrders}">
            <p style="text-align: center; color: #999; padding: 20px;">暂无待接单的订单</p>
        </c:if>

        <c:if test="${not empty pendingOrders}">
            <table>
                <thead>
                <tr>
                    <th>订单号</th>
                    <th>车主</th>
                    <th>车辆</th>
                    <th>服务类型</th>
                    <th>预约时间</th>
                    <th>操作</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach items="${pendingOrders}" var="order" varStatus="status" begin="0" end="4">
                    <tr>
                        <td>${order.orderNo}</td>
                        <td>${order.owner.realName}</td>
                        <td>${order.vehicle.plateNumber}</td>
                        <td>
                            <c:choose>
                                <c:when test="${order.serviceType == 'maintenance'}">保养</c:when>
                                <c:when test="${order.serviceType == 'repair'}">维修</c:when>
                                <c:otherwise>检测</c:otherwise>
                            </c:choose>
                        </td>
                        <td><fmt:formatDate value="${order.appointmentTime}" pattern="yyyy-MM-dd HH:mm"/></td>
                        <td>
                            <a href="${pageContext.request.contextPath}/mechanic/order/accept/${order.id}" class="btn btn-small">接单</a>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </c:if>
    </div>

    <div class="section">
        <div class="section-header">
            <h2>我的处理中订单</h2>
            <a href="${pageContext.request.contextPath}/mechanic/orders" class="btn btn-small btn-outline">查看全部</a>
        </div>

        <c:if test="${empty myOrders}">
            <p style="text-align: center; color: #999; padding: 20px;">暂无处理中的订单</p>
        </c:if>

        <c:if test="${not empty myOrders}">
            <table>
                <thead>
                <tr>
                    <th>订单号</th>
                    <th>车主</th>
                    <th>车辆</th>
                    <th>服务类型</th>
                    <th>预约时间</th>
                    <th>状态</th>
                    <th>操作</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach items="${myOrders}" var="order" varStatus="status" begin="0" end="4">
                    <tr>
                        <td>${order.orderNo}</td>
                        <td>${order.owner.realName}</td>
                        <td>${order.vehicle.plateNumber}</td>
                        <td>
                            <c:choose>
                                <c:when test="${order.serviceType == 'maintenance'}">保养</c:when>
                                <c:when test="${order.serviceType == 'repair'}">维修</c:when>
                                <c:otherwise>检测</c:otherwise>
                            </c:choose>
                        </td>
                        <td><fmt:formatDate value="${order.appointmentTime}" pattern="yyyy-MM-dd HH:mm"/></td>
                        <td><span class="status-badge status-processing">处理中</span></td>
                        <td>
                            <a href="${pageContext.request.contextPath}/mechanic/order/process/${order.id}" class="btn btn-small">处理</a>
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