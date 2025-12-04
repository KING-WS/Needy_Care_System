<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<style>
    /* ---------------------------------------------------- */
    /* 1. 디자인 시스템 (공통 변수 재정의) */
    /* ---------------------------------------------------- */
    :root {
        --primary-color: #3498db;      /* 통일된 주 색상 */
        --secondary-color: #343a40;    /* 진한 회색 텍스트 */
        --secondary-bg: #F0F8FF;       /* 연한 배경색 (입력창 등) */
        --card-bg: white;
        --danger-color: #e74c3c;
    }

    body {
        background-color: #f8f9fa; /* 전체 배경색 유지 */
        font-family: 'Noto Sans KR', sans-serif;
    }

    /* ---------------------------------------------------- */
    /* 2. 레이아웃 및 컨테이너 */
    /* ---------------------------------------------------- */
    .profile-container {
        max-width: 800px;
        margin: 0 auto;
        padding: 40px 20px 100px 20px;
    }

    .page-header {
        text-align: center;
        margin-bottom: 40px;
    }

    .page-title {
        font-size: 38px;
        font-weight: 800;
        color: var(--secondary-color);
        margin-bottom: 10px;
        text-shadow: 0 1px 2px rgba(0, 0, 0, 0.05);
    }

    .page-title i {
        color: var(--primary-color);
        margin-right: 10px;
    }

    /* ---------------------------------------------------- */
    /* 3. 폼 카드 스타일 (edit.jsp / detail.jsp 공통) */
    /* ---------------------------------------------------- */
    .form-card {
        background: var(--card-bg);
        border-radius: 20px; /* 통일된 둥근 모서리 */
        padding: 40px;
        box-shadow: 0 10px 30px rgba(0,0,0,0.05); /* 깊은 그림자 */
    }

    /* ---------------------------------------------------- */
    /* 4. 입력 필드 스타일 */
    /* ---------------------------------------------------- */
    .form-group {
        margin-bottom: 25px;
    }

    .form-label {
        display: block;
        font-size: 14px;
        font-weight: 700;
        color: var(--secondary-color);
        margin-bottom: 8px;
    }

    .form-label i {
        color: var(--primary-color);
        margin-right: 5px;
    }

    .form-control {
        width: 100%;
        padding: 12px 15px;
        background: var(--secondary-bg);
        border: 1px solid transparent;
        border-radius: 12px; /* 통일된 입력창 모서리 */
        font-size: 15px;
        transition: all 0.3s ease;
        color: var(--secondary-color);
    }

    .form-control:focus {
        outline: none;
        background: white;
        border-color: var(--primary-color);
        box-shadow: 0 0 0 3px rgba(52, 152, 219, 0.1);
    }

    /* ---------------------------------------------------- */
    /* 5. 프로필 아바타 스타일 */
    /* ---------------------------------------------------- */
    .profile-avatar-container {
        position: relative;
        display: inline-block;
        margin-bottom: 30px;
    }

    .profile-avatar-icon {
        font-size: 120px;
        color: var(--primary-color);
        border: 4px solid var(--secondary-bg);
        border-radius: 50%;
        display: block; /* border를 제대로 적용하기 위해 block 처리 */
    }

    .btn-camera {
        position: absolute;
        bottom: 0;
        right: 0;
        border-radius: 50%;
        width: 40px;
        height: 40px;
        display: flex;
        align-items: center;
        justify-content: center;
        box-shadow: 0 2px 5px rgba(0,0,0,0.2);
    }

    /* ---------------------------------------------------- */
    /* 6. 버튼 스타일 (detail.jsp / edit.jsp 공통) */
    /* ---------------------------------------------------- */
    .btn-action {
        padding: 12px 30px;
        border: none;
        border-radius: 50px; /* 둥근 버튼 */
        font-size: 15px;
        font-weight: 700;
        cursor: pointer;
        transition: all 0.3s ease;
        display: inline-flex;
        align-items: center;
        gap: 8px;
        text-decoration: none; /* a 태그 스타일 제거 */
    }

    .btn-primary {
        background: var(--primary-color);
        color: white;
        box-shadow: 0 4px 15px rgba(52, 152, 219, 0.4);
    }

    .btn-primary:hover {
        background: #2980b9;
        transform: translateY(-2px);
        box-shadow: 0 6px 20px rgba(52, 152, 219, 0.6);
        color: white; /* 호버 시 텍스트 색상 유지 */
    }

    .btn-secondary {
        background: #e9ecef;
        color: #495057;
    }

    .btn-secondary:hover {
        background: #ced4da;
        transform: translateY(-2px);
    }
</style>

<div class="profile-container">
    <div class="page-header">
        <h1 class="page-title">
            <i class="fas fa-user-edit"></i> 프로필 수정
        </h1>
        <p style="font-size: 16px; color: #7f8c8d; margin-top: 10px;">
            회원님의 프로필 정보를 수정할 수 있습니다.
        </p>
    </div>

    <div class="form-card">
        <form action="<c:url value="/mypage/profile"/>" method="post">

            <div class="text-center">
                <div class="profile-avatar-container">
                    <i class="fas fa-user-circle profile-avatar-icon"></i>
                    <button type="button" class="btn btn-primary btn-camera">
                        <i class="fas fa-camera"></i>
                    </button>
                </div>
            </div>

            <div class="form-group">
                <label class="form-label">
                    <i class="fas fa-user"></i> 이름
                </label>
                <input type="text" name="custName" class="form-control"
                       value="${sessionScope.loginUser.custName}">
            </div>

            <div class="form-group">
                <label class="form-label">
                    <i class="fas fa-envelope"></i> 이메일
                </label>
                <input type="email" name="custEmail" class="form-control"
                       value="${sessionScope.loginUser.custEmail}">
            </div>

            <div class="form-group">
                <label class="form-label">
                    <i class="fas fa-phone"></i> 전화번호
                </label>
                <input type="tel" name="custPhone" class="form-control"
                       value="${sessionScope.loginUser.custPhone}"
                       placeholder="010-0000-0000">
            </div>

            <div class="form-group">
                <label class="form-label">
                    <i class="fas fa-comment-alt"></i> 자기소개
                </label>
                <textarea name="bio" class="form-control" rows="4"
                          placeholder="간단한 자기소개를 입력하세요"></textarea>
            </div>

            <div class="d-flex justify-content-between mt-4" style="padding-top: 20px; border-top: 1px solid #f0f0f0;">
                <a href="<c:url value="/mypage"/>" class="btn-action btn-secondary">
                    <i class="fas fa-times"></i> 취소
                </a>
                <button type="submit" class="btn-action btn-primary">
                    <i class="fas fa-save"></i> 저장하기
                </button>
            </div>
        </form>
    </div>
</div>