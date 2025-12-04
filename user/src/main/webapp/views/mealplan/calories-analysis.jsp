<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<link rel="stylesheet" href="<c:url value='/css/mealplan.css'/>" />

<style>
    /* ---------------------------------------------------- */
    /* 1. 디자인 시스템 */
    /* ---------------------------------------------------- */
    :root {
        --primary-color: #3498db;   /* 메인 블루 (아이콘 색상과 동일) */
        --secondary-color: #343a40;
        --secondary-bg: #F0F8FF;
        --card-bg: white;
        --danger-color: #e74c3c;
        --success-color: #2ecc71;
        --warning-color: #f1c40f;
    }

    body {
        background-color: #f8f9fa;
    }

    .calories-analysis-section {
        max-width: 1400px;
        margin: 0 auto;
        padding: 40px 20px 100px 20px;
    }

    /* ---------------------------------------------------- */
    /* 2. 헤더 & 카드 스타일 */
    /* ---------------------------------------------------- */
    .page-header {
        text-align: center;
        margin-bottom: 40px;
        padding-bottom: 0;
        border-bottom: none;
    }

    .page-header h1 {
        font-size: 38px;
        font-weight: 800;
        text-shadow: 0 1px 2px rgba(0, 0, 0, 0.05);
        margin-bottom: 10px;
        color: var(--secondary-color);
    }

    .page-header p {
        font-size: 20px; /* Increased from 18px */
        color: #000000; /* Ensured black color */
    }

    /* 카드 공통 스타일 */
    .ai-analysis-section {
        background: var(--card-bg);
        border-radius: 20px;
        padding: 30px;
        box-shadow: 0 10px 30px rgba(0,0,0,0.05);
        margin-bottom: 30px;
        border: none;
        text-align: center; /* Added to center content */
    }

    /* ---------------------------------------------------- */
    /* 3. 통계 카드 (Grid) - [수정됨] */
    /* ---------------------------------------------------- */
    .stats-grid {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
        gap: 25px;
        margin-bottom: 30px;
    }

    .stat-card {
        margin-bottom: 0;
        display: flex;
        flex-direction: column;
        justify-content: center;
        position: relative;
        overflow: hidden;
        transition: transform 0.3s ease;
    }

    .stat-card:hover {
        transform: translateY(-5px);
        box-shadow: 0 15px 30px rgba(0,0,0,0.1);
    }

    .stat-card::before { display: none; }

    /* [수정] 통계 헤더: 아이콘과 간격 1px, 텍스트 스타일 변경 */
    .stat-header {
        display: flex;
        align-items: center;
        justify-content: flex-start; /* 왼쪽 정렬로 변경하여 붙임 */
        gap: 1px; /* [요청] 아이콘과의 간격 1px */
        margin-bottom: 15px;
    }

    /* [수정] 통계 제목: 검은색, 굵게 */
    .stat-title {
        font-size: 16px;
        color: #000000; /* [요청] 검은색 */
        font-weight: 800; /* [요청] 굵게 */
        text-transform: uppercase;
        margin-right: 5px; /* 시각적 균형을 위해 약간의 여백 추가 (원하시면 제거 가능) */
    }

    .stat-icon {
        width: 40px;
        height: 40px;
        border-radius: 12px;
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 20px;
        padding: 0;
    }

    .stat-card.today .stat-icon { color: #3498db; background: #e3f2fd; }
    .stat-card.week .stat-icon { color: #e67e22; background: #fdf2e9; }
    .stat-card.month .stat-icon { color: #2ecc71; background: #e8f8f5; }

    .stat-value-container {
        display: flex;
        align-items: baseline;
        gap: 8px;
    }

    .stat-value {
        font-size: 36px;
        font-weight: 800;
        color: var(--secondary-color);
    }

    .stat-unit {
        font-size: 16px;
        color: #95a5a6;
        font-weight: 600;
    }

    /* ---------------------------------------------------- */
    /* 4. 차트 & AI 섹션 - [수정됨] */
    /* ---------------------------------------------------- */
    .chart-header h2, .ai-analysis-header h2 {
        font-size: 22px;
        font-weight: 700;
        color: var(--secondary-color);
        margin-bottom: 10px;
        display: flex;
        align-items: center;
        gap: 10px;
    }

    .chart-header h2 i, .ai-analysis-header h2 i {
        color: var(--primary-color);
    }

    .chart-header p, .ai-analysis-header p {
        font-size: 20px; /* Increased from 14px */
        color: #000000; /* Changed to black */
    }

    .chart-wrapper {
        position: relative;
        height: 400px;
        margin-top: 25px;
    }

    .chart-header {
        text-align: left;
    }

    /* [수정] AI 분석 버튼: 아이콘 색상(Primary Blue) 적용 */
    .btn-analyze {
        background: var(--primary-color); /* [요청] 아이콘 색상(#3498db) 적용 */
        color: white;
        border: none;
        padding: 14px 40px;
        font-size: 16px;
        font-weight: 700;
        border-radius: 50px;
        cursor: pointer;
        transition: all 0.3s ease;
        box-shadow: none;
        display: inline-flex;
        align-items: center;
        gap: 10px;
    }

    .btn-analyze:hover {
        background: #2980b9; /* 호버 시 약간 진하게 */
        transform: translateY(-2px);
        box-shadow: none;
    }

    .btn-analyze:disabled {
        background: #bdc3c7;
        box-shadow: none;
        cursor: not-allowed;
        transform: none;
    }

    /* [수정] AI 결과 카드 영역: 초기에는 안 보이게 설정 */
    .ai-analysis-result {
        display: none; /* [요청] 버튼 누르기 전에는 숨김 */
        margin-top: 30px;
    }

    .ai-analysis-result.show {
        display: block; /* 버튼 누르고 데이터 오면 보임 */
        animation: fadeIn 0.5s ease;
    }

    /* New rule for centering the AI analysis header content */
    .ai-analysis-header {
        display: flex;
        flex-direction: column; /* Stack h2 and p vertically */
        align-items: center;   /* Center them horizontally */
        margin-bottom: 20px; /* Add some space below the header block */
        text-align: center; /* Ensures text within p tag is centered */
    }

    .result-card {
        background: var(--secondary-bg);
        border-radius: 15px;
        padding: 25px;
        margin-bottom: 20px;
        border: 1px solid rgba(52, 152, 219, 0.1);
        transition: all 0.3s ease;
    }

    .result-card:hover {
        background: white;
        border-color: var(--primary-color);
        box-shadow: 0 5px 15px rgba(0,0,0,0.05);
    }

    .result-card-title {
        font-size: 18px;
        font-weight: 700;
        color: var(--secondary-color);
        margin-bottom: 15px;
        display: flex;
        align-items: center;
        border-bottom: 2px solid rgba(0,0,0,0.05);
        padding-bottom: 10px;
    }

    .result-card-title i {
        margin-right: 10px;
        font-size: 20px;
        color: var(--primary-color);
    }

    .result-card-content {
        font-size: 20px;
        color: #495057;
        line-height: 1.7;
        /* 글자 굵기 추가 */
        font-weight: bold; /* 또는 700, 600 등 */
    }

    .status-badge {
        display: inline-block;
        padding: 6px 15px;
        border-radius: 30px;
        font-size: 14px;
        font-weight: 700;
        margin-left: auto;
    }

    .status-badge.부족 { background: #fff3cd; color: #856404; }
    .status-badge.적정 { background: #d4edda; color: #155724; }
    .status-badge.과다 { background: #f8d7da; color: #721c24; }

    .recommended-calories {
        font-size: 28px;
        font-weight: 800;
        color: var(--primary-color);
    }

    #aiGuideCard {
        background: #e7f3ff;
        border-left: 5px solid var(--primary-color);
    }
    #aiGuideCard .result-card-title {
        color: #0056b3;
        border-bottom-color: rgba(52, 152, 219, 0.2);
    }

    /* ---------------------------------------------------- */
    /* 5. 로딩 & Empty State */
    /* ---------------------------------------------------- */
    .loading, .analysis-loading {
        text-align: center;
        padding: 50px;
        color: #95a5a6;
    }
    .loading i, .analysis-loading i {
        font-size: 40px;
        margin-bottom: 20px;
        color: var(--primary-color);
        animation: spin 1s linear infinite;
    }

    .empty-state {
        background: white;
        border-radius: 20px;
        padding: 80px 20px;
        text-align: center;
        box-shadow: 0 10px 30px rgba(0,0,0,0.05);
    }
    .empty-state i {
        font-size: 60px;
        color: #e0e0e0;
        margin-bottom: 20px;
    }
    .empty-state h3 {
        font-size: 22px;
        font-weight: 700;
        color: var(--secondary-color);
        margin-bottom: 10px;
    }
    .empty-state p {
        color: #7f8c8d;
    }

    @keyframes spin {
        from { transform: rotate(0deg); }
        to { transform: rotate(360deg); }
    }
    @keyframes fadeIn {
        from { opacity: 0; transform: translateY(10px); }
        to { opacity: 1; transform: translateY(0); }
    }

    /* ---------------------------------------------------- */
    /* 6. 모달 스타일 */
    /* ---------------------------------------------------- */
    .modal-overlay {
        display: none;
        position: fixed;
        top: 0; left: 0; width: 100%; height: 100%;
        background: rgba(0, 0, 0, 0.5);
        z-index: 9999; /* 헤더보다 높게 설정 */
        align-items: center;
        justify-content: center;
        backdrop-filter: blur(3px);
    }
    .modal-overlay[style*="display: flex"] { display: flex !important; }

    .loading-modal-content {
        background: white;
        border-radius: 20px;
        text-align: center;
        padding: 40px 50px;
        box-shadow: 0 20px 60px rgba(0,0,0,0.15);
    }
    .spinner {
        border: 4px solid #f3f3f3;
        border-top: 4px solid var(--primary-color);
        border-radius: 50%;
        width: 50px;
        height: 50px;
        animation: spin 1s linear infinite;
        margin: 0 auto 20px;
    }

</style>

<div class="calories-analysis-section">
    <div class="calories-analysis-container">
        <div class="page-header">
            <h1><i class="fas fa-chart-line" style="color: var(--primary-color);"></i> 칼로리 분석</h1>
            <p>보호자가 등록한 돌봄대상자의 식단을 가져와 AI가 칼로리를 분석하고 시각화합니다.</p>
        </div>

        <c:if test="${selectedRecipient != null}">

            <c:if test="${selectedRecipient != null}">
                <input type="hidden" id="currentRecIdValue" value="${selectedRecipient.recId}" />
                <div id="recipientHealthInfo" style="display: none;">
                    <span data-type="medHistory">${selectedRecipient.recMedHistory}</span>
                    <span data-type="allergies">${selectedRecipient.recAllergies}</span>
                    <span data-type="specNotes">${selectedRecipient.recSpecNotes}</span>
                    <span data-type="healthNeeds">${selectedRecipient.recHealthNeeds}</span>
                </div>
            </c:if>

            <div class="stats-grid">
                <div class="stat-card today">
                    <div class="stat-header">
                        <span class="stat-title">오늘 총 칼로리</span>
                        <div class="stat-icon"><i class="fas fa-sun"></i></div>
                    </div>
                    <div class="stat-value-container">
                        <div class="stat-value" id="todayCalories">-</div>
                        <div class="stat-unit">kcal</div>
                    </div>
                </div>

                <div class="stat-card week">
                    <div class="stat-header">
                        <span class="stat-title">이번주 총 칼로리</span>
                        <div class="stat-icon"><i class="fas fa-calendar-week"></i></div>
                    </div>
                    <div class="stat-value-container">
                        <div class="stat-value" id="weekCalories">-</div>
                        <div class="stat-unit">kcal</div>
                    </div>
                </div>

                <div class="stat-card month">
                    <div class="stat-header">
                        <span class="stat-title">이번달 총 칼로리</span>
                        <div class="stat-icon"><i class="fas fa-calendar-alt"></i></div>
                    </div>
                    <div class="stat-value-container">
                        <div class="stat-value" id="monthCalories">-</div>
                        <div class="stat-unit">kcal</div>
                    </div>
                </div>
            </div>

            <div class="chart-container ai-analysis-section">
                <div class="chart-header">
                    <h2 id="chartTitle"><i class="fas fa-chart-area"></i> 일별 칼로리 추이</h2>
                    <p id="chartDescription">최근 30일간의 일별 칼로리 소비량을 그래프로 표시합니다.</p>
                </div>
                <div class="chart-wrapper">
                    <div class="loading" id="chartLoading">
                        <i class="fas fa-spinner"></i>
                        <p>차트 데이터를 불러오는 중...</p>
                    </div>
                    <canvas id="caloriesChart"></canvas>
                </div>
            </div>

            <div class="ai-analysis-section">
                <div class="ai-analysis-header">
                    <h2><i class="fas fa-robot"></i> AI 칼로리 분석</h2>
                    <p>AI가 최근 칼로리 섭취 데이터를 분석하여 건강 상태를 평가하고 조절 방안을 제시합니다.</p>
                </div>

                <div class="ai-analysis-button">
                    <button class="btn-analyze" id="btnAnalyze" onclick="startAiAnalysis()">
                        <i class="fas fa-magic"></i> AI 분석 시작하기
                    </button>
                </div>

                <div class="ai-analysis-result" id="analysisResult">
                    <div class="result-card" id="aiGuideCard" style="display: none;">
                        <div class="result-card-title">
                            <i class="fas fa-robot"></i> AI 종합 분석
                            <span class="status-badge" id="statusBadge"></span>
                        </div>
                        <div class="result-card-content" id="aiGuideContent"></div>
                    </div>

                    <div class="result-card">
                        <div class="result-card-title">
                            <i class="fas fa-bullseye"></i> 권장 일일 칼로리
                        </div>
                        <div class="result-card-content">
                            <div class="recommended-calories" id="recommendedCalories"></div>
                        </div>
                    </div>

                    <div class="result-card">
                        <div class="result-card-title">
                            <i class="fas fa-balance-scale"></i> 조절 방안
                        </div>
                        <div class="result-card-content" id="adjustmentPlanContent"></div>
                    </div>

                    <div class="result-card">
                        <div class="result-card-title">
                            <i class="fas fa-utensils"></i> 구체적인 식단 조절 제안
                        </div>
                        <div class="result-card-content" id="dietSuggestionContent"></div>
                    </div>
                </div>
            </div>
        </c:if>

        <c:if test="${selectedRecipient == null}">
            <div class="empty-state">
                <i class="fas fa-user-slash"></i>
                <h3>돌봄 대상자가 없습니다</h3>
                <p>칼로리 분석을 하려면 먼저 돌봄 대상자를 등록해주세요.</p>
            </div>
        </c:if>
    </div>
</div>

<div class="modal-overlay" id="loadingModal" style="display: none; z-index: 9999;">
    <div class="loading-modal-content">
        <div class="spinner"></div>
        <p style="font-size: 18px; font-weight: 700; color: #2c3e50; margin-top: 10px; margin-bottom: 5px;">AI가 식단을 분석 중입니다...</p>
        <p style="font-size: 14px; color: #7f8c8d; margin: 0;">잠시만 기다려주세요.</p>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

<script>
    let caloriesChart = null;
    let currentPeriod = 'default';

    // recId 가져오기 함수
    function getRecId() {
        const recipientSelect = document.getElementById('recipientSelect');
        if (recipientSelect && recipientSelect.value) {
            return recipientSelect.value;
        }
        const hiddenRecId = document.getElementById('currentRecIdValue');
        if (hiddenRecId && hiddenRecId.value) {
            return hiddenRecId.value;
        }
        return null;
    }

    // 칼로리 차트 로드
    function loadCaloriesChart() {
        const recId = getRecId();

        if (!recId || recId === 'null' || recId === null || recId === '') {
            console.error('recId가 유효하지 않습니다.');
            showError('대상자 정보가 없습니다.');
            return;
        }

        currentPeriod = 'default';
        const loadingDiv = document.getElementById('chartLoading');
        loadingDiv.style.display = 'block';

        fetch('<c:url value="/mealplan/api/calories-chart"/>?recId=' + recId)
            .then(response => {
                if (!response.ok) throw new Error(`HTTP error! status: ${response.status}`);
                return response.json();
            })
            .then(data => {
                loadingDiv.style.display = 'none';
                if (data.success && data.labels && data.data) {
                    if (data.labels.length === 0) {
                        showEmptyChart();
                    } else {
                        const isMealType = data.isMealType || false;
                        renderChart(data.labels, data.data, 'default', isMealType);
                    }
                } else {
                    const errorMsg = data.message || '차트 데이터를 불러올 수 없습니다.';
                    showError(errorMsg);
                }
            })
            .catch(error => {
                loadingDiv.style.display = 'none';
                showError('차트 데이터를 불러오는 중 오류가 발생했습니다: ' + error.message);
            });
    }

    // 페이지 로드 시 데이터 로드
    document.addEventListener('DOMContentLoaded', function() {
        const recId = getRecId();
        if (recId && recId !== 'null' && recId !== null && recId !== '' && recId !== undefined) {
            loadCaloriesStats();
            setTimeout(() => {
                loadCaloriesChart();
            }, 100);
        } else {
            console.error('recId를 가져올 수 없습니다.');
        }
    });

    // 기간별 차트 로드
    function loadChartByPeriod(period) {
        const recId = getRecId();
        if (!recId || recId === 'null' || recId === null || recId === '' || recId === undefined) {
            alert('대상자 정보가 없습니다. 대상자를 선택해주세요.');
            return;
        }

        currentPeriod = period;
        const chartWrapper = document.querySelector('.chart-wrapper');
        chartWrapper.innerHTML = `
            <div class="loading" id="chartLoading">
                <i class="fas fa-spinner"></i>
                <p>차트 데이터를 불러오는 중...</p>
            </div>
            <canvas id="caloriesChart"></canvas>
        `;

        const loadingDiv = document.getElementById('chartLoading');
        loadingDiv.style.display = 'block';

        const today = new Date();
        let startDate, endDate, title, description;

        switch(period) {
            case 'today':
                startDate = new Date(today);
                endDate = new Date(today);
                title = '<i class="fas fa-sun"></i> 오늘 칼로리';
                description = '오늘 섭취한 칼로리를 식사별로 표시합니다.';
                break;
            case 'week':
                const dayOfWeek = today.getDay();
                const diff = today.getDate() - dayOfWeek + (dayOfWeek === 0 ? -6 : 1);
                startDate = new Date(today.getFullYear(), today.getMonth(), diff);
                endDate = new Date(today);
                title = '<i class="fas fa-calendar-week"></i> 이번주 칼로리';
                description = '이번주(월요일~오늘) 일별 칼로리 소비량을 그래프로 표시합니다.';
                break;
            case 'month':
                startDate = new Date(today.getFullYear(), today.getMonth(), 1);
                endDate = new Date(today);
                title = '<i class="fas fa-calendar-alt"></i> 이번달 칼로리';
                description = '이번달 일별 칼로리 소비량을 그래프로 표시합니다.';
                break;
            default:
                startDate = new Date(today);
                startDate.setDate(startDate.getDate() - 29);
                endDate = new Date(today);
                title = '<i class="fas fa-chart-area"></i> 일별 칼로리 추이';
                description = '최근 30일간의 일별 칼로리 소비량을 그래프로 표시합니다.';
        }

        const formatDate = (date) => {
            if (!date || isNaN(date.getTime())) return null;
            const year = date.getFullYear();
            const month = String(date.getMonth() + 1).padStart(2, '0');
            const day = String(date.getDate()).padStart(2, '0');
            return `${year}-${month}-${day}`;
        };

        const startDateStr = formatDate(startDate);
        const endDateStr = formatDate(endDate);

        if (!startDateStr || !endDateStr) {
            showError('날짜 계산 중 오류가 발생했습니다.');
            return;
        }

        document.getElementById('chartTitle').innerHTML = title;
        document.getElementById('chartDescription').textContent = description;

        const apiUrl = `<c:url value="/mealplan/api/calories-chart"/>?recId=${recId}&startDate=${startDateStr}&endDate=${endDateStr}`;

        fetch(apiUrl)
            .then(response => {
                if (!response.ok) throw new Error(`HTTP error! status: ${response.status}`);
                return response.json();
            })
            .then(data => {
                loadingDiv.style.display = 'none';
                if (data.success && data.labels && data.data) {
                    if (data.labels.length === 0) {
                        showEmptyChart();
                    } else {
                        const isMealType = data.isMealType || false;
                        renderChart(data.labels, data.data, period, isMealType);
                    }
                } else {
                    const errorMsg = data.message || '차트 데이터를 불러올 수 없습니다.';
                    showError(errorMsg);
                }
            })
            .catch(error => {
                loadingDiv.style.display = 'none';
                showError('차트 데이터를 불러오는 중 오류가 발생했습니다: ' + error.message);
            });
    }

    // 칼로리 통계 로드
    function loadCaloriesStats() {
        const recId = getRecId();
        if (!recId || recId === 'null' || recId === null || recId === '') return;

        fetch('<c:url value="/mealplan/api/calories-stats"/>?recId=' + recId)
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    document.getElementById('todayCalories').textContent = formatNumber(data.todayCalories || 0);
                    document.getElementById('weekCalories').textContent = formatNumber(data.weekCalories || 0);
                    document.getElementById('monthCalories').textContent = formatNumber(data.monthCalories || 0);
                } else {
                    showError('통계 데이터를 불러올 수 없습니다.');
                }
            })
            .catch(error => {
                showError('통계 데이터를 불러오는 중 오류가 발생했습니다.');
            });
    }

    // 차트 렌더링
    function renderChart(labels, data, period, isMealType = false) {
        const ctx = document.getElementById('caloriesChart');
        if (caloriesChart) caloriesChart.destroy();

        let formattedLabels;
        if (isMealType) {
            formattedLabels = labels;
        } else {
            formattedLabels = labels.map(label => {
                const date = new Date(label);
                const month = String(date.getMonth() + 1).padStart(2, '0');
                const day = String(date.getDate()).padStart(2, '0');
                if (period === 'week') {
                    const weekdays = ['일', '월', '화', '수', '목', '금', '토'];
                    const weekday = weekdays[date.getDay()];
                    return month + '/' + day + ' (' + weekday + ')';
                } else {
                    return month + '/' + day;
                }
            });
        }

        const chartType = isMealType ? 'bar' : 'line';
        let chartColors;
        if (isMealType) {
            chartColors = {
                backgroundColor: [
                    'rgba(102, 126, 234, 0.8)',
                    'rgba(118, 75, 162, 0.8)',
                    'rgba(240, 147, 251, 0.8)'
                ],
                borderColor: [
                    'rgb(102, 126, 234)',
                    'rgb(118, 75, 162)',
                    'rgb(240, 147, 251)'
                ]
            };
        } else {
            chartColors = {
                backgroundColor: 'rgba(52, 152, 219, 0.1)',
                borderColor: '#3498db'
            };
        }

        const datasetConfig = {
            label: isMealType ? '식사별 칼로리 (kcal)' : '칼로리 (kcal)',
            data: data,
            borderWidth: 3,
            pointRadius: 4,
            pointHoverRadius: 6,
            pointBackgroundColor: isMealType ? chartColors.borderColor : '#fff',
            pointBorderColor: isMealType ? '#fff' : chartColors.borderColor,
            pointBorderWidth: 2
        };

        if (isMealType) {
            datasetConfig.backgroundColor = chartColors.backgroundColor;
            datasetConfig.borderColor = chartColors.borderColor;
        } else {
            datasetConfig.backgroundColor = chartColors.backgroundColor;
            datasetConfig.borderColor = chartColors.borderColor;
            datasetConfig.fill = true;
            datasetConfig.tension = 0.4;
        }

        caloriesChart = new Chart(ctx, {
            type: chartType,
            data: {
                labels: formattedLabels,
                datasets: [datasetConfig]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: {
                        display: true,
                        position: 'top',
                        labels: {
                            font: { size: 14, weight: 'bold' },
                            color: '#2c3e50'
                        }
                    },
                    tooltip: {
                        backgroundColor: 'rgba(0, 0, 0, 0.8)',
                        padding: 12,
                        titleFont: { size: 16, weight: 'bold' },
                        bodyFont: { size: 14 },
                        callbacks: {
                            label: function(context) {
                                return '칼로리: ' + formatNumber(context.parsed.y) + ' kcal';
                            }
                        }
                    }
                },
                scales: {
                    y: {
                        beginAtZero: true,
                        title: {
                            display: true,
                            text: '칼로리 (kcal)',
                            font: { size: 14, weight: 'bold' },
                            color: '#2c3e50'
                        },
                        ticks: {
                            font: { size: 12 },
                            color: '#666',
                            callback: function(value) { return formatNumber(value); }
                        },
                        grid: { color: 'rgba(0, 0, 0, 0.05)' }
                    },
                    x: {
                        title: {
                            display: true,
                            text: '날짜',
                            font: { size: 14, weight: 'bold' },
                            color: '#2c3e50'
                        },
                        ticks: {
                            font: { size: 12 },
                            color: '#666',
                            maxRotation: 45,
                            minRotation: 45
                        },
                        grid: { display: false }
                    }
                }
            }
        });
    }

    function showEmptyChart() {
        const chartWrapper = document.querySelector('.chart-wrapper');
        chartWrapper.innerHTML = `
            <div class="empty-state">
                <i class="fas fa-chart-line"></i>
                <h3>데이터가 없습니다</h3>
                <p>표시할 칼로리 데이터가 없습니다. 식단을 등록해주세요.</p>
            </div>
        `;
    }

    function showError(message) {
        const chartWrapper = document.querySelector('.chart-wrapper');
        chartWrapper.innerHTML = `
            <div class="empty-state">
                <i class="fas fa-exclamation-triangle"></i>
                <h3>오류 발생</h3>
                <p>${message}</p>
            </div>
        `;
    }

    function formatNumber(num) {
        return num.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
    }

    function startAiAnalysis() {
        const recId = getRecId();
        if (!recId || recId === 'null' || recId === null || recId === '') {
            alert('대상자 정보가 없습니다. 대상자를 선택해주세요.');
            return;
        }

        const btnAnalyze = document.getElementById('btnAnalyze');
        const analysisResult = document.getElementById('analysisResult');

        btnAnalyze.disabled = true;
        document.getElementById('loadingModal').style.display = 'flex';
        analysisResult.classList.remove('show');

        fetch('<c:url value="/mealplan/api/calories-analysis"/>', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({
                recId: parseInt(recId) || recId
            })
        })
            .then(response => response.json())
            .then(data => {
                document.getElementById('loadingModal').style.display = 'none';
                btnAnalyze.disabled = false;

                if (data.success) {
                    displayAnalysisResult(data);
                } else {
                    alert('분석 중 오류가 발생했습니다: ' + (data.message || '알 수 없는 오류'));
                }
            })
            .catch(error => {
                document.getElementById('loadingModal').style.display = 'none';
                btnAnalyze.disabled = false;
                console.error('AI 분석 에러:', error);
                alert('AI 분석 중 오류가 발생했습니다: ' + error.message);
            });
    }

    function displayAnalysisResult(data) {
        const analysisResult = document.getElementById('analysisResult');
        const aiGuideCard = document.getElementById('aiGuideCard');
        const aiGuideContent = document.getElementById('aiGuideContent');
        const statusBadge = document.getElementById('statusBadge');
        const recommendedCalories = document.getElementById('recommendedCalories');
        const adjustmentPlanContent = document.getElementById('adjustmentPlanContent');
        const dietSuggestionContent = document.getElementById('dietSuggestionContent');

        if (data.aiAnalysis) {
            aiGuideContent.textContent = data.aiAnalysis;
            aiGuideCard.style.display = 'block';
        } else {
            aiGuideCard.style.display = 'none';
        }

        const status = data.status || '적정';
        statusBadge.textContent = status;
        statusBadge.className = 'status-badge ' + status;

        const recommended = data.recommendedCalories || 2000;
        recommendedCalories.textContent = formatNumber(recommended) + ' kcal';

        adjustmentPlanContent.textContent = data.adjustmentPlan || '조절 방안이 없습니다.';
        dietSuggestionContent.textContent = data.dietSuggestion || '식단 조절 제안이 없습니다.';

        analysisResult.classList.add('show');
    }
</script>