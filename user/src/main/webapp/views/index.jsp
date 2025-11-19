<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Aventro - Business Bootstrap Template</title>
    <link rel="icon" type="image/png" href="/img/favicontitle.png">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.2/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/aos/2.3.4/aos.css" rel="stylesheet">
    <style>
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

        /* Header */
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
            font-weight: bold;
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
            font-weight: 500;
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
            padding: 8px 20px;
            border-radius: 20px;
            text-decoration: none;
            font-weight: 500;
            font-size: 14px;
            transition: all 0.3s;
            order: 3;
        }

        .btn-login-nav:hover {
            background: var(--secondary-color);
            color: white;
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(0,0,0,0.2);
        }

        /* 반응형 토글 숨김 */
        .navbar-toggler {
            display: none;
        }

        .navbar-collapse {
            display: flex !important;
            flex-basis: auto;
        }

        /* 사용 안 하는 스타일 (나중에 필요할 수 있음) */
        .user-info {
            display: flex;
            align-items: center;
            gap: 15px;
            margin-left: 20px;
        }

        .user-name {
            color: var(--primary-color);
            font-weight: 600;
            font-size: 16px;
        }

        .btn-logout {
            background: var(--accent-color);
            color: white;
            padding: 8px 20px;
            border-radius: 20px;
            text-decoration: none;
            font-weight: 500;
            font-size: 14px;
            transition: all 0.3s;
            border: none;
        }

        .btn-logout:hover {
            background: #c0392b;
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(0,0,0,0.2);
        }

        /* Hero Section */
        #hero {
            background: linear-gradient(135deg, var(--primary-color), var(--secondary-color));
            padding: 180px 0 100px;
            color: white;
            position: relative;
            overflow: hidden;
        }

        #hero::before {
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

        #hero h1 {
            font-size: 48px;
            font-weight: bold;
            margin-bottom: 20px;
        }

        #hero p {
            font-size: 20px;
            margin-bottom: 30px;
        }

        .hero-buttons {
            display: flex;
            gap: 15px;
            flex-wrap: wrap;
        }

        .btn-hero {
            background: white;
            color: var(--primary-color);
            padding: 12px 35px;
            border-radius: 50px;
            font-weight: 600;
            text-decoration: none;
            display: inline-block;
            transition: all 0.3s;
        }

        .btn-hero:hover {
            background: var(--accent-color);
            color: white;
            transform: translateY(-3px);
            box-shadow: 0 10px 20px rgba(0,0,0,0.2);
        }

        .btn-hero-secondary {
            background: transparent;
            color: white;
            border: 2px solid white;
            padding: 12px 35px;
            border-radius: 50px;
            font-weight: 600;
            text-decoration: none;
            display: inline-block;
            transition: all 0.3s;
        }

        .btn-hero-secondary:hover {
            background: white;
            color: var(--primary-color);
            transform: translateY(-3px);
            box-shadow: 0 10px 20px rgba(0,0,0,0.2);
        }

        /* About Section */
        #about {
            padding: 80px 0;
        }

        .section-title {
            text-align: center;
            margin-bottom: 50px;
        }

        .section-title h2 {
            font-size: 36px;
            font-weight: bold;
            color: var(--secondary-color);
            margin-bottom: 15px;
        }

        .section-title p {
            color: #666;
            font-size: 16px;
        }

        .about-img {
            border-radius: 10px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
        }

        /* Services Section */
        #services {
            background: var(--light-bg);
            padding: 80px 0;
        }

        .service-box {
            background: white;
            padding: 40px 30px;
            border-radius: 10px;
            transition: all 0.3s;
            height: 100%;
            box-shadow: 0 5px 15px rgba(0,0,0,0.08);
        }

        .service-box:hover {
            transform: translateY(-10px);
            box-shadow: 0 15px 30px rgba(0,0,0,0.15);
        }

        .service-box i {
            font-size: 48px;
            color: var(--primary-color);
            margin-bottom: 20px;
        }

        .service-box h3 {
            font-size: 22px;
            font-weight: 600;
            margin-bottom: 15px;
        }

        /* Portfolio Section */
        #portfolio {
            padding: 80px 0;
        }

        .portfolio-item {
            position: relative;
            overflow: hidden;
            border-radius: 10px;
            margin-bottom: 30px;
            cursor: pointer;
        }

        .portfolio-item img {
            width: 100%;
            height: 300px;
            object-fit: cover;
            transition: transform 0.3s;
        }

        .portfolio-item:hover img {
            transform: scale(1.1);
        }

        .portfolio-overlay {
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: rgba(52, 152, 219, 0.9);
            display: flex;
            align-items: center;
            justify-content: center;
            opacity: 0;
            transition: opacity 0.3s;
        }

        .portfolio-item:hover .portfolio-overlay {
            opacity: 1;
        }

        .portfolio-overlay h4 {
            color: white;
            font-size: 24px;
            font-weight: bold;
        }

        /* Team Section */
        #team {
            background: var(--light-bg);
            padding: 80px 0;
        }

        .team-member {
            background: white;
            border-radius: 10px;
            padding: 30px;
            text-align: center;
            transition: all 0.3s;
            box-shadow: 0 5px 15px rgba(0,0,0,0.08);
        }

        .team-member:hover {
            transform: translateY(-10px);
            box-shadow: 0 15px 30px rgba(0,0,0,0.15);
        }

        .team-member img {
            width: 120px;
            height: 120px;
            border-radius: 50%;
            margin-bottom: 20px;
            object-fit: cover;
        }

        .team-member h4 {
            font-size: 20px;
            font-weight: 600;
            margin-bottom: 5px;
        }

        .team-member span {
            color: #888;
            font-size: 14px;
        }

        .team-social {
            margin-top: 15px;
        }

        .team-social a {
            color: var(--primary-color);
            margin: 0 10px;
            font-size: 18px;
            transition: color 0.3s;
        }

        .team-social a:hover {
            color: var(--accent-color);
        }

        /* Contact Section */
        #contact {
            padding: 150px 0 150px 0;
            background: var(--light-bg);
            margin-bottom: 0;
        }

        .contact-info-card {
            background: linear-gradient(135deg, #1e88e5 0%, #1565c0 100%);
            color: white;
            padding: 50px 40px;
            border-radius: 20px;
            box-shadow: 0 10px 40px rgba(0, 0, 0, 0.15);
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

        .contact-form-card {
            background: white;
            padding: 50px 40px;
            border-radius: 20px;
            box-shadow: 0 10px 40px rgba(0, 0, 0, 0.1);
            height: 100%;
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
            border-radius: 10px;
            padding: 14px 18px;
            margin-bottom: 20px;
            font-size: 15px;
            transition: all 0.3s;
        }

        .form-control:focus {
            border-color: var(--primary-color);
            box-shadow: 0 0 0 3px rgba(30, 136, 229, 0.1);
            outline: none;
        }

        .form-control::placeholder {
            color: #999;
        }

        textarea.form-control {
            resize: vertical;
            min-height: 120px;
        }

        .btn-submit {
            background: var(--primary-color);
            color: white;
            padding: 14px 45px;
            border: none;
            border-radius: 50px;
            font-size: 16px;
            font-weight: 600;
            transition: all 0.3s;
            cursor: pointer;
        }

        .btn-submit:hover {
            background: #1565c0;
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(30, 136, 229, 0.4);
        }

        /* Main Content Wrapper */
        main {
            flex: 1;
        }

        /* Footer */
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

        /* Pricing Section */
        #pricing {
            padding: 80px 0 150px 0;
        }

        .pricing-card {
            background: white;
            border-radius: 20px;
            padding: 40px 30px;
            box-shadow: 0 10px 40px rgba(0, 0, 0, 0.1);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            position: relative;
            height: 100%;
            display: flex;
            flex-direction: column;
        }

        .pricing-card:hover {
            transform: translateY(-10px);
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.15);
        }

        .pricing-card.featured {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            transform: scale(1.05);
        }

        .pricing-card.featured:hover {
            transform: scale(1.05) translateY(-10px);
        }

        .popular-badge {
            position: absolute;
            top: -15px;
            left: 50%;
            transform: translateX(-50%);
            background: var(--primary-color);
            color: white;
            padding: 8px 20px;
            border-radius: 20px;
            font-size: 11px;
            font-weight: 700;
            letter-spacing: 0.5px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.2);
        }

        .pricing-header h3 {
            font-size: 28px;
            font-weight: 700;
            margin-bottom: 10px;
            color: var(--secondary-color);
        }

        .pricing-card.featured .pricing-header h3 {
            color: white;
        }

        .pricing-header .subtitle {
            color: #666;
            font-size: 14px;
            margin-bottom: 20px;
        }

        .pricing-card.featured .pricing-header .subtitle {
            color: rgba(255, 255, 255, 0.9);
        }

        .pricing-price {
            display: flex;
            align-items: baseline;
            margin-bottom: 5px;
        }

        .pricing-price .currency {
            font-size: 28px;
            font-weight: 700;
            color: var(--secondary-color);
        }

        .pricing-card.featured .pricing-price .currency {
            color: white;
        }

        .pricing-price .amount {
            font-size: 56px;
            font-weight: 700;
            line-height: 1;
            color: var(--secondary-color);
        }

        .pricing-card.featured .pricing-price .amount {
            color: white;
        }

        .pricing-price .period {
            font-size: 16px;
            color: #666;
            margin-left: 3px;
        }

        .pricing-card.featured .pricing-price .period {
            color: rgba(255, 255, 255, 0.9);
        }

        .billing-info {
            color: #888;
            font-size: 14px;
            margin-bottom: 25px;
        }

        .pricing-card.featured .billing-info {
            color: rgba(255, 255, 255, 0.85);
        }

        .custom-pricing {
            font-size: 32px;
            font-weight: 700;
            color: var(--secondary-color);
            margin-bottom: 5px;
        }

        .custom-subtitle {
            color: #666;
            font-size: 14px;
        }

        .pricing-features {
            list-style: none;
            margin-bottom: 30px;
            flex-grow: 1;
        }

        .pricing-features li {
            padding: 12px 0;
            display: flex;
            align-items: center;
            border-bottom: 1px solid #f0f0f0;
            color: #555;
        }

        .pricing-card.featured .pricing-features li {
            border-bottom: 1px solid rgba(255, 255, 255, 0.2);
            color: white;
        }

        .pricing-features li:last-child {
            border-bottom: none;
        }

        .pricing-features li i {
            color: var(--primary-color);
            margin-right: 10px;
            font-size: 16px;
        }

        .pricing-card.featured .pricing-features li i {
            color: white;
        }

        .btn-pricing {
            width: 100%;
            padding: 16px;
            border: 2px solid var(--primary-color);
            background: var(--primary-color);
            color: white;
            border-radius: 50px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-block;
            text-align: center;
        }

        .btn-pricing:hover {
            background: var(--accent-color);
            border-color: var(--accent-color);
            color: white;
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(52, 152, 219, 0.4);
        }

        .btn-pricing-featured {
            background: white;
            color: var(--primary-color);
            border-color: white;
        }

        .btn-pricing-featured:hover {
            background: rgba(255, 255, 255, 0.95);
            color: var(--primary-color);
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(0, 0, 0, 0.2);
        }

        .btn-pricing-contact {
            background: transparent;
            border: 2px solid var(--primary-color);
            color: var(--primary-color);
        }

        .btn-pricing-contact:hover {
            background: var(--primary-color);
            color: white;
        }

        .trial-info {
            text-align: center;
            color: #888;
            font-size: 13px;
            margin-top: 15px;
            margin-bottom: 0;
        }

        .pricing-card.featured .trial-info {
            color: rgba(255, 255, 255, 0.8);
        }

        /* Responsive */
        @media (max-width: 768px) {
            #hero h1 {
                font-size: 32px;
            }

            #hero p {
                font-size: 16px;
            }

            .section-title h2 {
                font-size: 28px;
            }

            .pricing-card.featured {
                transform: scale(1);
            }

            .pricing-card.featured:hover {
                transform: translateY(-10px);
            }

            .pricing-price .amount {
                font-size: 42px;
            }
        }
    </style>
</head>
<body>
<!-- Header -->
<header>
    <nav class="navbar navbar-expand-lg">
        <div class="container">
            <!-- 왼쪽: 로고 -->
            <a class="navbar-brand" href="/">
                <img src="/img/favicontitle.png" alt="Aventro Logo">
                Aventro
            </a>
            
            <!-- 중앙: 메뉴 -->
            <ul class="navbar-nav">
                <li class="nav-item"><a class="nav-link" href="#hero">Home</a></li>
                <li class="nav-item"><a class="nav-link" href="#about">About</a></li>
                <li class="nav-item"><a class="nav-link" href="#services">Services</a></li>
                <li class="nav-item"><a class="nav-link" href="#portfolio">Portfolio</a></li>
                <li class="nav-item"><a class="nav-link" href="#team">Team</a></li>
                <li class="nav-item"><a class="nav-link" href="#contact">Contact</a></li>
            </ul>
            
            <!-- 오른쪽: 로그인 버튼 -->
            <a href="/login" class="btn-login-nav">로그인</a>
        </div>
    </nav>
</header>

<main>
<!-- Hero Section -->
<section id="hero">
    <div class="container">
        <div class="row align-items-center">
            <div class="col-lg-6" data-aos="fade-right">
                <h1>Needy care</h1>
                <p>케어가 필요하신 분들에게 희망을 안겨드립니다</p>
                <div class="hero-buttons">
                    <a href="#pricing" class="btn-hero">가입하기</a>
                    <a href="/login" class="btn-hero-secondary">로그인</a>
                </div>
            </div>
            <div class="col-lg-6" data-aos="fade-left">
                <img src="/img/sinear.jpg" class="img-fluid" alt="Hero">
            </div>
        </div>
    </div>
</section>

<!-- About Section -->
<section id="about">
    <div class="container">
        <div class="section-title" data-aos="fade-up">
            <h2>About Us</h2>
            <p>yea</p>
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

<!-- Services Section -->
<section id="services">
    <div class="container">
        <div class="section-title" data-aos="fade-up">
            <h2>Our Services</h2>
            <p>저희의 서비스를 한번 탐색해보세요</p>
        </div>
        <div class="row">
            <div class="col-lg-4 col-md-6 mb-4" data-aos="fade-up" data-aos-delay="100">
                <div class="service-box">
                    <i class="fas fa-laptop-code"></i>
                    <h3>산책 추천 시스템</h3>
                    <p>.ㅇㄴㅁㅇㅁㄴㅇㅁㄴㅇㅁㄴㅇㅁㄴㅇ</p>
                </div>
            </div>
            <div class="col-lg-4 col-md-6 mb-4" data-aos="fade-up" data-aos-delay="200">
                <div class="service-box">
                    <i class="fas fa-mobile-alt"></i>
                    <h3>식단 추천 시스템</h3>
                    <p>ㅇㄴㅁㅇㄴㅁㅇㅁㄴㅇㅁㄴㅇㄴㅁㅇㄴㅁ</p>
                </div>
            </div>
            <div class="col-lg-4 col-md-6 mb-4" data-aos="fade-up" data-aos-delay="300">
                <div class="service-box">
                    <i class="fas fa-paint-brush"></i>
                    <h3>실시간 노약자 모니터링 시스템</h3>
                    <p>ㅇㄴㅁㅇㄴㅁㅇㅁㄴㅇㄴㅁㅇㅁㄴㅇㄴㅁ</p>
                </div>
            </div>
            <div class="col-lg-4 col-md-6 mb-4" data-aos="fade-up" data-aos-delay="100">
                <div class="service-box">
                    <i class="fas fa-chart-line"></i>
                    <h3>AI를 통한 요양사 추천 시스템</h3>
                    <p>ㄹㅇㅁㅇㄴㅇㅁㄴㅇㅁㄴ.</p>
                </div>
            </div>
            <div class="col-lg-4 col-md-6 mb-4" data-aos="fade-up" data-aos-delay="200">
                <div class="service-box">
                    <i class="fas fa-camera"></i>
                    <h3>AI챗봇 시스템</h3>
                    <p>ㅇㅁㄴㅇㄴㅁㅇㅁㄴㅇㄴㅁㅇㅁㄴㅇㅁㄴㅇㅁㄴㅇ</p>
                </div>
            </div>
            <div class="col-lg-4 col-md-6 mb-4" data-aos="fade-up" data-aos-delay="300">
                <div class="service-box">
                    <i class="fas fa-bullhorn"></i>
                    <h3>AI 건강진단서 분석 시스템</h3>
                    <p>ㄻㅇㄴㅁㅁㄴㅇㅁㄴㅇㄴㅁㅇㅁㄴㅇㄴㅁㅇㅁㄴ</p>
                </div>
            </div>
        </div>
    </div>
</section>


<!-- Pricing Section -->
<section id="pricing">
    <div class="container">
        <div class="section-title" data-aos="fade-up">
            <h2>구독</h2>
            <p>최상의 서비스를 월 구독제를 통해 만나보세요</p>
        </div>
        <div class="row">
            <!-- Starter Plan -->
<%--            <div class="col-lg-4 mb-4" data-aos="fade-up" data-aos-delay="100">--%>
<%--                <div class="pricing-card">--%>
<%--                    <div class="pricing-header">--%>
<%--                        <h3>Starter</h3>--%>
<%--                        <p class="subtitle">For small teams getting started</p>--%>
<%--                    </div>--%>
<%--                    <div class="pricing-price">--%>
<%--                        <span class="currency">$</span>--%>
<%--                        <span class="amount">29</span>--%>
<%--                        <span class="period">/user/month</span>--%>
<%--                    </div>--%>
<%--                    <p class="billing-info">Billed monthly</p>--%>
<%--                    <ul class="pricing-features">--%>
<%--                        <li><i class="fas fa-check-circle"></i> Up to 10 team members</li>--%>
<%--                        <li><i class="fas fa-check-circle"></i> 5 GB storage per user</li>--%>
<%--                        <li><i class="fas fa-check-circle"></i> Basic reporting and analytics</li>--%>
<%--                        <li><i class="fas fa-check-circle"></i> Email support</li>--%>
<%--                        <li><i class="fas fa-check-circle"></i> Mobile app access</li>--%>
<%--                    </ul>--%>
<%--                    <a href="/register" class="btn-pricing">Start Free Trial</a>--%>
<%--                    <p class="trial-info">14-day free trial, no credit card required</p>--%>
<%--                </div>--%>
<%--            </div>--%>

            <!-- Professional Plan -->
            <div class="col-lg-4 mb-4" data-aos="fade-up" data-aos-delay="200">
                <div class="pricing-card featured">
                    <div class="popular-badge">MOST POPULAR</div>
                    <div class="pricing-header">
                        <h3>천사 요금제</h3>
                        <p class="subtitle">모든 서비스 이용가능</p>
                    </div>
                    <div class="pricing-price">
                        <span class="currency">☠️☠️</span>
                        <span class="amount">590,000원</span>
                        <span class="period">월</span>
                    </div>
                    <p class="billing-info">월 가격</p>
                    <ul class="pricing-features">
                        <li><i class="fas fa-check-circle"></i> 무제한 산책 경로 추천</li>
                        <li><i class="fas fa-check-circle"></i> 무제한 식단 추천</li>
                        <li><i class="fas fa-check-circle"></i> 실시간 모니터링 무제한 지원</li>
                        <li><i class="fas fa-check-circle"></i> 무제한 건강 PDF 분석 AI 지원</li>
                        <li><i class="fas fa-check-circle"></i> 프로페셔널한 요양사 추천 자유 이용</li>
                        <li><i class="fas fa-check-circle"></i> 명예 보호자 칭호 지급</li>
                    </ul>
                    <a href="/register" class="btn-pricing btn-pricing-featured">구독하기</a>
                    <p class="trial-info">구매일 기준으로 30일마다 정기결제</p>
                </div>
            </div>



<!-- Contact Section -->
<section id="contact">
    <div class="container">
        <div class="section-title" data-aos="fade-up">
            <h2>Contact</h2>
            <p>Necessitatibus eius consequatur ex aliquid fuga eum quidem sint consectetur velit</p>
        </div>
        <div class="row">
            <!-- Contact Info Card -->
            <div class="col-lg-5 mb-4" data-aos="fade-right">
                <div class="contact-info-card">
                    <h3>Contact Info</h3>
                    <p>Praesent sapien massa, convallis a pellentesque nec, egestas non nisi. Vestibulum ante ipsum primis.</p>

                    <!-- Location -->
                    <div class="contact-detail">
                        <div class="contact-icon">
                            <i class="fas fa-map-marker-alt"></i>
                        </div>
                        <div class="contact-text">
                            <h4>Our Location</h4>
                            <p>비체크리스탈 6동 301호<br>충남 아산시 탕정면 탕정면로 119-4</p>
                        </div>
                    </div>

                    <!-- Phone -->
                    <div class="contact-detail">
                        <div class="contact-icon">
                            <i class="fas fa-phone"></i>
                        </div>
                        <div class="contact-text">
                            <h4>Phone Number</h4>
                            <p>+82 10-8920-3471<br>+82 10-5734-7072</p>
                        </div>
                    </div>

                    <!-- Email -->
                    <div class="contact-detail">
                        <div class="contact-icon">
                            <i class="fas fa-envelope"></i>
                        </div>
                        <div class="contact-text">
                            <h4>Email Address</h4>
                            <p>rnalsdn100@gmail.com<br>shinchagyoung@gmail.com</p>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Contact Form Card -->
            <div class="col-lg-7 mb-4" data-aos="fade-left">
                <div class="contact-form-card">
                    <h3>Get In Touch</h3>
                    <p>Praesent sapien massa, convallis a pellentesque nec, egestas non nisl. Vestibulum ante ipsum primis.</p>

                    <form>
                        <div class="row">
                            <div class="col-md-6">
                                <input type="text" class="form-control" placeholder="Your Name" required>
                            </div>
                            <div class="col-md-6">
                                <input type="email" class="form-control" placeholder="Your Email" required>
                            </div>
                        </div>
                        <input type="text" class="form-control" placeholder="Subject" required>
                        <textarea class="form-control" placeholder="Message" required></textarea>
                        <div class="text-center">
                            <button type="submit" class="btn-submit">Send Message</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</section>
</main>

<!-- Footer -->
<footer>
    <div class="container">
        <div class="footer-social mb-3">
            <a href="#"><i class="fab fa-twitter"></i></a>
            <a href="#"><i class="fab fa-facebook"></i></a>
            <a href="#"><i class="fab fa-instagram"></i></a>
            <a href="#"><i class="fab fa-linkedin"></i></a>
        </div>
        <p>&copy; 2024 Aventro. All Rights Reserved.</p>
    </div>
</footer>

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
            e.preventDefault();
            const target = document.querySelector(this.getAttribute('href'));
            if (target) {
                target.scrollIntoView({
                    behavior: 'smooth',
                    block: 'start'
                });
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
</script>
</body>
</html>