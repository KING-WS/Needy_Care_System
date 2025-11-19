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
        background: radial-gradient(circle at top left, #f4f9ff 0, #f8fbff 40%, #fff9fb 100%);
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
        min-height: 150px;
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

    /* 건강 카드 스타일 */
    .health-card {
        background: radial-gradient(circle at top left, #f4f9ff 0, #f8fbff 40%, #fff9fb 100%);
        color: #333;
        text-align: left;
        padding: 20px;
        display: grid;
        grid-template-columns: auto 1fr;
        gap: 20px;
        align-items: start;
        border-radius: 15px;
    }

    .health-card-left {
        display: flex;
        flex-direction: column;
        align-items: center;
        gap: 10px;
        padding-right: 15px;
        border-right: 2px solid #e0e0e0;
    }

    .health-card-right {
        display: flex;
        flex-direction: column;
        gap: 15px;
    }

    .recipient-avatar {
        width: 80px;
        height: 80px;
        border-radius: 50%;
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 30px;
        color: white;
        flex-shrink: 0;
        box-shadow: 0 4px 12px rgba(102, 126, 234, 0.3);
        overflow: hidden;
        position: relative;
    }

    .avatar-image {
        width: 100%;
        height: 100%;
        object-fit: cover;
        border-radius: 50%;
    }

    .recipient-info {
        display: flex;
        flex-direction: column;
        gap: 5px;
        align-items: center;
        text-align: center;
    }

    .recipient-name {
        font-size: 16px;
        font-weight: 700;
        margin: 0;
        color: #2c3e50;
    }

    .recipient-badge {
        display: inline-block;
        padding: 4px 10px;
        border-radius: 12px;
        font-size: 11px;
        font-weight: 600;
        width: fit-content;
    }

    .badge-elderly {
        background: #e3f2fd;
        color: #1976d2;
    }

    .badge-pregnant {
        background: #fce4ec;
        color: #c2185b;
    }

    .badge-disabled {
        background: #f3e5f5;
        color: #7b1fa2;
    }

    .health-info-item {
        display: flex;
        align-items: center;
        gap: 10px;
    }

    .health-info-label {
        font-size: 11px;
        font-weight: 600;
        color: #666;
        min-width: 80px;
        text-align: left;
    }

    .health-value-text {
        font-size: 13px;
        font-weight: 600;
        color: #2c3e50;
        min-width: 50px;
        text-align: right;
    }

    .progress-bar-wrapper {
        flex: 1;
        background: #e9ecef;
        border-radius: 10px;
        height: 10px;
        overflow: hidden;
        position: relative;
    }

    .progress-bar-fill {
        height: 100%;
        border-radius: 10px;
        transition: width 0.3s ease;
    }

    .progress-blood-pressure {
        background: linear-gradient(90deg, #4a90e2 0%, #5ba3f5 100%);
    }

    .progress-blood-sugar {
        background: linear-gradient(90deg, #5cb85c 0%, #6fd76f 100%);
    }

    .progress-brightness {
        background: linear-gradient(90deg, #ff9f43 0%, #ffb66d 100%);
    }

    .no-data {
        text-align: center;
        padding: 20px;
        font-size: 13px;
        color: #999;
        display: flex;
        flex-direction: column;
        align-items: center;
        gap: 8px;
    }

    .no-data i {
        font-size: 32px;
        color: #ccc;
    }

    .health-card:hover {
        transform: translateY(-4px);
        box-shadow: 0 12px 28px rgba(102, 126, 234, 0.2);
    }

    /* 캘린더 카드 스타일 */
    .calendar-card {
        background: radial-gradient(circle at top left, #f4f9ff 0, #f8fbff 40%, #fff9fb 100%);
        padding: 20px;
        border-radius: 15px;
        display: flex;
        flex-direction: column;
        height: 100%;
        box-shadow: 0 8px 20px rgba(102, 126, 234, 0.15);
        cursor: pointer;
        transition: all 0.3s ease;
    }

    .calendar-card:hover {
        transform: translateY(-4px);
        box-shadow: 0 12px 28px rgba(102, 126, 234, 0.2);
    }

    .calendar-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 15px;
        padding-bottom: 12px;
        border-bottom: 2px solid #e0e7ff;
    }

    .calendar-title {
        font-size: 17px;
        font-weight: 700;
        color: #2c3e50;
        display: flex;
        align-items: center;
        gap: 8px;
    }

    .calendar-title i {
        color: #667eea;
        font-size: 20px;
    }

    .calendar-month {
        font-size: 13px;
        font-weight: 600;
        color: #667eea;
        background: #e0e7ff;
        padding: 4px 12px;
        border-radius: 20px;
    }

    .calendar-grid {
        display: grid;
        grid-template-columns: repeat(7, 1fr);
        gap: 5px;
        flex: 1;
    }

    .calendar-day-header {
        text-align: center;
        font-size: 10px;
        font-weight: 700;
        color: #667eea;
        padding: 5px 0;
        display: flex;
        align-items: center;
        justify-content: center;
    }

    .calendar-day {
        aspect-ratio: 1;
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 11px;
        border-radius: 8px;
        position: relative;
        cursor: pointer;
        transition: all 0.2s ease;
        max-height: 45px;
        color: #666;
        background: #e0e7ff; /* 일반 날짜 배경색 변경 */
    }

    .calendar-day:hover {
        background: #c7d2fe; /* 호버 시 조금 더 진한 색으로 변경 */
        color: #4338ca;
        transform: scale(1.05);
    }

    .calendar-day.empty {
        cursor: default;
        background: transparent;
    }

    .calendar-day.empty:hover {
        background: transparent;
        transform: none;
    }

    .calendar-day.today {
        background: #4d5eaa; /* 1. 가장 진한 색 */
        color: #ffffff;
        font-weight: 700;
        box-shadow: 0 4px 12px rgba(102, 126, 234, 0.3);
    }

    .calendar-day.today:hover {
        background: #4d5eaa;
        transform: scale(1.1);
    }

    .calendar-day.has-event {
        background: #667eea; /* 2. 중간 색 */
        color: #ffffff;
        font-weight: 700;
    }

    .calendar-day.has-event::after {
        content: '';
        position: absolute;
        bottom: 4px;
        width: 4px;
        height: 4px;
        border-radius: 50%;
        background: #667eea;
        box-shadow: 0 0 6px rgba(102, 126, 234, 0.5);
    }

    .calendar-day.today.has-event::after {
        background: #ffffff;
        box-shadow: 0 0 6px rgba(255, 255, 255, 0.8);
    }

    .calendar-footer {
        margin-top: 12px;
        padding-top: 12px;
        border-top: 2px solid #e0e7ff;
        display: flex;
        flex-direction: column;
        gap: 10px;
    }

    .calendar-stats {
        display: flex;
        justify-content: space-between;
        gap: 10px;
    }

    .calendar-stat-item {
        display: flex;
        flex-direction: column;
        align-items: center;
        gap: 3px;
        color: #667eea;
        font-size: 11px;
        font-weight: 600;
    }

    .calendar-stat-item i {
        font-size: 16px;
        color: #667eea;
    }

    .calendar-view-all {
        color: #667eea;
        font-size: 12px;
        font-weight: 600;
        display: flex;
        align-items: center;
        justify-content: center;
        gap: 5px;
        padding: 8px;
        background: #e0e7ff;
        border-radius: 8px;
        transition: all 0.3s ease;
    }

    .calendar-view-all:hover {
        background: #667eea;
        color: #ffffff;
    }

    .calendar-view-all i {
        font-size: 14px;
    }
</style>

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
