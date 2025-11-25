<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<style>
    .comm-left-menu {
        padding: 20px;
    }
    .comm-left-menu h5 {
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
        background: var(--primary-color);
        color: white !important;
    }
</style>

<div class="comm-left-menu">
    <h5><i class="fas fa-heartbeat"></i> 돌봄 케어</h5>
    <ul class="nav nav-pills flex-column">
        <li class="nav-item">
            <a class="nav-link active" href="<c:url value='/care'/>">
                <i class="fas fa-video"></i> 맞춤 돌봄 콘텐츠
            </a>
        </li>
    </ul>
</div>

