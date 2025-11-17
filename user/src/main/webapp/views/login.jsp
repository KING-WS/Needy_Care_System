<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>로그인 - Aventro</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.2/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <style>
        :root {
            --primary-color: #3498db;
            --secondary-color: #2c3e50;
            --accent-color: #e74c3c;
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: white;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 40px 20px;
        }

        .login-container {
            max-width: 400px;
            width: 100%;
        }

        .login-header {
            text-align: center;
            margin-bottom: 35px;
        }

        .login-header h2 {
            font-size: 28px;
            font-weight: 600;
            color: #2c3e50;
            margin-bottom: 10px;
        }

        .login-header p {
            font-size: 14px;
            color: #7f8c8d;
        }

        .login-header p a {
            color: var(--primary-color);
            text-decoration: none;
            font-weight: 500;
        }

        .login-header p a:hover {
            text-decoration: underline;
        }

        .form-group {
            margin-bottom: 25px;
        }

        .form-label {
            font-weight: 500;
            color: #555;
            margin-bottom: 8px;
            display: block;
            font-size: 13px;
        }

        .form-control {
            width: 100%;
            padding: 12px 15px;
            border: 1px solid #ddd;
            border-radius: 6px;
            font-size: 14px;
            transition: all 0.3s;
            background: #fafafa;
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
        }

        .toggle-password:hover {
            color: var(--primary-color);
        }

        .alert {
            padding: 12px 20px;
            border-radius: 10px;
            margin-bottom: 20px;
            font-size: 14px;
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
            background: linear-gradient(135deg, #3498db 0%, #2c3e50 100%);
            color: white;
            border: none;
            border-radius: 6px;
            font-size: 15px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s;
            margin-top: 10px;
        }

        .btn-login:hover {
            transform: translateY(-1px);
            box-shadow: 0 4px 12px rgba(52, 152, 219, 0.4);
        }

        .btn-login:active {
            transform: translateY(0);
        }

        .register-link {
            display: block;
            text-align: center;
            margin-top: 20px;
            font-size: 13px;
            color: var(--primary-color);
            text-decoration: none;
        }

        .register-link:hover {
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
                padding: 0;
            }

            .login-header h2 {
                font-size: 24px;
            }
        }
    </style>
</head>
<body>
    <div class="login-container">
        <div class="login-header">
            <h2>로그인</h2>
            <p>환영합니다! 로그인하여 서비스를 이용하세요</p>
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
            <!-- 이메일 -->
            <div class="form-group">
                <label class="form-label">이메일</label>
                <input type="email" name="custEmail" class="form-control" 
                       placeholder="이메일을 입력하세요" required>
            </div>

            <!-- 비밀번호 -->
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

        <a href="/register" class="register-link">계정이 없으신가요? 회원가입</a>
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

