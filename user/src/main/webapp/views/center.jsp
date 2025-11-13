<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- User Dashboard - 기본 메인 페이지 -->
<section id="user-dashboard" style="min-height: calc(100vh - 80px - 100px); padding: 100px 0; background: #f8f9fa;">
    <div class="container">
        <div class="row">
            <div class="col-12">
                <h1 style="font-size: 48px; font-weight: bold; color: var(--secondary-color); text-align: center; margin-bottom: 20px;">
                    환영합니다, ${sessionScope.loginUser.custName}님! 👋
                </h1>
                <p style="font-size: 20px; color: #666; text-align: center; margin-bottom: 50px;">
                    로그인 되었습니다. 여기에 대시보드나 사용자 전용 컨텐츠가 표시됩니다.
                </p>
            </div>
            
            <div class="col-md-4 mb-4">
                <div class="dashboard-card">
                    <i class="fas fa-user-circle"></i>
                    <h3>내 정보</h3>
                    <p>아이디: ${sessionScope.loginUser.custId}</p>
                    <p>이름: ${sessionScope.loginUser.custName}</p>
                </div>
            </div>
            
            <div class="col-md-4 mb-4">
                <div class="dashboard-card">
                    <i class="fas fa-chart-line"></i>
                    <h3>대시보드</h3>
                    <p>사용자 전용 통계 및 데이터</p>
                </div>
            </div>
            
            <div class="col-md-4 mb-4">
                <div class="dashboard-card">
                    <i class="fas fa-cog"></i>
                    <h3>설정</h3>
                    <p>계정 설정 및 관리</p>
                </div>
            </div>

            <div class="col-md-4 mb-4">
                <div class="dashboard-card">
                    <i class="fas fa-bell"></i>
                    <h3>알림</h3>
                    <p>새로운 알림 확인하기</p>
                </div>
            </div>

            <div class="col-md-4 mb-4">
                <div class="dashboard-card">
                    <i class="fas fa-envelope"></i>
                    <h3>메시지</h3>
                    <p>받은 메시지 확인하기</p>
                </div>
            </div>

            <div class="col-md-4 mb-4">
                <div class="dashboard-card">
                    <i class="fas fa-file-alt"></i>
                    <h3>문서</h3>
                    <p>나의 문서 관리</p>
                </div>
            </div>
        </div>
    </div>
</section>

