<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <title>服务评价 - 汽车4S店售后管理系统</title>
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
        .evaluate-container {
            background: white;
            border-radius: 10px;
            box-shadow: 0 15px 35px rgba(0,0,0,0.2);
            width: 600px;
            padding: 40px;
        }
        h2 {
            text-align: center;
            color: #333;
            margin-bottom: 30px;
        }
        .order-info {
            background: #f8f9fa;
            padding: 20px;
            border-radius: 5px;
            margin-bottom: 30px;
        }
        .order-info-item {
            display: flex;
            margin-bottom: 10px;
        }
        .order-info-label {
            width: 100px;
            color: #666;
        }
        .order-info-value {
            color: #333;
            font-weight: 500;
        }
        .rating-section {
            text-align: center;
            margin-bottom: 30px;
        }
        .rating-section h3 {
            color: #333;
            margin-bottom: 20px;
        }
        .stars {
            display: flex;
            justify-content: center;
            gap: 15px;
            font-size: 40px;
            cursor: pointer;
        }
        .star {
            color: #ddd;
            transition: all 0.3s;
        }
        .star:hover,
        .star.active {
            color: #ffd700;
            transform: scale(1.1);
        }
        .rating-text {
            margin-top: 15px;
            color: #666;
            font-size: 16px;
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
        .form-group textarea {
            width: 100%;
            padding: 12px 15px;
            border: 2px solid #e1e1e1;
            border-radius: 6px;
            font-size: 15px;
            height: 120px;
            resize: vertical;
        }
        .form-group textarea:focus {
            border-color: #667eea;
            outline: none;
        }
        .btn {
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
        }
        .btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(102,126,234,0.4);
        }
        .btn-secondary {
            background: #95a5a6;
            margin-top: 10px;
        }
        .btn-secondary:hover {
            background: #7f8c8d;
        }
    </style>
</head>
<body>
<div class="evaluate-container">
    <h2>服务评价</h2>

    <div class="order-info">
        <div class="order-info-item">
            <span class="order-info-label">订单号：</span>
            <span class="order-info-value">${order.orderNo}</span>
        </div>
        <div class="order-info-item">
            <span class="order-info-label">车辆信息：</span>
            <span class="order-info-value">${order.vehicle.plateNumber} - ${order.vehicle.model}</span>
        </div>
        <div class="order-info-item">
            <span class="order-info-label">服务类型：</span>
            <span class="order-info-value">
                    <c:choose>
                        <c:when test="${order.serviceType == 'maintenance'}">保养</c:when>
                        <c:when test="${order.serviceType == 'repair'}">维修</c:when>
                        <c:otherwise>检测</c:otherwise>
                    </c:choose>
                </span>
        </div>
        <div class="order-info-item">
            <span class="order-info-label">服务时间：</span>
            <span class="order-info-value">
                    <fmt:formatDate value="${order.appointmentTime}" pattern="yyyy-MM-dd HH:mm"/>
                </span>
        </div>
    </div>

    <form action="${pageContext.request.contextPath}/owner/evaluation/submit" method="post">
        <input type="hidden" name="orderId" value="${order.id}">
        <input type="hidden" name="rating" id="rating" value="5">

        <div class="rating-section">
            <h3>请为本次服务打分</h3>
            <div class="stars" id="stars">
                <span class="star active" data-value="5">★</span>
                <span class="star" data-value="4">★</span>
                <span class="star" data-value="3">★</span>
                <span class="star" data-value="2">★</span>
                <span class="star" data-value="1">★</span>
            </div>
            <div class="rating-text" id="ratingText">非常满意</div>
        </div>

        <div class="form-group">
            <label>评价内容：</label>
            <textarea name="comment" placeholder="请写下您的评价和建议..."></textarea>
        </div>

        <button type="submit" class="btn">提交评价</button>
        <a href="${pageContext.request.contextPath}/owner/orders" class="btn btn-secondary">返回</a>
    </form>
</div>

<script>
    const stars = document.querySelectorAll('.star');
    const ratingInput = document.getElementById('rating');
    const ratingText = document.getElementById('ratingText');

    const ratingDescriptions = {
        5: '非常满意',
        4: '满意',
        3: '一般',
        2: '不满意',
        1: '非常不满意'
    };

    stars.forEach(star => {
        star.addEventListener('click', function() {
            const value = this.getAttribute('data-value');
            ratingInput.value = value;

            stars.forEach(s => s.classList.remove('active'));

            stars.forEach(s => {
                if (s.getAttribute('data-value') <= value) {
                    s.classList.add('active');
                }
            });

            ratingText.textContent = ratingDescriptions[value];
        });

        star.addEventListener('mouseover', function() {
            const value = this.getAttribute('data-value');

            stars.forEach(s => {
                if (s.getAttribute('data-value') <= value) {
                    s.style.color = '#ffd700';
                } else {
                    s.style.color = '#ddd';
                }
            });
        });

        star.addEventListener('mouseout', function() {
            const currentValue = ratingInput.value;

            stars.forEach(s => {
                if (s.getAttribute('data-value') <= currentValue) {
                    s.style.color = '#ffd700';
                } else {
                    s.style.color = '#ddd';
                }
            });
        });
    });
</script>
</body>
</html>