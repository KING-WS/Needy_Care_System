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

        html, body {
            height: 100%;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            color: #333;
            overflow-x: hidden;
            display: flex;
            flex-direction: column;
        }

        /* Header */
        header {
            background: #fff;
            box-shadow: 0 2px 15px rgba(0,0,0,0.1);
            position: fixed;
            width: 100%;
            top: 0;
            z-index: 1100;
            transition: all 0.3s;
        }

        .navbar {
            padding: 15px 0;
        }

        .navbar .container {
            display: flex;
            justify-content: space-between;
            align-items: center;
            max-width: 100%;
            padding: 0 30px;
            position: relative;
        }

        /* 왼쪽: 로고 */
        .navbar-brand {
            font-size: 28px;
            font-weight: bold;
            color: var(--primary-color) !important;
            text-decoration: none;
            order: 1;
        }

        /* 중앙: 메뉴 */
        .navbar-nav {
            display: flex;
            align-items: center;
            gap: 30px;
            list-style: none;
            margin: 0;
            padding: 0;
            position: absolute;
            left: 50%;
            transform: translateX(-50%);
        }

        .nav-item {
            margin: 0;
        }

        .nav-link {
            color: var(--secondary-color) !important;
            font-weight: 500;
            transition: color 0.3s;
            text-decoration: none;
            white-space: nowrap;
        }

        .nav-link:hover {
            color: var(--primary-color) !important;
        }

        /* 오른쪽: 사용자 정보 */
        .user-info {
            display: flex;
            align-items: center;
            gap: 15px;
            order: 3;
        }

        .user-name {
            color: var(--primary-color);
            font-weight: 600;
            font-size: 16px;
            transition: all 0.3s;
            text-decoration: none;
        }

        .user-name:hover {
            color: var(--secondary-color);
            transform: translateY(-2px);
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

        /* 반응형 토글 숨김 */
        .navbar-toggler {
            display: none;
        }

        .navbar-collapse {
            display: flex !important;
            flex-basis: auto;
        }

        /* Sidebar Toggle Button */
        .sidebar-toggle {
            position: fixed;
            left: 20px;
            top: 100px;
            z-index: 1050;
            background: var(--primary-color);
            color: white;
            border: none;
            border-radius: 50%;
            width: 50px;
            height: 50px;
            font-size: 20px;
            cursor: pointer;
            box-shadow: 0 4px 8px rgba(0,0,0,0.2);
            transition: left 0.3s ease;
            display: none;
        }

        .sidebar-toggle.show {
            display: block;
        }

        .sidebar-toggle.active {
            left: 320px;
        }

        .sidebar-toggle:hover {
            background: var(--secondary-color);
            transform: scale(1.1);
        }

        /* Sidebar Styles */
        .sidebar {
            position: fixed;
            left: -300px;
            top: 80px;
            width: 300px;
            height: calc(100vh - 80px);
            background: white;
            box-shadow: 2px 0 10px rgba(0,0,0,0.1);
            transition: left 0.3s ease;
            z-index: 1040;
            overflow-y: auto;
        }

        .sidebar.active {
            left: 0;
        }

        /* Main content margin when sidebar is open */
        .main-content {
            transition: margin-left 0.3s ease, padding 0.3s ease;
            padding: 0 1rem 0 90px;
            margin-top: 80px;
            flex: 1;
            min-height: calc(100vh - 80px - 100px);
        }

        .main-content.sidebar-active {
            margin-left: 302px; /* 300px sidebar + 2px gap */
            padding: 0 1rem;
        }

        /* Overlay */
        .sidebar-overlay {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0,0,0,0.5);
            z-index: 1030;
            display: none;
        }

        .sidebar-overlay.active {
            display: block;
        }

        /* Dashboard Section */
        #user-dashboard {
            min-height: calc(100vh - 80px);
            padding: 30px 0;
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
            flex-shrink: 0;
            margin-top: auto;
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
            <!-- 왼쪽: 로고 -->
            <a class="navbar-brand" href="/">Aventro</a>
            
            <!-- 중앙: 메뉴 -->
            <ul class="navbar-nav">
                <li class="nav-item"><a class="nav-link" href="<c:url value="/home"/>">HOME</a></li>
                <li class="nav-item"><a class="nav-link" href="<c:url value="/comm"/>">통신</a></li>
                <li class="nav-item"><a class="nav-link" href="<c:url value="/schedule"/>">일정</a></li>
                <li class="nav-item"><a class="nav-link" href="<c:url value="/cctv"/>">CCTV</a></li>
                <li class="nav-item"><a class="nav-link" href="<c:url value="/page"/>">페이지</a></li>
            </ul>
            
            <!-- 오른쪽: 사용자 정보 -->
            <c:choose>
                <c:when test="${sessionScope.loginUser != null}">
                    <div class="user-info">
                        <a href="<c:url value="/mypage"/>" class="user-name">
                            <i class="fas fa-user-circle"></i> ${sessionScope.loginUser.custName}님
                        </a>
                        <a href="/logout" class="btn-logout">로그아웃</a>
                    </div>
                </c:when>
                <c:otherwise>
                    <a href="/login" class="btn-login-nav">로그인</a>
                </c:otherwise>
            </c:choose>
        </div>
    </nav>
</header>

<!-- Sidebar Toggle Button (only show when left menu exists) -->
<c:if test="${left != null}">
    <button class="sidebar-toggle show" id="sidebarToggle">
        <i class="fas fa-bars"></i>
    </button>
</c:if>

<!-- Sidebar Overlay -->
<div class="sidebar-overlay" id="sidebarOverlay"></div>

<!-- Left Sidebar (if exists) -->
<c:if test="${left != null}">
    <nav class="sidebar" id="sidebar">
        <div class="sidebar-sticky pt-3">
            <jsp:include page="${left}.jsp"/>
        </div>
    </nav>
</c:if>

<!-- Main Content Area -->
<div class="main-content" id="mainContent">
    <c:choose>
        <c:when test="${center == null}">
            <jsp:include page="center.jsp"/>
        </c:when>
        <c:otherwise>
            <jsp:include page="${center}.jsp"/>
        </c:otherwise>
    </c:choose>
</div>

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
<script>
    // Sidebar Toggle Functionality
    document.addEventListener('DOMContentLoaded', function() {
        const sidebarToggle = document.getElementById('sidebarToggle');
        const sidebar = document.getElementById('sidebar');
        const sidebarOverlay = document.getElementById('sidebarOverlay');
        const mainContent = document.getElementById('mainContent');
        
        if (sidebarToggle && sidebar) {
            // Toggle sidebar on button click
            sidebarToggle.addEventListener('click', function() {
                sidebar.classList.toggle('active');
                sidebarOverlay.classList.toggle('active');
                mainContent.classList.toggle('sidebar-active');
                this.classList.toggle('active');
                
                // Change icon
                const icon = this.querySelector('i');
                if (sidebar.classList.contains('active')) {
                    icon.classList.remove('fa-bars');
                    icon.classList.add('fa-times');
                } else {
                    icon.classList.remove('fa-times');
                    icon.classList.add('fa-bars');
                }
            });
            
            // Close sidebar when clicking overlay
            sidebarOverlay.addEventListener('click', function() {
                sidebar.classList.remove('active');
                sidebarOverlay.classList.remove('active');
                mainContent.classList.remove('sidebar-active');
                sidebarToggle.classList.remove('active');
                
                const icon = sidebarToggle.querySelector('i');
                icon.classList.remove('fa-times');
                icon.classList.add('fa-bars');
            });
        }
    });
</script>
</body>
</html>
