<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
  <title>留言详情 - 汽车4S店售后管理系统</title>
  <style>
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
    .message-card {
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
    .back-link {
      color: #667eea;
      text-decoration: none;
    }
    .message-info {
      background: #f8f9fa;
      padding: 20px;
      border-radius: 5px;
      margin-bottom: 20px;
    }
    .info-item {
      margin-bottom: 10px;
    }
    .label {
      color: #999;
      font-size: 13px;
      margin-bottom: 3px;
    }
    .value {
      color: #333;
      font-size: 16px;
    }
    .message-content {
      background: white;
      padding: 20px;
      border-radius: 5px;
      margin: 20px 0;
      line-height: 1.6;
    }
    .reply-form {
      margin-top: 20px;
      padding: 20px;
      background: #f8f9fa;
      border-radius: 5px;
    }
    .reply-form textarea {
      width: 100%;
      padding: 10px;
      border: 1px solid #ddd;
      border-radius: 5px;
      height: 150px;
      margin-bottom: 10px;
    }
    .btn {
      padding: 10px 25px;
      background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
      color: white;
      border: none;
      border-radius: 5px;
      cursor: pointer;
    }
  </style>
</head>
<body>
<div class="container">
  <div class="message-card">
    <div class="header">
      <h2>留言详情</h2>
      <a href="${pageContext.request.contextPath}/mechanic/messages" class="back-link">← 返回列表</a>
    </div>

    <div class="message-info">
      <div class="info-item">
        <div class="label">留言用户</div>
        <div class="value">${message.owner.realName} (${message.owner.phone})</div>
      </div>
      <div class="info-item">
        <div class="label">留言时间</div>
        <div class="value"><fmt:formatDate value="${message.createTime}" pattern="yyyy-MM-dd HH:mm"/></div>
      </div>
      <div class="info-item">
        <div class="label">状态</div>
        <div class="value">
          <c:choose>
            <c:when test="${message.status == 0}">待回复</c:when>
            <c:otherwise>已回复</c:otherwise>
          </c:choose>
        </div>
      </div>
    </div>

    <h3>${message.title}</h3>
    <div class="message-content">
      ${message.content}
    </div>

    <c:if test="${message.status == 0}">
      <div class="reply-form">
        <h4>回复留言</h4>
        <form action="${pageContext.request.contextPath}/mechanic/message/reply" method="post">
          <input type="hidden" name="id" value="${message.id}">
          <textarea name="reply" required placeholder="请输入回复内容..."></textarea>
          <button type="submit" class="btn">提交回复</button>
        </form>
      </div>
    </c:if>

    <c:if test="${message.status == 1}">
      <div style="background: #d4edda; padding: 15px; border-radius: 5px;">
        <h4>已回复</h4>
        <p>${message.reply}</p>
        <p style="color:#999; font-size:12px;">回复时间：<fmt:formatDate value="${message.replyTime}" pattern="yyyy-MM-dd HH:mm"/></p>
      </div>
    </c:if>
  </div>
</div>
</body>
</html>