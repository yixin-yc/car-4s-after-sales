<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
    <title>保养提醒 - 汽车4S店售后管理系统</title>
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
        .stats-card {
            background: white;
            padding: 20px;
            border-radius: 10px;
            margin-bottom: 20px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.05);
        }
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 20px;
        }
        .stat-item {
            text-align: center;
        }
        .stat-number {
            font-size: 36px;
            font-weight: 700;
            color: #667eea;
        }
        .stat-label {
            color: #999;
            margin-top: 5px;
        }
        .reminder-list {
            background: white;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.05);
            overflow: hidden;
        }
        .reminder-header {
            display: grid;
            grid-template-columns: 2fr 2fr 1fr 2fr 1fr 1fr;
            background: #f8f9fa;
            padding: 15px;
            font-weight: 600;
            color: #555;
        }
        .reminder-item {
            display: grid;
            grid-template-columns: 2fr 2fr 1fr 2fr 1fr 1fr;
            padding: 15px;
            border-bottom: 1px solid #eee;
            align-items: center;
        }
        .reminder-item:hover {
            background: #f8f9fa;
        }
        .reminder-item.urgent {
            background: #fff3cd;
        }
        .reminder-item.warning {
            background: #fff8e7;
        }
        .plate-number {
            font-weight: 600;
            color: #333;
        }
        .owner-info {
            color: #666;
        }
        .last-maintenance {
            color: #666;
        }
        .days-badge {
            display: inline-block;
            padding: 5px 10px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 500;
        }
        .days-overdue {
            background: #f44336;
            color: white;
        }
        .days-urgent {
            background: #ff9800;
            color: white;
        }
        .days-warning {
            background: #ffc107;
            color: #333;
        }
        .days-normal {
            background: #4caf50;
            color: white;
        }
        .filter-bar {
            background: white;
            padding: 15px;
            border-radius: 10px;
            margin-bottom: 20px;
            display: flex;
            gap: 15px;
            align-items: center;
        }
        .filter-bar select {
            padding: 8px 15px;
            border: 1px solid #ddd;
            border-radius: 5px;
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
    <a href="${pageContext.request.contextPath}/mechanic/orders">订单管理</a>
    <a href="${pageContext.request.contextPath}/mechanic/messages">留言回复</a>
    <a href="${pageContext.request.contextPath}/mechanic/maintenance-reminder" class="active">保养提醒</a>
</div>

<div class="container">
    <div class="page-title">
        <h2>车辆保养提醒</h2>
    </div>

    <div class="stats-card">
        <div class="stats-grid">
            <div class="stat-item">
                <div class="stat-number">${urgentCount}</div>
                <div class="stat-label">急需保养 (已过期)</div>
            </div>
            <div class="stat-item">
                <div class="stat-number">${warningCount}</div>
                <div class="stat-label">即将到期 (7天内)</div>
            </div>
            <div class="stat-item">
                <div class="stat-number">${normalCount}</div>
                <div class="stat-label">正常</div>
            </div>
        </div>
    </div>

    <div class="filter-bar">
        <label>筛选：</label>
        <select id="statusFilter" onchange="filterReminders()">
            <option value="all">全部车辆</option>
            <option value="urgent">急需保养</option>
            <option value="warning">即将到期</option>
            <option value="normal">正常</option>
            <option value="unknown">未设置</option>
        </select>
    </div>

    <div class="reminder-list">
        <div class="reminder-header">
            <div>车牌号码</div>
            <div>车主信息</div>
            <div>车型</div>
            <div>上次保养</div>
            <div>保养周期</div>
            <div>状态</div>
        </div>

        <c:if test="${empty vehicles}">
            <div class="empty-message">暂无车辆信息</div>
        </c:if>

        <c:forEach items="${vehicles}" var="vehicle">
            <c:if test="${not empty vehicle.lastMaintenance}">
                <jsp:useBean id="now" class="java.util.Date" />

                <%-- 计算距离上次保养的天数 --%>
                <c:set var="millisPerDay" value="${24 * 60 * 60 * 1000}" />
                <c:set var="daysSinceLastMaintenance" value="${(now.time - vehicle.lastMaintenance.time) / millisPerDay}" />

                <%-- 计算下次保养日期 --%>
                <c:set var="nextMaintenanceMillis" value="${vehicle.lastMaintenance.time + (vehicle.maintenanceCycle * 30 * millisPerDay)}" />
                <c:set var="daysUntilNextMaintenance" value="${(nextMaintenanceMillis - now.time) / millisPerDay}" />

                <%-- 取整处理 --%>
                <fmt:formatNumber value="${daysUntilNextMaintenance}" pattern="#" var="roundedDaysUntilNext" />
                <fmt:formatNumber value="${-daysUntilNextMaintenance}" pattern="#" var="roundedDaysOverdue" />

                <c:choose>
                    <c:when test="${daysUntilNextMaintenance < 0}">
                        <c:set var="status" value="已过期 ${roundedDaysOverdue}天" />
                        <c:set var="statusClass" value="reminder-item urgent" />
                        <c:set var="dataStatus" value="urgent" />
                    </c:when>
                    <c:when test="${daysUntilNextMaintenance <= 7}">
                        <c:set var="status" value="即将到期 ${roundedDaysUntilNext}天" />
                        <c:set var="statusClass" value="reminder-item warning" />
                        <c:set var="dataStatus" value="warning" />
                    </c:when>
                    <c:otherwise>
                        <c:set var="status" value="正常" />
                        <c:set var="statusClass" value="reminder-item" />
                        <c:set var="dataStatus" value="normal" />
                    </c:otherwise>
                </c:choose>
            </c:if>
            <c:if test="${empty vehicle.lastMaintenance}">
                <c:set var="status" value="未设置" />
                <c:set var="statusClass" value="reminder-item" />
                <c:set var="dataStatus" value="unknown" />
            </c:if>

            <div class="${statusClass}" data-status="${dataStatus}">
                <div class="plate-number">${vehicle.plateNumber}</div>
                <div class="owner-info">${vehicle.owner.realName}<br>${vehicle.owner.phone}</div>
                <div>${vehicle.model}</div>
                <div class="last-maintenance">
                    <c:if test="${not empty vehicle.lastMaintenance}">
                        <fmt:formatDate value="${vehicle.lastMaintenance}" pattern="yyyy-MM-dd"/>
                    </c:if>
                    <c:if test="${empty vehicle.lastMaintenance}">
                        未记录
                    </c:if>
                </div>
                <div>${vehicle.maintenanceCycle}个月</div>
                <div>
                        <span class="days-badge
                            ${statusClass == 'reminder-item urgent' ? 'days-overdue' :
                              (statusClass == 'reminder-item warning' ? 'days-warning' :
                                (dataStatus == 'unknown' ? '' : 'days-normal'))}">
                                ${status}
                        </span>
                </div>
            </div>
        </c:forEach>
    </div>
</div>

<script>
    function filterReminders() {
        var filter = document.getElementById('statusFilter').value;
        var reminders = document.querySelectorAll('.reminder-item');

        reminders.forEach(function(item) {
            if (filter == 'all' || item.getAttribute('data-status') == filter) {
                item.style.display = 'grid';
            } else {
                item.style.display = 'none';
            }
        });
    }
</script>
</body>
</html>