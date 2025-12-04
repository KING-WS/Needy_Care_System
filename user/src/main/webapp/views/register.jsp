<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <title>회원가입 - Needy Care System</title>
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
            font-family: 'Noto Sans KR', sans-serif;
            background: #f8f9fa; /* 전체 배경을 연한 회색으로 변경하여 카드 효과 강조 */
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 40px 20px;
        }

        .register-container {
            max-width: 500px;
            width: 100%;
            /* 카드 스타일 적용: 둥근 모서리, 그림자 */
            background: var(--card-bg);
            border-radius: 20px;
            padding: 40px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.05);
        }

        .register-header {
            text-align: center;
            margin-bottom: 35px;
        }

        .register-header h2 {
            font-size: 32px; /* 헤더 폰트 크기 강조 */
            font-weight: 800; /* 헤더 폰트 두께 강조 */
            color: var(--secondary-color);
            margin-bottom: 10px;
        }

        .register-header p {
            font-size: 15px;
            color: #7f8c8d;
        }

        .register-header p a {
            color: var(--primary-color);
            text-decoration: none;
            font-weight: 600;
        }

        .register-header p a:hover {
            text-decoration: underline;
        }

        .form-group {
            margin-bottom: 25px;
        }

        .form-label {
            font-weight: 700;
            color: var(--secondary-color);
            margin-bottom: 8px;
            display: block;
            font-size: 14px;
        }

        .form-label .required {
            color: var(--danger-color); /* accent-color 대신 danger-color 사용 */
            margin-left: 3px;
        }

        .form-control {
            width: 100%;
            padding: 12px 15px;
            border: 1px solid transparent;
            border-radius: 12px; /* 둥근 입력창 모서리 통일 */
            font-size: 15px;
            transition: all 0.3s;
            background: var(--secondary-bg);
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
            border-color: var(--danger-color);
            box-shadow: 0 0 0 3px rgba(231, 76, 60, 0.1);
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
            font-size: 16px;
        }

        .toggle-password:hover {
            color: var(--primary-color);
        }

        /* 알림 메시지 스타일 통일 */
        .alert {
            padding: 15px 20px;
            border-radius: 12px;
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

        .btn-register {
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

        .btn-register:hover {
            transform: translateY(-2px);
            background: #2980b9;
            box-shadow: none;
        }

        .btn-register:active {
            transform: translateY(0);
        }

        .login-link {
            display: block;
            text-align: center;
            margin-top: 20px;
            font-size: 14px;
            color: var(--secondary-color);
            text-decoration: none;
        }

        .login-link:hover {
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
            .register-container {
                padding: 30px 20px;
                box-shadow: none;
            }

            .register-header h2 {
                font-size: 28px;
            }
        }
    </style>
</head>
<body>
    <div class="register-container">
        <div class="register-header">
            <h2>회원가입</h2>
            <p>회원 정보를 입력해주세요</p>
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
            <div class="form-group">
                <label class="form-label">
                    이메일 <span class="required">*</span>
                </label>
                <input type="email" name="custEmail" id="custEmail" class="form-control"
                       placeholder="이메일을 입력하세요" required>
            </div>

            <div class="form-group">
                <label class="form-label">
                    비밀번호 <span class="required">*</span>
                </label>
                <div class="password-wrapper">
                    <input type="password" name="custPwd" id="password"
                           class="form-control" placeholder="비밀번호를 입력하세요 (8자 이상, 영문+숫자+특수문자)"
                           pattern="^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*#?&])[A-Za-z\d@$!%*#?&]{8,}$"
                           title="비밀번호는 8자 이상이며 영문, 숫자, 특수문자를 포함해야 합니다."
                           required>
                    <i class="fas fa-eye toggle-password" onclick="togglePassword('password')"></i>
                </div>
                <small class="form-text" style="color: #666; font-size: 12px; margin-top: 5px; display: block;">
                    <i class="fas fa-info-circle"></i> 8자 이상, 영문+숫자+특수문자 조합
                </small>
            </div>

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

            <div class="form-group">
                <label class="form-label">
                    이름 <span class="required">*</span>
                </label>
                <input type="text" name="custName" class="form-control"
                       placeholder="이름을 입력하세요" required>
            </div>

            <div class="form-group">
                <label class="form-label">
                    전화번호 <span class="required">*</span>
                </label>
                <input type="tel" name="custPhone" class="form-control"
                       placeholder="010-0000-0000" required
                       pattern="[0-9]{3}-[0-9]{4}-[0-9]{4}"
                       title="전화번호 형식: 010-0000-0000">
            </div>

            <button type="submit" class="btn-register">회원가입</button>
        </form>

        <a href="/login" class="login-link">이미 계정이 있으신가요?
        <span style="font-weight: 600; color: var(--primary-color);">로그인</span></a>
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

        // 비밀번호 형식 검증 함수 (기능적인 부분이지만, 기존 JavaScript를 그대로 유지함)
        function validatePassword(password) {
            const passwordRegex = /^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*#?&])[A-Za-z\d@$!%*#?&]{8,}$/;
            return passwordRegex.test(password);
        }

        // 비밀번호 입력 시 실시간 검증
        document.getElementById('password').addEventListener('input', function() {
            const password = this.value;
            const passwordField = this;

            if (password.length > 0 && !validatePassword(password)) {
                passwordField.classList.add('error');
                passwordField.setCustomValidity('비밀번호는 8자 이상이며 영문, 숫자, 특수문자를 포함해야 합니다.');
            } else {
                passwordField.classList.remove('error');
                passwordField.setCustomValidity('');
            }
        });

        // 폼 제출 시 유효성 검사
        document.getElementById('registerForm').addEventListener('submit', function(e) {
            const password = document.getElementById('password').value;
            const passwordConfirm = document.getElementById('passwordConfirm').value;

            // 비밀번호 형식 검증
            if (!validatePassword(password)) {
                e.preventDefault();
                alert('비밀번호는 8자 이상이며 영문, 숫자, 특수문자를 포함해야 합니다.');
                document.getElementById('password').classList.add('error');
                document.getElementById('password').focus();
                return false;
            }

            // 비밀번호 확인 검증
            if (password !== passwordConfirm) {
                e.preventDefault();
                alert('비밀번호가 일치하지 않습니다.');
                document.getElementById('passwordConfirm').classList.add('error');
                document.getElementById('passwordConfirm').focus();
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