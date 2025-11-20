<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%
    DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy년 MM월 dd일");
    pageContext.setAttribute("dateFormatter", formatter);
%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>키오스크 모드</title>
    <link rel="icon" type="image/png" href="/img/favicontitle.png">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.2/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Malgun Gothic', '맑은 고딕', sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            flex-direction: column;
        }

        /* 헤더 - 큰 글씨, 심플 */
        .kiosk-header {
            background: rgba(255, 255, 255, 0.95);
            padding: 30px 20px;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
            text-align: center;
        }

        .kiosk-header h1 {
            font-size: 48px;
            font-weight: bold;
            color: #333;
            margin: 0;
        }

        .kiosk-header p {
            font-size: 24px;
            color: #666;
            margin-top: 10px;
        }

        /* 메인 컨텐츠 */
        .kiosk-container {
            flex: 1;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            padding: 40px 20px;
        }

        /* 환영 카드 */
        .welcome-card {
            background: white;
            border-radius: 30px;
            padding: 60px 80px;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.2);
            text-align: center;
            max-width: 1000px;
            width: 100%;
            margin-bottom: 40px;
        }

        .welcome-card .profile-img {
            width: 200px;
            height: 200px;
            border-radius: 50%;
            object-fit: cover;
            border: 8px solid #667eea;
            margin-bottom: 30px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.2);
        }

        .welcome-card h2 {
            font-size: 56px;
            font-weight: bold;
            color: #333;
            margin-bottom: 20px;
        }

        .welcome-card .greeting {
            font-size: 36px;
            color: #667eea;
            font-weight: 600;
            margin-bottom: 40px;
        }

        .welcome-card .info {
            font-size: 28px;
            color: #666;
            margin-bottom: 15px;
            padding: 15px;
            background: #f8f9fa;
            border-radius: 15px;
        }

        /* 메뉴 버튼 그리드 */
        .menu-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 30px;
            max-width: 1200px;
            width: 100%;
        }

        .menu-btn {
            background: white;
            border: none;
            border-radius: 25px;
            padding: 60px 40px;
            cursor: pointer;
            transition: all 0.3s ease;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
            text-decoration: none;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            min-height: 280px;
        }

        .menu-btn:hover {
            transform: translateY(-10px);
            box-shadow: 0 20px 50px rgba(0, 0, 0, 0.2);
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        }

        .menu-btn:hover i {
            color: white;
        }

        .menu-btn:hover .menu-text {
            color: white;
        }

        .menu-btn i {
            font-size: 80px;
            margin-bottom: 25px;
            color: #667eea;
            transition: all 0.3s ease;
        }

        .menu-text {
            font-size: 32px;
            font-weight: bold;
            color: #333;
            transition: all 0.3s ease;
            white-space: nowrap;
        }

        /* 하단 버튼 */
        .bottom-section {
            padding: 30px;
            text-align: center;
        }

        .logout-btn {
            background: rgba(255, 255, 255, 0.3);
            color: white;
            border: 3px solid white;
            padding: 20px 60px;
            font-size: 28px;
            font-weight: bold;
            border-radius: 50px;
            cursor: pointer;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-block;
        }

        .logout-btn:hover {
            background: white;
            color: #667eea;
            transform: scale(1.05);
        }

        /* 반응형 */
        @media (max-width: 1200px) {
            .menu-grid {
                grid-template-columns: repeat(2, 1fr);
            }
        }

        @media (max-width: 768px) {
            .kiosk-header h1 {
                font-size: 36px;
            }

            .welcome-card {
                padding: 40px 30px;
            }

            .welcome-card h2 {
                font-size: 40px;
            }

            .welcome-card .greeting {
                font-size: 28px;
            }

            .menu-grid {
                grid-template-columns: 1fr;
                gap: 20px;
            }

            .menu-btn {
                padding: 40px 30px;
                min-height: 200px;
            }

            .menu-btn i {
                font-size: 60px;
            }

            .menu-text {
                font-size: 24px;
            }
        }

        /* 준비중 뱃지 */
        .coming-soon {
            position: relative;
        }

        .coming-soon::after {
            content: '준비중';
            position: absolute;
            top: 15px;
            right: 15px;
            background: #ff6b6b;
            color: white;
            padding: 8px 16px;
            border-radius: 20px;
            font-size: 16px;
            font-weight: bold;
        }
    </style>
</head>
<body>
    <!-- 헤더 -->
    <div class="kiosk-header">
        <h1>🏠 돌봄 키오스크</h1>
        <p>쉽고 편리한 서비스</p>
    </div>

    <!-- 메인 컨텐츠 -->
    <div class="kiosk-container">
        <!-- 환영 카드 -->
        <div class="welcome-card">
            <c:if test="${not empty recipient.recPhotoUrl}">
                <img src="${recipient.recPhotoUrl}" alt="프로필 사진" class="profile-img">
            </c:if>
            <c:if test="${empty recipient.recPhotoUrl}">
                <div class="profile-img" style="display: flex; align-items: center; justify-content: center; background: #f0f0f0;">
                    <i class="fas fa-user" style="font-size: 80px; color: #999;"></i>
                </div>
            </c:if>
            
            <p class="greeting">환영합니다! 👋</p>
            <c:if test="${not empty recipient.recName}">
                <h2 style="font-size: 48px; color: #333; font-weight: bold; margin-top: 15px; margin-bottom: 15px;">
                    ${recipient.recName}님
                </h2>
            </c:if>
            <c:if test="${not empty cust.custName}">
                <p style="font-size: 32px; color: #666; font-weight: 500; margin-bottom: 30px;">
                    돌봄 담당: ${cust.custName}님
                </p>
            </c:if>
            
            <div class="info">
                <i class="fas fa-birthday-cake"></i>
                생년월일: ${recipient.recBirthday.format(dateFormatter)}
            </div>
            
            <c:if test="${not empty recipient.recAddress}">
                <div class="info">
                    <i class="fas fa-home"></i>
                    주소: ${recipient.recAddress}
                </div>
            </c:if>
        </div>

    </div>

    <!-- 하단 섹션 -->
    <div class="bottom-section">
        <a href="/kiosk/logout" class="logout-btn">
            <i class="fas fa-sign-out-alt"></i> 나가기
        </a>
    </div>

    <script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.2/js/bootstrap.bundle.min.js"></script>
    <script>
        // 현재 시간 표시 (선택사항)
        function updateTime() {
            const now = new Date();
            const timeString = now.toLocaleTimeString('ko-KR', { 
                hour: '2-digit', 
                minute: '2-digit'
            });
            console.log('현재 시간:', timeString);
        }
        
        setInterval(updateTime, 60000); // 1분마다 업데이트
        updateTime();

        // 버튼 클릭 시 햅틱 피드백 (모바일)
        document.querySelectorAll('.menu-btn').forEach(btn => {
            btn.addEventListener('click', function() {
                if (navigator.vibrate) {
                    navigator.vibrate(50);
                }
            });
        });
    </script>
</body>
</html>

