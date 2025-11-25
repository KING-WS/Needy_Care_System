<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- Chart.js 라이브러리 -->
<script src="https://cdn.jsdelivr.net/npm/chart.js@3.9.1/dist/chart.min.js"></script>

<style>
    .ai-calories-section {
        padding: 20px 0 100px 0;
        background: #FFFFFF;
    }
    
    .ai-calories-container {
        max-width: 1400px;
        margin: 0 auto;
        padding: 0 20px;
    }
    
    .page-header {
        margin-bottom: 30px;
    }
    
    .page-header h1 {
        font-size: 36px;
        font-weight: bold;
        color: var(--secondary-color);
        margin-bottom: 10px;
    }
    
    .page-header p {
        font-size: 16px;
        color: #666;
    }
    
    .recipient-select-card {
        background: #f8f9fa;
        border-radius: 12px;
        padding: 20px;
        margin-bottom: 30px;
    }
    
    .recipient-select-label {
        font-weight: 600;
        color: #2c3e50;
        margin-bottom: 10px;
        display: block;
    }
    
    .recipient-select {
        width: 100%;
        padding: 12px;
        border: 1px solid #ddd;
        border-radius: 8px;
        font-size: 16px;
    }
    
    .date-range-selector {
        background: #fff;
        border-radius: 12px;
        box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        padding: 20px;
        margin-bottom: 30px;
        display: flex;
        gap: 15px;
        align-items: center;
        flex-wrap: wrap;
    }
    
    .date-range-selector label {
        font-weight: 600;
        color: #2c3e50;
    }
    
    .date-range-selector input {
        padding: 10px;
        border: 1px solid #ddd;
        border-radius: 8px;
        font-size: 14px;
    }
    
    .date-range-selector button {
        padding: 10px 20px;
        background: var(--primary-color);
        color: white;
        border: none;
        border-radius: 8px;
        cursor: pointer;
        font-weight: 600;
        transition: background 0.3s;
    }
    
    .date-range-selector button:hover {
        background: var(--primary-color-dark);
    }
    
    .chart-container {
        background: #fff;
        border-radius: 15px;
        box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        padding: 30px;
        margin-bottom: 30px;
    }
    
    .chart-container h3 {
        font-size: 20px;
        color: #2c3e50;
        margin-bottom: 20px;
        padding-bottom: 15px;
        border-bottom: 2px solid #eee;
    }
    
    .chart-wrapper {
        position: relative;
        height: 400px;
        margin-top: 20px;
    }
    
    .analysis-container {
        background: #fff;
        border-radius: 15px;
        box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        padding: 30px;
        margin-bottom: 30px;
    }
    
    .analysis-section {
        margin-bottom: 30px;
    }
    
    .analysis-section:last-child {
        margin-bottom: 0;
    }
    
    .analysis-section h4 {
        font-size: 18px;
        color: #2c3e50;
        margin-bottom: 15px;
        padding-bottom: 10px;
        border-bottom: 1px solid #eee;
        display: flex;
        align-items: center;
        gap: 10px;
    }
    
    .status-badge {
        display: inline-block;
        padding: 6px 12px;
        border-radius: 20px;
        font-size: 14px;
        font-weight: 600;
        margin-left: 10px;
    }
    
    .status-badge.good {
        background: #d4edda;
        color: #155724;
    }
    
    .status-badge.warning {
        background: #fff3cd;
        color: #856404;
    }
    
    .status-badge.poor {
        background: #f8d7da;
        color: #721c24;
    }
    
    .analysis-content {
        font-size: 16px;
        line-height: 1.8;
        color: #333;
    }
    
    .list-items {
        list-style: none;
        padding: 0;
        margin-top: 15px;
    }
    
    .list-items li {
        padding: 12px;
        margin-bottom: 10px;
        border-radius: 8px;
        display: flex;
        align-items: start;
        gap: 10px;
    }
    
    .list-items.avoid li {
        background: #f8d7da;
        color: #721c24;
    }
    
    .list-items.recommend li {
        background: #d4edda;
        color: #155724;
    }
    
    .list-items.caution li {
        background: #fff3cd;
        color: #856404;
    }
    
    .stat-cards {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
        gap: 20px;
        margin-bottom: 30px;
    }
    
    .stat-card {
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        border-radius: 15px;
        padding: 25px;
        color: white;
        box-shadow: 0 5px 15px rgba(0,0,0,0.1);
    }
    
    .stat-card:nth-child(2) {
        background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
    }
    
    .stat-card:nth-child(3) {
        background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
    }
    
    .stat-card:nth-child(4) {
        background: linear-gradient(135deg, #43e97b 0%, #38f9d7 100%);
    }
    
    .stat-card-label {
        font-size: 14px;
        opacity: 0.9;
        margin-bottom: 10px;
    }
    
    .stat-card-value {
        font-size: 32px;
        font-weight: 700;
    }
    
    .loading {
        text-align: center;
        padding: 40px;
        display: none;
    }
    
    .loading.show {
        display: block;
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
    
    @keyframes spin {
        0% { transform: rotate(0deg); }
        100% { transform: rotate(360deg); }
    }
</style>

<section class="ai-calories-section">
    <div class="ai-calories-container">
        <!-- 헤더 -->
        <div class="page-header">
            <h1>
                <i class="fas fa-chart-pie"></i> AI 식단 칼로리 통계
            </h1>
            <p>식단 칼로리를 분석하여 건강 상태를 파악하고 식단 방향성을 제시합니다</p>
        </div>

        <!-- 노약자 선택 -->
        <c:if test="${not empty recipientList}">
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
        </c:if>

        <!-- 날짜 범위 선택 -->
        <div class="date-range-selector">
            <label>분석 기간:</label>
            <input type="date" id="startDate" />
            <span>~</span>
            <input type="date" id="endDate" />
            <button onclick="loadAnalysis()">
                <i class="fas fa-search"></i> 분석하기
            </button>
        </div>

        <!-- 로딩 -->
        <div class="loading" id="loadingDiv">
            <div class="spinner"></div>
            <p>AI가 칼로리 데이터를 분석하고 있습니다...</p>
        </div>

        <!-- 통계 카드 -->
        <div class="stat-cards" id="statCards" style="display: none;">
            <div class="stat-card">
                <div class="stat-card-label">일평균 칼로리</div>
                <div class="stat-card-value" id="dailyAverage">0</div>
            </div>
            <div class="stat-card">
                <div class="stat-card-label">최고 칼로리</div>
                <div class="stat-card-value" id="maxCalories">0</div>
            </div>
            <div class="stat-card">
                <div class="stat-card-label">최저 칼로리</div>
                <div class="stat-card-value" id="minCalories">0</div>
            </div>
            <div class="stat-card">
                <div class="stat-card-label">권장 칼로리</div>
                <div class="stat-card-value" id="recommendedCalories">-</div>
            </div>
        </div>

        <!-- 차트 -->
        <div class="chart-container" id="chartContainer" style="display: none;">
            <h3><i class="fas fa-chart-line"></i> 일별 칼로리 추이</h3>
            <div class="chart-wrapper">
                <canvas id="calorieChart"></canvas>
            </div>
        </div>

        <!-- AI 분석 결과 -->
        <div class="analysis-container" id="analysisContainer" style="display: none;">
            <!-- 전체 상태 -->
            <div class="analysis-section">
                <h4>
                    <i class="fas fa-clipboard-check"></i> 전체 상태 평가
                    <span class="status-badge" id="overallStatusBadge"></span>
                </h4>
                <div class="analysis-content" id="overallStatus"></div>
            </div>

            <!-- 식단 방향성 -->
            <div class="analysis-section">
                <h4><i class="fas fa-compass"></i> 식단 방향성</h4>
                <div class="analysis-content" id="dietDirection"></div>
            </div>

            <!-- 건강 상태 -->
            <div class="analysis-section">
                <h4><i class="fas fa-heartbeat"></i> 건강 상태 분석</h4>
                <div class="analysis-content" id="healthStatus"></div>
            </div>

            <!-- 음식 권장사항 -->
            <div class="analysis-section">
                <h4><i class="fas fa-utensils"></i> 음식 권장사항</h4>
                <div>
                    <h5 style="color: #721c24; margin-top: 15px;">피해야 할 음식</h5>
                    <ul class="list-items avoid" id="avoidFoods"></ul>
                    
                    <h5 style="color: #155724; margin-top: 15px;">권장 음식</h5>
                    <ul class="list-items recommend" id="recommendFoods"></ul>
                    
                    <h5 style="color: #856404; margin-top: 15px;">주의 음식</h5>
                    <ul class="list-items caution" id="cautionFoods"></ul>
                </div>
            </div>

            <!-- 권장사항 -->
            <div class="analysis-section">
                <h4><i class="fas fa-lightbulb"></i> 개선 권장사항</h4>
                <ul class="list-items recommend" id="recommendations"></ul>
            </div>
        </div>
    </div>
</section>

<script>
    let currentRecId = <c:choose><c:when test="${selectedRecipient != null}">${selectedRecipient.recId}</c:when><c:otherwise>null</c:otherwise></c:choose>;
    let calorieChart = null;

    // 날짜 초기화 (최근 30일)
    document.addEventListener('DOMContentLoaded', function() {
        const endDate = new Date();
        const startDate = new Date();
        startDate.setDate(startDate.getDate() - 30);
        
        document.getElementById('endDate').value = endDate.toISOString().split('T')[0];
        document.getElementById('startDate').value = startDate.toISOString().split('T')[0];
        
        // 자동으로 분석 실행 (노약자가 선택된 경우에만)
        if (currentRecId) {
            loadAnalysis();
        }
    });

    function changeRecipient() {
        const select = document.getElementById('recipientSelect');
        currentRecId = parseInt(select.value);
        loadAnalysis();
    }

    function loadAnalysis() {
        if (!currentRecId) {
            alert('돌봄 대상자를 선택해주세요.');
            return;
        }

        const startDate = document.getElementById('startDate').value;
        const endDate = document.getElementById('endDate').value;

        if (!startDate || !endDate) {
            alert('시작일과 종료일을 선택해주세요.');
            return;
        }

        // 로딩 표시
        document.getElementById('loadingDiv').classList.add('show');
        document.getElementById('statCards').style.display = 'none';
        document.getElementById('chartContainer').style.display = 'none';
        document.getElementById('analysisContainer').style.display = 'none';

        // API 호출
        fetch(`/mealplan/api/ai-calories?recId=${currentRecId}&startDate=${startDate}&endDate=${endDate}`)
            .then(response => response.json())
            .then(data => {
                document.getElementById('loadingDiv').classList.remove('show');
                
                if (data.success) {
                    displayResults(data);
                } else {
                    alert('분석 중 오류가 발생했습니다: ' + (data.message || '알 수 없는 오류'));
                }
            })
            .catch(error => {
                document.getElementById('loadingDiv').classList.remove('show');
                console.error('Error:', error);
                alert('분석 중 오류가 발생했습니다.');
            });
    }

    function displayResults(data) {
        const calorieData = data.calorieData;
        const analysis = data.analysis;

        // 통계 카드 표시
        document.getElementById('dailyAverage').textContent = calorieData.dailyAverage + ' kcal';
        document.getElementById('maxCalories').textContent = calorieData.maxCalories + ' kcal';
        document.getElementById('minCalories').textContent = calorieData.minCalories + ' kcal';
        
        if (analysis.analysis && analysis.analysis.recommendedCalories) {
            document.getElementById('recommendedCalories').textContent = analysis.analysis.recommendedCalories + ' kcal';
        }
        
        document.getElementById('statCards').style.display = 'grid';

        // 차트 생성
        createChart(calorieData.dailyData);
        document.getElementById('chartContainer').style.display = 'block';

        // AI 분석 결과 표시
        if (analysis) {
            displayAnalysis(analysis);
            document.getElementById('analysisContainer').style.display = 'block';
        }
    }

    function createChart(dailyData) {
        const ctx = document.getElementById('calorieChart').getContext('2d');
        
        // 기존 차트가 있으면 제거
        if (calorieChart) {
            calorieChart.destroy();
        }

        const labels = dailyData.map(d => {
            const date = new Date(d.date);
            return (date.getMonth() + 1) + '/' + date.getDate();
        });
        const calories = dailyData.map(d => d.calories);

        calorieChart = new Chart(ctx, {
            type: 'line',
            data: {
                labels: labels,
                datasets: [{
                    label: '칼로리 (kcal)',
                    data: calories,
                    borderColor: 'rgb(75, 192, 192)',
                    backgroundColor: 'rgba(75, 192, 192, 0.2)',
                    tension: 0.4,
                    fill: true
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: {
                        display: true,
                        position: 'top'
                    },
                    tooltip: {
                        mode: 'index',
                        intersect: false
                    }
                },
                scales: {
                    y: {
                        beginAtZero: true,
                        title: {
                            display: true,
                            text: '칼로리 (kcal)'
                        }
                    }
                }
            }
        });
    }

    function displayAnalysis(analysis) {
        // 전체 상태
        if (analysis.analysis) {
            const overallStatus = analysis.analysis.overallStatus || 'GOOD';
            const badge = document.getElementById('overallStatusBadge');
            
            if (overallStatus === 'GOOD') {
                badge.className = 'status-badge good';
                badge.textContent = '양호';
            } else if (overallStatus === 'WARNING') {
                badge.className = 'status-badge warning';
                badge.textContent = '주의';
            } else {
                badge.className = 'status-badge poor';
                badge.textContent = '불량';
            }
            
            document.getElementById('overallStatus').innerHTML = 
                '<strong>칼로리 상태:</strong> ' + (analysis.analysis.calorieStatus || '-') + '<br>' +
                '<strong>평균 칼로리:</strong> ' + (analysis.analysis.averageCalories || '-') + ' kcal<br>' +
                '<strong>권장 칼로리:</strong> ' + (analysis.analysis.recommendedCalories || '-') + ' kcal<br><br>' +
                (analysis.analysis.statusMessage || '');
        }

        // 식단 방향성
        if (analysis.dietDirection) {
            let directionHtml = analysis.dietDirection.direction || '';
            if (analysis.dietDirection.focusAreas && analysis.dietDirection.focusAreas.length > 0) {
                directionHtml += '<br><br><strong>중점 영역:</strong><ul style="margin-top: 10px;">';
                analysis.dietDirection.focusAreas.forEach(area => {
                    directionHtml += '<li>' + area + '</li>';
                });
                directionHtml += '</ul>';
            }
            document.getElementById('dietDirection').innerHTML = directionHtml;
        }

        // 건강 상태
        if (analysis.healthStatus) {
            let healthHtml = analysis.healthStatus.currentStatus || '';
            if (analysis.healthStatus.concerns && analysis.healthStatus.concerns.length > 0) {
                healthHtml += '<br><br><strong>우려사항:</strong><ul style="margin-top: 10px;">';
                analysis.healthStatus.concerns.forEach(concern => {
                    healthHtml += '<li>' + concern + '</li>';
                });
                healthHtml += '</ul>';
            }
            if (analysis.healthStatus.improvements && analysis.healthStatus.improvements.length > 0) {
                healthHtml += '<br><br><strong>개선사항:</strong><ul style="margin-top: 10px;">';
                analysis.healthStatus.improvements.forEach(improvement => {
                    healthHtml += '<li>' + improvement + '</li>';
                });
                healthHtml += '</ul>';
            }
            document.getElementById('healthStatus').innerHTML = healthHtml;
        }

        // 음식 권장사항
        if (analysis.foodRecommendations) {
            const avoidUl = document.getElementById('avoidFoods');
            const recommendUl = document.getElementById('recommendFoods');
            const cautionUl = document.getElementById('cautionFoods');
            
            avoidUl.innerHTML = '';
            recommendUl.innerHTML = '';
            cautionUl.innerHTML = '';
            
            if (analysis.foodRecommendations.avoid) {
                analysis.foodRecommendations.avoid.forEach(food => {
                    const li = document.createElement('li');
                    li.innerHTML = '<i class="fas fa-times-circle"></i> ' + food;
                    avoidUl.appendChild(li);
                });
            }
            
            if (analysis.foodRecommendations.recommend) {
                analysis.foodRecommendations.recommend.forEach(food => {
                    const li = document.createElement('li');
                    li.innerHTML = '<i class="fas fa-check-circle"></i> ' + food;
                    recommendUl.appendChild(li);
                });
            }
            
            if (analysis.foodRecommendations.caution) {
                analysis.foodRecommendations.caution.forEach(food => {
                    const li = document.createElement('li');
                    li.innerHTML = '<i class="fas fa-exclamation-triangle"></i> ' + food;
                    cautionUl.appendChild(li);
                });
            }
        }

        // 권장사항
        if (analysis.recommendations) {
            const recommendationsUl = document.getElementById('recommendations');
            recommendationsUl.innerHTML = '';
            analysis.recommendations.forEach(rec => {
                const li = document.createElement('li');
                li.innerHTML = '<i class="fas fa-lightbulb"></i> ' + rec;
                recommendationsUl.appendChild(li);
            });
        }
    }
</script>

