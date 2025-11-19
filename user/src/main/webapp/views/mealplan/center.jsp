<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- CSS 파일 링크 -->
<link rel="stylesheet" href="<c:url value='/css/mealplan.css'/>" />

<section class="mealplan-section">
    <div class="container-fluid">
        <!-- 헤더 -->
        <div class="row mb-4">
            <div class="col-12">
                <div class="page-header">
                    <h1 class="page-title">
                        <i class="fas fa-utensils"></i> 식단 관리
                    </h1>
                    <p class="page-subtitle">
                        <i class="fas fa-user"></i> ${sessionScope.loginUser.custName} 님의 식단 관리 시스템
                    </p>
                </div>
            </div>
        </div>

        <!-- 노약자 선택 영역 -->
        <c:if test="${not empty recipientList}">
            <div class="row mb-3">
                <div class="col-12">
                    <div class="recipient-select-card">
                        <label class="recipient-select-label">
                            <i class="fas fa-user-injured"></i> 돌봄 대상자 선택
                        </label>
                        <select id="recipientSelect" class="recipient-select" onchange="changeRecipient()">
                            <c:forEach items="${recipientList}" var="rec">
                                <option value="${rec.recId}" ${rec.recId == selectedRecipient.recId ? 'selected' : ''}>
                                    ${rec.recName}
                                </option>
                            </c:forEach>
                        </select>
                    </div>
                </div>
            </div>
        </c:if>

        <!-- 대상자가 없는 경우 -->
        <c:if test="${empty selectedRecipient}">
            <div class="row">
                <div class="col-12">
                    <div class="no-recipient-message">
                        <i class="fas fa-exclamation-circle"></i>
                        <h3>등록된 돌봄 대상자가 없습니다</h3>
                        <p>먼저 돌봄 대상자를 등록해주세요.</p>
                        <a href="<c:url value='/recipient/register'/>" class="btn-register-recipient">
                            <i class="fas fa-plus"></i> 대상자 등록하기
                        </a>
                    </div>
                </div>
            </div>
        </c:if>

        <!-- 대상자가 있는 경우 - 메인 콘텐츠 -->
        <c:if test="${not empty selectedRecipient}">
            <div class="row">
                <!-- 왼쪽 영역: 통계 카드 -->
                <div class="col-lg-3 col-md-6 mb-4">
                    <!-- 오늘 식단 -->
                    <div class="stat-card stat-card-today">
                        <div class="stat-icon">
                            <i class="fas fa-calendar-day"></i>
                        </div>
                        <div class="stat-content">
                            <div class="stat-label">오늘 식단</div>
                            <div class="stat-value" id="todayMealCount">0</div>
                            <div class="stat-sub">끼 등록됨</div>
                        </div>
                    </div>

                    <!-- 오늘 총 칼로리 -->
                    <div class="stat-card stat-card-calories">
                        <div class="stat-icon">
                            <i class="fas fa-fire"></i>
                        </div>
                        <div class="stat-content">
                            <div class="stat-label">오늘 총 칼로리</div>
                            <div class="stat-value" id="todayTotalCalories">0</div>
                            <div class="stat-sub">kcal</div>
                        </div>
                    </div>

                    <!-- 이번 주 평균 -->
                    <div class="stat-card stat-card-average">
                        <div class="stat-icon">
                            <i class="fas fa-chart-line"></i>
                        </div>
                        <div class="stat-content">
                            <div class="stat-label">주간 평균</div>
                            <div class="stat-value" id="weekAvgCalories">0</div>
                            <div class="stat-sub">kcal/일</div>
                        </div>
                    </div>

                    <!-- 빠른 추가 버튼 -->
                    <button class="quick-add-btn" onclick="openAddModal()">
                        <i class="fas fa-plus-circle"></i>
                        <span>식단 빠른 추가</span>
                    </button>
                </div>

                <!-- 오른쪽 영역: 캘린더 + 식단 목록 -->
                <div class="col-lg-9">
                    <!-- 날짜 선택기 -->
                    <div class="date-selector-card">
                        <button class="date-nav-btn" onclick="changeDate(-1)">
                            <i class="fas fa-chevron-left"></i>
                        </button>
                        <div class="date-display">
                            <input type="date" id="selectedDate" class="date-input" onchange="loadMeals()">
                            <button class="today-btn" onclick="goToToday()">
                                <i class="fas fa-calendar-day"></i> 오늘
                            </button>
                        </div>
                        <button class="date-nav-btn" onclick="changeDate(1)">
                            <i class="fas fa-chevron-right"></i>
                        </button>
                    </div>

                    <!-- 식단 목록 카드 -->
                    <div class="meals-container">
                        <!-- 아침 -->
                        <div class="meal-card" data-meal-type="아침">
                            <div class="meal-card-header">
                                <div class="meal-type-badge breakfast">
                                    <i class="fas fa-sun"></i> 아침
                                </div>
                                <button class="add-meal-btn" onclick="openAddModal('아침')">
                                    <i class="fas fa-plus"></i>
                                </button>
                            </div>
                            <div class="meal-card-body" id="breakfast-meals">
                                <div class="empty-meal-message">
                                    <i class="fas fa-utensils"></i>
                                    <p>등록된 식단이 없습니다</p>
                                </div>
                            </div>
                        </div>

                        <!-- 점심 -->
                        <div class="meal-card" data-meal-type="점심">
                            <div class="meal-card-header">
                                <div class="meal-type-badge lunch">
                                    <i class="fas fa-cloud-sun"></i> 점심
                                </div>
                                <button class="add-meal-btn" onclick="openAddModal('점심')">
                                    <i class="fas fa-plus"></i>
                                </button>
                            </div>
                            <div class="meal-card-body" id="lunch-meals">
                                <div class="empty-meal-message">
                                    <i class="fas fa-utensils"></i>
                                    <p>등록된 식단이 없습니다</p>
                                </div>
                            </div>
                        </div>

                        <!-- 저녁 -->
                        <div class="meal-card" data-meal-type="저녁">
                            <div class="meal-card-header">
                                <div class="meal-type-badge dinner">
                                    <i class="fas fa-moon"></i> 저녁
                                </div>
                                <button class="add-meal-btn" onclick="openAddModal('저녁')">
                                    <i class="fas fa-plus"></i>
                                </button>
                            </div>
                            <div class="meal-card-body" id="dinner-meals">
                                <div class="empty-meal-message">
                                    <i class="fas fa-utensils"></i>
                                    <p>등록된 식단이 없습니다</p>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </c:if>
    </div>
</section>

<!-- 식단 추가/수정 모달 -->
<div class="modal-overlay" id="mealModal">
    <div class="modal-content">
        <div class="modal-header">
            <h3 class="modal-title" id="modalTitle">
                <i class="fas fa-plus-circle"></i> 식단 추가
            </h3>
            <button class="modal-close-btn" onclick="closeModal()">
                <i class="fas fa-times"></i>
            </button>
        </div>
        <div class="modal-body">
            <form id="mealForm">
                <input type="hidden" id="mealId" name="mealId">
                <input type="hidden" id="recId" name="recId" value="${selectedRecipient.recId}">
                
                <div class="form-group">
                    <label class="form-label">
                        <i class="fas fa-calendar"></i> 날짜 <span class="required">*</span>
                    </label>
                    <input type="date" id="mealDate" name="mealDate" class="form-control" required>
                </div>

                <div class="form-group">
                    <label class="form-label">
                        <i class="fas fa-clock"></i> 식사 구분 <span class="required">*</span>
                    </label>
                    <select id="mealType" name="mealType" class="form-control" required>
                        <option value="">선택하세요</option>
                        <option value="아침">🌅 아침</option>
                        <option value="점심">☀️ 점심</option>
                        <option value="저녁">🌙 저녁</option>
                    </select>
                </div>

                <div class="form-group">
                    <label class="form-label">
                        <i class="fas fa-utensils"></i> 메뉴 <span class="required">*</span>
                    </label>
                    <textarea id="mealMenu" name="mealMenu" class="form-control" rows="4" 
                              placeholder="예: 김치찌개, 밥, 계란후라이, 김치, 무생채" required></textarea>
                    <small class="form-hint">쉼표(,)로 구분하여 입력해주세요</small>
                </div>

                <div class="form-group">
                    <label class="form-label">
                        <i class="fas fa-fire"></i> 칼로리 (kcal)
                    </label>
                    <input type="number" id="mealCalories" name="mealCalories" class="form-control" 
                           placeholder="예: 650" min="0" step="10">
                    <small class="form-hint">선택사항입니다</small>
                </div>
            </form>
        </div>
        <div class="modal-footer">
            <button class="btn btn-cancel" onclick="closeModal()">
                <i class="fas fa-times"></i> 취소
            </button>
            <button class="btn btn-save" onclick="saveMeal()">
                <i class="fas fa-save"></i> 저장
            </button>
        </div>
    </div>
</div>

<!-- JavaScript 파일 링크 -->
<script src="<c:url value='/js/mealplan.js'/>"></script>

<script>
    // 현재 선택된 노약자 ID
    const currentRecId = ${not empty selectedRecipient ? selectedRecipient.recId : 'null'};
    
    // 페이지 로드 시 초기화
    document.addEventListener('DOMContentLoaded', function() {
        if (currentRecId) {
            // 오늘 날짜 설정
            const today = new Date().toISOString().split('T')[0];
            document.getElementById('selectedDate').value = today;
            
            // 데이터 로드
            loadMeals();
            loadStatistics();
        }
    });
    
    // 노약자 변경
    function changeRecipient() {
        const recId = document.getElementById('recipientSelect').value;
        window.location.href = '/mealplan?recId=' + recId;
    }
    
    // 오늘로 이동
    function goToToday() {
        const today = new Date().toISOString().split('T')[0];
        document.getElementById('selectedDate').value = today;
        loadMeals();
    }
    
    // 날짜 변경
    function changeDate(days) {
        const dateInput = document.getElementById('selectedDate');
        const currentDate = new Date(dateInput.value);
        currentDate.setDate(currentDate.getDate() + days);
        dateInput.value = currentDate.toISOString().split('T')[0];
        loadMeals();
    }
</script>

