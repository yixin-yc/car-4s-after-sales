<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <title>车辆管理 - 汽车4S店售后管理系统</title>
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
        table {
            width: 100%;
            background: white;
            border-collapse: collapse;
            box-shadow: 0 2px 10px rgba(0,0,0,0.05);
            border-radius: 10px;
            overflow: hidden;
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
        .action-links a {
            margin-right: 10px;
            color: #667eea;
            text-decoration: none;
        }
        .action-links a.delete {
            color: #f44336;
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
        .form-group input,
        .form-group select {
            width: 100%;
            padding: 8px 12px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 14px;
        }
        .form-group input:focus {
            border-color: #667eea;
            outline: none;
        }
        .form-actions {
            display: flex;
            justify-content: flex-end;
            gap: 10px;
            margin-top: 20px;
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
    <a href="${pageContext.request.contextPath}/owner/vehicles" class="active">车辆管理</a>
    <a href="${pageContext.request.contextPath}/owner/appointment">预约服务</a>
    <a href="${pageContext.request.contextPath}/owner/orders">订单查询</a>
    <a href="${pageContext.request.contextPath}/owner/messages">留言咨询</a>
    <a href="${pageContext.request.contextPath}/owner/complaints">投诉建议</a>
</div>

<div class="container">
    <div class="page-title">
        <h2>我的车辆</h2>
        <button class="btn" onclick="showAddModal()">+ 添加车辆</button>
    </div>

    <c:if test="${empty vehicles}">
        <div style="text-align: center; padding: 50px; background: white; border-radius: 10px;">
            <p style="color: #999; margin-bottom: 20px;">您还没有添加车辆信息</p>
            <button class="btn" onclick="showAddModal()">立即添加</button>
        </div>
    </c:if>

    <c:if test="${not empty vehicles}">
        <table>
            <thead>
            <tr>
                <th>车牌号码</th>
                <th>车型</th>
                <th>车辆识别码(VIN)</th>
                <th>购买时间</th>
                <th>保养周期</th>
                <th>上次保养</th>
                <th>操作</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach items="${vehicles}" var="vehicle">
                <tr>
                    <td>${vehicle.plateNumber}</td>
                    <td>${vehicle.model}</td>
                    <td>${vehicle.vin}</td>
                    <td><fmt:formatDate value="${vehicle.purchaseDate}" pattern="yyyy-MM-dd"/></td>
                    <td>${vehicle.maintenanceCycle}个月</td>
                    <td><fmt:formatDate value="${vehicle.lastMaintenance}" pattern="yyyy-MM-dd"/></td>
                    <td class="action-links">
                        <a href="#" onclick="showEditModal(${vehicle.id}, '${vehicle.plateNumber}', '${vehicle.model}', '${vehicle.vin}', '${vehicle.maintenanceCycle}')">编辑</a>
                        <a href="#" class="delete" onclick="deleteVehicle(${vehicle.id})">删除</a>
                        <a href="${pageContext.request.contextPath}/owner/appointment?vehicleId=${vehicle.id}">预约</a>
                    </td>
                </tr>
            </c:forEach>
            </tbody>
        </table>
    </c:if>
</div>

<!-- 添加车辆模态框 -->
<div id="addModal" class="modal">
    <div class="modal-content">
        <h3>添加车辆</h3>
        <form action="${pageContext.request.contextPath}/owner/vehicle/add" method="post">
            <div class="form-group">
                <label>车牌号码：</label>
                <input type="text" name="plateNumber" required placeholder="例如：京A12345">
            </div>
            <div class="form-group">
                <label>车型：</label>
                <input type="text" name="model" required placeholder="例如：奥迪A6L">
            </div>
            <div class="form-group">
                <label>车辆识别码(VIN)：</label>
                <input type="text" name="vin" required placeholder="17位VIN码">
            </div>
            <div class="form-group">
                <label>购买时间：</label>
                <input type="date" name="purchaseDate" required>
            </div>
            <div class="form-group">
                <label>保养周期(月)：</label>
                <input type="number" name="maintenanceCycle" value="6" required>
            </div>
            <div class="form-group">
                <label>上次保养时间：</label>
                <input type="date" name="lastMaintenance">
            </div>
            <div class="form-actions">
                <button type="button" class="btn btn-danger" onclick="hideAddModal()">取消</button>
                <button type="submit" class="btn">保存</button>
            </div>
        </form>
    </div>
</div>

<!-- 编辑车辆模态框 -->
<div id="editModal" class="modal">
    <div class="modal-content">
        <h3>编辑车辆</h3>
        <form action="${pageContext.request.contextPath}/owner/vehicle/update" method="post">
            <input type="hidden" name="id" id="editId">
            <div class="form-group">
                <label>车牌号码：</label>
                <input type="text" name="plateNumber" id="editPlateNumber" required>
            </div>
            <div class="form-group">
                <label>车型：</label>
                <input type="text" name="model" id="editModel" required>
            </div>
            <div class="form-group">
                <label>车辆识别码(VIN)：</label>
                <input type="text" name="vin" id="editVin" required>
            </div>
            <div class="form-group">
                <label>保养周期(月)：</label>
                <input type="number" name="maintenanceCycle" id="editMaintenanceCycle" required>
            </div>
            <div class="form-actions">
                <button type="button" class="btn btn-danger" onclick="hideEditModal()">取消</button>
                <button type="submit" class="btn">更新</button>
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

    function showEditModal(id, plateNumber, model, vin, maintenanceCycle) {
        document.getElementById('editId').value = id;
        document.getElementById('editPlateNumber').value = plateNumber;
        document.getElementById('editModel').value = model;
        document.getElementById('editVin').value = vin;
        document.getElementById('editMaintenanceCycle').value = maintenanceCycle;
        document.getElementById('editModal').style.display = 'block';
    }

    function hideEditModal() {
        document.getElementById('editModal').style.display = 'none';
    }

    function deleteVehicle(id) {
        if (confirm('确定要删除这辆车吗？')) {
            window.location.href = '${pageContext.request.contextPath}/owner/vehicle/delete/' + id;
        }
    }

    window.onclick = function(event) {
        if (event.target == document.getElementById('addModal')) {
            hideAddModal();
        }
        if (event.target == document.getElementById('editModal')) {
            hideEditModal();
        }
    }
</script>
</body>
</html>