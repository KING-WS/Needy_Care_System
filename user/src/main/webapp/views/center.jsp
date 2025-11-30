<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
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
                                <i class="bi bi-heart-pulse-fill card-title-icon"></i>
<%--                                <div class="calendar-header">--%>
<%--                                    <div class="calendar-title">--%>
<%--                                        건강 정보--%>
<%--                                    </div>--%>
<%--                                </div>--%>
                                <div class="health-card-content">
                                <!-- 왼쪽: 프로필 정보 -->
                                <div class="health-card-left">
                                    <div class="recipient-avatar">
                                        <c:choose>
                                            <c:when test="${not empty recipient.recPhotoUrl}">
                                                    <c:set var="photoUrlWithCache" value="${recipient.recPhotoUrl}${fn:contains(recipient.recPhotoUrl, '?') ? '&' : '?'}v=${recipient.recId}"/>
                                                    <img src="<c:url value='${photoUrlWithCache}'/>" alt="${recipient.recName}" class="avatar-image" 
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
                            
                            // 일정이 있는 날짜를 Set으로 저장하고, 날짜별 일정 이름 목록을 Map으로 저장
                            Set<Integer> scheduleDays = new HashSet<>();
                            Map<Integer, List<String>> scheduleNamesByDay = new HashMap<>();
                            List schedules = (List) request.getAttribute("schedules");
                            if (schedules != null) {
                                for (Object obj : schedules) {
                                    edu.sm.app.dto.Schedule schedule = (edu.sm.app.dto.Schedule) obj;
                                    int day = schedule.getSchedDate().getDayOfMonth();
                                    scheduleDays.add(day);
                                    
                                    // 날짜별 일정 이름 목록 저장
                                    if (!scheduleNamesByDay.containsKey(day)) {
                                        scheduleNamesByDay.put(day, new ArrayList<>());
                                    }
                                    if (schedule.getSchedName() != null && !schedule.getSchedName().isEmpty()) {
                                        scheduleNamesByDay.get(day).add(schedule.getSchedName());
                                    }
                                }
                            }
                            pageContext.setAttribute("scheduleDays", scheduleDays);
                            pageContext.setAttribute("scheduleNamesByDay", scheduleNamesByDay);
                        %>
                        
                        <i class="bi bi-calendar-event card-title-icon"></i>
<%--                        <div class="calendar-header">--%>
<%--                            <div class="calendar-title">--%>
<%--                                일정--%>
<%--                            </div>--%>
<%--                            <div class="calendar-month">${currentYear}년 ${currentMonth}월</div>--%>
<%--                        </div>--%>
<%--                        --%>
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
                                <c:set var="daySchedules" value="${scheduleNamesByDay[day]}" />
                                <div class="calendar-day 
                                    ${day == currentDay ? 'today' : ''} 
                                    ${scheduleDays.contains(day) ? 'has-event' : ''}"
                                    <c:if test="${not empty daySchedules}">
                                        data-schedule-names="<c:forEach var="schedName" items="${daySchedules}" varStatus="status">${schedName}<c:if test="${!status.last}">|</c:if></c:forEach>"
                                    </c:if>>
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
                            <i class="fas fa-utensils card-title-icon"></i>
                            <div class="calendar-header">
                                <div class="calendar-title">
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
                    <div class="dashboard-card card-medium schedule-card">
                        <i class="bi bi-clock-history card-title-icon"></i>
                        <div class="calendar-header">
                            <div class="calendar-title">
                                오늘의 시간표
                            </div>
                            <div class="calendar-month">
                                <c:set var="today" value="<%=java.time.LocalDate.now()%>"/>
                                ${today.monthValue}월 ${today.dayOfMonth}일
                            </div>
                            <button type="button" class="btn-add-schedule" onclick="openTodayScheduleModal();">
                                <i class="fas fa-plus"></i>
                            </button>
                        </div>
                        
                        <div class="hourly-schedule-list">
                            <c:choose>
                                <c:when test="${not empty todayHourlySchedules}">
                                    <c:forEach var="hourly" items="${todayHourlySchedules}">
                                            <div class="hourly-schedule-item">
                                                <div class="hourly-time">
                                                    <c:if test="${not empty hourly.hourlySchedStartTime}">
                                                    ${fn:substring(hourly.hourlySchedStartTime, 0, 5)}
                                                    </c:if>
                                                    <c:if test="${not empty hourly.hourlySchedEndTime}">
                                                    ~ ${fn:substring(hourly.hourlySchedEndTime, 0, 5)}
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
                                    <span>케어 지도</span>

                                </div>
                                <div class="map-address-panel" id="mapLocationList">
                                    <div class="map-location-items">
                                        <!-- 노약자 집 주소 (항상 표시, 고정) -->
                                        <c:if test="${not empty recipient && not empty recipient.recAddress}">
                                            <div class="map-location-item home-location" onclick="focusHomeMarker()">
                                                <div class="location-info">
                                                    <div class="location-name-wrapper">
                                                        <div class="location-name" style="font-weight: 600;">
                                                        ${recipient.recName}님의 집
                                                    </div>
                                                        <div class="location-category">집</div>
                                                    </div>
                                                </div>
                                                    <div class="location-address">
                                                        ${recipient.recAddress}
                                                    </div>
                                                </div>
                                        
                                        <!-- 구분선 -->
                                            <c:if test="${not empty maps}">
                                                <div class="home-location-divider"></div>
                                            </c:if>
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
                                                        <div class="location-info">
                                                            <div class="location-name-wrapper">
                                                            <div class="location-name">${map.mapName}</div>
                                                            <div class="location-category">${map.mapCategory}</div>
                                                            </div>
                                                        </div>
                                                        <div class="location-address" data-lat="${map.mapLatitude}" data-lng="${map.mapLongitude}">
                                                            주소 조회 중...
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
                                        <!-- 산책코스 모드일 때만 표시되는 저장 버튼 -->
                                        <button type="button" id="courseSaveBtn" class="map-tab course-save-btn" onclick="saveCourse()" style="display: none; margin-left: 10px; background: #667eea; border-color: #667eea; color: white;">
                                            <i class="fas fa-save"></i>
                                            <span>산책코스 저장</span>
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

<!-- SockJS & StompJS for real-time location -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/sockjs-client/1.6.1/sockjs.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/stomp.js/2.3.3/stomp.min.js"></script>

<!-- Map 관련 JavaScript 파일 -->
<script src="/js/homecenter/center.js"></script>
<script>
    // JSP 변수 - 노약자 정보
    var recipientAddress = '<c:out value="${recipient.recAddress}" escapeXml="false"/>';
    var recipientName = '<c:out value="${recipient.recName}" escapeXml="false"/>';
    <c:choose>
        <c:when test="${not empty recipient.recPhotoUrl}">
            <c:set var="jsPhotoUrl" value="${recipient.recPhotoUrl}${fn:contains(recipient.recPhotoUrl, '?') ? '&' : '?'}v=${recipient.recId}"/>
            var recipientPhotoUrl = '<c:out value="${jsPhotoUrl}" escapeXml="false"/>';
        </c:when>
        <c:otherwise>
            var recipientPhotoUrl = '';
        </c:otherwise>
    </c:choose>
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
    
    // 태그 active 상태 설정 함수
    function setActiveTag(buttonElement) {
        // 모든 버튼에서 active 클래스 제거
        document.querySelectorAll('.schedule-tag').forEach(function(tag) {
            tag.classList.remove('active');
            tag.style.background = '#fff';
            tag.style.color = '#333';
        });
        
        // 클릭된 버튼에 active 클래스 추가
        if (buttonElement) {
            buttonElement.classList.add('active');
            buttonElement.style.background = '#3498db';
            buttonElement.style.color = '#fff';
        }
    }
    
    // 일정 전환 함수
    function switchSchedule(schedId, buttonElement) {
        // 태그 active 상태 설정
        setActiveTag(buttonElement);
        
        // 해당 일정의 시간표만 표시
        var allItems = document.querySelectorAll('.hourly-schedule-item');
        var hasVisibleItem = false;
        
        allItems.forEach(function(item) {
            var itemSchedId = item.getAttribute('data-sched-id');
            if (itemSchedId == schedId) {
                item.style.display = 'flex';
                hasVisibleItem = true;
            } else {
                item.style.display = 'none';
            }
        });
        
        // 일정이 없을 경우 빈 메시지 표시
        var emptyDiv = document.querySelector('.hourly-empty');
        if (!hasVisibleItem) {
            if (!emptyDiv) {
                var listDiv = document.getElementById('hourlyScheduleList');
                listDiv.innerHTML = '<div class="hourly-empty"><i class="bi bi-calendar-x"></i><span>선택한 일정에 시간표가 없습니다</span></div>';
            }
        } else if (emptyDiv) {
            emptyDiv.remove();
        }
    }
    
    // 모든 시간표 표시 함수
    function showAllSchedules() {
        var allItems = document.querySelectorAll('.hourly-schedule-item');
        var hasVisibleItem = false;
        
        allItems.forEach(function(item) {
            item.style.display = 'flex';
            hasVisibleItem = true;
        });
        
        // 빈 메시지 제거
        var emptyDiv = document.querySelector('.hourly-empty');
        if (emptyDiv && hasVisibleItem) {
            emptyDiv.remove();
        }
        
        // "전체" 태그를 active로 설정
        var allTag = document.querySelector('.schedule-tag[data-sched-id="all"]');
        if (allTag) {
            setActiveTag(allTag);
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
                // 함수가 존재할 때만 실행하도록 변경
                if (typeof loadRecipientLocationMarker === 'function') {
                    loadRecipientLocationMarker();
                } else {
                    console.warn('loadRecipientLocationMarker 함수를 찾을 수 없습니다.');
                }
            }, 1000);
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
        
        // 초기 로드 시 모든 시간표 표시 (필터링하지 않음)
        showAllSchedules();
        
        // 여러 일정이 있을 경우에만 태그 표시 (기본적으로 모든 시간표 보여줌)
        var scheduleTags = document.querySelectorAll('.schedule-tag');
        if (scheduleTags.length > 1) {
            // 여러 일정이 있을 때는 첫 번째 일정 태그를 active로 설정하되, 모든 시간표는 표시
            var firstScheduleTag = document.querySelector('.schedule-tag.active');
            if (firstScheduleTag) {
                // 태그는 active 상태 유지하지만 시간표는 모두 표시
                showAllSchedules();
            }
        }
        
        // 디버깅: 시간표 개수 확인
        var hourlyItems = document.querySelectorAll('.hourly-schedule-item');
        console.log('시간표 개수:', hourlyItems.length);
        hourlyItems.forEach(function(item, index) {
            console.log('시간표 ' + index + ':', {
                schedId: item.getAttribute('data-sched-id'),
                name: item.querySelector('.hourly-name') ? item.querySelector('.hourly-name').textContent : 'N/A',
                display: item.style.display || 'default'
            });
        });
        
        // 저장된 장소들의 주소 가져오기
        loadMapLocationAddresses();
        
        // 캘린더 일정 툴팁 설정
        setupCalendarScheduleTooltips();
    });
    
    // 캘린더 일정 툴팁 설정 함수
    function setupCalendarScheduleTooltips() {
        var calendarDays = document.querySelectorAll('.calendar-day[data-schedule-names]');
        
        calendarDays.forEach(function(day) {
            var scheduleNames = day.getAttribute('data-schedule-names');
            if (!scheduleNames) return;
            
            // 일정 이름들을 |로 분리
            var schedules = scheduleNames.split('|');
            
            // 마우스 오버 시 툴팁 생성
            day.addEventListener('mouseenter', function(e) {
                // 기존 툴팁 제거
                var existingTooltip = day.querySelector('.calendar-schedule-tooltip');
                if (existingTooltip) {
                    existingTooltip.remove();
                }
                
                // 툴팁 생성
                var tooltip = document.createElement('ul');
                tooltip.className = 'calendar-schedule-tooltip';
                
                schedules.forEach(function(scheduleName) {
                    if (scheduleName.trim()) {
                        var li = document.createElement('li');
                        li.textContent = scheduleName.trim();
                        tooltip.appendChild(li);
                    }
                });
                
                day.appendChild(tooltip);
            });
            
            // 마우스 아웃 시 툴팁 제거
            day.addEventListener('mouseleave', function(e) {
                var tooltip = day.querySelector('.calendar-schedule-tooltip');
                if (tooltip) {
                    tooltip.remove();
                }
            });
        });
    }
    
    // 저장된 장소들의 주소를 가져와서 표시하는 함수
    function loadMapLocationAddresses() {
        if (typeof kakao === 'undefined' || !kakao.maps || !kakao.maps.services) {
            return;
        }
        
        var geocoder = new kakao.maps.services.Geocoder();
        var addressElements = document.querySelectorAll('.map-location-item .location-address[data-lat][data-lng]');
        
        addressElements.forEach(function(element) {
            var lat = parseFloat(element.getAttribute('data-lat'));
            var lng = parseFloat(element.getAttribute('data-lng'));
            
            if (isNaN(lat) || isNaN(lng)) {
                element.textContent = '주소 정보 없음';
                return;
            }
            
            // 좌표를 주소로 변환
            geocoder.coord2Address(lng, lat, function(result, status) {
                if (status === kakao.maps.services.Status.OK) {
                    var addr = result[0].address.address_name;
                    element.textContent = addr;
                } else {
                    element.textContent = '위도: ' + lat.toFixed(6) + ', 경도: ' + lng.toFixed(6);
                }
            });
        });
    }

    // --- 실시간 위치 업데이트 스크립트 ---
    document.addEventListener('DOMContentLoaded', function() {
        if (defaultRecId && typeof Stomp !== 'undefined') {
            connectAndSubscribeForLocation();
        } else {
            console.log("실시간 위치 업데이트를 위한 사용자 정보 또는 Stomp 라이브러리를 찾을 수 없습니다.");
        }
    });

    function connectAndSubscribeForLocation() {
        const socket = new SockJS('/adminchat'); // 서버의 STOMP 엔드포인트
        const stompClient = Stomp.over(socket);
        stompClient.debug = null; // 디버그 로그 비활성화

        stompClient.connect({}, function (frame) {
            console.log('✅ Real-time location WS Connected: ' + frame);
            
            // recipient-specific 토픽 구독
            const topic = '/topic/location/' + defaultRecId;
            stompClient.subscribe(topic, function (message) {
                try {
                    const locationData = JSON.parse(message.body);
                    console.log('📍 Real-time Location:', locationData);

                    // center.js에 정의된 마커 이동 함수 호출
                    if (typeof updateRecipientMarker === 'function') {
                        updateRecipientMarker(locationData.latitude, locationData.longitude);
                    } else {
                        // 함수가 없으면 직접 이동 (비상용)
                        moveMarkerDirectly(locationData.latitude, locationData.longitude);
                    }
                    
                } catch (e) {
                    console.error('위치 데이터 파싱 오류:', e);
                }
            });
        }, function(error) {
            console.log('⚠️ 위치 정보 소켓 연결이 끊겼습니다. 5초 후 재연결합니다...');
            setTimeout(connectAndSubscribeForLocation, 5000);
        });
    }
</script>

<!-- 오늘의 일정 목록 모달 -->
<div class="map-modal-overlay" id="todayScheduleListModal">
    <div class="map-modal">
        <div class="map-modal-header">
            <div class="map-modal-title">
                <i class="fas fa-calendar-day"></i>
                <span>오늘의 일정 목록</span>
            </div>
            <button class="map-modal-close" onclick="closeTodayScheduleListModal()">
                <i class="bi bi-x-lg"></i>
            </button>
        </div>
        <div class="map-modal-body" id="todayScheduleListBody" style="max-height: 400px; overflow-y: auto;">
            <div id="todayScheduleListContent">
                <!-- 일정 목록이 여기에 동적으로 로드됩니다 -->
            </div>
        </div>
        <div class="map-modal-footer">
            <button type="button" class="modal-btn modal-btn-cancel" onclick="closeTodayScheduleListModal()">
                <i class="fas fa-times"></i> 닫기
            </button>
        </div>
    </div>
</div>

<!-- 시간대별 일정 추가 모달 -->
<div class="map-modal-overlay" id="hourlyScheduleModal">
    <div class="map-modal">
        <div class="map-modal-header">
            <div class="map-modal-title" id="hourlyScheduleModalTitle">
                <i class="fas fa-plus-circle"></i>
                <span>시간대별 일정 추가</span>
            </div>
            <button class="map-modal-close" onclick="closeHourlyScheduleModal()">
                <i class="bi bi-x-lg"></i>
            </button>
        </div>
        <div class="map-modal-body">
            <form id="hourlyScheduleForm">
                <input type="hidden" id="hourlyScheduleSchedId">
                <input type="hidden" id="hourlyScheduleParentSchedId">

                <div class="modal-form-group">
                    <label class="modal-form-label">
                        <i class="fas fa-heading"></i> 제목<span class="required">*</span>
                    </label>
                    <input type="text" class="modal-form-input" id="hourlyScheduleName" placeholder="예: 점심 식사" required>
                </div>

                <div class="modal-form-group">
                    <label class="modal-form-label">
                        <i class="fas fa-clock"></i> 시작 시간<span class="required">*</span>
                    </label>
                    <div style="display: flex; gap: 10px;">
                        <select id="hourlyScheduleStartHour" class="modal-form-select" style="flex: 1;"></select>
                        <select id="hourlyScheduleStartMinute" class="modal-form-select" style="flex: 1;"></select>
                    </div>
                </div>

                <div class="modal-form-group">
                    <label class="modal-form-label">
                        <i class="fas fa-clock"></i> 종료 시간<span class="required">*</span>
                    </label>
                    <div style="display: flex; gap: 10px;">
                        <select id="hourlyScheduleEndHour" class="modal-form-select" style="flex: 1;"></select>
                        <select id="hourlyScheduleEndMinute" class="modal-form-select" style="flex: 1;"></select>
                    </div>
                </div>

                <div class="modal-form-group">
                    <label class="modal-form-label">
                        <i class="fas fa-align-left"></i> 상세 내용
                    </label>
                    <textarea class="modal-form-textarea" id="hourlyScheduleContent" rows="3" placeholder="상세 내용을 입력하세요"></textarea>
                </div>
            </form>
        </div>
        <div class="map-modal-footer">
            <button type="button" class="modal-btn modal-btn-cancel" onclick="closeHourlyScheduleModal()">
                <i class="fas fa-times"></i> 취소
            </button>
            <button type="button" class="modal-btn modal-btn-save" id="saveHourlyScheduleBtn">
                <i class="fas fa-save"></i> 저장
            </button>
        </div>
    </div>
</div>

<script>
    // 시간 선택 옵션 채우기
    function populateTimeSelects() {
        const hourSelects = [
            document.getElementById('hourlyScheduleStartHour'),
            document.getElementById('hourlyScheduleEndHour')
        ];
        const minuteSelects = [
            document.getElementById('hourlyScheduleStartMinute'),
            document.getElementById('hourlyScheduleEndMinute')
        ];

        for (let i = 0; i < 24; i++) {
            const hour = String(i).padStart(2, '0');
            hourSelects.forEach(sel => {
                if (sel) sel.add(new Option(hour, hour));
            });
        }
        for (let i = 0; i < 60; i++) {
            const minute = String(i).padStart(2, '0');
            minuteSelects.forEach(sel => {
                if (sel) sel.add(new Option(minute, minute));
            });
        }
    }

    // 플러스 버튼 클릭 시 일정 확인 후 모달 열기
    function openTodayScheduleModal() {
        const today = new Date();
        const todayStr = today.getFullYear() + '-' + 
                        String(today.getMonth() + 1).padStart(2, '0') + '-' + 
                        String(today.getDate()).padStart(2, '0');
        
        // recId 가져오기
        const recId = defaultRecId;
        if (!recId) {
            alert('돌봄 대상자를 선택해주세요.');
            return;
        }

        // 오늘의 일정 확인
        const url = '/schedule/api/monthly?recId=' + recId + '&startDate=' + todayStr + '&endDate=' + todayStr;
        
        console.log('일정 조회 URL:', url);
        
        fetch(url)
            .then(res => {
                console.log('응답 상태:', res.status, res.statusText);
                return res.json().then(data => {
                    if (!res.ok) {
                        throw new Error(data.message || '일정 조회 실패');
                    }
                    // 에러 응답인지 확인 (success: false 형태)
                    if (data.success === false) {
                        throw new Error(data.message || '일정 조회 실패');
                    }
                    return data;
                });
            })
            .then(data => {
                // data가 배열인지 확인
                const schedules = Array.isArray(data) ? data : [];
                console.log('조회된 일정 개수:', schedules.length);
                
                if (schedules.length === 0) {
                    // 일정이 없으면 자동 생성 후 시간표 추가 모달 열기
                    createTodaySchedule(recId, todayStr, '오늘의 일정');
                } else if (schedules.length === 1) {
                    // 일정이 1개면 바로 시간표 추가 모달 열기
                    const schedId = schedules[0].schedId;
                    const schedName = schedules[0].schedName || '오늘의 일정';
                    openHourlyScheduleModal(schedId, schedName);
                } else {
                    // 일정이 2개 이상이면 일정 선택 모달 표시
                    showScheduleSelectionModal(schedules);
                }
            })
            .catch(error => {
                console.error('일정 확인 실패:', error);
                console.error('에러 상세:', error.stack);
                alert('일정을 확인하는 중 오류가 발생했습니다: ' + (error.message || '알 수 없는 오류'));
            });
    }

    // 일정 선택 모달 표시
    function showScheduleSelectionModal(schedules) {
        const container = document.getElementById('todayScheduleListContent');
        let html = '';
        schedules.forEach(function(schedule) {
            html += '<div class="modal-form-group" style="cursor: pointer; padding: 15px; border: 2px solid #ecf0f1; border-radius: 10px; margin-bottom: 15px; transition: all 0.3s ease;" ';
            html += 'onclick="selectScheduleForHourly(' + schedule.schedId + ', \'' + (schedule.schedName || '제목 없음').replace(/'/g, "\\'") + '\');" ';
            html += 'onmouseover="this.style.borderColor=\'#667eea\'; this.style.backgroundColor=\'#f8f9ff\';" ';
            html += 'onmouseout="this.style.borderColor=\'#ecf0f1\'; this.style.backgroundColor=\'transparent\';">';
            html += '<div style="font-weight: 600; color: #2c3e50; font-size: 16px; margin-bottom: 5px;">' + (schedule.schedName || '제목 없음') + '</div>';
            if (schedule.schedStartTime) {
                html += '<div style="color: #667eea; font-size: 13px;">시작: ' + schedule.schedStartTime.substring(0, 5) + '</div>';
            }
            html += '</div>';
        });
        container.innerHTML = html;

        // 일정 선택 모달 열기
        document.getElementById('todayScheduleListModal').classList.add('show');
    }

    // 오늘의 일정 목록 모달 닫기
    function closeTodayScheduleListModal() {
        document.getElementById('todayScheduleListModal').classList.remove('show');
    }

    // 오늘의 일정 자동 생성
    function createTodaySchedule(recId, todayStr, schedName) {
        const data = {
            recId: recId,
            schedName: schedName,
            schedDate: todayStr
        };

        fetch('/schedule/api/schedule', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify(data)
        })
        .then(res => res.json())
        .then(result => {
            if (result.success && result.schedule) {
                const schedId = result.schedule.schedId;
                openHourlyScheduleModal(schedId, schedName);
            } else {
                alert('일정 생성에 실패했습니다: ' + (result.message || '알 수 없는 오류'));
            }
        })
        .catch(error => {
            console.error('일정 생성 실패:', error);
            alert('일정 생성 중 오류가 발생했습니다.');
        });
    }

    // 일정 선택하여 시간표 추가 모달 열기
    function selectScheduleForHourly(schedId, schedName) {
        document.getElementById('hourlyScheduleParentSchedId').value = schedId;
        const titleElement = document.getElementById('hourlyScheduleModalTitle');
        titleElement.innerHTML = '<i class="fas fa-plus-circle"></i><span>시간대별 일정 추가 - ' + schedName + '</span>';
        
        // 폼 초기화
        document.getElementById('hourlyScheduleSchedId').value = '';
        document.getElementById('hourlyScheduleName').value = '';
        document.getElementById('hourlyScheduleStartHour').value = '00';
        document.getElementById('hourlyScheduleStartMinute').value = '00';
        document.getElementById('hourlyScheduleEndHour').value = '00';
        document.getElementById('hourlyScheduleEndMinute').value = '00';
        document.getElementById('hourlyScheduleContent').value = '';

        // 일정 선택 모달 닫기
        closeTodayScheduleListModal();

        // 시간표 추가 모달 열기
        setTimeout(() => {
            document.getElementById('hourlyScheduleModal').classList.add('show');
        }, 300);
    }

    // 시간표 추가 모달 열기 (내부 함수)
    function openHourlyScheduleModal(schedId, schedName) {
        selectScheduleForHourly(schedId, schedName);
    }

    // 시간표 추가 모달 닫기
    function closeHourlyScheduleModal() {
        document.getElementById('hourlyScheduleModal').classList.remove('show');
    }

    // 시간대별 일정 저장
    document.addEventListener('DOMContentLoaded', function() {
        populateTimeSelects();
        
        document.getElementById('saveHourlyScheduleBtn').addEventListener('click', function() {
            const form = document.getElementById('hourlyScheduleForm');
            if (!form.checkValidity()) {
                form.reportValidity();
                return;
            }

            const parentSchedId = document.getElementById('hourlyScheduleParentSchedId').value;
            const hourlySchedId = document.getElementById('hourlyScheduleSchedId').value;
            const name = document.getElementById('hourlyScheduleName').value;
            const startHour = document.getElementById('hourlyScheduleStartHour').value;
            const startMinute = document.getElementById('hourlyScheduleStartMinute').value;
            const endHour = document.getElementById('hourlyScheduleEndHour').value;
            const endMinute = document.getElementById('hourlyScheduleEndMinute').value;
            const content = document.getElementById('hourlyScheduleContent').value;

            const startTime = startHour + ':' + startMinute + ':00';
            const endTime = endHour + ':' + endMinute + ':00';

            const data = {
                hourlySchedId: hourlySchedId || null,
                schedId: parentSchedId,
                hourlySchedName: name,
                hourlySchedStartTime: startTime,
                hourlySchedEndTime: endTime,
                hourlySchedContent: content
            };

            const method = hourlySchedId ? 'PUT' : 'POST';
            const url = hourlySchedId ? 
                '/schedule/api/hourly/' + hourlySchedId : 
                '/schedule/api/hourly';

            fetch(url, {
                method: method,
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify(data)
            })
            .then(res => res.json())
            .then(result => {
                if (result.success) {
                    alert('시간대별 일정이 저장되었습니다.');
                    closeHourlyScheduleModal();
                    // 페이지 새로고침하여 변경사항 반영
                    location.reload();
                } else {
                    alert('저장에 실패했습니다: ' + (result.message || '알 수 없는 오류'));
                }
            })
            .catch(error => {
                console.error('시간대별 일정 저장 실패:', error);
                alert('시간대별 일정 저장 중 오류가 발생했습니다.');
            });
        });
    });
</script>
