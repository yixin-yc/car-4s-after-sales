<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <title>留言管理 - 汽车4S店售后管理系统</title>
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
        }
        .tab:hover {
            background: #667eea;
            color: white;
        }
        .tab.active {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }
        .message-list {
            background: white;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.05);
            overflow: hidden;
        }
        .message-item {
            padding: 20px;
            border-bottom: 1px solid #eee;
        }
        .message-item:hover {
            background: #f8f9fa;
        }
        .message-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 10px;
        }
        .message-user {
            font-weight: 600;
            color: #333;
        }
        .message-time {
            color: #999;
            font-size: 13px;
        }
        .message-title {
            font-size: 16px;
            font-weight: 500;
            color: #333;
            margin-bottom: 10px;
        }
        .message-content {
            color: #666;
            margin-bottom: 15px;
            line-height: 1.6;
        }
        .message-reply {
            background: #f8f9fa;
            padding: 15px;
            border-radius: 5px;
            margin-top: 10px;
            border-left: 3px solid #667eea;
        }
        .reply-header {
            color: #667eea;
            font-weight: 500;
            margin-bottom: 5px;
        }
        .status-badge {
            display: inline-block;
            padding: 3px 10px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 500;
            margin-left: 10px;
        }
        .status-unreplied {
            background: #fff3cd;
            color: #856404;
        }
        .status-replied {
            background: #d4edda;
            color: #155724;
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
        .btn-small {
            padding: 5px 15px;
            font-size: 13px;
        }
        .btn-danger {
            background: #f44336;
        }
        .reply-form {
            margin-top: 15px;
            padding: 15px;
            background: #f8f9fa;
            border-radius: 5px;
            display: none;
        }
        .reply-form textarea {
            width: 100%;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 5px;
            height: 100px;
            margin-bottom: 10px;
        }
        .reply-actions {
            display: flex;
            gap: 10px;
            justify-content: flex-end;
        }
        .message-actions {
            margin-top: 10px;
            text-align: right;
        }
        .message-actions a {
            color: #f44336;
            text-decoration: none;
            font-size: 13px;
            margin-left: 15px;
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
        <span>欢迎，${sessionScope.user.realName} (管理员)</span>
        <a href="${pageContext.request.contextPath}/logout">退出</a>
    </div>
</div>

<div class="nav">
    <a href="${pageContext.request.contextPath}/admin/dashboard">首页</a>
    <a href="${pageContext.request.contextPath}/admin/users">用户管理</a>
    <a href="${pageContext.request.contextPath}/admin/parts">配件管理</a>
    <a href="${pageContext.request.contextPath}/admin/orders">订单管理</a>
    <a href="${pageContext.request.contextPath}/admin/complaints">投诉处理</a>
    <a href="${pageContext.request.contextPath}/admin/messages" class="active">留言管理</a>
</div>

<div class="container">
    <div class="page-title">
        <h2>留言管理</h2>
    </div>

    <div class="tab-bar">
        <button class="tab active" onclick="showTab('unreplied')">待回复 (${unrepliedMessages.size()})</button>
        <button class="tab" onclick="showTab('all')">全部留言</button>
    </div>

    <!-- 待回复留言 -->
    <div id="unrepliedTab" class="message-list" style="display: block;">
        <c:if test="${empty unrepliedMessages}">
            <div class="empty-message">暂无待回复的留言</div>
        </c:if>
        <c:forEach items="${unrepliedMessages}" var="msg">
            <div class="message-item">
                <div class="message-header">
                    <span class="message-user">${msg.owner.realName} (${msg.owner.phone})</span>
                    <span class="status-badge status-unreplied">待回复</span>
                </div>
                <div class="message-title">${msg.title}</div>
                <div class="message-content">${msg.content}</div>
                <div class="message-time">
                    留言时间：<fmt:formatDate value="${msg.createTime}" pattern="yyyy-MM-dd HH:mm"/>
                </div>

                <div class="message-actions">
                    <button class="btn btn-small" onclick="showReplyForm(${msg.id})">回复</button>
                    <a href="#" onclick="deleteMessage(${msg.id})">删除</a>
                </div>

                <div id="replyForm_${msg.id}" class="reply-form">
                    <form action="${pageContext.request.contextPath}/admin/message/reply" method="post">
                        <input type="hidden" name="id" value="${msg.id}">
                        <textarea name="reply" placeholder="请输入回复内容..." required></textarea>
                        <div class="reply-actions">
                            <button type="button" class="btn btn-small btn-danger" onclick="hideReplyForm(${msg.id})">取消</button>
                            <button type="submit" class="btn btn-small">提交回复</button>
                        </div>
                    </form>
                </div>
            </div>
        </c:forEach>
    </div>

    <!-- 全部留言 -->
    <div id="allTab" class="message-list" style="display: none;">
        <c:if test="${empty messages}">
            <div class="empty-message">暂无留言记录</div>
        </c:if>
        <c:forEach items="${messages}" var="msg">
            <div class="message-item">
                <div class="message-header">
                    <span class="message-user">${msg.owner.realName} (${msg.owner.phone})</span>
                    <span class="status-badge ${msg.status == 0 ? 'status-unreplied' : 'status-replied'}">
                            ${msg.status == 0 ? '待回复' : '已回复'}
                    </span>
                </div>
                <div class="message-title">${msg.title}</div>
                <div class="message-content">${msg.content}</div>

                <c:if test="${not empty msg.reply}">
                    <div class="message-reply">
                        <div class="reply-header">管理员回复：</div>
                        <div>${msg.reply}</div>
                        <div style="color:#999; font-size:12px; margin-top:5px;">
                            回复时间：<fmt:formatDate value="${msg.replyTime}" pattern="yyyy-MM-dd HH:mm"/>
                        </div>
                    </div>
                </c:if>

                <div class="message-time">
                    留言时间：<fmt:formatDate value="${msg.createTime}" pattern="yyyy-MM-dd HH:mm"/>
                </div>

                <div class="message-actions">
                    <c:if test="${msg.status == 0}">
                        <button class="btn btn-small" onclick="showReplyForm(${msg.id})">回复</button>
                    </c:if>
                    <a href="#" onclick="deleteMessage(${msg.id})">删除</a>
                </div>

                <div id="replyForm_${msg.id}" class="reply-form">
                    <form action="${pageContext.request.contextPath}/admin/message/reply" method="post">
                        <input type="hidden" name="id" value="${msg.id}">
                        <textarea name="reply" placeholder="请输入回复内容..." required></textarea>
                        <div class="reply-actions">
                            <button type="button" class="btn btn-small btn-danger" onclick="hideReplyForm(${msg.id})">取消</button>
                            <button type="submit" class="btn btn-small">提交回复</button>
                        </div>
                    </form>
                </div>
            </div>
        </c:forEach>
    </div>
</div>

<script>
    function showTab(tabName) {
        var tabs = document.querySelectorAll('.tab');
        var tabContents = document.querySelectorAll('.message-list');

        tabs.forEach(tab => tab.classList.remove('active'));
        tabContents.forEach(content => content.style.display = 'none');

        event.target.classList.add('active');
        document.getElementById(tabName + 'Tab').style.display = 'block';
    }

    function showReplyForm(id) {
        document.getElementById('replyForm_' + id).style.display = 'block';
    }

    function hideReplyForm(id) {
        document.getElementById('replyForm_' + id).style.display = 'none';
    }

    function deleteMessage(id) {
        if (confirm('确定要删除这条留言吗？')) {
            window.location.href = '${pageContext.request.contextPath}/admin/message/delete/' + id;
        }
    }
</script>
</body>
</html>