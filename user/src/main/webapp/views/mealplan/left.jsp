<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<style>
    .left-menu {
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        padding: 30px 20px;
        border-radius: 15px;
        box-shadow: 0 8px 20px rgba(102, 126, 234, 0.3);
        min-height: calc(100vh - 200px);
    }

    .left-menu-title {
        color: white;
        font-size: 24px;
        font-weight: 700;
        margin-bottom: 20px;
        text-align: center;
        display: flex;
        align-items: center;
        justify-content: center;
        gap: 10px;
    }

    .left-menu-item {
        background: rgba(255, 255, 255, 0.15);
        color: white;
        padding: 15px 20px;
        margin-bottom: 10px;
        border-radius: 10px;
        text-decoration: none;
        display: flex;
        align-items: center;
        gap: 12px;
        transition: all 0.3s ease;
        cursor: pointer;
    }

    .left-menu-item:hover {
        background: rgba(255, 255, 255, 0.25);
        transform: translateX(5px);
        color: white;
    }

    .left-menu-item.active {
        background: white;
        color: #667eea;
        font-weight: 600;
    }

    .left-menu-item i {
        font-size: 20px;
    }

    .menu-divider {
        height: 1px;
        background: rgba(255, 255, 255, 0.3);
        margin: 20px 0;
    }

    .quick-stats {
        background: rgba(255, 255, 255, 0.15);
        padding: 15px;
        border-radius: 10px;
        margin-top: 20px;
    }

    .quick-stats-title {
        color: white;
        font-size: 14px;
        font-weight: 600;
        margin-bottom: 10px;
    }

    .quick-stat-item {
        display: flex;
        justify-content: space-between;
        color: rgba(255, 255, 255, 0.9);
        font-size: 13px;
        margin-bottom: 8px;
    }

    .quick-stat-item:last-child {
        margin-bottom: 0;
    }

    .quick-stat-value {
        font-weight: 600;
        color: white;
    }
</style>

<div class="left-menu">
    <div class="left-menu-title">
        <i class="fas fa-utensils"></i>
        <span>식단 관리</span>
    </div>

    <a href="<c:url value='/mealplan'/>" class="left-menu-item active">
        <i class="fas fa-calendar-alt"></i>
        <span>식단 캘린더</span>
    </a>

    <a href="<c:url value='/mealplan'/>" class="left-menu-item">
        <i class="fas fa-plus-circle"></i>
        <span>식단 추가</span>
    </a>

    <div class="menu-divider"></div>

    <a href="<c:url value='/mealplan'/>" class="left-menu-item">
        <i class="fas fa-chart-line"></i>
        <span>칼로리 통계</span>
    </a>

    <a href="<c:url value='/mealplan'/>" class="left-menu-item">
        <i class="fas fa-history"></i>
        <span>식단 이력</span>
    </a>

    <div class="menu-divider"></div>

    <a href="<c:url value='/'/>" class="left-menu-item">
        <i class="fas fa-home"></i>
        <span>홈으로</span>
    </a>

    <div class="quick-stats">
        <div class="quick-stats-title">
            <i class="fas fa-info-circle"></i> Quick Info
        </div>
        <div class="quick-stat-item">
            <span>이번 주 등록</span>
            <span class="quick-stat-value" id="weekMealsCount">0건</span>
        </div>
        <div class="quick-stat-item">
            <span>오늘 총 칼로리</span>
            <span class="quick-stat-value" id="todayCalories">0kcal</span>
        </div>
        <div class="quick-stat-item">
            <span>평균 칼로리</span>
            <span class="quick-stat-value" id="avgCalories">0kcal</span>
        </div>
    </div>
</div>

