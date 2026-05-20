<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <title>订单查询 - 汽车4S店售后管理系统</title>
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
        .page-title {
            margin-bottom: 20px;
        }
        .page-title h2 {
            color: #333;
        }
        .filter-bar {
            background: white;
            padding: 20px;
            border-radius: 10px;
            margin-bottom: 20px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.05);
            display: flex;
            gap: 15px;
            align-items: center;
        }
        .filter-bar select {
            padding: 8px 15px;
            border: 1px solid #ddd;
            border-radius: 5px;
            font-size: 14px;
        }
        .order-list {
            background: white;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.05);
            overflow: hidden;
        }
        .order-item {
            padding: 20px;
            border-bottom: 1px solid #eee;
            transition: all 0.3s;
        }
        .order-item:hover {
            background: #f8f9fa;
        }
        .order-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 15px;
        }
        .order-no {
            font-size: 16px;
            font-weight: 600;
            color: #333;
        }
        .order-status {
            padding: 5px 15px;
            border-radius: 20px;
            font-size: 13px;
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
        .order-detail {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 15px;
            margin-bottom: 15px;
        }
        .detail-item {
            color: #666;
        }
        .detail-item .label {
            font-size: 13px;
            color: #999;
            margin-bottom: 3px;
        }
        .detail-item .value {
            font-size: 15px;
            font-weight: 500;
        }
        .order-actions {
            display: flex;
            gap: 10px;
            justify-content: flex-end;
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
        .btn-outline {
            background: transparent;
            border: 1px solid #667eea;
            color: #667eea;
        }
        .btn-outline:hover {
            background: #667eea;
            color: white;
        }
        .empty-message {
            text-align: center;
            padding: 50px;
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
    <a href="${pageContext.request.contextPath}/owner/dashboard">首页</a>
    <a href="${pageContext.request.contextPath}/owner/vehicles">车辆管理</a>
    <a href="${pageContext.request.contextPath}/owner/appointment">预约服务</a>
    <a href="${pageContext.request.contextPath}/owner/orders" class="active">订单查询</a>
    <a href="${pageContext.request.contextPath}/owner/messages">留言咨询</a>
    <a href="${pageContext.request.contextPath}/owner/complaints">投诉建议</a>
</div>

<div class="container">
    <div class="page-title">
        <h2>我的服务订单</h2>
    </div>

    <div class="filter-bar">
        <label>筛选状态：</label>
        <select id="statusFilter" onchange="filterOrders()">
            <option value="all">全部订单</option>
            <option value="pending">待处理</option>
            <option value="processing">处理中</option>
            <option value="completed">已完成</option>
        </select>
    </div>

    <div class="order-list">
        <c:if test="${empty orders}">
            <div class="empty-message">
                暂无服务订单
            </div>
        </c:if>

        <c:forEach items="${orders}" var="order">
            <div class="order-item" data-status="${order.status}">
                <div class="order-header">
                    <span class="order-no">订单号：${order.orderNo}</span>
                    <span class="order-status status-${order.status}">
                            <c:choose>
                                <c:when test="${order.status == 'pending'}">待处理</c:when>
                                <c:when test="${order.status == 'processing'}">处理中</c:when>
                                <c:when test="${order.status == 'completed'}">已完成</c:when>
                                <c:otherwise>已取消</c:otherwise>
                            </c:choose>
                        </span>
                </div>

                <div class="order-detail">
                    <div class="detail-item">
                        <div class="label">车辆信息</div>
                        <div class="value">${order.vehicle.plateNumber} - ${order.vehicle.model}</div>
                    </div>
                    <div class="detail-item">
                        <div class="label">服务类型</div>
                        <div class="value">
                            <c:choose>
                                <c:when test="${order.serviceType == 'maintenance'}">保养</c:when>
                                <c:when test="${order.serviceType == 'repair'}">维修</c:when>
                                <c:otherwise>检测</c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                    <div class="detail-item">
                        <div class="label">预约时间</div>
                        <div class="value"><fmt:formatDate value="${order.appointmentTime}" pattern="yyyy-MM-dd HH:mm"/></div>
                    </div>
                    <div class="detail-item">
                        <div class="label">服务费用</div>
                        <div class="value">¥${order.amount == null ? '待核算' : order.amount}</div>
                    </div>
                </div>

                <div class="order-actions">
                    <a href="${pageContext.request.contextPath}/owner/order/detail/${order.id}" class="btn btn-outline">查看详情</a>
                    <c:if test="${order.status == 'completed'}">
                        <a href="${pageContext.request.contextPath}/owner/evaluate/${order.id}" class="btn">评价服务</a>
                    </c:if>
                </div>
            </div>
        </c:forEach>
    </div>
</div>

<script>
    function filterOrders() {
        var status = document.getElementById('statusFilter').value;
        var orders = document.getElementsByClassName('order-item');

        for (var i = 0; i < orders.length; i++) {
            if (status == 'all' || orders[i].getAttribute('data-status') == status) {
                orders[i].style.display = 'block';
            } else {
                orders[i].style.display = 'none';
            }
        }
    }
</script>
</body>
</html>