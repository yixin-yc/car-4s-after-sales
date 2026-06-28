<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <title>个人信息 - 汽车4S店售后管理系统</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Microsoft YaHei', Arial, sans-serif; background-color: #f4f7fc; }
        .header { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; padding: 15px 30px; display: flex; justify-content: space-between; align-items: center; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
        .header h1 { font-size: 24px; }
        .user-info { display: flex; align-items: center; gap: 20px; }
        .user-info a { color: white; text-decoration: none; padding: 5px 15px; border: 1px solid rgba(255,255,255,0.3); border-radius: 4px; }
        .user-info a:hover { background: rgba(255,255,255,0.2); }
        .nav { background: white; padding: 0 30px; box-shadow: 0 2px 5px rgba(0,0,0,0.05); }
        .nav a { display: inline-block; color: #666; text-decoration: none; padding: 15px 25px; font-weight: 500; }
        .nav a:hover { color: #667eea; }
        .nav a.active { color: #667eea; border-bottom: 3px solid #667eea; }
        .container { padding: 30px; max-width: 800px; margin: 0 auto; }
        .profile-card { background: white; padding: 30px; border-radius: 10px; box-shadow: 0 2px 10px rgba(0,0,0,0.05); }
        .profile-card h2 { color: #333; margin-bottom: 25px; padding-bottom: 15px; border-bottom: 2px solid #667eea; }
        .info-section { background: #f8f9fa; padding: 20px; border-radius: 8px; margin-bottom: 25px; }
        .info-section h3 { color: #555; font-size: 15px; margin-bottom: 15px; border-left: 3px solid #667eea; padding-left: 10px; }
        .info-row { display: flex; padding: 10px 0; border-bottom: 1px solid #eee; }
        .info-row:last-child { border-bottom: none; }
        .info-row .label { width: 120px; color: #999; font-size: 14px; }
        .info-row .value { color: #333; font-size: 14px; font-weight: 500; }
        .form-group { margin-bottom: 18px; }
        .form-group label { display: block; color: #555; font-size: 14px; margin-bottom: 6px; }
        .form-group input { width: 100%; padding: 10px 15px; border: 1px solid #ddd; border-radius: 5px; font-size: 14px; }
        .form-group input:focus { outline: none; border-color: #667eea; box-shadow: 0 0 0 2px rgba(102,126,234,0.2); }
        .btn { display: inline-block; padding: 10px 30px; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; text-decoration: none; border-radius: 5px; font-size: 14px; border: none; cursor: pointer; }
        .btn:hover { transform: translateY(-2px); box-shadow: 0 5px 15px rgba(102,126,234,0.4); }
        .message { padding: 10px 15px; border-radius: 5px; margin-bottom: 15px; }
        .message-success { background: #d4edda; color: #155724; }
    </style>
</head>
<body>
<div class="header">
    <h1>汽车4S店售后管理系统</h1>
    <div class="user-info">
        <a href="${pageContext.request.contextPath}/admin/profile" style="color:white; text-decoration:none;">欢迎，${sessionScope.user.realName} (管理员)</a>
        <a href="${pageContext.request.contextPath}/logout">退出</a>
    </div>
</div>

<div class="nav">
    <a href="${pageContext.request.contextPath}/admin/dashboard">首页</a>
    <a href="${pageContext.request.contextPath}/admin/users">用户管理</a>
    <a href="${pageContext.request.contextPath}/admin/parts">配件管理</a>
    <a href="${pageContext.request.contextPath}/admin/orders">订单管理</a>
    <a href="${pageContext.request.contextPath}/admin/complaints">投诉处理</a>
    <a href="${pageContext.request.contextPath}/admin/messages">留言管理</a>
    <a href="${pageContext.request.contextPath}/admin/profile" class="active">个人信息</a>
</div>

<div class="container">
    <div class="profile-card">
        <h2>个人信息</h2>

        <c:if test="${param.success != null}">
            <div class="message message-success">信息修改成功！</div>
        </c:if>

        <div class="info-section">
            <h3>基础信息（只读）</h3>
            <div class="info-row">
                <span class="label">用户ID</span>
                <span class="value">${user.id}</span>
            </div>
            <div class="info-row">
                <span class="label">角色</span>
                <span class="value">管理员</span>
            </div>
            <div class="info-row">
                <span class="label">注册时间</span>
                <span class="value"><fmt:formatDate value="${user.createTime}" pattern="yyyy-MM-dd HH:mm"/></span>
            </div>
        </div>

        <form action="${pageContext.request.contextPath}/admin/profile/update" method="post">
            <div class="info-section">
                <h3>可修改信息</h3>
                <div class="form-group">
                    <label>用户名</label>
                    <input type="text" name="username" value="${user.username}" required>
                </div>
                <div class="form-group">
                    <label>密码</label>
                    <input type="password" name="password" value="${user.password}" required>
                </div>
                <div class="form-group">
                    <label>真实姓名</label>
                    <input type="text" name="realName" value="${user.realName}">
                </div>
                <div class="form-group">
                    <label>手机号</label>
                    <input type="text" name="phone" value="${user.phone}">
                </div>
                <div class="form-group">
                    <label>邮箱</label>
                    <input type="email" name="email" value="${user.email}">
                </div>
            </div>
            <button type="submit" class="btn">保存修改</button>
        </form>
    </div>
</div>
</body>
</html>
