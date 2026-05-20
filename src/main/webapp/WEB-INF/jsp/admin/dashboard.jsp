<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <title>管理员首页 - 汽车4S店售后管理系统</title>
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
            max-width: 1400px;
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
        }
        .stat-number {
            color: #667eea;
            font-size: 36px;
            font-weight: 700;
        }
        .stat-detail {
            color: #666;
            font-size: 14px;
            margin-top: 10px;
        }
        .dashboard-grid {
            display: grid;
            grid-template-columns: 2fr 1fr;
            gap: 20px;
        }
        .section {
            background: white;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.05);
            margin-bottom: 20px;
        }
        .section h2 {
            color: #333;
            margin-bottom: 15px;
            padding-bottom: 10px;
            border-bottom: 2px solid #667eea;
            font-size: 18px;
        }
        .alert-list {
            max-height: 300px;
            overflow-y: auto;
        }
        .alert-item {
            padding: 12px;
            border-bottom: 1px solid #eee;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .alert-item:hover {
            background: #f8f9fa;
        }
        .alert-icon {
            width: 30px;
            height: 30px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 16px;
        }
        .alert-icon.warning {
            background: #fff3cd;
            color: #856404;
        }
        .alert-icon.danger {
            background: #f8d7da;
            color: #721c24;
        }
        .alert-icon.info {
            background: #d1ecf1;
            color: #0c5460;
        }
        .alert-content {
            flex: 1;
        }
        .alert-title {
            font-weight: 500;
            color: #333;
        }
        .alert-time {
            font-size: 12px;
            color: #999;
        }
        .btn {
            display: inline-block;
            padding: 8px 20px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            text-decoration: none;
            border-radius: 5px;
            font-size: 14px;
        }
        .btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(102,126,234,0.4);
        }
        .btn-small {
            padding: 5px 12px;
            font-size: 12px;
        }
        table {
            width: 100%;
            border-collapse: collapse;
        }
        th {
            text-align: left;
            padding: 12px;
            color: #666;
            font-weight: 600;
            border-bottom: 2px solid #667eea;
        }
        td {
            padding: 12px;
            border-bottom: 1px solid #eee;
        }
        tr:hover {
            background: #f8f9fa;
        }
        .status-badge {
            display: inline-block;
            padding: 3px 10px;
            border-radius: 20px;
            font-size: 12px;
        }
        .status-pending {
            background: #fff3cd;
            color: #856404;
        }
        .status-unreplied {
            background: #fff3cd;
            color: #856404;
        }
        .status-unhandled {
            background: #f8d7da;
            color: #721c24;
        }
    </style>
</head>
<body>
<div class="header">
    <h1>汽车4S店售后管理系统</h1>
    <div class="user-info">
        <span>欢迎，${sessionScope.user.realName} (管理员)</span>
        <a href="${pageContext.request.contextPath}/logout">退出</a>
    </div>
</div>

<div class="nav">
    <a href="${pageContext.request.contextPath}/admin/dashboard" class="active">首页</a>
    <a href="${pageContext.request.contextPath}/admin/users">用户管理</a>
    <a href="${pageContext.request.contextPath}/admin/parts">配件管理</a>
    <a href="${pageContext.request.contextPath}/admin/orders">订单管理</a>
    <a href="${pageContext.request.contextPath}/admin/complaints">投诉处理</a>
    <a href="${pageContext.request.contextPath}/admin/messages">留言管理</a>
</div>

<div class="container">
    <div class="welcome-card">
        <h2>系统管理后台</h2>
        <p>欢迎使用汽车4S店售后管理系统管理后台，您可以在这里管理用户、配件、订单等信息。</p>
    </div>

    <div class="stats-grid">
        <div class="stat-card">
            <h3>总用户数</h3>
            <div class="stat-number">${userCount}</div>
            <div class="stat-detail">车主: ${ownerCount} | 维修人员: ${mechanicCount}</div>
        </div>
        <div class="stat-card">
            <h3>车辆总数</h3>
            <div class="stat-number">${vehicleCount}</div>
        </div>
        <div class="stat-card">
            <h3>今日订单</h3>
            <div class="stat-number">${orderCount}</div>
            <div class="stat-detail">待处理: ${pendingOrderCount}</div>
        </div>
        <div class="stat-card">
            <h3>待处理</h3>
            <div class="stat-number">${unrepliedMessageCount + unhandledComplaintCount}</div>
            <div class="stat-detail">留言: ${unrepliedMessageCount} | 投诉: ${unhandledComplaintCount}</div>
        </div>
    </div>

    <div class="dashboard-grid">
        <div>
            <div class="section">
                <h2>最近订单</h2>
                <table>
                    <thead>
                    <tr>
                        <th>订单号</th>
                        <th>车主</th>
                        <th>服务类型</th>
                        <th>状态</th>
                        <th>预约时间</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach items="${recentOrders}" var="order">
                        <tr>
                            <td>${order.orderNo}</td>
                            <td>${order.owner.realName}</td>
                            <td>
                                <c:choose>
                                    <c:when test="${order.serviceType == 'maintenance'}">保养</c:when>
                                    <c:when test="${order.serviceType == 'repair'}">维修</c:when>
                                    <c:otherwise>检测</c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                        <span class="status-badge status-${order.status}">
                                            <c:choose>
                                                <c:when test="${order.status == 'pending'}">待处理</c:when>
                                                <c:when test="${order.status == 'processing'}">处理中</c:when>
                                                <c:when test="${order.status == 'completed'}">已完成</c:when>
                                            </c:choose>
                                        </span>
                            </td>
                            <td><fmt:formatDate value="${order.appointmentTime}" pattern="yyyy-MM-dd HH:mm"/></td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>

        <div>
            <div class="section">
                <h2>系统提醒</h2>
                <div class="alert-list">
                    <c:if test="${unrepliedMessageCount > 0}">
                        <div class="alert-item">
                            <div class="alert-icon warning">📝</div>
                            <div class="alert-content">
                                <div class="alert-title">有 ${unrepliedMessageCount} 条留言待回复</div>
                                <div class="alert-time">请及时处理客户留言</div>
                            </div>
                            <a href="${pageContext.request.contextPath}/admin/messages" class="btn-small">处理</a>
                        </div>
                    </c:if>

                    <c:if test="${unhandledComplaintCount > 0}">
                        <div class="alert-item">
                            <div class="alert-icon danger">⚠️</div>
                            <div class="alert-content">
                                <div class="alert-title">有 ${unhandledComplaintCount} 条投诉待处理</div>
                                <div class="alert-time">请及时处理客户投诉</div>
                            </div>
                            <a href="${pageContext.request.contextPath}/admin/complaints" class="btn-small">处理</a>
                        </div>
                    </c:if>

                    <c:if test="${pendingOrderCount > 0}">
                        <div class="alert-item">
                            <div class="alert-icon info">🔧</div>
                            <div class="alert-content">
                                <div class="alert-title">有 ${pendingOrderCount} 个订单待接单</div>
                                <div class="alert-time">请提醒维修人员及时接单</div>
                            </div>
                            <a href="${pageContext.request.contextPath}/admin/orders" class="btn-small">查看</a>
                        </div>
                    </c:if>

                    <c:if test="${unrepliedMessageCount == 0 && unhandledComplaintCount == 0 && pendingOrderCount == 0}">
                        <div style="text-align: center; color: #999; padding: 20px;">
                            暂无待处理事项
                        </div>
                    </c:if>
                </div>
            </div>

            <div class="section">
                <h2>快速操作</h2>
                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 10px;">
                    <a href="${pageContext.request.contextPath}/admin/user/add" style="text-align: center; padding: 15px; background: #f8f9fa; border-radius: 5px; text-decoration: none; color: #333;">
                        <div style="font-size: 24px; margin-bottom: 5px;">👤</div>
                        <div>添加用户</div>
                    </a>
                    <a href="${pageContext.request.contextPath}/admin/part/add" style="text-align: center; padding: 15px; background: #f8f9fa; border-radius: 5px; text-decoration: none; color: #333;">
                        <div style="font-size: 24px; margin-bottom: 5px;">🔧</div>
                        <div>添加配件</div>
                    </a>
                    <a href="${pageContext.request.contextPath}/admin/order/statistics" style="text-align: center; padding: 15px; background: #f8f9fa; border-radius: 5px; text-decoration: none; color: #333;">
                        <div style="font-size: 24px; margin-bottom: 5px;">📊</div>
                        <div>订单统计</div>
                    </a>
                    <a href="${pageContext.request.contextPath}/admin/messages" style="text-align: center; padding: 15px; background: #f8f9fa; border-radius: 5px; text-decoration: none; color: #333;">
                        <div style="font-size: 24px; margin-bottom: 5px;">💬</div>
                        <div>留言管理</div>
                    </a>
                </div>
            </div>
        </div>
    </div>
</div>
</body>
</html>