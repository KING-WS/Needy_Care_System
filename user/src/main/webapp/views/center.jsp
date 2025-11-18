<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<spring:eval expression="@environment.getProperty('app.api.kakao-js-key')" var="kakaoJsKey"/>

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
        background: #ffffff;
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

    /* 지도 큰 카드에는 호버 애니메이션 제거 */
    .dashboard-card.card-xlarge:hover {
        transform: none;
        box-shadow: 0 16px 36px rgba(0, 0, 0, 0.1);
        cursor: default;
    }

    .dashboard-card.card-xlarge:hover i {
        transform: none;
        color: var(--primary-color);
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
        min-height: 720px;
    }

    /* 지도 카드 스타일 전체 컨테이너 (대시보드 안의 하이라이트 카드) */
    .dashboard-card.card-xlarge {
        padding: 18px 24px;
        display: block;
        overflow: hidden;
        background: radial-gradient(circle at top left, #f4f9ff 0, #f8fbff 40%, #fff9fb 100%);
        border-radius: 24px;
        box-shadow: 0 18px 45px rgba(0, 0, 0, 0.12);
        position: relative;
    }

    /* 장식용 그라디언트 원 */
    .dashboard-card.card-xlarge::before,
    .dashboard-card.card-xlarge::after {
        content: "";
        position: absolute;
        border-radius: 999px;
        pointer-events: none;
        opacity: 0.45;
    }

    .dashboard-card.card-xlarge::before {
        width: 220px;
        height: 220px;
        background: radial-gradient(circle, rgba(52, 152, 219, 0.25), transparent 70%);
        top: -60px;
        right: -60px;
    }

    .dashboard-card.card-xlarge::after {
        width: 180px;
        height: 180px;
        background: radial-gradient(circle, rgba(231, 76, 60, 0.18), transparent 70%);
        bottom: -40px;
        left: -40px;
    }

    /* 지도 레이아웃 (왼쪽 텍스트/목록 + 오른쪽 지도) */
    .map-layout {
        display: flex;
        gap: 24px;
        height: 100%;
        align-items: stretch;
    }

    /* 왼쪽 영역 */
    .map-left {
        width: 300px;
        display: flex;
        flex-direction: column;
        background: rgba(255, 255, 255, 0.96);
        border-radius: 18px;
        padding: 20px 20px 18px;
        box-shadow: 0 10px 24px rgba(0, 0, 0, 0.07);
        position: relative;
        z-index: 1;
    }

    .map-title {
        display: flex;
        align-items: center;
        gap: 10px;
        font-size: 26px;
        font-weight: 700;
        color: var(--secondary-color);
        margin-bottom: 10px;
    }

    .map-title-icon {
        width: 34px;
        height: 34px;
        border-radius: 999px;
        background: rgba(52, 152, 219, 0.1);
        display: inline-flex;
        align-items: center;
        justify-content: center;
        color: var(--primary-color);
        font-size: 16px;
    }

    .map-desc {
        font-size: 14px;
        color: #777;
        margin-bottom: 20px;
        line-height: 1.6;
    }

    .map-address-panel {
        flex: 1;
        background: #ffffff;
        border-radius: 14px;
        padding: 16px 16px 14px;
        font-size: 14px;
        color: #555555;
        line-height: 1.6;
        display: flex;
        align-items: flex-start;
        justify-content: flex-start;
        border: 1px dashed #d0d7de;
    }

    /* 오른쪽 영역 (탭 + 지도) */
    .map-right {
        flex: 1;
        display: flex;
        flex-direction: column;
    }

    /* 상단 탭 영역 */
    .map-tabs {
        display: inline-flex;
        gap: 4px;
        margin-bottom: 12px;
        position: relative;
        z-index: 1;
    }

    .map-tab {
        border-radius: 10px 10px 0 0;
        padding: 8px 18px;
        font-size: 13px;
        font-weight: 600;
        border: none;
        background: transparent;
        color: #5f6b7a;
        cursor: default; /* 아직 기능 없음 */
        position: relative;
    }

    .map-tab i {
        margin-right: 6px;
        font-size: 13px;
    }

    .map-tab.active {
        color: var(--secondary-color);
    }

    .map-tab.active::after {
        content: "";
        position: absolute;
        left: 10px;
        right: 10px;
        bottom: -6px;
        height: 3px;
        border-radius: 999px;
        background: linear-gradient(90deg, var(--primary-color), var(--accent-color));
        box-shadow: 0 4px 12px rgba(52, 152, 219, 0.45);
    }

    /* 지도 영역 */
    .map-area {
        flex: 1;
        background: #ffffff;
        border-radius: 20px;
        box-shadow: 0 16px 36px rgba(0, 0, 0, 0.1);
        overflow: hidden;
        min-height: 600px;
        position: relative;
        z-index: 1;
    }

    #map {
        width: 100%;
        height: 100%;
        border-radius: 0;
    }

    /* 레이아웃을 위한 추가 스타일 */
    .card-wrapper {
        margin-bottom: 20px;
        flex: 1;
        display: flex;
        flex-direction: column;
    }

    .card-wrapper:last-child {
        margin-bottom: 0;
    }

    /* 각 카드가 컬럼 너비를 꽉 채우도록 설정 */
    .card-wrapper > * {
        flex: 1;
        width: 100%;
    }

    /* 전체 레이아웃 높이 조정 */
    #user-dashboard {
        display: flex;
        align-items: stretch;
    }

    #user-dashboard .container-fluid {
        width: 100%;
        padding-left: 40px;
        padding-right: 40px;
    }

    #user-dashboard .row {
        height: 100%;
        margin-left: 0;
        margin-right: 0;
    }

    #user-dashboard .row > [class*="col-"] {
        padding-left: 10px;
        padding-right: 10px;
        display: flex;
        flex-direction: column;
    }
</style>

<!-- User Dashboard - 기본 메인 페이지 -->
<section id="user-dashboard" style="min-height: calc(100vh - 80px - 100px); padding: 40px 0; background: #ffffff;">
    <div class="container-fluid">
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
                    <div class="dashboard-card card-xlarge">
                        <div class="map-layout">
                            <!-- 왼쪽 : 제목 + 주소 목록 안내 -->
                            <div class="map-left">
                                <div class="map-title">
                                    <span class="map-title-icon">
                                        <i class="fas fa-location-dot"></i>
                                    </span>
                                    <span>내 주변 케어 지도</span>
                                </div>
                                <div class="map-address-panel">
                                    지도에서 사용자가 핀찍은 주소 목록
                                </div>
                            </div>

                            <!-- 오른쪽 : 탭 + 지도 -->
                            <div class="map-right">
                                <div class="map-tabs">
                                    <button type="button" class="map-tab active">
                                        <i class="fas fa-map-marked-alt"></i>
                                        <span>내 지도</span>
                                    </button>
                                    <button type="button" class="map-tab">
                                        <i class="fas fa-route"></i>
                                        <span>산책 코스</span>
                                    </button>
                                    <button type="button" class="map-tab">
                                        <i class="fas fa-route"></i>
                                        <span>병원</span>
                                    </button>
                                    <button type="submit" class="map-tab">
                                        <i class="fas fa-route"></i>
                                        <span><input placeholder="위치 검색" type="text" ></span>
                                    </button>
                                </div>
                                <div class="map-area">
                                    <div id="map"></div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- 카카오맵 API -->
<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=${kakaoJsKey}"></script>
<script>
    var mapContainer = document.getElementById('map');
    var mapOption = {
        center: new kakao.maps.LatLng(36.789, 127.004), // 선문대학교 아산캠퍼스 중심 좌표
        level: 3 // 지도의 확대 레벨
    };

    var map = new kakao.maps.Map(mapContainer, mapOption);

    // 마커가 표시될 위치
    var markerPosition = new kakao.maps.LatLng(36.789, 127.004);

    // 마커 생성
    var marker = new kakao.maps.Marker({
        position: markerPosition
    });

    // 마커가 지도 위에 표시되도록 설정
    marker.setMap(map);

    // 커스텀 오버레이에 표시할 내용
    var content = '<div style="padding:5px; font-size:12px; white-space:nowrap;">선문대학교 아산캠퍼스</div>';

    // 커스텀 오버레이 생성
    var customOverlay = new kakao.maps.CustomOverlay({
        position: markerPosition,
        content: content,
        yAnchor: 2
    });

    // 커스텀 오버레이가 지도 위에 표시되도록 설정
    customOverlay.setMap(map);
</script>
