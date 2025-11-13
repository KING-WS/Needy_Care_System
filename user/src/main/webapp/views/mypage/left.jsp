<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div class="p-3">
    <div style="text-align: center; padding: 20px 0; border-bottom: 2px solid #f0f0f0; margin-bottom: 20px;">
        <i class="fas fa-user-circle" style="font-size: 60px; color: var(--primary-color);"></i>
        <h5 style="margin-top: 15px; color: var(--secondary-color);">${sessionScope.loginUser.custName}님</h5>
        <p style="color: #999; font-size: 14px; margin: 0;">${sessionScope.loginUser.custId}</p>
    </div>
    
    <h5 style="padding: 10px 0; border-bottom: 2px solid var(--primary-color); margin-bottom: 15px;">
        <i class="fas fa-user-cog"></i> 마이페이지
    </h5>
    
    <ul class="nav flex-column">
        <li class="nav-item">
            <a class="nav-link" href="<c:url value="/mypage"/>" style="padding: 12px 15px; border-radius: 8px; margin-bottom: 5px; transition: all 0.3s;">
                <i class="fas fa-home"></i> 마이페이지 홈
            </a>
        </li>
        <li class="nav-item">
            <a class="nav-link" href="<c:url value="/mypage/profile"/>" style="padding: 12px 15px; border-radius: 8px; margin-bottom: 5px; transition: all 0.3s;">
                <i class="fas fa-user-edit"></i> 프로필 수정
            </a>
        </li>
        <li class="nav-item">
            <a class="nav-link" href="<c:url value="/mypage/security"/>" style="padding: 12px 15px; border-radius: 8px; margin-bottom: 5px; transition: all 0.3s;">
                <i class="fas fa-lock"></i> 보안 설정
            </a>
        </li>
        <li class="nav-item">
            <a class="nav-link" href="<c:url value="/mypage/settings"/>" style="padding: 12px 15px; border-radius: 8px; margin-bottom: 5px; transition: all 0.3s;">
                <i class="fas fa-cog"></i> 환경 설정
            </a>
        </li>
    </ul>
</div>

<style>
    .nav-link {
        color: var(--secondary-color) !important;
    }
    .nav-link:hover {
        background: var(--light-bg);
        color: var(--primary-color) !important;
        transform: translateX(5px);
    }
    .nav-link.active {
        background: var(--primary-color);
        color: white !important;
    }
</style>

