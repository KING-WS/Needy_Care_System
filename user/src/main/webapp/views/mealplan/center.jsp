<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- CSS 파일 링크 -->
<link rel="stylesheet" href="<c:url value='/css/mealplan.css'/>" />

<style>
    /* 컨텐츠 중앙 정렬 및 여백 조정 */
    .mealplan-section > .container-fluid {
        max-width: 1400px;
        margin: 0 auto;
        padding: 0 40px;
    }
    
    @media (max-width: 1200px) {
        .mealplan-section > .container-fluid {
            padding: 0 30px;
        }
    }
    
    @media (max-width: 768px) {
        .mealplan-section > .container-fluid {
            padding: 0 20px;
        }
    }

    /* 통계 카드 스타일 - 일정 페이지와 동일 */
    .stat-item {
        border-radius: 15px;
        border: 1px solid #eee;
        padding: 20px;
        color: #2c3e50;
        box-shadow: none;
        display: flex;
        align-items: center;
        gap: 15px;
        transition: transform 0.2s;
        margin-bottom: 15px;
    }

    .stat-item:hover {
        transform: translateY(-3px);
        box-shadow: none;
    }

    .stat-icon {
        font-size: 32px;
        opacity: 0.9;
        width: 60px;
        height: 60px;
        border-radius: 12px;
        display: flex;
        align-items: center;
        justify-content: center;
        flex-shrink: 0;
        color: white;
    }
    
    /* 오늘 식단 이모티콘 배경색 */
    .stat-item:first-child .stat-icon {
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    }
    
    /* 오늘 총 칼로리 이모티콘 배경색 */
    .stat-item:nth-child(2) .stat-icon {
        background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
    }
    
    /* 주간 평균 이모티콘 배경색 */
    .stat-item:nth-child(3) .stat-icon {
        background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
    }

    .stat-content {
        flex: 1;
    }

    .stat-label {
        font-size: 13px;
        color: #2c3e50;
        margin-bottom: 5px;
        font-weight: 500;
    }

    .stat-value {
        font-size: 28px;
        font-weight: 700;
        color: #2c3e50;
    }
</style>

<section class="mealplan-section" style="padding: 20px 0 100px 0; background: #FFFFFF;">
    <div class="container-fluid">
        <!-- 헤더 -->
        <div class="row mb-4">
            <div class="col-12">
                <h1 style="font-size: 36px; font-weight: bold; color: var(--secondary-color);">
                    <i class="fas fa-utensils"></i> 식단 관리
                </h1>
                <p style="font-size: 16px; color: #666; margin-top: 10px;">
                    <i class="fas fa-user"></i> ${sessionScope.loginUser.custName} 님의 식단 관리 시스템
                </p>
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
                    <div class="stat-item" style="background: radial-gradient(circle at top left, #f0f9ff 0, #f4f9ff 40%, #f8fbff 100%);">
                        <div class="stat-icon"><i class="fas fa-calendar-day"></i></div>
                        <div class="stat-content">
                            <div class="stat-label">오늘 식단</div>
                            <div class="stat-value" id="todayMealCount">0</div>
                        </div>
                    </div>

                    <!-- 오늘 총 칼로리 -->
                    <div class="stat-item" style="background: radial-gradient(circle at top left, #f0f9ff 0, #f4f9ff 40%, #f8fbff 100%);">
                        <div class="stat-icon"><i class="fas fa-fire"></i></div>
                        <div class="stat-content">
                            <div class="stat-label">오늘 총 칼로리</div>
                            <div class="stat-value" id="todayTotalCalories">0</div>
                        </div>
                    </div>

                    <!-- 이번 주 평균 -->
                    <div class="stat-item" style="background: radial-gradient(circle at top left, #f0f9ff 0, #f4f9ff 40%, #f8fbff 100%);">
                        <div class="stat-icon"><i class="fas fa-chart-line"></i></div>
                        <div class="stat-content">
                            <div class="stat-label">주간 평균</div>
                            <div class="stat-value" id="weekAvgCalories">0</div>
                        </div>
                    </div>

                    <!-- 빠른 추가 버튼 -->
                    <button class="quick-add-btn" onclick="openAddModal()">
                        <i class="fas fa-plus-circle"></i>
                        <span>식단 빠른 추가</span>
                    </button>

                                        <!-- AI 식단 추천 버튼 -->

                                        <button class="quick-add-btn ai-btn" onclick="openAiRecommendationModal()">

                                            <i class="fas fa-magic"></i>

                                            <span>AI 식단 추천</span>

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
                        <i class="fas fa-book"></i> 레시피
                    </label>
                    <textarea id="mealRecipe" name="mealRecipe" class="form-control" rows="6" 
                              placeholder="예: 1. 김치를 적당한 크기로 썬다&#10;2. 냄비에 물을 넣고 끓인다&#10;3. 김치와 고기를 넣고 끓인다"></textarea>
                    <small class="form-hint">선택사항입니다. 조리 방법을 입력해주세요</small>
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

<!-- 식단 상세 정보 모달 -->
<div class="modal-overlay" id="mealDetailModal">
    <div class="modal-content">
        <div class="modal-header">
            <h3 class="modal-title">
                <i class="fas fa-utensils"></i> 식단 상세 정보
            </h3>
            <button class="modal-close-btn" onclick="closeMealDetailModal()">
                <i class="fas fa-times"></i>
            </button>
        </div>
        <div class="modal-body">
            <div class="form-group">
                <label class="form-label">
                    <i class="fas fa-utensils"></i> 메뉴
                </label>
                <div class="form-control" style="background: #f7fafc; border: none; padding: 12px; font-weight: 600; font-size: 16px;" id="detailMealMenu">
                    -
                </div>
            </div>

            <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 15px;">
                <div class="form-group">
                    <label class="form-label">
                        <i class="fas fa-clock"></i> 식사 구분
                    </label>
                    <div class="form-control" style="background: #f7fafc; border: none; padding: 12px;" id="detailMealType">
                        -
                    </div>
                </div>

                <div class="form-group">
                    <label class="form-label">
                        <i class="fas fa-calendar"></i> 날짜
                    </label>
                    <div class="form-control" style="background: #f7fafc; border: none; padding: 12px;" id="detailMealDate">
                        -
                    </div>
                </div>
            </div>

            <div class="form-group">
                <label class="form-label">
                    <i class="fas fa-fire"></i> 칼로리
                </label>
                <div class="form-control" style="background: #f7fafc; border: none; padding: 12px; color: #f093fb; font-weight: 600;" id="detailMealCalories">
                    -
                </div>
            </div>

            <div class="form-group">
                <label class="form-label">
                    <i class="fas fa-book"></i> 레시피
                </label>
                <div id="detailMealRecipe" style="min-height: 100px;">
                    <p style="color: #999; font-style: italic; text-align: center; padding: 20px;">로딩 중...</p>
                </div>
            </div>
        </div>
        <div class="modal-footer">
            <button class="btn btn-primary" onclick="closeMealDetailModal()">
                <i class="fas fa-check"></i> 확인
            </button>
        </div>
    </div>
</div>

<!-- AI 식단 추천 모달 -->
<div class="modal-overlay" id="aiRecommendationModal">
    <div class="modal-content">
        <div class="modal-header">
            <h3 class="modal-title">
                <i class="fas fa-magic"></i> AI 식단 추천
            </h3>
            <button class="modal-close-btn" onclick="closeAiRecommendationModal()">
                <i class="fas fa-times"></i>
            </button>
        </div>
        <div class="modal-body">
            <form id="aiRecommendationForm">
                <div class="form-group">
                    <label class="form-label">
                        <i class="fas fa-clock"></i> 식사 종류 <span class="required">*</span>
                    </label>
                    <select id="aiMealType" class="form-control" required>
                        <option value="아침" selected>🌅 아침</option>
                        <option value="점심">☀️ 점심</option>
                        <option value="저녁">🌙 저녁</option>
                    </select>
                </div>
                <div class="form-group">
                    <label class="form-label">
                        <i class="fas fa-list-alt"></i> 특이사항 (선택)
                    </label>
                    <textarea id="aiSpecialNotes" class="form-control" rows="4" 
                              placeholder="추가적으로 고려할 사항이 있다면 입력해주세요. 예: 오늘은 소화가 잘되는 부드러운 음식이 좋겠습니다."></textarea>
                    <small class="form-hint">입력하지 않으시면 대상자의 기존 건강 정보(병력, 알레르기 등)를 기반으로 추천합니다.</small>
                </div>
                <div id="aiRecommendationResult" class="form-group" style="display: none;">
                    <div id="aiRecommendationBasis" style="display: none; margin-bottom: 15px; padding: 12px; background-color: #f0f7ff; border-left: 4px solid #4facfe; border-radius: 4px; font-size: 13px; color: #555;">
                        <!-- 추천 근거가 여기에 표시됩니다. -->
                    </div>
                    <label class="form-label">
                        <i class="fas fa-lightbulb"></i> AI 추천 식단
                    </label>
                    <div id="aiRecommendedMealDetails" class="ai-recommendation-details">
                        <!-- AI 추천 결과가 여기에 표시됩니다. -->
                    </div>
                    <button type="button" class="btn btn-success mt-3" onclick="applyAiRecommendation()">
                        <i class="fas fa-check-circle"></i> 이 식단 적용하기
                    </button>
                </div>
            </form>
        </div>
        <div class="modal-footer">
            <button class="btn btn-cancel" onclick="closeAiRecommendationModal()">
                <i class="fas fa-times"></i> 닫기
            </button>
            <button class="btn btn-primary" id="getAiRecommendationBtn" onclick="getAiRecommendation()">
                <i class="fas fa-robot"></i> 추천받기
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

