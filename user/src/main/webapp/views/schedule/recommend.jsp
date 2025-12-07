<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<spring:eval expression="@environment.getProperty('app.api.kakao-js-key')" var="kakaoJsKey"/>

<link rel="stylesheet" href="<c:url value='/css/center.css'/>" />

<style>
    /* 지도 탭 버튼 스타일 (center.jsp와 동일하게) */
    .map-tab {
        background: #f1f3f5 !important; /* 비활성 탭: 중립적인 배경 */
        color: #495057 !important;     /* 비활성 탭: 어두운 텍스트 */
        border: 1px solid #dee2e6 !important;
        border-radius: 12px !important;
        padding: 10px 20px !important;
        font-weight: 700 !important;
        font-size: 14px !important;
        box-shadow: none !important;
        transition: all 0.2s ease !important;
    }
    .map-tab:hover:not(.active) {
        background: #e9ecef !important; /* 비활성 탭 호버 효과 */
    }
    .map-tab.active {
        background: #3498db !important; /* 활성 탭: 요청된 색상 */
        color: white !important;
        border-color: transparent !important;
        box-shadow: none !important;
    }
    .map-tab.active:hover {
        background: #2980b9 !important; /* 활성 탭 호버: 약간 어둡게 */
    }

    /* =========================================
       1. 기본 모달 및 공통 스타일
       ========================================= */
    .modal { z-index: 10055 !important; }
    .modal-backdrop { z-index: 10050 !important; }

    /* =========================================
       2. AI 추천 카드 스타일 (왼쪽 목록)
       ========================================= */
    .recommend-card {
        transition: transform 0.3s ease-in-out, box-shadow 0.3s ease-in-out;
        height: 100%;
        border: none;
        border-radius: 15px;
        overflow: hidden;
        box-shadow: 0 4px 15px rgba(0,0,0,0.05);
    }
    .recommend-card:hover {
        transform: translateY(-5px);
        box-shadow: 0 15px 30px rgba(0,0,0,0.1);
    }
    .card-header-custom {
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        color: white;
        padding: 15px;
        border-bottom: none;
    }
    .badge-category {
        background-color: rgba(255,255,255,0.2);
        padding: 5px 10px;
        border-radius: 20px;
        font-size: 0.8rem;
    }
    .btn-map {
        background-color: #fee500;
        color: #191919;
        border: none;
        font-weight: 600;
        font-size: 0.9rem;
        padding: 8px 15px;
    }
    .btn-map:hover { background-color: #fdd835; }

    .btn-outline-secondary {
        border: 1px solid #ced4da;
        color: #6c757d;
        font-weight: 600;
        font-size: 0.9rem;
        padding: 8px 15px;
        min-width: 0;
    }
    .btn-outline-secondary:hover {
        background-color: #e9ecef;
        color: #495057;
    }

    /* 카드 내부 일정 추가 버튼 - center.css 스타일 덮어쓰기 */
    .recommend-card .btn-add-schedule,
    .recommend-card .btn.btn-primary.btn-add-schedule,
    #recommendation-results .btn-add-schedule,
    #recommendation-results .btn.btn-primary.btn-add-schedule {
        background: #667eea !important; /* 단색 적용 (수정 버튼과 통일감) */
        border: none !important;
        border-color: #667eea !important;
        color: white !important;
        font-weight: 600 !important;
        padding: 12px 15px !important;
        border-radius: 10px !important; /* center.css의 50% 덮어쓰기 */
        box-shadow: 0 4px 6px rgba(102, 126, 234, 0.2) !important;
        transition: all 0.3s ease !important;
        width: auto !important; /* center.css의 32px 덮어쓰기 */
        height: auto !important; /* center.css의 32px 덮어쓰기 */
        display: block !important; /* center.css의 flex 덮어쓰기 */
        align-items: unset !important;
        justify-content: unset !important;
        position: static !important;
        margin: 0 !important;
    }
    .recommend-card .btn-add-schedule:hover,
    .recommend-card .btn-add-schedule:focus,
    .recommend-card .btn-add-schedule:active,
    .recommend-card .btn.btn-primary.btn-add-schedule:hover,
    .recommend-card .btn.btn-primary.btn-add-schedule:focus,
    .recommend-card .btn.btn-primary.btn-add-schedule:active,
    #recommendation-results .btn-add-schedule:hover,
    #recommendation-results .btn-add-schedule:focus,
    #recommendation-results .btn-add-schedule:active,
    #recommendation-results .btn.btn-primary.btn-add-schedule:hover,
    #recommendation-results .btn.btn-primary.btn-add-schedule:focus,
    #recommendation-results .btn.btn-primary.btn-add-schedule:active {
        background: #5a6fd6 !important;
        border-color: #5a6fd6 !important;
        transform: translateY(-2px) !important; /* center.css의 scale(1.1) 덮어쓰기 */
        box-shadow: 0 6px 15px rgba(102, 126, 234, 0.3) !important;
        color: white !important;
    }
    /* center.css의 아이콘 스타일도 덮어쓰기 */
    .recommend-card .btn-add-schedule i,
    #recommendation-results .btn-add-schedule i {
        color: white !important;
        font-size: inherit !important;
        line-height: inherit !important;
        margin: 0 !important;
        padding: 0 !important;
        display: inline !important;
        position: static !important;
        top: auto !important;
        left: auto !important;
        transform: none !important;
    }

    .summary-content {
        display: none;
        background-color: #f8f9fa;
        padding: 15px;
        border-radius: 10px;
        margin-top: 15px;
        font-size: 0.95rem;
        line-height: 1.6;
        border-left: 4px solid #667eea;
    }

    /* =========================================
       3. 모달 커스텀 디자인
       ========================================= */
    #addScheduleModal .modal-content { border-radius: 20px; border: none; box-shadow: 0 10px 30px rgba(0,0,0,0.1); }
    #addScheduleModal .modal-header { background: #fff; border-bottom: none; padding: 25px 25px 10px 25px; }
    #addScheduleModal .modal-title { font-weight: 800; color: #333; font-size: 1.4rem; display: flex; align-items: center; gap: 10px; }
    .title-icon { color: #667eea; font-size: 1.6rem; }
    .btn-close-custom { background-color: #f1f3f5; border-radius: 50%; padding: 10px; opacity: 0.8; transition: all 0.3s ease; transform: rotate(0deg); }
    .btn-close-custom:hover { opacity: 1; background-color: #e9ecef; transform: rotate(90deg); }

    .form-label-custom { font-weight: 700; color: #495057; font-size: 0.95rem; margin-bottom: 8px; display: flex; align-items: center; gap: 8px; }
    .form-label-icon { color: #667eea; }
    .form-control-custom { border: 1px solid #e9ecef; border-radius: 12px; padding: 12px 15px; font-size: 0.95rem; background-color: #fff; transition: border-color 0.2s; }
    .form-control-custom:focus { border-color: #667eea; box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1); }
    .form-control-custom[readonly] { background-color: #f8f9fa; color: #666; }
    .required-star { color: #ff6b6b; margin-left: 2px; }

    #addScheduleModal .modal-footer { border-top: none; background: #fff; padding: 10px 25px 25px 25px; }
    .btn-modal-cancel { background-color: #f1f3f5; color: #495057; border: none; border-radius: 10px; padding: 10px 20px; font-weight: 600; }
    .btn-modal-save { background: #667eea; color: white; border: none; border-radius: 10px; padding: 10px 30px; font-weight: 600; box-shadow: 0 4px 10px rgba(102, 126, 234, 0.3); }
    .btn-modal-save:hover { background: #5a6fd6; transform: translateY(-2px); box-shadow: 0 6px 15px rgba(102, 126, 234, 0.4); }

    .ai-info-box { background-color: #f3f0ff; border-radius: 15px; padding: 20px; margin-bottom: 25px; border: 1px solid #e0d4fc; }
    .ai-info-title { color: #667eea; font-weight: 700; margin-bottom: 10px; display: flex; align-items: center; gap: 8px; }

    /* 💡 [수정] 맞춤 추천 버튼: 이모지 제거 및 수정 버튼 색상 적용 */
    .btn-recommend-ai {
        background: #667eea; /* 요청하신 수정 버튼 색상 (단색) */
        color: white;
        border: none;
        border-radius: 12px; /* 살짝 둥근 사각형 */
        padding: 0 20px;
        font-weight: 700;
        font-size: 0.95rem;
        height: 48px;
        white-space: nowrap;
        box-shadow: none;
        transition: all 0.2s ease;
        display: flex;
        align-items: center;
        justify-content: center;
    }
    .btn-recommend-ai:hover {
        background-color: #5a6fd6;
        box-shadow: none;
        color: white;
    }
    .btn-recommend-ai:active {
        background-color: #4e63bb; /* Original #667eea -> hover #5a6fd6 -> active #4e63bb */
        box-shadow: none;
    }

    /* 💡 [수정] 오버레이(상태창) 내부 일정 추가 버튼 (스타일 재정의) */
    .btn-add-schedule-overlay {
        display: block;
        margin-top: 12px;
        background: #667eea; /* 수정 버튼과 동일 색상 */
        color: white;
        border: none;
        padding: 10px 0;
        border-radius: 8px; /* 둥근 모서리 */
        cursor: pointer;
        width: 100%;
        font-size: 14px;
        font-weight: 600;
        text-align: center;
        box-shadow: 0 2px 5px rgba(102,126,234,0.2);
        transition: all 0.2s;
    }

    /* 💡 [수정] 커스텀 오버레이 (심플한 디자인, 이모지 제거) */
    .custom-overlay-wrap {
        position: absolute;
        bottom: 50px;
        left: -125px;
        width: 250px;
        background: #fff;
        border-radius: 15px; /* 둥근 모서리 */
        box-shadow: 0 5px 20px rgba(0,0,0,0.15);
        overflow: hidden;
        font-family: 'Malgun Gothic', dotum, '돋움', sans-serif;
        animation: fadeIn 0.3s ease-out;
        z-index: 1000;
        border: 1px solid #f0f0f0;
    }

    .custom-overlay-header {
        background: #fff; /* 헤더 흰색 배경으로 심플하게 */
        padding: 12px 15px;
        color: #333;
        font-weight: 800;
        font-size: 15px;
        display: flex;
        justify-content: space-between;
        align-items: center;
        border-bottom: 1px solid #f0f0f0;
    }

    .custom-overlay-close {
        cursor: pointer;
        color: #999;
        font-size: 18px;
        transition: color 0.2s;
    }
    .custom-overlay-close:hover { color: #333; }

    .custom-overlay-body {
        padding: 15px;
        text-align: center;
        background: #fff;
    }

    .custom-overlay-category {
        display: inline-block;
        padding: 4px 12px;
        background: #f3f0ff; /* 연한 보라색 배경 */
        color: #667eea; /* 글자색 강조 */
        border-radius: 20px;
        font-size: 12px;
        margin-bottom: 10px;
        font-weight: 700;
    }

    @keyframes fadeIn {
        from { opacity: 0; transform: translateY(10px); }
        to { opacity: 1; transform: translateY(0); }
    }

    /* 검색 입력 필드와 버튼 스타일 수정 */
    .map-search-wrapper {
        position: relative !important;
        width: 100% !important;
        max-width: 100% !important;
        min-width: 0 !important;
    }

    .map-search-input {
        padding-right: 130px !important; /* 버튼 3개를 위한 공간 확보 */
        width: 100% !important;
        max-width: 100% !important;
        min-width: 0 !important;
        box-sizing: border-box !important;
        overflow: hidden !important;
        text-overflow: ellipsis !important;
        white-space: nowrap !important;
    }

    /* 검색 컨테이너 반응형 처리 - center.css의 max-width 제한 제거 */
    .map-search-container.ai-recommend-search {
        width: 100% !important;
        max-width: 100% !important;
        min-width: 0 !important;
        flex: 1 !important;
    }

    /* 입력 필드의 텍스트가 버튼 영역을 침범하지 않도록 */
    .map-search-input:focus {
        padding-right: 130px !important;
    }

    /* 검색 버튼들을 입력 필드 안에 완전히 배치 */
    .map-search-btn {
        position: absolute !important;
        top: 50% !important;
        transform: translateY(-50%) !important;
        z-index: 10 !important;
        margin: 0 !important;
        flex-shrink: 0 !important;
    }

    /* 검색 버튼 (맨 오른쪽 - 돋보기 아이콘) */
    .map-search-wrapper .search-icon-btn {
        right: 5px !important;
    }

    /* 음성 검색 버튼 스타일 */
    .map-search-wrapper .voice-search-btn {
        background: #28a745 !important;
        right: 42px !important;
    }
    .map-search-wrapper .voice-search-btn:hover {
        background: #218838 !important;
    }
    .map-search-wrapper .voice-search-btn.recording {
        background: #dc3545 !important;
        animation: pulse 1.5s infinite;
    }

    /* AI 검색 버튼 위치 */
    .map-search-wrapper .ai-icon-btn {
        right: 79px !important;
    }

    /* 반응형: 작은 화면에서 버튼 간격 조정 */
    @media (max-width: 768px) {
        .map-search-input {
            padding-right: 120px !important;
        }
        .map-search-wrapper .voice-search-btn {
            right: 38px !important;
        }
        .map-search-wrapper .ai-icon-btn {
            right: 72px !important;
        }
    }

    @keyframes pulse {
        0%, 100% { opacity: 1; }
        50% { opacity: 0.7; }
    }
</style>

<section style="padding: 20px 0 100px 0; background: #f8f9fa; min-height: calc(100vh - 200px);">
    <div class="container-fluid" style="max-width: 1400px; margin: 0 auto;">

        <div class="row">
            <div class="col-12 mb-4 text-center">
                <h1 style="font-size: 38px; font-weight: 800; color: var(--secondary-color); text-shadow: 0 1px 2px rgba(0, 0, 0, 0.05);">
                    <i class="fas fa-robot" style="color: var(--primary-color);"></i> AI 장소 추천
                </h1>
            </div>
        </div>

        <div class="row mb-4">
            <div class="col-12">
                <div class="card-wrapper">
                    <div class="dashboard-card card-xlarge">
                        <div class="map-layout">
                            <div class="map-left">
                                <div class="map-title">
                                    <span class="map-title-icon"><i class="fas fa-location-dot"></i></span>
                                    <span>지도 목록</span>
                                </div>
                                <div class="map-address-panel" id="mapLocationList">
                                    <div class="map-location-items">
                                        <c:if test="${not empty selectedRecipient && not empty selectedRecipient.recAddress}">
                                            <div class="map-location-item home-location" onclick="focusHomeMarker()">
                                                <div class="location-info">
                                                    <div class="location-name-wrapper">
                                                        <div class="location-name" style="font-weight: 600;">${selectedRecipient.recName}님의 집</div>
                                                        <div class="location-category">집</div>
                                                    </div>
                                                </div>
                                                <div class="location-address">${selectedRecipient.recAddress}</div>
                                            </div>
                                            <c:if test="${not empty maps}"><div class="home-location-divider"></div></c:if>
                                        </c:if>

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
                                                        <div class="location-address" data-lat="${map.mapLatitude}" data-lng="${map.mapLongitude}">주소 조회 중...</div>
                                                        <button class="location-delete-btn" onclick="event.stopPropagation(); deleteLocation(${map.mapId})">
                                                            <i class="bi bi-x-circle"></i>
                                                        </button>
                                                    </div>
                                                </c:forEach>
                                            </c:otherwise>
                                        </c:choose>

                                        <div id="courseListContainer" style="display: none;">
                                            <c:if test="${not empty courses}">
                                                <div class="home-location-divider"></div>
                                                <c:forEach var="course" items="${courses}">
                                                    <div class="map-location-item course-item" data-course-id="${course.courseId}" onclick="showCourseDetail(${course.courseId})">
                                                        <div class="location-info">
                                                            <div class="location-name-wrapper">
                                                                <div class="location-name">${course.courseName}</div>
                                                                <div class="location-category course-category">${course.courseType}</div>
                                                            </div>
                                                        </div>
                                                        <button class="location-delete-btn" onclick="event.stopPropagation(); deleteCourse(${course.courseId})">
                                                            <i class="bi bi-x-circle"></i>
                                                        </button>
                                                    </div>
                                                </c:forEach>
                                            </c:if>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <div class="map-right">
                                <div class="map-header">
                                    <div class="map-tabs">
                                        <button type="button" class="map-tab active" onclick="switchMapTab(this, 'mymap')">
                                            <i class="fas fa-map-marked-alt"></i><span>내 지도</span>
                                        </button>
                                        <button type="button" class="map-tab" onclick="switchMapTab(this, 'course')">
                                            <i class="fas fa-walking"></i><span>산책 코스</span>
                                        </button>
                                    </div>

                                    <div class="map-search-container ai-recommend-search d-flex align-items-center gap-2">
                                        <div class="map-search-wrapper flex-grow-1">
                                            <input type="text" id="mapSearchInput" class="map-search-input" placeholder="병원, 약국, 공원 등 장소를 검색..." onkeypress="if(event.key==='Enter') searchLocation()">
                                            <button type="button" class="map-search-btn search-icon-btn" onclick="searchLocation()" title="검색"><i class="bi bi-search"></i></button>
                                            <button type="button" id="voiceSearchBtn" class="map-search-btn voice-search-btn" title="음성 검색"><i class="fas fa-microphone"></i></button>
                                            <button type="button" id="aiSearchBtn" class="map-search-btn ai-icon-btn" title="AI 검색"><i class="fas fa-robot"></i></button>
                                        </div>
                                        <button id="recommendBtn" class="btn btn-recommend-ai">
                                            맞춤 추천
                                        </button>
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

        <!-- 로딩 모달 -->
        <div class="modal fade" id="loadingModal" tabindex="-1" aria-hidden="true" data-bs-backdrop="static" data-bs-keyboard="false">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content" style="border-radius: 20px; border: none; box-shadow: 0 10px 30px rgba(0,0,0,0.1);">
                    <div class="modal-body text-center" style="padding: 40px 30px;">
                        <div class="spinner-border text-primary mb-4" role="status" style="width: 3rem; height: 3rem;">
                            <span class="visually-hidden">Loading...</span>
                        </div>
                        <h5 class="fw-bold text-secondary mb-2">AI가 대상자의 건강 상태를 분석하고 있습니다...</h5>
                        <p class="text-muted mb-0">장소를 찾고 있으니 잠시만 기다려주세요.</p>
                    </div>
                </div>
            </div>
        </div>

        <div id="recommendation-results" class="row g-4"></div>
    </div>
</section>

<div class="modal fade" id="addScheduleModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered modal-dialog-scrollable">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title"><i class="fas fa-plus-circle title-icon"></i> 일정 추가</h5>
                <button type="button" class="btn-close btn-close-custom" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <form id="saveRecommendForm">
                    <div class="ai-info-box">
                        <div class="ai-info-title"><i class="fas fa-location-bot"></i> AI 추천 정보</div>
                        <div class="mb-2">
                            <span class="badge bg-primary bg-opacity-10 text-primary px-3 py-2 rounded-pill" id="displayMapCategory" style="font-weight: 600; margin-right: 5px;"></span>
                            <strong id="displayMapName" style="font-size: 1.1rem; color: #333;"></strong>
                        </div>
                        <div class="p-3 bg-white rounded-3 border border-light text-secondary small" style="line-height: 1.6;">
                            <span id="displayMapContent"></span>
                        </div>
                    </div>
                    <input type="hidden" id="modalMapName">
                    <input type="hidden" id="modalMapContent">
                    <input type="hidden" id="modalMapCategory">
                    <div class="mb-4">
                        <label for="schedDate" class="form-label-custom"><i class="fas fa-calendar-alt form-label-icon"></i> 날짜 <span class="required-star">*</span></label>
                        <input type="date" class="form-control form-control-custom" id="schedDate" required>
                    </div>
                    <div class="mb-4">
                        <label for="schedName" class="form-label-custom"><i class="fas fa-pen form-label-icon"></i> 일정 이름 <span class="required-star">*</span></label>
                        <input type="text" class="form-control form-control-custom" id="schedName" required placeholder="일정 이름을 입력해주세요">
                    </div>
                    <div class="mb-4">
                        <label for="mapAddress" class="form-label-custom"><i class="fas fa-map-marker-alt form-label-icon"></i> 주소 <span class="required-star">*</span></label>
                        <textarea class="form-control form-control-custom" id="mapAddress" rows="2" required readonly placeholder="주소 정보"></textarea>
                        <div class="form-text ms-1 mt-1"><small>주소가 정확하지 않으면 직접 수정할 수 있습니다.</small></div>
                    </div>
                    <div class="card border-0 bg-light rounded-4 p-3">
                        <div class="d-flex align-items-center mb-3">
                            <i class="fas fa-route text-success me-2 fs-5"></i><span class="fw-bold text-dark">산책 코스 저장</span>
                        </div>
                        <div class="mb-2">
                            <label for="courseName" class="form-label-custom" style="font-size: 0.85rem;">코스 이름</label>
                            <input type="text" class="form-control form-control-custom" id="courseName" required>
                        </div>
                        <input type="hidden" id="courseType">
                        <input type="hidden" id="startLat"><input type="hidden" id="startLng">
                        <input type="hidden" id="endLat"><input type="hidden" id="endLng">
                        <input type="hidden" id="courseDistance">
                        <div class="d-flex align-items-center mt-2">
                            <span class="badge bg-success me-2 rounded-pill" id="displayCourseType"></span>
                            <small class="text-muted" style="font-size: 0.8rem;">이 코스는 지도의 '산책 코스' 탭에 저장됩니다.</small>
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-modal-cancel" data-bs-dismiss="modal"><i class="fas fa-times me-1"></i> 취소</button>
                <button type="button" class="btn btn-modal-save" id="saveRecommendBtn"><i class="fas fa-save me-1"></i> 저장</button>
            </div>
        </div>
    </div>
</div>

<div class="map-modal-overlay" id="mapModal">
    <div class="map-modal">
        <div class="map-modal-header">
            <div class="map-modal-title"><i class="bi bi-pin-map-fill"></i><span>장소 추가</span></div>
            <button class="map-modal-close" onclick="closeMapModal()"><i class="bi bi-x-lg"></i></button>
        </div>
        <div class="map-modal-body">
            <div class="modal-location-info" id="modalLocationInfo"><i class="bi bi-geo-alt-fill"></i><span id="modalAddress">주소 조회 중...</span></div>
            <form id="mapLocationForm">
                <input type="hidden" id="modalLat" name="latitude"><input type="hidden" id="modalLng" name="longitude">
                <input type="hidden" id="modalRecId" name="recId" value="${recipient.recId}">
                <div class="modal-form-group">
                    <label class="modal-form-label">장소 이름<span class="required">*</span></label>
                    <input type="text" class="modal-form-input" id="modalMapName" name="mapName" placeholder="예: 우리 동네 병원" required maxlength="100">
                </div>
                <div class="modal-form-group">
                    <label class="modal-form-label">카테고리<span class="required">*</span></label>
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
                    <label class="modal-form-label">메모</label>
                    <textarea class="modal-form-textarea" id="modalContent" name="mapContent" placeholder="이 장소에 대한 메모를 남겨보세요..." maxlength="500"></textarea>
                </div>
            </form>
        </div>
        <div class="map-modal-footer">
            <button type="button" class="modal-btn modal-btn-cancel" onclick="closeMapModal()">취소</button>
            <button type="button" class="modal-btn modal-btn-save" onclick="saveMapLocation()">저장</button>
        </div>
    </div>
</div>

<div class="map-modal-overlay" id="locationDetailModal">
    <div class="map-modal">
        <div class="map-modal-header">
            <div class="map-modal-title"><i class="bi bi-geo-alt-fill"></i><span>장소 정보</span></div>
            <button class="map-modal-close" onclick="closeLocationDetailModal()"><i class="bi bi-x-lg"></i></button>
        </div>
        <div class="map-modal-body">
            <div class="modal-location-info" id="detailLocationAddress"><i class="bi bi-geo-alt-fill"></i><span id="detailAddress">주소 조회 중...</span></div>
            <div class="modal-form-group"><label class="modal-form-label">거리</label><div class="modal-form-readonly" id="detailLocationDistance" style="color: #667eea; font-weight: 600; font-size: 16px; margin-bottom: 10px;">-</div></div>
            <div class="modal-form-group"><label class="modal-form-label">장소 이름</label><div class="modal-form-readonly" id="detailLocationName">-</div></div>
            <div class="modal-form-group"><label class="modal-form-label">카테고리</label><div class="modal-form-readonly" id="detailLocationCategory">-</div></div>
            <div class="modal-form-group"><label class="modal-form-label">메모</label><div class="modal-form-readonly" id="detailLocationContent">-</div></div>
        </div>
        <div class="map-modal-footer">
            <button type="button" class="modal-btn modal-btn-delete" onclick="deleteLocationFromModal()">삭제</button>
            <button type="button" class="modal-btn modal-btn-cancel" onclick="closeLocationDetailModal()">닫기</button>
            <button type="button" class="modal-btn modal-btn-save" onclick="viewLocationOnMap()">지도에서 보기</button>
        </div>
    </div>
</div>

<div class="map-modal-overlay" id="courseDetailModal">
    <div class="map-modal">
        <div class="map-modal-header">
            <div class="map-modal-title"><i class="bi bi-walking"></i><span>산책코스 정보</span></div>
            <button class="map-modal-close" onclick="closeCourseDetailModal()"><i class="bi bi-x-lg"></i></button>
        </div>
        <div class="map-modal-body">
            <div class="modal-form-group"><label class="modal-form-label">코스 이름</label><div class="modal-form-readonly" id="detailCourseName">-</div></div>
            <div class="modal-form-group"><label class="modal-form-label">코스 타입</label><div class="modal-form-readonly" id="detailCourseType">-</div></div>
            <div class="modal-form-group"><label class="modal-form-label">총 거리</label><div class="modal-form-readonly" id="detailCourseDistance">-</div></div>
        </div>
        <div class="map-modal-footer">
            <button type="button" class="modal-btn modal-btn-cancel" onclick="closeCourseDetailModal()">닫기</button>
            <button type="button" class="modal-btn modal-btn-save" onclick="viewCourseOnMap()">지도에서 보기</button>
        </div>
    </div>
</div>

<div class="map-modal-overlay" id="searchResultDetailModal">
    <div class="map-modal">
        <div class="map-modal-header">
            <div class="map-modal-title"><i class="bi bi-geo-alt-fill"></i><span>검색 장소 정보</span></div>
            <button class="map-modal-close" onclick="closeSearchResultDetailModal()"><i class="bi bi-x-lg"></i></button>
        </div>
        <div class="map-modal-body">
            <div class="modal-form-group"><label class="modal-form-label">장소 이름</label><div class="modal-form-readonly" id="searchResultName">-</div></div>
            <div class="modal-form-group"><label class="modal-form-label">카테고리</label><div class="modal-form-readonly" id="searchResultCategory">-</div></div>
            <div class="modal-form-group"><label class="modal-form-label">주소</label><div class="modal-form-readonly" id="searchResultAddress">-</div></div>
            <div class="modal-form-group"><label class="modal-form-label">집 주소</label><div class="modal-form-readonly" id="searchResultHomeAddress">-</div></div>
            <div class="modal-form-group"><label class="modal-form-label">거리</label><div class="modal-form-readonly" id="searchResultDistance" style="color: #667eea; font-weight: 600; font-size: 16px;">-</div></div>
            <div class="modal-form-group"><label class="modal-form-label">메모</label><textarea class="modal-form-input" id="searchResultMemo" placeholder="이 장소에 대한 메모를 입력하세요 (선택사항)" rows="3" style="resize: vertical;"></textarea></div>
        </div>
        <div class="map-modal-footer">
            <button type="button" class="modal-btn modal-btn-save" onclick="saveSearchResultLocation()">저장</button>
            <button type="button" class="modal-btn modal-btn-cancel" onclick="closeSearchResultDetailModal()">닫기</button>
        </div>
    </div>
</div>

<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=${kakaoJsKey}&libraries=services"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/sockjs-client/1.6.1/sockjs.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/stomp.js/2.3.3/stomp.min.js"></script>
<script src="/js/homecenter/center.js"></script>

<script>
    var recipientAddress = '<c:out value="${selectedRecipient.recAddress}" escapeXml="false"/>';
    var recipientName = '<c:out value="${selectedRecipient.recName}" escapeXml="false"/>';
    <c:choose>
    <c:when test="${not empty selectedRecipient.recPhotoUrl}">
    <c:set var="jsPhotoUrl" value="${selectedRecipient.recPhotoUrl}${fn:contains(selectedRecipient.recPhotoUrl, '?') ? '&' : '?'}v=${selectedRecipient.recId}"/>
    var recipientPhotoUrl = '<c:out value="${jsPhotoUrl}" escapeXml="false"/>';
    </c:when>
    <c:otherwise>
    var recipientPhotoUrl = '';
    </c:otherwise>
    </c:choose>
    var defaultRecId = <c:choose><c:when test="${not empty selectedRecipient}">${selectedRecipient.recId}</c:when><c:otherwise>null</c:otherwise></c:choose>;

    // AI 추천 기능 전용 오버레이 배열
    var recommendOverlays = [];

    // 지도 이동 및 상태창 표시 함수 (검색 버튼 클릭 시 호출)
    window.moveMapToLocation = function(lat, lng, index) {
        if (map) {
            var moveLatLon = new kakao.maps.LatLng(lat, lng);
            map.panTo(moveLatLon); // 부드럽게 이동

            // 해당 인덱스의 오버레이 열기
            if (typeof recommendOverlays !== 'undefined' && recommendOverlays[index]) {
                closeAllRecommendOverlays(); // 다른 추천 오버레이 닫기
                recommendOverlays[index].setMap(map); // 해당 오버레이 열기
            }
        }
    };

    // 지도 마커의 '일정 추가' 버튼 클릭 시 모달 열기
    function openScheduleModalFromMarker(button) {
        const modal = new bootstrap.Modal(document.getElementById('addScheduleModal'));
        const mapName = button.dataset.mapname;
        const mapContent = button.dataset.mapcontent;
        const mapCategory = button.dataset.mapcategory;
        const mapAddress = button.dataset.mapaddress;
        const courseType = button.dataset.coursetype;
        const distance = button.dataset.distance;
        const startLat = button.dataset.startlat;
        const startLng = button.dataset.startlng;
        const endLat = button.dataset.endlat;
        const endLng = button.dataset.endlng;
        document.getElementById('modalMapName').value = mapName;
        document.getElementById('modalMapContent').value = mapContent;
        document.getElementById('modalMapCategory').value = mapCategory;
        document.getElementById('displayMapName').textContent = mapName;
        document.getElementById('displayMapCategory').textContent = mapCategory;
        document.getElementById('displayMapContent').textContent = mapContent;
        document.getElementById('schedName').value = mapName + " 방문";
        document.getElementById('courseName').value = mapName + " 방문 코스";
        document.getElementById('courseType').value = courseType;
        document.getElementById('displayCourseType').textContent = courseType;
        document.getElementById('startLat').value = startLat;
        document.getElementById('startLng').value = startLng;
        document.getElementById('endLat').value = endLat;
        document.getElementById('endLng').value = endLng;
        document.getElementById('courseDistance').value = distance;

        const addrInput = document.getElementById('mapAddress');
        addrInput.value = mapAddress;
        if (!mapAddress || mapAddress === '주소 정보 없음' || mapAddress === 'null') {
            addrInput.value = '';
            addrInput.placeholder = '주소를 직접 입력해주세요';
            addrInput.readOnly = false;
            addrInput.style.backgroundColor = '#ffffff';
        } else {
            addrInput.readOnly = true;
            addrInput.style.backgroundColor = '#f8f9fa';
        }
        modal.show();
    }

    // AI 추천 오버레이 닫기 함수
    function closeAllRecommendOverlays() {
        recommendOverlays.forEach(overlay => {
            if (overlay) {
                overlay.setMap(null);
            }
        });
    }

    // 특정 AI 추천 오버레이 닫기
    window.closeRecommendOverlay = function(index) {
        if (recommendOverlays[index]) {
            recommendOverlays[index].setMap(null);
        }
    }

    document.addEventListener('DOMContentLoaded', function() {
        const recommendBtn = document.getElementById('recommendBtn');
        const resultsContainer = document.getElementById('recommendation-results');
        const modalElement = document.getElementById('addScheduleModal');
        const modal = new bootstrap.Modal(modalElement);
        let recommendMarkers = [];

        document.getElementById('schedDate').valueAsDate = new Date();

        recommendBtn.addEventListener('click', function() {
            const recId = ${not empty selectedRecipient ? selectedRecipient.recId : 'null'};
            if (!recId) { alert("추천을 위한 대상자 정보가 없습니다."); return; }
            resultsContainer.innerHTML = '';

            // 로딩 모달 표시
            const loadingModalElement = document.getElementById('loadingModal');
            const loadingModal = new bootstrap.Modal(loadingModalElement);
            loadingModal.show();
            recommendBtn.disabled = true;

            fetch('/schedule/ai-recommend', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ recId: parseInt(recId) })
            })
                .then(response => response.json())
                .then(data => {
                    // 로딩 모달 닫기
                    loadingModal.hide();
                    recommendBtn.disabled = false;
                    if (!data || data.length === 0) {
                        resultsContainer.innerHTML = '<div class="col-12 text-center py-5"><h4 class="text-muted">추천 결과가 없습니다.</h4></div>';
                        return;
                    }
                    displayRecommendationsOnMap(data);
                    renderRecommendationCards(data);
                })
                .catch(error => {
                    console.error('Error:', error);
                    // 로딩 모달 닫기
                    const loadingModalElement = document.getElementById('loadingModal');
                    const loadingModal = bootstrap.Modal.getInstance(loadingModalElement);
                    if (loadingModal) {
                        loadingModal.hide();
                    }
                    recommendBtn.disabled = false;
                    resultsContainer.innerHTML = '<div class="col-12 text-center py-5"><h4 class="text-danger">오류가 발생했습니다. 잠시 후 다시 시도해주세요.</h4></div>';
                });
        });

        // 음성 인식 기능
        const voiceSearchBtn = document.getElementById('voiceSearchBtn');
        const mapSearchInput = document.getElementById('mapSearchInput');
        let recognition = null;
        let isRecording = false;

        // Web Speech API 지원 확인 및 초기화
        if ('webkitSpeechRecognition' in window || 'SpeechRecognition' in window) {
            const SpeechRecognition = window.SpeechRecognition || window.webkitSpeechRecognition;
            recognition = new SpeechRecognition();
            recognition.lang = 'ko-KR'; // 한국어 설정
            recognition.continuous = false; // 한 번만 인식
            recognition.interimResults = false; // 최종 결과만 받기

            recognition.onstart = function() {
                isRecording = true;
                voiceSearchBtn.classList.add('recording');
                voiceSearchBtn.title = '음성 인식 중... (클릭하여 중지)';
                mapSearchInput.placeholder = '말씀해주세요...';
            };

            recognition.onresult = function(event) {
                const transcript = event.results[0][0].transcript.trim();
                mapSearchInput.value = transcript;
                isRecording = false;
                voiceSearchBtn.classList.remove('recording');
                voiceSearchBtn.title = '음성 검색';
                mapSearchInput.placeholder = '병원, 약국, 공원 등 장소를 검색...';

                // 음성 인식 후 자동으로 AI 검색 실행
                if (transcript) {
                    performAiSearch(transcript);
                }
            };

            recognition.onerror = function(event) {
                console.error('음성 인식 오류:', event.error);
                isRecording = false;
                voiceSearchBtn.classList.remove('recording');
                voiceSearchBtn.title = '음성 검색';
                mapSearchInput.placeholder = '병원, 약국, 공원 등 장소를 검색...';

                let errorMsg = '음성 인식 중 오류가 발생했습니다.';
                if (event.error === 'no-speech') {
                    errorMsg = '음성이 감지되지 않았습니다. 다시 시도해주세요.';
                } else if (event.error === 'not-allowed') {
                    errorMsg = '마이크 권한이 필요합니다. 브라우저 설정에서 마이크 권한을 허용해주세요.';
                }
                alert(errorMsg);
            };

            recognition.onend = function() {
                isRecording = false;
                voiceSearchBtn.classList.remove('recording');
                voiceSearchBtn.title = '음성 검색';
                mapSearchInput.placeholder = '병원, 약국, 공원 등 장소를 검색...';
            };

            voiceSearchBtn.addEventListener('click', function() {
                if (isRecording) {
                    // 녹음 중이면 중지
                    recognition.stop();
                } else {
                    // 녹음 시작
                    try {
                        recognition.start();
                    } catch (e) {
                        console.error('음성 인식 시작 오류:', e);
                        alert('음성 인식을 시작할 수 없습니다. 잠시 후 다시 시도해주세요.');
                    }
                }
            });
        } else {
            // Web Speech API를 지원하지 않는 경우
            voiceSearchBtn.style.display = 'none';
            console.warn('이 브라우저는 음성 인식을 지원하지 않습니다.');
        }

        // AI 검색 함수 (재사용 가능하도록 분리)
        function performAiSearch(keyword) {
            if (!keyword || keyword.trim() === '') {
                alert("검색어를 입력해주세요.");
                return;
            }

            const recId = ${not empty selectedRecipient ? selectedRecipient.recId : 'null'};
            if (!recId) {
                alert("추천을 위한 대상자 정보가 없습니다.");
                return;
            }
            resultsContainer.innerHTML = '';

            // 로딩 모달 표시
            const loadingModalElement = document.getElementById('loadingModal');
            const loadingModal = new bootstrap.Modal(loadingModalElement);
            loadingModal.show();
            const aiSearchBtn = document.getElementById('aiSearchBtn');
            aiSearchBtn.disabled = true;

            fetch('/schedule/ai-keyword-recommend', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ recId: parseInt(recId), keyword: keyword.trim() })
            })
                .then(response => response.json())
                .then(data => {
                    // 로딩 모달 닫기
                    loadingModal.hide();
                    aiSearchBtn.disabled = false;
                    if (!data || data.length === 0) {
                        const keywordEscaped = keyword.replace(/'/g, "\\'");
                        resultsContainer.innerHTML = `<div class="col-12 text-center py-5"><h4 class="text-muted">'${keywordEscaped}'에 대한 AI 추천 결과가 없습니다.</h4></div>`;
                        return;
                    }
                    displayRecommendationsOnMap(data);
                    renderRecommendationCards(data);
                })
                .catch(error => {
                    console.error('Error:', error);
                    // 로딩 모달 닫기
                    const loadingModalElement = document.getElementById('loadingModal');
                    const loadingModal = bootstrap.Modal.getInstance(loadingModalElement);
                    if (loadingModal) {
                        loadingModal.hide();
                    }
                    aiSearchBtn.disabled = false;
                    resultsContainer.innerHTML = '<div class="col-12 text-center py-5"><h4 class="text-danger">오류가 발생했습니다. 잠시 후 다시 시도해주세요.</h4></div>';
                });
        }

        // AI 검색 버튼 클릭 이벤트
        const aiSearchBtn = document.getElementById('aiSearchBtn');
        aiSearchBtn.addEventListener('click', function() {
            const keyword = document.getElementById('mapSearchInput').value;
            performAiSearch(keyword);
        });

        function renderRecommendationCards(data) {
            resultsContainer.innerHTML = '';
            data.forEach((item, index) => {
                const cardCol = document.createElement('div');
                cardCol.className = 'col-lg-4 col-md-6';
                cardCol.dataset.lat = item.y;
                cardCol.dataset.lng = item.x;
                const hasValidLocation = (item.placeUrl && item.placeUrl.trim() !== '') || (item.x && item.y && item.x.trim() !== '' && item.y.trim() !== '');
                const address = item.address && item.address.trim() !== '' ? item.address : (hasValidLocation ? '' : '주소 정보 없음');
                const distance = item.distance ? `(약 \${(parseInt(item.distance)/1000).toFixed(1)}km)` : '';

                cardCol.innerHTML = `
<div class="card recommend-card" data-index="\${index}">
<div class="card-header-custom d-flex justify-content-between align-items-center">
    <h5 class="mb-0 text-truncate" title="\${item.mapName}">\${item.mapName}</h5>
    <span class="badge badge-category">\${item.mapCategory}</span>
</div>
<div class="card-body d-flex flex-column">
    <p class="card-text text-muted mb-2">\${address ? `<i class="fas fa-map-marker-alt text-danger"></i> \${address} ` : ''}\${distance}</p>
                <div class="mt-auto pt-3">
                    <div class="summary-content mb-3" style="display: block;">
                    <strong><i class="fas fa-robot text-primary"></i> AI 추천 이유:</strong><br>\${item.mapContent}
            </div>
                <div class="d-flex flex-column" style="gap: 10px;">
                    <div class="d-flex w-100" style="gap: 10px;">
                        <a href="https://map.kakao.com/?sName=\${encodeURIComponent(item.startAddress || '내 위치')}&eName=\${encodeURIComponent(item.mapName)}" target="_blank" class="btn btn-map flex-grow-1"><i class="fas fa-directions"></i> 길찾기</a>
                        <a href="https://map.kakao.com/link/search/\${encodeURIComponent(item.mapName)}" target="_blank" class="btn btn-outline-secondary flex-grow-1">
                            <i class="fas fa-search"></i> 검색
                        </a>                            </div>
                    <button class="btn btn-primary w-100 btn-add-schedule" data-mapname="\${item.mapName}" data-mapcontent="\${item.mapContent}" data-mapcategory="\${item.mapCategory}" data-mapaddress="\${address}" data-coursetype="\${item.courseType || 'WALK'}" data-startlat="\${item.startLat}" data-startlng="\${item.startLng}" data-endlat="\${item.y}" data-endlng="\${item.x}" data-distance="\${item.distance || 0}">
                        <i class="fas fa-plus"></i> 일정 추가
                    </button>
                </div>
            </div>
            </div>
            </div>`;
            resultsContainer.appendChild(cardCol);
        });
        addCardEventListeners();
    }

        function displayRecommendationsOnMap(places) {
            // 기존 추천 마커 및 오버레이 제거
            recommendMarkers.forEach(marker => marker.setMap(null));
            recommendMarkers = [];
            closeAllRecommendOverlays(); // 기존 추천 오버레이 모두 닫기
            recommendOverlays = []; // 추천 오버레이 배열 초기화

            const bounds = new kakao.maps.LatLngBounds();
            if (window.homeMarker) { bounds.extend(window.homeMarker.getPosition()); }

            places.forEach((place, i) => {
                if (place.y && place.x) {
                    const position = new kakao.maps.LatLng(place.y, place.x);
                    const imageSrc = 'https://t1.daumcdn.net/localimg/localimages/07/mapapidoc/markerStar.png';
                    const imageSize = new kakao.maps.Size(24, 35);
                    const markerImage = new kakao.maps.MarkerImage(imageSrc, imageSize);

                    const marker = new kakao.maps.Marker({
                        map: map,
                        position: position,
                        title: place.mapName,
                        image: markerImage
                    });
                    recommendMarkers.push(marker);
                    bounds.extend(position);

                    const address = place.address && place.address.trim() !== '' ? place.address : ( (place.placeUrl && place.placeUrl.trim() !== '') || (place.x && place.y && place.x.trim() !== '' && place.y.trim() !== '') ? '' : '주소 정보 없음');

                    const content = `
                <div class="custom-overlay-wrap">
                    <div class="custom-overlay-header">
                    <span>\${place.mapName}</span>
                <div class="custom-overlay-close" onclick="event.stopPropagation(); closeRecommendOverlay(\${i})" title="닫기">×</div>
            </div>
                <div class="custom-overlay-body">
                    <span class="custom-overlay-category">\${place.mapCategory}</span>
                    <div style="font-size:12px; color:#666; margin-bottom:8px;">\${address}</div>
                    <button class="btn-add-schedule-overlay" onclick="openScheduleModalFromMarker(this)"
                            data-mapname="\${place.mapName}" data-mapcontent="\${place.mapContent}"
                            data-mapcategory="\${place.mapCategory}" data-mapaddress="\${address}"
                            data-coursetype="\${place.courseType || 'WALK'}" data-startlat="\${place.startLat}"
                            data-startlng="\${place.startLng}" data-endlat="\${place.y}"
                            data-endlng="\${place.x}" data-distance="\${place.distance || 0}">
                        일정 추가
                    </button>
                </div>
            </div>
                `;

                    const overlay = new kakao.maps.CustomOverlay({
                        content: content,
                        position: marker.getPosition(),
                        map: null,
                        zIndex: 100
                    });

                    // 추천 오버레이 배열에 저장 (인덱스로 접근 가능하게)
                    recommendOverlays[i] = overlay;

                    // 마커 클릭 시 오버레이 열기 (다른 오버레이는 `center.js`의 `closeAllOverlays`로 닫힘)
                    kakao.maps.event.addListener(marker, 'click', function() {
                        if(typeof closeAllOverlays === 'function') {
                            closeAllOverlays(); // center.js의 전역 오버레이 닫기
                        }
                        closeAllRecommendOverlays(); // 현재 스크립트의 오버레이 닫기
                        overlay.setMap(map); // 내꺼 열기
                        map.panTo(marker.getPosition()); // 마커 중심으로 이동
                    });
                }
            });
            if (recommendMarkers.length > 0) { map.setBounds(bounds); }
        }

        function addCardEventListeners() {
            document.querySelectorAll('.recommend-card').forEach(card => {
                card.addEventListener('mouseover', function() {
                    const index = this.dataset.index;
                    if (recommendMarkers[index]) { recommendMarkers[index].setZIndex(100); }
                });
                card.addEventListener('mouseout', function() {
                    const index = this.dataset.index;
                    if (recommendMarkers[index]) { recommendMarkers[index].setZIndex(0); }
                });
                card.addEventListener('click', function(event) {
                    if (event.target.closest('button, a')) {
                        return;
                    }
                    const lat = this.parentElement.dataset.lat;
                    const lng = this.parentElement.dataset.lng;
                    const index = this.dataset.index;
                    if (lat && lng && index !== undefined) {
                        window.scrollTo({ top: 0, behavior: 'smooth' });
                        setTimeout(() => {
                            moveMapToLocation(lat, lng, index);
                        }, 500);
                    }
                });
            });

            document.querySelectorAll('.btn-add-schedule').forEach(btn => {
                btn.addEventListener('click', function() {
                    const mapName = this.dataset.mapname;
                    const mapContent = this.dataset.mapcontent;
                    const mapCategory = this.dataset.mapcategory;
                    const mapAddress = this.dataset.mapaddress;
                    const courseType = this.dataset.coursetype;
                    const distance = this.dataset.distance;
                    const startLat = this.dataset.startlat;
                    const startLng = this.dataset.startlng;
                    const endLat = this.dataset.endlat;
                    const endLng = this.dataset.endlng;

                    document.getElementById('modalMapName').value = mapName;
                    document.getElementById('modalMapContent').value = mapContent;
                    document.getElementById('modalMapCategory').value = mapCategory;
                    document.getElementById('displayMapName').textContent = mapName;
                    document.getElementById('displayMapCategory').textContent = mapCategory;
                    document.getElementById('displayMapContent').textContent = mapContent;
                    document.getElementById('schedName').value = mapName + " 방문";
                    document.getElementById('courseName').value = mapName + " 방문 코스";
                    document.getElementById('courseType').value = courseType;
                    document.getElementById('displayCourseType').textContent = courseType;
                    document.getElementById('startLat').value = startLat;
                    document.getElementById('startLng').value = startLng;
                    document.getElementById('endLat').value = endLat;
                    document.getElementById('endLng').value = endLng;
                    document.getElementById('courseDistance').value = distance;

                    const addrInput = document.getElementById('mapAddress');
                    addrInput.value = mapAddress;
                    if (!mapAddress || mapAddress === '주소 정보 없음' || mapAddress === 'null') {
                        addrInput.value = '';
                        addrInput.placeholder = '주소를 직접 입력해주세요';
                        addrInput.readOnly = false;
                        addrInput.style.backgroundColor = '#ffffff';
                    } else {
                        addrInput.readOnly = true;
                        addrInput.style.backgroundColor = '#f8f9fa';
                    }
                    modal.show();
                });
            });
        }

        function addLocationToList(mapData) {
            const listContainer = document.querySelector('.map-location-items');
            if (!listContainer) return;
            const emptyList = listContainer.querySelector('.empty-map-list');
            if (emptyList) { emptyList.remove(); }
            if (!listContainer.querySelector('.home-location-divider')) {
                const divider = document.createElement('div');
                divider.className = 'home-location-divider';
                const homeLocation = listContainer.querySelector('.home-location');
                if (homeLocation) { homeLocation.after(divider); } else { listContainer.prepend(divider); }
            }
            const newItem = document.createElement('div');
            newItem.className = 'map-location-item';
            newItem.dataset.mapId = mapData.mapId;
            newItem.dataset.lat = mapData.mapLatitude;
            newItem.dataset.lng = mapData.mapLongitude;
            newItem.setAttribute('onclick', `showLocationDetail(\${mapData.mapId})`);
            newItem.innerHTML = `<div class="location-info"><div class="location-name-wrapper"><div class="location-name">\${mapData.mapName}</div><div class="location-category">\${mapData.mapCategory}</div></div></div><div class="location-address" data-lat="\${mapData.mapLatitude}" data-lng="\${mapData.mapLongitude}">주소 조회 중...</div><button class="location-delete-btn" onclick="event.stopPropagation(); deleteLocation(\${mapData.mapId})"><i class="bi bi-x-circle"></i></button>`;
            listContainer.appendChild(newItem);
            loadMapLocationAddresses();
        }

        document.getElementById('saveRecommendBtn').addEventListener('click', function() {
            const saveBtn = this;
            const recId = ${not empty selectedRecipient ? selectedRecipient.recId : 'null'};
            const data = {
                recId: recId,
                schedDate: document.getElementById('schedDate').value,
                schedName: document.getElementById('schedName').value,
                mapAddress: document.getElementById('mapAddress').value,
                mapName: document.getElementById('modalMapName').value,
                mapContent: document.getElementById('modalMapContent').value,
                mapCategory: document.getElementById('modalMapCategory').value,
                courseName: document.getElementById('courseName').value,
                courseType: document.getElementById('courseType').value,
                startLat: document.getElementById('startLat').value,
                startLng: document.getElementById('startLng').value,
                endLat: document.getElementById('endLat').value,
                endLng: document.getElementById('endLng').value,
                courseDistance: document.getElementById('courseDistance').value
            };
            if (!data.schedDate || !data.schedName || !data.mapAddress) { alert('날짜, 일정 이름, 주소는 필수 항목입니다.'); return; }
            saveBtn.disabled = true;
            saveBtn.innerHTML = '<span class="spinner-border spinner-border-sm" role="status" aria-hidden="true"></span> 저장 중...';
            fetch('/schedule/save-recommendation', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify(data)
            })
            .then(response => response.json())
            .then(result => {
                if (result.success) {
                    alert(result.message);
                    modal.hide();
                    if (result.mapData) {
                        if (typeof addMarkerToMap === 'function') {
                            addMarkerToMap({ mapId: result.mapData.mapId, mapName: result.mapData.mapName, mapCategory: result.mapData.mapCategory, lat: result.mapData.mapLatitude, lng: result.mapData.mapLongitude });
                        }
                        addLocationToList(result.mapData);
                    }
                } else { alert(result.message || '저장에 실패했습니다.'); }
            })
            .catch(error => { console.error('Error:', error); alert('저장 중 오류가 발생했습니다.'); })
            .finally(() => { saveBtn.disabled = false; saveBtn.innerHTML = '<i class="fas fa-save me-1"></i> 저장'; });
        });
    });

    function loadSavedMarkers() {
        var savedMapsJson = '<c:out value="${not empty maps ? true : false}" escapeXml="false"/>';
        if (savedMapsJson === 'true') {
            var savedMaps = [];
            <c:forEach var="mapItem" items="${maps}" varStatus="status">
            savedMaps.push({ mapId: parseInt('${mapItem.mapId}'), mapName: '<c:out value="${mapItem.mapName}" escapeXml="false"/>', mapCategory: '<c:out value="${mapItem.mapCategory}" escapeXml="false"/>', lat: parseFloat('${mapItem.mapLatitude}'), lng: parseFloat('${mapItem.mapLongitude}') });
            </c:forEach>
            loadSavedMarkersWithData(savedMaps);
        }
    }

    window.addEventListener('load', function() {
        if (typeof kakao !== 'undefined' && kakao.maps) {
            initializeMap();
            loadHomeMarker();
            loadSavedMarkers();
            setTimeout(function() {
                if (typeof loadRecipientLocationMarker === 'function') { loadRecipientLocationMarker(); }
                else { console.warn('loadRecipientLocationMarker 함수를 찾을 수 없습니다.'); }
            }, 1000);
        }
        loadMapLocationAddresses();
    });

    function loadMapLocationAddresses() {
        if (typeof kakao === 'undefined' || !kakao.maps || !kakao.maps.services) { return; }
        var geocoder = new kakao.maps.services.Geocoder();
        var addressElements = document.querySelectorAll('.map-location-item .location-address[data-lat][data-lng]');
        addressElements.forEach(function(element) {
            var lat = parseFloat(element.getAttribute('data-lat'));
            var lng = parseFloat(element.getAttribute('data-lng'));
            if (isNaN(lat) || isNaN(lng)) { element.textContent = '주소 정보 없음'; return; }
            geocoder.coord2Address(lng, lat, function(result, status) {
                if (status === kakao.maps.services.Status.OK) { var addr = result[0].address.address_name; element.textContent = addr; }
                else { element.textContent = '위도: ' + lat.toFixed(6) + ', 경도: ' + lng.toFixed(6); }
            });
        });
    }

    document.addEventListener('DOMContentLoaded', function() {
        if (defaultRecId && typeof Stomp !== 'undefined') { connectAndSubscribeForLocation(); }
        else { console.log("실시간 위치 업데이트를 위한 사용자 정보 또는 Stomp 라이브러리를 찾을 수 없습니다."); }
    });

    function connectAndSubscribeForLocation() {
        const socket = new SockJS('/adminchat');
        const stompClient = Stomp.over(socket);
        stompClient.debug = null;
        stompClient.connect({}, function (frame) {
            console.log('✅ Real-time location WS Connected: ' + frame);
            const topic = '/topic/location/' + defaultRecId;
            stompClient.subscribe(topic, function (message) {
                try {
                    const locationData = JSON.parse(message.body);
                    console.log('📍 Real-time Location:', locationData);
                    if (typeof updateRecipientMarker === 'function') { updateRecipientMarker(locationData.latitude, locationData.longitude); }
                    else { moveMarkerDirectly(locationData.latitude, locationData.longitude); }
                } catch (e) { console.error('위치 데이터 파싱 오류:', e); }
            });
        }, function(error) {
            console.log('⚠️ 위치 정보 소켓 연결이 끊겼습니다. 5초 후 재연결합니다...');
            setTimeout(connectAndSubscribeForLocation, 5000);
        });
    }
</script>