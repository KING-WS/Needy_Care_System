<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<style>

    :root {
        /* 사용자 정의 변수가 있다면 여기에 정의되어야 합니다.
 (예: Spring/JSP 설정) [cite_start][cite: 1, 2] */
        /* 임시 컬러 변수 (원래 코드에서 정의되지 않아 임의 지정) */
        --primary-color: #3498db;
        --primary-color-dark: #2980b9;
        --secondary-color: #2c3e50;
        --warning-light: #fef9e7;
        --danger-light: #fcebeb;
    }

    .calories-analysis-section {
        padding: 20px 0 100px 0;
        background: #FFFFFF;
    }
    
    .calories-analysis-container {
        max-width: 1200px;
        margin: 0 auto;
        padding: 0 20px;
    }
    
    .page-header {
        margin-bottom: 30px;
        text-align: center;
    }
    
    .page-header h1 {
        font-size: 38px;
        font-weight: 800;
        color: var(--secondary-color);
        margin-bottom: 10px;
        text-shadow: 0 1px 2px rgba(0, 0, 0, 0.05);
    }
    
    .page-header p {
        font-size: 16px;
        color: #666;
    }
    
    .stats-grid {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
        gap: 20px;
        margin-bottom: 30px;
    }
    
    .stat-card {
        background: white;
        border-radius: 15px;
        padding: 20px; /* 패딩 약간 줄임 */
        box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        transition: transform 0.3s ease, box-shadow 0.3s ease;
        border-left: 4px solid;
    }
    
    .stat-card:hover {
        transform: translateY(-5px);
        box-shadow: 0 8px 20px rgba(0,0,0,0.15);
    }
    
    .stat-card.today {
        border-left-color: #667eea;
    }
    
    .stat-card.week {
        border-left-color: #764ba2;
    }
    
    .stat-card.month {
        border-left-color: #f093fb;
    }
    
    .stat-header {
        display: flex;
        align-items: center;
        justify-content: space-between;
        margin-bottom: 10px; /* 간격 줄임 */
    }
    
    .stat-title {
        font-size: 15px; /* 약간 줄임 */
        color: #666;
        font-weight: 500;
    }
    
    .stat-icon {
        font-size: 24px; /* 약간 줄임 */
        opacity: 0.7;
    }
    
    .stat-card.today .stat-icon {
        color: #667eea;
    }
    
    .stat-card.week .stat-icon {
        color: #764ba2;
    }
    
    .stat-card.month .stat-icon {
        color: #f093fb;
    }
    
    .stat-value-container {
        display: flex;
        align-items: baseline; /* 기준선을 맞춤 */
        gap: 8px; /* 숫자와 단위 사이 간격 */
    }
    
    .stat-value {
        font-size: 32px; /* 약간 줄임 */
        font-weight: bold;
        color: #2c3e50;
        margin: 0; /* margin 제거 */
    }
    
    .stat-unit {
        font-size: 16px; /* 약간 키움 */
        color: #999;
        font-weight: 500;
    }
    
    .chart-container {
        background: white;
        border-radius: 15px;
        padding: 30px;
        box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        margin-bottom: 20px;
    }
    
    .chart-header {
        margin-bottom: 20px;
    }
    
    .chart-header h2 {
        font-size: 24px;
        font-weight: bold;
        color: #2c3e50;
        margin-bottom: 10px;
    }
    
    .chart-header p {
        font-size: 14px;
        color: #666;
    }
    
    .chart-wrapper {
        position: relative;
        height: 400px;
        margin-top: 20px;
    }
    
    .loading {
        text-align: center;
        padding: 50px;
        color: #666;
    }
    
    .loading i {
        font-size: 48px;
        margin-bottom: 20px;
        animation: spin 1s linear infinite;
    }
    
    @keyframes spin {
        from { transform: rotate(0deg); }
        to { transform: rotate(360deg); }
    }
    
    .empty-state {
        text-align: center;
        padding: 60px 20px;
        color: #999;
    }
    
    .empty-state i {
        font-size: 64px;
        margin-bottom: 20px;
        opacity: 0.5;
    }
    
    .empty-state h3 {
        font-size: 20px;
        margin-bottom: 10px;
        color: #666;
    }
    
    .empty-state p {
        font-size: 14px;
    }
    
    .ai-analysis-section {
        background: white;
        border-radius: 15px;
        padding: 30px;
        box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        margin-bottom: 20px;
    }
    
    .ai-analysis-header {
        margin-bottom: 20px;
    }
    
    .ai-analysis-header h2 {
        font-size: 24px;
        font-weight: bold;
        color: #2c3e50;
        margin-bottom: 10px;
    }
    
    .ai-analysis-header p {
        font-size: 14px;
        color: #666;
    }
    
    .ai-analysis-button {
        text-align: center;
        margin: 30px 0;
    }
    
    .btn-analyze {
        background: var(--primary-color);
        color: white;
        border: none;
        padding: 15px 40px;
        font-size: 18px;
        font-weight: bold;
        border-radius: 50px;
        cursor: pointer;
        transition: all 0.3s ease;
    }
    
    .btn-analyze:hover {
        background: var(--primary-color-dark);
        transform: translateY(-2px);
        box-shadow: 0 4px 10px rgba(52, 152, 219, 0.4);
    }
    
    .btn-analyze:disabled {
        background: #ccc;
        cursor: not-allowed;
        transform: none;
        box-shadow: none;
    }
    
    .ai-analysis-result {
        display: none;
        margin-top: 30px;
    }
    
    .ai-analysis-result.show {
        display: block;
        animation: fadeIn 0.5s ease;
    }
    
    @keyframes fadeIn {
        from {
            opacity: 0;
            transform: translateY(10px);
        }
        to {
            opacity: 1;
            transform: translateY(0);
        }
    }
    
    .result-card {
        background: #f8f9fa;
        border-radius: 12px;
        padding: 20px;
        margin-bottom: 15px;
        border-left: 4px solid;
    }
    
    .result-card.status {
        border-left-color: #667eea;
    }
    
    .result-card.status.부족 {
        border-left-color: #f39c12;
    }
    
    .result-card.status.적정 {
        border-left-color: #27ae60;
    }
    
    .result-card.status.과다 {
        border-left-color: #e74c3c;
    }
    
    .result-card-title {
        font-size: 16px;
        font-weight: bold;
        color: #2c3e50;
        margin-bottom: 10px;
        display: flex;
        align-items: center;
    }
    
    .result-card-title i {
        margin-right: 8px;
        font-size: 18px;
    }
    
    .result-card-content {
        font-size: 15px;
        color: #555;
        line-height: 1.6;
    }
    
    .status-badge {
        display: inline-block;
        padding: 5px 15px;
        border-radius: 20px;
        font-size: 14px;
        font-weight: bold;
        margin-left: 10px;
    }
    
    .status-badge.부족 {
        background: #fff3cd;
        color: #856404;
    }
    
    .status-badge.적정 {
        background: #d4edda;
        color: #155724;
    }
    
    .status-badge.과다 {
        background: #f8d7da;
        color: #721c24;
    }
    
    .recommended-calories {
        font-size: 28px;
        font-weight: bold;
        color: #667eea;
        margin-top: 5px;
    }
    
    .analysis-loading {
        text-align: center;
        padding: 40px;
        color: #666;
    }
    
    .analysis-loading i {
        font-size: 48px;
        margin-bottom: 20px;
        animation: spin 1s linear infinite;
    }

    /* AI 가이드 카드 스타일 */
    #aiGuideCard {
        background: #e8f5fb;
        color: #333;
        border: none;
        border-radius: 15px;
        padding: 25px;
        margin-bottom: 25px;
        box-shadow: 0 5px 15px rgba(0,0,0,0.1);
    }
    #aiGuideCard .result-card-title {
        color: #0056b3;
        font-size: 20px;
    }
    #aiGuideCard .result-card-content {
        font-size: 17px;
        font-weight: 500;
        color: #495057;
    }
    .highlight-keyword {
        color: #e74c3c;
        font-weight: 700;
    }

    /* 모달 (mealplan.css 기반) */
    .modal-overlay {
        display: none;
        position: fixed;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        background: rgba(0, 0, 0, 0.6);
        z-index: 9999;
        align-items: center;
        justify-content: center;
        animation: fadeIn 0.3s ease;
    }

    /* 모달창이 활성화될 때 (JS에서 display: flex로 변경됨) */
    .modal-overlay[style*="display: flex"] {
        display: flex !important;
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
            <p>노약자의 식단 칼로리를 분석하고 시각화합니다.</p>
        </div>
        
        <c:if test="${selectedRecipient != null}">
            
            <!-- 현재 선택된 recId를 hidden으로 저장 -->
            <c:if test="${selectedRecipient != null}">
                <input type="hidden" id="currentRecIdValue" value="${selectedRecipient.recId}" />
                <div id="recipientHealthInfo" style="display: none;">
                    <span data-type="medHistory">${selectedRecipient.recMedHistory}</span>
                    <span data-type="allergies">${selectedRecipient.recAllergies}</span>
                    <span data-type="specNotes">${selectedRecipient.recSpecNotes}</span>
                    <span data-type="healthNeeds">${selectedRecipient.recHealthNeeds}</span>
                </div>
            </c:if>
            
            <!-- 통계 카드 -->
            <div class="stats-grid">
                <div class="stat-card today">
                    <div class="stat-header">
                        <span class="stat-title">오늘 총 칼로리</span>
                        <i class="fas fa-sun stat-icon"></i>
                    </div>
                    <div class="stat-value-container">
                        <div class="stat-value" id="todayCalories">-</div>
                        <div class="stat-unit">kcal</div>
                    </div>
                </div>
                
                <div class="stat-card week">
                    <div class="stat-header">
                        <span class="stat-title">이번주 총 칼로리</span>
                        <i class="fas fa-calendar-week stat-icon"></i>
                    </div>
                    <div class="stat-value-container">
                        <div class="stat-value" id="weekCalories">-</div>
                        <div class="stat-unit">kcal</div>
                    </div>
                </div>
                
                <div class="stat-card month">
                    <div class="stat-header">
                        <span class="stat-title">이번달 총 칼로리</span>
                        <i class="fas fa-calendar-alt stat-icon"></i>
                    </div>
                    <div class="stat-value-container">
                        <div class="stat-value" id="monthCalories">-</div>
                        <div class="stat-unit">kcal</div>
                    </div>
                </div>
            </div>
            
            <!-- 차트 컨테이너 -->
            <div class="chart-container">
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
            
            <!-- AI 분석 섹션 -->
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
                    <!-- AI 종합 분석 가이드 (수정) -->
                    <div class="result-card" id="aiGuideCard" style="display: none;">
                        <div class="result-card-title">
                            <i class="fas fa-robot"></i> AI 종합 분석
                            <span class="status-badge" id="statusBadge"></span>
                        </div>
                        <div class="result-card-content" id="aiGuideContent"></div>
                    </div>
                    
                    <!-- 권장 일일 칼로리 -->
                    <div class="result-card">
                        <div class="result-card-title">
                            <i class="fas fa-bullseye"></i> 권장 일일 칼로리
                        </div>
                        <div class="result-card-content">
                            <div class="recommended-calories" id="recommendedCalories"></div>
                        </div>
                    </div>
                    
                    <!-- 조절 방안 -->
                    <div class="result-card">
                        <div class="result-card-title">
                            <i class="fas fa-balance-scale"></i> 조절 방안
                        </div>
                        <div class="result-card-content" id="adjustmentPlanContent"></div>
                    </div>
                    
                    <!-- 구체적인 식단 조절 제안 -->
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

<!-- AI 분석 로딩 모달 -->
<div class="modal-overlay" id="loadingModal" style="display: none; z-index: 1060; backdrop-filter: blur(5px);">
    <div style="background: white; border-radius: 20px; text-align: center; padding: 40px 50px; box-shadow: 0 20px 60px rgba(0,0,0,0.3);">
        <div class="spinner"></div>
        <p style="font-size: 18px; font-weight: 600; color: #2d3748; margin-top: 10px; margin-bottom: 5px;">AI가 식단을 분석 중입니다...</p>
        <p style="font-size: 14px; color: #718096; margin: 0;">잠시만 기다려주세요.</p>
    </div>
</div>

<!-- Chart.js -->
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

<script>
    let caloriesChart = null;
    let currentPeriod = 'default'; // 현재 선택된 기간
    
    // recId 가져오기 함수
    function getRecId() {
        // 1. select 요소에서 가져오기
        const recipientSelect = document.getElementById('recipientSelect');
        if (recipientSelect && recipientSelect.value) {
            return recipientSelect.value;
        }
        
        // 2. hidden input에서 가져오기
        const hiddenRecId = document.getElementById('currentRecIdValue');
        if (hiddenRecId && hiddenRecId.value) {
            return hiddenRecId.value;
        }
        
        return null;
    }
    
    // 칼로리 차트 로드 (기본: 최근 30일)
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
                console.log('응답 상태:', response.status, response.statusText);
                if (!response.ok) {
                    throw new Error(`HTTP error! status: ${response.status}`);
                }
                return response.json();
            })
            .then(data => {
                console.log('차트 데이터 응답:', data);
                loadingDiv.style.display = 'none';
                
                if (data.success && data.labels && data.data) {
                    if (data.labels.length === 0) {
                        showEmptyChart();
                    } else {
                        const isMealType = data.isMealType || false;
                        renderChart(data.labels, data.data, 'default', isMealType);
                    }
                } else {
                    console.error('차트 데이터 로드 실패:', data);
                    const errorMsg = data.message || '차트 데이터를 불러올 수 없습니다.';
                    showError(errorMsg);
                }
            })
            .catch(error => {
                loadingDiv.style.display = 'none';
                console.error('차트 로드 에러:', error);
                showError('차트 데이터를 불러오는 중 오류가 발생했습니다: ' + error.message);
            });
    }
    
    // 페이지 로드 시 데이터 로드
    document.addEventListener('DOMContentLoaded', function() {
        const recId = getRecId();
        console.log('페이지 로드 - recId:', recId);
        
        if (recId && recId !== 'null' && recId !== null && recId !== '' && recId !== undefined) {
            loadCaloriesStats();
            // 약간의 지연을 두어 DOM이 완전히 로드되도록 함
            setTimeout(() => {
                loadCaloriesChart(); // 기본: 최근 30일
            }, 100);
        } else {
            console.error('recId를 가져올 수 없습니다.');
        }
    });
    
    // 기간별 차트 로드
    function loadChartByPeriod(period) {
        // recId 가져오기
        const recId = getRecId();
        
        // recId 유효성 검사
        if (!recId || recId === 'null' || recId === null || recId === '' || recId === undefined) {
            console.error('recId가 유효하지 않습니다:', recId);
            alert('대상자 정보가 없습니다. 대상자를 선택해주세요.');
            return;
        }
        
        console.log('차트 로드 - recId:', recId, 'period:', period);
        
        currentPeriod = period;
        const chartWrapper = document.querySelector('.chart-wrapper');
        
        // 차트 영역 초기화
        chartWrapper.innerHTML = `
            <div class="loading" id="chartLoading">
                <i class="fas fa-spinner"></i>
                <p>차트 데이터를 불러오는 중...</p>
            </div>
            <canvas id="caloriesChart"></canvas>
        `;
        
        // 초기화 후 loadingDiv 다시 가져오기
        const loadingDiv = document.getElementById('chartLoading');
        loadingDiv.style.display = 'block';
        
        // 기간에 따른 시작일과 종료일 계산
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
                // 이번주 월요일부터 오늘까지
                const dayOfWeek = today.getDay();
                const diff = today.getDate() - dayOfWeek + (dayOfWeek === 0 ? -6 : 1); // 월요일
                startDate = new Date(today.getFullYear(), today.getMonth(), diff);
                endDate = new Date(today);
                title = '<i class="fas fa-calendar-week"></i> 이번주 칼로리';
                description = '이번주(월요일~오늘) 일별 칼로리 소비량을 그래프로 표시합니다.';
                break;
            case 'month':
                // 이번달 1일부터 오늘까지
                startDate = new Date(today.getFullYear(), today.getMonth(), 1);
                endDate = new Date(today);
                title = '<i class="fas fa-calendar-alt"></i> 이번달 칼로리';
                description = '이번달 일별 칼로리 소비량을 그래프로 표시합니다.';
                break;
            default:
                // 최근 30일
                startDate = new Date(today);
                startDate.setDate(startDate.getDate() - 29);
                endDate = new Date(today);
                title = '<i class="fas fa-chart-area"></i> 일별 칼로리 추이';
                description = '최근 30일간의 일별 칼로리 소비량을 그래프로 표시합니다.';
        }
        
        // 날짜를 YYYY-MM-DD 형식으로 변환
        const formatDate = (date) => {
            if (!date || isNaN(date.getTime())) {
                console.error('유효하지 않은 날짜:', date);
                return null;
            }
            const year = date.getFullYear();
            const month = String(date.getMonth() + 1).padStart(2, '0');
            const day = String(date.getDate()).padStart(2, '0');
            return `${year}-${month}-${day}`;
        };
        
        const startDateStr = formatDate(startDate);
        const endDateStr = formatDate(endDate);
        
        // 날짜 유효성 검사
        if (!startDateStr || !endDateStr) {
            console.error('날짜 변환 실패:', { startDate, endDate, startDateStr, endDateStr });
            showError('날짜 계산 중 오류가 발생했습니다.');
            return;
        }
        
        console.log('날짜 범위:', { startDateStr, endDateStr });
        
        // 차트 제목과 설명 업데이트
        document.getElementById('chartTitle').innerHTML = title;
        document.getElementById('chartDescription').textContent = description;
        
        // API 호출 (recId 사용)
        const apiUrl = `<c:url value="/mealplan/api/calories-chart"/>?recId=${recId}&startDate=${startDateStr}&endDate=${endDateStr}`;
        console.log('차트 데이터 요청:', apiUrl);
        
        fetch(apiUrl)
            .then(response => {
                console.log('응답 상태:', response.status, response.statusText);
                if (!response.ok) {
                    throw new Error(`HTTP error! status: ${response.status}`);
                }
                return response.json();
            })
            .then(data => {
                console.log('차트 데이터 응답:', data);
                loadingDiv.style.display = 'none';
                
                if (data.success && data.labels && data.data) {
                    if (data.labels.length === 0) {
                        showEmptyChart();
                    } else {
                        // 식사별 데이터인지 확인
                        const isMealType = data.isMealType || false;
                        renderChart(data.labels, data.data, period, isMealType);
                    }
                } else {
                    console.error('차트 데이터 로드 실패:', data);
                    const errorMsg = data.message || '차트 데이터를 불러올 수 없습니다.';
                    showError(errorMsg);
                }
            })
            .catch(error => {
                loadingDiv.style.display = 'none';
                console.error('차트 로드 에러:', error);
                showError('차트 데이터를 불러오는 중 오류가 발생했습니다: ' + error.message);
            });
    }
    
    // 대상자 변경
    function changeRecipient() {
        const recId = document.getElementById('recipientSelect').value;
        location.href = '<c:url value="/mealplan/calories-analysis"/>?recId=' + recId;
    }
    
    // 칼로리 통계 로드
    function loadCaloriesStats() {
        const recId = getRecId();
        
        if (!recId || recId === 'null' || recId === null || recId === '') {
            console.error('recId가 유효하지 않습니다.');
            return;
        }
        
        fetch('<c:url value="/mealplan/api/calories-stats"/>?recId=' + recId)
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    document.getElementById('todayCalories').textContent = 
                        formatNumber(data.todayCalories || 0);
                    document.getElementById('weekCalories').textContent = 
                        formatNumber(data.weekCalories || 0);
                    document.getElementById('monthCalories').textContent = 
                        formatNumber(data.monthCalories || 0);
                } else {
                    console.error('통계 로드 실패:', data.message);
                    showError('통계 데이터를 불러올 수 없습니다.');
                }
            })
            .catch(error => {
                console.error('Error:', error);
                showError('통계 데이터를 불러오는 중 오류가 발생했습니다.');
            });
    }
    
    
    // 차트 렌더링
    function renderChart(labels, data, period, isMealType = false) {
        const ctx = document.getElementById('caloriesChart');
        
        // 기존 차트가 있으면 제거
        if (caloriesChart) {
            caloriesChart.destroy();
        }
        
        // 라벨 포맷팅 (기간에 따라 다르게 표시)
        let formattedLabels;
        if (isMealType) {
            // 식사별 데이터인 경우 (오늘)
            formattedLabels = labels; // 아침, 점심, 저녁 그대로 사용
        } else {
            // 날짜 포맷팅
            formattedLabels = labels.map(label => {
                const date = new Date(label);
                const month = String(date.getMonth() + 1).padStart(2, '0');
                const day = String(date.getDate()).padStart(2, '0');
                
                if (period === 'week') {
                    // 주간은 요일 포함
                    const weekdays = ['일', '월', '화', '수', '목', '금', '토'];
                    const weekday = weekdays[date.getDay()];
                    return month + '/' + day + ' (' + weekday + ')';
                } else {
                    // 기본: MM/DD
                    return month + '/' + day;
                }
            });
        }
        
        // 차트 타입 결정 (식사별은 막대 차트, 일별은 선 차트)
        const chartType = isMealType ? 'bar' : 'line';
        
        // 차트 색상 설정
        let chartColors;
        if (isMealType) {
            // 식사별 막대 차트 색상
            chartColors = {
                backgroundColor: [
                    'rgba(102, 126, 234, 0.8)',  // 아침
                    'rgba(118, 75, 162, 0.8)',   // 점심
                    'rgba(240, 147, 251, 0.8)'   // 저녁
                ],
                borderColor: [
                    'rgb(102, 126, 234)',
                    'rgb(118, 75, 162)',
                    'rgb(240, 147, 251)'
                ]
            };
        } else {
            // 일별 선 차트 색상
            chartColors = {
                backgroundColor: 'rgba(102, 126, 234, 0.1)',
                borderColor: 'rgb(102, 126, 234)'
            };
        }
        
        const datasetConfig = {
            label: isMealType ? '식사별 칼로리 (kcal)' : '칼로리 (kcal)',
            data: data,
            borderWidth: 3,
            pointRadius: 4,
            pointHoverRadius: 6,
            pointBackgroundColor: chartColors.borderColor,
            pointBorderColor: '#fff',
            pointBorderWidth: 2
        };
        
        if (isMealType) {
            // 막대 차트 설정
            datasetConfig.backgroundColor = chartColors.backgroundColor;
            datasetConfig.borderColor = chartColors.borderColor;
        } else {
            // 선 차트 설정
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
                            font: {
                                size: 14,
                                weight: 'bold'
                            },
                            color: '#2c3e50'
                        }
                    },
                    tooltip: {
                        backgroundColor: 'rgba(0, 0, 0, 0.8)',
                        padding: 12,
                        titleFont: {
                            size: 16,
                            weight: 'bold'
                        },
                        bodyFont: {
                            size: 14
                        },
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
                            font: {
                                size: 14,
                                weight: 'bold'
                            },
                            color: '#2c3e50'
                        },
                        ticks: {
                            font: {
                                size: 12
                            },
                            color: '#666',
                            callback: function(value) {
                                return formatNumber(value);
                            }
                        },
                        grid: {
                            color: 'rgba(0, 0, 0, 0.05)'
                        }
                    },
                    x: {
                        title: {
                            display: true,
                            text: '날짜',
                            font: {
                                size: 14,
                                weight: 'bold'
                            },
                            color: '#2c3e50'
                        },
                        ticks: {
                            font: {
                                size: 12
                            },
                            color: '#666',
                            maxRotation: 45,
                            minRotation: 45
                        },
                        grid: {
                            display: false
                        }
                    }
                }
            }
        });
    }
    
    // 빈 차트 표시
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
    
    // 에러 표시
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
    
    // 숫자 포맷팅 (천 단위 구분)
    function formatNumber(num) {
        return num.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
    }
    
    // AI 분석 시작
    function startAiAnalysis() {
        const recId = getRecId();
        
        if (!recId || recId === 'null' || recId === null || recId === '') {
            alert('대상자 정보가 없습니다. 대상자를 선택해주세요.');
            return;
        }
        
        const btnAnalyze = document.getElementById('btnAnalyze');
        const analysisResult = document.getElementById('analysisResult');
        
        // 버튼 비활성화 및 로딩 표시
        btnAnalyze.disabled = true;
        document.getElementById('loadingModal').style.display = 'flex';
        analysisResult.classList.remove('show');
        
        // API 호출
        fetch('<c:url value="/mealplan/api/calories-analysis"/>', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({
                recId: parseInt(recId) || recId  // 숫자로 변환 시도
            })
        })
        .then(response => response.json())
        .then(data => {
            document.getElementById('loadingModal').style.display = 'none';
            btnAnalyze.disabled = false;
            
            if (data.success) {
                // 결과 표시
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
    
    // 분석 결과 표시
    function displayAnalysisResult(data) {
        const analysisResult = document.getElementById('analysisResult');
        const aiGuideCard = document.getElementById('aiGuideCard');
        const aiGuideContent = document.getElementById('aiGuideContent');
        const statusBadge = document.getElementById('statusBadge');
        const recommendedCalories = document.getElementById('recommendedCalories');
        const adjustmentPlanContent = document.getElementById('adjustmentPlanContent');
        const dietSuggestionContent = document.getElementById('dietSuggestionContent');
        
        // AI 종합 분석 가이드 표시
        if (data.aiAnalysis) {
            aiGuideContent.textContent = data.aiAnalysis;
            aiGuideCard.style.display = 'block';
        } else {
            aiGuideCard.style.display = 'none';
        }

        // 상태 설정
        const status = data.status || '적정';
        statusBadge.textContent = status;
        statusBadge.className = 'status-badge ' + status;
        
        // 권장 칼로리
        const recommended = data.recommendedCalories || 2000;
        recommendedCalories.textContent = formatNumber(recommended) + ' kcal';
        
        // 조절 방안
        adjustmentPlanContent.textContent = data.adjustmentPlan || '조절 방안이 없습니다.';
        
        // 식단 조절 제안
        dietSuggestionContent.textContent = data.dietSuggestion || '식단 조절 제안이 없습니다.';
        
        // 결과 영역 표시
        analysisResult.classList.add('show');
    }
</script>
