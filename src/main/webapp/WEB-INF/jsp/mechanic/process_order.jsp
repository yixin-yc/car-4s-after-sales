<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
  <title>处理订单 - 汽车4S店售后管理系统</title>
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
      max-width: 800px;
      margin: 0 auto;
    }
    .process-card {
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
    .order-info {
      background: #f8f9fa;
      padding: 20px;
      border-radius: 5px;
      margin-bottom: 30px;
    }
    .info-grid {
      display: grid;
      grid-template-columns: repeat(2, 1fr);
      gap: 15px;
    }
    .info-item .label {
      color: #999;
      font-size: 13px;
      margin-bottom: 3px;
    }
    .info-item .value {
      color: #333;
      font-size: 16px;
      font-weight: 500;
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
    .form-group textarea,
    .form-group input {
      width: 100%;
      padding: 12px 15px;
      border: 2px solid #e1e1e1;
      border-radius: 6px;
      font-size: 15px;
      transition: all 0.3s;
    }
    .form-group textarea {
      height: 150px;
      resize: vertical;
    }
    .form-group input:focus,
    .form-group textarea:focus {
      border-color: #667eea;
      outline: none;
      box-shadow: 0 0 0 3px rgba(102,126,234,0.1);
    }
    .parts-section {
      background: #f8f9fa;
      padding: 20px;
      border-radius: 5px;
      margin-bottom: 20px;
    }
    .parts-section h3 {
      color: #333;
      margin-bottom: 15px;
      font-size: 16px;
    }
    .part-item {
      display: flex;
      align-items: center;
      gap: 10px;
      margin-bottom: 10px;
    }
    .part-item select,
    .part-item input {
      flex: 1;
      padding: 8px;
      border: 1px solid #ddd;
      border-radius: 4px;
    }
    .part-item .remove-part {
      color: #f44336;
      cursor: pointer;
      font-size: 20px;
    }
    .btn-add-part {
      background: #95a5a6;
      color: white;
      border: none;
      padding: 8px 15px;
      border-radius: 4px;
      cursor: pointer;
      font-size: 14px;
      margin-top: 10px;
    }
    .btn-add-part:hover {
      background: #7f8c8d;
    }
    .form-actions {
      display: flex;
      gap: 10px;
      justify-content: flex-end;
      margin-top: 30px;
    }
    .btn {
      padding: 12px 30px;
      border: none;
      border-radius: 5px;
      font-size: 16px;
      font-weight: 500;
      cursor: pointer;
      transition: all 0.3s;
      text-decoration: none;
      display: inline-block;
    }
    .btn-primary {
      background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
      color: white;
    }
    .btn-primary:hover {
      transform: translateY(-2px);
      box-shadow: 0 5px 15px rgba(102,126,234,0.4);
    }
    .btn-secondary {
      background: #95a5a6;
      color: white;
    }
    .btn-secondary:hover {
      background: #7f8c8d;
    }
  </style>
</head>
<body>
<div class="container">
  <div class="process-card">
    <h2>处理维修订单</h2>

    <div class="order-info">
      <div class="info-grid">
        <div class="info-item">
          <div class="label">订单号</div>
          <div class="value">${order.orderNo}</div>
        </div>
        <div class="info-item">
          <div class="label">车主</div>
          <div class="value">${order.owner.realName} (${order.owner.phone})</div>
        </div>
        <div class="info-item">
          <div class="label">车辆信息</div>
          <div class="value">${order.vehicle.plateNumber} - ${order.vehicle.model}</div>
        </div>
        <div class="info-item">
          <div class="label">服务类型</div>
          <div class="value">
            <c:choose>
              <c:when test="${order.serviceType == 'maintenance'}">保养</c:when>
              <c:when test="${order.serviceType == 'repair'}">维修</c:when>
              <c:otherwise>检测</c:otherwise>
            </c:choose>
          </div>
        </div>
        <div class="info-item">
          <div class="label">预约时间</div>
          <div class="value"><fmt:formatDate value="${order.appointmentTime}" pattern="yyyy-MM-dd HH:mm"/></div>
        </div>
        <div class="info-item">
          <div class="label">客户描述</div>
          <div class="value">${order.serviceContent}</div>
        </div>
      </div>
    </div>

    <form action="${pageContext.request.contextPath}/mechanic/order/complete" method="post">
      <input type="hidden" name="orderId" value="${order.id}">

      <div class="form-group">
        <label>维修内容记录：</label>
        <textarea name="serviceContent" required placeholder="请详细记录维修过程、检测结果等..."></textarea>
      </div>

      <div class="parts-section">
        <h3>使用配件记录</h3>
        <div id="partsContainer">
          <div class="part-item">
            <select name="partIds" onchange="updatePartPrice(this)">
              <option value="">选择配件</option>
              <c:forEach items="${parts}" var="part">
                <option value="${part.id}" data-price="${part.price}">
                    ${part.partName} - ${part.specification} (库存:${part.stock})
                </option>
              </c:forEach>
            </select>
            <input type="number" name="partQuantities" placeholder="数量" min="1" value="1" onchange="calculateTotal()">
            <span class="remove-part" onclick="removePart(this)">×</span>
          </div>
        </div>
        <button type="button" class="btn-add-part" onclick="addPart()">+ 添加配件</button>
      </div>
      <!-- 调试信息：查看配件列表是否有数据 -->
      <c:if test="${empty parts}">
        <div style="background: #fff3cd; color: #856404; padding: 10px; margin-bottom: 10px; border-radius: 5px;">
          警告：配件列表为空！请检查数据库是否有配件数据。
        </div>
      </c:if>
      <c:if test="${not empty parts}">
        <div style="background: #d4edda; color: #155724; padding: 10px; margin-bottom: 10px; border-radius: 5px;">
          配件列表已加载，共 ${parts.size()} 个配件。
        </div>
      </c:if>

      <div class="form-group">
        <label>工时费：</label>
        <input type="number" name="laborFee" id="laborFee" step="0.01" min="0" value="0" onchange="calculateTotal()" required>
      </div>

      <div class="form-group">
        <label>总费用：</label>
        <input type="number" name="amount" id="totalAmount" step="0.01" min="0" readonly required style="background:#f8f9fa; font-weight:bold; font-size:18px;">
      </div>

      <div class="form-actions">
        <a href="${pageContext.request.contextPath}/mechanic/orders" class="btn btn-secondary">返回</a>
        <button type="submit" class="btn btn-primary">完成订单</button>
      </div>
    </form>
  </div>
</div>

<script>
  let partCount = 1;

  function addPart() {
    const container = document.getElementById('partsContainer');
    const newPart = document.createElement('div');
    newPart.className = 'part-item';
    newPart.innerHTML = `
                <select name="partIds" onchange="updatePartPrice(this)">
                    <option value="">选择配件</option>
                    <c:forEach items="${parts}" var="part">
                        <option value="${part.id}" data-price="${part.price}">${part.partName} - ${part.specification} (库存:${part.stock})</option>
                    </c:forEach>
                </select>
                <input type="number" name="partQuantities" placeholder="数量" min="1" value="1" onchange="calculateTotal()">
                <span class="remove-part" onclick="removePart(this)">×</span>
            `;
    container.appendChild(newPart);
    partCount++;
  }

  function removePart(element) {
    if (document.querySelectorAll('.part-item').length > 1) {
      element.parentElement.remove();
      calculateTotal();
    }
  }

  function updatePartPrice(select) {
    calculateTotal();
  }

  function calculateTotal() {
    let total = 0;

    // 计算配件总价
    const partItems = document.querySelectorAll('.part-item');
    partItems.forEach(item => {
      const select = item.querySelector('select');
      const quantity = item.querySelector('input[type="number"]').value;

      if (select.value && select.selectedOptions[0].dataset.price) {
        const price = parseFloat(select.selectedOptions[0].dataset.price);
        total += price * parseInt(quantity);
      }
    });

    // 加工时费
    const laborFee = parseFloat(document.getElementById('laborFee').value) || 0;
    total += laborFee;

    document.getElementById('totalAmount').value = total.toFixed(2);
  }
</script>
</body>
</html>