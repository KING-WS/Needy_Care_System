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

<div class="comm-left-menu">
    <h5><i class="fas fa-comments"></i> 통신 메뉴</h5>
    <ul class="nav nav-pills flex-column">
        <li class="nav-item">
            <a class="nav-link" href="<c:url value="/schedule"/>">
                <i class="fas fa-home"></i> 일정메인
            </a>
        </li>
        <li class="nav-item">
            <a class="nav-link" href="<c:url value="/comm/chat"/>">
                <i class="fas fa-comment-dots"></i> 일정2
            </a>
        </li>
        <li class="nav-item">
            <a class="nav-link" href="<c:url value="/comm/video"/>">
                <i class="fas fa-video"></i> 일정3
            </a>
        </li>
    </ul>
</div>

