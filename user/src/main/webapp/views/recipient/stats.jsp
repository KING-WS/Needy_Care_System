<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<style>
    .stats-container {
        padding: 30px;
    }
    
    .page-header {
        margin-bottom: 30px;
        padding-bottom: 20px;
        border-bottom: 2px solid #f0f0f0;
    }
    
    .page-title {
        font-size: 28px;
        font-weight: 700;
        color: #2c3e50;
    }
    
    .page-title i {
        margin-right: 10px;
        color: #667eea;
    }
    
    .stats-grid {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
        gap: 25px;
        margin-bottom: 40px;
    }
    
    .stat-card {
        background: white;
        border-radius: 20px;
        padding: 30px;
        box-shadow: 0 5px 20px rgba(0,0,0,0.08);
        transition: all 0.3s ease;
        border-left: 5px solid;
    }
    
    .stat-card:hover {
        transform: translateY(-5px);
        box-shadow: 0 10px 30px rgba(0,0,0,0.15);
    }
    
    .stat-card.total {
        border-left-color: #667eea;
        background: linear-gradient(135deg, rgba(102, 126, 234, 0.05) 0%, rgba(118, 75, 162, 0.05) 100%);
    }
    
    .stat-card.elderly {
        border-left-color: #1976d2;
    }
    
    .stat-card.pregnant {
        border-left-color: #c2185b;
    }
    
    .stat-card.disabled {
        border-left-color: #7b1fa2;
    }
    
    .stat-icon {
        width: 60px;
        height: 60px;
        border-radius: 50%;
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 28px;
        margin-bottom: 20px;
    }
    
    .stat-card.total .stat-icon {
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        color: white;
    }
    
    .stat-card.elderly .stat-icon {
        background: #e3f2fd;
        color: #1976d2;
    }
    
    .stat-card.pregnant .stat-icon {
        background: #fce4ec;
        color: #c2185b;
    }
    
    .stat-card.disabled .stat-icon {
        background: #f3e5f5;
        color: #7b1fa2;
    }
    
    .stat-label {
        font-size: 14px;
        color: #999;
        margin-bottom: 10px;
        font-weight: 600;
        text-transform: uppercase;
        letter-spacing: 1px;
    }
    
    .stat-value {
        font-size: 36px;
        font-weight: 700;
        color: #2c3e50;
        margin-bottom: 5px;
    }
    
    .stat-description {
        font-size: 13px;
        color: #666;
    }
    
    .chart-section {
        background: white;
        border-radius: 20px;
        padding: 30px;
        box-shadow: 0 5px 20px rgba(0,0,0,0.08);
        margin-bottom: 30px;
    }
    
    .section-title {
        font-size: 20px;
        font-weight: 700;
        color: #2c3e50;
        margin-bottom: 20px;
    }
    
    .chart-placeholder {
        height: 300px;
        display: flex;
        align-items: center;
        justify-content: center;
        background: #f8f9fa;
        border-radius: 10px;
        color: #999;
        font-size: 16px;
    }
    
    .empty-state {
        text-align: center;
        padding: 80px 20px;
        background: white;
        border-radius: 20px;
        box-shadow: 0 5px 20px rgba(0,0,0,0.08);
    }
    
    .empty-icon {
        font-size: 80px;
        color: #e0e0e0;
        margin-bottom: 20px;
    }
    
    .empty-title {
        font-size: 24px;
        font-weight: 700;
        color: #666;
        margin-bottom: 10px;
    }
    
    .empty-subtitle {
        font-size: 16px;
        color: #999;
        margin-bottom: 30px;
    }
    
    .add-btn {
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        color: white;
        border: none;
        padding: 12px 30px;
        border-radius: 50px;
        font-weight: 600;
        cursor: pointer;
        transition: all 0.3s ease;
        box-shadow: 0 4px 15px rgba(102, 126, 234, 0.4);
    }
    
    .add-btn:hover {
        transform: translateY(-2px);
        box-shadow: 0 6px 20px rgba(102, 126, 234, 0.6);
    }
</style>

<div class="stats-container">
    <div class="page-header">
        <h1 class="page-title">
            <i class="bi bi-bar-chart-fill"></i> 통계 현황
        </h1>
    </div>
    
    <div id="statsContent">
        <div class="empty-state">
            <div class="empty-icon"><i class="bi bi-hourglass-split"></i></div>
            <div class="empty-title">데이터를 불러오는 중...</div>
        </div>
    </div>
</div>

<script>
    // 페이지 로드 시 통계 데이터 가져오기
    document.addEventListener('DOMContentLoaded', function() {
        loadStats();
    });
    
    // 통계 데이터 로드
    function loadStats() {
        fetch('<c:url value="/recipient/api/list"/>')
            .then(response => response.json())
            .then(data => {
                displayStats(data);
            })
            .catch(error => {
                console.error('Error:', error);
                document.getElementById('statsContent').innerHTML = `
                    <div class="empty-state">
                        <div class="empty-icon"><i class="bi bi-exclamation-triangle"></i></div>
                        <div class="empty-title">데이터를 불러올 수 없습니다</div>
                        <div class="empty-subtitle">잠시 후 다시 시도해주세요.</div>
                    </div>
                `;
            });
    }
    
    // 통계 표시
    function displayStats(recipients) {
        const container = document.getElementById('statsContent');
        
        if (!recipients || recipients.length === 0) {
            container.innerHTML = `
                <div class="empty-state">
                    <div class="empty-icon"><i class="bi bi-person-x"></i></div>
                    <div class="empty-title">등록된 돌봄 대상자가 없습니다</div>
                    <div class="empty-subtitle">새로운 대상자를 등록하여 통계를 확인하세요.</div>
                    <button class="add-btn" onclick="location.href='<c:url value='/recipient/register'/>'">
                        <i class="bi bi-plus-circle"></i> 첫 대상자 등록하기
                    </button>
                </div>
            `;
            return;
        }
        
        // 유형별 집계
        const stats = {
            total: recipients.length,
            elderly: recipients.filter(r => r.recTypeCode === 'ELDERLY').length,
            pregnant: recipients.filter(r => r.recTypeCode === 'PREGNANT').length,
            disabled: recipients.filter(r => r.recTypeCode === 'DISABLED').length
        };
        
        // 성별 집계
        const genderStats = {
            male: recipients.filter(r => r.recGender === 'M').length,
            female: recipients.filter(r => r.recGender === 'F').length
        };
        
        let html = `
            <div class="stats-grid">
                <div class="stat-card total">
                    <div class="stat-icon">
                        <i class="bi bi-people-fill"></i>
                    </div>
                    <div class="stat-label">전체 대상자</div>
                    <div class="stat-value">\${stats.total}명</div>
                    <div class="stat-description">등록된 전체 돌봄 대상자</div>
                </div>
                
                <div class="stat-card elderly">
                    <div class="stat-icon">
                        <i class="bi bi-person-walking"></i>
                    </div>
                    <div class="stat-label">노인/고령자</div>
                    <div class="stat-value">\${stats.elderly}명</div>
                    <div class="stat-description">\${((stats.elderly / stats.total) * 100).toFixed(1)}%</div>
                </div>
                
                <div class="stat-card pregnant">
                    <div class="stat-icon">
                        <i class="bi bi-heart-pulse"></i>
                    </div>
                    <div class="stat-label">임산부</div>
                    <div class="stat-value">\${stats.pregnant}명</div>
                    <div class="stat-description">\${((stats.pregnant / stats.total) * 100).toFixed(1)}%</div>
                </div>
                
                <div class="stat-card disabled">
                    <div class="stat-icon">
                        <i class="bi bi-universal-access"></i>
                    </div>
                    <div class="stat-label">장애인</div>
                    <div class="stat-value">\${stats.disabled}명</div>
                    <div class="stat-description">\${((stats.disabled / stats.total) * 100).toFixed(1)}%</div>
                </div>
            </div>
            
            <div class="chart-section">
                <h3 class="section-title"><i class="bi bi-pie-chart"></i> 성별 분포</h3>
                <div style="display: grid; grid-template-columns: repeat(2, 1fr); gap: 20px;">
                    <div style="text-align: center; padding: 30px; background: #e3f2fd; border-radius: 15px;">
                        <div style="font-size: 48px; margin-bottom: 10px;">👨</div>
                        <div style="font-size: 32px; font-weight: 700; color: #1976d2; margin-bottom: 5px;">\${genderStats.male}명</div>
                        <div style="font-size: 14px; color: #666;">남성 (\${((genderStats.male / stats.total) * 100).toFixed(1)}%)</div>
                    </div>
                    <div style="text-align: center; padding: 30px; background: #fce4ec; border-radius: 15px;">
                        <div style="font-size: 48px; margin-bottom: 10px;">👩</div>
                        <div style="font-size: 32px; font-weight: 700; color: #c2185b; margin-bottom: 5px;">\${genderStats.female}명</div>
                        <div style="font-size: 14px; color: #666;">여성 (\${((genderStats.female / stats.total) * 100).toFixed(1)}%)</div>
                    </div>
                </div>
            </div>
            
            <div class="chart-section">
                <h3 class="section-title"><i class="bi bi-graph-up"></i> 연령대별 분포</h3>
                <div class="chart-placeholder">
                    <div style="text-align: center;">
                        <i class="bi bi-graph-up" style="font-size: 48px; margin-bottom: 10px;"></i>
                        <div>차트는 추후 구현 예정입니다</div>
                    </div>
                </div>
            </div>
        `;
        
        container.innerHTML = html;
    }
</script>

