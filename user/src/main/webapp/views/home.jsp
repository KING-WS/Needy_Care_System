<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Home - Aventro</title>
    <link rel="icon" type="image/png" href="/img/favicontitle.png">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.2/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css" rel="stylesheet">
    <script src="https://dapi.kakao.com/v2/maps/sdk.js?appkey=9122c6ed65a3629b19d62bab6d93ffaf&libraries=services"></script>
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
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
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .navbar-brand img {
            width: 32px;
            height: 32px;
            object-fit: contain;
            transition: all 0.3s ease;
        }

        .navbar-brand:hover img {
            transform: rotate(360deg) scale(1.2);
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
            flex: 1 0 auto;
            min-height: calc(100vh - 80px);
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
            margin-top: 0;
            width: 100%;
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

        /* Floating Chat Button */
        .floating-chat-btn {
            position: fixed;
            bottom: 110px;
            right: 30px;
            width: 60px;
            height: 60px;
            background: linear-gradient(135deg, var(--primary-color), #2980b9);
            color: white;
            border: none;
            border-radius: 50%;
            font-size: 24px;
            cursor: pointer;
            box-shadow: 0 4px 8px rgba(0,0,0,0.2);
            z-index: 1000;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .floating-chat-btn:hover {
            transform: scale(1.1);
            box-shadow: 0 6px 12px rgba(0,0,0,0.3);
        }

        .floating-chat-btn .badge {
            position: absolute;
            top: -5px;
            right: -5px;
            background: var(--accent-color);
            color: white;
            border-radius: 50%;
            width: 24px;
            height: 24px;
            font-size: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: bold;
        }

        /* Chat Modal */
        .chat-modal {
            display: none;
            position: fixed;
            bottom: 100px;
            right: 30px;
            width: 380px;
            height: 600px;
            background: white;
            border-radius: 20px;
            box-shadow: 0 10px 40px rgba(0, 0, 0, 0.2);
            z-index: 1001;
            flex-direction: column;
            overflow: hidden;
            animation: slideUp 0.3s ease;
        }

        .chat-modal.active {
            display: flex;
        }

        @keyframes slideUp {
            from {
                opacity: 0;
                transform: translateY(20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .chat-header {
            background: linear-gradient(135deg, var(--primary-color), #2980b9);
            color: white;
            padding: 20px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .chat-header h5 {
            margin: 0;
            font-size: 18px;
            font-weight: 600;
        }

        .chat-header .status {
            font-size: 12px;
            opacity: 0.9;
        }

        .chat-header .close-btn {
            background: none;
            border: none;
            color: white;
            font-size: 20px;
            cursor: pointer;
            padding: 5px;
            border-radius: 50%;
            width: 30px;
            height: 30px;
            display: flex;
            align-items: center;
            justify-content: center;
            transition: background 0.3s;
        }

        .chat-header .close-btn:hover {
            background: rgba(255, 255, 255, 0.2);
        }

        .chat-messages {
            flex: 1;
            overflow-y: auto;
            padding: 20px;
            background: #f0f2f5;
            display: flex;
            flex-direction: column;
        }

        .chat-message {
            margin-bottom: 12px;
            display: flex;
            align-items: flex-end;
            gap: 8px;
            width: 100%;
        }

        /* 말풍선 레이아웃 스타일 - 사용자 메시지를 완전히 오른쪽에 배치 */
        .chat-messages .chat-message.sent {
            flex-direction: row-reverse !important;
            justify-content: flex-end !important;
            align-items: flex-end !important;
            margin-left: auto !important;
            margin-right: 0 !important;
            max-width: 85% !important;
            width: 100% !important;
        }

        .chat-messages .chat-message.received {
            flex-direction: row !important;
            justify-content: flex-start !important;
            margin-right: auto !important;
            max-width: 95% !important;
        }

        .message-avatar {
            width: 32px;
            height: 32px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            flex-shrink: 0;
            font-size: 14px;
            margin-bottom: 2px;
        }

        /* 아바타 스타일 - 사용자 메시지 아바타 숨김 */
        .chat-messages .chat-message.sent .message-avatar {
            display: none !important;
        }

        .chat-messages .chat-message.received .message-avatar {
            background: #e4e6eb !important;
            color: #65676b !important;
        }

        .message-content-wrapper {
            display: flex;
            flex-direction: column;
            max-width: 70%;
            min-width: 0;
        }

        .chat-messages .chat-message.sent .message-content-wrapper {
            align-items: flex-end !important;
            margin-left: auto !important;
            margin-right: 0 !important;
            max-width: 85% !important;
        }

        /* AI 봇 메시지 말풍선을 더 넓게 */
        .chat-messages .chat-message.received .message-content-wrapper {
            align-items: flex-start;
            max-width: 90% !important;
            min-width: 200px;
        }

        .message-bubble-wrapper {
            display: flex;
            align-items: flex-end;
            gap: 6px;
        }

        .chat-messages .chat-message.sent .message-bubble-wrapper {
            flex-direction: row-reverse;
        }

        .chat-messages .chat-message.received .message-bubble-wrapper {
            flex-direction: row;
        }

        .message-sender {
            font-size: 12px;
            font-weight: 600;
            color: #65676b;
            margin-bottom: 4px;
            padding: 0 4px;
        }

        .chat-messages .chat-message.sent .message-sender {
            text-align: right;
            color: #0084ff;
        }

        .chat-messages .chat-message.received .message-sender {
            text-align: left;
            color: #65676b;
        }

        .message-bubble {
            padding: 12px 16px;
            border-radius: 18px;
            word-wrap: break-word;
            word-break: break-word;
            position: relative;
            line-height: 1.5;
            display: inline-block;
            max-width: 100%;
            /* 기본 스타일은 제거 - 각 타입별로 명시적으로 설정 */
        }
        
        /* AI 봇 메시지 말풍선을 더 넓고 읽기 편하게 */
        .chat-messages .chat-message.received .message-bubble {
            min-width: 250px;
            max-width: 100%;
        }

        /* 말풍선 스타일 - 최고 우선순위로 설정 (모든 외부 CSS 이후에 적용) */
        #chatMessages .chat-message.sent .message-bubble,
        .chat-modal #chatMessages .chat-message.sent .message-bubble {
            background: #0084ff !important;
            color: white !important;
            border-bottom-right-radius: 4px !important;
        }

        #chatMessages .chat-message.sent .message-bubble::after,
        .chat-modal #chatMessages .chat-message.sent .message-bubble::after {
            content: '' !important;
            position: absolute !important;
            right: -8px !important;
            bottom: 0 !important;
            width: 0 !important;
            height: 0 !important;
            border: 8px solid transparent !important;
            border-left-color: #0084ff !important;
            border-right: none !important;
            border-bottom: none !important;
            border-top: none !important;
        }

        #chatMessages .chat-message.received .message-bubble,
        .chat-modal #chatMessages .chat-message.received .message-bubble {
            background: #ffffff !important;
            color: #1c1e21 !important;
            border-bottom-left-radius: 4px !important;
            border: 1px solid #e4e6eb !important;
            box-shadow: 0 1px 2px rgba(0, 0, 0, 0.05) !important;
        }

        #chatMessages .chat-message.received .message-bubble::after,
        .chat-modal #chatMessages .chat-message.received .message-bubble::after {
            content: '' !important;
            position: absolute !important;
            left: -8px !important;
            bottom: 0 !important;
            width: 0 !important;
            height: 0 !important;
            border: 8px solid transparent !important;
            border-right-color: white !important;
            border-left: none !important;
            border-bottom: none !important;
        }

        .message-time {
            font-size: 11px;
            color: #8a8d91;
            padding: 0 2px;
            white-space: nowrap;
            margin-bottom: 2px;
            line-height: 1.2;
        }

        .chat-input-area {
            padding: 15px;
            background: white;
            border-top: 1px solid #e0e0e0;
            display: flex;
            gap: 10px;
        }

        .chat-input {
            flex: 1;
            border: 1px solid #e0e0e0;
            border-radius: 25px;
            padding: 10px 20px;
            font-size: 14px;
            outline: none;
            transition: border-color 0.3s;
        }

        .chat-input:focus {
            border-color: var(--primary-color);
        }

        .chat-send-btn {
            background: var(--primary-color);
            color: white;
            border: none;
            border-radius: 50%;
            width: 45px;
            height: 45px;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            transition: all 0.3s;
        }

        .chat-send-btn:hover {
            background: #2980b9;
            transform: scale(1.05);
        }

        .chat-send-btn:disabled {
            background: #ccc;
            cursor: not-allowed;
        }

        /* Responsive */
        @media (max-width: 768px) {
            .chat-modal {
                width: calc(100% - 40px);
                right: 20px;
                left: 20px;
                height: calc(100vh - 120px);
            }

            .floating-chat-btn {
                bottom: 20px;
                right: 20px;
            }
        }
    </style>
</head>
<body>
<!-- Header -->
<header>
    <nav class="navbar navbar-expand-lg">
        <div class="container">
            <!-- 왼쪽: 로고 -->
            <a class="navbar-brand" href="/">
                <img src="/img/favicontitle.png" alt="Aventro Logo">
                Aventro
            </a>

            <!-- 중앙: 메뉴 -->
            <ul class="navbar-nav">
                <li class="nav-item"><a class="nav-link" href="<c:url value="/home"/>"><i class="fas fa-home"></i> HOME</a></li>
                <li class="nav-item"><a class="nav-link" href="<c:url value="/comm"/>"><i class="fas fa-comments"></i> 통신</a></li>
                <li class="nav-item"><a class="nav-link" href="<c:url value="/schedule"/>"><i class="fas fa-calendar-alt"></i> 일정</a></li>
                <li class="nav-item"><a class="nav-link" href="<c:url value="/mealplan"/>"><i class="fas fa-utensils"></i> 식단관리</a></li>
                <li class="nav-item"><a class="nav-link" href="<c:url value="/cctv"/>"><i class="fas fa-video"></i> CCTV</a></li>
                <li class="nav-item"><a class="nav-link" href="<c:url value="/caregiver"/>"><i class="fas fa-id-card-alt"></i> 요양사</a></li>
                <li class="nav-item"><a class="nav-link" href="<c:url value="/page"/>"><i class="fas fa-file-alt"></i> 페이지</a></li>
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

<!-- Floating Chat Button -->
<button class="floating-chat-btn" id="floatingChatBtn" title="채팅하기">
    <i class="fas fa-robot"></i>
    <span class="badge" id="chatBadge" style="display: none;">0</span>
</button>

<!-- Chat Modal -->
<div class="chat-modal" id="chatModal">
    <div class="chat-header">
        <div>
            <h5><i class="fas fa-comments"></i> AI 봇</h5>
            <div class="status">온라인</div>
        </div>
        <button class="close-btn" id="closeChatBtn">
            <i class="fas fa-times"></i>
        </button>
    </div>
    <div class="chat-messages" id="chatMessages">
        <div class="chat-message received">
            <div class="message-avatar">
                <i class="fas fa-robot"></i>
            </div>
            <div class="message-content-wrapper">
                <div class="message-sender">AI 봇</div>
                <div class="message-bubble-wrapper">
                    <div class="message-bubble">
                        안녕하세요! 무엇을 도와드릴까요?
                    </div>
                    <div class="message-time" id="initialMessageTime"></div>
                </div>
            </div>
        </div>
    </div>
    <div class="chat-input-area">
        <input type="text" class="chat-input" id="chatInput" placeholder="메시지를 입력하세요..." maxlength="500">
        <button class="chat-send-btn" id="chatSendBtn">
            <i class="fas fa-paper-plane"></i>
        </button>
    </div>
</div>

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

        // Chat Functionality
        const floatingChatBtn = document.getElementById('floatingChatBtn');
        const chatModal = document.getElementById('chatModal');
        const closeChatBtn = document.getElementById('closeChatBtn');
        const chatInput = document.getElementById('chatInput');
        const chatSendBtn = document.getElementById('chatSendBtn');
        const chatMessages = document.getElementById('chatMessages');
        const chatBadge = document.getElementById('chatBadge');

        // 사용자 이름 설정
        var userName = '사용자';
        <c:if test="${sessionScope.loginUser != null}">
        userName = '<c:out value="${sessionScope.loginUser.custName}" escapeXml="true"/>';
        </c:if>

        // 첫 메시지 시간 설정
        const initialMessageTime = document.getElementById('initialMessageTime');
        if (initialMessageTime) {
            const now = new Date();
            initialMessageTime.textContent = now.getHours() + ':' + String(now.getMinutes()).padStart(2, '0');
        }

        // Open chat modal
        floatingChatBtn.addEventListener('click', function() {
            chatModal.classList.add('active');
            chatInput.focus();
            // Hide badge when chat is open
            chatBadge.style.display = 'none';
        });

        // Close chat modal
        closeChatBtn.addEventListener('click', function() {
            chatModal.classList.remove('active');
        });

        // Send message function
        function sendMessage() {
            const message = chatInput.value.trim();
            if (message === '') return;

            // Add sent message
            addMessage(message, 'sent');

            // Clear input
            chatInput.value = '';

            // 로딩 메시지 표시
            const loadingId = 'loading-' + Date.now();
            addMessage('AI 응답을 생성 중입니다...', 'received', loadingId);

            // 실제 API 호출
            <c:choose>
                <c:when test="${selectedRecipient != null}">
                    const recId = ${selectedRecipient.recId};
                </c:when>
                <c:otherwise>
                    const recId = null;
                </c:otherwise>
            </c:choose>

            if (!recId) {
                removeMessage(loadingId);
                addMessage('오류: 사용자 정보를 찾을 수 없습니다. 다시 로그인해주세요.', 'received');
                return;
            }

            fetch('/api/chat/ai/send', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify({
                    message: message,
                    recId: recId
                })
            })
            .then(response => {
                if (!response.ok) {
                    throw new Error('서버 응답 오류: ' + response.status);
                }
                return response.json();
            })
            .then(data => {
                removeMessage(loadingId);
                const responseText = data.response || data.message || '응답을 받지 못했습니다.';
                addMessage(responseText, 'received');
            })
            .catch(error => {
                removeMessage(loadingId);
                console.error('AI 메시지 전송 중 오류 발생:', error);
                addMessage('죄송합니다. 응답을 생성하는 중 문제가 발생했어요. 잠시 후 다시 시도해주세요.', 'received');
            });
        }

        // Add message to chat
        function addMessage(text, type, messageId) {
            const messageDiv = document.createElement('div');
            // classList를 사용하여 클래스 추가 (더 확실함)
            messageDiv.classList.add('chat-message');
            if (type === 'sent' || type === 'received') {
                messageDiv.classList.add(type);
            }
            if (messageId) {
                messageDiv.id = messageId;
            }

            // 디버깅: 클래스 확인
            console.log('메시지 추가:', type, '클래스:', messageDiv.className, 'classList:', Array.from(messageDiv.classList));

            // 아바타 생성
            const avatar = document.createElement('div');
            avatar.className = 'message-avatar';
            if (type === 'sent') {
                avatar.innerHTML = '<i class="fas fa-user"></i>';
            } else {
                avatar.innerHTML = '<i class="fas fa-robot"></i>';
            }

            // 메시지 컨텐츠 래퍼
            const contentWrapper = document.createElement('div');
            contentWrapper.className = 'message-content-wrapper';

            // 발신자 이름
            const sender = document.createElement('div');
            sender.className = 'message-sender';
            sender.textContent = type === 'sent' ? userName : 'AI 봇';

            // 말풍선 래퍼 (말풍선 + 시간)
            const bubbleWrapper = document.createElement('div');
            bubbleWrapper.className = 'message-bubble-wrapper';

            // 말풍선
            const bubble = document.createElement('div');
            bubble.className = 'message-bubble';
            bubble.textContent = text;

            // 시간
            const time = document.createElement('div');
            time.className = 'message-time';
            const now = new Date();
            time.textContent = now.getHours() + ':' + String(now.getMinutes()).padStart(2, '0');

            // 구조 조립
            bubbleWrapper.appendChild(bubble);
            bubbleWrapper.appendChild(time);
            contentWrapper.appendChild(sender);
            contentWrapper.appendChild(bubbleWrapper);
            messageDiv.appendChild(avatar);
            messageDiv.appendChild(contentWrapper);
            
            // 클래스가 제대로 추가되었는지 다시 확인 및 수정
            if (!messageDiv.classList.contains('chat-message')) {
                messageDiv.classList.add('chat-message');
            }
            if (type === 'sent' && !messageDiv.classList.contains('sent')) {
                messageDiv.classList.add('sent');
            }
            if (type === 'received' && !messageDiv.classList.contains('received')) {
                messageDiv.classList.add('received');
            }
            
            chatMessages.appendChild(messageDiv);

            // Scroll to bottom
            chatMessages.scrollTop = chatMessages.scrollHeight;
            
            // 스타일 적용 확인 (디버깅용)
            setTimeout(() => {
                const computedStyle = window.getComputedStyle(bubble);
                const parentComputedStyle = window.getComputedStyle(messageDiv);
                console.log('말풍선 스타일 확인:', {
                    type: type,
                    background: computedStyle.backgroundColor,
                    color: computedStyle.color,
                    bubbleClasses: bubble.className,
                    messageDivClasses: messageDiv.className,
                    messageDivClassList: Array.from(messageDiv.classList),
                    hasReceived: messageDiv.classList.contains('received'),
                    hasSent: messageDiv.classList.contains('sent'),
                    parentBackground: parentComputedStyle.backgroundColor,
                    // CSS 선택자 매칭 확인
                    matchesSentSelector: messageDiv.matches('#chatMessages .chat-message.sent'),
                    matchesReceivedSelector: messageDiv.matches('#chatMessages .chat-message.received')
                });
            }, 100);
        }

        // Remove message from chat
        function removeMessage(messageId) {
            const messageElement = document.getElementById(messageId);
            if (messageElement) {
                messageElement.remove();
            }
        }

        // Send button click
        chatSendBtn.addEventListener('click', sendMessage);

        // Enter key press
        chatInput.addEventListener('keypress', function(e) {
            if (e.key === 'Enter') {
                sendMessage();
            }
        });

        // Show notification badge (예시)
        // 실제로는 서버에서 새 메시지가 올 때 이 함수를 호출
        function showNotification(count) {
            if (!chatModal.classList.contains('active')) {
                chatBadge.textContent = count;
                chatBadge.style.display = 'flex';
            }
        }
    });
</script>
</body>
</html>