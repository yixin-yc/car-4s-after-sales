<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
  <title>添加配件 - 汽车4S店售后管理系统</title>
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
    .form-group select,
    .form-group textarea {
      width: 100%;
      padding: 12px 15px;
      border: 2px solid #e1e1e1;
      border-radius: 6px;
      font-size: 15px;
      transition: all 0.3s;
    }
    .form-group input:focus,
    .form-group select:focus,
    .form-group textarea:focus {
      border-color: #667eea;
      outline: none;
      box-shadow: 0 0 0 3px rgba(102,126,234,0.1);
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
    <h2>添加新配件</h2>

    <form action="${pageContext.request.contextPath}/admin/part/add" method="post">
      <div class="form-row">
        <div class="form-group">
          <label>配件编号：</label>
          <input type="text" name="partNo" required placeholder="例如：P001">
        </div>
        <div class="form-group">
          <label>配件名称：</label>
          <input type="text" name="partName" required placeholder="例如：机油">
        </div>
      </div>

      <div class="form-group">
        <label>规格型号：</label>
        <input type="text" name="specification" required placeholder="例如：5W-30 4L">
      </div>

      <div class="form-row">
        <div class="form-group">
          <label>单价：</label>
          <input type="number" name="price" step="0.01" min="0" required placeholder="0.00">
        </div>
        <div class="form-group">
          <label>库存数量：</label>
          <input type="number" name="stock" min="0" required placeholder="0">
        </div>
      </div>

      <div class="form-group">
        <label>供应商：</label>
        <input type="text" name="supplier" required placeholder="例如：壳牌">
      </div>

      <div class="form-actions">
        <a href="${pageContext.request.contextPath}/admin/parts" class="btn btn-secondary">取消</a>
        <button type="submit" class="btn btn-primary">添加配件</button>
      </div>
    </form>
  </div>
</div>
</body>
</html>