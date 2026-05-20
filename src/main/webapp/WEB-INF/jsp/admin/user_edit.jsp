<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
  <title>编辑用户 - 汽车4S店售后管理系统</title>
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
      max-width: 600px;
      margin: 0 auto;
    }
    .form-card {
      background: white;
      border-radius: 10px;
      box-shadow: 0 15px 35px rgba(0,0,0,0.2);
      padding: 30px;
    }
    h2 {
      color: #333;
      margin-bottom: 20px;
      padding-bottom: 15px;
      border-bottom: 2px solid #667eea;
    }
    .form-group {
      margin-bottom: 20px;
    }
    .form-group label {
      display: block;
      margin-bottom: 8px;
      color: #555;
      font-weight: 500;
    }
    .form-group input,
    .form-group select {
      width: 100%;
      padding: 12px 15px;
      border: 2px solid #e1e1e1;
      border-radius: 6px;
      font-size: 15px;
      transition: all 0.3s;
    }
    .form-group input:focus,
    .form-group select:focus {
      border-color: #667eea;
      outline: none;
      box-shadow: 0 0 0 3px rgba(102,126,234,0.1);
    }
    .form-group input[readonly] {
      background: #f8f9fa;
      cursor: not-allowed;
    }
    .form-row {
      display: grid;
      grid-template-columns: 1fr 1fr;
      gap: 15px;
    }
    .btn {
      padding: 14px 30px;
      border: none;
      border-radius: 6px;
      font-size: 16px;
      font-weight: 600;
      cursor: pointer;
      transition: all 0.3s;
      text-decoration: none;
      display: inline-block;
    }
    .btn-primary {
      background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
      color: white;
      width: 100%;
    }
    .btn-primary:hover {
      transform: translateY(-2px);
      box-shadow: 0 5px 15px rgba(102,126,234,0.4);
    }
    .btn-secondary {
      background: #95a5a6;
      color: white;
      width: 100%;
    }
    .btn-secondary:hover {
      background: #7f8c8d;
    }
    .form-actions {
      display: flex;
      gap: 10px;
      margin-top: 30px;
    }
  </style>
</head>
<body>
<div class="container">
  <div class="form-card">
    <h2>编辑用户信息</h2>

    <form action="${pageContext.request.contextPath}/admin/user/update" method="post">
      <input type="hidden" name="id" value="${user.id}">

      <div class="form-group">
        <label>用户名：</label>
        <input type="text" value="${user.username}" readonly>
      </div>

      <div class="form-row">
        <div class="form-group">
          <label>姓名：</label>
          <input type="text" name="realName" value="${user.realName}" required>
        </div>
        <div class="form-group">
          <label>手机号：</label>
          <input type="tel" name="phone" value="${user.phone}" required>
        </div>
      </div>

      <div class="form-group">
        <label>邮箱：</label>
        <input type="email" name="email" value="${user.email}" required>
      </div>

      <div class="form-row">
        <div class="form-group">
          <label>用户角色：</label>
          <select name="role" required>
            <option value="owner" ${user.role == 'owner' ? 'selected' : ''}>车主</option>
            <option value="mechanic" ${user.role == 'mechanic' ? 'selected' : ''}>维修人员</option>
            <option value="admin" ${user.role == 'admin' ? 'selected' : ''}>管理员</option>
          </select>
        </div>
        <div class="form-group">
          <label>状态：</label>
          <select name="status">
            <option value="1" ${user.status == 1 ? 'selected' : ''}>正常</option>
            <option value="0" ${user.status == 0 ? 'selected' : ''}>禁用</option>
          </select>
        </div>
      </div>

      <div class="form-actions">
        <a href="${pageContext.request.contextPath}/admin/users" class="btn btn-secondary">取消</a>
        <button type="submit" class="btn btn-primary">保存修改</button>
      </div>
    </form>
  </div>
</div>
</body>
</html>