<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="ko" data-bs-theme="light">
<head>
    <!-- Theme 초기화 (깜빡임 방지) -->
    <script>
        // 페이지 로드 전 테마 즉시 적용
        (function() {
            const savedTheme = localStorage.getItem('theme') || 'light';
            document.documentElement.setAttribute('data-bs-theme', savedTheme);
        })();
    </script>
    
    <!-- Meta Tags -->
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="Modern Bootstrap 5 Admin Template - Clean, responsive dashboard">
    <meta name="keywords" content="bootstrap, admin, dashboard, template, modern, responsive">
    <meta name="author" content="Bootstrap Admin Template">
    
    <!-- Favicon -->
    <link rel="icon" type="image/svg+xml" href="<c:url value='/assets/icons/favicon.svg'/>">
    <link rel="icon" type="image/png" href="<c:url value='/assets/icons/favicon.png'/>">
    
    <!-- Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    
    <!-- Bootstrap Icons -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    
    <!-- Main CSS -->
    <link href="<c:url value='/css/main.css'/>" rel="stylesheet">
    
    <!-- Title -->
    <title>Metis - Modern Bootstrap Admin</title>
    
    <!-- Theme Color -->
    <meta name="theme-color" content="#6366f1">
</head>

<body data-page="${empty center ? 'dashboard' : center}" class="admin-layout">
    <!-- Loading Screen -->
    <div id="loading-screen" class="loading-screen">
        <div class="loading-spinner">
            <div class="spinner-border text-primary" role="status">
                <span class="visually-hidden">Loading...</span>
            </div>
        </div>
    </div>

    <!-- Main Wrapper -->
    <div class="admin-wrapper" id="admin-wrapper">
        
        <!-- Header -->
        <header class="admin-header">
            <nav class="navbar navbar-expand-lg navbar-light bg-white border-bottom">
                <div class="container-fluid">
                    <!-- Logo/Brand -->
                    <a class="navbar-brand d-flex align-items-center" href="<c:url value='/'/>">
                        <img src="<c:url value='/assets/images/logo.svg'/>" alt="Logo" height="32" class="d-inline-block align-text-top me-2">
                        <h1 class="h4 mb-0 fw-bold text-primary">Metis</h1>
                    </a>

                    <!-- Search Bar -->
                    <div class="search-container flex-grow-1 mx-4">
                        <div class="position-relative">
                            <input type="search" 
                                   class="form-control" 
                                   placeholder="Search... (Ctrl+K)"
                                   aria-label="Search">
                            <i class="bi bi-search position-absolute top-50 end-0 translate-middle-y me-3"></i>
                        </div>
                    </div>

                    <!-- Right Side Icons -->
                    <div class="navbar-nav flex-row">
                        <!-- Theme Toggle -->
                        <button class="btn btn-outline-secondary me-2" 
                                type="button" 
                                onclick="toggleTheme()"
                                data-bs-toggle="tooltip"
                                data-bs-placement="bottom"
                                title="Toggle theme">
                            <i class="bi bi-sun-fill" id="theme-icon"></i>
                        </button>

                        <!-- Fullscreen Toggle -->
                        <button class="btn btn-outline-secondary me-2" 
                                type="button" 
                                onclick="toggleFullscreen()"
                                data-bs-toggle="tooltip"
                                data-bs-placement="bottom"
                                title="Toggle fullscreen">
                            <i class="bi bi-arrows-fullscreen icon-hover"></i>
                        </button>

                        <!-- Notifications -->
                        <div class="dropdown me-2">
                            <button class="btn btn-outline-secondary position-relative" 
                                    type="button" 
                                    data-bs-toggle="dropdown" 
                                    aria-expanded="false">
                                <i class="bi bi-bell"></i>
                                <span class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger">
                                    3
                                </span>
                            </button>
                            <ul class="dropdown-menu dropdown-menu-end">
                                <li><h6 class="dropdown-header">Notifications</h6></li>
                                <li><a class="dropdown-item" href="#">New user registered</a></li>
                                <li><a class="dropdown-item" href="#">Server status update</a></li>
                                <li><a class="dropdown-item" href="#">New message received</a></li>
                                <li><hr class="dropdown-divider"></li>
                                <li><a class="dropdown-item text-center" href="#">View all notifications</a></li>
                            </ul>
                        </div>

                        <!-- User Menu -->
                        <div class="dropdown">
                            <button class="btn btn-outline-secondary d-flex align-items-center" 
                                    type="button" 
                                    data-bs-toggle="dropdown" 
                                    aria-expanded="false">
                                <img src="<c:url value='/assets/images/avatar-placeholder.svg'/>" 
                                     alt="User Avatar" 
                                     width="24" 
                                     height="24" 
                                     class="rounded-circle me-2">
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

        <!-- Sidebar -->
        <aside class="admin-sidebar" id="admin-sidebar">
            <div class="sidebar-content">
                <nav class="sidebar-nav">
                    <ul class="nav flex-column">
                        <!-- Dashboard -->
                        <li class="nav-item">
                            <a class="nav-link ${empty center ? 'active' : ''}" href="<c:url value='/'/>">
                                <i class="bi bi-grid-1x2"></i>
                                <span>Dashboard</span>
                            </a>
                        </li>
                        
                        <!-- Web Socket (Collapsible Menu) -->
                        <li class="nav-item">
                            <a class="nav-link collapsed" 
                               data-bs-toggle="collapse" 
                               href="#websocketSubmenu" 
                               role="button" 
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
                        
                        <!-- Q&A -->
                        <li class="nav-item">
                            <a class="nav-link ${center == 'qna' ? 'active' : ''}" href="<c:url value='/qna'/>">
                                <i class="bi bi-question-circle"></i>
                                <span>Q&A</span>
                            </a>
                        </li>
                        
                        <!-- chart -->
                        <li class="nav-item">
                            <a class="nav-link ${center == 'chart' ? 'active' : ''}" href="<c:url value='/chart'/>">
                                <i class="bi bi-bar-chart-line"></i>
                                <span>chart</span>
                            </a>
                        </li>
                        
                        <!-- ADMIN MENU 헤딩 -->
                        <li class="nav-item mt-4">
                            <small class="text-muted px-3 text-uppercase fw-bold">ADMIN MENU</small>
                        </li>
                        
                        <!-- 고객 (서브메뉴 있음) -->
                        <li class="nav-item">
                            <a class="nav-link collapsed" 
                               data-bs-toggle="collapse" 
                               href="#customerSubmenu" 
                               role="button" 
                               aria-expanded="false" 
                               aria-controls="customerSubmenu">
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
                        
                        <!-- 노약자 (서브메뉴 있음) -->
                        <li class="nav-item">
                            <a class="nav-link collapsed" 
                               data-bs-toggle="collapse" 
                               href="#seniorSubmenu" 
                               role="button" 
                               aria-expanded="false" 
                               aria-controls="seniorSubmenu">
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
                        
                        <!-- 요양사 (서브메뉴 있음) -->
                        <li class="nav-item">
                            <a class="nav-link collapsed" 
                               data-bs-toggle="collapse" 
                               href="#caregiverSubmenu" 
                               role="button" 
                               aria-expanded="false" 
                               aria-controls="caregiverSubmenu">
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

        <!-- Floating Hamburger Menu -->
        <button class="hamburger-menu" 
                type="button" 
                data-sidebar-toggle
                aria-label="Toggle sidebar">
            <i class="bi bi-list"></i>
        </button>

        <!-- Main Content -->
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

        <!-- Footer -->
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
    </div> <!-- /.admin-wrapper -->

    <!-- Toast Container -->
    <div aria-live="polite" aria-atomic="true" class="position-fixed top-0 end-0 p-3" style="z-index: 11">
        <div id="toast-container"></div>
    </div>

    <!-- Scripts -->
    <script src="<c:url value='/js/main.js'/>" type="module"></script>
    
    <!-- 서브메뉴 화살표 애니메이션 스타일 -->
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

      // Initialize theme from localStorage
      document.addEventListener('DOMContentLoaded', () => {
        // localStorage에서 저장된 테마 불러오기 (없으면 light 기본값)
        const savedTheme = localStorage.getItem('theme') || 'light';
        document.documentElement.setAttribute('data-bs-theme', savedTheme);
        const icon = document.getElementById('theme-icon');
        
        // 아이콘을 저장된 테마에 맞게 설정
        if (savedTheme === 'dark') {
          icon.classList.remove('bi-sun-fill');
          icon.classList.add('bi-moon-fill');
        } else {
          icon.classList.remove('bi-moon-fill');
          icon.classList.add('bi-sun-fill');
        }

        // Sidebar toggle
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

        // Hide loading screen
        setTimeout(() => {
          document.getElementById('loading-screen').style.display = 'none';
        }, 500);
      });
    </script>
</body>
</html>

