<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <title>投诉处理 - 汽车4S店售后管理系统</title>
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
        }
        .tab:hover {
            background: #667eea;
            color: white;
        }
        .tab.active {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
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
        .complaint-user {
            font-weight: 600;
            color: #333;
        }
        .complaint-time {
            color: #999;
            font-size: 13px;
        }
        .complaint-order {
            color: #667eea;
            font-size: 14px;
            margin-bottom: 10px;
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
        .status-badge {
            display: inline-block;
            padding: 3px 10px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 500;
        }
        .status-unhandled {
            background: #f8d7da;
            color: #721c24;
        }
        .status-handled {
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
    <a href="${pageContext.request.contextPath}/admin/complaints" class="active">投诉处理</a>
    <a href="${pageContext.request.contextPath}/admin/messages">留言管理</a>
</div>

<div class="container">
    <div class="page-title">
        <h2>客户投诉处理</h2>
    </div>

    <div class="tab-bar">
        <button class="tab active" onclick="showTab('unhandled')">待处理 (${unhandledComplaints.size()})</button>
        <button class="tab" onclick="showTab('all')">全部投诉</button>
    </div>

    <!-- 待处理投诉 -->
    <div id="unhandledTab" class="complaint-list" style="display: block;">
        <c:if test="${empty unhandledComplaints}">
            <div class="empty-message">暂无待处理的投诉</div>
        </c:if>
        <c:forEach items="${unhandledComplaints}" var="complaint">
            <div class="complaint-item">
                <div class="complaint-header">
                    <span class="complaint-user">${complaint.owner.realName} (${complaint.owner.phone})</span>
                    <span class="status-badge status-unhandled">待处理</span>
                </div>
                <div class="complaint-order">
                    订单号：${complaint.order.orderNo}
                </div>
                <div class="complaint-content">
                        ${complaint.content}
                </div>
                <div class="complaint-time">
                    投诉时间：<fmt:formatDate value="${complaint.createTime}" pattern="yyyy-MM-dd HH:mm"/>
                </div>

                <div style="margin-top: 15px; text-align: right;">
                    <button class="btn btn-small" onclick="showReplyForm(${complaint.id})">处理投诉</button>
                </div>

                <div id="replyForm_${complaint.id}" class="reply-form">
                    <form action="${pageContext.request.contextPath}/admin/complaint/handle" method="post">
                        <input type="hidden" name="id" value="${complaint.id}">
                        <textarea name="reply" placeholder="请输入处理意见..." required></textarea>
                        <div class="reply-actions">
                            <button type="button" class="btn btn-small btn-danger" onclick="hideReplyForm(${complaint.id})">取消</button>
                            <button type="submit" class="btn btn-small">提交处理</button>
                        </div>
                    </form>
                </div>
            </div>
        </c:forEach>
    </div>

    <!-- 全部投诉 -->
    <div id="allTab" class="complaint-list" style="display: none;">
        <c:if test="${empty complaints}">
            <div class="empty-message">暂无投诉记录</div>
        </c:if>
        <c:forEach items="${complaints}" var="complaint">
            <div class="complaint-item">
                <div class="complaint-header">
                    <span class="complaint-user">${complaint.owner.realName} (${complaint.owner.phone})</span>
                    <span class="status-badge ${complaint.status == 0 ? 'status-unhandled' : 'status-handled'}">
                            ${complaint.status == 0 ? '待处理' : '已处理'}
                    </span>
                </div>
                <div class="complaint-order">
                    订单号：${complaint.order.orderNo}
                </div>
                <div class="complaint-content">
                        ${complaint.content}
                </div>
                <c:if test="${not empty complaint.reply}">
                    <div class="complaint-reply">
                        <div class="reply-header">处理回复：</div>
                        <div>${complaint.reply}</div>
                        <div style="color:#999; font-size:12px; margin-top:5px; text-align:right;">
                            处理时间：<fmt:formatDate value="${complaint.handleTime}" pattern="yyyy-MM-dd HH:mm"/>
                        </div>
                    </div>
                </c:if>
                <div class="complaint-time">
                    投诉时间：<fmt:formatDate value="${complaint.createTime}" pattern="yyyy-MM-dd HH:mm"/>
                </div>

                <c:if test="${complaint.status == 0}">
                    <div style="margin-top: 15px; text-align: right;">
                        <button class="btn btn-small" onclick="showReplyForm(${complaint.id})">处理投诉</button>
                    </div>

                    <div id="replyForm_${complaint.id}" class="reply-form">
                        <form action="${pageContext.request.contextPath}/admin/complaint/handle" method="post">
                            <input type="hidden" name="id" value="${complaint.id}">
                            <textarea name="reply" placeholder="请输入处理意见..." required></textarea>
                            <div class="reply-actions">
                                <button type="button" class="btn btn-small btn-danger" onclick="hideReplyForm(${complaint.id})">取消</button>
                                <button type="submit" class="btn btn-small">提交处理</button>
                            </div>
                        </form>
                    </div>
                </c:if>
            </div>
        </c:forEach>
    </div>
</div>

<script>
    function showTab(tabName) {
        var tabs = document.querySelectorAll('.tab');
        var tabContents = document.querySelectorAll('.complaint-list');

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
</script>
</body>
</html>