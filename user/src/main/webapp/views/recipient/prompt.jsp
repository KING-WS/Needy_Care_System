<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<link rel="stylesheet" href="<c:url value='/css/mealplan.css'/>" />

<style>
    /* ---------------------------------------------------- */
    /* 1. 디자인 시스템 (center.jsp 통일) */
    /* ---------------------------------------------------- */
    :root {
        --primary-color: #3498db;   /* 메인 블루 */
        --secondary-color: #343a40; /* 진한 회색 */
        --secondary-bg: #F0F8FF;    /* 연한 배경 */
        --card-bg: white;
    }

    body {
        background-color: #f8f9fa;
        font-family: 'Noto Sans KR', sans-serif;
    }

    .prompt-container {
        display: flex;
        flex-direction: column;
        align-items: center;
        justify-content: center;
        min-height: 70vh; /* 높이 약간 조정 */
        padding: 40px 20px;
        text-align: center;
    }

    /* ---------------------------------------------------- */
    /* 2. 카드 스타일 */
    /* ---------------------------------------------------- */
    .prompt-card {
        background: var(--card-bg);
        border-radius: 20px;
        padding: 50px 40px;
        box-shadow: 0 10px 30px rgba(0,0,0,0.05); /* 부드러운 그림자 */
        max-width: 600px;
        width: 100%;
        margin-bottom: 30px;
        border: 1px solid transparent;
        transition: transform 0.3s ease;
    }

    .prompt-card:hover {
        transform: translateY(-5px);
        box-shadow: 0 15px 40px rgba(0,0,0,0.1);
    }

    /* ---------------------------------------------------- */
    /* 3. 아이콘 & 텍스트 */
    /* ---------------------------------------------------- */
    .prompt-icon {
        font-size: 80px;
        color: var(--primary-color); /* 메인 블루 적용 */
        margin-bottom: 30px;
        animation: bounce 2s infinite;
        background: var(--secondary-bg);
        width: 140px;
        height: 140px;
        line-height: 140px;
        border-radius: 50%;
        margin: 0 auto 30px auto;
    }

    @keyframes bounce {
        0%, 100% { transform: translateY(0); }
        50% { transform: translateY(-10px); }
    }

    .prompt-title {
        font-size: 28px;
        font-weight: 800;
        color: var(--secondary-color);
        margin-bottom: 15px;
    }

    .prompt-subtitle {
        font-size: 16px;
        color: #7f8c8d;
        margin-bottom: 40px;
        line-height: 1.6;
    }

    /* ---------------------------------------------------- */
    /* 4. 기능 리스트 */
    /* ---------------------------------------------------- */
    .features-list {
        text-align: left;
        margin: 30px 0;
        background: #f8f9fa;
        padding: 20px;
        border-radius: 15px;
    }

    .feature-item {
        display: flex;
        align-items: center;
        padding: 12px 0;
        border-bottom: 1px dashed #e0e0e0;
    }

    .feature-item:last-child {
        border-bottom: none;
    }

    .feature-icon {
        font-size: 20px;
        color: var(--primary-color);
        margin-right: 15px;
        min-width: 30px;
        text-align: center;
        background: white;
        width: 35px;
        height: 35px;
        line-height: 35px;
        border-radius: 50%;
        box-shadow: 0 2px 5px rgba(0,0,0,0.05);
    }

    .feature-text {
        font-size: 15px;
        color: #555;
        font-weight: 500;
    }

    /* ---------------------------------------------------- */
    /* 5. 버튼 스타일 */
    /* ---------------------------------------------------- */
    .register-btn {
        background: var(--primary-color); /* 메인 블루 단색 적용 */
        color: white;
        border: none;
        padding: 15px 40px;
        font-size: 16px;
        font-weight: 700;
        border-radius: 50px;
        cursor: pointer;
        transition: all 0.3s ease;
        display: inline-flex;
        align-items: center;
        justify-content: center;
        gap: 10px;
        width: 100%;
    }

    .register-btn:hover {
        background: #2980b9;
        transform: translateY(-2px);
    }
</style>

<div class="prompt-container">

    <div class="prompt-card">
        <div class="prompt-icon">
            <i class="bi bi-person-plus-fill"></i>
        </div>

        <h1 class="prompt-title">돌봄 대상자를 등록해주세요</h1>
        <p class="prompt-subtitle">
            아직 등록된 돌봄 대상자가 없습니다.<br>
            돌봄 서비스를 시작하려면 먼저 대상자를 등록해주세요.
        </p>

        <div class="features-list">
            <div class="feature-item">
                <i class="bi bi-calendar-check feature-icon"></i>
                <span class="feature-text">일정 관리 및 알림 설정</span>
            </div>
            <div class="feature-item">
                <i class="bi bi-heart-pulse feature-icon"></i>
                <span class="feature-text">건강 데이터 모니터링</span>
            </div>
            <div class="feature-item">
                <i class="bi bi-geo-alt feature-icon"></i>
                <span class="feature-text">위치 추적 및 안전 관리</span>
            </div>
            <div class="feature-item">
                <i class="bi bi-person-video3 feature-icon"></i>
                <span class="feature-text">실시간 영상 확인</span>
            </div>
            <div class="feature-item">
                <i class="bi bi-chat-dots feature-icon"></i>
                <span class="feature-text">채팅 및 커뮤니케이션</span>
            </div>
        </div>

        <button class="register-btn" onclick="location.href='<c:url value='/recipient/register'/>'">
            돌봄 대상자 등록하기
            <i class="bi bi-arrow-right-circle"></i>
        </button>
    </div>
</div>