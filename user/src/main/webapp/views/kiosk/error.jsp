<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>접속 오류 - 키오스크</title>
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
            align-items: center;
            justify-content: center;
            padding: 20px;
        }

        .error-container {
            background: white;
            border-radius: 30px;
            padding: 80px 60px;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.2);
            text-align: center;
            max-width: 700px;
            width: 100%;
        }

        .error-icon {
            font-size: 120px;
            color: #ff6b6b;
            margin-bottom: 30px;
        }

        .error-title {
            font-size: 48px;
            font-weight: bold;
            color: #333;
            margin-bottom: 20px;
        }

        .error-message {
            font-size: 32px;
            color: #666;
            margin-bottom: 50px;
            line-height: 1.6;
        }

        .home-btn {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border: none;
            padding: 25px 70px;
            font-size: 28px;
            font-weight: bold;
            border-radius: 50px;
            cursor: pointer;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-block;
        }

        .home-btn:hover {
            transform: translateY(-5px);
            box-shadow: 0 15px 40px rgba(102, 126, 234, 0.4);
            color: white;
        }

        /* 반응형 */
        @media (max-width: 768px) {
            .error-container {
                padding: 50px 30px;
            }

            .error-icon {
                font-size: 80px;
            }

            .error-title {
                font-size: 36px;
            }

            .error-message {
                font-size: 24px;
            }

            .home-btn {
                padding: 20px 50px;
                font-size: 24px;
            }
        }
    </style>
</head>
<body>
    <div class="error-container">
        <div class="error-icon">
            <i class="fas fa-exclamation-triangle"></i>
        </div>
        
        <h1 class="error-title">접속 오류</h1>
        
        <p class="error-message">
            <c:choose>
                <c:when test="${not empty errorMessage}">
                    ${errorMessage}
                </c:when>
                <c:otherwise>
                    올바르지 않은 접속입니다.<br>
                    관리자에게 문의하세요.
                </c:otherwise>
            </c:choose>
        </p>
        
        <c:if test="${not empty kioskCode}">
            <div style="background: #f8f9fa; padding: 20px; border-radius: 15px; margin-bottom: 30px;">
                <p style="font-size: 16px; color: #666; margin: 0;">
                    입력된 코드: <strong>${kioskCode}</strong>
                </p>
            </div>
        </c:if>
        
        <c:if test="${not empty errorDetail}">
            <details style="background: #fff3cd; padding: 15px; border-radius: 10px; margin-bottom: 30px; text-align: left; cursor: pointer;">
                <summary style="font-size: 14px; font-weight: bold; color: #856404;">기술 정보 (개발자용)</summary>
                <pre style="font-size: 12px; color: #666; margin-top: 10px; white-space: pre-wrap;">${errorDetail}</pre>
            </details>
        </c:if>
        
        <a href="/" class="home-btn">
            <i class="fas fa-home"></i> 홈으로 돌아가기
        </a>
    </div>
</body>
</html>

