<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ page import="java.time.Period" %>
<%@ page import="java.util.Random" %>
<%@ page import="java.time.LocalDate" %>

<spring:eval expression="@environment.getProperty('app.api.kakao-js-key')" var="kakaoJsKey"/>
<link rel="stylesheet" href="<c:url value='/css/monitoring.css'/>"/>

<style>
    :root {
        --primary-color: #3498db;
        --secondary-color: #343a40;
        --secondary-bg: #F0F8FF;
        --card-bg: white;
        --danger-color: #e74c3c;
    }

    body {
        background-color: #f8f9fa;
    }

    .detail-container {
        max-width: 1300px;
        margin: 0 auto;
        padding: 40px 20px;
        padding-bottom: 50px;
        min-height: calc(100vh - 150px);
    }

    .detail-two-column {
        display: grid;
        grid-template-columns: 1fr 2fr;
        gap: 30px;
        align-items: start;
    }

    .detail-content-card {
        background: var(--card-bg);
        border-radius: 20px;
        padding: 30px;
        box-shadow: 0 10px 30px rgba(0,0,0,0.05);
        margin-bottom: 30px;
    }

    .detail-header {
        text-align: center;
        margin-bottom: 30px;
        padding-bottom: 0;
        border-bottom: none;
    }

    .detail-avatar {
        width: 120px;
        height: 120px;
        border-radius: 50%;
        background: var(--primary-color);
        display: flex;
        align-items: center;
        justify-content: center;
        color: white;
        font-size: 60px;
        margin: 0 auto 20px;
        border: 4px solid var(--secondary-bg);
    }

    .detail-name {
        font-size: 28px;
        font-weight: 700;
        color: var(--secondary-color);
        margin-bottom: 10px;
    }

    .detail-type {
        display: inline-block;
        padding: 8px 15px;
        border-radius: 20px;
        font-size: 14px;
        font-weight: 600;
        margin-bottom: 15px;
    }

    .type-elderly { background: #e3f2fd; color: #1976d2; }
    .type-pregnant { background: #fce4ec; color: #c2185b; }
    .type-disabled { background: #f3e5f5; color: #7b1fa2; }

    .info-section {
        margin-bottom: 25px;
        padding-bottom: 25px;
        border-bottom: none;
    }

    .section-title {
        font-size: 20px;
        font-weight: 700;
        color: #000;
        margin-bottom: 20px;
        display: flex;
        align-items: center;
        padding-bottom: 5px;
        border-bottom: 3px solid var(--secondary-bg);
    }

    .section-title i {
        margin-right: 10px;
        color: var(--primary-color);
        font-size: 22px;
    }

    .info-grid {
        display: flex;
        flex-direction: column;
        gap: 10px;
    }

    .info-item {
        padding: 15px;
        background: var(--secondary-bg);
        border-radius: 12px;
        transition: all 0.3s ease;
        display: flex;
        flex-direction: column;
    }

    .info-label {
        font-size: 13px;
        font-weight: 600;
        color: #7f8c8d;
        margin-bottom: 4px;
        text-transform: uppercase;
        letter-spacing: 0.5px;
    }

    .info-value {
        font-size: 17px;
        font-weight: 700;
        color: var(--secondary-color);
        word-break: break-word;
    }

    /* [수정됨] 실시간 건강정보 스타일 - 흰색 배경 스타일로 변경 */
    .monitoring-info-box {
        /* 배경 그라데이션 제거, 패딩 제거 (부모 카드 패딩 사용) */
        background: transparent;
        padding: 0;
        box-shadow: none;
        color: var(--secondary-color);
        margin-top: 0;
    }

    .monitoring-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 20px;
        padding-bottom: 5px;
        border-bottom: 3px solid var(--secondary-bg);
    }

    .monitoring-header h3 {
        margin: 0;
        font-size: 20px;
        font-weight: 700;
        color: #000;
    }

    .health-metrics-grid {
        display: grid;
        grid-template-columns: repeat(2, 1fr);
        gap: 15px;
        margin-bottom: 25px;
    }

    .health-metric-card {
        background: var(--secondary-bg); /* 밝은 회색 배경 */
        padding: 20px;
        border-radius: 12px;
        border: none;
        backdrop-filter: none;
        transition: all 0.3s ease;
    }

    .health-metric-card:hover {
        transform: translateY(-2px);
    }

    .health-metric-header {
        display: flex;
        align-items: center;
        gap: 10px;
        margin-bottom: 10px;
    }

    .health-metric-icon {
        font-size: 24px;
    }

    .health-metric-label {
        font-size: 14px;
        font-weight: 600;
        color: #7f8c8d; /* 라벨 색상 연하게 변경 */
        opacity: 1;
    }

    .health-metric-value {
        font-size: 28px;
        font-weight: 700;
        margin-bottom: 10px;
        color: var(--secondary-color);
        text-shadow: none;
    }

    .health-metric-bar {
        height: 8px;
        background: #e9ecef;
        border-radius: 4px;
        overflow: hidden;
    }

    .health-metric-bar-fill {
        height: 100%;
        background: var(--primary-color);
        border-radius: 4px;
        transition: width 0.3s ease;
    }

    .monitoring-map-container {
        margin-top: 25px;
        border-radius: 12px;
        overflow: hidden;
        border: 1px solid #e0e0e0;
        box-shadow: none;
    }

    .monitoring-map {
        width: 100%;
        height: 400px;
        border: none;
    }

    .action-buttons {
        display: flex;
        gap: 15px;
        justify-content: center;
        margin-top: 30px;
        padding-top: 20px;
        flex-wrap: nowrap;
    }

    .btn {
        padding: 12px 25px;
        border: none;
        border-radius: 50px;
        font-size: 15px;
        font-weight: 600;
        cursor: pointer;
        transition: all 0.3s ease;
        display: inline-flex;
        align-items: center;
        gap: 8px;
        white-space: nowrap;
    }

    .btn-secondary {
        background: #e9ecef;
        color: #495057;
    }
    .btn-secondary:hover {
        background: #ced4da;
        color: #212529;
    }
</style>

<%
    // 랜덤 건강 데이터 생성 (기존 유지)
    Random random = new Random();
    int systolic = 110 + random.nextInt(31); // 110-140
    int diastolic = 70 + random.nextInt(21); // 70-90
    int heartRate = 60 + random.nextInt(31); // 60-90
    double temperature = 36.0 + random.nextDouble() * 2.0; // 36.0-38.0

    pageContext.setAttribute("systolic", systolic);
    pageContext.setAttribute("diastolic", diastolic);
    pageContext.setAttribute("heartRate", heartRate);
    pageContext.setAttribute("temperature", String.format("%.1f", temperature));

    // 진행률 계산 (기존 유지)
    int systolicProgress = 60 + random.nextInt(30);
    int diastolicProgress = 50 + random.nextInt(30);
    int heartRateProgress = 40 + random.nextInt(30);
    int temperatureProgress = 50 + random.nextInt(30);

    pageContext.setAttribute("systolicProgress", systolicProgress);
    pageContext.setAttribute("diastolicProgress", diastolicProgress);
    pageContext.setAttribute("heartRateProgress", heartRateProgress);
    pageContext.setAttribute("temperatureProgress", temperatureProgress);
%>

<div class="detail-container">
    <div class="text-center mb-5">
        <h1 style="font-size: 38px; font-weight: 800; color: var(--secondary-color); text-shadow: 0 1px 2px rgba(0, 0, 0, 0.05);">
            <i class="bi bi-heart-pulse" style="color: var(--primary-color);"></i> 실시간 건강정보
        </h1>
        <p style="font-size: 16px; color: #666; margin-top: 10px;">
            ${recipient.recName}님의 실시간 건강 상태를 확인합니다.
        </p>
    </div>

    <div class="detail-two-column">
        <div>
            <div class="detail-content-card">
                <div class="info-section" style="border-bottom: none; padding-bottom: 0;">
                    <h3 class="section-title" style="border-bottom: none;">
                        <i class="bi bi-person-badge"></i> 기본 정보
                    </h3>
                </div>

                <div class="detail-header" style="margin-bottom: 20px;">
                    <div class="detail-avatar">
                        <c:choose>
                            <c:when test="${not empty recipient.recPhotoUrl}">
                                <img src="<c:url value='${recipient.recPhotoUrl}'/>" alt="${recipient.recName}" style="width: 100%; height: 100%; object-fit: cover; border-radius: 50%;">
                            </c:when>
                            <c:otherwise>
                                <i class="bi bi-person-fill"></i>
                            </c:otherwise>
                        </c:choose>
                    </div>
                    <h1 class="detail-name">${recipient.recName}</h1>
                    <c:choose>
                        <c:when test="${recipient.recTypeCode == 'ELDERLY'}">
                            <span class="detail-type type-elderly">노인/고령자</span>
                        </c:when>
                        <c:when test="${recipient.recTypeCode == 'PREGNANT'}">
                            <span class="detail-type type-pregnant">임산부</span>
                        </c:when>
                        <c:when test="${recipient.recTypeCode == 'DISABLED'}">
                            <span class="detail-type type-disabled">장애인</span>
                        </c:when>
                    </c:choose>
                </div>

                <div class="info-section">
                    <div class="info-grid">
                        <div class="info-item">
                            <div class="info-label">생년월일</div>
                            <div class="info-value">
                                <c:set var="birthday" value="${recipient.recBirthday}"/>
                                ${birthday.year}년 ${String.format('%02d', birthday.monthValue)}월 ${String.format('%02d', birthday.dayOfMonth)}일
                                <span style="color: #7f8c8d; margin-left: 10px;">(만 <span id="age"></span>세)</span>
                            </div>
                        </div>
                        <div class="info-item">
                            <div class="info-label">성별</div>
                            <div class="info-value">
                                <c:choose>
                                    <c:when test="${recipient.recGender == 'M'}">
                                        <i class="bi bi-gender-male" style="color: #3498db;"></i> 남성
                                    </c:when>
                                    <c:otherwise>
                                        <i class="bi bi-gender-female" style="color: #e91e63;"></i> 여성
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                        <div class="info-item">
                            <div class="info-label">주소</div>
                            <div class="info-value">
                                <i class="bi bi-geo-alt-fill" style="color: #e74c3c; margin-right: 5px;"></i>
                                ${recipient.recAddress}
                            </div>
                        </div>
                    </div>
                </div>

                <div class="action-buttons">
                    <a href="<c:url value="/recipient/list"/>" class="btn btn-secondary">
                        <i class="bi bi-arrow-left"></i> 목록
                    </a>
                </div>
            </div>
        </div>

        <div>
            <div class="detail-content-card">
                <div class="monitoring-info-box">
                    <div class="monitoring-header">
                        <h3 class="section-title" style="border:none; margin:0; padding:0;">
                            <i class="bi bi-activity" style="color: var(--primary-color); margin-right: 10px;"></i> 실시간 건강정보
                        </h3>
                    </div>

                    <div class="health-metrics-grid">
                        <div class="health-metric-card">
                            <div class="health-metric-header">
                                <i class="bi bi-heart-pulse-fill health-metric-icon" style="color: #ff6b9d;"></i>
                                <span class="health-metric-label">수축기 혈압</span>
                            </div>
                            <div class="health-metric-value">${systolic}</div>
                            <div class="health-metric-bar">
                                <div class="health-metric-bar-fill" style="width: ${systolicProgress}%; background-color: #ff6b9d;"></div>
                            </div>
                        </div>

                        <div class="health-metric-card">
                            <div class="health-metric-header">
                                <i class="bi bi-heart health-metric-icon" style="color: #ff4757;"></i>
                                <span class="health-metric-label">확장기 혈압</span>
                            </div>
                            <div class="health-metric-value">${diastolic}</div>
                            <div class="health-metric-bar">
                                <div class="health-metric-bar-fill" style="width: ${diastolicProgress}%; background-color: #ff4757;"></div>
                            </div>
                        </div>

                        <div class="health-metric-card">
                            <div class="health-metric-header">
                                <i class="bi bi-heart-fill health-metric-icon" style="color: #ff4757;"></i>
                                <span class="health-metric-label">심박수</span>
                            </div>
                            <div class="health-metric-value">${heartRate}</div>
                            <div class="health-metric-bar">
                                <div class="health-metric-bar-fill" style="width: ${heartRateProgress}%; background-color: #ff4757;"></div>
                            </div>
                        </div>

                        <div class="health-metric-card">
                            <div class="health-metric-header">
                                <i class="bi bi-thermometer-half health-metric-icon" style="color: #ff9f43;"></i>
                                <span class="health-metric-label">체온</span>
                            </div>
                            <div class="health-metric-value">${temperature}°C</div>
                            <div class="health-metric-bar">
                                <div class="health-metric-bar-fill" style="width: ${temperatureProgress}%; background-color: #ff9f43;"></div>
                            </div>
                        </div>
                    </div>

                    <div class="monitoring-map-container">
                        <div id="monitoringMap" class="monitoring-map"></div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=${kakaoJsKey}&libraries=services"></script>

<script src="https://cdnjs.cloudflare.com/ajax/libs/sockjs-client/1.6.1/sockjs.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/stomp.js/2.3.3/stomp.min.js"></script>

<script>
    // 전역 변수
    let monitoringMap = null;
    let homeMarker = null;
    let homeOverlay = null;
    let recipientLocationMarker = null;
    let recipientOverlay = null;
    const recId = ${recipient.recId};
    const recipientName = '<c:out value="${recipient.recName}" escapeXml="false"/>';
    const recipientAddress = '<c:out value="${recipient.recAddress}" escapeXml="false"/>';
    <c:choose>
    <c:when test="${not empty recipient.recPhotoUrl}">
    <c:set var="photoUrlWithCache" value="${recipient.recPhotoUrl}${fn:contains(recipient.recPhotoUrl, '?') ? '&' : '?'}v=${recipient.recId}"/>
    const recipientPhotoUrl = '<c:url value="${photoUrlWithCache}"/>';
    </c:when>
    <c:otherwise>
    const recipientPhotoUrl = '';
    </c:otherwise>
    </c:choose>

    // 나이 계산
    document.addEventListener('DOMContentLoaded', function() {
        <c:set var="birthday" value="${recipient.recBirthday}"/>
        const birthday = new Date(${birthday.year}, ${birthday.monthValue - 1}, ${birthday.dayOfMonth});
        const today = new Date();
        let age = today.getFullYear() - birthday.getFullYear();
        const monthDiff = today.getMonth() - birthday.getMonth();
        if (monthDiff < 0 || (monthDiff === 0 && today.getDate() < birthday.getDate())) {
            age--;
        }
        document.getElementById('age').textContent = age;
    });

    // 실시간 위치용 원형 프로필 이미지 생성
    function createCircularMarkerImageForRealtime(photoUrl, callback) {
        const canvas = document.createElement('canvas');
        canvas.width = 60;
        canvas.height = 70;
        const ctx = canvas.getContext('2d');
        const img = new Image();
        img.crossOrigin = 'anonymous';
        img.onload = function() {
            ctx.fillStyle = '#667eea';
            ctx.strokeStyle = '#fff';
            ctx.lineWidth = 2;
            ctx.beginPath();
            ctx.moveTo(30, 55);
            ctx.lineTo(25, 65);
            ctx.lineTo(35, 65);
            ctx.closePath();
            ctx.fill();
            ctx.stroke();
            ctx.save();
            ctx.beginPath();
            ctx.arc(30, 30, 25, 0, 2 * Math.PI);
            ctx.clip();
            ctx.fillStyle = '#667eea';
            ctx.fillRect(5, 5, 50, 50);
            ctx.drawImage(img, 5, 5, 50, 50);
            ctx.restore();
            ctx.strokeStyle = '#fff';
            ctx.lineWidth = 3;
            ctx.beginPath();
            ctx.arc(30, 30, 25, 0, 2 * Math.PI);
            ctx.stroke();
            ctx.strokeStyle = '#888';
            ctx.lineWidth = 1;
            ctx.beginPath();
            ctx.arc(30, 30, 27, 0, 2 * Math.PI);
            ctx.stroke();
            callback(canvas.toDataURL('image/png'));
        };
        img.onerror = () => callback(null);
        if (photoUrl && !photoUrl.startsWith('http') && !photoUrl.startsWith('data:')) {
            photoUrl = window.location.origin + (photoUrl.startsWith('/') ? '' : '/') + photoUrl;
        }
        img.src = photoUrl;
    }

    // 기본 마커 이미지 반환
    function getDefaultRecipientMarkerImage() {
        return new kakao.maps.MarkerImage(
            'data:image/svg+xml;base64,' + btoa('<svg xmlns="http://www.w3.org/2000/svg" width="50" height="60" viewBox="0 0 50 60"><circle cx="25" cy="25" r="20" fill="#667eea" stroke="#fff" stroke-width="3"/><circle cx="25" cy="20" r="7" fill="#fff"/><path d="M10 45 Q25 35 40 45" fill="#fff"/><path d="M25 45 L20 55 L30 55 Z" fill="#667eea" stroke="#fff" stroke-width="2"/></svg>'),
            new kakao.maps.Size(50, 60),
            {offset: new kakao.maps.Point(25, 60)}
        );
    }

    // 실시간 위치 마커 업데이트 함수
    function updateRecipientMarker(lat, lng) {
        if (!monitoringMap) {
            console.warn('지도가 초기화되지 않았습니다.');
            return;
        }

        const position = new kakao.maps.LatLng(lat, lng);
        if (recipientLocationMarker) {
            // 기존 마커가 있으면 위치만 업데이트
            recipientLocationMarker.setPosition(position);
        } else {
            // 마커가 없으면 새로 생성
            if (recipientPhotoUrl && recipientPhotoUrl !== '' && recipientPhotoUrl !== 'null') {
                // 프로필 이미지가 있으면 원형 마커 생성
                createCircularMarkerImageForRealtime(recipientPhotoUrl, function(dataUrl) {
                    const markerImage = dataUrl ?
                        new kakao.maps.MarkerImage(dataUrl, new kakao.maps.Size(60, 70), {offset: new kakao.maps.Point(30, 70)}) :
                        getDefaultRecipientMarkerImage();
                    createRecipientMarkerOnMap(position, markerImage);
                });
            } else {
                // 프로필 이미지가 없으면 기본 마커 사용
                const markerImage = getDefaultRecipientMarkerImage();
                createRecipientMarkerOnMap(position, markerImage);
            }
        }

        // 지도 중심을 마커 위치로 이동
        monitoringMap.setCenter(position);
    }

    // 지도에 마커 생성
    function createRecipientMarkerOnMap(position, markerImage) {
        recipientLocationMarker = new kakao.maps.Marker({
            position: position,
            map: monitoringMap,
            image: markerImage,
            zIndex: 999,
            title: recipientName + '님의 현재 위치'
        });
        // 오버레이는 생성하지만 지도에 올리지 않음 (표시하지 않음)
        const overlayContent = `
            <div class="custom-overlay-wrap">
                <div class="custom-overlay-header">
                    <span>${recipientName}님</span>
                    <div class="custom-overlay-close" onclick="this.parentNode.parentNode.parentNode.remove()" title="닫기">×</div>
                </div>
                <div class="custom-overlay-body">
                     <div style="font-size:12px; color:#666;">실시간 위치</div>
                </div>
            </div>`;
        recipientOverlay = new kakao.maps.CustomOverlay({
            content: overlayContent,
            position: position,
            map: null, // 지도에 올리지 않음
            zIndex: 1
        });
    }

    // 지도 초기화
    function initMonitoringMap() {
        if (typeof kakao === 'undefined' || !kakao.maps) {
            console.error('카카오맵 API를 불러올 수 없습니다.');
            return;
        }

        const mapContainer = document.getElementById('monitoringMap');
        if (!mapContainer) {
            console.error('지도 컨테이너를 찾을 수 없습니다.');
            return;
        }

        // 기본 지도 옵션 (서울 중심)
        const mapOption = {
            center: new kakao.maps.LatLng(37.5665, 126.9780),
            level: 5
        };
        monitoringMap = new kakao.maps.Map(mapContainer, mapOption);

        // 지도 타입 컨트롤 생성
        var mapTypeControl = new kakao.maps.MapTypeControl();
        monitoringMap.addControl(mapTypeControl, kakao.maps.ControlPosition.TOPRIGHT);

        // 줌 컨트롤 생성
        var zoomControl = new kakao.maps.ZoomControl();
        monitoringMap.addControl(zoomControl, kakao.maps.ControlPosition.RIGHT);

        const geocoder = new kakao.maps.services.Geocoder();
        // 주소로 지도 중심 설정 (초기 위치)
        if (recipientAddress && recipientAddress.trim() !== '') {
            geocoder.addressSearch(recipientAddress, function(result, status) {
                if (status === kakao.maps.services.Status.OK) {
                    const coords = new kakao.maps.LatLng(result[0].y, result[0].x);
                    monitoringMap.setCenter(coords);

                    // 초기 마커 표시 (집 주소)
                    const homeImageSrc = 'data:image/svg+xml;base64,' + btoa(
                        '<svg xmlns="http://www.w3.org/2000/svg" width="48" height="48" viewBox="0 0 48 48">' +
                        '<g><path d="M24 8L10 20v18h10v-12h8v12h10V20z" fill="#e74c3c" stroke="#888" stroke-width="1"/><path d="M24 8L10 20v18h10v-12h8v12h10V20z" fill="none" stroke="#c0392b" stroke-width="2"/><circle cx="24" cy="26" r="3" fill="#fff" opacity="0.8"/><rect x="18" y="38" width="2" height="6" fill="#c0392b"/><rect x="28" y="38" width="2" height="6" fill="#c0392b"/></g>' +
                        '<circle cx="24" cy="4" r="2" fill="#ffeb3b"/><path d="M24 6 L26 10 L22 10 Z" fill="#ffeb3b"/></svg>'
                    );
                    const homeImageSize = new kakao.maps.Size(48, 48);
                    const homeImageOption = {offset: new kakao.maps.Point(24, 48)};
                    const homeImage = new kakao.maps.MarkerImage(homeImageSrc, homeImageSize, homeImageOption);
                    homeMarker = new kakao.maps.Marker({
                        position: coords,
                        map: monitoringMap,
                        image: homeImage,
                        title: recipientName + '님의 집'
                    });
                    // 집 커스텀 오버레이 (생성만 하고 지도에 올리지 않음)
                    const homeOverlayContent = `
                        <div class="custom-overlay-wrap">
                            <div class="custom-overlay-header" style="background-color: #e74c3c;">
                                <span>${recipientName}님의 집</span>
                                <div class="custom-overlay-close" onclick="this.parentNode.parentNode.parentNode.remove()" title="닫기">×</div>
                            </div>
                            <div class="custom-overlay-body">
                                <span class="custom-overlay-category" style="background-color: #ffe0e0; color: #ff6b6b;">집</span>
                                <div style="font-size:12px; color:#666; margin-top: 8px;">${recipientAddress}</div>
                            </div>
                        </div>`;
                    homeOverlay = new kakao.maps.CustomOverlay({
                        content: homeOverlayContent,
                        position: coords,
                        map: null, // 지도에 올리지 않음
                        zIndex: 1
                    });
                } else {
                    console.warn('주소 검색 실패:', status);
                }
            });
        }
    }

    // 실시간 위치 업데이트 WebSocket 연결
    function connectAndSubscribeForLocation() {
        if (!recId || typeof Stomp === 'undefined') {
            console.log("실시간 위치 업데이트를 위한 사용자 정보 또는 Stomp 라이브러리를 찾을 수 없습니다.");
            return;
        }

        const socket = new SockJS('/adminchat');
        const stompClient = Stomp.over(socket);
        stompClient.debug = null;

        stompClient.connect({}, function (frame) {
            console.log('✅ 실시간 위치 WebSocket 연결됨: ' + frame);

            // recipient-specific 토픽 구독
            const topic = '/topic/location/' + recId;
            stompClient.subscribe(topic, function (message) {
                try {
                    const locationData = JSON.parse(message.body);
                    console.log('📍 실시간 위치 업데이트:', locationData);

                    // 마커 업데이트
                    updateRecipientMarker(locationData.latitude, locationData.longitude);
                } catch (e) {
                    console.error('위치 데이터 파싱 오류:', e);
                }
            });
        }, function(error) {
            console.log('⚠️ 위치 정보 소켓 연결이 끊겼습니다. 5초 후 재연결합니다...');
            setTimeout(connectAndSubscribeForLocation, 5000);
        });
    }

    // 페이지 로드 시 초기화
    window.addEventListener('load', function() {
        // 지도 초기화
        if (typeof kakao !== 'undefined' && kakao.maps) {
            initMonitoringMap();
            // 실시간 위치 업데이트 연결
            connectAndSubscribeForLocation();
        } else {
            // 카카오맵 API 로드 대기
            const checkKakao = setInterval(function() {
                if (typeof kakao !== 'undefined' && kakao.maps) {
                    clearInterval(checkKakao);
                    initMonitoringMap();
                    connectAndSubscribeForLocation();
                }
            }, 100);
        }
    });
</script>