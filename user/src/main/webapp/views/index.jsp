<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Needy Care</title>
    <link rel="icon" type="image/png" href="/img/favicontitle.png">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.2/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/aos/2.3.4/aos.css" rel="stylesheet">
    <style>
        /* ---------------------------------------------------- */
        /* 1. 디자인 시스템 (공통 변수 재정의) */
        /* ---------------------------------------------------- */
        :root {
            --primary-color: #3498db;
            --secondary-color: #2c3e50;
            --accent-color: #e74c3c;
            --light-bg: #f8f9fa;
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        html, body {
            height: 100%;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            color: #333;
            overflow-x: hidden;
            display: flex;
            flex-direction: column;
        }

        /* ---------------------------------------------------- */
        /* 2. Header & Navbar */
        /* ---------------------------------------------------- */
        header {
            background: #fff;
            box-shadow: 0 2px 15px rgba(0,0,0,0.1);
            position: fixed;
            width: 100%;
            top: 0;
            z-index: 1000;
            transition: all 0.3s;
        }

        .navbar {
            padding: 15px 0;
        }

        .navbar .container {
            display: flex;
            justify-content: space-between;
            align-items: center;
            max-width: 100%;
            padding: 0 30px;
            position: relative;
        }

        /* 왼쪽: 로고 */
        .navbar-brand {
            font-size: 28px;
            font-weight: 800; /* 두께 강조 */
            color: var(--primary-color) !important;
            text-decoration: none;
            order: 1;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .navbar-brand img {
            width: 32px;
            height: 32px;
            object-fit: contain;
            transition: all 0.3s ease;
        }

        .navbar-brand:hover img {
            transform: rotate(360deg) scale(1.2);
        }

        /* 중앙: 메뉴 */
        .navbar-nav {
            display: flex;
            align-items: center;
            gap: 30px;
            list-style: none;
            margin: 0;
            padding: 0;
            position: absolute;
            left: 50%;
            transform: translateX(-50%);
        }

        .nav-item {
            margin: 0;
        }

        .nav-link {
            color: var(--secondary-color) !important;
            font-weight: 600; /* 두께 강조 */
            transition: color 0.3s;
            text-decoration: none;
            white-space: nowrap;
        }

        .nav-link:hover {
            color: var(--primary-color) !important;
        }

        /* 오른쪽: 로그인 버튼 */
        .btn-login-nav {
            background: var(--primary-color);
            color: white;
            padding: 10px 25px; /* 크기 조정 */
            border-radius: 50px;
            /* 둥근 버튼 통일 */
            text-decoration: none;
            font-weight: 600;
            font-size: 15px;
            transition: all 0.3s;
            order: 3;
            box-shadow: none;
        }

        .btn-login-nav:hover {
            background: #2980b9;
            /* 호버 색상 변경 */
            color: white;
            transform: translateY(-2px);
            box-shadow: none;
        }

        /* ---------------------------------------------------- */
        /* 3. Hero Section (수정됨: 텍스트, 버튼, 이미지 크기 확대) */
        /* ---------------------------------------------------- */
        #hero {
            background: linear-gradient(135deg, var(--primary-color) 0%, #2c3e50 100%);
            /* 패딩을 줄이고 Flexbox로 중앙 정렬 */
            padding: 0;
            color: white;
            position: relative;
            overflow: hidden;

            /* [변경] 화면 꽉 차게 설정 */
            min-height: 100vh;
            display: flex;
            align-items: center;
        }

        #hero::before {
            /* SVG 웨이브 패턴 유지 */
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1440 320"><path fill="rgba(255,255,255,0.1)" d="M0,96L48,112C96,128,192,160,288,160C384,160,480,128,576,122.7C672,117,768,139,864,149.3C960,160,1056,160,1152,138.7C1248,117,1344,75,1392,53.3L1440,32L1440,320L1392,320C1344,320,1248,320,1152,320C1056,320,960,320,864,320C768,320,672,320,576,320C480,320,384,320,288,320C192,320,96,320,48,320L0,320Z"></path></svg>');
            background-size: cover;
            opacity: 0.3;
        }

        /* [수정] 메인 제목 크기 확대 */
        #hero h1 {
            font-size: 70px; /* 52px -> 70px */
            font-weight: 800; /* 두께 강조 */
            margin-bottom: 25px;
            line-height: 1.2;
        }

        /* [수정] 부제목 크기 확대 */
        #hero p {
            font-size: 26px; /* 20px -> 26px */
            margin-bottom: 45px;
            opacity: 0.9;
        }

        /* [수정] 이미지 크기 및 효과 */
        .hero-img-blend {
            max-width: 100%;
            height: auto;
            /* [수정] 이미지 자체를 1.2배 확대 */
            transform: scale(1.2);
            /* 이미지의 최대 크기를 제한 */
            max-width: 1500px;
            /* CSS Masking: 가장자리를 투명하게 처리 */
            -webkit-mask-image: radial-gradient(ellipse at center, black 50%, transparent 100%);
            mask-image: radial-gradient(ellipse at center, black 50%, transparent 100%);
            transition: transform 0.3s ease;
        }

        .hero-buttons {
            display: flex;
            gap: 20px; /* 버튼 사이 간격도 조금 늘림 */
            flex-wrap: wrap;
        }

        /* [수정] 가입하기 버튼 크기 확대 */
        .btn-hero {
            background: white;
            color: var(--primary-color);
            padding: 18px 50px; /* 14px 40px -> 18px 50px */
            font-size: 20px; /* 폰트 사이즈 추가 */
            border-radius: 50px;
            font-weight: 700;
            text-decoration: none;
            display: inline-block;
            transition: all 0.3s;
            box-shadow: none;
        }

        .btn-hero:hover {
            background: var(--accent-color);
            color: white;
            transform: translateY(-3px);
            box-shadow: none;
        }

        /* [수정] 로그인 버튼 크기 확대 */
        .btn-hero-secondary {
            background: transparent;
            color: white;
            border: 2px solid white;
            padding: 18px 50px; /* 14px 40px -> 18px 50px */
            font-size: 20px; /* 폰트 사이즈 추가 */
            border-radius: 50px;
            font-weight: 700;
            text-decoration: none;
            display: inline-block;
            transition: all 0.3s;
        }

        .btn-hero-secondary:hover {
            background: white;
            color: var(--primary-color);
            transform: translateY(-3px);
            box-shadow: none;
        }

        /* ---------------------------------------------------- */
        /* 4. 공통 섹션 스타일 (About, Services, Contact) */
        /* ---------------------------------------------------- */
        #about {
            padding: 100px 0;
            /* 패딩 조정 */
        }

        #services {
            background: var(--light-bg);
            padding: 100px 0; /* 패딩 조정 */
        }

        #team {
            background: var(--light-bg);
            padding: 100px 0;
        }

        #contact {
            padding: 100px 0;
            background: var(--light-bg);
            margin-bottom: 0;
        }

        .section-title {
            text-align: center;
            margin-bottom: 60px; /* 마진 증가 */
        }

        .section-title h2 {
            font-size: 38px;
            font-weight: 800; /* 두께 강조 */
            color: var(--secondary-color);
            margin-bottom: 15px;
        }

        .section-title p {
            color: #666;
            font-size: 16px;
        }

        /* ---------------------------------------------------- */
        /* 5. 서비스/팀/포트폴리오 카드 스타일 */
        /* ---------------------------------------------------- */
        .about-img {
            border-radius: 15px;
            /* 둥근 모서리 통일 */
            box-shadow: 0 10px 30px rgba(0,0,0,0.15);
            /* 그림자 강조 */
        }

        /* 서비스 박스 */
        .service-box {
            background: white;
            padding: 40px 30px;
            border-radius: 20px; /* 둥근 모서리 통일 */
            transition: all 0.3s;
            height: 100%;
            box-shadow: 0 10px 30px rgba(0,0,0,0.08); /* 그림자 강조 */
        }

        .service-box:hover {
            transform: translateY(-10px);
            box-shadow: 0 18px 40px rgba(0,0,0,0.15);
        }

        .service-box i {
            font-size: 52px;
            /* 아이콘 크기 강조 */
            color: var(--primary-color);
            margin-bottom: 20px;
        }

        .service-box h3 {
            font-size: 22px;
            font-weight: 700;
            margin-bottom: 15px;
        }

        /* 팀 멤버 */
        .team-member {
            background: white;
            border-radius: 20px;
            padding: 30px;
            text-align: center;
            transition: all 0.3s;
            height: 100%;
            /* 팀 카드가 서비스 박스와 높이를 맞추도록 */
            box-shadow: 0 10px 30px rgba(0,0,0,0.08);
        }

        .team-member:hover {
            transform: translateY(-10px);
            box-shadow: 0 18px 40px rgba(0,0,0,0.15);
        }

        /* ---------------------------------------------------- */
        /* 6. Contact 섹션 카드 스타일 */
        /* ---------------------------------------------------- */
        .contact-info-card {
            background: linear-gradient(135deg, #1e88e5 0%, #1565c0 100%);
            color: white;
            padding: 50px 40px;
            border-radius: 20px;
            box-shadow: 0 10px 40px rgba(0, 0, 0, 0.15);
            height: 100%;
        }

        .contact-form-card {
            background: white;
            padding: 50px 40px;
            border-radius: 20px;
            box-shadow: 0 10px 40px rgba(0, 0, 0, 0.1);
            height: 100%;
        }

        .contact-info-card h3 {
            font-size: 32px;
            font-weight: 700;
            margin-bottom: 15px;
        }

        .contact-info-card > p {
            font-size: 14px;
            margin-bottom: 40px;
            line-height: 1.6;
            opacity: 0.95;
        }

        .contact-detail {
            margin-bottom: 35px;
            display: flex;
            align-items: flex-start;
        }

        .contact-detail:last-child {
            margin-bottom: 0;
        }

        .contact-icon {
            width: 50px;
            height: 50px;
            background: rgba(255, 255, 255, 0.2);
            border-radius: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-right: 20px;
            flex-shrink: 0;
        }

        .contact-icon i {
            font-size: 22px;
            color: white;
        }

        .contact-text h4 {
            font-size: 20px;
            font-weight: 600;
            margin-bottom: 8px;
            color: white;
        }

        .contact-text p {
            margin: 0;
            font-size: 15px;
            line-height: 1.8;
            opacity: 0.95;
        }

        .contact-form-card h3 {
            font-size: 32px;
            font-weight: 700;
            margin-bottom: 15px;
            color: var(--secondary-color);
        }

        .contact-form-card > p {
            color: #666;
            font-size: 14px;
            margin-bottom: 35px;
            line-height: 1.6;
        }

        .form-control {
            border: 1px solid #e0e0e0;
            border-radius: 12px; /* 입력창 모서리 통일 */
            padding: 14px 18px;
            margin-bottom: 20px;
            font-size: 15px;
            transition: all 0.3s;
        }

        .btn-submit {
            background: var(--primary-color);
            color: white;
            padding: 14px 45px;
            border: none;
            border-radius: 50px; /* 둥근 버튼 통일 */
            font-size: 16px;
            font-weight: 700;
            transition: all 0.3s;
            cursor: pointer;
            box-shadow: none;
        }

        .btn-submit:hover {
            background: #1565c0;
            transform: translateY(-2px);
            box-shadow: none;
        }

        /* ---------------------------------------------------- */
        /* 7. Footer */
        /* ---------------------------------------------------- */
        footer {
            background: var(--secondary-color);
            color: white;
            padding: 40px 0 20px;
            text-align: center;
            flex-shrink: 0;
            margin-top: auto;
        }

        .footer-social a {
            color: white;
            margin: 0 15px;
            font-size: 24px;
            transition: color 0.3s;
        }

        .footer-social a:hover {
            color: var(--primary-color);
        }

        /* 모바일 햄버거 메뉴 버튼 */
        .mobile-menu-toggle {
            display: none;
            background: none;
            border: none;
            font-size: 24px;
            color: var(--primary-color);
            cursor: pointer;
            padding: 8px;
            order: 0;
            z-index: 1001;
        }

        /* 모바일 메뉴 패널 */
        .mobile-menu-overlay {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0, 0, 0, 0.5);
            z-index: 999;
            opacity: 0;
            transition: opacity 0.3s ease;
        }

        .mobile-menu-overlay.active {
            display: block;
            opacity: 1;
        }

        .mobile-menu-panel {
            position: fixed;
            top: 0;
            left: -100%;
            width: 280px;
            max-width: 85%;
            height: 100%;
            background: white;
            z-index: 1000;
            transition: left 0.3s ease;
            box-shadow: 2px 0 10px rgba(0, 0, 0, 0.1);
            overflow-y: auto;
        }

        .mobile-menu-panel.active {
            left: 0;
        }

        .mobile-menu-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 20px;
            border-bottom: 1px solid #e0e0e0;
            background: var(--primary-color);
            color: white;
        }

        .mobile-menu-close {
            background: none;
            border: none;
            color: white;
            font-size: 24px;
            cursor: pointer;
            padding: 5px;
            transition: transform 0.3s;
        }

        .mobile-menu-close:hover {
            transform: rotate(90deg);
        }

        .mobile-menu-nav {
            padding: 0;
        }

        .mobile-menu-list {
            list-style: none;
            margin: 0;
            padding: 0;
        }

        .mobile-menu-list > li {
            border-bottom: 1px solid #f0f0f0;
        }

        .mobile-menu-list > li > a {
            display: block;
            padding: 16px 20px;
            color: var(--secondary-color);
            text-decoration: none;
            font-size: 16px;
            font-weight: 500;
            transition: all 0.3s;
        }

        .mobile-menu-list > li > a:hover {
            background: #f8f9fa;
            color: var(--primary-color);
            padding-left: 25px;
        }

        /* 모바일 반응형 스타일 */
        @media (max-width: 768px) {
            /* 헤더 조정 */
            .navbar .container {
                padding: 0 15px;
            }

            /* 모바일에서 햄버거 버튼 표시 */
            .mobile-menu-toggle {
                display: block;
            }

            /* 모바일에서 네비게이션과 로그인 버튼 숨기기 */
            .navbar-nav,
            .btn-login-nav {
                display: none !important;
            }

            /* 로고 크기 조정 */
            .navbar-brand {
                font-size: 20px;
                flex: 1;
                justify-content: center;
            }

            .navbar-brand img {
                width: 28px;
                height: 28px;
            }

            /* Hero 섹션 조정 (모바일) */
            #hero {
                /* 모바일에서는 패딩을 줘서 100vh가 부담스럽지 않게 조정하거나 유지 */
                padding: 100px 0 60px;
                display: block; /* 모바일에서는 플렉스 해제하고 블록으로 */
                min-height: auto;
                /* 높이 강제 해제 (컨텐츠 양에 따름) */
            }

            #hero h1 {
                font-size: 42px; /* 모바일에서도 크게 */
                margin-bottom: 15px;
            }

            #hero p {
                font-size: 18px;
                margin-bottom: 25px;
            }

            .hero-buttons {
                flex-direction: column;
                gap: 15px;
            }

            .btn-hero,
            .btn-hero-secondary {
                width: 100%;
                text-align: center;
                padding: 15px 30px;
                font-size: 18px;
            }

            .hero-img-blend {
                transform: none; /* 모바일에서는 확대 효과 제거하거나 축소 */
                margin-top: 30px;
            }

            /* 섹션 패딩 조정 */
            #about,
            #services,
            #team,
            #contact {
                padding: 60px 0;
            }

            .section-title {
                margin-bottom: 40px;
            }

            .section-title h2 {
                font-size: 28px;
            }

            .section-title p {
                font-size: 14px;
            }

            /* 서비스 박스 조정 */
            .service-box {
                padding: 30px 20px;
                margin-bottom: 20px;
            }

            .service-box i {
                font-size: 40px;
            }

            .service-box h3 {
                font-size: 20px;
            }

            /* 팀 멤버 조정 */
            .team-member {
                padding: 25px 20px;
                margin-bottom: 20px;
            }

            /* Contact 카드 조정 */
            .contact-info-card,
            .contact-form-card {
                padding: 30px 20px;
                margin-bottom: 20px;
            }

            .contact-info-card h3,
            .contact-form-card h3 {
                font-size: 24px;
            }

            .contact-detail {
                margin-bottom: 25px;
            }

            .contact-icon {
                width: 40px;
                height: 40px;
                margin-right: 15px;
            }

            .contact-icon i {
                font-size: 18px;
            }

            .contact-text h4 {
                font-size: 18px;
            }

            .contact-text p {
                font-size: 14px;
            }

            /* 폼 조정 */
            .form-control {
                padding: 12px 15px;
                font-size: 14px;
            }

            .btn-submit {
                width: 100%;
                padding: 12px 30px;
            }

            /* Footer 조정 */
            footer {
                padding: 30px 0 15px;
            }

            .footer-social a {
                font-size: 20px;
                margin: 0 10px;
            }
        }

        /* 작은 모바일 (480px 이하) */
        @media (max-width: 480px) {
            #hero h1 {
                font-size: 32px;
            }

            #hero p {
                font-size: 16px;
            }

            .section-title h2 {
                font-size: 24px;
            }

            .service-box {
                padding: 25px 15px;
            }

            .service-box i {
                font-size: 35px;
            }

            .service-box h3 {
                font-size: 18px;
            }

            .contact-info-card,
            .contact-form-card {
                padding: 25px 15px;
            }

            .mobile-menu-panel {
                width: 260px;
            }
        }

        /* ---------------------------------------------------- */
        /* [추가/수정] 8. 플로팅 다운 버튼 (크기 확대) */
        /* ---------------------------------------------------- */
        .floating-down-btn {
            position: fixed;
            bottom: 40px; /* 바닥에서 조금 더 위로 */
            right: 40px;
            /* 우측에서 조금 더 안으로 */
            /* [수정] 크기 대폭 확대 */
            width: 70px;
            height: 70px;
            font-size: 28px; /* 아이콘 크기 확대 */

            background: var(--primary-color);
            color: white;
            border: none;
            border-radius: 50%;
            box-shadow: 0 4px 15px rgba(0,0,0,0.3);
            z-index: 1000;
            cursor: pointer;
            display: flex;
            justify-content: center;
            align-items: center;
            transition: all 0.3s ease;
            opacity: 1;
            animation: floatBounce 2s infinite;
        }

        .floating-down-btn:hover {
            background: var(--accent-color);
            transform: translateY(-5px) scale(1.1); /* 호버 시 약간 커지는 효과 추가 */
            color: white;
        }

        /* 바닥에 도착했을 때 숨기기 위한 클래스 */
        .floating-down-btn.hidden {
            opacity: 0;
            pointer-events: none;
            transform: translateY(20px);
        }

        /* 둥실거리는 효과 애니메이션 */
        @keyframes floatBounce {
            0%, 20%, 50%, 80%, 100% {transform: translateY(0);}
            40% {transform: translateY(-10px);}
            60% {transform: translateY(-5px);}
        }

        /* 모바일에서는 버튼 위치와 크기 조정 */
        @media (max-width: 768px) {
            .floating-down-btn {
                bottom: 20px;
                right: 20px;
                width: 55px; /* 모바일에서도 기존보다 크게 */
                height: 55px;
                font-size: 22px;
            }
        }

    </style>
</head>
<body>
<header>
    <nav class="navbar navbar-expand-lg">
        <div class="container">
            <button class="mobile-menu-toggle" id="mobileMenuToggle" aria-label="메뉴 열기">
                <i class="fas fa-bars"></i>
            </button>

            <a class="navbar-brand" href="/">
                <img src="/img/favicontitle.png" alt="Aventro Logo">
                AI 돌봄 시스템
            </a>

            <%--            <ul class="navbar-nav">--%>
            <%--                <li class="nav-item"><a class="nav-link" href="#hero">홈</a></li>--%>
            <%--                <li class="nav-item"><a class="nav-link" href="#about">소개</a></li>--%>
            <%--                <li class="nav-item"><a class="nav-link" href="#services">주요 서비스</a></li>--%>
            <%--                <li class="nav-item"><a class="nav-link" href="#team">팀</a></li>--%>
            <%--                <li class="nav-item"><a class="nav-link" href="#contact">Contact</a></li>--%>
            <%--            </ul>--%>

            <a href="/login" class="btn-login-nav">로그인</a>
        </div>
    </nav>
</header>

<div class="mobile-menu-overlay" id="mobileMenuOverlay"></div>
<div class="mobile-menu-panel" id="mobileMenuPanel">
    <div class="mobile-menu-header">
        <div>
            <strong>메뉴</strong>
        </div>
        <button class="mobile-menu-close" id="mobileMenuClose" aria-label="메뉴 닫기">
            <i class="fas fa-times"></i>
        </button>
    </div>
    <nav class="mobile-menu-nav">
        <ul class="mobile-menu-list">
            <li><a href="#hero">Home</a></li>
            <li><a href="#about">About</a></li>
            <li><a href="#services">Services</a></li>
            <li><a href="#team">Team</a></li>
            <%--            <li><a href="#contact">Contact</a></li>--%>
            <li style="border-top: 2px solid #e0e0e0;
margin-top: 10px;">
                <a href="/login" style="color: var(--primary-color);
font-weight: 600;">로그인</a>
            </li>
        </ul>
    </nav>
</div>

<main>
    <section id="hero">
        <div class="container">
            <div class="row align-items-center">
                <div class="col-lg-6" data-aos="fade-right">
                    <h1>AI 돌봄 시스템</h1>
                    <p>케어가 필요하신 분들에게 희망을 안겨드립니다</p>
                    <div class="hero-buttons">
                        <a href="/register" class="btn-hero">가입하기</a>
                        <a href="/login" class="btn-hero-secondary">로그인</a>
                    </div>
                </div>
                <div class="col-lg-6 text-center" data-aos="fade-left">
                    <img src="/img/sp2.png" class="hero-img-blend" alt="Hero">
                </div>
            </div>
        </div>
    </section>

    <section id="about">
        <div class="container">
            <div class="section-title" data-aos="fade-up">
                <h2>소개</h2>
                <p>저희의 서비스를 소개합니다</p>
            </div>
            <div class="row align-items-center">
                <div class="col-lg-6" data-aos="fade-right">
                    <img src="/img/sinear.jpg" class="img-fluid about-img" alt="About">
                </div>
                <div class="col-lg-6" data-aos="fade-left">
                    <h3>도움이 필요하신 분들에게 즐거움을 Have Enjoy~</h3>
                    <p>AI를 활용해 도움이 필요하신 분들에게 최상의 기능을 제공해드립니다</p>
                    <ul>
                        <li><i class="fas fa-check-circle text-primary"></i> AI가 직접 날씨와 코스를 분석해서 추천해주는 산책경로 추천 시스템</li>
                        <li><i class="fas fa-check-circle text-primary"></i> AI가 직접 노약자분들의 건강 상태에 따른 최적의 식단 추천 시스템</li>
                        <li><i class="fas fa-check-circle text-primary"></i> AI가 실시간으로 화면을 분석해 낙상,이상행동 등의 위기신호 감지 시스템</li>
                    </ul>
                </div>
            </div>
        </div>
    </section>

    <section id="services">
        <div class="container">
            <div class="section-title" data-aos="fade-up">
                <h2>서비스</h2>
                <p>저희의 서비스를 한번 탐색해보세요</p>
            </div>
            <div class="row">
                <div class="col-lg-4 col-md-6 mb-4" data-aos="fade-up" data-aos-delay="100">
                    <div class="service-box">
                        <i class="fas fa-laptop-code"></i>
                        <h3>산책 추천 시스템</h3>
                        <p>AI가 날씨와 사용자 컨디션을 분석하여 최적의 산책 코스를 제안합니다.
                            매일 새롭고 안전한 길을 따라 건강한 생활을 즐겨보세요.</p>
                    </div>
                </div>
                <div class="col-lg-4 col-md-6 mb-4" data-aos="fade-up" data-aos-delay="200">
                    <div class="service-box">
                        <i class="fas fa-mobile-alt"></i>
                        <h3>식단 추천 시스템</h3>
                        <p>사용자의 건강 데이터와 병력, 알레르기 정보를 기반으로 맞춤형 식단을 추천합니다.
                            균형 잡힌 영양으로 건강을 체계적으로 관리하세요.</p>
                    </div>
                </div>
                <div class="col-lg-4 col-md-6 mb-4" data-aos="fade-up" data-aos-delay="300">
                    <div class="service-box">
                        <i class="fas fa-paint-brush"></i>
                        <h3>실시간 노약자 모니터링 시스템</h3>
                        <p>집안에 설치된 카메라가 사용자의 낙상, 이상 행동 등 위기 상황을 실시간으로 감지합니다.
                            응급 상황 발생 시 보호자에게 즉시 알려 빠른 조치를 돕습니다.</p>
                    </div>
                </div>
                <div class="col-lg-4 col-md-6 mb-4" data-aos="fade-up" data-aos-delay="100">
                    <div class="service-box">
                        <i class="fas fa-chart-line"></i>
                        <h3>AI를 통한 요양사 추천 시스템</h3>
                        <p>사용자의 필요와 선호도에 가장 적합한 요양사를 AI가 매칭해 드립니다.
                            신뢰할 수 있는 전문가와 함께 편안한 돌봄을 경험하세요.</p>
                    </div>
                </div>
                <div class="col-lg-4 col-md-6 mb-4" data-aos="fade-up" data-aos-delay="200">
                    <div class="service-box">
                        <i class="fas fa-camera"></i>
                        <h3>AI챗봇 시스템</h3>
                        <p>24시간 언제든지 궁금한 점을 물어보고 답변을 받을 수 있는 AI 챗봇입니다.
                            돌봄 서비스 정보부터 일상적인 대화까지, 똑똑한 비서가 되어드립니다.</p>
                    </div>
                </div>
                <div class="col-lg-4 col-md-6 mb-4" data-aos="fade-up" data-aos-delay="300">
                    <div class="service-box">
                        <i class="fas fa-bullhorn"></i>
                        <h3>AI 건강진단서 분석 시스템</h3>
                        <p>복잡한 건강진단서 내용을 AI가 쉽게 분석하고 요약해 드립니다.
                            내 건강 상태를 한눈에 파악하고 체계적으로 관리하세요.</p>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <%--    <section id="team">--%>
    <%--        <div class="container">--%>
    <%--            <div class="section-title" data-aos="fade-up">--%>
    <%--                <h2>Team</h2>--%>
    <%--                <p>저희와 함께하는 팀원들을 소개합니다.</p>--%>
    <%--            </div>--%>
    <%--            <div class="row">--%>
    <%--                <div class="col-lg-3 col-md-6 mb-4 text-center" data-aos="fade-up" data-aos-delay="100">--%>
    <%--                    <div class="team-member">--%>
    <%--                        <i class="fas fa-users" style="font-size: 50px; color: #ccc;"></i>--%>
    <%--                        <h4 style="margin-top: 15px;">팀 멤버 1</h4>--%>
    <%--                        <span class="d-block mb-3">Placeholder</span>--%>
    <%--                        <p style="font-size: 14px; color: #666; margin-top: 10px;">준비 중</p>--%>
    <%--                    </div>--%>
    <%--                </div>--%>
    <%--                <div class="col-lg-3 col-md-6 mb-4 text-center" data-aos="fade-up" data-aos-delay="200">--%>
    <%--                    <div class="team-member">--%>
    <%--                        <i class="fas fa-users" style="font-size: 50px;
color: #ccc;"></i>--%>
    <%--                        <h4 style="margin-top: 15px;">팀 멤버 2</h4>--%>
    <%--                        <span class="d-block mb-3">Placeholder</span>--%>
    <%--                        <p style="font-size: 14px;
color: #666; margin-top: 10px;">준비 중</p>--%>
    <%--                    </div>--%>
    <%--                </div>--%>
    <%--                <div class="col-lg-3 col-md-6 mb-4 text-center" data-aos="fade-up" data-aos-delay="300">--%>
    <%--                    <div class="team-member">--%>
    <%--                        <i class="fas fa-users" style="font-size: 50px;
color: #ccc;"></i>--%>
    <%--                        <h4 style="margin-top: 15px;">팀 멤버 3</h4>--%>
    <%--                        <span class="d-block mb-3">Placeholder</span>--%>
    <%--                        <p style="font-size: 14px;
color: #666; margin-top: 10px;">준비 중</p>--%>
    <%--                    </div>--%>
    <%--                </div>--%>
    <%--                <div class="col-lg-3 col-md-6 mb-4 text-center" data-aos="fade-up" data-aos-delay="400">--%>
    <%--                    <div class="team-member">--%>
    <%--                        <i class="fas fa-users" style="font-size: 50px;
color: #ccc;"></i>--%>
    <%--                        <h4 style="margin-top: 15px;">팀 멤버 4</h4>--%>
    <%--                        <span class="d-block mb-3">Placeholder</span>--%>
    <%--                        <p style="font-size: 14px;
color: #666; margin-top: 10px;">준비 중</p>--%>
    <%--                    </div>--%>
    <%--                </div>--%>
    <%--            </div>--%>
    <%--        </div>--%>
    <%--    </section>--%>

    <%--    <section id="contact">--%>
    <%--        <div class="container">--%>
    <%--            <div class="section-title" data-aos="fade-up">--%>
    <%--                <h2>Contact</h2>--%>
    <%--                <p>Necessitatibus eius consequatur ex aliquid fuga eum quidem sint consectetur velit</p>--%>
    <%--            </div>--%>
    <%--            <div class="row">--%>
    <%--                <div class="col-lg-5 mb-4" data-aos="fade-right">--%>
    <%--                    <div class="contact-info-card">--%>
    <%--                        <h3>Contact Info</h3>--%>
    <%--                        <p>Praesent sapien massa, convallis a pellentesque nec, egestas non nisi.--%>
    <%--                            Vestibulum ante ipsum primis.</p>--%>

    <%--                        <div class="contact-detail">--%>
    <%--                            <div class="contact-icon">--%>
    <%--                                <i class="fas fa-map-marker-alt"></i>--%>
    <%--                            </div>--%>
    <%--                            <div class="contact-text">--%>
    <%--                                <h4>Our Location</h4>--%>
    <%--                                <p>비체크리스탈 6동 301호<br>충남 아산시 탕정면 탕정면로
119-4</p>--%>
    <%--                            </div>--%>
    <%--                        </div>--%>

    <%--                        <div class="contact-detail">--%>
    <%--                            <div class="contact-icon">--%>
    <%--                                <i class="fas fa-phone"></i>--%>
    <%--                            </div>--%>
    <%--                            <div class="contact-text">--%>
    <%--                                <h4>Phone Number</h4>--%>
    <%--                                <p>+82 10-8920-3471<br>+82
10-5734-7072</p>--%>
    <%--                            </div>--%>
    <%--                        </div>--%>

    <%--                        <div class="contact-detail">--%>
    <%--                            <div class="contact-icon">--%>
    <%--                                <i class="fas fa-envelope"></i>--%>
    <%--                            </div>--%>
    <%--                            <div class="contact-text">--%>
    <%--                                <h4>Email Address</h4>--%>
    <%--                                <p>rnalsdn100@gmail.com<br>shinchagyoung@gmail.com</p>--%>
    <%--                            </div>--%>
    <%--                        </div>--%>
    <%--                    </div>--%>
    <%--                </div>--%>

    <%--                <div class="col-lg-7 mb-4" data-aos="fade-left">--%>
    <%--                    <div class="contact-form-card">--%>
    <%--                        <h3>Get In Touch</h3>--%>
    <%--                        <p>Praesent sapien massa, convallis a pellentesque nec, egestas non nisl.--%>
    <%--                            Vestibulum ante ipsum primis.</p>--%>

    <%--                        <form>--%>
    <%--                            <div class="row">--%>
    <%--                                <div class="col-md-6">--%>
    <%--                                    <input type="text" class="form-control" placeholder="Your Name" required>--%>
    <%--                                </div>--%>
    <%--                                <div class="col-md-6">--%>
    <%--                                    <input type="email" class="form-control" placeholder="Your Email" required>--%>
    <%--                                </div>--%>
    <%--                            </div>--%>
    <%--                            <input type="text" class="form-control" placeholder="Subject" required>--%>
    <%--                            <textarea class="form-control" placeholder="Message" required></textarea>--%>
    <%--                            <div class="text-center">--%>
    <%--                                <button type="submit" class="btn-submit">Send Message</button>--%>
    <%--                            </div>--%>
    <%--                        </form>--%>
    <%--                    </div>--%>
    <%--                </div>--%>
    <%--            </div>--%>
    <%--        </div>--%>
    <%--    </section>--%>
</main>

<footer>
    <div class="container">
        <div class="footer-social mb-3">
            <a href="#"><i class="fab fa-twitter"></i></a>
            <a href="#"><i class="fab fa-facebook"></i></a>
            <a href="#"><i class="fab fa-instagram"></i></a>
            <a href="#"><i class="fab fa-linkedin"></i></a>
        </div>
        <p>AI가 함께하여 더욱 안심되는 돌봄 서비스.</p>
    </div>
</footer>

<button id="scrollDownBtn" class="floating-down-btn" aria-label="다음 섹션으로 이동">
    <i class="fas fa-arrow-down"></i>
</button>

<script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.2/js/bootstrap.bundle.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/aos/2.3.4/aos.js"></script>
<script>
    // Initialize AOS
    AOS.init({
        duration: 1000,
        once: true
    });
    // Smooth scrolling
    document.querySelectorAll('a[href^="#"]').forEach(anchor => {
        anchor.addEventListener('click', function (e) {
            // '가입하기' 버튼은 #이 아닌 /register로 이동해야 하므로, #이 붙은 링크만 스크롤을 적용
            if (this.getAttribute('href') !== '/register') {
                e.preventDefault();
                const target = document.querySelector(this.getAttribute('href'));
                if (target) {
                    target.scrollIntoView({
                        behavior: 'smooth',
                        block: 'start'
                    });
                }
            }
        });
    });
    // Navbar scroll effect
    window.addEventListener('scroll', function() {
        const header = document.querySelector('header');
        if (window.scrollY > 100) {
            header.style.padding = '10px 0';
            header.style.boxShadow = '0 4px 20px rgba(0,0,0,0.15)';
        } else {
            header.style.padding = '15px 0';
            header.style.boxShadow = '0 2px 15px rgba(0,0,0,0.1)';
        }
    });
    // 모바일 메뉴 토글 기능
    document.addEventListener('DOMContentLoaded', function() {
        const mobileMenuToggle = document.getElementById('mobileMenuToggle');
        const mobileMenuClose = document.getElementById('mobileMenuClose');
        const mobileMenuPanel = document.getElementById('mobileMenuPanel');
        const mobileMenuOverlay = document.getElementById('mobileMenuOverlay');
        const mobileMenuLinks = document.querySelectorAll('.mobile-menu-list a');

        if (mobileMenuToggle && mobileMenuPanel) {
            // 햄버거 버튼 클릭 시 메뉴 열기
            mobileMenuToggle.addEventListener('click', function() {
                mobileMenuPanel.classList.add('active');
                mobileMenuOverlay.classList.add('active');
                document.body.style.overflow = 'hidden';
            });

            // 닫기 버튼 클릭 시 메뉴 닫기
            if (mobileMenuClose) {
                mobileMenuClose.addEventListener('click', function() {
                    closeMobileMenu();
                });
            }

            // 오버레이 클릭 시 메뉴 닫기
            mobileMenuOverlay.addEventListener('click', function() {
                closeMobileMenu();
            });
            // 모바일 메뉴 링크 클릭 시 메뉴 닫기 및 스크롤
            mobileMenuLinks.forEach(link => {
                link.addEventListener('click', function(e) {
                    const href = this.getAttribute('href');
                    if (href && href.startsWith('#')) {
                        e.preventDefault();
                        closeMobileMenu();
                        setTimeout(function() {
                            const target = document.querySelector(href);
                            if (target) {
                                target.scrollIntoView({
                                    behavior: 'smooth',
                                    block: 'start'
                                });
                            }
                        }, 300);
                    } else {
                        closeMobileMenu();
                    }
                });
            });
        }

        function closeMobileMenu() {
            mobileMenuPanel.classList.remove('active');
            mobileMenuOverlay.classList.remove('active');
            document.body.style.overflow = '';
        }
    });

    // ----------------------------------------------------
    // [수정됨] 플로팅 다운 버튼 로직 (순차적 섹션 이동)
    // ----------------------------------------------------
    const scrollDownBtn = document.getElementById('scrollDownBtn');
    if (scrollDownBtn) {
        // 이동할 섹션들의 순서 정의
        // [참고] 여기있는 ID가 실제 태그에 있어야 합니다.
        // 현재 코드에는 hero, about, services가 있고 마지막은 footer로 이동하게 합니다.
        const sectionIds = ['hero', 'about', 'services'];
        // 1. 버튼 클릭 시 다음 섹션으로 이동
        scrollDownBtn.addEventListener('click', function() {
            const currentScroll = window.scrollY;
            const headerHeight = 80; // 헤더 높이만큼 보정 (제목이 가려지지 않게)
            let nextSection = null;

            // 섹션들을 순회하며 현재 스크롤보다 아래에 있는 첫 번째 섹션을 찾음
            // 1) 주요 섹션 확인
            for (let id of sectionIds) {
                const section = document.getElementById(id);
                if (section) {
                    // (현재 스크롤 위치 + 여유분) 보다 섹션의 시작점이 더 크면 그곳이 다음 목적지
                    if (section.offsetTop > currentScroll + 50) {
                        nextSection = section;
                        break;
                    }
                }
            }

            // 2) 만약 다음 섹션을 못 찾았다면 (마지막 서비스 섹션까지 지났다면), Footer로 이동
            if (!nextSection) {
                const footer = document.querySelector('footer');
                if (footer && footer.offsetTop > currentScroll + 50) {
                    nextSection = footer;
                }
            }

            // 3) 이동 실행
            if (nextSection) {
                const targetPosition = nextSection.offsetTop - headerHeight;
                window.scrollTo({
                    top: targetPosition > 0 ? targetPosition : 0,
                    behavior: 'smooth'
                });
            } else {
                // 더 이상 갈 곳이 없으면(이미 바닥이면) 그냥 맨 끝으로
                window.scrollTo({
                    top: document.body.scrollHeight,
                    behavior: 'smooth'
                });
            }
        });
        // 2. 스크롤 위치에 따른 버튼 숨김 처리 (바닥에 닿으면 숨김)
        window.addEventListener('scroll', function() {
            // 문서 바닥에 거의 도달했을 때
            if ((window.innerHeight + window.scrollY) >= document.body.offsetHeight - 50) {
                scrollDownBtn.classList.add('hidden');
            } else {
                scrollDownBtn.classList.remove('hidden');
            }
        });
    }
</script>
</body>
</html>