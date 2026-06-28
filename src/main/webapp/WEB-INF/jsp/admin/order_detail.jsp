<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <title>订单详情 - 汽车4S店售后管理系统</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Microsoft YaHei', Arial, sans-serif; background-color: #f4f7fc; }
        .header { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; padding: 15px 30px; display: flex; justify-content: space-between; align-items: center; }
        .header h1 { font-size: 24px; }
        .user-info { display: flex; align-items: center; gap: 20px; }
        .user-info a { color: white; text-decoration: none; padding: 5px 15px; border: 1px solid rgba(255,255,255,0.3); border-radius: 4px; }
        .nav { background: white; padding: 0 30px; box-shadow: 0 2px 5px rgba(0,0,0,0.05); }
        .nav a { display: inline-block; color: #666; text-decoration: none; padding: 15px 25px; }
        .nav a:hover { color: #667eea; }
        .nav a.active { color: #667eea; border-bottom: 3px solid #667eea; }
        .container { padding: 30px; max-width: 900px; margin: 0 auto; }
        .detail-card { background: white; border-radius: 10px; box-shadow: 0 2px 10px rgba(0,0,0,0.05); padding: 30px; }
        .page-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; padding-bottom: 15px; border-bottom: 2px solid #667eea; }
        .page-header h2 { color: #333; }
        .back-link { color: #667eea; text-decoration: none; }
        .order-no { color: #667eea; font-size: 18px; font-weight: 600; }
        .status-badge { display: inline-block; padding: 5px 15px; border-radius: 20px; font-size: 14px; font-weight: 500; }
        .status-pending { background: #fff3cd; color: #856404; }
        .status-processing { background: #cce5ff; color: #004085; }
        .status-completed { background: #d4edda; color: #155724; }
        .info-section { background: #f8f9fa; padding: 20px; border-radius: 5px; margin-bottom: 20px; }
        .info-section h3 { color: #333; margin-bottom: 15px; font-size: 16px; border-left: 3px solid #667eea; padding-left: 10px; }
        .info-grid { display: grid; grid-template-columns: repeat(2, 1fr); gap: 15px; }
        .info-item .label { color: #999; font-size: 13px; margin-bottom: 3px; }
        .info-item .value { color: #333; font-size: 16px; font-weight: 500; }
        .service-content { background: white; padding: 15px; border-radius: 5px; margin-top: 10px; line-height: 1.6; }
        .btn { display: inline-block; padding: 10px 25px; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; text-decoration: none; border-radius: 5px; border: none; cursor: pointer; font-size: 14px; }
        .btn:hover { transform: translateY(-2px); box-shadow: 0 5px 15px rgba(102,126,234,0.4); }
        .btn-secondary { background: #95a5a6; }
        .btn-success { background: #28a745; }
        .button-group { display: flex; gap: 10px; justify-content: flex-end; margin-top: 20px; }
        .error-message { text-align: center; padding: 50px; color: #999; }
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
    <div class="detail-card">
        <div class="page-header">
            <h2>订单详情</h2>
            <a href="${pageContext.request.contextPath}/admin/orders" class="back-link">← 返回列表</a>
        </div>

        <c:if test="${not empty order}">
            <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px;">
                <span class="order-no">${order.orderNo}</span>
                <span class="status-badge status-${order.status}">
                    <c:choose>
                        <c:when test="${order.status == 'pending'}">待处理</c:when>
                        <c:when test="${order.status == 'processing'}">处理中</c:when>
                        <c:when test="${order.status == 'completed'}">已完成</c:when>
                    </c:choose>
                </span>
            </div>

            <div class="info-section">
                <h3>车主信息</h3>
                <div class="info-grid">
                    <div class="info-item">
                        <div class="label">姓名</div>
                        <div class="value">${order.owner.realName}</div>
                    </div>
                    <div class="info-item">
                        <div class="label">联系电话</div>
                        <div class="value">${order.owner.phone}</div>
                    </div>
                </div>
            </div>

            <div class="info-section">
                <h3>车辆信息</h3>
                <div class="info-grid">
                    <div class="info-item">
                        <div class="label">车牌号码</div>
                        <div class="value">${order.vehicle.plateNumber}</div>
                    </div>
                    <div class="info-item">
                        <div class="label">车型</div>
                        <div class="value">${order.vehicle.model}</div>
                    </div>
                    <div class="info-item">
                        <div class="label">VIN码</div>
                        <div class="value">${order.vehicle.vin}</div>
                    </div>
                </div>
            </div>

            <div class="info-section">
                <h3>服务信息</h3>
                <div class="info-grid">
                    <div class="info-item">
                        <div class="label">服务类型</div>
                        <div class="value">
                            <c:choose>
                                <c:when test="${order.serviceType == 'maintenance'}">保养</c:when>
                                <c:when test="${order.serviceType == 'repair'}">维修</c:when>
                                <c:otherwise>检测</c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                    <div class="info-item">
                        <div class="label">预约时间</div>
                        <div class="value"><fmt:formatDate value="${order.appointmentTime}" pattern="yyyy-MM-dd HH:mm"/></div>
                    </div>
                    <c:if test="${not empty order.mechanic}">
                        <div class="info-item">
                            <div class="label">维修师傅</div>
                            <div class="value">${order.mechanic.realName}</div>
                        </div>
                    </c:if>
                    <c:if test="${not empty order.amount}">
                        <div class="info-item">
                            <div class="label">服务费用</div>
                            <div class="value">¥${order.amount}</div>
                        </div>
                    </c:if>
                    <c:if test="${not empty order.createTime}">
                        <div class="info-item">
                            <div class="label">创建时间</div>
                            <div class="value"><fmt:formatDate value="${order.createTime}" pattern="yyyy-MM-dd HH:mm"/></div>
                        </div>
                    </c:if>
                    <c:if test="${not empty order.completeTime}">
                        <div class="info-item">
                            <div class="label">完成时间</div>
                            <div class="value"><fmt:formatDate value="${order.completeTime}" pattern="yyyy-MM-dd HH:mm"/></div>
                        </div>
                    </c:if>
                </div>
                <div style="margin-top: 15px;">
                    <div class="label">服务内容描述</div>
                    <div class="service-content">${order.serviceContent}</div>
                </div>
            </div>

            <div class="button-group">
                <a href="${pageContext.request.contextPath}/admin/orders" class="btn btn-secondary">返回列表</a>
                <c:if test="${order.status == 'processing'}">
                    <a href="#" onclick="completeOrder(${order.id})" class="btn btn-success">完成订单</a>
                </c:if>
            </div>
        </c:if>

        <c:if test="${empty order}">
            <div class="error-message">
                <p style="font-size: 18px; margin-bottom: 20px;">❌ 订单不存在</p>
                <a href="${pageContext.request.contextPath}/admin/orders" class="btn">返回订单列表</a>
            </div>
        </c:if>
    </div>
</div>

<script>
    function completeOrder(id) {
        if (confirm('确定要将该订单标记为已完成吗？')) {
            window.location.href = '${pageContext.request.contextPath}/admin/order/complete/' + id;
        }
    }
</script>
</body>
</html>
