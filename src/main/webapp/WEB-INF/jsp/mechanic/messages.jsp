<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <title>留言回复 - 汽车4S店售后管理系统</title>
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
            border: 1px solid rgba(255, 255, 255, 0.3);
            border-radius: 4px;
        }

        .nav {
            background: white;
            padding: 0 30px;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.05);
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

        .message-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
        }

        .message-section {
            background: white;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
            padding: 20px;
        }

        .message-section h3 {
            color: #333;
            margin-bottom: 15px;
            padding-bottom: 10px;
            border-bottom: 2px solid #667eea;
        }

        .message-list {
            max-height: 600px;
            overflow-y: auto;
        }

        .message-item {
            padding: 15px;
            border-bottom: 1px solid #eee;
            cursor: pointer;
            transition: all 0.3s;
        }

        .message-item:hover {
            background: #f8f9fa;
        }

        .message-item.selected {
            background: #e8f0fe;
            border-left: 3px solid #667eea;
        }

        .message-header {
            display: flex;
            justify-content: space-between;
            margin-bottom: 5px;
        }

        .message-title {
            font-weight: 600;
            color: #333;
        }

        .message-time {
            color: #999;
            font-size: 12px;
        }

        .message-owner {
            color: #667eea;
            font-size: 13px;
            margin-bottom: 5px;
        }

        .message-preview {
            color: #666;
            font-size: 13px;
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
        }

        .status-badge {
            display: inline-block;
            padding: 2px 8px;
            border-radius: 12px;
            font-size: 11px;
            font-weight: 500;
            margin-left: 5px;
        }

        .status-unreplied {
            background: #fff3cd;
            color: #856404;
        }

        .reply-section {
            background: white;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
            padding: 20px;
            margin-top: 20px;
        }

        .reply-section h3 {
            color: #333;
            margin-bottom: 15px;
        }

        .selected-message {
            background: #f8f9fa;
            padding: 15px;
            border-radius: 5px;
            margin-bottom: 20px;
        }

        .selected-message .content {
            color: #666;
            line-height: 1.6;
            margin-top: 10px;
        }

        .form-group {
            margin-bottom: 15px;
        }

        .form-group label {
            display: block;
            margin-bottom: 5px;
            color: #555;
        }

        .form-group textarea {
            width: 100%;
            padding: 12px;
            border: 2px solid #e1e1e1;
            border-radius: 5px;
            height: 150px;
            resize: vertical;
        }

        .form-group textarea:focus {
            border-color: #667eea;
            outline: none;
        }

        .btn {
            padding: 10px 25px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 14px;
        }

        .btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(102, 126, 234, 0.4);
        }

        .btn:disabled {
            background: #ccc;
            cursor: not-allowed;
        }

        .empty-message {
            text-align: center;
            padding: 30px;
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
    <a href="${pageContext.request.contextPath}/mechanic/messages" class="active">留言回复</a>
    <a href="${pageContext.request.contextPath}/mechanic/maintenance-reminder">保养提醒</a>
</div>

<div class="container">
    <div class="page-title">
        <h2>客户留言管理</h2>
    </div>

    <div class="message-grid">
        <!-- 待回复留言 -->
        <div class="message-section">
            <h3>待回复留言 <span style="color:#667eea;">(${unrepliedMessages.size()})</span></h3>
            <div class="message-list">
                <c:if test="${empty unrepliedMessages}">
                    <div class="empty-message">暂无待回复留言</div>
                </c:if>
                <c:forEach items="${unrepliedMessages}" var="msg">
                    <div class="message-item ${selectedMessage.id == msg.id ? 'selected' : ''}"
                         onclick="selectMessage(${msg.id}, '${msg.title}', '${msg.content}', ${msg.ownerId})">
                        <div class="message-header">
                            <span class="message-title">${msg.title}</span>
                            <span class="message-time"><fmt:formatDate value="${msg.createTime}"
                                                                       pattern="MM-dd HH:mm"/></span>
                        </div>
                        <div class="message-owner">${msg.owner.realName}</div>
                        <div class="message-preview">${msg.content}</div>
                    </div>
                </c:forEach>
            </div>
        </div>

        <!-- 全部留言 -->
        <div class="message-section">
            <h3>全部留言</h3>
            <div class="message-list">
                <c:if test="${empty allMessages}">
                    <div class="empty-message">暂无留言记录</div>
                </c:if>
                <c:forEach items="${allMessages}" var="msg">
                    <div class="message-item" onclick="viewMessage(${msg.id})">
                        <div class="message-header">
                            <span class="message-title">${msg.title}</span>
                            <span class="message-time"><fmt:formatDate value="${msg.createTime}"
                                                                       pattern="MM-dd HH:mm"/></span>
                        </div>
                        <div class="message-owner">${msg.owner.realName}</div>
                        <div class="message-preview">
                                ${msg.content}
                            <c:if test="${msg.status == 1}">
                                <span class="status-badge status-replied"
                                      style="background:#d4edda; color:#155724;">已回复</span>
                            </c:if>
                            <c:if test="${msg.status == 0}">
                                <span class="status-badge status-unreplied">待回复</span>
                            </c:if>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </div>
    </div>

    <!-- 回复区域 -->
    <div class="reply-section" id="replySection" style="display: none;">
        <h3>回复留言</h3>
        <div class="selected-message" id="selectedMessage">
            <div style="font-weight:600;" id="selectedTitle"></div>
            <div style="color:#667eea; font-size:13px; margin:5px 0;" id="selectedOwner"></div>
            <div class="content" id="selectedContent"></div>
        </div>

        <form action="${pageContext.request.contextPath}/mechanic/message/reply" method="post" id="replyForm">
            <input type="hidden" name="id" id="messageId">
            <div class="form-group">
                <label>回复内容：</label>
                <textarea name="reply" id="replyContent" required placeholder="请输入回复内容..."></textarea>
            </div>
            <button type="submit" class="btn">提交回复</button>
        </form>
    </div>

    <script>
        let currentMessageId = null;

        function selectMessage(id, title, content, ownerId) {
            currentMessageId = id;

            document.getElementById('replySection').style.display = 'block';
            document.getElementById('messageId').value = id;
            document.getElementById('selectedTitle').textContent = title;
            document.getElementById('selectedContent').textContent = content;

            // 高亮选中的消息
            document.querySelectorAll('.message-item').forEach(item => {
                item.classList.remove('selected');
            });
            event.currentTarget.classList.add('selected');
        }

        function viewMessage(id) {
            window.location.href = '${pageContext.request.contextPath}/mechanic/message/view/' + id;
        }
    </script>
</body>
</html>