<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- 통신 메인 페이지 -->
<style>
    /* 컨텐츠 중앙 정렬 및 여백 조정 */
    section > .container-fluid {
        max-width: 1400px;
        margin: 0 auto;
        padding: 0 40px;
    }
    
    @media (max-width: 1200px) {
        section > .container-fluid {
            padding: 0 30px;
        }
    }
    
    @media (max-width: 768px) {
        section > .container-fluid {
            padding: 0 20px;
        }
    }
</style>

<section style="padding: 20px 0 100px 0;">
    <div class="container-fluid">
        <div class="row">
            <div class="col-12 mb-4 text-center">
                <h1 style="font-size: 38px; font-weight: 800; color: var(--secondary-color); text-shadow: 0 1px 2px rgba(0, 0, 0, 0.05);">
                    <i class="fas fa-comments" style="color: var(--primary-color);"></i> 통신 센터
                </h1>
                <p style="font-size: 16px; color: #666; margin-top: 10px;">
                    ${sessionScope.loginUser.custName}님의 통신 관리 페이지입니다.
                </p>
            </div>
            
            <div class="col-md-6 mb-4">
                <div class="card" style="border: none; border-radius: 15px; box-shadow: 0 5px 15px rgba(0,0,0,0.1); padding: 30px; height: 100%;">
                    <div style="text-align: center;">
                        <i class="fas fa-comment-dots" style="font-size: 60px; color: var(--primary-color); margin-bottom: 20px;"></i>
                        <h3 style="font-size: 24px; margin-bottom: 15px; color: var(--secondary-color);">채팅</h3>
                        <p style="color: #666; margin-bottom: 20px;">
                            실시간 채팅으로 소통하세요
                        </p>
                        <a href="<c:url value="/comm/chat"/>" class="btn btn-primary" style="border-radius: 20px; padding: 10px 30px;">
                            채팅 시작하기
                        </a>
                    </div>
                </div>
            </div>
            
            <div class="col-md-6 mb-4">
                <div class="card" style="border: none; border-radius: 15px; box-shadow: 0 5px 15px rgba(0,0,0,0.1); padding: 30px; height: 100%;">
                    <div style="text-align: center;">
                        <i class="fas fa-video" style="font-size: 60px; color: #e74c3c; margin-bottom: 20px;"></i>
                        <h3 style="font-size: 24px; margin-bottom: 15px; color: var(--secondary-color);">화상통화</h3>
                        <p style="color: #666; margin-bottom: 20px;">
                            영상으로 대면 상담하세요
                        </p>
                        <a href="<c:url value="/comm/video"/>" class="btn btn-danger" style="border-radius: 20px; padding: 10px 30px;">
                            화상통화 시작하기
                        </a>
                    </div>
                </div>
            </div>

            <div class="col-12 mt-4">
                <div class="card" style="border: none; border-radius: 15px; box-shadow: 0 5px 15px rgba(0,0,0,0.1); padding: 30px; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white;">
                    <h4 style="margin-bottom: 15px;"><i class="fas fa-info-circle"></i> 통신 이용 안내</h4>
                    <ul style="list-style: none; padding: 0;">
                        <li style="margin-bottom: 10px;"><i class="fas fa-check"></i> 24시간 실시간 채팅 지원</li>
                        <li style="margin-bottom: 10px;"><i class="fas fa-check"></i> HD 화질 화상통화</li>
                        <li style="margin-bottom: 10px;"><i class="fas fa-check"></i> 안전한 암호화 통신</li>
                        <li style="margin-bottom: 10px;"><i class="fas fa-check"></i> 통신 내역 자동 저장</li>
                    </ul>
                </div>
            </div>
        </div>
    </div>
</section>

