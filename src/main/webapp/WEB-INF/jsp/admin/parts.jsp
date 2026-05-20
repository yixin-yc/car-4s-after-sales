<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <title>配件管理 - 汽车4S店售后管理系统</title>
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
        .btn-small {
            padding: 5px 12px;
            font-size: 12px;
            margin: 0 2px;
        }
        .parts-table {
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
        .stock-low {
            color: #f44336;
            font-weight: 600;
        }
        .stock-warning {
            color: #ff9800;
            font-weight: 600;
        }
        .stock-normal {
            color: #4caf50;
        }
        .action-links a {
            margin: 0 5px;
            color: #667eea;
            text-decoration: none;
        }
        .action-links a.delete {
            color: #f44336;
        }
        .search-bar {
            background: white;
            padding: 15px;
            border-radius: 10px;
            margin-bottom: 20px;
            display: flex;
            gap: 10px;
            align-items: center;
        }
        .search-bar input {
            flex: 1;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 5px;
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
    <a href="${pageContext.request.contextPath}/admin/parts" class="active">配件管理</a>
    <a href="${pageContext.request.contextPath}/admin/orders">订单管理</a>
    <a href="${pageContext.request.contextPath}/admin/complaints">投诉处理</a>
    <a href="${pageContext.request.contextPath}/admin/messages">留言管理</a>
</div>

<div class="container">
    <div class="page-title">
        <h2>配件库存管理</h2>
        <a href="${pageContext.request.contextPath}/admin/part/add" class="btn">+ 添加配件</a>
    </div>

    <div class="search-bar">
        <input type="text" id="searchInput" placeholder="搜索配件名称、编号、供应商..." onkeyup="searchParts()">
        <button class="btn" onclick="searchParts()">搜索</button>
    </div>

    <div class="parts-table">
        <c:if test="${empty parts}">
            <div class="empty-message">暂无配件数据</div>
        </c:if>
        <c:if test="${not empty parts}">
            <table id="partsTable">
                <thead>
                <tr>
                    <th>配件编号</th>
                    <th>配件名称</th>
                    <th>规格型号</th>
                    <th>供应商</th>
                    <th>单价</th>
                    <th>库存数量</th>
                    <th>状态</th>
                    <th>操作</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach items="${parts}" var="part">
                    <tr>
                        <td>${part.partNo}</td>
                        <td>${part.partName}</td>
                        <td>${part.specification}</td>
                        <td>${part.supplier}</td>
                        <td>¥${part.price}</td>
                        <td>
                                    <span class="${part.stock < 10 ? 'stock-low' : (part.stock < 20 ? 'stock-warning' : 'stock-normal')}">
                                            ${part.stock}
                                    </span>
                        </td>
                        <td>
                            <c:choose>
                                <c:when test="${part.stock < 10}">
                                    <span style="color:#f44336;">库存不足</span>
                                </c:when>
                                <c:when test="${part.stock < 20}">
                                    <span style="color:#ff9800;">即将缺货</span>
                                </c:when>
                                <c:otherwise>
                                    <span style="color:#4caf50;">库存充足</span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td class="action-links">
                            <a href="${pageContext.request.contextPath}/admin/part/edit/${part.id}">编辑</a>
                            <a href="#" class="delete" onclick="deletePart(${part.id})">删除</a>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </c:if>
    </div>
</div>

<script>
    function searchParts() {
        var input = document.getElementById('searchInput');
        var filter = input.value.toUpperCase();
        var table = document.getElementById('partsTable');
        var tr = table.getElementsByTagName('tr');

        for (var i = 1; i < tr.length; i++) {
            var tdArray = tr[i].getElementsByTagName('td');
            var found = false;
            for (var j = 0; j < tdArray.length - 1; j++) {
                if (tdArray[j]) {
                    var txtValue = tdArray[j].textContent || tdArray[j].innerText;
                    if (txtValue.toUpperCase().indexOf(filter) > -1) {
                        found = true;
                        break;
                    }
                }
            }
            tr[i].style.display = found ? '' : 'none';
        }
    }

    function deletePart(id) {
        if (confirm('确定要删除该配件吗？')) {
            window.location.href = '${pageContext.request.contextPath}/admin/part/delete/' + id;
        }
    }
</script>
</body>
</html>