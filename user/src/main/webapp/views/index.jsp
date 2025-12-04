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
            font-family: 'Noto Sans KR', sans-serif; /* 폰트 통일 */
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
            border-radius: 50px; /* 둥근 버튼 통일 */
            text-decoration: none;
            font-weight: 600;
            font-size: 15px;
            transition: all 0.3s;
            order: 3;
            box-shadow: 0 4px 10px rgba(52, 152, 219, 0.4); /* 그림자 추가 */
        }

        .btn-login-nav:hover {
            background: #2980b9; /* 호버 색상 변경 */
            color: white;
            transform: translateY(-2px);
            box-shadow: 0 6px 15px rgba(52, 152, 219, 0.6);
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
            padding: 10px 25px; /* 크기 조정 */
            border-radius: 50px; /* 둥근 버튼 통일 */
            text-decoration: none;
            font-weight: 600;
            font-size: 15px;
            transition: all 0.3s;
            border: none;
            box-shadow: 0 4px 10px rgba(231, 76, 60, 0.4);
        }

        .btn-logout:hover {
            background: #c0392b;
            transform: translateY(-2px);
            box-shadow: 0 6px 15px rgba(231, 76, 60, 0.6);
        }

        /* ---------------------------------------------------- */
        /* 3. Hero Section */
        /* ---------------------------------------------------- */
        #hero {
            background: linear-gradient(135deg, var(--primary-color) 0%, #2c3e50 100%); /* 그라데이션 유지 */
            padding: 180px 0 100px;
            color: white;
            position: relative;
            overflow: hidden;
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

        #hero h1 {
            font-size: 52px; /* 크기 강조 */
            font-weight: 800; /* 두께 강조 */
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
            padding: 14px 40px; /* 크기 조정 */
            border-radius: 50px;
            font-weight: 700;
            text-decoration: none;
            display: inline-block;
            transition: all 0.3s;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        }

        .btn-hero:hover {
            background: var(--accent-color);
            color: white;
            transform: translateY(-3px);
            box-shadow: 0 10px 20px rgba(0,0,0,0.3);
        }

        .btn-hero-secondary {
            background: transparent;
            color: white;
            border: 2px solid white;
            padding: 14px 40px; /* 크기 조정 */
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
            box-shadow: 0 10px 20px rgba(0,0,0,0.3);
        }

        /* ---------------------------------------------------- */
        /* 4. 공통 섹션 스타일 (About, Services, Contact) */
        /* ---------------------------------------------------- */
        #about {
            padding: 100px 0; /* 패딩 조정 */
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
            border-radius: 15px; /* 둥근 모서리 통일 */
            box-shadow: 0 10px 30px rgba(0,0,0,0.15); /* 그림자 강조 */
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
            font-size: 52px; /* 아이콘 크기 강조 */
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
            height: 100%; /* 팀 카드가 서비스 박스와 높이를 맞추도록 */
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
            box-shadow: 0 4px 15px rgba(52, 152, 219, 0.4);
        }

        .btn-submit:hover {
            background: #1565c0;
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(52, 152, 219, 0.6);
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

    </style>
</head>
<body>
<header>
    <nav class="navbar navbar-expand-lg">
        <div class="container">
            <a class="navbar-brand" href="/">
                <img src="/img/favicontitle.png" alt="Aventro Logo">
                AI 돌봄 시스템
            </a>

            <ul class="navbar-nav">
                <li class="nav-item"><a class="nav-link" href="#hero">Home</a></li>
                <li class="nav-item"><a class="nav-link" href="#about">About</a></li>
                <li class="nav-item"><a class="nav-link" href="#services">Services</a></li>
                <li class="nav-item"><a class="nav-link" href="#team">Team</a></li>
                <li class="nav-item"><a class="nav-link" href="#contact">Contact</a></li>
            </ul>

            <a href="/login" class="btn-login-nav">로그인</a>
        </div>
    </nav>
</header>

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
                <div class="col-lg-6" data-aos="fade-left">
                    <img src="/img/sinear.jpg" class="img-fluid" alt="Hero">
                </div>
            </div>
        </div>
    </section>

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

    <section id="team">
        <div class="container">
            <div class="section-title" data-aos="fade-up">
                <h2>Team</h2>
                <p>저희와 함께하는 팀원들을 소개합니다.</p>
            </div>
            <div class="row">
                <div class="col-lg-3 col-md-6 mb-4 text-center" data-aos="fade-up" data-aos-delay="100">
                    <div class="team-member">
                        <i class="fas fa-users" style="font-size: 50px; color: #ccc;"></i>
                        <h4 style="margin-top: 15px;">팀 멤버 1</h4>
                        <span class="d-block mb-3">Placeholder</span>
                        <p style="font-size: 14px; color: #666; margin-top: 10px;">준비 중</p>
                    </div>
                </div>
                <div class="col-lg-3 col-md-6 mb-4 text-center" data-aos="fade-up" data-aos-delay="200">
                    <div class="team-member">
                        <i class="fas fa-users" style="font-size: 50px; color: #ccc;"></i>
                        <h4 style="margin-top: 15px;">팀 멤버 2</h4>
                        <span class="d-block mb-3">Placeholder</span>
                        <p style="font-size: 14px; color: #666; margin-top: 10px;">준비 중</p>
                    </div>
                </div>
                <div class="col-lg-3 col-md-6 mb-4 text-center" data-aos="fade-up" data-aos-delay="300">
                    <div class="team-member">
                        <i class="fas fa-users" style="font-size: 50px; color: #ccc;"></i>
                        <h4 style="margin-top: 15px;">팀 멤버 3</h4>
                        <span class="d-block mb-3">Placeholder</span>
                        <p style="font-size: 14px; color: #666; margin-top: 10px;">준비 중</p>
                    </div>
                </div>
                <div class="col-lg-3 col-md-6 mb-4 text-center" data-aos="fade-up" data-aos-delay="400">
                    <div class="team-member">
                        <i class="fas fa-users" style="font-size: 50px; color: #ccc;"></i>
                        <h4 style="margin-top: 15px;">팀 멤버 4</h4>
                        <span class="d-block mb-3">Placeholder</span>
                        <p style="font-size: 14px; color: #666; margin-top: 10px;">준비 중</p>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <section id="contact">
        <div class="container">
            <div class="section-title" data-aos="fade-up">
                <h2>Contact</h2>
                <p>Necessitatibus eius consequatur ex aliquid fuga eum quidem sint consectetur velit</p>
            </div>
            <div class="row">
                <div class="col-lg-5 mb-4" data-aos="fade-right">
                    <div class="contact-info-card">
                        <h3>Contact Info</h3>
                        <p>Praesent sapien massa, convallis a pellentesque nec, egestas non nisi.
                            Vestibulum ante ipsum primis.</p>

                        <div class="contact-detail">
                            <div class="contact-icon">
                                <i class="fas fa-map-marker-alt"></i>
                            </div>
                            <div class="contact-text">
                                <h4>Our Location</h4>
                                <p>비체크리스탈 6동 301호<br>충남 아산시 탕정면 탕정면로 119-4</p>
                            </div>
                        </div>

                        <div class="contact-detail">
                            <div class="contact-icon">
                                <i class="fas fa-phone"></i>
                            </div>
                            <div class="contact-text">
                                <h4>Phone Number</h4>
                                <p>+82 10-8920-3471<br>+82 10-5734-7072</p>
                            </div>
                        </div>

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

                <div class="col-lg-7 mb-4" data-aos="fade-left">
                    <div class="contact-form-card">
                        <h3>Get In Touch</h3>
                        <p>Praesent sapien massa, convallis a pellentesque nec, egestas non nisl.
                            Vestibulum ante ipsum primis.</p>

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
</script>
</body>
</html>