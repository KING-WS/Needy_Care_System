<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>회원가입 - Aventro</title>
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

        .register-container {
            max-width: 400px;
            width: 100%;
        }

        .register-header {
            text-align: center;
            margin-bottom: 35px;
        }

        .register-header h2 {
            font-size: 28px;
            font-weight: 600;
            color: #2c3e50;
            margin-bottom: 10px;
        }

        .register-header p {
            font-size: 14px;
            color: #7f8c8d;
        }

        .register-header p a {
            color: var(--primary-color);
            text-decoration: none;
            font-weight: 500;
        }

        .register-header p a:hover {
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

        .form-label .required {
            color: var(--accent-color);
            margin-left: 3px;
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

        .form-control.error {
            border-color: var(--accent-color);
        }

        textarea.form-control {
            resize: vertical;
            min-height: 100px;
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

        .btn-register {
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

        .btn-register:hover {
            transform: translateY(-1px);
            box-shadow: 0 4px 12px rgba(52, 152, 219, 0.4);
        }

        .btn-register:active {
            transform: translateY(0);
        }

        .login-link {
            display: block;
            text-align: center;
            margin-top: 20px;
            font-size: 13px;
            color: var(--primary-color);
            text-decoration: none;
        }

        .login-link:hover {
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
            .register-container {
                padding: 0;
            }

            .register-header h2 {
                font-size: 24px;
            }
        }
    </style>
</head>
<body>
    <div class="register-container">
        <div class="register-header">
            <h2>회원가입</h2>
            <p>환자 및 보호자 정보를 입력해주세요</p>
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

        <form action="/register" method="post" id="registerForm">
            <!-- 로그인 ID -->
            <div class="form-group">
                <label class="form-label">
                    로그인 ID <span class="required">*</span>
                </label>
                <input type="text" name="username" class="form-control" 
                       placeholder="아이디를 입력하세요" required>
            </div>

            <!-- 비밀번호 -->
            <div class="form-group">
                <label class="form-label">
                    비밀번호 <span class="required">*</span>
                </label>
                <div class="password-wrapper">
                    <input type="password" name="password" id="password" 
                           class="form-control" placeholder="비밀번호를 입력하세요" required>
                    <i class="fas fa-eye toggle-password" onclick="togglePassword('password')"></i>
                </div>
            </div>

            <!-- 비밀번호 확인 -->
            <div class="form-group">
                <label class="form-label">
                    비밀번호 확인 <span class="required">*</span>
                </label>
                <div class="password-wrapper">
                    <input type="password" name="passwordConfirm" id="passwordConfirm" 
                           class="form-control" placeholder="비밀번호를 다시 입력하세요" required>
                    <i class="fas fa-eye toggle-password" onclick="togglePassword('passwordConfirm')"></i>
                </div>
            </div>

            <!-- 환자명 -->
            <div class="form-group">
                <label class="form-label">
                    환자명 <span class="required">*</span>
                </label>
                <input type="text" name="patientName" class="form-control" 
                       placeholder="환자 이름을 입력하세요" required>
            </div>

            <!-- 환자 특징 -->
            <div class="form-group">
                <label class="form-label">
                    환자 특징 <span class="required">*</span>
                </label>
                <textarea name="patientFeature" class="form-control" 
                          placeholder="환자의 특징이나 주의사항을 입력하세요" required></textarea>
            </div>

            <!-- 보호자명 -->
            <div class="form-group">
                <label class="form-label">
                    보호자명 <span class="required">*</span>
                </label>
                <input type="text" name="guardianName" class="form-control" 
                       placeholder="보호자 이름을 입력하세요" required>
            </div>

            <!-- 주소 -->
            <div class="form-group">
                <label class="form-label">
                    주소 <span class="required">*</span>
                </label>
                <input type="text" name="address" class="form-control" 
                       placeholder="주소를 입력하세요" required>
            </div>

            <button type="submit" class="btn-register">회원가입</button>
        </form>

        <a href="/login" class="login-link">이미 계정이 있으신가요? 로그인</a>
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

        // 폼 제출 시 유효성 검사
        document.getElementById('registerForm').addEventListener('submit', function(e) {
            const password = document.getElementById('password').value;
            const passwordConfirm = document.getElementById('passwordConfirm').value;
            
            if (password !== passwordConfirm) {
                e.preventDefault();
                alert('비밀번호가 일치하지 않습니다.');
                document.getElementById('passwordConfirm').classList.add('error');
                return false;
            }
            
            return true;
        });

        // 비밀번호 확인 필드 입력 시 오류 클래스 제거
        document.getElementById('passwordConfirm').addEventListener('input', function() {
            this.classList.remove('error');
        });
    </script>
</body>
</html>

