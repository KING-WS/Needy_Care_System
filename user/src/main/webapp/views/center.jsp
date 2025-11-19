<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<spring:eval expression="@environment.getProperty('app.api.kakao-js-key')" var="kakaoJsKey"/>

<!-- CSS 파일 링크 -->
<link rel="stylesheet" href="<c:url value='/css/center.css'/>" />

<!-- User Dashboard - 기본 메인 페이지 -->
<section id="user-dashboard" style="min-height: calc(100vh - 80px - 100px); padding: 40px 0; background: #ffffff;">
    <div class="container-fluid">
        <div class="row">
            <!-- 왼쪽 열 - 2개의 카드 -->
            <div class="col-lg-3 col-md-6">
                <!-- 작은 카드 (위) - 노약자 건강 정보 -->
                <div class="card-wrapper">
                    <c:if test="${not empty recipient}">
                        <a href="<c:url value="/recipient/detail?recId=${recipient.recId}"/>" class="dashboard-card-link">
                            <div class="dashboard-card card-small health-card">
                                <!-- 왼쪽: 프로필 정보 -->
                                <div class="health-card-left">
                                    <div class="recipient-avatar">
                                        <c:choose>
                                            <c:when test="${not empty recipient.recPhotoUrl}">
                                                <img src="<c:url value='${recipient.recPhotoUrl}'/>" alt="${recipient.recName}" class="avatar-image">
                                            </c:when>
                                            <c:otherwise>
                                                <i class="bi bi-person-fill"></i>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                    <div class="recipient-info">
                                        <div class="recipient-name">${recipient.recName}</div>
                                        <c:choose>
                                            <c:when test="${recipient.recTypeCode == 'ELDERLY'}">
                                                <span class="recipient-badge badge-elderly">노인</span>
                                            </c:when>
                                            <c:when test="${recipient.recTypeCode == 'PREGNANT'}">
                                                <span class="recipient-badge badge-pregnant">임산부</span>
                                            </c:when>
                                            <c:when test="${recipient.recTypeCode == 'DISABLED'}">
                                                <span class="recipient-badge badge-disabled">장애인</span>
                                            </c:when>
                                        </c:choose>
                                    </div>
                                </div>

                                <!-- 오른쪽: 건강 데이터 섹션 -->
                                <div class="health-card-right">
                                    <!-- 혈압 수치 병력 -->
                                    <div class="health-info-item">
                                        <div class="health-info-label">혈압 수치</div>
                                        <div class="health-value-text">15/22</div>
                                        <div class="progress-bar-wrapper">
                                            <div class="progress-bar-fill progress-blood-pressure" style="width: 68%;"></div>
                                        </div>
                                    </div>

                                    <!-- 혈당 -->
                                    <div class="health-info-item">
                                        <div class="health-info-label">혈당</div>
                                        <div class="health-value-text">5/19</div>
                                        <div class="progress-bar-wrapper">
                                            <div class="progress-bar-fill progress-blood-sugar" style="width: 26%;"></div>
                                        </div>
                                    </div>

                                    <!-- 조도 -->
                                    <div class="health-info-item">
                                        <div class="health-info-label">조도</div>
                                        <div class="health-value-text">12/08h</div>
                                        <div class="progress-bar-wrapper">
                                            <div class="progress-bar-fill progress-brightness" style="width: 50%;"></div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </a>
                    </c:if>
                    <c:if test="${empty recipient}">
                        <div class="dashboard-card card-small">
                            <div class="no-data">
                                <i class="bi bi-person-x"></i>
                                <span>등록된 노약자가 없습니다</span>
                            </div>
                        </div>
                    </c:if>
                </div>

                <!-- 큰 카드 (아래) - 캘린더 -->
                <div class="card-wrapper">
                    <div class="dashboard-card card-large calendar-card" onclick="location.href='${pageContext.request.contextPath}/schedule'">
                        <%@ page import="java.time.LocalDate, java.time.format.TextStyle, java.util.*, java.util.Locale, java.time.DayOfWeek" %>
                        <%
                            LocalDate now = LocalDate.now();
                            int year = now.getYear();
                            int month = now.getMonthValue();
                            LocalDate firstDay = LocalDate.of(year, month, 1);
                            int daysInMonth = firstDay.lengthOfMonth();
                            int startDayOfWeek = firstDay.getDayOfWeek().getValue() % 7;
                            
                            pageContext.setAttribute("currentYear", year);
                            pageContext.setAttribute("currentMonth", month);
                            pageContext.setAttribute("currentDay", now.getDayOfMonth());
                            pageContext.setAttribute("daysInMonth", daysInMonth);
                            pageContext.setAttribute("startDayOfWeek", startDayOfWeek);
                            
                            // 일정이 있는 날짜를 Set으로 저장
                            Set<Integer> scheduleDays = new HashSet<>();
                            List schedules = (List) request.getAttribute("schedules");
                            if (schedules != null) {
                                for (Object obj : schedules) {
                                    edu.sm.app.dto.Schedule schedule = (edu.sm.app.dto.Schedule) obj;
                                    scheduleDays.add(schedule.getSchedDate().getDayOfMonth());
                                }
                            }
                            pageContext.setAttribute("scheduleDays", scheduleDays);
                        %>
                        
                        <div class="calendar-header">
                            <div class="calendar-title">
                                <i class="bi bi-calendar-event"></i>
                                일정
                            </div>
                            <div class="calendar-month">${currentYear}년 ${currentMonth}월</div>
                        </div>
                        
                        <div class="calendar-grid">
                            <!-- 요일 헤더 -->
                            <div class="calendar-day-header">일</div>
                            <div class="calendar-day-header">월</div>
                            <div class="calendar-day-header">화</div>
                            <div class="calendar-day-header">수</div>
                            <div class="calendar-day-header">목</div>
                            <div class="calendar-day-header">금</div>
                            <div class="calendar-day-header">토</div>
                            
                            <!-- 빈 칸 -->
                            <c:forEach begin="1" end="${startDayOfWeek}">
                                <div class="calendar-day empty"></div>
                            </c:forEach>
                            
                            <!-- 날짜 -->
                            <c:forEach begin="1" end="${daysInMonth}" var="day">
                                <div class="calendar-day 
                                    ${day == currentDay ? 'today' : ''} 
                                    ${scheduleDays.contains(day) ? 'has-event' : ''}">
                                    ${day}
                                </div>
                            </c:forEach>
                        </div>
                        
                        <div class="calendar-footer">
                            <div class="calendar-stats">
                                <div class="calendar-stat-item">
                                    <i class="bi bi-calendar-day"></i>
                                    <span>오늘: ${not empty todaySchedules ? todaySchedules.size() : 0}개</span>
                                </div>
                                <div class="calendar-stat-item">
                                    <i class="bi bi-calendar-week"></i>
                                    <span>이번주: ${not empty schedules ? schedules.size() : 0}개</span>
                                </div>
                                <div class="calendar-stat-item">
                                    <i class="bi bi-calendar-month"></i>
                                    <span>이번달: ${not empty schedules ? schedules.size() : 0}개</span>
                                </div>
                            </div>
                            <div class="calendar-view-all">
                                자세히 보기
                                <i class="bi bi-arrow-right-circle"></i>
                            </div>
                        </div>
                    </div>
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
                                <div class="map-address-panel" id="mapLocationList">
                                    <div class="map-location-items">
                                        <!-- 노약자 집 주소 (항상 표시, 고정) -->
                                        <c:if test="${not empty recipient && not empty recipient.recAddress}">
                                            <div class="map-location-item home-location" onclick="focusHomeMarker()">
                                                <div class="location-icon" style="color: #e74c3c;">
                                                    <i class="bi bi-house-heart-fill"></i>
                                                </div>
                                                <div class="location-info">
                                                    <div class="location-name" style="color: #e74c3c; font-weight: 700;">
                                                        ${recipient.recName}님의 집
                                                    </div>
                                                    <div class="location-category" style="background: #ffebee; color: #e74c3c;">집</div>
                                                    <div class="location-address">
                                                        ${recipient.recAddress}
                                                    </div>
                                                </div>
                                            </div>
                                        </c:if>
                                        
                                        <!-- 구분선 -->
                                        <c:if test="${not empty maps && not empty recipient.recAddress}">
                                            <div style="border-top: 2px solid #e0e0e0; margin: 12px 0;"></div>
                                        </c:if>
                                        
                                        <!-- 저장된 장소 목록 또는 빈 상태 -->
                                        <c:choose>
                                            <c:when test="${empty maps}">
                                                <div class="empty-map-list" style="padding: 20px;">
                                                    <i class="bi bi-pin-map" style="font-size: 30px; color: #ccc; margin-bottom: 8px;"></i>
                                                    <p style="color: #999; font-size: 13px; margin: 0;">지도를 클릭하여<br/>장소를 추가해보세요!</p>
                                                </div>
                                            </c:when>
                                            <c:otherwise>
                                                <c:forEach var="map" items="${maps}">
                                                    <div class="map-location-item" data-map-id="${map.mapId}" 
                                                         data-lat="${map.mapLatitude}" data-lng="${map.mapLongitude}"
                                                         onclick="focusMarker(${map.mapLatitude}, ${map.mapLongitude})">
                                                        <div class="location-icon">
                                                            <i class="bi bi-geo-alt-fill"></i>
                                                        </div>
                                                        <div class="location-info">
                                                            <div class="location-name">${map.mapName}</div>
                                                            <div class="location-category">${map.mapCategory}</div>
                                                        </div>
                                                        <button class="location-delete-btn" onclick="event.stopPropagation(); deleteLocation(${map.mapId})">
                                                            <i class="bi bi-x-circle"></i>
                                                        </button>
                                                    </div>
                                                </c:forEach>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                            </div>

                            <!-- 오른쪽 : 탭 + 검색 + 지도 -->
                            <div class="map-right">
                                <!-- 헤더: 탭 + 검색 -->
                                <div class="map-header">
                                    <div class="map-tabs">
                                        <button type="button" class="map-tab active" onclick="switchMapTab(this, 'mymap')">
                                            <i class="fas fa-map-marked-alt"></i>
                                            <span>내 지도</span>
                                        </button>
                                        <button type="button" class="map-tab" onclick="switchMapTab(this, 'course')">
                                            <i class="fas fa-walking"></i>
                                            <span>산책 코스</span>
                                        </button>
                                    </div>
                                    
                                    <!-- 검색 영역 -->
                                    <div class="map-search-container">
                                        <div class="map-search-wrapper">
                                            <input type="text" 
                                                   id="mapSearchInput" 
                                                   class="map-search-input" 
                                                   placeholder="병원, 약국, 공원 등 장소를 검색하세요..."
                                                   onkeypress="if(event.key==='Enter') searchLocation()">
                                            <button type="button" class="map-search-btn" onclick="searchLocation()">
                                                <i class="bi bi-search"></i>
                                            </button>
                                        </div>
                                        <!-- 검색 결과 드롭다운 -->
                                        <div id="searchResults" class="search-results"></div>
                                    </div>
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

<!-- 장소 추가 모달 -->
<div class="map-modal-overlay" id="mapModal">
    <div class="map-modal">
        <div class="map-modal-header">
            <div class="map-modal-title">
                <i class="bi bi-pin-map-fill"></i>
                <span>장소 추가</span>
            </div>
            <button class="map-modal-close" onclick="closeMapModal()">
                <i class="bi bi-x-lg"></i>
            </button>
        </div>
        <div class="map-modal-body">
            <div class="modal-location-info" id="modalLocationInfo">
                <i class="bi bi-geo-alt-fill"></i>
                <span id="modalAddress">주소 조회 중...</span>
            </div>
            <form id="mapLocationForm">
                <input type="hidden" id="modalLat" name="latitude">
                <input type="hidden" id="modalLng" name="longitude">
                <input type="hidden" id="modalRecId" name="recId" value="${recipient.recId}">
                
                <div class="modal-form-group">
                    <label class="modal-form-label">
                        장소 이름<span class="required">*</span>
                    </label>
                    <input type="text" class="modal-form-input" id="modalMapName" 
                           name="mapName" placeholder="예: 우리 동네 병원" required maxlength="100">
                </div>
                
                <div class="modal-form-group">
                    <label class="modal-form-label">
                        카테고리<span class="required">*</span>
                    </label>
                    <select class="modal-form-select" id="modalCategory" name="mapCategory" required>
                        <option value="">선택하세요</option>
                        <option value="병원">병원</option>
                        <option value="약국">약국</option>
                        <option value="마트">마트/편의점</option>
                        <option value="공원">공원</option>
                        <option value="복지관">복지관</option>
                        <option value="기타">기타</option>
                    </select>
                </div>
                
                <div class="modal-form-group">
                    <label class="modal-form-label">
                        메모
                    </label>
                    <textarea class="modal-form-textarea" id="modalContent" 
                              name="mapContent" placeholder="이 장소에 대한 메모를 남겨보세요..." maxlength="500"></textarea>
                </div>
            </form>
        </div>
        <div class="map-modal-footer">
            <button type="button" class="modal-btn modal-btn-cancel" onclick="closeMapModal()">취소</button>
            <button type="button" class="modal-btn modal-btn-save" onclick="saveMapLocation()">저장</button>
        </div>
    </div>
</div>

<!-- 카카오맵 API (services 라이브러리 포함) -->
<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=${kakaoJsKey}&libraries=services"></script>
<script>
    // 전역 변수
    var map;
    var markers = [];
    var geocoder = new kakao.maps.services.Geocoder();
    var tempMarker = null;
    var clickedPosition = null;
    var homeMarker = null; // 집 마커
    var homeInfowindow = null; // 집 인포윈도우
    
    // 노약자 주소 정보
    var recipientAddress = '<c:out value="${recipient.recAddress}" escapeXml="false"/>';
    var recipientName = '<c:out value="${recipient.recName}" escapeXml="false"/>';
    
    // 지도 초기화
    var mapContainer = document.getElementById('map');
    var mapOption = {
        center: new kakao.maps.LatLng(37.5665, 126.9780), // 기본 좌표 (곧 집 주소로 변경됨)
        level: 5
    };
    
    map = new kakao.maps.Map(mapContainer, mapOption);
    
    // 지도 클릭 이벤트 - 마커 추가 & 인포윈도우 닫기
    kakao.maps.event.addListener(map, 'click', function(mouseEvent) {
        var latlng = mouseEvent.latLng;
        
        // 모든 인포윈도우 닫기
        markers.forEach(function(item) {
            if (item.infowindow) {
                item.infowindow.close();
            }
        });
        
        searchMarkers.forEach(function(item) {
            if (item.infowindow) {
                item.infowindow.close();
            }
        });
        
        // 집 인포윈도우도 닫기
        if (homeInfowindow) {
            homeInfowindow.close();
        }
        
        // 임시 마커 제거
        if (tempMarker) {
            tempMarker.setMap(null);
        }
        
        // 새 임시 마커 생성
        tempMarker = new kakao.maps.Marker({
            position: latlng,
            map: map,
            image: new kakao.maps.MarkerImage(
                'https://t1.daumcdn.net/localimg/localimages/07/mapapidoc/marker_red.png',
                new kakao.maps.Size(35, 40)
            )
        });
        
        clickedPosition = latlng;
        
        // 모달 열기 및 주소 조회
        openMapModal(latlng.getLat(), latlng.getLng());
    });
    
    // 노약자 집 마커 표시 (최우선)
    function loadHomeMarker() {
        if (!recipientAddress || recipientAddress === '' || recipientAddress === 'null') {
            console.log('노약자 주소 정보가 없습니다.');
            return;
        }
        
        console.log('집 주소 검색 시도:', recipientAddress);
        
        // 주소 정제 (상세주소 제거, 쉼표나 괄호 이후 내용 제거)
        var cleanAddress = recipientAddress
            .split(',')[0]      // 쉼표 이후 제거
            .split('(')[0]      // 괄호 이후 제거
            .trim();
        
        console.log('정제된 주소:', cleanAddress);
        
        // 주소로 좌표 검색
        geocoder.addressSearch(cleanAddress, function(result, status) {
            if (status === kakao.maps.services.Status.OK) {
                var coords = new kakao.maps.LatLng(result[0].y, result[0].x);
                
                console.log('✅ 주소 검색 성공! 좌표:', result[0].y, result[0].x);
                
                // 집 마커 이미지 (커스텀 집 아이콘 SVG)
                var homeImageSrc = 'data:image/svg+xml;base64,' + btoa(
                    '<svg xmlns="http://www.w3.org/2000/svg" width="48" height="48" viewBox="0 0 48 48">' +
                    '<defs>' +
                    '<filter id="shadow" x="-50%" y="-50%" width="200%" height="200%">' +
                    '<feGaussianBlur in="SourceAlpha" stdDeviation="2"/>' +
                    '<feOffset dx="0" dy="2" result="offsetblur"/>' +
                    '<feComponentTransfer><feFuncA type="linear" slope="0.3"/></feComponentTransfer>' +
                    '<feMerge><feMergeNode/><feMergeNode in="SourceGraphic"/></feMerge>' +
                    '</filter>' +
                    '</defs>' +
                    '<g filter="url(#shadow)">' +
                    '<path d="M24 8L10 20v18h10v-12h8v12h10V20z" fill="#e74c3c"/>' +
                    '<path d="M24 8L10 20v18h10v-12h8v12h10V20z" fill="none" stroke="#c0392b" stroke-width="2"/>' +
                    '<circle cx="24" cy="26" r="3" fill="#fff" opacity="0.8"/>' +
                    '<rect x="18" y="38" width="2" height="6" fill="#c0392b"/>' +
                    '<rect x="28" y="38" width="2" height="6" fill="#c0392b"/>' +
                    '</g>' +
                    '<circle cx="24" cy="4" r="2" fill="#ffeb3b"/>' +
                    '<path d="M24 6 L26 10 L22 10 Z" fill="#ffeb3b"/>' +
                    '</svg>'
                );
                var homeImageSize = new kakao.maps.Size(48, 48);
                var homeImageOption = {offset: new kakao.maps.Point(24, 48)};
                var homeImage = new kakao.maps.MarkerImage(homeImageSrc, homeImageSize, homeImageOption);
                
                // 집 마커 생성
                homeMarker = new kakao.maps.Marker({
                    map: map,
                    position: coords,
                    image: homeImage,
                    title: recipientName + '님의 집'
                });
                
                // 집 정보 인포윈도우
                homeInfowindow = new kakao.maps.InfoWindow({
                    content: '<div style="padding:15px;font-size:14px;min-width:200px;text-align:center;">' +
                             '<div style="font-weight:700;color:#e74c3c;margin-bottom:5px;">' +
                             '<i class="bi bi-house-heart-fill"></i> ' + recipientName + '님의 집</div>' +
                             '<div style="font-size:12px;color:#666;">' + cleanAddress + '</div>' +
                             '</div>',
                    removable: false
                });
                
                // 집 마커 클릭 시 인포윈도우 표시
                kakao.maps.event.addListener(homeMarker, 'click', function() {
                    // 다른 모든 인포윈도우 닫기
                    markers.forEach(function(item) {
                        if (item.infowindow) {
                            item.infowindow.close();
                        }
                    });
                    
                    searchMarkers.forEach(function(item) {
                        if (item.infowindow) {
                            item.infowindow.close();
                        }
                    });
                    
                    // 집 인포윈도우만 열기
                    homeInfowindow.open(map, homeMarker);
                });
                
                // 지도 중심을 집 위치로 설정
                map.setCenter(coords);
                map.setLevel(4); // 적당한 줌 레벨
                
                console.log('✅ 집 마커 표시 완료:', cleanAddress);
            } else {
                console.error('❌ 주소 검색 실패!');
                console.error('원본 주소:', recipientAddress);
                console.error('정제된 주소:', cleanAddress);
                console.error('상태 코드:', status);
                
                // 검색 실패 시 키워드 검색 시도
                console.log('📍 키워드 검색으로 재시도...');
                var ps = new kakao.maps.services.Places();
                ps.keywordSearch(cleanAddress, function(data, status) {
                    if (status === kakao.maps.services.Status.OK && data.length > 0) {
                        var coords = new kakao.maps.LatLng(data[0].y, data[0].x);
                        
                        console.log('✅ 키워드 검색 성공! 좌표:', data[0].y, data[0].x);
                        
                        // 집 마커 이미지
                        var homeImageSrc = 'https://t1.daumcdn.net/localimg/localimages/07/mapapidoc/red_b.png';
                        var homeImageSize = new kakao.maps.Size(50, 45);
                        var homeImageOption = {offset: new kakao.maps.Point(15, 43)};
                        var homeImage = new kakao.maps.MarkerImage(homeImageSrc, homeImageSize, homeImageOption);
                        
                        homeMarker = new kakao.maps.Marker({
                            map: map,
                            position: coords,
                            image: homeImage,
                            title: recipientName + '님의 집'
                        });
                        
                        map.setCenter(coords);
                        map.setLevel(4);
                        
                        console.log('✅ 키워드 검색으로 집 마커 표시 완료');
                    } else {
                        console.error('❌ 키워드 검색도 실패. 지도를 기본 위치(서울)로 표시합니다.');
                        console.error('💡 팁: 노약자 관리 페이지에서 정확한 주소로 수정해주세요.');
                        // 기본 위치(서울)로 유지
                    }
                });
            }
        });
    }
    
    // 저장된 마커들 표시
    function loadSavedMarkers() {
        var savedMapsJson = '<c:out value="${not empty maps ? true : false}" escapeXml="false"/>';
        if (savedMapsJson === 'true') {
            var savedMaps = [];
            <c:forEach var="mapItem" items="${maps}" varStatus="status">
            savedMaps.push({
                mapId: parseInt('${mapItem.mapId}'),
                mapName: '<c:out value="${mapItem.mapName}" escapeXml="false"/>',
                mapCategory: '<c:out value="${mapItem.mapCategory}" escapeXml="false"/>',
                lat: parseFloat('${mapItem.mapLatitude}'),
                lng: parseFloat('${mapItem.mapLongitude}')
            });
            </c:forEach>
            
            savedMaps.forEach(function(mapData) {
                addMarkerToMap(mapData);
            });
            
            // 집 마커가 없고 저장된 마커가 있으면 첫 번째 마커로 이동
            if (!homeMarker && savedMaps.length > 0) {
                map.setCenter(new kakao.maps.LatLng(savedMaps[0].lat, savedMaps[0].lng));
            }
        }
    }
    
    // 카테고리별 마커 이미지 URL 반환
    function getMarkerImageByCategory(category) {
        var imageInfo = {
            src: '',
            size: new kakao.maps.Size(40, 42),
            offset: new kakao.maps.Point(20, 42)
        };
        
        switch(category) {
            case '병원':
                imageInfo.src = 'https://t1.daumcdn.net/localimg/localimages/07/mapapidoc/markerStar.png';
                imageInfo.size = new kakao.maps.Size(24, 35);
                imageInfo.offset = new kakao.maps.Point(12, 35);
                break;
            case '약국':
                imageInfo.src = 'https://t1.daumcdn.net/localimg/localimages/07/2018/pc/img/marker_spot.png';
                imageInfo.size = new kakao.maps.Size(30, 35);
                imageInfo.offset = new kakao.maps.Point(15, 35);
                break;
            case '마트':
            case '편의점':
                imageInfo.src = 'https://t1.daumcdn.net/localimg/localimages/07/mapapidoc/marker_number_blue.png';
                imageInfo.size = new kakao.maps.Size(36, 37);
                imageInfo.offset = new kakao.maps.Point(18, 37);
                break;
            case '공원':
                imageInfo.src = 'https://t1.daumcdn.net/localimg/localimages/07/mapapidoc/marker_number_green.png';
                imageInfo.size = new kakao.maps.Size(36, 37);
                imageInfo.offset = new kakao.maps.Point(18, 37);
                break;
            case '복지관':
                imageInfo.src = 'https://t1.daumcdn.net/localimg/localimages/07/mapapidoc/marker_number_orange.png';
                imageInfo.size = new kakao.maps.Size(36, 37);
                imageInfo.offset = new kakao.maps.Point(18, 37);
                break;
            default:
                imageInfo.src = 'https://t1.daumcdn.net/localimg/localimages/07/mapapidoc/markerStar.png';
                imageInfo.size = new kakao.maps.Size(24, 35);
                imageInfo.offset = new kakao.maps.Point(12, 35);
                break;
        }
        
        return new kakao.maps.MarkerImage(imageInfo.src, imageInfo.size, {offset: imageInfo.offset});
    }
    
    // 지도에 마커 추가
    function addMarkerToMap(mapData) {
        var position = new kakao.maps.LatLng(mapData.lat, mapData.lng);
        
        // 카테고리별 마커 이미지 가져오기
        var markerImage = getMarkerImageByCategory(mapData.mapCategory);
        
        var marker = new kakao.maps.Marker({
            position: position,
            map: map,
            image: markerImage,
            title: mapData.mapName
        });
        
        // 인포윈도우 생성
        var infowindow = new kakao.maps.InfoWindow({
            content: '<div style="padding:12px;font-size:13px;min-width:180px;text-align:center;">' +
                     '<div style="font-weight:700;color:#333;margin-bottom:5px;">' + mapData.mapName + '</div>' +
                     '<div style="display:inline-block;padding:3px 10px;background:#e8eaf6;color:#667eea;border-radius:12px;font-size:11px;">' +
                     mapData.mapCategory + '</div>' +
                     '</div>'
        });
        
        // 마커 클릭 이벤트
        kakao.maps.event.addListener(marker, 'click', function() {
            // 다른 모든 인포윈도우 닫기
            markers.forEach(function(item) {
                if (item.infowindow) {
                    item.infowindow.close();
                }
            });
            
            searchMarkers.forEach(function(item) {
                if (item.infowindow) {
                    item.infowindow.close();
                }
            });
            
            // 집 인포윈도우도 닫기
            if (homeInfowindow) {
                homeInfowindow.close();
            }
            
            // 클릭한 마커의 인포윈도우만 열기
            infowindow.open(map, marker);
        });
        
        markers.push({
            marker: marker,
            infowindow: infowindow,
            mapId: mapData.mapId
        });
    }
    
    // 모달 열기
    function openMapModal(lat, lng) {
        document.getElementById('modalLat').value = lat;
        document.getElementById('modalLng').value = lng;
        document.getElementById('mapModal').classList.add('show');
        
        // 주소 조회
        geocoder.coord2Address(lng, lat, function(result, status) {
            if (status === kakao.maps.services.Status.OK) {
                var addr = result[0].address.address_name;
                document.getElementById('modalAddress').textContent = addr;
            } else {
                document.getElementById('modalAddress').textContent = '위도: ' + lat.toFixed(6) + ', 경도: ' + lng.toFixed(6);
            }
        });
        
        // 폼 초기화
        document.getElementById('mapLocationForm').reset();
    }
    
    // 모달 닫기
    function closeMapModal() {
        document.getElementById('mapModal').classList.remove('show');
        
        // 임시 마커 제거
        if (tempMarker) {
            tempMarker.setMap(null);
            tempMarker = null;
        }
    }
    
    // 장소 저장
    async function saveMapLocation() {
        var form = document.getElementById('mapLocationForm');
        if (!form.checkValidity()) {
            form.reportValidity();
            return;
        }
        
        var saveBtn = document.querySelector('.modal-btn-save');
        saveBtn.disabled = true;
        saveBtn.textContent = '저장 중...';
        
        var formData = {
            recId: parseInt(document.getElementById('modalRecId').value),
            mapName: document.getElementById('modalMapName').value.trim(),
            mapCategory: document.getElementById('modalCategory').value,
            mapContent: document.getElementById('modalContent').value.trim(),
            mapLatitude: parseFloat(document.getElementById('modalLat').value),
            mapLongitude: parseFloat(document.getElementById('modalLng').value)
        };
        
        try {
            const response = await fetch('/api/map', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify(formData)
            });
            
            const result = await response.json();
            
            if (result.success) {
                alert('장소가 성공적으로 저장되었습니다!');
                closeMapModal();
                location.reload(); // 페이지 새로고침
            } else {
                alert('저장 실패: ' + (result.message || '알 수 없는 오류'));
                saveBtn.disabled = false;
                saveBtn.textContent = '저장';
            }
        } catch (error) {
            console.error('저장 오류:', error);
            alert('저장 중 오류가 발생했습니다.');
            saveBtn.disabled = false;
            saveBtn.textContent = '저장';
        }
    }
    
    // 장소 삭제
    async function deleteLocation(mapId) {
        if (!confirm('이 장소를 삭제하시겠습니까?')) {
            return;
        }
        
        try {
            const response = await fetch('/api/map/' + mapId, {
                method: 'DELETE'
            });
            
            const result = await response.json();
            
            if (result.success) {
                alert('장소가 삭제되었습니다.');
                location.reload();
            } else {
                alert('삭제 실패: ' + (result.message || '알 수 없는 오류'));
            }
        } catch (error) {
            console.error('삭제 오류:', error);
            alert('삭제 중 오류가 발생했습니다.');
        }
    }
    
    // 마커에 포커스
    function focusMarker(lat, lng) {
        var position = new kakao.maps.LatLng(lat, lng);
        map.setCenter(position);
        map.setLevel(3);
        
        // 해당 마커의 인포윈도우 열기
        markers.forEach(function(item) {
            var markerPos = item.marker.getPosition();
            if (Math.abs(markerPos.getLat() - lat) < 0.0001 && 
                Math.abs(markerPos.getLng() - lng) < 0.0001) {
                item.infowindow.open(map, item.marker);
            }
        });
    }
    
    // 집 마커에 포커스
    function focusHomeMarker() {
        if (homeMarker && homeInfowindow) {
            var position = homeMarker.getPosition();
            map.setCenter(position);
            map.setLevel(3);
            
            // 다른 모든 인포윈도우 닫기
            markers.forEach(function(item) {
                if (item.infowindow) {
                    item.infowindow.close();
                }
            });
            
            searchMarkers.forEach(function(item) {
                if (item.infowindow) {
                    item.infowindow.close();
                }
            });
            
            // 집 인포윈도우만 열기
            homeInfowindow.open(map, homeMarker);
        }
    }
    
    // 탭 전환 함수
    function switchMapTab(element, tabType) {
        // 모든 탭에서 active 클래스 제거
        document.querySelectorAll('.map-tab').forEach(tab => {
            tab.classList.remove('active');
        });
        
        // 클릭한 탭에 active 클래스 추가
        element.classList.add('active');
        
        // 탭에 따른 기능 추가 (추후 구현)
        console.log('탭 전환:', tabType);
    }
    
    // 위치 검색 함수
    var searchMarkers = []; // 검색 결과 마커들
    
    function searchLocation() {
        var keyword = document.getElementById('mapSearchInput').value.trim();
        
        if (!keyword) {
            alert('검색어를 입력해주세요.');
            return;
        }
        
        console.log('🔍 검색어:', keyword);
        
        // Places 서비스 객체 생성
        var ps = new kakao.maps.services.Places();
        
        // 현재 지도 중심 좌표 가져오기
        var center = map.getCenter();
        
        // 키워드 검색 (현재 위치 기준)
        ps.keywordSearch(keyword, function(data, status) {
            if (status === kakao.maps.services.Status.OK) {
                console.log('✅ 검색 성공! 결과:', data.length + '개');
                displaySearchResults(data);
            } else if (status === kakao.maps.services.Status.ZERO_RESULT) {
                console.log('❌ 검색 결과 없음');
                displayNoResults();
            } else {
                console.error('❌ 검색 실패:', status);
                alert('검색 중 오류가 발생했습니다.');
            }
        }, {
            location: center,
            radius: 5000, // 5km 반경 검색
            size: 10 // 최대 10개 결과
        });
    }
    
    // 검색 결과 표시
    function displaySearchResults(places) {
        var resultsContainer = document.getElementById('searchResults');
        resultsContainer.innerHTML = '';
        
        // 이전 검색 마커 제거
        searchMarkers.forEach(function(item) {
            if (item.marker) {
                item.marker.setMap(null);
            }
            if (item.infowindow) {
                item.infowindow.close();
            }
        });
        searchMarkers = [];
        
        places.forEach(function(place, index) {
            // 검색 결과 항목 생성
            var item = document.createElement('div');
            item.className = 'search-result-item';
            item.onclick = function() {
                selectSearchResult(place);
            };
            
            var icon = getCategoryIcon(place.category_name);
            
            item.innerHTML = 
                '<div class="search-result-icon">' +
                    '<i class="' + icon + '"></i>' +
                '</div>' +
                '<div class="search-result-info">' +
                    '<div class="search-result-name">' + place.place_name + '</div>' +
                    '<div class="search-result-address">' + place.address_name + '</div>' +
                    '<span class="search-result-category">' + getCategoryText(place.category_name) + '</span>' +
                '</div>';
            
            resultsContainer.appendChild(item);
            
            // 지도에 검색 결과 마커 표시
            var markerPosition = new kakao.maps.LatLng(place.y, place.x);
            var marker = new kakao.maps.Marker({
                position: markerPosition,
                map: map
            });
            
            var infowindow = new kakao.maps.InfoWindow({
                content: '<div style="padding:10px;font-size:13px;text-align:center;min-width:150px;">' +
                         '<strong>' + place.place_name + '</strong><br/>' +
                         '<span style="color:#666;font-size:11px;">' + place.address_name + '</span>' +
                         '</div>'
            });
            
            // 마커 클릭 시에만 인포윈도우 표시
            kakao.maps.event.addListener(marker, 'click', function() {
                // 다른 인포윈도우 모두 닫기
                searchMarkers.forEach(function(item) {
                    if (item.infowindow) {
                        item.infowindow.close();
                    }
                });
                
                markers.forEach(function(item) {
                    if (item.infowindow) {
                        item.infowindow.close();
                    }
                });
                
                // 집 인포윈도우도 닫기
                if (homeInfowindow) {
                    homeInfowindow.close();
                }
                
                // 클릭한 마커의 인포윈도우만 열기
                infowindow.open(map, marker);
            });
            
            searchMarkers.push({
                marker: marker,
                infowindow: infowindow
            });
        });
        
        // 검색 결과 드롭다운 표시
        resultsContainer.classList.add('show');
        
        // 첫 번째 결과로 지도 이동
        if (places.length > 0) {
            var firstPlace = places[0];
            map.setCenter(new kakao.maps.LatLng(firstPlace.y, firstPlace.x));
            map.setLevel(4);
        }
    }
    
    // 검색 결과 없음 표시
    function displayNoResults() {
        alert('검색 결과가 없습니다.\n다른 검색어로 시도해보세요.');
        
        // 검색 입력창 포커스
        document.getElementById('mapSearchInput').focus();
    }
    
    // 검색 결과 선택
    function selectSearchResult(place) {
        console.log('📍 선택한 장소:', place.place_name);
        
        // 해당 위치로 지도 이동
        var position = new kakao.maps.LatLng(place.y, place.x);
        map.setCenter(position);
        map.setLevel(3);
        
        // 검색 결과 드롭다운 닫기
        document.getElementById('searchResults').classList.remove('show');
        
        // 해당 마커의 인포윈도우 열기
        searchMarkers.forEach(function(item) {
            var markerPos = item.marker.getPosition();
            if (Math.abs(markerPos.getLat() - place.y) < 0.0001 && 
                Math.abs(markerPos.getLng() - place.x) < 0.0001) {
                
                // 다른 인포윈도우 모두 닫기
                searchMarkers.forEach(function(otherItem) {
                    if (otherItem.infowindow) {
                        otherItem.infowindow.close();
                    }
                });
                
                // 선택한 마커의 인포윈도우만 열기
                item.infowindow.open(map, item.marker);
            }
        });
    }
    
    // 카테고리별 아이콘 반환
    function getCategoryIcon(categoryName) {
        if (!categoryName) return 'bi bi-geo-alt-fill';
        
        if (categoryName.includes('병원') || categoryName.includes('의료')) return 'bi bi-hospital';
        if (categoryName.includes('약국')) return 'bi bi-capsule';
        if (categoryName.includes('음식') || categoryName.includes('카페')) return 'bi bi-cup-hot';
        if (categoryName.includes('마트') || categoryName.includes('편의점')) return 'bi bi-cart';
        if (categoryName.includes('공원')) return 'bi bi-tree';
        if (categoryName.includes('은행')) return 'bi bi-bank';
        if (categoryName.includes('주차')) return 'bi bi-p-square';
        
        return 'bi bi-geo-alt-fill';
    }
    
    // 카테고리 텍스트 정리
    function getCategoryText(categoryName) {
        if (!categoryName) return '기타';
        
        var parts = categoryName.split('>');
        return parts[parts.length - 1].trim() || '기타';
    }
    
    // 검색창 외부 클릭 시 드롭다운 닫기
    document.addEventListener('click', function(e) {
        var searchContainer = document.querySelector('.map-search-container');
        var searchResults = document.getElementById('searchResults');
        
        if (searchContainer && !searchContainer.contains(e.target)) {
            searchResults.classList.remove('show');
        }
    });
    
    // 페이지 로드 시 집 마커 먼저, 그 다음 저장된 마커 표시
    window.addEventListener('load', function() {
        loadHomeMarker();      // 1. 집 마커 먼저 표시
        loadSavedMarkers();    // 2. 저장된 장소들 표시
    });
    
    // ESC 키로 모달 닫기
    document.addEventListener('keydown', function(e) {
        if (e.key === 'Escape' && document.getElementById('mapModal').classList.contains('show')) {
            closeMapModal();
        }
    });
</script>
