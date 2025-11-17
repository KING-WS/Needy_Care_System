<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<style>
    .dashboard-card-link {
        text-decoration: none;
        color: inherit;
        display: block;
        height: 100%;
    }
    .dashboard-card {
        border: none;
        border-radius: 15px;
        box-shadow: 0 5px 15px rgba(0,0,0,0.08);
        padding: 30px;
        height: 100%;
        text-align: center;
        transition: all 0.3s ease;
        background: #e0e0e0;
        display: flex;
        flex-direction: column;
        justify-content: center;
        align-items: center;
    }
    .dashboard-card:hover {
        transform: translateY(-8px);
        box-shadow: 0 12px 25px rgba(0,0,0,0.12);
        cursor: pointer;
    }
    .dashboard-card i {
        font-size: 50px;
        color: var(--primary-color);
        margin-bottom: 20px;
        transition: all 0.3s ease;
    }
    .dashboard-card:hover i {
        transform: scale(1.1);
        color: var(--accent-color);
    }
    .dashboard-card h3 {
        font-size: 22px;
        margin-bottom: 10px;
        color: var(--secondary-color);
        font-weight: 600;
    }
    .dashboard-card p {
        color: #666;
        font-size: 15px;
        line-height: 1.5;
    }

    /* 카드 높이 설정 */
    .card-small {
        min-height: 250px;
    }
    .card-medium {
        min-height: 395px;
    }
    .card-large {
        min-height: 560px;
    }
    .card-xlarge {
        min-height: 830px;
    }

    /* 레이아웃을 위한 추가 스타일 */
    .card-wrapper {
        margin-bottom: 20px;
    }

    /* 전체 레이아웃 높이 조정 */
    #user-dashboard {
        display: flex;
        align-items: stretch;
    }

    #user-dashboard .container-fluid {
        width: 100%;
    }

    #user-dashboard .row {
        height: 100%;
    }
</style>

<!-- User Dashboard - 기본 메인 페이지 -->
<section id="user-dashboard" style="min-height: calc(100vh - 80px - 100px); padding: 40px 0; background: #f8f9fa;">
    <div class="container-fluid px-4">
        <div class="row">
            <!-- 왼쪽 열 - 2개의 카드 -->
            <div class="col-lg-3 col-md-6">
                <!-- 작은 카드 (위) -->
                <div class="card-wrapper">
                    <a href="<c:url value="/comm"/>" class="dashboard-card-link">
                        <div class="dashboard-card card-small">
                        </div>
                    </a>
                </div>

                <!-- 큰 카드 (아래) -->
                <div class="card-wrapper">
                    <a href="<c:url value="/schedule"/>" class="dashboard-card-link">
                        <div class="dashboard-card card-large">
                        </div>
                    </a>
                </div>
            </div>

            <!-- 가운데 열 - 2개의 카드 -->
            <div class="col-lg-3 col-md-6">
                <!-- 중간 카드 (위) -->
                <div class="card-wrapper">
                    <a href="<c:url value="/cctv"/>" class="dashboard-card-link">
                        <div class="dashboard-card card-medium">
                        </div>
                    </a>
                </div>

                <!-- 중간 카드 (아래) -->
                <div class="card-wrapper">
                    <a href="<c:url value="/mypage"/>" class="dashboard-card-link">
                        <div class="dashboard-card card-medium">
                        </div>
                    </a>
                </div>
            </div>

            <!-- 오른쪽 열 - 1개의 큰 카드 -->
            <div class="col-lg-6 col-md-12">
                <div class="card-wrapper">
                    <a href="<c:url value="/page"/>" class="dashboard-card-link">
                        <div class="dashboard-card card-xlarge">
                        </div>
                    </a>
                </div>
            </div>
        </div>
    </div>
</section>
