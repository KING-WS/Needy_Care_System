<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="ko" data-bs-theme="light">
<head>
    <script>
        // 페이지 로드 전 테마 즉시 적용
        (function() {
            const savedTheme = localStorage.getItem('theme') || 'light';
            document.documentElement.setAttribute('data-bs-theme', savedTheme);
        })();
    </script>

    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="Modern Bootstrap 5 Admin Template - Clean, responsive dashboard">
    <meta name="keywords" content="bootstrap, admin, dashboard, template, modern, responsive">
    <meta name="author" content="Bootstrap Admin Template">

    <link rel="icon" type="image/svg+xml" href="<c:url value='/assets/icons/favicon.svg'/>">
    <link rel="icon" type="image/png" href="<c:url value='/assets/icons/favicon.png'/>">

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">

    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">

    <link href="<c:url value='/css/main.css'/>" rel="stylesheet">

    <title>Metis - Modern Bootstrap Admin</title>

    <meta name="theme-color" content="#6366f1">

    <style>
        .submenu-arrow {
            transition: transform 0.3s ease;
            font-size: 0.75rem;
        }
        .nav-link[aria-expanded="true"] .submenu-arrow {
            transform: rotate(90deg);
        }
        .collapse .nav-link {
            font-size: 0.9rem;
            padding-left: 1rem;
        }
        .collapse .nav-link:hover {
            background-color: rgba(var(--bs-primary-rgb), 0.1);
        }
    </style>
</head>

<body data-page="${empty center ? 'dashboard' : center}" class="admin-layout">
<div id="loading-screen" class="loading-screen">
    <div class="loading-spinner">
        <div class="spinner-border text-primary" role="status">
            <span class="visually-hidden">Loading...</span>
        </div>
    </div>
</div>

<div class="admin-wrapper" id="admin-wrapper">

    <header class="admin-header">
        <nav class="navbar navbar-expand-lg navbar-light bg-white border-bottom">
            <div class="container-fluid">
                <a class="navbar-brand d-flex align-items-center" href="<c:url value='/'/>">
                    <img src="<c:url value='/assets/images/logo.svg'/>" alt="Logo" height="32" class="d-inline-block align-text-top me-2">
                    <h1 class="h4 mb-0 fw-bold text-primary">Metis</h1>
                </a>

                <div class="search-container flex-grow-1 mx-4">
                    <div class="position-relative">
                        <input type="search" class="form-control" placeholder="Search... (Ctrl+K)" aria-label="Search">
                        <i class="bi bi-search position-absolute top-50 end-0 translate-middle-y me-3"></i>
                    </div>
                </div>

                <div class="navbar-nav flex-row">
                    <button class="btn btn-outline-secondary me-2" type="button" onclick="toggleTheme()" data-bs-toggle="tooltip" data-bs-placement="bottom" title="Toggle theme">
                        <i class="bi bi-sun-fill" id="theme-icon"></i>
                    </button>

                    <button class="btn btn-outline-secondary me-2" type="button" onclick="toggleFullscreen()" data-bs-toggle="tooltip" data-bs-placement="bottom" title="Toggle fullscreen">
                        <i class="bi bi-arrows-fullscreen icon-hover"></i>
                    </button>

                    <div class="dropdown me-2">
                        <button class="btn btn-outline-secondary position-relative" type="button" data-bs-toggle="dropdown" aria-expanded="false">
                            <i class="bi bi-bell"></i>
                            <span class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger d-none">0</span>
                        </button>
                        <ul class="dropdown-menu dropdown-menu-end">
                            <li><h6 class="dropdown-header">Notifications</h6></li>
                            <li><a class="dropdown-item" href="<c:url value='/admin/alerts'/>">알림 전체 보기</a></li>
                        </ul>
                    </div>

                    <div class="dropdown">
                        <button class="btn btn-outline-secondary d-flex align-items-center" type="button" data-bs-toggle="dropdown" aria-expanded="false">
                            <img src="<c:url value='/assets/images/avatar-placeholder.svg'/>" alt="User Avatar" width="24" height="24" class="rounded-circle me-2">
                            <span class="d-none d-md-inline">John Doe</span>
                            <i class="bi bi-chevron-down ms-1"></i>
                        </button>
                        <ul class="dropdown-menu dropdown-menu-end">
                            <li><a class="dropdown-item" href="<c:url value='/profile'/>"><i class="bi bi-person me-2"></i>Profile</a></li>
                            <li><a class="dropdown-item" href="<c:url value='/settings'/>"><i class="bi bi-gear me-2"></i>Settings</a></li>
                            <li><hr class="dropdown-divider"></li>
                            <li><a class="dropdown-item" href="#"><i class="bi bi-box-arrow-right me-2"></i>Logout</a></li>
                        </ul>
                    </div>
                </div>
            </div>
        </nav>
    </header>

    <aside class="admin-sidebar" id="admin-sidebar">
        <div class="sidebar-content">
            <nav class="sidebar-nav">
                <ul class="nav flex-column">
                    <li class="nav-item">
                        <a class="nav-link ${empty center ? 'active' : ''}" href="<c:url value='/'/>">
                            <i class="bi bi-grid-1x2"></i>
                            <span>Dashboard</span>
                        </a>
                    </li>

                    <li class="nav-item">
                        <a class="nav-link collapsed" data-bs-toggle="collapse" href="#websocketSubmenu" role="button"
                           aria-expanded="${center == 'websocket' || center == 'websocket/video' ? 'true' : 'false'}"
                           aria-controls="websocketSubmenu">
                            <i class="bi bi-wifi"></i>
                            <span>Web Socket</span>
                            <i class="bi bi-chevron-right ms-auto submenu-arrow"></i>
                        </a>
                        <div class="collapse ${center == 'websocket' || center == 'websocket/video' ? 'show' : ''}" id="websocketSubmenu">
                            <ul class="nav flex-column ms-3">
                                <li class="nav-item">
                                    <a class="nav-link ${center == 'websocket' ? 'active' : ''}" href="<c:url value='/websocket'/>">
                                        <i class="bi bi-chat-dots"></i>
                                        <span>Web Socket Chat</span>
                                    </a>
                                </li>
                                <li class="nav-item">
                                    <a class="nav-link ${center == 'websocket/video' ? 'active' : ''}" href="<c:url value='/websocket/video'/>">
                                        <i class="bi bi-camera-video"></i>
                                        <span>화상 통화</span>
                                    </a>
                                </li>
                            </ul>
                        </div>
                    </li>

                    <li class="nav-item">
                        <a class="nav-link ${center == 'qna' ? 'active' : ''}" href="<c:url value='/qna'/>">
                            <i class="bi bi-question-circle"></i>
                            <span>Q&A</span>
                        </a>
                    </li>

                    <li class="nav-item">
                        <a class="nav-link ${center == 'chart' ? 'active' : ''}" href="<c:url value='/chart'/>">
                            <i class="bi bi-bar-chart-line"></i>
                            <span>chart</span>
                        </a>
                    </li>

                    <li class="nav-item">
                        <a class="nav-link ${center == 'admin/alerts' ? 'active' : ''}" href="<c:url value='/admin/alerts'/>">
                            <i class="bi bi-bell"></i>
                            <span>알림 관리</span>
                        </a>
                    </li>

                    <li class="nav-item">
                        <a class="nav-link ${center == 'map/map' ? 'active' : ''}" href="<c:url value='/map'/>">
                            <i class="bi bi-geo-alt"></i>
                            <span>지도</span>
                        </a>
                    </li>

                    <li class="nav-item mt-4">
                        <small class="text-muted px-3 text-uppercase fw-bold">ADMIN MENU</small>
                    </li>

                    <li class="nav-item">
                        <a class="nav-link collapsed" data-bs-toggle="collapse" href="#customerSubmenu" role="button" aria-expanded="false" aria-controls="customerSubmenu">
                            <i class="bi bi-people"></i>
                            <span>고객</span>
                            <i class="bi bi-chevron-right ms-auto submenu-arrow"></i>
                        </a>
                        <div class="collapse" id="customerSubmenu">
                            <ul class="nav flex-column ms-3">
                                <li class="nav-item">
                                    <a class="nav-link ${center == 'customer-list' ? 'active' : ''}" href="<c:url value='/customer/list'/>">
                                        <i class="bi bi-list"></i>
                                        <span>고객 목록</span>
                                    </a>
                                </li>
                                <li class="nav-item">
                                    <a class="nav-link ${center == 'customer-add' ? 'active' : ''}" href="<c:url value='/customer/add'/>">
                                        <i class="bi bi-person-plus"></i>
                                        <span>고객 등록</span>
                                    </a>
                                </li>
                                <li class="nav-item">
                                    <a class="nav-link ${center == 'customer-search' ? 'active' : ''}" href="<c:url value='/customer/search'/>">
                                        <i class="bi bi-search"></i>
                                        <span>고객 검색</span>
                                    </a>
                                </li>
                            </ul>
                        </div>
                    </li>

                    <li class="nav-item">
                        <a class="nav-link collapsed" data-bs-toggle="collapse" href="#seniorSubmenu" role="button" aria-expanded="false" aria-controls="seniorSubmenu">
                            <i class="bi bi-person-wheelchair"></i>
                            <span>노약자</span>
                            <i class="bi bi-chevron-right ms-auto submenu-arrow"></i>
                        </a>
                        <div class="collapse" id="seniorSubmenu">
                            <ul class="nav flex-column ms-3">
                                <li class="nav-item">
                                    <a class="nav-link ${center == 'senior-list' ? 'active' : ''}" href="<c:url value='/senior/list'/>">
                                        <i class="bi bi-list"></i>
                                        <span>노약자 목록</span>
                                    </a>
                                </li>
                                <li class="nav-item">
                                    <a class="nav-link ${center == 'senior-add' ? 'active' : ''}" href="<c:url value='/senior/add'/>">
                                        <i class="bi bi-person-plus"></i>
                                        <span>노약자 등록</span>
                                    </a>
                                </li>
                                <li class="nav-item">
                                    <a class="nav-link ${center == 'senior-care' ? 'active' : ''}" href="<c:url value='/senior/care'/>">
                                        <i class="bi bi-heart-pulse"></i>
                                        <span>케어 관리</span>
                                    </a>
                                </li>
                            </ul>
                        </div>
                    </li>

                    <li class="nav-item">
                        <a class="nav-link collapsed" data-bs-toggle="collapse" href="#caregiverSubmenu" role="button" aria-expanded="false" aria-controls="caregiverSubmenu">
                            <i class="bi bi-hospital"></i>
                            <span>요양사</span>
                            <i class="bi bi-chevron-right ms-auto submenu-arrow"></i>
                        </a>
                        <div class="collapse" id="caregiverSubmenu">
                            <ul class="nav flex-column ms-3">
                                <li class="nav-item">
                                    <a class="nav-link ${center == 'caregiver-list' ? 'active' : ''}" href="<c:url value='/caregiver/list'/>">
                                        <i class="bi bi-people"></i>
                                        <span>요양사 목록</span>
                                    </a>
                                </li>
                                <li class="nav-item">
                                    <a class="nav-link ${center == 'caregiver-add' ? 'active' : ''}" href="<c:url value='/caregiver/add'/>">
                                        <i class="bi bi-person-plus-fill"></i>
                                        <span>요양사 등록</span>
                                    </a>
                                </li>
                                <li class="nav-item">
                                    <a class="nav-link ${center == 'caregiver-manage' ? 'active' : ''}" href="<c:url value='/caregiver/manage'/>">
                                        <i class="bi bi-gear"></i>
                                        <span>요양사 관리</span>
                                    </a>
                                </li>
                            </ul>
                        </div>
                    </li>
                </ul>
            </nav>
        </div>
    </aside>

    <button class="hamburger-menu" type="button" data-sidebar-toggle aria-label="Toggle sidebar">
        <i class="bi bi-list"></i>
    </button>

    <main class="admin-main">
        <c:choose>
            <c:when test="${center == null}">
                <jsp:include page="dashboard.jsp"></jsp:include>
            </c:when>
            <c:otherwise>
                <jsp:include page="${center}.jsp"></jsp:include>
            </c:otherwise>
        </c:choose>
    </main>

    <footer class="admin-footer">
        <div class="container-fluid">
            <div class="row">
                <div class="col-md-6">
                    <p class="mb-0 text-muted">© 2025 Modern Bootstrap Admin Template</p>
                </div>
                <div class="col-md-6 text-md-end">
                    <p class="mb-0 text-muted">Built with Bootstrap 5.3</p>
                </div>
            </div>
        </div>
    </footer>
</div> <div aria-live="polite" aria-atomic="true" class="position-fixed top-0 end-0 p-3" style="z-index: 1055">
    <div id="toast-container"></div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/sockjs-client/1.6.1/sockjs.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/stomp.js/2.3.3/stomp.min.js"></script>

<script src="<c:url value='/js/main.js'/>" type="module"></script>

<script>
    // Toggle Theme
    function toggleTheme() {
        const html = document.documentElement;
        const icon = document.getElementById('theme-icon');
        const currentTheme = html.getAttribute('data-bs-theme');

        if (currentTheme === 'light') {
            html.setAttribute('data-bs-theme', 'dark');
            icon.classList.remove('bi-sun-fill');
            icon.classList.add('bi-moon-fill');
            localStorage.setItem('theme', 'dark');
        } else {
            html.setAttribute('data-bs-theme', 'light');
            icon.classList.remove('bi-moon-fill');
            icon.classList.add('bi-sun-fill');
            localStorage.setItem('theme', 'light');
        }
    }

    // Toggle Fullscreen
    function toggleFullscreen() {
        if (!document.fullscreenElement) {
            document.documentElement.requestFullscreen();
        } else {
            document.exitFullscreen();
        }
    }

    // Initialize theme and sidebar
    document.addEventListener('DOMContentLoaded', () => {
        const savedTheme = localStorage.getItem('theme') || 'light';
        document.documentElement.setAttribute('data-bs-theme', savedTheme);
        const icon = document.getElementById('theme-icon');

        if (savedTheme === 'dark') {
            icon.classList.remove('bi-sun-fill');
            icon.classList.add('bi-moon-fill');
        } else {
            icon.classList.remove('bi-moon-fill');
            icon.classList.add('bi-sun-fill');
        }

        const toggleButton = document.querySelector('[data-sidebar-toggle]');
        const wrapper = document.getElementById('admin-wrapper');

        if (toggleButton && wrapper) {
            const isCollapsed = localStorage.getItem('sidebar-collapsed') === 'true';
            if (isCollapsed) {
                wrapper.classList.add('sidebar-collapsed');
                toggleButton.classList.add('is-active');
            }

            toggleButton.addEventListener('click', () => {
                const isCurrentlyCollapsed = wrapper.classList.contains('sidebar-collapsed');
                if (isCurrentlyCollapsed) {
                    wrapper.classList.remove('sidebar-collapsed');
                    toggleButton.classList.remove('is-active');
                    localStorage.setItem('sidebar-collapsed', 'false');
                } else {
                    wrapper.classList.add('sidebar-collapsed');
                    toggleButton.classList.add('is-active');
                    localStorage.setItem('sidebar-collapsed', 'true');
                }
            });
        }

        setTimeout(() => {
            document.getElementById('loading-screen').style.display = 'none';
        }, 500);
    });
</script>

<script>
    document.addEventListener('DOMContentLoaded', function () {

        // [1] 알림 토스트 팝업을 띄우는 함수
        function showEmergencyToast(alertData) {
            const toastContainer = document.getElementById('toast-container');
            if (!toastContainer) return;

            const toastId = 'toast-' + Date.now();
            const timeStr = new Date(alertData.time).toLocaleTimeString();

            const isEmergency = alertData.type === 'EMERGENCY';
            const badgeClass = isEmergency ? 'bg-danger' : 'bg-info';
            const iconClass = isEmergency ? 'bi-exclamation-triangle-fill' : 'bi-telephone-fill';
            const title = isEmergency ? '긴급 호출' : '연락 요청';

            const toastHTML = `
                <div id="\${toastId}" class="toast" role="alert" aria-live="assertive" aria-atomic="true" data-bs-delay="10000">
                    <div class="toast-header \${badgeClass} text-white">
                        <i class="bi \${iconClass} me-2"></i>
                        <strong class="me-auto">\${title}</strong>
                        <small class="text-white-50">\${timeStr}</small>
                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="toast" aria-label="Close"></button>
                    </div>
                    <div class="toast-body">
                        <p class="mb-1"><strong>대상자:</strong> \${alertData.recName}</p>
                        <p class="mb-0">\${alertData.message}</p>
                        <div class="mt-2 pt-2 border-top">
                            <a href="<c:url value='/admin/alerts'/>" class="btn btn-sm btn-light w-100">확인하러 가기</a>
                        </div>
                    </div>
                </div>
                `;

            toastContainer.insertAdjacentHTML('beforeend', toastHTML);

            const toastElement = document.getElementById(toastId);

            // Bootstrap 객체 생성 (라이브러리 로드 확인)
            if (typeof bootstrap !== 'undefined') {
                const toast = new bootstrap.Toast(toastElement);
                toastElement.addEventListener('hidden.bs.toast', function () {
                    toastElement.remove();
                });
                toast.show();
            } else {
                console.error("Bootstrap JS not loaded");
                toastElement.classList.add('show'); // 강제 표시
            }
        }

        // [2] 웹소켓 연결 및 구독 함수
        function connectAndSubscribe() {
            // Controller에서 주소를 못 받았을 경우(GlobalControllerAdvice 미적용 시)를 대비한 하드코딩
            let kioskUrl = "${kioskServerUrl}";

            // 주소가 비어있으면 수동 주소 사용 (여기서 IP를 님의 User 서버 IP로 맞춤)
            if (!kioskUrl || kioskUrl === "") {
                kioskUrl = "https://192.168.1.12:8084";
                console.log("⚠️ Using fallback kiosk URL:", kioskUrl);
            } else {
                console.log("🔔 Global Notification Init - Target:", kioskUrl);
            }

            const socket = new SockJS(kioskUrl + '/adminchat');
            const stompClient = Stomp.over(socket);
            stompClient.debug = null; // 로그 끄기

            stompClient.connect({}, function (frame) {
                console.log('✅ Global WS Connected: ' + frame);

                stompClient.subscribe('/topic/alert', function (message) {
                    try {
                        const alertData = JSON.parse(message.body);
                        console.log('🚨 Real-time Alert:', alertData);

                        // 1. 토스트 팝업 띄우기
                        showEmergencyToast(alertData);

                        // 2. 상단 종(Bell) 아이콘 배지 숫자 증가
                        const badge = document.querySelector('.bi-bell + .badge');
                        if (badge) {
                            let count = parseInt(badge.innerText) || 0;
                            badge.innerText = count + 1;
                            badge.classList.remove('d-none');
                        }

                        // 3. 만약 현재 페이지가 '알림 관리(alerts.jsp)'라면 테이블에도 행 추가
                        if (typeof addAlertRow === 'function') {
                            addAlertRow(alertData);
                        }

                    } catch (e) {
                        console.error('Error parsing alert:', e);
                    }
                });
            }, function(error) {
                console.log('⚠️ Notification socket disconnected. Reconnecting in 5s...');
                setTimeout(connectAndSubscribe, 5000);
            });
        }

        // 실행
        connectAndSubscribe();
    });
</script>
</body>
</html>