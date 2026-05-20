<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>汽车4S店售后管理系统 - 注册</title>
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
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 20px;
        }
        .register-container {
            background: white;
            border-radius: 10px;
            box-shadow: 0 15px 35px rgba(0,0,0,0.2);
            width: 500px;
            padding: 40px;
        }
        h2 {
            text-align: center;
            color: #333;
            margin-bottom: 30px;
            font-size: 28px;
        }
        .form-group {
            margin-bottom: 20px;
        }
        label {
            display: block;
            margin-bottom: 5px;
            color: #555;
            font-weight: 500;
        }
        input[type="text"],
        input[type="password"],
        input[type="email"],
        input[type="tel"] {
            width: 100%;
            padding: 10px 15px;
            border: 2px solid #e1e1e1;
            border-radius: 6px;
            font-size: 15px;
            transition: all 0.3s;
        }
        input:focus {
            border-color: #667eea;
            outline: none;
            box-shadow: 0 0 0 3px rgba(102,126,234,0.1);
        }
        button {
            width: 100%;
            padding: 14px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border: none;
            border-radius: 6px;
            font-size: 18px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s;
            margin-top: 10px;
        }
        button:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(102,126,234,0.4);
        }
        .login-link {
            text-align: center;
            margin-top: 20px;
            color: #666;
        }
        .login-link a {
            color: #667eea;
            text-decoration: none;
            font-weight: 600;
        }
        .login-link a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>
<div class="register-container">
    <h2>用户注册</h2>

    <form action="${pageContext.request.contextPath}/register" method="post">
        <div class="form-group">
            <label>用户名：</label>
            <input type="text" name="username" required placeholder="请输入用户名">
        </div>
        <div class="form-group">
            <label>密码：</label>
            <input type="password" name="password" required placeholder="请输入密码">
        </div>
        <div class="form-group">
            <label>姓名：</label>
            <input type="text" name="realName" required placeholder="请输入真实姓名">
        </div>
        <div class="form-group">
            <label>手机号：</label>
            <input type="tel" name="phone" required placeholder="请输入手机号码">
        </div>
        <div class="form-group">
            <label>邮箱：</label>
            <input type="email" name="email" required placeholder="请输入邮箱">
        </div>
        <button type="submit">注册</button>
    </form>

    <div class="login-link">
        已有账号？ <a href="${pageContext.request.contextPath}/">立即登录</a>
    </div>
</div>
</body>
</html>