<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <title>订单管理 - 汽车4S店售后管理系统</title>
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
        .tab-bar {
            display: flex;
            gap: 10px;
            margin-bottom: 20px;
        }
        .tab {
            padding: 10px 25px;
            background: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 15px;
            color: #666;
            transition: all 0.3s;
        }
        .tab:hover {
            background: #667eea;
            color: white;
        }
        .tab.active {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
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
        .order-detail {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 15px;
            margin-bottom: 15px;
        }
        .detail-item .label {
            font-size: 13px;
            color: #999;
            margin-bottom: 3px;
        }
        .detail-item .value {
            font-size: 15px;
            font-weight: 500;
            color: #333;
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
        <span>欢迎，${sessionScope.user.realName} (维修人员)</span>
        <a href="${pageContext.request.contextPath}/logout">退出</a>
    </div>
</div>

<div class="nav">
    <a href="${pageContext.request.contextPath}/mechanic/dashboard">首页</a>
    <a href="${pageContext.request.contextPath}/mechanic/orders" class="active">订单管理</a>
    <a href="${pageContext.request.contextPath}/mechanic/messages">留言回复</a>
    <a href="${pageContext.request.contextPath}/mechanic/maintenance-reminder">保养提醒</a>
</div>

<div class="container">
    <div class="page-title">
        <h2>订单管理</h2>
    </div>

    <div class="tab-bar">
        <button class="tab active" onclick="showTab('pending')">待接单</button>
        <button class="tab" onclick="showTab('processing')">处理中</button>
        <button class="tab" onclick="showTab('completed')">已完成</button>
        <button class="tab" onclick="showTab('my')">我的订单</button>
    </div>

    <!-- 待接单列表 -->
    <div id="pendingTab" class="order-list" style="display: block;">
        <c:if test="${empty pendingOrders}">
            <div class="empty-message">暂无待接单的订单</div>
        </c:if>
        <c:forEach items="${pendingOrders}" var="order">
            <div class="order-item">
                <div class="order-header">
                    <span class="order-no">${order.orderNo}</span>
                    <span class="order-status status-pending">待接单</span>
                </div>
                <div class="order-detail">
                    <div class="detail-item">
                        <div class="label">车主</div>
                        <div class="value">${order.owner.realName} (${order.owner.phone})</div>
                    </div>
                    <div class="detail-item">
                        <div class="label">车辆</div>
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
                </div>
                <div class="order-actions">
                    <a href="${pageContext.request.contextPath}/mechanic/order/accept/${order.id}" class="btn">接单</a>
                </div>
            </div>
        </c:forEach>
    </div>

    <!-- 处理中列表 -->
    <div id="processingTab" class="order-list" style="display: none;">
        <c:if test="${empty processingOrders}">
            <div class="empty-message">暂无处理中的订单</div>
        </c:if>
        <c:forEach items="${processingOrders}" var="order">
            <div class="order-item">
                <div class="order-header">
                    <span class="order-no">${order.orderNo}</span>
                    <span class="order-status status-processing">处理中</span>
                </div>
                <div class="order-detail">
                    <div class="detail-item">
                        <div class="label">车主</div>
                        <div class="value">${order.owner.realName} (${order.owner.phone})</div>
                    </div>
                    <div class="detail-item">
                        <div class="label">车辆</div>
                        <div class="value">${order.vehicle.plateNumber} - ${order.vehicle.model}</div>
                    </div>
                    <div class="detail-item">
                        <div class="label">服务内容</div>
                        <div class="value">${order.serviceContent}</div>
                    </div>
                </div>
                <div class="order-actions">
                    <a href="${pageContext.request.contextPath}/mechanic/order/process/${order.id}" class="btn">处理</a>
                </div>
            </div>
        </c:forEach>
    </div>

    <!-- 已完成列表 -->
    <div id="completedTab" class="order-list" style="display: none;">
        <c:if test="${empty completedOrders}">
            <div class="empty-message">暂无已完成订单</div>
        </c:if>
        <c:forEach items="${completedOrders}" var="order">
            <div class="order-item">
                <div class="order-header">
                    <span class="order-no">${order.orderNo}</span>
                    <span class="order-status status-completed">已完成</span>
                </div>
                <div class="order-detail">
                    <div class="detail-item">
                        <div class="label">车主</div>
                        <div class="value">${order.owner.realName}</div>
                    </div>
                    <div class="detail-item">
                        <div class="label">车辆</div>
                        <div class="value">${order.vehicle.plateNumber}</div>
                    </div>
                    <div class="detail-item">
                        <div class="label">服务费用</div>
                        <div class="value">¥${order.amount}</div>
                    </div>
                    <div class="detail-item">
                        <div class="label">完成时间</div>
                        <div class="value"><fmt:formatDate value="${order.completeTime}" pattern="yyyy-MM-dd HH:mm"/></div>
                    </div>
                </div>
            </div>
        </c:forEach>
    </div>

    <!-- 我的订单列表 -->
    <div id="myTab" class="order-list" style="display: none;">
        <c:if test="${empty myOrders}">
            <div class="empty-message">暂无订单</div>
        </c:if>
        <c:forEach items="${myOrders}" var="order">
            <div class="order-item">
                <div class="order-header">
                    <span class="order-no">${order.orderNo}</span>
                    <span class="order-status status-${order.status}">
                            <c:choose>
                                <c:when test="${order.status == 'pending'}">待接单</c:when>
                                <c:when test="${order.status == 'processing'}">处理中</c:when>
                                <c:when test="${order.status == 'completed'}">已完成</c:when>
                            </c:choose>
                        </span>
                </div>
                <div class="order-detail">
                    <div class="detail-item">
                        <div class="label">车主</div>
                        <div class="value">${order.owner.realName}</div>
                    </div>
                    <div class="detail-item">
                        <div class="label">车辆</div>
                        <div class="value">${order.vehicle.plateNumber}</div>
                    </div>
                    <div class="detail-item">
                        <div class="label">服务类型</div>
                        <div class="value">${order.serviceType}</div>
                    </div>
                </div>
                <div class="order-actions">
                    <c:if test="${order.status == 'processing'}">
                        <a href="${pageContext.request.contextPath}/mechanic/order/process/${order.id}" class="btn">处理</a>
                    </c:if>
                </div>
            </div>
        </c:forEach>
    </div>
</div>

<script>
    function showTab(tabName) {
        var tabs = document.querySelectorAll('.tab');
        var tabContents = document.querySelectorAll('.order-list');

        tabs.forEach(tab => tab.classList.remove('active'));
        tabContents.forEach(content => content.style.display = 'none');

        event.target.classList.add('active');
        document.getElementById(tabName + 'Tab').style.display = 'block';
    }
</script>
</body>
</html>