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
            background: #f8f9fa;
        }

        .chat-message {
            margin-bottom: 15px;
            display: flex;
            flex-direction: column;
        }

        .chat-message.sent {
            align-items: flex-end;
        }

        .chat-message.received {
            align-items: flex-start;
        }

        .message-bubble {
            max-width: 70%;
            padding: 12px 16px;
            border-radius: 18px;
            word-wrap: break-word;
        }

        .chat-message.sent .message-bubble {
            background: var(--primary-color);
            color: white;
            border-bottom-right-radius: 4px;
        }

        .chat-message.received .message-bubble {
            background: white;
            color: #333;
            border-bottom-left-radius: 4px;
            box-shadow: 0 1px 2px rgba(0, 0, 0, 0.1);
        }

        .message-time {
            font-size: 11px;
            color: #999;
            margin-top: 5px;
            padding: 0 5px;
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
            <div class="message-bubble">
                안녕하세요! 무엇을 도와드릴까요?
            </div>
            <div class="message-time">지금</div>
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

            // Simulate response (실제로는 서버와 통신)
            setTimeout(function() {
                addMessage('감사합니다. 문의사항을 확인했습니다. 담당자가 곧 답변드리겠습니다.', 'received');
            }, 1000);
        }

        // Add message to chat
        function addMessage(text, type) {
            const messageDiv = document.createElement('div');
            messageDiv.className = `chat-message ${type}`;

            const bubble = document.createElement('div');
            bubble.className = 'message-bubble';
            bubble.textContent = text;

            const time = document.createElement('div');
            time.className = 'message-time';
            const now = new Date();
            time.textContent = now.getHours() + ':' + String(now.getMinutes()).padStart(2, '0');

            messageDiv.appendChild(bubble);
            messageDiv.appendChild(time);
            chatMessages.appendChild(messageDiv);

            // Scroll to bottom
            chatMessages.scrollTop = chatMessages.scrollHeight;
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