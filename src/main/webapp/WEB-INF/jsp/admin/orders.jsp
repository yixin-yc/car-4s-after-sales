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
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }
        .page-title h2 {
            color: #333;
        }
        .btn {
            display: inline-block;
            padding: 10px 20px;
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
        .filter-bar {
            background: white;
            padding: 15px;
            border-radius: 10px;
            margin-bottom: 20px;
            display: flex;
            gap: 15px;
            align-items: center;
            flex-wrap: wrap;
        }
        .filter-bar select,
        .filter-bar input {
            padding: 8px 15px;
            border: 1px solid #ddd;
            border-radius: 5px;
        }
        .filter-bar .date-range {
            display: flex;
            gap: 5px;
            align-items: center;
        }
        .orders-table {
            background: white;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.05);
            overflow: hidden;
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
        .action-links a {
            margin: 0 5px;
            color: #667eea;
            text-decoration: none;
        }
        .pagination {
            display: flex;
            justify-content: center;
            gap: 10px;
            margin-top: 20px;
        }
        .pagination a {
            padding: 8px 12px;
            background: white;
            color: #667eea;
            text-decoration: none;
            border-radius: 5px;
        }
        .pagination a.active {
            background: #667eea;
            color: white;
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
    <a href="${pageContext.request.contextPath}/admin/dashboard">首页</a>
    <a href="${pageContext.request.contextPath}/admin/users">用户管理</a>
    <a href="${pageContext.request.contextPath}/admin/parts">配件管理</a>
    <a href="${pageContext.request.contextPath}/admin/orders" class="active">订单管理</a>
    <a href="${pageContext.request.contextPath}/admin/complaints">投诉处理</a>
    <a href="${pageContext.request.contextPath}/admin/messages">留言管理</a>
</div>

<div class="container">
    <div class="page-title">
        <h2>订单管理</h2>
        <a href="${pageContext.request.contextPath}/admin/order/statistics" class="btn">查看统计</a>
    </div>

    <div class="filter-bar">
        <select id="statusFilter" onchange="filterOrders()">
            <option value="">全部状态</option>
            <option value="pending">待处理</option>
            <option value="processing">处理中</option>
            <option value="completed">已完成</option>
        </select>

        <input type="text" id="searchInput" placeholder="搜索订单号、车主、车牌" onkeyup="filterOrders()">

        <div class="date-range">
            <input type="date" id="startDate" onchange="filterOrders()">
            <span>至</span>
            <input type="date" id="endDate" onchange="filterOrders()">
        </div>
    </div>

    <div class="orders-table">
        <c:if test="${empty orders}">
            <div style="text-align: center; padding: 50px; color: #999;">
                暂无订单数据
            </div>
        </c:if>
        <c:if test="${not empty orders}">
            <table id="ordersTable">
                <thead>
                <tr>
                    <th>订单号</th>
                    <th>车主</th>
                    <th>车辆</th>
                    <th>服务类型</th>
                    <th>维修人员</th>
                    <th>预约时间</th>
                    <th>金额</th>
                    <th>状态</th>
                    <th>操作</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach items="${orders}" var="order">
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
                        <td>${order.mechanic.realName}</td>
                        <td><fmt:formatDate value="${order.appointmentTime}" pattern="yyyy-MM-dd HH:mm"/></td>
                        <td>¥${order.amount}</td>
                        <td>
                                    <span class="status-badge status-${order.status}">
                                        <c:choose>
                                            <c:when test="${order.status == 'pending'}">待处理</c:when>
                                            <c:when test="${order.status == 'processing'}">处理中</c:when>
                                            <c:when test="${order.status == 'completed'}">已完成</c:when>
                                        </c:choose>
                                    </span>
                        </td>
                        <td class="action-links">
                            <a href="#" onclick="viewOrder(${order.id})">查看</a>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </c:if>
    </div>
</div>

<script>
    function filterOrders() {
        var status = document.getElementById('statusFilter').value;
        var searchText = document.getElementById('searchInput').value.toUpperCase();
        var startDate = document.getElementById('startDate').value;
        var endDate = document.getElementById('endDate').value;

        var table = document.getElementById('ordersTable');
        if (!table) return;

        var tr = table.getElementsByTagName('tr');

        for (var i = 1; i < tr.length; i++) {
            var show = true;

            // 状态筛选
            if (status) {
                var statusSpan = tr[i].getElementsByClassName('status-badge')[0];
                if (statusSpan && !statusSpan.className.includes(status)) {
                    show = false;
                }
            }

            // 搜索筛选
            if (show && searchText) {
                var found = false;
                var tds = tr[i].getElementsByTagName('td');
                for (var j = 0; j < 3; j++) { // 搜索订单号、车主、车牌
                    if (tds[j] && tds[j].textContent.toUpperCase().indexOf(searchText) > -1) {
                        found = true;
                        break;
                    }
                }
                show = found;
            }

            tr[i].style.display = show ? '' : 'none';
        }
    }

    function viewOrder(id) {
        window.location.href = '${pageContext.request.contextPath}/admin/order/detail/' + id;
    }
</script>
</body>
</html>