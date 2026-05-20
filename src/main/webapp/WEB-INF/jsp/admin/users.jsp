<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <title>用户管理 - 汽车4S店售后管理系统</title>
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
            border: none;
            cursor: pointer;
            font-size: 14px;
        }
        .btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(102,126,234,0.4);
        }
        .btn-danger {
            background: #f44336;
        }
        .btn-danger:hover {
            background: #da190b;
        }
        .btn-small {
            padding: 5px 12px;
            font-size: 12px;
            margin: 0 2px;
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
        .user-table {
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
        .status-active {
            background: #d4edda;
            color: #155724;
        }
        .status-inactive {
            background: #f8d7da;
            color: #721c24;
        }
        .role-badge {
            display: inline-block;
            padding: 3px 10px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 500;
        }
        .role-admin {
            background: #cce5ff;
            color: #004085;
        }
        .role-mechanic {
            background: #fff3cd;
            color: #856404;
        }
        .role-owner {
            background: #d1ecf1;
            color: #0c5460;
        }
        .action-links a {
            margin: 0 5px;
            color: #667eea;
            text-decoration: none;
        }
        .action-links a.delete {
            color: #f44336;
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
    <a href="${pageContext.request.contextPath}/admin/users" class="active">用户管理</a>
    <a href="${pageContext.request.contextPath}/admin/parts">配件管理</a>
    <a href="${pageContext.request.contextPath}/admin/orders">订单管理</a>
    <a href="${pageContext.request.contextPath}/admin/complaints">投诉处理</a>
    <a href="${pageContext.request.contextPath}/admin/messages">留言管理</a>
</div>

<div class="container">
    <div class="page-title">
        <h2>用户管理</h2>
        <a href="${pageContext.request.contextPath}/admin/user/add" class="btn">+ 添加用户</a>
    </div>

    <div class="tab-bar">
        <button class="tab active" onclick="showTab('all')">全部用户</button>
        <button class="tab" onclick="showTab('owner')">车主</button>
        <button class="tab" onclick="showTab('mechanic')">维修人员</button>
        <button class="tab" onclick="showTab('admin')">管理员</button>
    </div>

    <!-- 全部用户 -->
    <div id="allTab" class="user-table" style="display: block;">
        <c:if test="${empty owners and empty mechanics}">
            <div class="empty-message">暂无用户数据</div>
        </c:if>
        <c:if test="${not empty owners or not empty mechanics}">
            <table>
                <thead>
                <tr>
                    <th>ID</th>
                    <th>用户名</th>
                    <th>姓名</th>
                    <th>手机号</th>
                    <th>邮箱</th>
                    <th>角色</th>
                    <th>状态</th>
                    <th>注册时间</th>
                    <th>操作</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach items="${owners}" var="user">
                    <tr>
                        <td>${user.id}</td>
                        <td>${user.username}</td>
                        <td>${user.realName}</td>
                        <td>${user.phone}</td>
                        <td>${user.email}</td>
                        <td><span class="role-badge role-owner">车主</span></td>
                        <td>
                                    <span class="status-badge ${user.status == 1 ? 'status-active' : 'status-inactive'}">
                                            ${user.status == 1 ? '正常' : '禁用'}
                                    </span>
                        </td>
                        <td><fmt:formatDate value="${user.createTime}" pattern="yyyy-MM-dd"/></td>
                        <td class="action-links">
                            <a href="${pageContext.request.contextPath}/admin/user/edit/${user.id}">编辑</a>
                            <a href="#" class="delete" onclick="deleteUser(${user.id})">删除</a>
                        </td>
                    </tr>
                </c:forEach>
                <c:forEach items="${mechanics}" var="user">
                    <tr>
                        <td>${user.id}</td>
                        <td>${user.username}</td>
                        <td>${user.realName}</td>
                        <td>${user.phone}</td>
                        <td>${user.email}</td>
                        <td><span class="role-badge role-mechanic">维修人员</span></td>
                        <td>
                                    <span class="status-badge ${user.status == 1 ? 'status-active' : 'status-inactive'}">
                                            ${user.status == 1 ? '正常' : '禁用'}
                                    </span>
                        </td>
                        <td><fmt:formatDate value="${user.createTime}" pattern="yyyy-MM-dd"/></td>
                        <td class="action-links">
                            <a href="${pageContext.request.contextPath}/admin/user/edit/${user.id}">编辑</a>
                            <a href="#" class="delete" onclick="deleteUser(${user.id})">删除</a>
                        </td>
                    </tr>
                </c:forEach>
                <c:forEach items="${admins}" var="user">
                    <tr>
                        <td>${user.id}</td>
                        <td>${user.username}</td>
                        <td>${user.realName}</td>
                        <td>${user.phone}</td>
                        <td>${user.email}</td>
                        <td><span class="role-badge role-admin">管理员</span></td>
                        <td>
                                    <span class="status-badge ${user.status == 1 ? 'status-active' : 'status-inactive'}">
                                            ${user.status == 1 ? '正常' : '禁用'}
                                    </span>
                        </td>
                        <td><fmt:formatDate value="${user.createTime}" pattern="yyyy-MM-dd"/></td>
                        <td class="action-links">
                            <a href="${pageContext.request.contextPath}/admin/user/edit/${user.id}">编辑</a>
                            <a href="#" class="delete" onclick="deleteUser(${user.id})">删除</a>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </c:if>
    </div>

    <!-- 车主列表 -->
    <div id="ownerTab" class="user-table" style="display: none;">
        <c:if test="${empty owners}">
            <div class="empty-message">暂无车主数据</div>
        </c:if>
        <c:if test="${not empty owners}">
            <table>
                <thead>
                <tr>
                    <th>ID</th>
                    <th>用户名</th>
                    <th>姓名</th>
                    <th>手机号</th>
                    <th>邮箱</th>
                    <th>状态</th>
                    <th>注册时间</th>
                    <th>操作</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach items="${owners}" var="user">
                    <tr>
                        <td>${user.id}</td>
                        <td>${user.username}</td>
                        <td>${user.realName}</td>
                        <td>${user.phone}</td>
                        <td>${user.email}</td>
                        <td>
                                    <span class="status-badge ${user.status == 1 ? 'status-active' : 'status-inactive'}">
                                            ${user.status == 1 ? '正常' : '禁用'}
                                    </span>
                        </td>
                        <td><fmt:formatDate value="${user.createTime}" pattern="yyyy-MM-dd"/></td>
                        <td class="action-links">
                            <a href="${pageContext.request.contextPath}/admin/user/edit/${user.id}">编辑</a>
                            <a href="#" class="delete" onclick="deleteUser(${user.id})">删除</a>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </c:if>
    </div>

    <!-- 维修人员列表 -->
    <div id="mechanicTab" class="user-table" style="display: none;">
        <c:if test="${empty mechanics}">
            <div class="empty-message">暂无维修人员数据</div>
        </c:if>
        <c:if test="${not empty mechanics}">
            <table>
                <thead>
                <tr>
                    <th>ID</th>
                    <th>用户名</th>
                    <th>姓名</th>
                    <th>手机号</th>
                    <th>邮箱</th>
                    <th>状态</th>
                    <th>注册时间</th>
                    <th>操作</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach items="${mechanics}" var="user">
                    <tr>
                        <td>${user.id}</td>
                        <td>${user.username}</td>
                        <td>${user.realName}</td>
                        <td>${user.phone}</td>
                        <td>${user.email}</td>
                        <td>
                                    <span class="status-badge ${user.status == 1 ? 'status-active' : 'status-inactive'}">
                                            ${user.status == 1 ? '正常' : '禁用'}
                                    </span>
                        </td>
                        <td><fmt:formatDate value="${user.createTime}" pattern="yyyy-MM-dd"/></td>
                        <td class="action-links">
                            <a href="${pageContext.request.contextPath}/admin/user/edit/${user.id}">编辑</a>
                            <a href="#" class="delete" onclick="deleteUser(${user.id})">删除</a>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </c:if>
    </div>

    <!-- 管理员列表 -->
    <div id="adminTab" class="user-table" style="display: none;">
        <c:if test="${empty admins}">
            <div class="empty-message">暂无管理员数据</div>
        </c:if>
        <c:if test="${not empty admins}">
            <table>
                <thead>
                <tr>
                    <th>ID</th>
                    <th>用户名</th>
                    <th>姓名</th>
                    <th>手机号</th>
                    <th>邮箱</th>
                    <th>状态</th>
                    <th>注册时间</th>
                    <th>操作</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach items="${admins}" var="user">
                    <tr>
                        <td>${user.id}</td>
                        <td>${user.username}</td>
                        <td>${user.realName}</td>
                        <td>${user.phone}</td>
                        <td>${user.email}</td>
                        <td>
                                    <span class="status-badge ${user.status == 1 ? 'status-active' : 'status-inactive'}">
                                            ${user.status == 1 ? '正常' : '禁用'}
                                    </span>
                        </td>
                        <td><fmt:formatDate value="${user.createTime}" pattern="yyyy-MM-dd"/></td>
                        <td class="action-links">
                            <a href="${pageContext.request.contextPath}/admin/user/edit/${user.id}">编辑</a>
                            <a href="#" class="delete" onclick="deleteUser(${user.id})">删除</a>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </c:if>
    </div>
</div>

<script>
    function showTab(tabName) {
        var tabs = document.querySelectorAll('.tab');
        var tabContents = document.querySelectorAll('.user-table');

        tabs.forEach(tab => tab.classList.remove('active'));
        tabContents.forEach(content => content.style.display = 'none');

        event.target.classList.add('active');
        document.getElementById(tabName + 'Tab').style.display = 'block';
    }

    function deleteUser(id) {
        if (confirm('确定要删除该用户吗？')) {
            window.location.href = '${pageContext.request.contextPath}/admin/user/delete/' + id;
        }
    }
</script>
</body>
</html>