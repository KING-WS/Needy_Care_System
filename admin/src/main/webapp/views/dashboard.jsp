<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

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
                            <h6 class="mb-0 text-muted">고객수</h6>
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
                            <h6 class="mb-0 text-muted">노약자수</h6>
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
                            <h6 class="mb-0 text-muted">요양사수</h6>
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
                    <h5 class="card-title mb-0">알림 관리</h5>
                </div>
                <div class="card-body">
                    <div class="activity-feed">
                        <div class="activity-item">
                            <div class="activity-icon bg-primary bg-opacity-10 text-primary">
                                <i class="bi bi-person-plus"></i>
                            </div>
                            <div class="activity-content">
                                <p class="mb-1">New user registered</p>
                                <small class="text-muted">2 minutes ago</small>
                            </div>
                        </div>
                        <div class="activity-item">
                            <div class="activity-icon bg-success bg-opacity-10 text-success">
                                <i class="bi bi-bag-check"></i>
                            </div>
                            <div class="activity-content">
                                <p class="mb-1">Order #1234 completed</p>
                                <small class="text-muted">5 minutes ago</small>
                            </div>
                        </div>
                        <div class="activity-item">
                            <div class="activity-icon bg-warning bg-opacity-10 text-warning">
                                <i class="bi bi-exclamation-triangle"></i>
                            </div>
                            <div class="activity-content">
                                <p class="mb-1">Server maintenance scheduled</p>
                                <small class="text-muted">1 hour ago</small>
                            </div>
                        </div>
                        <div class="activity-item">
                            <div class="activity-icon bg-danger bg-opacity-10 text-danger">
                                <i class="bi bi-x-circle"></i>
                            </div>
                            <div class="activity-content">
                                <p class="mb-1">Payment failed for order #4321</p>
                                <small class="text-muted">3 hours ago</small>
                            </div>
                        </div>
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
                    <h5 class="card-title mb-0">User Growth (Last 7 Days)</h5>
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
    <div class="row g-4">
        <div class="col-12">
            <div class="card">
                <div class="card-header">
                    <h5 class="card-title mb-0">Recent Orders</h5>
                </div>
                <div class="card-body">
                    <div class="table-responsive">
                        <table class="table table-hover mb-0">
                            <thead class="table-light">
                                <tr>
                                    <th>Order ID</th>
                                    <th>Customer</th>
                                    <th>Product</th>
                                    <th>Amount</th>
                                    <th>Status</th>
                                    <th>Date</th>
                                    <th>Action</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td>#ORD-001</td>
                                    <td>John Smith</td>
                                    <td>Laptop Pro</td>
                                    <td>$1,299.00</td>
                                    <td><span class="badge bg-success">Completed</span></td>
                                    <td>2025-11-10</td>
                                    <td>
                                        <button class="btn btn-sm btn-outline-primary">View</button>
                                    </td>
                                </tr>
                                <tr>
                                    <td>#ORD-002</td>
                                    <td>Jane Doe</td>
                                    <td>Wireless Mouse</td>
                                    <td>$49.99</td>
                                    <td><span class="badge bg-warning">Pending</span></td>
                                    <td>2025-11-10</td>
                                    <td>
                                        <button class="btn btn-sm btn-outline-primary">View</button>
                                    </td>
                                </tr>
                                <tr>
                                    <td>#ORD-003</td>
                                    <td>Bob Johnson</td>
                                    <td>Mechanical Keyboard</td>
                                    <td>$159.00</td>
                                    <td><span class="badge bg-info">Processing</span></td>
                                    <td>2025-11-09</td>
                                    <td>
                                        <button class="btn btn-sm btn-outline-primary">View</button>
                                    </td>
                                </tr>
                                <tr>
                                    <td>#ORD-004</td>
                                    <td>Alice Brown</td>
                                    <td>USB-C Hub</td>
                                    <td>$79.99</td>
                                    <td><span class="badge bg-success">Completed</span></td>
                                    <td>2025-11-09</td>
                                    <td>
                                        <button class="btn btn-sm btn-outline-primary">View</button>
                                    </td>
                                </tr>
                                <tr>
                                    <td>#ORD-005</td>
                                    <td>Charlie Wilson</td>
                                    <td>Monitor 27"</td>
                                    <td>$399.00</td>
                                    <td><span class="badge bg-danger">Cancelled</span></td>
                                    <td>2025-11-08</td>
                                    <td>
                                        <button class="btn btn-sm btn-outline-primary">View</button>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>

</div>

<script>
// Dashboard initialization
document.addEventListener('DOMContentLoaded', function() {
    // Initialize tooltips
    const tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
    tooltipTriggerList.map(function (tooltipTriggerEl) {
        return new bootstrap.Tooltip(tooltipTriggerEl);
    });
    
    // Initialize map
    initDashboardMap();
});

// Dashboard Map initialization
function initDashboardMap() {
    const mapContainer = document.getElementById('dashboard-map');
    
    if (!mapContainer) {
        console.error('지도 컨테이너를 찾을 수 없습니다.');
        return;
    }

    // 카카오맵 API 로드 함수
    function loadKakaoMap() {
        // 이미 로드되어 있으면 바로 초기화
        if (typeof kakao !== 'undefined' && kakao.maps && typeof kakao.maps.LatLng === 'function') {
            console.log('카카오맵 API 이미 로드됨');
            createMap();
            return;
        }

        // 이미 스크립트가 추가되었는지 확인
        const existingScript = document.querySelector('script[src*="dapi.kakao.com"]');
        if (existingScript) {
            console.log('카카오맵 스크립트 이미 존재, 로드 대기 중...');
            const checkInterval = setInterval(function() {
                if (typeof kakao !== 'undefined' && kakao.maps && typeof kakao.maps.LatLng === 'function') {
                    clearInterval(checkInterval);
                    createMap();
                }
            }, 100);
            
            setTimeout(function() {
                clearInterval(checkInterval);
                if (typeof kakao === 'undefined' || !kakao.maps || typeof kakao.maps.LatLng !== 'function') {
                    console.error('카카오맵 API 로드 타임아웃');
                }
            }, 10000);
            return;
        }

        console.log('카카오맵 API 스크립트 동적 로드 시작');
        
        // 카카오맵 API 스크립트 동적 로드
        const script = document.createElement('script');
        script.type = 'text/javascript';
        script.src = '//dapi.kakao.com/v2/maps/sdk.js?appkey=${kakaoMapKey}&libraries=services&autoload=false';
        script.async = true;
        
        script.onload = function() {
            console.log('카카오맵 API 스크립트 로드 완료');
            if (typeof kakao !== 'undefined' && kakao.maps && kakao.maps.load) {
                kakao.maps.load(function() {
                    console.log('카카오맵 API 완전히 로드됨');
                    if (typeof kakao.maps.LatLng === 'function') {
                        createMap();
                    } else {
                        console.error('카카오맵 API 초기화 실패 - LatLng 생성자 없음');
                    }
                });
            } else {
                setTimeout(function() {
                    if (typeof kakao !== 'undefined' && kakao.maps && typeof kakao.maps.LatLng === 'function') {
                        createMap();
                    } else {
                        const retryInterval = setInterval(function() {
                            if (typeof kakao !== 'undefined' && kakao.maps && typeof kakao.maps.LatLng === 'function') {
                                clearInterval(retryInterval);
                                createMap();
                            }
                        }, 50);
                        
                        setTimeout(function() {
                            clearInterval(retryInterval);
                            if (typeof kakao.maps.LatLng !== 'function') {
                                console.error('카카오맵 API 초기화 실패');
                            }
                        }, 5000);
                    }
                }, 500);
            }
        };
        
        script.onerror = function() {
            console.error('카카오맵 API 스크립트 로드 실패');
        };
        
        document.head.appendChild(script);
    }

    // 지도 생성 함수
    function createMap() {
        if (typeof kakao === 'undefined' || !kakao.maps || typeof kakao.maps.LatLng !== 'function') {
            console.error('카카오맵 API가 아직 준비되지 않았습니다.');
            return;
        }

        console.log('대시보드 지도 초기화 시작...');
        
        const mapOption = {
            center: new kakao.maps.LatLng(37.5665, 126.9780), // 서울시청 좌표
            level: 5
        };

        try {
            const map = new kakao.maps.Map(mapContainer, mapOption);
            
            // 지도 타입 컨트롤 추가
            const mapTypeControl = new kakao.maps.MapTypeControl();
            map.addControl(mapTypeControl, kakao.maps.ControlPosition.TOPRIGHT);

            // 줌 컨트롤 추가
            const zoomControl = new kakao.maps.ZoomControl();
            map.addControl(zoomControl, kakao.maps.ControlPosition.RIGHT);

            // 기본 마커 추가
            const markerPosition = new kakao.maps.LatLng(37.5665, 126.9780);
            const marker = new kakao.maps.Marker({
                position: markerPosition,
                map: map
            });

            // 인포윈도우 생성
            const infowindow = new kakao.maps.InfoWindow({
                content: '<div style="padding:5px;font-size:12px;">서울시청</div>'
            });

            // 마커 클릭 이벤트
            kakao.maps.event.addListener(marker, 'click', function() {
                infowindow.open(map, marker);
            });
            
            console.log('대시보드 지도 초기화 완료');
        } catch (error) {
            console.error('지도 초기화 오류:', error);
        }
    }

    // 지도 로드 시작
    loadKakaoMap();
}
</script>

