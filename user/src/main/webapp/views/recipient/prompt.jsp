<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<style>
    .prompt-container {
        display: flex;
        flex-direction: column;
        align-items: center;
        justify-content: center;
        min-height: 60vh;
        padding: 40px 20px;
        text-align: center;
    }
    
    .prompt-icon {
        font-size: 100px;
        color: #e8f4f8;
        margin-bottom: 30px;
        animation: bounce 2s infinite;
    }
    
    @keyframes bounce {
        0%, 100% { transform: translateY(0); }
        50% { transform: translateY(-20px); }
    }
    
    .prompt-title {
        font-size: 32px;
        font-weight: 700;
        color: #2c3e50;
        margin-bottom: 20px;
    }
    
    .prompt-subtitle {
        font-size: 18px;
        color: #7f8c8d;
        margin-bottom: 40px;
        line-height: 1.6;
    }
    
    .prompt-card {
        background: white;
        border-radius: 20px;
        padding: 40px;
        box-shadow: 0 10px 30px rgba(0,0,0,0.1);
        max-width: 600px;
        margin-bottom: 30px;
    }
    
    .features-list {
        text-align: left;
        margin: 30px 0;
    }
    
    .feature-item {
        display: flex;
        align-items: center;
        padding: 15px 0;
        border-bottom: 1px solid #ecf0f1;
    }
    
    .feature-item:last-child {
        border-bottom: none;
    }
    
    .feature-icon {
        font-size: 24px;
        color: #3498db;
        margin-right: 15px;
        min-width: 30px;
    }
    
    .feature-text {
        font-size: 16px;
        color: #34495e;
    }
    
    .register-btn {
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        color: white;
        border: none;
        padding: 18px 50px;
        font-size: 18px;
        font-weight: 600;
        border-radius: 50px;
        cursor: pointer;
        transition: all 0.3s ease;
        box-shadow: 0 5px 15px rgba(102, 126, 234, 0.4);
    }
    
    .register-btn:hover {
        transform: translateY(-3px);
        box-shadow: 0 8px 25px rgba(102, 126, 234, 0.6);
    }
    
    .register-btn i {
        margin-left: 10px;
    }
</style>

<div class="prompt-container">
    <div class="prompt-icon">
        <i class="bi bi-person-plus-fill"></i>
    </div>
    
    <div class="prompt-card">
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

