<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
  <title>投诉建议 - 汽车4S店售后管理系统</title>
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
      max-width: 1000px;
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
      border: none;
      cursor: pointer;
      font-size: 14px;
    }
    .btn:hover {
      transform: translateY(-2px);
      box-shadow: 0 5px 15px rgba(102,126,234,0.4);
    }
    .complaint-list {
      background: white;
      border-radius: 10px;
      box-shadow: 0 2px 10px rgba(0,0,0,0.05);
      overflow: hidden;
    }
    .complaint-item {
      padding: 20px;
      border-bottom: 1px solid #eee;
    }
    .complaint-item:hover {
      background: #f8f9fa;
    }
    .complaint-header {
      display: flex;
      justify-content: space-between;
      align-items: center;
      margin-bottom: 10px;
    }
    .order-info {
      font-size: 14px;
      color: #667eea;
      margin-bottom: 5px;
    }
    .complaint-content {
      color: #666;
      margin-bottom: 15px;
      line-height: 1.6;
    }
    .complaint-reply {
      background: #f8f9fa;
      padding: 15px;
      border-radius: 5px;
      margin-top: 10px;
      border-left: 3px solid #4CAF50;
    }
    .reply-header {
      color: #4CAF50;
      font-weight: 500;
      margin-bottom: 5px;
    }
    .reply-content {
      color: #666;
    }
    .reply-time {
      color: #999;
      font-size: 12px;
      margin-top: 5px;
      text-align: right;
    }
    .status-badge {
      display: inline-block;
      padding: 3px 10px;
      border-radius: 20px;
      font-size: 12px;
      font-weight: 500;
    }
    .status-unhandled {
      background: #fff3cd;
      color: #856404;
    }
    .status-handled {
      background: #d4edda;
      color: #155724;
    }
    .complaint-time {
      color: #999;
      font-size: 13px;
    }
    .modal {
      display: none;
      position: fixed;
      z-index: 1000;
      left: 0;
      top: 0;
      width: 100%;
      height: 100%;
      background-color: rgba(0,0,0,0.5);
    }
    .modal-content {
      background: white;
      margin: 50px auto;
      padding: 30px;
      border-radius: 10px;
      width: 500px;
      max-width: 90%;
    }
    .modal-content h3 {
      margin-bottom: 20px;
      color: #333;
    }
    .form-group {
      margin-bottom: 15px;
    }
    .form-group label {
      display: block;
      margin-bottom: 5px;
      color: #555;
    }
    .form-group select,
    .form-group textarea {
      width: 100%;
      padding: 8px 12px;
      border: 1px solid #ddd;
      border-radius: 4px;
      font-size: 14px;
    }
    .form-group textarea {
      height: 150px;
      resize: vertical;
    }
    .form-actions {
      display: flex;
      justify-content: flex-end;
      gap: 10px;
      margin-top: 20px;
    }
    .btn-danger {
      background: #f44336;
    }
    .btn-danger:hover {
      background: #da190b;
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
  <a href="${pageContext.request.contextPath}/owner/orders">订单查询</a>
  <a href="${pageContext.request.contextPath}/owner/messages">留言咨询</a>
  <a href="${pageContext.request.contextPath}/owner/complaints" class="active">投诉建议</a>
</div>

<div class="container">
  <div class="page-title">
    <h2>我的投诉</h2>
    <button class="btn" onclick="showAddModal()">+ 新建投诉</button>
  </div>

  <div class="complaint-list">
    <c:if test="${empty complaints}">
      <div class="empty-message">
        暂无投诉记录
      </div>
    </c:if>

    <c:forEach items="${complaints}" var="complaint">
      <div class="complaint-item">
        <div class="complaint-header">
          <div>
                            <span class="status-badge ${complaint.status == 0 ? 'status-unhandled' : 'status-handled'}">
                                ${complaint.status == 0 ? '待处理' : '已处理'}
                            </span>
            <c:if test="${not empty complaint.order}">
              <span class="order-info">订单号：${complaint.order.orderNo}</span>
            </c:if>
          </div>
          <span class="complaint-time">
                            <fmt:formatDate value="${complaint.createTime}" pattern="yyyy-MM-dd HH:mm"/>
                        </span>
        </div>

        <div class="complaint-content">
            ${complaint.content}
        </div>

        <c:if test="${not empty complaint.reply}">
          <div class="complaint-reply">
            <div class="reply-header">处理回复：</div>
            <div class="reply-content">${complaint.reply}</div>
            <div class="reply-time">
              处理时间：<fmt:formatDate value="${complaint.handleTime}" pattern="yyyy-MM-dd HH:mm"/>
            </div>
          </div>
        </c:if>
      </div>
    </c:forEach>
  </div>
</div>

<!-- 新建投诉模态框 -->
<div id="addModal" class="modal">
  <div class="modal-content">
    <h3>新建投诉</h3>
    <form action="${pageContext.request.contextPath}/owner/complaint/add" method="post">
      <div class="form-group">
        <label>关联订单：</label>
        <select name="orderId">
          <option value="">请选择订单（可选）</option>
          <c:forEach items="${orders}" var="order">
            <option value="${order.id}">${order.orderNo} - ${order.vehicle.plateNumber}</option>
          </c:forEach>
        </select>
      </div>
      <div class="form-group">
        <label>投诉内容：</label>
        <textarea name="content" required placeholder="请详细描述您的投诉内容..."></textarea>
      </div>
      <div class="form-actions">
        <button type="button" class="btn btn-danger" onclick="hideAddModal()">取消</button>
        <button type="submit" class="btn">提交</button>
      </div>
    </form>
  </div>
</div>

<script>
  function showAddModal() {
    document.getElementById('addModal').style.display = 'block';
  }

  function hideAddModal() {
    document.getElementById('addModal').style.display = 'none';
  }

  window.onclick = function(event) {
    if (event.target == document.getElementById('addModal')) {
      hideAddModal();
    }
  }
</script>
</body>
</html>