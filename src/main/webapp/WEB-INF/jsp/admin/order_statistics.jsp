<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
  <title>订单统计 - 汽车4S店售后管理系统</title>
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
    .stats-grid {
      display: grid;
      grid-template-columns: repeat(4, 1fr);
      gap: 20px;
      margin-bottom: 30px;
    }
    .stat-card {
      background: white;
      padding: 25px;
      border-radius: 10px;
      text-align: center;
      box-shadow: 0 2px 10px rgba(0,0,0,0.05);
    }
    .stat-card h3 {
      color: #999;
      font-size: 16px;
      margin-bottom: 10px;
    }
    .stat-number {
      color: #667eea;
      font-size: 42px;
      font-weight: 700;
    }
    .stat-sub {
      color: #666;
      font-size: 14px;
      margin-top: 10px;
    }
    .charts-section {
      display: grid;
      grid-template-columns: 1fr 1fr;
      gap: 20px;
      margin-bottom: 30px;
    }
    .chart-card {
      background: white;
      padding: 20px;
      border-radius: 10px;
      box-shadow: 0 2px 10px rgba(0,0,0,0.05);
    }
    .chart-card h3 {
      color: #333;
      margin-bottom: 15px;
      padding-bottom: 10px;
      border-bottom: 2px solid #667eea;
    }
    .chart-container {
      height: 300px;
      display: flex;
      align-items: flex-end;
      justify-content: center;
      gap: 30px;
      padding: 20px 0;
    }
    .bar {
      width: 60px;
      background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
      border-radius: 5px 5px 0 0;
      position: relative;
      transition: all 0.3s;
    }
    .bar:hover {
      transform: scale(1.05);
    }
    .bar-label {
      position: absolute;
      bottom: -25px;
      left: 50%;
      transform: translateX(-50%);
      color: #666;
      font-size: 14px;
    }
    .bar-value {
      position: absolute;
      top: -25px;
      left: 50%;
      transform: translateX(-50%);
      color: #333;
      font-weight: 600;
    }
    .pie-chart {
      width: 200px;
      height: 200px;
      border-radius: 50%;
      margin: 20px auto;
      background: conic-gradient(
      #667eea 0% ${pendingPercent}%,
      #764ba2 ${pendingPercent}% ${pendingPercent + processingPercent}%,
      #4caf50 ${pendingPercent + processingPercent}% 100%
      );
    }
    .pie-legend {
      display: flex;
      justify-content: center;
      gap: 20px;
      margin-top: 20px;
    }
    .legend-item {
      display: flex;
      align-items: center;
      gap: 5px;
    }
    .legend-color {
      width: 12px;
      height: 12px;
      border-radius: 3px;
    }
    .revenue-section {
      background: white;
      padding: 20px;
      border-radius: 10px;
      box-shadow: 0 2px 10px rgba(0,0,0,0.05);
    }
    .revenue-section h3 {
      color: #333;
      margin-bottom: 15px;
      padding-bottom: 10px;
      border-bottom: 2px solid #667eea;
    }
    .revenue-grid {
      display: grid;
      grid-template-columns: repeat(3, 1fr);
      gap: 20px;
      text-align: center;
    }
    .revenue-item .label {
      color: #999;
      margin-bottom: 5px;
    }
    .revenue-item .value {
      color: #333;
      font-size: 24px;
      font-weight: 600;
    }
    .btn {
      display: inline-block;
      padding: 10px 20px;
      background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
      color: white;
      text-decoration: none;
      border-radius: 5px;
      margin-bottom: 20px;
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
  <a href="${pageContext.request.contextPath}/admin/messages">留言管理</a>
</div>

<div class="container">
  <div class="page-title">
    <h2>订单统计</h2>
  </div>

  <div class="stats-grid">
    <div class="stat-card">
      <h3>总订单数</h3>
      <div class="stat-number">${totalOrders}</div>
    </div>
    <div class="stat-card">
      <h3>待处理订单</h3>
      <div class="stat-number">${pendingOrders}</div>
    </div>
    <div class="stat-card">
      <h3>处理中订单</h3>
      <div class="stat-number">${processingOrders}</div>
    </div>
    <div class="stat-card">
      <h3>已完成订单</h3>
      <div class="stat-number">${completedOrders}</div>
    </div>
  </div>

  <div class="charts-section">
    <div class="chart-card">
      <h3>月度订单统计</h3>
      <div class="chart-container">
        <div class="bar" style="height: ${monthlyData[0] * 20}px;">
          <span class="bar-value">${monthlyData[0]}</span>
          <span class="bar-label">1月</span>
        </div>
        <div class="bar" style="height: ${monthlyData[1] * 20}px;">
          <span class="bar-value">${monthlyData[1]}</span>
          <span class="bar-label">2月</span>
        </div>
        <div class="bar" style="height: ${monthlyData[2] * 20}px;">
          <span class="bar-value">${monthlyData[2]}</span>
          <span class="bar-label">3月</span>
        </div>
        <div class="bar" style="height: ${monthlyData[3] * 20}px;">
          <span class="bar-value">${monthlyData[3]}</span>
          <span class="bar-label">4月</span>
        </div>
        <div class="bar" style="height: ${monthlyData[4] * 20}px;">
          <span class="bar-value">${monthlyData[4]}</span>
          <span class="bar-label">5月</span>
        </div>
        <div class="bar" style="height: ${monthlyData[5] * 20}px;">
          <span class="bar-value">${monthlyData[5]}</span>
          <span class="bar-label">6月</span>
        </div>
      </div>
    </div>

    <div class="chart-card">
      <h3>订单状态分布</h3>
      <div class="pie-chart"></div>
      <div class="pie-legend">
        <div class="legend-item">
          <span class="legend-color" style="background:#667eea;"></span>
          <span>待处理 (${pendingOrders})</span>
        </div>
        <div class="legend-item">
          <span class="legend-color" style="background:#764ba2;"></span>
          <span>处理中 (${processingOrders})</span>
        </div>
        <div class="legend-item">
          <span class="legend-color" style="background:#4caf50;"></span>
          <span>已完成 (${completedOrders})</span>
        </div>
      </div>
    </div>
  </div>

  <div class="revenue-section">
    <h3>营收统计</h3>
    <div class="revenue-grid">
      <div class="revenue-item">
        <div class="label">本月营收</div>
        <div class="value">¥${monthlyRevenue}</div>
      </div>
      <div class="revenue-item">
        <div class="label">本季度营收</div>
        <div class="value">¥${quarterlyRevenue}</div>
      </div>
      <div class="revenue-item">
        <div class="label">年度营收</div>
        <div class="value">¥${yearlyRevenue}</div>
      </div>
    </div>
  </div>
</div>

<script>
  // 这里可以添加图表初始化的JavaScript代码
  // 实际项目中可以使用Chart.js或ECharts等图表库
</script>
</body>
</html>