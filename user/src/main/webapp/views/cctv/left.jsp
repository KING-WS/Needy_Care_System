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
        color: var(--secondary-color) !important;
        margin-bottom: 10px;
        border-radius: 8px;
        padding: 12px 15px;
        transition: all 0.3s;
    }
    .nav-pills .nav-link:hover {
        background: var(--light-bg);
        color: var(--primary-color) !important;
        transform: translateX(5px);
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
                <i class="fas fa-home"></i> 다중 모니터링
            </a>
        </li>
    </ul>
</div>

