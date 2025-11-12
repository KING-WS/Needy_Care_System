<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<style>
    .chart-card {
        border-radius: 15px;
        overflow: hidden;
    }
    
    .chart-card .card-header {
        border-radius: 15px 15px 0 0;
    }
</style>

<div class="container-fluid py-4">
    <div class="row">
        <!-- AI 기능 사용 빈도 분석 -->
        <div class="col-md-6 mb-4">
            <div class="card shadow-sm chart-card">
                <div class="card-header">
                    <h5 class="mb-0">AI 기능 사용 빈도 분석</h5>
                </div>
                <div class="card-body">
                    <canvas id="aiUsageChart" height="250"></canvas>
                </div>
            </div>
        </div>
        
        <!-- 월별 신규 가입자 및 이탈자 추이 -->
        <div class="col-md-6 mb-4">
            <div class="card shadow-sm chart-card">
                <div class="card-header">
                    <h5 class="mb-0">월별 신규 가입자 및 이탈자 추이</h5>
                </div>
                <div class="card-body">
                    <canvas id="userTrendChart" height="250"></canvas>
                </div>
            </div>
        </div>
    </div>
    
    <div class="row">
        <!-- 등록된 노약자의 연령대 및 성별 분포 -->
        <div class="col-md-6 mb-4">
            <div class="card shadow-sm chart-card">
                <div class="card-header">
                    <h5 class="mb-0">등록된 노약자의 연령대 및 성별 분포</h5>
                </div>
                <div class="card-body">
                    <canvas id="ageGenderChart" height="250"></canvas>
                </div>
            </div>
        </div>
        
        <!-- 구독 등급별 고객 분포 -->
        <div class="col-md-6 mb-4">
            <div class="card shadow-sm chart-card">
                <div class="card-header">
                    <h5 class="mb-0">구독 등급별 고객 분포</h5>
                </div>
                <div class="card-body">
                    <canvas id="subscriptionChart" height="250"></canvas>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Chart.js -->
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script>
    // 1. AI 기능 사용 빈도 분석 (가로 막대 차트)
    const aiUsageCtx = document.getElementById('aiUsageChart');
    new Chart(aiUsageCtx, {
        type: 'bar',
        data: {
            labels: ['음성인식', '챗봇', '추천시스템', '예측분석', '이미지인식'],
            datasets: [{
                label: 'AI 기능 사용 빈도',
                data: [350, 280, 240, 180, 150],
                backgroundColor: 'rgba(54, 162, 235, 0.7)',
                borderColor: 'rgb(54, 162, 235)',
                borderWidth: 1
            }]
        },
        options: {
            indexAxis: 'y',
            responsive: true,
            maintainAspectRatio: false,
            plugins: {
                legend: {
                    display: false
                }
            },
            scales: {
                x: {
                    beginAtZero: true,
                    title: {
                        display: true,
                        text: '사용 빈도 (회)'
                    }
                }
            }
        }
    });

    // 2. 월별 신규 가입자 및 이탈자 추이 (세로 막대 차트 - 그룹)
    const userTrendCtx = document.getElementById('userTrendChart');
    new Chart(userTrendCtx, {
        type: 'bar',
        data: {
            labels: ['1월', '2월', '3월', '4월', '5월', '6월'],
            datasets: [{
                label: '신규가입',
                data: [8, 12, 15, 18, 17, 10],
                backgroundColor: 'rgba(54, 162, 235, 0.7)',
                borderColor: 'rgb(54, 162, 235)',
                borderWidth: 1
            }, {
                label: '이탈자',
                data: [5, 7, 9, 8, 12, 6],
                backgroundColor: 'rgba(255, 99, 132, 0.7)',
                borderColor: 'rgb(255, 99, 132)',
                borderWidth: 1
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: {
                legend: {
                    position: 'top',
                }
            },
            scales: {
                y: {
                    beginAtZero: true,
                    title: {
                        display: true,
                        text: '인원 (명)'
                    }
                }
            }
        }
    });

    // 3. 등록된 노약자의 연령대 및 성별 분포 (그룹 바 차트)
    const ageGenderCtx = document.getElementById('ageGenderChart');
    new Chart(ageGenderCtx, {
        type: 'bar',
        data: {
            labels: ['60대', '70대', '80대'],
            datasets: [{
                label: '남성',
                data: [320, 250, 180],
                backgroundColor: 'rgba(54, 162, 235, 0.7)',
                borderColor: 'rgb(54, 162, 235)',
                borderWidth: 1
            }, {
                label: '여성',
                data: [420, 350, 280],
                backgroundColor: 'rgba(255, 99, 132, 0.7)',
                borderColor: 'rgb(255, 99, 132)',
                borderWidth: 1
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: {
                legend: {
                    position: 'top',
                }
            },
            scales: {
                y: {
                    beginAtZero: true,
                    title: {
                        display: true,
                        text: '인원 (명)'
                    }
                },
                x: {
                    title: {
                        display: true,
                        text: '연령대'
                    }
                }
            }
        }
    });

    // 4. 구독 등급별 고객 분포 (파이 차트)
    const subscriptionCtx = document.getElementById('subscriptionChart');
    new Chart(subscriptionCtx, {
        type: 'pie',
        data: {
            labels: ['프리미엄', '스탠다드', '베이직'],
            datasets: [{
                data: [35, 45, 20],
                backgroundColor: [
                    'rgba(54, 162, 235, 0.8)',
                    'rgba(75, 192, 192, 0.8)',
                    'rgba(153, 102, 255, 0.8)'
                ],
                borderColor: [
                    'rgb(54, 162, 235)',
                    'rgb(75, 192, 192)',
                    'rgb(153, 102, 255)'
                ],
                borderWidth: 2
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: {
                legend: {
                    position: 'right',
                    labels: {
                        padding: 20,
                        font: {
                            size: 12
                        }
                    }
                }
            }
        }
    });
</script>

