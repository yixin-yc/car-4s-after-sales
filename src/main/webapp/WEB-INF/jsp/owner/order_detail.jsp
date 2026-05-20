<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
  <title>订单详情 - 汽车4S店售后管理系统</title>
  <style>
    * {
      margin: 0;
      padding: 0;
      box-sizing: border-box;
    }
    body {
      font-family: 'Microsoft YaHei', Arial, sans-serif;
      background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
      min-height: 100vh;
      padding: 30px;
    }
    .container {
      max-width: 800px;
      margin: 0 auto;
    }
    .detail-card {
      background: white;
      border-radius: 10px;
      box-shadow: 0 15px 35px rgba(0,0,0,0.2);
      padding: 30px;
    }
    .header {
      display: flex;
      justify-content: space-between;
      align-items: center;
      margin-bottom: 20px;
      padding-bottom: 15px;
      border-bottom: 2px solid #667eea;
    }
    .header h2 {
      color: #333;
    }
    .back-link {
      color: #667eea;
      text-decoration: none;
    }
    .order-status {
      display: inline-block;
      padding: 5px 15px;
      border-radius: 20px;
      font-size: 14px;
      font-weight: 500;
      margin-bottom: 20px;
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
    .info-section {
      background: #f8f9fa;
      padding: 20px;
      border-radius: 5px;
      margin-bottom: 20px;
    }
    .info-section h3 {
      color: #333;
      margin-bottom: 15px;
      font-size: 16px;
      border-left: 3px solid #667eea;
      padding-left: 10px;
    }
    .info-grid {
      display: grid;
      grid-template-columns: repeat(2, 1fr);
      gap: 15px;
    }
    .info-item .label {
      color: #999;
      font-size: 13px;
      margin-bottom: 3px;
    }
    .info-item .value {
      color: #333;
      font-size: 16px;
      font-weight: 500;
    }
    .service-content {
      background: white;
      padding: 15px;
      border-radius: 5px;
      margin-top: 10px;
      line-height: 1.6;
    }
    .btn {
      display: inline-block;
      padding: 10px 25px;
      background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
      color: white;
      text-decoration: none;
      border-radius: 5px;
      border: none;
      cursor: pointer;
      font-size: 14px;
      transition: all 0.3s;
    }
    .btn:hover {
      transform: translateY(-2px);
      box-shadow: 0 5px 15px rgba(102,126,234,0.4);
    }
    .btn-secondary {
      background: #95a5a6;
    }
    .btn-secondary:hover {
      background: #7f8c8d;
    }
    .btn-danger {
      background: #f44336;
    }
    .btn-danger:hover {
      background: #da190b;
    }
    .button-group {
      display: flex;
      gap: 10px;
      justify-content: flex-end;
      margin-top: 20px;
    }
    .evaluation-section {
      background: #f8f9fa;
      padding: 20px;
      border-radius: 5px;
      margin-top: 20px;
    }
    .rating {
      color: #ffd700;
      font-size: 20px;
      margin-bottom: 10px;
    }
    .rating-text {
      color: #333;
      margin-bottom: 10px;
    }
    .rating-time {
      color: #999;
      font-size: 12px;
      text-align: right;
    }
    .order-no {
      color: #667eea;
      font-size: 18px;
      font-weight: 600;
    }
    .error-message {
      text-align: center;
      padding: 50px;
      color: #999;
    }
  </style>
</head>
<body>
<div class="container">
  <div class="detail-card">
    <div class="header">
      <h2>订单详情</h2>
      <a href="${pageContext.request.contextPath}/owner/orders" class="back-link">← 返回列表</a>
    </div>

    <c:if test="${not empty order}">
      <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px;">
        <span class="order-no">${order.orderNo}</span>
        <span class="order-status status-${order.status}">
                        <c:choose>
                          <c:when test="${order.status == 'pending'}">待处理</c:when>
                          <c:when test="${order.status == 'processing'}">处理中</c:when>
                          <c:when test="${order.status == 'completed'}">已完成</c:when>
                          <c:otherwise>已取消</c:otherwise>
                        </c:choose>
                    </span>
      </div>

      <!-- 车主信息 -->
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

      <!-- 车辆信息 -->
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
          <c:if test="${not empty order.vehicle.purchaseDate}">
            <div class="info-item">
              <div class="label">购买时间</div>
              <div class="value"><fmt:formatDate value="${order.vehicle.purchaseDate}" pattern="yyyy-MM-dd"/></div>
            </div>
          </c:if>
        </div>
      </div>

      <!-- 服务信息 -->
      <div class="info-section">
        <h3>服务信息</h3>
        <div class="info-grid">
          <div class="info-item">
            <div class="label">服务类型</div>
            <div class="value">
              <c:choose>
                <c:when test="${order.serviceType == 'maintenance'}">保养</c:when>
                <c:when test="${order.serviceType == 'repair'}">维修</c:when>
                <c:when test="${order.serviceType == 'inspection'}">检测</c:when>
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
          <div class="service-content">
              ${order.serviceContent}
          </div>
        </div>
      </div>

      <!-- 评价信息（如果已完成且有评价） -->
      <c:if test="${order.status == 'completed' and not empty evaluation}">
        <div class="evaluation-section">
          <h3>服务评价</h3>
          <div class="rating">
            <c:forEach begin="1" end="5" var="i">
              <c:choose>
                <c:when test="${i <= evaluation.rating}">★</c:when>
                <c:otherwise>☆</c:otherwise>
              </c:choose>
            </c:forEach>
          </div>
          <div class="rating-text">${evaluation.comment}</div>
          <div class="rating-time">
            评价时间：<fmt:formatDate value="${evaluation.createTime}" pattern="yyyy-MM-dd HH:mm"/>
          </div>
        </div>
      </c:if>

      <div class="button-group">
        <a href="${pageContext.request.contextPath}/owner/orders" class="btn btn-secondary">返回列表</a>
        <c:if test="${order.status == 'pending'}">
          <a href="#" onclick="cancelOrder(${order.id})" class="btn btn-danger">取消订单</a>
        </c:if>
        <c:if test="${order.status == 'completed' and empty evaluation}">
          <a href="${pageContext.request.contextPath}/owner/evaluate/${order.id}" class="btn">评价服务</a>
        </c:if>
      </div>
    </c:if>

    <c:if test="${empty order}">
      <div class="error-message">
        <p style="font-size: 18px; margin-bottom: 20px;">❌ 订单不存在或已被删除</p>
        <a href="${pageContext.request.contextPath}/owner/orders" class="btn">返回订单列表</a>
      </div>
    </c:if>
  </div>
</div>

<script>
  function cancelOrder(id) {
    if (confirm('确定要取消这个订单吗？')) {
      // 这里需要实现取消订单的功能
      alert('取消订单功能开发中');
      // window.location.href = '${pageContext.request.contextPath}/owner/order/cancel/' + id;
    }
  }
</script>
</body>
</html>