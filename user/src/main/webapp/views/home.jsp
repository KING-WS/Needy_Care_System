    <%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Home - Aventro</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.2/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <style>
        :root {
            --primary-color: #3498db;
            --secondary-color: #2c3e50;
            --accent-color: #e74c3c;
            --light-bg: #f8f9fa;
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            color: #333;
            overflow-x: hidden;
        }

        /* Header */
        header {
            background: #fff;
            box-shadow: 0 2px 15px rgba(0,0,0,0.1);
            position: fixed;
            width: 100%;
            top: 0;
            z-index: 1000;
            transition: all 0.3s;
        }

        .navbar {
            padding: 15px 0;
        }

        .navbar-brand {
            font-size: 28px;
            font-weight: bold;
            color: var(--primary-color) !important;
        }

        .nav-link {
            color: var(--secondary-color) !important;
            font-weight: 500;
            margin: 0 15px;
            transition: color 0.3s;
        }

        .nav-link:hover {
            color: var(--primary-color) !important;
        }

        .user-info {
            display: flex;
            align-items: center;
            gap: 15px;
            margin-left: 20px;
        }

        .user-name {
            color: var(--primary-color);
            font-weight: 600;
            font-size: 16px;
        }

        .btn-logout {
            background: var(--accent-color);
            color: white;
            padding: 8px 20px;
            border-radius: 20px;
            text-decoration: none;
            font-weight: 500;
            font-size: 14px;
            transition: all 0.3s;
            border: none;
        }

        .btn-logout:hover {
            background: #c0392b;
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(0,0,0,0.2);
        }

        /* Dashboard Section */
        #user-dashboard {
            min-height: calc(100vh - 80px);
            padding: 100px 0;
            background: #f8f9fa;
        }

        .dashboard-title {
            font-size: 48px;
            font-weight: bold;
            color: var(--secondary-color);
            text-align: center;
            margin-bottom: 20px;
        }

        .dashboard-subtitle {
            font-size: 20px;
            color: #666;
            text-align: center;
            margin-bottom: 50px;
        }

        .dashboard-card {
            border: none;
            border-radius: 15px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
            padding: 30px;
            height: 100%;
            text-align: center;
            transition: all 0.3s;
            background: white;
        }

        .dashboard-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 25px rgba(0,0,0,0.15);
        }

        .dashboard-card i {
            font-size: 60px;
            color: var(--primary-color);
            margin-bottom: 20px;
        }

        .dashboard-card h3 {
            font-size: 24px;
            margin-bottom: 10px;
            color: var(--secondary-color);
        }

        .dashboard-card p {
            color: #666;
            font-size: 15px;
        }

        /* Footer */
        footer {
            background: var(--secondary-color);
            color: white;
            padding: 40px 0 20px;
            text-align: center;
        }

        .footer-social a {
            color: white;
            margin: 0 15px;
            font-size: 24px;
            transition: color 0.3s;
        }

        .footer-social a:hover {
            color: var(--primary-color);
        }
    </style>
</head>
<body>
<!-- Header -->
<header>
    <nav class="navbar navbar-expand-lg">
        <div class="container">
            <a class="navbar-brand" href="/">Aventro</a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav ms-auto align-items-center">
                    <li class="nav-item"><a class="nav-link" href="/home">HOME</a></li>
                    <li class="nav-item"><a class="nav-link" href="/home?center=page1">통신</a></li>
                    <li class="nav-item"><a class="nav-link" href="/home?center=page2">일정</a></li>
                    <li class="nav-item"><a class="nav-link" href="/home?center=page3">CCTV</a></li>
                    <li class="nav-item"><a class="nav-link" href="/home?center=page4">페이지</a></li>
                    <li class="nav-item">
                        <div class="user-info">
                            <span class="user-name">
                                <i class="fas fa-user-circle"></i> ${sessionScope.loginUser.custName}님
                            </span>
                            <a href="/logout" class="btn-logout">로그아웃</a>
                        </div>
                    </li>
                </ul>
            </div>
        </div>
    </nav>
</header>

<!-- Dynamic Content Area -->
<c:choose>
    <c:when test="${center == null}">
        <jsp:include page="center.jsp"/>
    </c:when>
    <c:otherwise>
        <jsp:include page="${center}.jsp"/>
    </c:otherwise>
</c:choose>

<!-- Footer -->
<footer>
    <div class="container">
        <div class="footer-social mb-3">
            <a href="#"><i class="fab fa-twitter"></i></a>
            <a href="#"><i class="fab fa-facebook"></i></a>
            <a href="#"><i class="fab fa-instagram"></i></a>
            <a href="#"><i class="fab fa-linkedin"></i></a>
        </div>
        <p>&copy; 2024 Aventro. All Rights Reserved.</p>
    </div>
</footer>

<script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.2/js/bootstrap.bundle.min.js"></script>
</body>
</html>

