<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<style>
    .recipient-left-menu {
        padding: 20px;
    }
    .recipient-left-menu h5 {
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
        display: flex;
        align-items: center;
        padding: 12px 15px;
    }
    .nav-pills .nav-link i {
        margin-right: 10px;
        font-size: 18px;
    }
    .nav-pills .nav-link:hover {
        background-color: var(--primary-color);
        color: white;
        transform: translateX(5px);
    }
    .nav-pills .nav-link.active {
        background-color: var(--primary-color);
        color: white;
    }
    .menu-icon {
        width: 60px;
        height: 60px;
        margin: 0 auto 15px;
        display: flex;
        align-items: center;
        justify-content: center;
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        border-radius: 50%;
        color: white;
        font-size: 28px;
    }
</style>

<div class="recipient-left-menu">
    <div class="menu-icon">
        <i class="bi bi-people-fill"></i>
    </div>
    <h5><i class="bi bi-heart-pulse"></i> 돌봄 대상자 관리</h5>
    <ul class="nav nav-pills flex-column">
        <li class="nav-item">
            <a class="nav-link" href="<c:url value='/recipient/list'/>">
                <i class="bi bi-list-ul"></i> 대상자 목록
            </a>
        </li>
        <li class="nav-item">
            <a class="nav-link" href="<c:url value='/recipient/register'/>">
                <i class="bi bi-person-plus-fill"></i> 대상자 등록
            </a>
        </li>
        <li class="nav-item">
            <a class="nav-link" href="<c:url value='/recipient/stats'/>">
                <i class="bi bi-bar-chart-fill"></i> 통계 현황
            </a>
        </li>
    </ul>
</div>

