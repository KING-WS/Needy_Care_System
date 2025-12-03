<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<style>
    .activity-link:hover .activity-item {
        background-color: var(--bs-light-bg-subtle);
    }
</style>

<div class="container-fluid p-4 p-lg-5">

    <!-- Stats Cards -->
    <div class="row g-4 mb-4">
        <div class="col-xl-3 col-lg-6">
            <div class="card stats-card">
                <div class="card-body">
                    <div class="d-flex align-items-center">
                        <div class="flex-shrink-0">
                            <div class="stats-icon bg-primary bg-opacity-10 text-primary">
                                <i class="bi bi-people"></i>
                            </div>
                        </div>
                        <div class="flex-grow-1 ms-3">
                            <h6 class="mb-0 text-muted">고객</h6>
                            <h3 class="mb-0">${userCount}명</h3>
<%--                            <small class="text-success">--%>
<%--                                <i class="bi bi-arrow-up"></i> +12.5%--%>
<%--                            </small>--%>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="col-xl-3 col-lg-6">
            <div class="card stats-card">
                <div class="card-body">
                    <div class="d-flex align-items-center">
                        <div class="flex-shrink-0">
                            <div class="stats-icon bg-success bg-opacity-10 text-success">
                                <i class="bi bi-people"></i>
                            </div>
                        </div>
                        <div class="flex-grow-1 ms-3">
                            <h6 class="mb-0 text-muted">노약자</h6>
                            <h3 class="mb-0">${seniorCount}명</h3>
<%--                            <small class="text-success">--%>
<%--                                <i class="bi bi-people"></i> +8.2%--%>
<%--                            </small>--%>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="col-xl-3 col-lg-6">
            <div class="card stats-card">
                <div class="card-body">
                    <div class="d-flex align-items-center">
                        <div class="flex-shrink-0">
                            <div class="stats-icon bg-warning bg-opacity-10 text-warning">
                                <i class="bi bi-bag-check"></i>
                            </div>
                        </div>
                        <div class="flex-grow-1 ms-3">
                            <h6 class="mb-0 text-muted">요양사</h6>
                            <h3 class="mb-0">${caregiverCount}명</h3>
<%--                            <small class="text-danger">--%>
<%--                                <i class="bi bi-arrow-down"></i> -2.1%--%>
<%--                            </small>--%>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="col-xl-3 col-lg-6">
            <div class="card stats-card">
                <div class="card-body">
                    <div class="d-flex align-items-center">
                        <div class="flex-shrink-0">
                            <div class="stats-icon bg-info bg-opacity-10 text-info">
                                <i class="bi bi-clock-history"></i>
                            </div>
                        </div>
                        <div class="flex-grow-1 ms-3">
                            <h6 class="mb-0 text-muted">읽지 않는 Q&A</h6>
                            <h3 class="mb-0">3건</h3>
<%--                            <small class="text-success">--%>
<%--                                <i class="bi bi-arrow-up"></i> +5.4%--%>
<%--                            </small>--%>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Chart Section -->
    <div class="row g-4 mb-4">
        <div class="col-lg-8">
            <div class="card">
                <div class="card-header d-flex justify-content-between align-items-center">
                    <h5 class="card-title mb-0">실시간 사용자 접속 추이</h5>
<%--                    <div class="btn-group btn-group-sm" role="group">--%>
<%--                        <button type="button" class="btn btn-outline-primary active">7D</button>--%>
<%--                        <button type="button" class="btn btn-outline-primary">30D</button>--%>
<%--                        <button type="button" class="btn btn-outline-primary">90D</button>--%>
<%--                        <button type="button" class="btn btn-outline-primary">1Y</button>--%>
<%--                    </div>--%>
                </div>
                <div class="card-body">
                    <canvas id="revenueChart" height="250"></canvas>
                </div>
            </div>
        </div>

        <div class="col-lg-4">
            <div class="card">
                <div class="card-header">
                    <h5 class="card-title mb-0">활동 피드</h5>
                </div>
                <div class="card-body">
                    <div class="activity-feed">
                        <!-- Activity items will be dynamically inserted here -->
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Additional Charts Row -->
    <div class="row g-4 mb-4">
        <div class="col-lg-6">
            <div class="card">
                <div class="card-header">
                    <h5 class="card-title mb-0"> 가입자 수 (일주일)</h5>
                </div>
                <div class="card-body">
                    <canvas id="userGrowthChart" height="200"></canvas>
                </div>
            </div>
        </div>

        <div class="col-lg-6">
            <div class="card">
                <div class="card-header">
                    <h5 class="card-title mb-0">지도</h5>
                </div>
                <div class="card-body">
                    <div id="dashboard-map" style="width: 100%; height: 300px; border-radius: 8px; border: 1px solid #e0e0e0;"></div>
                </div>
            </div>
        </div>
    </div>

    <!-- Recent Orders -->
<%--    <div class="row g-4">--%>
<%--        <div class="col-12">--%>
<%--            <div class="card">--%>
<%--                <div class="card-header">--%>
<%--                    <h5 class="card-title mb-0">Recent Orders</h5>--%>
<%--                </div>--%>
<%--                <div class="card-body">--%>
<%--                    <div class="table-responsive">--%>
<%--                        <table class="table table-hover mb-0">--%>
<%--                            <thead class="table-light">--%>
<%--                                <tr>--%>
<%--                                    <th>Order ID</th>--%>
<%--                                    <th>Customer</th>--%>
<%--                                    <th>Product</th>--%>
<%--                                    <th>Amount</th>--%>
<%--                                    <th>Status</th>--%>
<%--                                    <th>Date</th>--%>
<%--                                    <th>Action</th>--%>
<%--                                </tr>--%>
<%--                            </thead>--%>
<%--                            <tbody>--%>
<%--                                <tr>--%>
<%--                                    <td>#ORD-001</td>--%>
<%--                                    <td>John Smith</td>--%>
<%--                                    <td>Laptop Pro</td>--%>
<%--                                    <td>$1,299.00</td>--%>
<%--                                    <td><span class="badge bg-success">Completed</span></td>--%>
<%--                                    <td>2025-11-10</td>--%>
<%--                                    <td>--%>
<%--                                        <button class="btn btn-sm btn-outline-primary">View</button>--%>
<%--                                    </td>--%>
<%--                                </tr>--%>
<%--                                <tr>--%>
<%--                                    <td>#ORD-002</td>--%>
<%--                                    <td>Jane Doe</td>--%>
<%--                                    <td>Wireless Mouse</td>--%>
<%--                                    <td>$49.99</td>--%>
<%--                                    <td><span class="badge bg-warning">Pending</span></td>--%>
<%--                                    <td>2025-11-10</td>--%>
<%--                                    <td>--%>
<%--                                        <button class="btn btn-sm btn-outline-primary">View</button>--%>
<%--                                    </td>--%>
<%--                                </tr>--%>
<%--                                <tr>--%>
<%--                                    <td>#ORD-003</td>--%>
<%--                                    <td>Bob Johnson</td>--%>
<%--                                    <td>Mechanical Keyboard</td>--%>
<%--                                    <td>$159.00</td>--%>
<%--                                    <td><span class="badge bg-info">Processing</span></td>--%>
<%--                                    <td>2025-11-09</td>--%>
<%--                                    <td>--%>
<%--                                        <button class="btn btn-sm btn-outline-primary">View</button>--%>
<%--                                    </td>--%>
<%--                                </tr>--%>
<%--                                <tr>--%>
<%--                                    <td>#ORD-004</td>--%>
<%--                                    <td>Alice Brown</td>--%>
<%--                                    <td>USB-C Hub</td>--%>
<%--                                    <td>$79.99</td>--%>
<%--                                    <td><span class="badge bg-success">Completed</span></td>--%>
<%--                                    <td>2025-11-09</td>--%>
<%--                                    <td>--%>
<%--                                        <button class="btn btn-sm btn-outline-primary">View</button>--%>
<%--                                    </td>--%>
<%--                                </tr>--%>
<%--                                <tr>--%>
<%--                                    <td>#ORD-005</td>--%>
<%--                                    <td>Charlie Wilson</td>--%>
<%--                                    <td>Monitor 27"</td>--%>
<%--                                    <td>$399.00</td>--%>
<%--                                    <td><span class="badge bg-danger">Cancelled</span></td>--%>
<%--                                    <td>2025-11-08</td>--%>
<%--                                    <td>--%>
<%--                                        <button class="btn btn-sm btn-outline-primary">View</button>--%>
<%--                                    </td>--%>
<%--                                </tr>--%>
<%--                            </tbody>--%>
<%--                        </table>--%>
<%--                    </div>--%>
<%--                </div>--%>
<%--            </div>--%>
<%--        </div>--%>
<%--    </div>--%>

</div>

<script>
// Dashboard initialization
document.addEventListener('DOMContentLoaded', function() {
    // Initialize tooltips
    const tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
    tooltipTriggerList.map(function (tooltipTriggerEl) {
        return new bootstrap.Tooltip(tooltipTriggerEl);
    });

    // Initialize map and charts
    initDashboardMap();
    initUserGrowthChart();
    initActivityFeed();
});

// --- UTILITY: Relative Time Function ---
function formatTimeAgo(date) {
    const now = new Date();
    const seconds = Math.floor((now - new Date(date)) / 1000);
    let interval = seconds / 31536000;
    if (interval > 1) return Math.floor(interval) + "년 전";
    interval = seconds / 2592000;
    if (interval > 1) return Math.floor(interval) + "달 전";
    interval = seconds / 86400;
    if (interval > 1) return Math.floor(interval) + "일 전";
    interval = seconds / 3600;
    if (interval > 1) return Math.floor(interval) + "시간 전";
    interval = seconds / 60;
    if (interval > 1) return Math.floor(interval) + "분 전";
    return "방금 전";
}


// --- CHART: User Growth ---
function initUserGrowthChart() {
    const chartScript = document.querySelector('script[src*="chart.js"]');
    if (chartScript) {
        // If Chart.js is already loading or loaded, just run the fetch logic
        if (typeof Chart !== 'undefined') {
            fetchAndRenderUserChart();
        } else {
            chartScript.addEventListener('load', fetchAndRenderUserChart);
        }
    } else {
        // If Chart.js is not loaded, create the script tag
        const script = document.createElement('script');
        script.src = 'https://cdn.jsdelivr.net/npm/chart.js';
        script.onload = fetchAndRenderUserChart;
        document.head.appendChild(script);
    }
    
    function fetchAndRenderUserChart() {
        fetch('/api/dashboard/user-growth')
            .then(response => response.ok ? response.json() : Promise.reject('Failed to load user growth data'))
            .then(data => {
                data.sort((a, b) => new Date(a.date) - new Date(b.date));
                const dates = data.map(item => item.date);
                const counts = data.map(item => item.count);
                const ctx = document.getElementById('userGrowthChart').getContext('2d');
                const gradient = ctx.createLinearGradient(0, 0, 0, ctx.canvas.height);
                gradient.addColorStop(0, 'rgba(75, 192, 192, 0.4)');
                gradient.addColorStop(1, 'rgba(75, 192, 192, 0)');

                new Chart(ctx, {
                    type: 'line',
                    data: {
                        labels: dates,
                        datasets: [{
                            label: '일별 가입자 수',
                            data: counts,
                            borderColor: 'rgb(75, 192, 192)',
                            backgroundColor: gradient,
                            fill: true,
                            tension: 0.4
                        }]
                    },
                    options: {
                        responsive: true,
                        plugins: { legend: { display: false } },
                        scales: {
                            y: { beginAtZero: true, ticks: { stepSize: 1 }, title: { display: true, text: '가입자 수' }},
                            x: { title: { display: true, text: '날짜' }}
                        }
                    }
                });
            })
            .catch(error => console.error('Error fetching user growth data:', error));
    }
}

// --- FEED: Recent Activity ---
function initActivityFeed() {
    fetch('/api/dashboard/recent-activities')
        .then(response => response.ok ? response.json() : Promise.reject('Failed to load recent activities'))
        .then(data => {
            const feedContainer = document.querySelector('.activity-feed');
            if (!feedContainer) return;
            
            feedContainer.innerHTML = ''; // Clear static content

            if (data.length === 0) {
                feedContainer.innerHTML = '<p class="text-muted text-center">최근 활동이 없습니다.</p>';
                return;
            }

            data.forEach(item => {
                const itemHtml = `
                    <a href="\${item.link}" class="text-decoration-none text-body activity-link">
                        <div class="activity-item">
                            <div class="activity-icon \${item.bgClass} bg-opacity-10 text-primary">
                                <i class="bi \${item.iconClass}"></i>
                            </div>
                            <div class="activity-content">
                                <p class="mb-1">\${item.message}</p>
                                <small class="text-muted">\${formatTimeAgo(item.timestamp)}</small>
                            </div>
                        </div>
                    </a>
                `;
                feedContainer.insertAdjacentHTML('beforeend', itemHtml);
            });
        })
        .catch(error => {
            console.error('Error fetching recent activity:', error);
            const feedContainer = document.querySelector('.activity-feed');
            if(feedContainer) feedContainer.innerHTML = '<p class="text-danger text-center">활동 피드를 불러오는 데 실패했습니다.</p>';
        });
}

// --- MAP: Dashboard Map ---
function initDashboardMap() {
    const mapContainer = document.getElementById('dashboard-map');
    if (!mapContainer) return;

    function loadKakaoMap() {
        if (typeof kakao !== 'undefined' && kakao.maps && typeof kakao.maps.LatLng === 'function') {
            createMap();
            return;
        }
        const existingScript = document.querySelector('script[src*="dapi.kakao.com"]');
        if (existingScript) { return; }

        const script = document.createElement('script');
        script.type = 'text/javascript';
        script.src = '//dapi.kakao.com/v2/maps/sdk.js?appkey=${kakaoMapKey}&libraries=services&autoload=false';
        script.async = true;
        script.onload = () => {
            kakao.maps.load(createMap);
        };
        script.onerror = () => console.error('카카오맵 API 스크립트 로드 실패');
        document.head.appendChild(script);
    }

    function createMap() {
        if (typeof kakao === 'undefined' || !kakao.maps || typeof kakao.maps.LatLng !== 'function') return;
        const mapOption = { center: new kakao.maps.LatLng(37.5665, 126.9780), level: 5 };
        try {
            const map = new kakao.maps.Map(mapContainer, mapOption);
            const mapTypeControl = new kakao.maps.MapTypeControl();
            map.addControl(mapTypeControl, kakao.maps.ControlPosition.TOPRIGHT);
            const zoomControl = new kakao.maps.ZoomControl();
            map.addControl(zoomControl, kakao.maps.ControlPosition.RIGHT);
        } catch (error) {
            console.error('지도 초기화 오류:', error);
        }
    }
    loadKakaoMap();
}
</script>

