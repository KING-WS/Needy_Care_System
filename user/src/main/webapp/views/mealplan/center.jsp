<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<link rel="stylesheet" href="<c:url value='/css/mealplan.css'/>" />

<style>
    /* ---------------------------------------------------- */
    /* 1. 디자인 시스템 (detail.jsp와 통일) */
    /* ---------------------------------------------------- */
    :root {
        --primary-color: #3498db; /* 메인 블루 */
        --secondary-color: #343a40; /* 진한 회색 텍스트 */
        --secondary-bg: #F0F8FF; /* 연한 배경색 */
        --card-bg: white;
        --danger-color: #e74c3c;
        --success-color: #2ecc71;
    }

    body {
        background-color: #f8f9fa;
    }

    /* ---------------------------------------------------- */
    /* 2. 레이아웃 & 카드 스타일 */
    /* ---------------------------------------------------- */
    .mealplan-section {
        max-width: 1400px;
        margin: 0 auto;
        padding: 40px 20px 100px 20px !important; /* 인라인 스타일 override */
        background: transparent !important;
    }

    .detail-content-card {
        background: var(--card-bg);
        border-radius: 20px;
        padding: 30px;
        box-shadow: 0 10px 30px rgba(0,0,0,0.05);
        margin-bottom: 30px;
        height: 100%; /* 높이 맞춤 */
    }

    /* 헤더 스타일 */
    .page-header {
        text-align: center;
        margin-bottom: 40px;
    }

    .page-header h1 {
        font-size: 38px;
        font-weight: 800;
        text-shadow: 0 1px 2px rgba(0, 0, 0, 0.05);
        margin-bottom: 10px;
    }

    /* ---------------------------------------------------- */
    /* 3. 통계 영역 (왼쪽 사이드바) */
    /* ---------------------------------------------------- */
    .stat-item {
        background: var(--secondary-bg);
        border-radius: 15px;
        padding: 25px;
        border: 1px solid transparent;
        display: flex;
        align-items: center;
        gap: 20px;
        transition: all 0.3s ease;
        margin-bottom: 15px;
    }

    .stat-item:hover {
        background: #e9f2ff;
        transform: translateY(-2px);
        border-color: var(--primary-color);
        box-shadow: none; /* 기존 그림자 제거 */
    }

    .stat-icon {
        width: 60px;
        height: 60px;
        border-radius: 12px;
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 28px;
        color: var(--primary-color);
        background: white;
        box-shadow: 0 4px 10px rgba(0,0,0,0.05);
    }

    /* 기존 그라데이션 제거하고 심플하게 변경 */
    .stat-item:nth-child(1) .stat-icon { color: #3498db; }
    .stat-item:nth-child(2) .stat-icon { color: #e74c3c; } /* 칼로리는 붉은색 계열 */
    .stat-item:nth-child(3) .stat-icon { color: #2ecc71; } /* 평균은 초록색 계열 */

    .stat-label {
        font-size: 15px;
        color: #7f8c8d;
        font-weight: 600;
        text-transform: uppercase;
        margin-bottom: 2px;
    }

    .stat-value {
        font-size: 30px;
        font-weight: 700;
        color: var(--secondary-color);
    }

    /* 버튼 스타일 (detail.jsp와 통일) */
    .btn-custom {
        width: 100%;
        padding: 16px 25px;
        border-radius: 50px;
        font-weight: 600;
        border: none;
        display: flex;
        align-items: center;
        justify-content: center;
        gap: 8px;
        cursor: pointer;
        transition: all 0.3s;
        margin-bottom: 10px;
        font-size: 18px;
    }

    .btn-quick-add {
        background: var(--primary-color);
        color: white;
        box-shadow: none;
    }

    .btn-quick-add:hover {
        transform: translateY(-2px);
        box-shadow: none;
    }

    .btn-ai {
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        color: white;
        box-shadow: none;
    }

    .btn-ai:hover {
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        transform: translateY(-2px);
        box-shadow: none;
    }

    /* ---------------------------------------------------- */
    /* 4. 오른쪽 컨텐츠 (날짜 선택 & 식단 리스트) */
    /* ---------------------------------------------------- */
    .date-selector-wrapper {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 25px;
        padding-bottom: 15px;
        border-bottom: 3px solid var(--secondary-bg);
    }

    .date-display {
        display: flex;
        align-items: center;
        gap: 10px;
        background: var(--secondary-bg);
        padding: 5px 15px;
        border-radius: 50px;
    }

    .date-input {
        background: transparent;
        border: none;
        font-size: 18px;
        font-weight: 700;
        color: var(--secondary-color);
        cursor: pointer;
        outline: none;
    }

    .date-nav-btn {
        background: white;
        border: 2px solid var(--secondary-bg);
        width: 40px;
        height: 40px;
        border-radius: 50%;
        display: flex;
        align-items: center;
        justify-content: center;
        color: var(--primary-color);
        transition: all 0.2s;
    }

    .date-nav-btn:hover {
        background: var(--primary-color);
        border-color: var(--primary-color);
        color: white;
    }

    /* 식단 카드 스타일 */
    .meal-section {
        margin-bottom: 25px;
    }

    .meal-section:last-child {
        margin-bottom: 0;
    }

    .meal-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 15px;
    }

    .meal-badge {
        font-size: 16px;
        font-weight: 700;
        display: flex;
        align-items: center;
        gap: 8px;
        padding: 8px 15px;
        border-radius: 12px;
    }

    .meal-badge.breakfast { background: #fff3cd; color: #856404; }
    .meal-badge.lunch { background: #d1ecf1; color: #0c5460; }
    .meal-badge.dinner { background: #d4edda; color: #155724; }

    .btn-add-mini {
        width: 32px;
        height: 32px;
        border-radius: 50%;
        border: none;
        background: var(--secondary-bg);
        color: var(--primary-color);
        display: flex;
        align-items: center;
        justify-content: center;
        transition: all 0.2s;
    }

    .btn-add-mini:hover {
        background: var(--primary-color);
        color: white;
    }

    .meal-list-body {
        min-height: 100px;
        border: 2px dashed #eee;
        border-radius: 15px;
        padding: 15px;
        transition: all 0.3s;
    }

    .meal-list-body:hover {
        border-color: var(--primary-color);
        background: #fcfcfc;
    }

    .empty-message {
        text-align: center;
        color: #adb5bd;
        padding: 20px 0;
    }

    .empty-message i {
        font-size: 24px;
        margin-bottom: 10px;
        display: block;
        opacity: 0.5;
    }

    /* 모달 스타일 일부 수정 (detail.jsp 톤앤매너) */
    .modal-header {
        border-bottom: none;
        padding-bottom: 0;
    }
    .modal-title {
        color: var(--secondary-color);
        font-weight: 800;
    }
    .form-control {
        background: var(--secondary-bg);
        border: 1px solid transparent;
        border-radius: 12px;
        padding: 12px;
    }
    .form-control:focus {
        background: white;
        border-color: var(--primary-color);
        box-shadow: 0 0 0 3px rgba(52, 152, 219, 0.1);
    }

    /* 대상자 없음 메시지 */
    .no-recipient-message {
        background: white;
        border-radius: 20px;
        padding: 50px;
        text-align: center;
        box-shadow: 0 10px 30px rgba(0,0,0,0.05);
    }
    .no-recipient-message i.fas.fa-exclamation-circle {
        font-size: 60px;
        color: #e0e0e0;
        margin-bottom: 20px;
    }

    /* Voice button styles */
    .voice-btn {
        position: absolute;
        bottom: 10px; /* Change from top: 10px to bottom: 10px */
        right: 10px;
        background: #28a745;
        border: none;
        color: white;
        width: 36px;
        height: 36px;
        border-radius: 50%;
        cursor: pointer;
        display: flex;
        justify-content: center;
        align-items: center;
        transition: background-color 0.3s, transform 0.2s;
    }
    .voice-btn:hover {
        background: #218838;
    }
    .voice-btn.recording {
        background: #dc3545;
        animation: pulse 1.5s infinite;
    }

    @keyframes pulse {
        0%, 100% { opacity: 1; }
        50% { opacity: 0.7; }
    }
</style>

<section class="mealplan-section">

    <div class="page-header">
        <h1>
            <i class="fas fa-utensils" style="color: var(--primary-color);"></i> AI 식단 관리
        </h1>
        <br>
        <h5>AI가 돌봄대상자의 특이사항 및 건강상태에 따른 식단을 추천해줍니다</h5>
    </div>

    <c:if test="${empty selectedRecipient}">
        <div class="no-recipient-message">
            <i class="fas fa-exclamation-circle"></i>
            <h3 style="color: var(--secondary-color); font-weight: 700;">등록된 돌봄 대상자가 없습니다</h3>
            <p style="color: #7f8c8d; margin-bottom: 30px;">먼저 돌봄 대상자를 등록해주세요.</p>
            <a href="<c:url value='/recipient/register'/>" class="btn btn-quick-add" style="display: inline-flex; width: auto; padding: 12px 30px;">
                <i class="fas fa-plus"></i> 대상자 등록하기
            </a>
        </div>
    </c:if>

    <c:if test="${not empty selectedRecipient}">
        <div class="row">
            <div class="col-lg-3 col-md-12 mb-4">
                <div class="detail-content-card">
                    <h3 style="font-size: 20px; font-weight: 700; margin-bottom: 20px; color: var(--secondary-color); border-bottom: 3px solid var(--secondary-bg); padding-bottom: 10px;">
                        <i class="fas fa-chart-pie" style="color: var(--primary-color); margin-right: 8px;"></i> 요약
                    </h3>

                    <div class="stat-item">
                        <div class="stat-icon"><i class="fas fa-calendar-day"></i></div>
                        <div class="stat-content">
                            <div class="stat-label">오늘 식단</div>
                            <div class="stat-value" id="todayMealCount">0</div>
                        </div>
                    </div>

                    <div class="stat-item">
                        <div class="stat-icon"><i class="fas fa-fire"></i></div>
                        <div class="stat-content">
                            <div class="stat-label">오늘 총 칼로리</div>
                            <div class="stat-value" id="todayTotalCalories">0</div>
                        </div>
                    </div>

                    <div class="stat-item">
                        <div class="stat-icon"><i class="fas fa-chart-line"></i></div>
                        <div class="stat-content">
                            <div class="stat-label">주간 평균</div>
                            <div class="stat-value" id="weekAvgCalories">0</div>
                        </div>
                    </div>

                    <hr style="margin: 25px 0; border-top: 2px dashed #eee;">

                    <button class="btn-custom btn-quick-add" onclick="openAddModal()">
                        <i class="fas fa-plus-circle"></i>
                        <span>식단 빠른 추가</span>
                    </button>

                    <button class="btn-custom btn-ai" onclick="openAiRecommendationModal()">
                        <i class="fas fa-magic"></i>
                        <span>AI 식단 추천</span>
                    </button>
                </div>
            </div>

            <div class="col-lg-9 col-md-12">
                <div class="detail-content-card">
                    <div class="date-selector-wrapper">
                        <h3 style="font-size: 20px; font-weight: 700; margin: 0; color: var(--secondary-color);">
                            <i class="fas fa-calendar-alt" style="color: var(--primary-color); margin-right: 8px;"></i> 상세 식단
                        </h3>

                        <div style="display: flex; align-items: center; gap: 10px;">
                            <button class="date-nav-btn" onclick="changeDate(-1)">
                                <i class="fas fa-chevron-left"></i>
                            </button>
                            <div class="date-display">
                                <input type="date" id="selectedDate" class="date-input" onchange="loadMeals()">
                            </div>
                            <button class="date-nav-btn" onclick="changeDate(1)">
                                <i class="fas fa-chevron-right"></i>
                            </button>
                            <button class="btn btn-sm btn-secondary" onclick="goToToday()" style="border-radius: 50px; padding: 8px 15px; margin-left: 5px;">
                                오늘
                            </button>
                        </div>
                    </div>

                    <div class="meals-container">
                        <div class="meal-section">
                            <div class="meal-header">
                                <div class="meal-badge breakfast">
                                    <i class="fas fa-sun"></i> 아침
                                </div>
                                <button class="btn-add-mini" onclick="openAddModal('아침')" title="아침 추가">
                                    <i class="fas fa-plus"></i>
                                </button>
                            </div>
                            <div class="meal-list-body" id="breakfast-meals">
                                <div class="empty-message">
                                    <i class="fas fa-utensils"></i>
                                    <p>등록된 식단이 없습니다</p>
                                </div>
                            </div>
                        </div>

                        <div class="meal-section">
                            <div class="meal-header">
                                <div class="meal-badge lunch">
                                    <i class="fas fa-cloud-sun"></i> 점심
                                </div>
                                <button class="btn-add-mini" onclick="openAddModal('점심')" title="점심 추가">
                                    <i class="fas fa-plus"></i>
                                </button>
                            </div>
                            <div class="meal-list-body" id="lunch-meals">
                                <div class="empty-message">
                                    <i class="fas fa-utensils"></i>
                                    <p>등록된 식단이 없습니다</p>
                                </div>
                            </div>
                        </div>

                        <div class="meal-section">
                            <div class="meal-header">
                                <div class="meal-badge dinner">
                                    <i class="fas fa-moon"></i> 저녁
                                </div>
                                <button class="btn-add-mini" onclick="openAddModal('저녁')" title="저녁 추가">
                                    <i class="fas fa-plus"></i>
                                </button>
                            </div>
                            <div class="meal-list-body" id="dinner-meals">
                                <div class="empty-message">
                                    <i class="fas fa-utensils"></i>
                                    <p>등록된 식단이 없습니다</p>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </c:if>
</section>

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
                <div class="form-control" style="background: #f7fafc; border: none; padding: 12px; font-weight: 700; font-size: 16px;" id="detailMealMenu">
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
                <div class="form-control" style="background: #f7fafc; border: none; padding: 12px; color: #e74c3c; font-weight: 600;" id="detailMealCalories">
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
                    <label class="form-label" for="aiSpecialNotes">
                        <i class="fas fa-list-alt"></i> 특이사항 (선택)
                    </label>
                    <div style="position: relative;">
                        <textarea id="aiSpecialNotes" class="form-control" rows="4"
                                  placeholder="추가적으로 고려할 사항이 있다면 입력해주세요.&#10;예: 오늘은 소화가 잘되는 부드러운 음식이 좋겠습니다."></textarea>
                        <button type="button" id="voiceRecordBtn" class="voice-btn" title="음성으로 입력">
                            <i class="fas fa-microphone"></i>
                        </button>
                    </div>
                    <small class="form-hint" style="color: #e74c3c; font-size: 14px;">입력하지 않으시면 대상자의 기존 건강 정보(병력, 알레르기 등)를 기반으로 추천합니다.</small>
                </div>
                <div id="aiRecommendationResult" class="form-group" style="display: none;">
                    <div id="aiRecommendationBasis" style="display: none; margin-bottom: 15px; padding: 12px; background-color: #f0f7ff; border-left: 4px solid #4facfe; border-radius: 4px; font-size: 13px; color: #555;">
                    </div>
                    <label class="form-label">
                        <i class="fas fa-lightbulb"></i> AI 추천 식단
                    </label>
                    <div id="aiRecommendedMealDetails" class="ai-recommendation-details">
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


<script src="<c:url value='/js/mealplan.js'/>"></script>

<script>
    // 현재 선택된 돌봄대상자 ID
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

    // 돌봄대상자 변경
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

    // AI 식단 추천 음성 인식
    document.addEventListener('DOMContentLoaded', function() {
        const voiceRecordBtn = document.getElementById('voiceRecordBtn');
        const specialNotesTextarea = document.getElementById('aiSpecialNotes');

        if ('webkitSpeechRecognition' in window || 'SpeechRecognition' in window) {
            const SpeechRecognition = window.SpeechRecognition || window.webkitSpeechRecognition;
            const recognition = new SpeechRecognition();
            recognition.lang = 'ko-KR';
            recognition.continuous = false;
            recognition.interimResults = false;

            let isRecording = false;

            recognition.onstart = function() {
                isRecording = true;
                voiceRecordBtn.classList.add('recording');
                voiceRecordBtn.title = '음성 인식 중...';
                specialNotesTextarea.placeholder = '말씀해주세요...';
            };

            recognition.onresult = function(event) {
                const transcript = event.results[0][0].transcript.trim();
                specialNotesTextarea.value = transcript;

                const aiMealTypeSelect = document.getElementById('aiMealType');

                if (transcript.includes('아침')) {
                    aiMealTypeSelect.value = '아침';
                } else if (transcript.includes('점심')) {
                    aiMealTypeSelect.value = '점심';
                } else if (transcript.includes('저녁')) {
                    aiMealTypeSelect.value = '저녁';
                }

                if (transcript) {
                    getAiRecommendation();
                }
            };

            recognition.onerror = function(event) {
                console.error('음성 인식 오류:', event.error);
                let errorMsg = '음성 인식 중 오류가 발생했습니다.';
                if (event.error === 'no-speech') {
                    errorMsg = '음성이 감지되지 않았습니다. 다시 시도해주세요.';
                } else if (event.error === 'not-allowed') {
                    errorMsg = '마이크 권한이 필요합니다. 브라우저 설정에서 마이크 권한을 허용해주세요.';
                }
                alert(errorMsg);
            };

            recognition.onend = function() {
                isRecording = false;
                voiceRecordBtn.classList.remove('recording');
                voiceRecordBtn.title = '음성으로 입력';
                specialNotesTextarea.placeholder = '추가적으로 고려할 사항이 있다면 입력해주세요.\\n예: 오늘은 소화가 잘되는 부드러운 음식이 좋겠습니다.';
            };

            voiceRecordBtn.addEventListener('click', function() {
                if (isRecording) {
                    recognition.stop();
                } else {
                    try {
                        recognition.start();
                    } catch(e) {
                        alert('음성 인식을 시작할 수 없습니다. 마이크 연결을 확인해주세요.');
                    }
                }
            });

        } else {
            voiceRecordBtn.style.display = 'none';
            console.warn('이 브라우저는 음성 인식을 지원하지 않습니다.');
        }
    });
</script>