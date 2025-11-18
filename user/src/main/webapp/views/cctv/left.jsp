<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<style>
    .cctv-left-menu {
        padding: 20px;
    }
    .cctv-left-menu h5 {
        color: var(--secondary-color);
        font-weight: 600;
        margin-bottom: 20px;
        padding-bottom: 10px;
        border-bottom: 2px solid var(--primary-color);
    }
    .nav-pills .nav-link {
        color: #666;
        margin-bottom: 10px;
        border-radius: 8px;
        transition: all 0.3s;
    }
    .nav-pills .nav-link:hover {
        background-color: var(--primary-color);
        color: white;
    }
    .nav-pills .nav-link.active {
        background-color: var(--primary-color);
    }
</style>

<div class="cctv-left-menu">
    <h5><i class="fas fa-comments"></i> CCTV 메뉴</h5>
    <ul class="nav nav-pills flex-column">
        <li class="nav-item">
            <a class="nav-link" href="<c:url value="/cctv"/>">
                <i class="fas fa-home"></i> 통신 메인
            </a>
        </li>
        <li class="nav-item">
            <a class="nav-link" href="<c:url value="/cctv/chat"/>">
                <i class="fas fa-comments-dots"></i> 채팅
            </a>
        </li>
        <li class="nav-item">
            <a class="nav-link" href="<c:url value="/cctv/video"/>">
                <i class="fas fa-video"></i> 화상통화
            </a>
        </li>
    </ul>
</div>

