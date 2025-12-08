<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <title>로그인 - Needy Care System</title>
    <%@ include file="common/head.jsp" %>
    <style>
        /* ---------------------------------------------------- */
        /* 1. 디자인 시스템 (공통 변수 재정의) */
        /* ---------------------------------------------------- */
        :root {
            --primary-color: #3498db;      /* 통일된 주 색상 */
            --secondary-color: #2c3e50;    /* 진한 회색 텍스트 */
            --secondary-bg: #F0F8FF;       /* 연한 배경색 (입력창 등) */
            --card-bg: white;
            --danger-color: #e74c3c;
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            /* 폰트 변경: Noto Sans KR이 적용되었다고 가정 */
            font-family: 'Noto Sans KR', sans-serif;
            background: #f8f9fa; /* 전체 배경을 연한 회색으로 변경하여 카드 효과 강조 */
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 40px 20px;
        }

        .login-container {
            max-width: 400px;
            width: 100%;
            /* 카드 스타일 적용: 둥근 모서리, 그림자 */
            background: var(--card-bg);
            border-radius: 20px;
            padding: 40px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.05);
        }

        .login-header {
            text-align: center;
            margin-bottom: 35px;
        }

        .login-header h2 {
            font-size: 32px; /* 헤더 폰트 크기 강조 */
            font-weight: 800; /* 헤더 폰트 두께 강조 */
            color: var(--secondary-color);
            margin-bottom: 10px;
        }

        .login-header p {
            font-size: 15px;
            color: #7f8c8d;
        }

        .login-header p a {
            color: var(--primary-color);
            text-decoration: none;
            font-weight: 600;
        }

        .login-header p a:hover {
            text-decoration: underline;
        }

        .form-group {
            margin-bottom: 25px;
        }

        .form-label {
            font-weight: 700; /* 폰트 두께 강조 */
            color: var(--secondary-color); /* 색상 변경 */
            margin-bottom: 8px;
            display: block;
            font-size: 14px; /* 폰트 크기 변경 */
        }

        .form-control {
            width: 100%;
            padding: 12px 15px;
            border: 1px solid transparent; /* 투명한 테두리 */
            border-radius: 12px; /* 둥근 입력창 모서리 통일 */
            font-size: 15px; /* 폰트 크기 변경 */
            transition: all 0.3s;
            background: var(--secondary-bg); /* 배경색 변경 */
        }

        .form-control:focus {
            border-color: var(--primary-color);
            outline: none;
            background: white;
            box-shadow: 0 0 0 3px rgba(52, 152, 219, 0.1);
        }

        .form-control::placeholder {
            color: #aaa;
        }

        .password-wrapper {
            position: relative;
        }

        .toggle-password {
            position: absolute;
            right: 15px;
            top: 50%;
            transform: translateY(-50%);
            cursor: pointer;
            color: #999;
            transition: color 0.3s;
            font-size: 16px;
        }

        .toggle-password:hover {
            color: var(--primary-color);
        }

        /* 알림 메시지 스타일 통일 */
        .alert {
            padding: 15px 20px;
            border-radius: 12px; /* 둥근 모서리 */
            margin-bottom: 25px;
            font-size: 14px;
            font-weight: 500;
        }

        .alert-danger {
            background: #ffebee;
            color: #c62828;
            border: 1px solid #ef5350;
        }

        .alert-success {
            background: #e8f5e9;
            color: #2e7d32;
            border: 1px solid #66bb6a;
        }

        .btn-login {
            width: 100%;
            padding: 13px;
            background: var(--primary-color);
            color: white;
            border: none;
            border-radius: 50px;
            font-size: 16px;
            font-weight: 700;
            cursor: pointer;
            transition: all 0.3s;
            margin-top: 15px;
            box-shadow: none;
        }

        .btn-login:hover {
            transform: translateY(-2px); /* 호버 효과 강조 */
            background: #2980b9;
            box-shadow: none;
        }

        .btn-login:active {
            transform: translateY(0);
        }

        .register-link {
            display: block;
            text-align: center;
            margin-top: 20px;
            font-size: 14px;
            color: var(--secondary-color); /* 색상 변경 */
            text-decoration: none;
        }

        .register-link:hover {
            color: var(--primary-color);
            text-decoration: underline;
        }

        .btn-back {
            display: block;
            text-align: center;
            margin-top: 25px;
            color: #7f8c8d;
            text-decoration: none;
            font-size: 14px;
        }

        .btn-back:hover {
            color: var(--primary-color);
        }

        @media (max-width: 768px) {
            .login-container {
                padding: 30px 20px; /* 모바일에서 패딩 조정 */
                box-shadow: none; /* 모바일에서 그림자 제거 */
            }

            .login-header h2 {
                font-size: 28px;
            }
        }
    </style>
</head>
<body>
    <div class="login-container">
        <div class="login-header">
            <h2>로그인</h2>
            <p>환영합니다!
                <a href="/register">로그인하여 서비스를 이용하세요</a>
            </p>
        </div>

        <c:if test="${not empty error}">
            <div class="alert alert-danger">
                ${error}
            </div>
        </c:if>

        <c:if test="${not empty success}">
            <div class="alert alert-success">
                ${success}
            </div>
        </c:if>

        <form action="/login" method="post" id="loginForm">
            <div class="form-group">
                <label class="form-label">이메일</label>
                <input type="email" name="custEmail" class="form-control"
                       placeholder="이메일을 입력하세요" required>
            </div>

            <div class="form-group">
                <label class="form-label">비밀번호</label>
                <div class="password-wrapper">
                    <input type="password" name="password" id="password"
                           class="form-control" placeholder="비밀번호를 입력하세요" required>
                    <i class="fas fa-eye toggle-password" onclick="togglePassword('password')"></i>
                </div>
            </div>

            <button type="submit" class="btn-login">로그인</button>
        </form>

        <a href="/register" class="register-link">계정이 없으신가요?
        <span style="font-weight: 600; color: var(--primary-color);">회원가입</span></a>
        <a href="/" class="btn-back">← 메인으로 돌아가기</a>
    </div>

    <script>
        // 비밀번호 보기/숨기기
        function togglePassword(fieldId) {
            const field = document.getElementById(fieldId);
            const icon = event.target;

            if (field.type === 'password') {
                field.type = 'text';
                icon.classList.remove('fa-eye');
                icon.classList.add('fa-eye-slash');
            } else {
                field.type = 'password';
                icon.classList.remove('fa-eye-slash');
                icon.classList.add('fa-eye');
            }
        }
    </script>
</body>
</html>