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
                                <div class="calendar-header">
                                    <div class="calendar-title">
                                        <i class="bi bi-heart-pulse-fill"></i>
                                        건강 정보
                                    </div>
                                </div>
                                <div class="health-card-content">
                                    <!-- 왼쪽: 프로필 정보 -->
                                    <div class="health-card-left">
                                        <div class="recipient-avatar">
                                            <c:choose>
                                                <c:when test="${not empty recipient.recPhotoUrl}">
                                                    <img src="${recipient.recPhotoUrl}" alt="${recipient.recName}" class="avatar-image" 
                                                         onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';">
                                                    <i class="bi bi-person-fill" style="display: none; position: absolute; font-size: 30px; color: white;"></i>
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
                        </div>
                    </div>
                </div>
            </div>

            <!-- 가운데 열 - 2개의 카드 -->
            <div class="col-lg-3 col-md-6">
                <!-- 중간 카드 (위) - 오늘의 식단 -->
                <div class="card-wrapper">
                    <a href="<c:url value="/mealplan"/>" class="dashboard-card-link">
                        <div class="dashboard-card card-medium meal-card">
                            <div class="calendar-header">
                                <div class="calendar-title">
                                    <i class="bi bi-egg-fried"></i>
                                    오늘의 식단표
                                </div>
                                <div class="calendar-month">
                                    <c:set var="today" value="<%=java.time.LocalDate.now()%>"/>
                                    ${today.monthValue}월 ${today.dayOfMonth}일
                                </div>
                            </div>
                            
                            <div class="meal-list">
                                <c:choose>
                                    <c:when test="${not empty todayMeals}">
                                        <c:forEach var="meal" items="${todayMeals}">
                                            <div class="meal-item">
                                                <div class="meal-type ${meal.mealType == '아침' ? 'breakfast' : (meal.mealType == '점심' ? 'lunch' : 'dinner')}">
                                                    <span>${meal.mealType}</span>
                                                </div>
                                                <div class="meal-content">
                                                    <div class="meal-menu">${meal.mealMenu}</div>
                                                    <c:if test="${not empty meal.mealCalories}">
                                                        <div class="meal-calories">${meal.mealCalories}kcal</div>
                                                    </c:if>
                                                </div>
                                            </div>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="meal-empty-container">
                                            <div class="meal-empty">등록된 식단이 없습니다</div>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </a>
                </div>

                <!-- 중간 카드 (아래) - 오늘의 일정 -->
                <div class="card-wrapper">
                    <a href="<c:url value="/schedule"/>" class="dashboard-card-link">
                        <div class="dashboard-card card-medium schedule-card">
                            <div class="calendar-header">
                                <div class="calendar-title">
                                    <i class="bi bi-clock-history"></i>
                                    오늘의 일정
                                </div>
                                <div class="calendar-month">
                                    <c:set var="today" value="<%=java.time.LocalDate.now()%>"/>
                                    ${today.monthValue}월 ${today.dayOfMonth}일
                                </div>
                            </div>
                            
                            <div class="hourly-schedule-list">
                                <c:choose>
                                    <c:when test="${not empty todayHourlySchedules}">
                                        <c:forEach var="hourly" items="${todayHourlySchedules}">
                                            <div class="hourly-schedule-item">
                                                <div class="hourly-time">
                                                    <c:if test="${not empty hourly.hourlySchedStartTime}">
                                                        ${hourly.hourlySchedStartTime}
                                                    </c:if>
                                                    <c:if test="${not empty hourly.hourlySchedEndTime}">
                                                        ~ ${hourly.hourlySchedEndTime}
                                                    </c:if>
                                                </div>
                                                <div class="hourly-content">
                                                    <div class="hourly-name">${hourly.hourlySchedName}</div>
                                                    <c:if test="${not empty hourly.hourlySchedContent}">
                                                        <div class="hourly-detail">${hourly.hourlySchedContent}</div>
                                                    </c:if>
                                                </div>
                                            </div>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="hourly-empty">
                                            <i class="bi bi-calendar-x"></i>
                                            <span>오늘 등록된 일정이 없습니다</span>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
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
                                                         onclick="showLocationDetail(${map.mapId})">
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
                                        <!-- 산책코스 모드일 때만 표시되는 경로 초기화 버튼 -->
                                        <button type="button" id="courseResetBtn" class="map-tab course-reset-btn" onclick="clearCurrentCourse()" style="display: none; margin-left: 10px; background: #ff6b6b; border-color: #ff6b6b;">
                                            <i class="fas fa-redo"></i>
                                            <span>경로 초기화</span>
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

<!-- 산책코스 저장 모달 -->
<div class="map-modal-overlay" id="courseModal">
    <div class="map-modal">
        <div class="map-modal-header">
            <div class="map-modal-title">
                <i class="fas fa-walking"></i>
                <span>산책코스 저장</span>
            </div>
            <button class="map-modal-close" onclick="closeCourseModal()">
                <i class="bi bi-x-lg"></i>
            </button>
        </div>
        <div class="map-modal-body">
            <form id="courseForm">
                <input type="hidden" id="courseRecId" name="recId" value="${recipient.recId}">
                
                <div class="modal-form-group">
                    <label class="modal-form-label">
                        산책코스 이름<span class="required">*</span>
                    </label>
                    <input type="text" class="modal-form-input" id="courseName" 
                           name="courseName" placeholder="예: 아침 산책 코스" required maxlength="100">
                </div>
                
                <div class="modal-form-group">
                    <label class="modal-form-label">
                        코스 유형<span class="required">*</span>
                    </label>
                    <select class="modal-form-select" id="courseType" name="courseType" required>
                        <option value="">선택하세요</option>
                        <option value="산책">산책</option>
                        <option value="운동">운동</option>
                        <option value="병원경로">병원경로</option>
                        <option value="쇼핑">쇼핑</option>
                        <option value="기타">기타</option>
                    </select>
                </div>
                
                <div class="modal-form-group">
                    <label class="modal-form-label">
                        총 거리
                    </label>
                    <input type="text" class="modal-form-input" id="courseTotalDistance" 
                           readonly style="background: #f5f5f5;">
                </div>
                
                <div class="modal-form-group">
                    <label class="modal-form-label">
                        경로 지점 수
                    </label>
                    <input type="text" class="modal-form-input" id="coursePointCount" 
                           readonly style="background: #f5f5f5;">
                </div>
            </form>
        </div>
        <div class="map-modal-footer">
            <button type="button" class="modal-btn modal-btn-cancel" onclick="closeCourseModal()">취소</button>
            <button type="button" class="modal-btn modal-btn-save" onclick="saveCourseToServer()">저장</button>
        </div>
    </div>
</div>

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

<!-- 장소 상세 정보 모달 -->
<div class="map-modal-overlay" id="locationDetailModal">
    <div class="map-modal">
        <div class="map-modal-header">
            <div class="map-modal-title">
                <i class="bi bi-geo-alt-fill"></i>
                <span>장소 정보</span>
            </div>
            <button class="map-modal-close" onclick="closeLocationDetailModal()">
                <i class="bi bi-x-lg"></i>
            </button>
        </div>
        <div class="map-modal-body">
            <div class="modal-location-info" id="detailLocationAddress">
                <i class="bi bi-geo-alt-fill"></i>
                <span id="detailAddress">주소 조회 중...</span>
            </div>
            <div class="modal-form-group">
                <label class="modal-form-label">거리</label>
                <div class="modal-form-readonly" id="detailLocationDistance" style="color: #667eea; font-weight: 600; font-size: 16px; margin-bottom: 10px;">-</div>
            </div>
            <div class="modal-form-group">
                <label class="modal-form-label">장소 이름</label>
                <div class="modal-form-readonly" id="detailLocationName">-</div>
            </div>
            <div class="modal-form-group">
                <label class="modal-form-label">카테고리</label>
                <div class="modal-form-readonly" id="detailLocationCategory">-</div>
            </div>
            <div class="modal-form-group">
                <label class="modal-form-label">메모</label>
                <div class="modal-form-readonly" id="detailLocationContent">-</div>
            </div>
        </div>
        <div class="map-modal-footer">
            <button type="button" class="modal-btn modal-btn-delete" onclick="deleteLocationFromModal()">삭제</button>
            <button type="button" class="modal-btn modal-btn-cancel" onclick="closeLocationDetailModal()">닫기</button>
            <button type="button" class="modal-btn modal-btn-save" onclick="viewLocationOnMap()">지도에서 보기</button>
        </div>
    </div>
</div>

<!-- 산책코스 상세 정보 모달 -->
<div class="map-modal-overlay" id="courseDetailModal">
    <div class="map-modal">
        <div class="map-modal-header">
            <div class="map-modal-title">
                <i class="bi bi-walking"></i>
                <span>산책코스 정보</span>
            </div>
            <button class="map-modal-close" onclick="closeCourseDetailModal()">
                <i class="bi bi-x-lg"></i>
            </button>
        </div>
        <div class="map-modal-body">
            <div class="modal-form-group">
                <label class="modal-form-label">코스 이름</label>
                <div class="modal-form-readonly" id="detailCourseName">-</div>
            </div>
            <div class="modal-form-group">
                <label class="modal-form-label">코스 타입</label>
                <div class="modal-form-readonly" id="detailCourseType">-</div>
            </div>
            <div class="modal-form-group">
                <label class="modal-form-label">총 거리</label>
                <div class="modal-form-readonly" id="detailCourseDistance">-</div>
            </div>
            <div class="modal-form-group">
                <label class="modal-form-label">지점 수</label>
                <div class="modal-form-readonly" id="detailCoursePoints">-</div>
            </div>
            <div class="modal-form-group">
                <label class="modal-form-label">등록일</label>
                <div class="modal-form-readonly" id="detailCourseRegdate">-</div>
            </div>
        </div>
        <div class="map-modal-footer">
            <button type="button" class="modal-btn modal-btn-cancel" onclick="closeCourseDetailModal()">닫기</button>
            <button type="button" class="modal-btn modal-btn-save" onclick="viewCourseOnMap()">지도에서 보기</button>
        </div>
    </div>
</div>

<!-- 검색 결과 상세 정보 모달 -->
<div class="map-modal-overlay" id="searchResultDetailModal">
    <div class="map-modal">
        <div class="map-modal-header">
            <div class="map-modal-title">
                <i class="bi bi-geo-alt-fill"></i>
                <span>검색 장소 정보</span>
            </div>
            <button class="map-modal-close" onclick="closeSearchResultDetailModal()">
                <i class="bi bi-x-lg"></i>
            </button>
        </div>
        <div class="map-modal-body">
            <div class="modal-form-group">
                <label class="modal-form-label">장소 이름</label>
                <div class="modal-form-readonly" id="searchResultName">-</div>
            </div>
            <div class="modal-form-group">
                <label class="modal-form-label">카테고리</label>
                <div class="modal-form-readonly" id="searchResultCategory">-</div>
            </div>
            <div class="modal-form-group">
                <label class="modal-form-label">주소</label>
                <div class="modal-form-readonly" id="searchResultAddress">-</div>
            </div>
            <div class="modal-form-group">
                <label class="modal-form-label">집 주소</label>
                <div class="modal-form-readonly" id="searchResultHomeAddress">-</div>
            </div>
            <div class="modal-form-group">
                <label class="modal-form-label">거리</label>
                <div class="modal-form-readonly" id="searchResultDistance" style="color: #667eea; font-weight: 600; font-size: 16px;">-</div>
            </div>
            <div class="modal-form-group">
                <label class="modal-form-label">메모</label>
                <textarea class="modal-form-input" id="searchResultMemo" 
                          placeholder="이 장소에 대한 메모를 입력하세요 (선택사항)" 
                          rows="3" style="resize: vertical;"></textarea>
            </div>
        </div>
        <div class="map-modal-footer">
            <button type="button" class="modal-btn modal-btn-save" onclick="saveSearchResultLocation()">저장</button>
            <button type="button" class="modal-btn modal-btn-cancel" onclick="closeSearchResultDetailModal()">닫기</button>
        </div>
    </div>
</div>

<!-- 카카오맵 API (services 라이브러리 포함) -->
<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=${kakaoJsKey}&libraries=services"></script>
<!-- Map 관련 JavaScript 파일 -->
<script src="/js/homecenter/center.js"></script>
<script>
    // JSP 변수 - 노약자 정보
    var recipientAddress = '<c:out value="${recipient.recAddress}" escapeXml="false"/>';
    var recipientName = '<c:out value="${recipient.recName}" escapeXml="false"/>';
    var recipientPhotoUrl = '<c:out value="${recipient.recPhotoUrl}" escapeXml="false"/>';
    var defaultRecId = <c:choose><c:when test="${not empty recipient}">${recipient.recId}</c:when><c:otherwise>null</c:otherwise></c:choose>;
    
    // 저장된 마커들 표시 (JSP forEach 사용)
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
            
            // 외부 JS 파일의 함수 호출
            loadSavedMarkersWithData(savedMaps);
        }
    }
    
    // 페이지 로드 시 초기화
    window.addEventListener('load', function() {
        if (typeof kakao !== 'undefined' && kakao.maps) {
            initializeMap(); // 지도 초기화
            loadHomeMarker(); // 집 마커 표시
            loadSavedMarkers(); // 저장된 장소들 표시
            // 집 마커가 로드된 후 노약자 위치 마커 표시
            setTimeout(function() {
                loadRecipientLocationMarker();
            }, 1000); // 집 마커 로드 후 1초 뒤에 실행
        }
        
        // 일정 제목 길이 제한 적용
        if (typeof limitScheduleTitleLength === 'function') {
            limitScheduleTitleLength();
        }
        
        // 식단 메뉴 이름 길이 제한 적용
        if (typeof limitMealMenuLength === 'function') {
            limitMealMenuLength();
        }
        
        // 일정 목록 스크롤 설정 (5개 이상일 때만)
        if (typeof setupScheduleScroll === 'function') {
            setupScheduleScroll();
        }
    });
</script>
