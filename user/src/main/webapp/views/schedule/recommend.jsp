<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<spring:eval expression="@environment.getProperty('app.api.kakao-js-key')" var="kakaoJsKey"/>

<!-- CSS 파일 링크 -->
<link rel="stylesheet" href="<c:url value='/css/center.css'/>" />

<style>
    /* =========================================
       1. 모달 겹침 방지 및 z-index 설정
       ========================================= */
    .modal {
        z-index: 10055 !important; /* 헤더보다 위로 */
    }
    .modal-backdrop {
        z-index: 10050 !important;
    }

    /* =========================================
       2. AI 추천 카드 스타일 (메인 화면)
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
    /* 💡 수정/유지된 스타일: 길찾기 버튼 스타일 */
    .btn-map {
        background-color: #fee500;
        color: #191919;
        border: none;
        font-weight: 600;
        font-size: 0.9rem; /* 폰트 크기 CSS로 통합 */
        padding: 8px 15px; /* 버튼 패딩 조정 */
    }
    .btn-map:hover {
        background-color: #fdd835;
    }
    /* 💡 추가된 스타일: 검색 버튼 스타일 */
    .btn-outline-secondary {
        border: 1px solid #ced4da;
        color: #6c757d;
        font-weight: 600;
        font-size: 0.9rem; /* 폰트 크기 CSS로 통합 */
        padding: 8px 15px; /* 버튼 패딩 조정 */
        min-width: 0; /* flex 컨테이너에서 최소 너비 확보 */
    }
    .btn-outline-secondary:hover {
        background-color: #e9ecef;
        color: #495057;
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
       3. 모달 커스텀 디자인 (깔끔한 스타일)
       ========================================= */

    /* 모달 컨텐츠 둥글게 */
    #addScheduleModal .modal-content {
        border-radius: 20px;
        border: none;
        box-shadow: 0 10px 30px rgba(0,0,0,0.1);
    }

    /* 헤더: 흰색 배경 */
    #addScheduleModal .modal-header {
        background: #fff;
        border-bottom: none;
        padding: 25px 25px 10px 25px;
    }

    #addScheduleModal .modal-title {
        font-weight: 800;
        color: #333;
        font-size: 1.4rem;
        display: flex;
        align-items: center;
        gap: 10px;
    }

    /* 제목 아이콘 */
    .title-icon {
        color: #667eea;
        font-size: 1.6rem;
    }

    /* 닫기 버튼 */
    .btn-close-custom {
        background-color: #f1f3f5;
        border-radius: 50%;
        padding: 10px;
        opacity: 0.8;
        transition: all 0.3s ease;
        transform: rotate(0deg); /* 애니메이션을 위한 초기 상태 */
    }
    .btn-close-custom:hover {
        opacity: 1;
        background-color: #e9ecef;
        transform: rotate(90deg); /* 마우스 올리면 90도 회전 */
    }
    .btn-close-custom:active {
        transform: rotate(90deg) scale(0.9); /* 클릭 시 살짝 작아지는 효과 */
        background-color: #dee2e6;
    }

    /* 폼 라벨 및 입력창 */
    .form-label-custom {
        font-weight: 700;
        color: #495057;
        font-size: 0.95rem;
        margin-bottom: 8px;
        display: flex;
        align-items: center;
        gap: 8px;
    }

    .form-label-icon {
        color: #667eea;
    }

    .form-control-custom {
        border: 1px solid #e9ecef;
        border-radius: 12px;
        padding: 12px 15px;
        font-size: 0.95rem;
        background-color: #fff;
        transition: border-color 0.2s;
    }

    .form-control-custom:focus {
        border-color: #667eea;
        box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
    }

    .form-control-custom[readonly] {
        background-color: #f8f9fa;
        color: #666;
    }

    .required-star {
        color: #ff6b6b;
        margin-left: 2px;
    }

    /* 푸터 버튼 */
    #addScheduleModal .modal-footer {
        border-top: none;
        background: #fff;
        padding: 10px 25px 25px 25px;
    }

    .btn-modal-cancel {
        background-color: #f1f3f5;
        color: #495057;
        border: none;
        border-radius: 10px;
        padding: 10px 20px;
        font-weight: 600;
    }

    .btn-modal-save {
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        color: white;
        border: none;
        border-radius: 10px;
        padding: 10px 30px;
        font-weight: 600;
        box-shadow: 0 4px 10px rgba(102, 126, 234, 0.3);
    }
    .btn-modal-save:hover {
        transform: translateY(-2px);
        box-shadow: 0 6px 15px rgba(102, 126, 234, 0.4);
    }

    /* AI 정보 박스 */
    .ai-info-box {
        background-color: #f3f0ff;
        border-radius: 15px;
        padding: 20px;
        margin-bottom: 25px;
        border: 1px solid #e0d4fc;
    }
    .ai-info-title {
        color: #667eea;
        font-weight: 700;
        margin-bottom: 10px;
        display: flex;
        align-items: center;
        gap: 8px;
    }


</style>

<section style="padding: 20px 0 100px 0; background: #FFFFFF; min-height: calc(100vh - 200px);">
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
                                        <c:if test="${not empty selectedRecipient && not empty selectedRecipient.recAddress}">
                                            <div class="map-location-item home-location" onclick="focusHomeMarker()">
                                                <div class="location-info">
                                                    <div class="location-name-wrapper">
                                                        <div class="location-name" style="font-weight: 600;">
                                                        ${selectedRecipient.recName}님의 집
                                                    </div>
                                                        <div class="location-category">집</div>
                                                    </div>
                                                </div>
                                                    <div class="location-address">
                                                        ${selectedRecipient.recAddress}
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
                                        
                                        <!-- 산책코스 목록 (기본 숨김) -->
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

        <div class="row mb-5">
            <div class="col-12 text-center">
                <button id="recommendBtn" class="btn btn-lg btn-primary shadow" style="font-size: 1.2rem; padding: 15px 50px; border-radius: 50px; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); border: none;">
                    <i class="fas fa-magic me-2"></i> 노약자 맞춤 추천 시작
                </button>
            </div>
        </div>

        <div id="loadingSpinner" class="text-center my-5" style="display: none;">
            <div class="spinner-border text-primary" role="status" style="width: 3rem; height: 3rem;">
                <span class="visually-hidden">Loading...</span>
            </div>
            <h5 class="mt-3 fw-bold text-secondary">AI가 대상자의 건강 상태를 분석하고 있습니다...</h5>
            <p class="text-muted">장소를 찾고 있으니 잠시만 기다려주세요.</p>
        </div>

        <div id="recommendation-results" class="row g-4">
        </div>
    </div>
</section>

<div class="modal fade" id="addScheduleModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered modal-dialog-scrollable">
        <div class="modal-content">

            <div class="modal-header">
                <h5 class="modal-title">
                    <i class="fas fa-plus-circle title-icon"></i> 일정 추가
                </h5>
                <button type="button" class="btn-close btn-close-custom" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>

            <div class="modal-body">
                <form id="saveRecommendForm">

                    <div class="ai-info-box">
                        <div class="ai-info-title">
                            <i class="fas fa-robot"></i> AI 추천 정보
                        </div>
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
                        <label for="schedDate" class="form-label-custom">
                            <i class="fas fa-calendar-alt form-label-icon"></i> 날짜 <span class="required-star">*</span>
                        </label>
                        <input type="date" class="form-control form-control-custom" id="schedDate" required>
                    </div>

                    <div class="mb-4">
                        <label for="schedName" class="form-label-custom">
                            <i class="fas fa-pen form-label-icon"></i> 일정 이름 <span class="required-star">*</span>
                        </label>
                        <input type="text" class="form-control form-control-custom" id="schedName" required placeholder="일정 이름을 입력해주세요">
                    </div>

                    <div class="mb-4">
                        <label for="mapAddress" class="form-label-custom">
                            <i class="fas fa-map-marker-alt form-label-icon"></i> 주소 <span class="required-star">*</span>
                        </label>
                        <textarea class="form-control form-control-custom" id="mapAddress" rows="2" required readonly placeholder="주소 정보"></textarea>
                        <div class="form-text ms-1 mt-1"><small>주소가 정확하지 않으면 직접 수정할 수 있습니다.</small></div>
                    </div>

                    <div class="card border-0 bg-light rounded-4 p-3">
                        <div class="d-flex align-items-center mb-3">
                            <i class="fas fa-route text-success me-2 fs-5"></i>
                            <span class="fw-bold text-dark">산책 코스 저장</span>
                        </div>

                        <div class="mb-2">
                            <label for="courseName" class="form-label-custom" style="font-size: 0.85rem;">코스 이름</label>
                            <input type="text" class="form-control form-control-custom" id="courseName" required>
                        </div>

                        <input type="hidden" id="courseType">
                        <input type="hidden" id="startLat">
                        <input type="hidden" id="startLng">
                        <input type="hidden" id="endLat">
                        <input type="hidden" id="endLng">
                        <input type="hidden" id="courseDistance">

                        <div class="d-flex align-items-center mt-2">
                            <span class="badge bg-success me-2 rounded-pill" id="displayCourseType"></span>
                            <small class="text-muted" style="font-size: 0.8rem;">이 코스는 지도의 '산책 코스' 탭에 저장됩니다.</small>
                        </div>
                    </div>

                </form>
            </div>

            <div class="modal-footer">
                <button type="button" class="btn btn-modal-cancel" data-bs-dismiss="modal">
                    <i class="fas fa-times me-1"></i> 취소
                </button>
                <button type="button" class="btn btn-modal-save" id="saveRecommendBtn">
                    <i class="fas fa-save me-1"></i> 저장
                </button>
            </div>
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

    document.addEventListener('DOMContentLoaded', function() {
        const recommendBtn = document.getElementById('recommendBtn');
        const resultsContainer = document.getElementById('recommendation-results');
        const loadingSpinner = document.getElementById('loadingSpinner');
        const modalElement = document.getElementById('addScheduleModal');
        const modal = new bootstrap.Modal(modalElement);
        let recommendMarkers = []; // AI 추천 마커만 관리하는 배열

        // 오늘 날짜로 초기화
        document.getElementById('schedDate').valueAsDate = new Date();

        // 1. 추천 시작 버튼 클릭
        recommendBtn.addEventListener('click', function() {
            const recId = ${not empty selectedRecipient ? selectedRecipient.recId : 'null'};

            if (!recId) {
                alert("추천을 위한 대상자 정보가 없습니다.");
                return;
            }

            resultsContainer.innerHTML = '';
            loadingSpinner.style.display = 'block';
            recommendBtn.disabled = true;

            fetch('/schedule/ai-recommend', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ recId: parseInt(recId) })
            })
            .then(response => response.json())
            .then(data => {
                loadingSpinner.style.display = 'none';
                recommendBtn.disabled = false;

                if (!data || data.length === 0) {
                    resultsContainer.innerHTML = '<div class="col-12 text-center py-5"><h4 class="text-muted">추천 결과가 없습니다.</h4></div>';
                    return;
                }

                displayRecommendationsOnMap(data); // 지도에 AI 추천 마커 표시
                
                data.forEach((item, index) => {
                    const cardCol = document.createElement('div');
                    cardCol.className = 'col-lg-4 col-md-6';
                    
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
                            <p class="card-text text-muted mb-2">
                                \${address ? `<i class="fas fa-map-marker-alt text-danger"></i> \${address} ` : ''}\${distance}
                            </p>
                            <div class="mt-auto pt-3">
                                <button class="btn btn-outline-primary w-100 mb-2 btn-summary-toggle">
                                    <i class="fas fa-align-left"></i> AI 요약 보기
                                </button>
                                <div class="summary-content mb-3">
                                    <strong><i class="fas fa-robot text-primary"></i> AI 추천 이유:</strong><br>
                                    \${item.mapContent}
                                </div>
                                <div class="d-flex gap-2 mb-2">
                                    <a href="https://map.kakao.com/?sName=\${encodeURIComponent(item.startAddress || '내 위치')}&eName=\${encodeURIComponent(item.mapName)}" target="_blank" class="btn btn-map flex-grow-1">
                                        <i class="fas fa-directions"></i> 길찾기
                                    </a>
                                    <a href="https://map.kakao.com/link/search/\${encodeURIComponent(item.mapName)}" target="_blank" class="btn btn-outline-secondary flex-grow-1">
                                        <i class="fas fa-search"></i> 검색
                                    </a>
                                </div>
                                <div class="d-grid">
                                    <button class="btn btn-success w-100 btn-add-schedule"
                                            data-mapname="\${item.mapName}" data-mapcontent="\${item.mapContent}"
                                            data-mapcategory="\${item.mapCategory}" data-mapaddress="\${address}"
                                            data-coursetype="\${item.courseType || 'WALK'}" data-startlat="\${item.startLat}"
                                            data-startlng="\${item.startLng}" data-endlat="\${item.y}"
                                            data-endlng="\${item.x}" data-distance="\${item.distance || 0}">
                                        <i class="fas fa-plus"></i> 일정에 추가
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>`;
                    resultsContainer.appendChild(cardCol);
                });

                addCardEventListeners();
            })
            .catch(error => {
                console.error('Error:', error);
                loadingSpinner.style.display = 'none';
                recommendBtn.disabled = false;
                resultsContainer.innerHTML = '<div class="col-12 text-center py-5"><h4 class="text-danger">오류가 발생했습니다. 잠시 후 다시 시도해주세요.</h4></div>';
            });
        });

        // AI 추천 결과를 지도에 표시하는 함수
        function displayRecommendationsOnMap(places) {
            // 기존 AI 추천 마커들 제거
            recommendMarkers.forEach(marker => marker.setMap(null));
            recommendMarkers = [];

            const bounds = new kakao.maps.LatLngBounds();

            // 집 마커가 있으면 bounds에 추가
            if (window.homeMarker) {
                bounds.extend(window.homeMarker.getPosition());
            }

            places.forEach((place, i) => {
                if (place.y && place.x) {
                    const position = new kakao.maps.LatLng(place.y, place.x);
                    
                    const imageSrc = 'https://t1.daumcdn.net/localimg/localimages/07/mapapidoc/markerStar.png'; 
                    const imageSize = new kakao.maps.Size(24, 35); 
                    const markerImage = new kakao.maps.MarkerImage(imageSrc, imageSize);

                    const marker = new kakao.maps.Marker({
                        map: map, // center.js에서 생성된 메인 지도 사용
                        position: position,
                        title: place.mapName,
                        image: markerImage 
                    });
                    
                    recommendMarkers.push(marker);
                    bounds.extend(position);

                    const infowindow = new kakao.maps.InfoWindow({
                        content: `<div style="padding:5px;font-size:12px;color:blue;">[추천] \${place.mapName}</div>`
                    });

                    kakao.maps.event.addListener(marker, 'mouseover', function() {
                        infowindow.open(map, marker);
                    });
                    kakao.maps.event.addListener(marker, 'mouseout', function() {
                        infowindow.close();
                    });
                }
            });

            if (recommendMarkers.length > 0) {
                map.setBounds(bounds);
            }
        }

        // 카드와 마커 상호작용
        function addCardEventListeners() {
            document.querySelectorAll('.recommend-card').forEach(card => {
                card.addEventListener('mouseover', function() {
                    const index = this.dataset.index;
                    if (recommendMarkers[index]) {
                        recommendMarkers[index].setZIndex(100);
                    }
                });
                card.addEventListener('mouseout', function() {
                    const index = this.dataset.index;
                    if (recommendMarkers[index]) {
                        recommendMarkers[index].setZIndex(0);
                    }
                });
            });

            document.querySelectorAll('.btn-summary-toggle').forEach(btn => {
                btn.addEventListener('click', function() {
                    const summary = this.nextElementSibling;
                    if (summary.style.display === 'block') {
                        summary.style.display = 'none';
                        this.innerHTML = '<i class="fas fa-align-left"></i> AI 요약 보기';
                    } else {
                        summary.style.display = 'block';
                        this.innerHTML = '<i class="fas fa-chevron-up"></i> 요약 접기';
                    }
                });
            });

            document.querySelectorAll('.btn-add-schedule').forEach(btn => {
                btn.addEventListener('click', function() {
                    // ... (기존 모달 열기 로직)
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

        // 모달 저장 버튼 클릭
        document.getElementById('saveRecommendBtn').addEventListener('click', function() {
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
                } else {
                    alert(result.message);
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert('저장 중 오류가 발생했습니다.');
            });
        });
    });
    
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
                // 함수가 존재할 때만 실행하도록 변경
                if (typeof loadRecipientLocationMarker === 'function') {
                    loadRecipientLocationMarker();
                } else {
                    console.warn('loadRecipientLocationMarker 함수를 찾을 수 없습니다.');
                }
            }, 1000);
        }
        
        // 저장된 장소들의 주소 가져오기
        loadMapLocationAddresses();
    });
    
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