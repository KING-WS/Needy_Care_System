<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<link href='https://cdn.jsdelivr.net/npm/fullcalendar/main.min.css' rel='stylesheet' />
<link rel="stylesheet" href="<c:url value='/css/mealplan.css'/>" />

<style>
    /* ---------------------------------------------------- */
    /* 1. 디자인 시스템 (center.jsp 통일) */
    /* ---------------------------------------------------- */
    :root {
        --primary-color: #3498db;   /* 메인 블루 */
        --secondary-color: #343a40; /* 진한 회색 */
        --secondary-bg: #F0F8FF;    /* 연한 배경 */
        --card-bg: white;
        --danger-color: #e74c3c;
        --success-color: #2ecc71;
    }

    body {
        background-color: #f8f9fa;
        font-family: 'Noto Sans KR', sans-serif;
    }

    .schedule-section {
        max-width: 1400px;
        margin: 0 auto;
        padding: 40px 20px 100px 20px;
    }

    /* ---------------------------------------------------- */
    /* 2. 헤더 & 카드 스타일 */
    /* ---------------------------------------------------- */
    .page-header {
        text-align: center;
        margin-bottom: 40px;
    }

    .page-header h1 {
        font-size: 38px;
        font-weight: 800;
        text-shadow: 0 1px 2px rgba(0, 0, 0, 0.05);
        margin-bottom: 10px;
        color: var(--secondary-color);
    }

    .page-header p {
        font-size: 16px;
        color: #7f8c8d;
    }

    /* 카드 공통 스타일 */
    .detail-content-card {
        background: var(--card-bg);
        border-radius: 20px;
        padding: 30px;
        box-shadow: 0 10px 30px rgba(0,0,0,0.05);
        margin-bottom: 30px;
        height: 100%;
    }

    /* ---------------------------------------------------- */
    /* 3. FullCalendar 커스텀 */
    /* ---------------------------------------------------- */
    #calendar {
        min-height: 600px;
    }

    .fc-toolbar-title {
        font-size: 24px !important;
        font-weight: 700 !important;
        color: var(--secondary-color);
    }

    .fc-button-primary {
        background-color: var(--primary-color) !important;
        border-color: var(--primary-color) !important;
        border-radius: 50px !important; /* 캡슐형 버튼 */
        padding: 8px 20px !important;
        font-weight: 600 !important;
        box-shadow: 0 4px 10px rgba(52, 152, 219, 0.3) !important;
        transition: all 0.3s ease !important;
    }

    .fc-button-primary:hover {
        background-color: #2980b9 !important;
        border-color: #2980b9 !important;
        transform: translateY(-2px);
    }

    .fc-button-active {
        background-color: #2c3e50 !important;
        border-color: #2c3e50 !important;
    }

    .fc-daygrid-day {
        transition: background 0.2s;
    }
    .fc-daygrid-day:hover {
        background: #f1f8ff;
    }

    .fc-event {
        border-radius: 5px;
        padding: 2px 5px;
        font-size: 13px;
        border: none;
        box-shadow: 0 2px 5px rgba(0,0,0,0.1);
    }

    /* ---------------------------------------------------- */
    /* 4. 통계 영역 (우측 사이드) */
    /* ---------------------------------------------------- */
    .stats-container {
        display: flex;
        flex-direction: column;
        gap: 15px;
    }

    .stat-item {
        background: white;
        border-radius: 15px;
        padding: 22px; /* Adjusted from 25px */
        display: flex;
        align-items: center;
        gap: 18px; /* Adjusted from 20px */
        box-shadow: 0 5px 15px rgba(0,0,0,0.03);
        border: 1px solid rgba(0,0,0,0.03);
        transition: transform 0.3s ease;
    }

    .stat-item:hover {
        transform: translateY(-3px);
        box-shadow: 0 8px 20px rgba(0,0,0,0.08);
        border-color: var(--primary-color);
    }

    .stat-icon {
        width: 50px; /* Adjusted from 55px */
        height: 50px; /* Adjusted from 55px */
        border-radius: 12px;
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 22px; /* Adjusted from 24px */
        color: white;
        flex-shrink: 0;
    }

    /* 아이콘 색상 테마 */
    .stat-item:nth-child(1) .stat-icon { background: #3498db; } /* 오늘 */
    .stat-item:nth-child(2) .stat-icon { background: #e67e22; } /* 이번주 */
    .stat-item:nth-child(3) .stat-icon { background: #2ecc71; } /* 이번달 */

    .stat-content {
        display: flex;
        flex-direction: column;
    }

    .stat-label {
        font-size: 14px; /* Adjusted from 16px */
        color: #7f8c8d;
        font-weight: 600;
        margin-bottom: 5px;
    }

    .stat-value {
        font-size: 27px; /* Adjusted from 30px */
        font-weight: 800;
        color: var(--secondary-color);
    }

    /* AI 일정 추천 버튼 */
    .ai-schedule-btn {
        width: 100%;
        margin-top: 20px;
        padding: 50px; /* Adjusted from 55px */
        background: var(--primary-color);
        color: white;
        border: none;
        border-radius: 15px;
        font-size: 33px; /* Adjusted from 36px */
        font-weight: 700;
        cursor: pointer;
        display: flex;
        align-items: center;
        justify-content: center;
        gap: 10px;
        box-shadow: 0 4px 15px rgba(52, 152, 219, 0.4);
        transition: all 0.3s ease;
    }

    .ai-schedule-btn span {
        white-space: nowrap; /* Prevent text from wrapping */
        writing-mode: horizontal-tb; /* Explicitly set horizontal writing mode */
    }

    .ai-schedule-btn:hover {
        background: #2980b9;
        transform: translateY(-2px);
        box-shadow: 0 6px 20px rgba(52, 152, 219, 0.6);
    }

    /* Styling for the AI Schedule Recommendation Button to match stat-item */
    .ai-schedule-btn {
        width: 100%;
        margin-top: 20px;
        padding: 22px; /* Adjusted to match stat-item padding */
        background: var(--primary-color);
        color: white;
        border: none;
        border-radius: 15px; /* Matched stat-item border-radius */
        font-weight: 700;
        cursor: pointer;
        display: flex; /* Kept flex display */
        align-items: center; /* Kept align-items */
        gap: 18px; /* Matched stat-item gap */
        box-shadow: 0 4px 15px rgba(52, 152, 219, 0.4);
        transition: all 0.3s ease;
        text-align: left; /* Align text to the left */
    }

    .ai-schedule-btn .ai-btn-icon {
        width: 50px; /* Matched stat-icon width */
        height: 50px; /* Matched stat-icon height */
        border-radius: 12px;
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 22px; /* Matched stat-icon font-size */
        color: var(--primary-color); /* Similar to stat-icon colors */
        background: white; /* Similar to stat-icon background */
        flex-shrink: 0;
    }

    .ai-schedule-btn .ai-btn-content {
        display: flex;
        flex-direction: column;
        justify-content: center;
    }

    .ai-schedule-btn .ai-btn-label {
        font-size: 27px; /* Matched stat-value font-size */
        font-weight: 800; /* Matched stat-value font-weight */
        color: white; /* Make text white as button background is primary color */
    }


    /* ---------------------------------------------------- */
    /* 5. 모달 스타일 (공통) */
    /* ---------------------------------------------------- */
    .modal-overlay {
        display: none;
        position: fixed;
        top: 0; left: 0; width: 100%; height: 100%;
        background: rgba(0, 0, 0, 0.5);
        z-index: 9999;
        align-items: center;
        justify-content: center;
        backdrop-filter: blur(3px);
    }
    .modal-overlay.show { display: flex !important; }

    .modal-content {
        background: white;
        border-radius: 20px;
        width: 90%;
        max-width: 600px;
        max-height: 90vh;
        overflow-y: auto;
        box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.25);
        animation: slideUp 0.3s ease;
        border: none;
    }

    @keyframes slideUp {
        from { opacity: 0; transform: translateY(20px); }
        to { opacity: 1; transform: translateY(0); }
    }

    .modal-header {
        padding: 25px 30px 10px 30px;
        display: flex;
        align-items: center;
        justify-content: space-between;
    }

    .modal-title {
        font-size: 22px;
        font-weight: 800;
        color: var(--secondary-color);
        margin: 0;
        display: flex;
        align-items: center;
        gap: 10px;
    }
    .modal-title i { color: var(--primary-color); }

    .modal-close-btn {
        width: 36px; height: 36px;
        border: none; background: #f1f3f5; color: #868e96;
        border-radius: 50%; cursor: pointer;
        display: flex; align-items: center; justify-content: center;
        transition: all 0.2s;
    }
    .modal-close-btn:hover { background: var(--danger-color); color: white; }

    .modal-body { padding: 10px 30px 30px 30px; }

    /* 입력 폼 스타일 */
    .form-group { margin-bottom: 20px; }
    .form-label {
        display: block; font-size: 14px; font-weight: 600;
        color: var(--secondary-color); margin-bottom: 8px;
    }
    .form-label i { color: var(--primary-color); margin-right: 5px; }

    .form-control, .form-select {
        width: 100%;
        background: var(--secondary-bg);
        border: 1px solid transparent;
        border-radius: 12px;
        padding: 12px 15px;
        font-size: 15px;
        transition: all 0.3s ease;
        color: var(--secondary-color);
    }
    .form-control:focus, .form-select:focus {
        background: white; outline: none;
        border-color: var(--primary-color);
        box-shadow: 0 0 0 3px rgba(52, 152, 219, 0.1);
    }

    .modal-footer {
        padding: 20px 30px;
        background: #fafafa;
        border-radius: 0 0 20px 20px;
        display: flex;
        justify-content: flex-end;
        gap: 10px;
    }

    /* 버튼 스타일 */
    .btn {
        padding: 12px 24px;
        border-radius: 50px;
        font-weight: 600;
        border: none;
        cursor: pointer;
        transition: all 0.3s;
        display: inline-flex; align-items: center; gap: 6px;
        font-size: 14px;
    }
    .btn-primary {
        background: var(--primary-color); color: white;
        box-shadow: 0 4px 10px rgba(52, 152, 219, 0.3);
    }
    .btn-primary:hover {
        background: #2980b9; transform: translateY(-2px);
    }
    .btn-secondary {
        background: #95a5a6; color: white;
    }
    .btn-secondary:hover { background: #7f8c8d; }
    .btn-danger {
        background: var(--danger-color); color: white;
        box-shadow: 0 4px 10px rgba(231, 76, 60, 0.3);
    }
    .btn-danger:hover { background: #c0392b; transform: translateY(-2px); }
    .btn-cancel {
        background: #f1f3f5; color: #495057;
    }
    .btn-cancel:hover { background: #e9ecef; }

    .required { color: var(--danger-color); }
    .form-hint { font-size: 12px; color: #7f8c8d; margin-top: 5px; display: block; }

    /* ---------------------------------------------------- */
    /* 6. 시간대별 일정 리스트 & AI 추천 결과 */
    /* ---------------------------------------------------- */
    .hourly-list { display: flex; flex-direction: column; gap: 10px; }

    .hourly-item, .timeline-item {
        background: white;
        border: 1px solid #eee;
        border-left: 4px solid var(--primary-color);
        padding: 15px;
        border-radius: 10px;
        cursor: pointer;
        transition: all 0.2s;
        box-shadow: 0 2px 5px rgba(0,0,0,0.03);
    }
    .hourly-item:hover, .timeline-item:hover {
        transform: translateX(5px);
        box-shadow: 0 5px 15px rgba(0,0,0,0.08);
        border-color: var(--primary-color);
    }

    .hourly-time, .timeline-time {
        font-weight: 700; color: var(--primary-color);
        font-size: 14px; margin-bottom: 5px;
        display: flex; align-items: center; gap: 5px;
    }

    .schedule-timeline {
        display: flex; flex-direction: column; gap: 10px; margin-top: 15px;
    }

    /* 반응형 */
    @media (max-width: 991px) {
        .col-lg-10, .col-lg-2 { width: 100%; }
        .stats-container {
            flex-direction: row; flex-wrap: wrap; margin-top: 30px;
        }
        .stat-item { flex: 1; min-width: 200px; }
    }
</style>

<section class="schedule-section">
    <div class="page-header">
        <h1>
            <i class="fas fa-calendar-alt" style="color: var(--primary-color);"></i> Needy 일정 관리
        </h1>
        <p>
            <i class="fas fa-user-md"></i> ${sessionScope.loginUser.custName} 님의 Needy 스케줄
        </p>
    </div>

    <div class="row">
        <div class="col-lg-9">
            <div class="detail-content-card">
                <div id="calendar"></div>
            </div>
        </div>

        <div class="col-lg-3">
            <div class="stats-container">
                <div class="stat-item">
                    <div class="stat-icon"><i class="fas fa-calendar-check"></i></div>
                    <div class="stat-content">
                        <div class="stat-label">오늘 일정</div>
                        <div class="stat-value" id="todayCount">0</div>
                    </div>
                </div>

                <div class="stat-item">
                    <div class="stat-icon"><i class="fas fa-calendar-week"></i></div>
                    <div class="stat-content">
                        <div class="stat-label">이번 주</div>
                        <div class="stat-value" id="weekCount">0</div>
                    </div>
                </div>

                <div class="stat-item">
                    <div class="stat-icon"><i class="fas fa-calendar-alt"></i></div>
                    <div class="stat-content">
                        <div class="stat-label">이번 달</div>
                        <div class="stat-value" id="monthCount">0</div>
                    </div>
                </div>

                <button class="ai-schedule-btn" onclick="openAiScheduleModal()">
                    <div class="stat-icon ai-btn-icon"><i class="fas fa-magic"></i></div>
                    <div class="ai-btn-content">
                        <div class="ai-btn-label">AI 일정 추천</div>
                    </div>
                </button>
            </div>
        </div>
    </div>
</section>

<div class="modal-overlay" id="dayDetailModal">
    <div class="modal-content" style="max-width: 800px;">
        <div class="modal-header">
            <h5 class="modal-title" id="dayDetailTitle">
                <i class="fas fa-calendar-day"></i> 날짜
            </h5>
            <button type="button" class="modal-close-btn" onclick="closeDayDetailModal()"><i class="fas fa-times"></i></button>
        </div>
        <div class="modal-body" id="dayDetailBody">
            <div class="day-schedule-info">
                <h3 id="scheduleTitle" style="font-size: 20px; font-weight: 700; color: var(--secondary-color); margin-bottom: 20px;">일정 제목</h3>
            </div>
            <div id="hourlySchedulesContainer"></div>
        </div>
        <div class="modal-footer">
            <button type="button" class="btn btn-primary" id="addHourlyBtn">
                <i class="fas fa-plus"></i> 시간대별 추가
            </button>
            <button type="button" class="btn btn-secondary" id="editScheduleBtn">
                <i class="fas fa-edit"></i> 제목 수정
            </button>
            <button type="button" class="btn btn-cancel" onclick="closeDayDetailModal()">
                <i class="fas fa-times"></i> 닫기
            </button>
        </div>
    </div>
</div>

<div class="modal-overlay" id="scheduleModal">
    <div class="modal-content">
        <div class="modal-header">
            <h5 class="modal-title" id="scheduleModalTitle">
                <i class="fas fa-plus-circle"></i> 일정 등록
            </h5>
            <button type="button" class="modal-close-btn" onclick="closeScheduleModal()"><i class="fas fa-times"></i></button>
        </div>
        <div class="modal-body">
            <form id="scheduleForm">
                <input type="hidden" id="schedId">
                <input type="hidden" id="selectedDate">

                <div class="form-group">
                    <label class="form-label"><i class="fas fa-heading"></i> 일정 제목</label>
                    <input type="text" class="form-control" id="schedName" placeholder="예: 오늘의 일정" required>
                </div>
            </form>
        </div>
        <div class="modal-footer">
            <button type="button" class="btn btn-cancel" onclick="closeScheduleModal()">
                <i class="fas fa-times"></i> 취소
            </button>
            <button type="button" class="btn btn-danger" id="deleteScheduleBtn" style="display:none;">
                <i class="fas fa-trash"></i> 삭제
            </button>
            <button type="button" class="btn btn-primary" id="saveScheduleBtn">
                <i class="fas fa-save"></i> 저장
            </button>
        </div>
    </div>
</div>

<div class="modal-overlay" id="hourlyModal">
    <div class="modal-content">
        <div class="modal-header">
            <h5 class="modal-title" id="hourlyModalTitle">
                <i class="fas fa-plus-circle"></i> 시간대별 일정 추가
            </h5>
            <button type="button" class="modal-close-btn" onclick="closeHourlyModal()"><i class="fas fa-times"></i></button>
        </div>
        <div class="modal-body">
            <form id="hourlyForm">
                <input type="hidden" id="hourlySchedId">
                <input type="hidden" id="parentSchedId">

                <div class="form-group">
                    <label class="form-label"><i class="fas fa-heading"></i> 제목</label>
                    <input type="text" class="form-control" id="hourlySchedName" placeholder="예: 점심 식사" required>
                </div>

                <div class="row">
                    <div class="col-6 mb-3">
                        <label class="form-label"><i class="fas fa-clock"></i> 시작 시간</label>
                        <div class="d-flex gap-2">
                            <select id="hourlyStartHour" class="form-select"></select>
                            <select id="hourlyStartMinute" class="form-select"></select>
                        </div>
                    </div>
                    <div class="col-6 mb-3">
                        <label class="form-label"><i class="fas fa-clock"></i> 종료 시간</label>
                        <div class="d-flex gap-2">
                            <select id="hourlyEndHour" class="form-select"></select>
                            <select id="hourlyEndMinute" class="form-select"></select>
                        </div>
                    </div>
                </div>

                <div class="form-group">
                    <label class="form-label"><i class="fas fa-align-left"></i> 상세 내용</label>
                    <textarea class="form-control" id="hourlySchedContent" rows="3" placeholder="상세 내용을 입력하세요"></textarea>
                </div>
            </form>
        </div>
        <div class="modal-footer">
            <button type="button" class="btn btn-cancel" onclick="closeHourlyModal()">
                <i class="fas fa-times"></i> 취소
            </button>
            <button type="button" class="btn btn-danger" id="deleteHourlyBtn" style="display:none;">
                <i class="fas fa-trash"></i> 삭제
            </button>
            <button type="button" class="btn btn-primary" id="saveHourlyBtn">
                <i class="fas fa-save"></i> 저장
            </button>
        </div>
    </div>
</div>

<div class="modal-overlay" id="aiScheduleModal">
    <div class="modal-content">
        <div class="modal-header">
            <h3 class="modal-title">
                <i class="fas fa-magic"></i> AI 일정 추천
            </h3>
            <button class="modal-close-btn" onclick="closeAiScheduleModal()">
                <i class="fas fa-times"></i>
            </button>
        </div>
        <div class="modal-body">
            <form id="aiScheduleForm">
                <div class="form-group">
                    <label class="form-label">
                        <i class="fas fa-calendar"></i> 날짜
                    </label>
                    <input type="date" id="aiScheduleDate" class="form-control" readonly style="cursor: not-allowed; opacity: 0.7;">
                    <small class="form-hint">특이사항에 날짜를 입력하면 자동으로 설정됩니다. (예: 이번주 금요일, 이번달 23일)</small>
                </div>

                <div class="form-group">
                    <label class="form-label">
                        <i class="fas fa-cog"></i> 추천 모드 <span class="required">*</span>
                    </label>
                    <div style="display: flex; flex-direction: column; gap: 10px; margin-top: 10px;">
                        <label style="display: flex; align-items: center; cursor: pointer; padding: 15px; background: var(--secondary-bg); border-radius: 12px; border: 1px solid transparent; transition: all 0.2s;">
                            <input type="radio" name="recommendMode" value="basic" checked style="margin-right: 15px; transform: scale(1.2);">
                            <div>
                                <strong style="color: var(--secondary-color);">기본 일정 추천</strong>
                                <div style="font-size: 13px; color: #7f8c8d; margin-top: 5px;">식사 시간, 약 복용, 기본 활동 등을 포함한 일정</div>
                            </div>
                        </label>
                        <label style="display: flex; align-items: center; cursor: pointer; padding: 15px; background: var(--secondary-bg); border-radius: 12px; border: 1px solid transparent; transition: all 0.2s;">
                            <input type="radio" name="recommendMode" value="custom" style="margin-right: 15px; transform: scale(1.2);">
                            <div>
                                <strong style="color: var(--secondary-color);">특이사항 기반 맞춤형 추천</strong>
                                <div style="font-size: 13px; color: #7f8c8d; margin-top: 5px;">특이사항에 작성한 활동을 중심으로 건강 상태를 고려한 시간표</div>
                            </div>
                        </label>
                    </div>
                </div>

                <div class="form-group">
                    <label class="form-label">
                        <i class="fas fa-list-alt"></i> 특이사항 <span class="required" id="specialNotesRequired" style="display: none;">*</span>
                    </label>
                    <textarea id="aiSpecialNotes" class="form-control" rows="4"
                              placeholder="기본 모드: 추가 고려사항 입력 (예: 오늘은 병원 방문이 있습니다.)&#10;맞춤형 모드: 원하는 활동을 입력하세요 (예: 공원에 가고 싶어요, 도서관 방문 등)"></textarea>
                    <small class="form-hint" id="specialNotesHint">기본 모드: 입력하지 않으시면 대상자의 기존 건강 정보를 기반으로 AI가 최적의 스케줄을 추천합니다.</small>
                </div>
                <div id="aiScheduleResult" class="form-group" style="display: none;">
                </div>
            </form>
        </div>
        <div class="modal-footer">
            <button class="btn btn-cancel" onclick="closeAiScheduleModal()">
                <i class="fas fa-times"></i> 닫기
            </button>
            <button class="btn btn-primary" onclick="getAiScheduleRecommendation()">
                <i class="fas fa-robot"></i> 추천받기
            </button>
        </div>
    </div>
</div>

<script src='https://cdn.jsdelivr.net/npm/fullcalendar@6.1.10/index.global.min.js'></script>
<script src='https://cdn.jsdelivr.net/npm/@fullcalendar/core@6.1.10/locales/ko.global.min.js'></script>

<script>
    let calendar;
    let currentSchedule = null;

    // ✅ 수정: Controller에서 model로 전달받은 selectedRecipient 사용
    let currentRecId = ${not empty selectedRecipient ? selectedRecipient.recId : 0};

    // 노약자 변경 함수 (URL 수정)
    function changeRecipient() {
        const recId = document.getElementById('recipientSelect').value;
        if (recId) {
            // BUG FIX: Controller 경로에 맞게 '/schedule'로 수정
            location.href = '/schedule?recId=' + recId;
        }
    }

    document.addEventListener('DOMContentLoaded', function() {
        // recId가 없으면 경고 후, 캘린더 로드를 막음
        if (!currentRecId || currentRecId === 0) {
            document.getElementById('calendar').innerHTML = '<div style="text-align:center; padding:40px; color:red;">돌봄 대상자 정보를 불러오는 데 실패했습니다. 관리자에게 문의하세요.</div>';
            return;
        }

        const calendarEl = document.getElementById('calendar');

        calendar = new FullCalendar.Calendar(calendarEl, {
            locale: 'ko',
            initialView: 'dayGridMonth',
            headerToolbar: {
                left: 'prev,next today',
                center: 'title',
                right: 'dayGridMonth'
            },
            buttonText: {
                today: '오늘',
                month: '월간'
            },
            height: 'auto',
            dayMaxEvents: 3,

            dateClick: function(info) {
                openScheduleModal('create', info.date);
            },

            eventClick: function(info) {
                info.jsEvent.preventDefault();
                loadScheduleDetail(info.event.id);
            },

            events: function(fetchInfo, successCallback, failureCallback) {
                const selectedRecId = currentRecId;

                if (!selectedRecId || selectedRecId === 0 || selectedRecId === "0") {
                    const error = new Error("돌봄 대상자 ID가 없습니다. ID: " + selectedRecId);
                    failureCallback(error);
                    return;
                }

                if (!fetchInfo || !fetchInfo.start || !fetchInfo.end) {
                    const error = new Error("날짜 정보(fetchInfo)가 올바르지 않습니다.");
                    failureCallback(error);
                    return;
                }

                // FullCalendar의 end 날짜는 exclusive이므로, inclusive 쿼리를 위해 하루를 뺍니다.
                const endDate = new Date(fetchInfo.end);
                endDate.setDate(endDate.getDate() - 1);

                const startDateStr = fetchInfo.start.toISOString().split('T')[0];
                const endDateStr = endDate.toISOString().split('T')[0];

                const url = '/schedule/api/monthly?recId=' + selectedRecId + '&startDate=' + startDateStr + '&endDate=' + endDateStr;

                fetch(url, { cache: 'no-cache' })
                    .then(res => {
                        if (!res.ok) {
                            throw new Error(`서버 응답 오류: ${res.status}`);
                        }
                        const contentType = res.headers.get("content-type");
                        if (contentType && contentType.indexOf("application/json") !== -1) {
                            return res.json();
                        } else {
                            return []; // JSON이 아니면 빈 배열로 처리
                        }
                    })
                    .then(data => {
                        if (data && Array.isArray(data)) {
                            const events = data.map(schedule => ({
                                id: schedule.schedId,
                                title: schedule.schedName,
                                start: schedule.schedDate,
                                backgroundColor: '#3498db', // Primary color
                                borderColor: '#3498db'
                            }));
                            successCallback(events);
                        } else {
                            // 데이터가 비어있는 경우 (200 OK 이지만 내용이 없는 경우)
                            successCallback([]);
                        }
                    })
                    .catch(error => {
                        console.error("월별 일정 로딩 중 오류 발생:", error);
                        failureCallback(error);
                    });
            },

            eventDidMount: function() {
                updateStats();
            },

            eventsSet: function() { // eventsSet is a better hook for this
                updateStats();
            }
        });

        calendar.render();

        // 일정 등록 버튼
        document.getElementById('saveScheduleBtn').addEventListener('click', saveSchedule);
        document.getElementById('deleteScheduleBtn').addEventListener('click', deleteSchedule);

        // 시간대별 일정 버튼
        document.getElementById('addHourlyBtn').addEventListener('click', () => openHourlyModal('create'));
        document.getElementById('editScheduleBtn').addEventListener('click', () => {
            closeDayDetailModal();
            setTimeout(() => openScheduleModal('edit', null, currentSchedule), 300);
        });
        document.getElementById('saveHourlyBtn').addEventListener('click', saveHourlySchedule);
        document.getElementById('deleteHourlyBtn').addEventListener('click', deleteHourlySchedule);

        populateTimeSelects();
    });

    function populateTimeSelects() {
        const hourSelects = [document.getElementById('hourlyStartHour'), document.getElementById('hourlyEndHour')];
        const minuteSelects = [document.getElementById('hourlyStartMinute'), document.getElementById('hourlyEndMinute')];

        for (let i = 0; i < 24; i++) {
            const hour = String(i).padStart(2, '0');
            hourSelects.forEach(sel => sel.add(new Option(hour, hour)));
        }
        for (let i = 0; i < 60; i++) {
            const minute = String(i).padStart(2, '0');
            minuteSelects.forEach(sel => sel.add(new Option(minute, minute)));
        }
    }


    // 일정 상세 로드
    function loadScheduleDetail(schedId) {
        fetch('/schedule/api/schedule/' + schedId, { cache: 'no-cache' })
            .then(res => res.json())
            .then(schedule => {
                console.log('서버로부터 받은 메인 일정 데이터:', schedule); // 디버깅용 로그
                if (schedule.success === false) {
                    alert(schedule.message || '일정 정보를 불러오지 못했습니다.');
                    return;
                }
                currentSchedule = schedule;

                const dateStr = schedule.schedDate; // e.g., '2025-11-20'
                let formattedDate = '날짜 정보 없음';
                if (dateStr && dateStr.includes('-')) {
                    const parts = dateStr.split('-');
                    const year = parts[0];
                    const month = parts[1];
                    const day = parts[2];
                    formattedDate = year + '년 ' + month + '월 ' + day + '일';
                }
                document.getElementById('dayDetailTitle').innerHTML =
                    '<i class="fas fa-calendar-day"></i> ' + formattedDate;

                document.getElementById('scheduleTitle').textContent = schedule.schedName;

                loadHourlySchedules(schedId);
                document.getElementById('dayDetailModal').classList.add('show');
            })
            .catch(err => {
                console.error('Error fetching schedule details:', err);
                alert('일정 상세 정보를 불러오는 중 오류가 발생했습니다.');
            });
    }

    // 시간대별 일정 로드
    function loadHourlySchedules(schedId) {
        fetch('/schedule/api/hourly/' + schedId, { cache: 'no-cache' })
            .then(res => res.json())
            .then(data => {
                console.log('서버로부터 받은 시간대별 일정 데이터:', data); // 디버깅용 로그
                const container = document.getElementById('hourlySchedulesContainer');
                if (data.length === 0) {
                    container.innerHTML = '<p class="text-center" style="color:#adb5bd; padding:20px;">등록된 시간대별 일정이 없습니다.</p>';
                } else {
                    let html = '<div class="hourly-list">';
                    data.forEach(function(hourly) {
                        var onclick_handler = hourly.hourlySchedId ? 'onclick="editHourlySchedule(' + hourly.hourlySchedId + ')"' : '';
                        html +=
                            '<div class="hourly-item" ' + onclick_handler + '>' +
                            '<div class="hourly-time">' +
                            '<i class="fas fa-clock"></i> ' +
                            (hourly.hourlySchedStartTime || '') + ' - ' + (hourly.hourlySchedEndTime || '') +
                            '</div>' +
                            '<div class="hourly-content">' +
                            '<h6>' + (hourly.hourlySchedName || '') + '</h6>' +
                            '<p>' + (hourly.hourlySchedContent || '') + '</p>' +
                            '</div>' +
                            '</div>';
                    });
                    html += '</div>';
                    container.innerHTML = html;
                }
            });
    }

    function closeDayDetailModal() { document.getElementById('dayDetailModal').classList.remove('show'); }
    function closeScheduleModal() { document.getElementById('scheduleModal').classList.remove('show'); }
    function closeHourlyModal() { document.getElementById('hourlyModal').classList.remove('show'); }

    // 일정 등록/수정 모달 열기
    function openScheduleModal(mode, date, schedule) {
        if (mode === 'create') {
            document.getElementById('scheduleModalTitle').innerHTML = '<i class="fas fa-plus-circle"></i> 일정 등록';
            document.getElementById('deleteScheduleBtn').style.display = 'none';
            document.getElementById('schedId').value = '';
            document.getElementById('schedName').value = '';
            document.getElementById('selectedDate').value = formatDate(date);
        } else {
            document.getElementById('scheduleModalTitle').innerHTML = '<i class="fas fa-edit"></i> 일정 수정';
            document.getElementById('deleteScheduleBtn').style.display = 'block';
            document.getElementById('schedId').value = schedule.schedId;
            document.getElementById('schedName').value = schedule.schedName;
            document.getElementById('selectedDate').value = schedule.schedDate;
        }
        document.getElementById('scheduleModal').classList.add('show');
    }

    // 일정 저장
    function saveSchedule() {
        const schedId = document.getElementById('schedId').value;
        const schedName = document.getElementById('schedName').value;
        const schedDate = document.getElementById('selectedDate').value;

        if (!schedName) {
            alert('일정 제목을 입력하세요.');
            return;
        }

        const data = {
            recId: currentRecId,
            schedName: schedName,
            schedDate: schedDate
        };

        const url = schedId ? '/schedule/api/schedule' : '/schedule/api/schedule';
        const method = schedId ? 'PUT' : 'POST';

        if (schedId) data.schedId = schedId;

        fetch(url, {
            method: method,
            headers: {'Content-Type': 'application/json'},
            body: JSON.stringify(data)
        })
            .then(res => res.json())
            .then(result => {
                if (result.success) {
                    alert(schedId ? '수정되었습니다.' : '등록되었습니다.');
                    closeScheduleModal();
                    calendar.refetchEvents();
                } else {
                    alert('저장에 실패했습니다: ' + (result.message || '알 수 없는 오류'));
                }
            })
            .catch(error => {
                console.error("일정 저장 중 오류 발생:", error);
                alert("일정 저장 중 오류가 발생했습니다.");
            });
    }

    // 일정 삭제
    function deleteSchedule() {
        if (!confirm('일정을 삭제하시겠습니까? 이 작업은 되돌릴 수 없습니다.')) return;

        const schedId = document.getElementById('schedId').value;
        fetch('/schedule/api/schedule/' + schedId, {method: 'DELETE'})
            .then(res => res.json())
            .then(result => {
                if (result.success) {
                    alert('삭제되었습니다.');
                    closeScheduleModal();
                    closeDayDetailModal(); // 상세 모달도 닫기
                    calendar.refetchEvents();
                } else {
                    alert('삭제에 실패했습니다: ' + (result.message || '알 수 없는 오류'));
                }
            })
            .catch(error => {
                console.error("일정 삭제 중 오류 발생:", error);
                alert("일정 삭제 중 오류가 발생했습니다.");
            });
    }

    // 시간대별 일정 모달 열기
    function openHourlyModal(mode, hourlySchedId) {
        if (mode === 'create') {
            document.getElementById('hourlyModalTitle').innerHTML = '<i class="fas fa-plus-circle"></i> 시간대별 일정 추가';
            document.getElementById('deleteHourlyBtn').style.display = 'none';
            document.getElementById('hourlySchedId').value = '';
            document.getElementById('hourlySchedName').value = '';
            document.getElementById('hourlyStartHour').value = '00';
            document.getElementById('hourlyStartMinute').value = '00';
            document.getElementById('hourlyEndHour').value = '00';
            document.getElementById('hourlyEndMinute').value = '00';
            document.getElementById('hourlySchedContent').value = '';
            document.getElementById('parentSchedId').value = currentSchedule.schedId;
        }
        document.getElementById('hourlyModal').classList.add('show');
    }

    // 시간대별 일정 수정 모달 열기
    function editHourlySchedule(hourlySchedId) {
        fetch('/schedule/api/hourly/detail/' + hourlySchedId)
            .then(res => res.json())
            .then(hourly => {
                if (hourly.success === false) {
                    alert(hourly.message || '시간대별 일정 정보를 불러오지 못했습니다.');
                    return;
                }
                document.getElementById('hourlyModalTitle').innerHTML = '<i class="fas fa-edit"></i> 시간대별 일정 수정';
                document.getElementById('deleteHourlyBtn').style.display = 'block';
                document.getElementById('hourlySchedId').value = hourly.hourlySchedId;
                document.getElementById('hourlySchedName').value = hourly.hourlySchedName;

                if (hourly.hourlySchedStartTime) {
                    const startTimeParts = hourly.hourlySchedStartTime.split(':');
                    document.getElementById('hourlyStartHour').value = startTimeParts[0];
                    document.getElementById('hourlyStartMinute').value = startTimeParts[1];
                }
                if (hourly.hourlySchedEndTime) {
                    const endTimeParts = hourly.hourlySchedEndTime.split(':');
                    document.getElementById('hourlyEndHour').value = endTimeParts[0];
                    document.getElementById('hourlyEndMinute').value = endTimeParts[1];
                }

                document.getElementById('hourlySchedContent').value = hourly.hourlySchedContent || '';
                document.getElementById('parentSchedId').value = hourly.schedId;
                closeDayDetailModal();
                document.getElementById('hourlyModal').classList.add('show');
            })
            .catch(err => {
                console.error('Error fetching hourly schedule:', err);
                alert('시간대별 일정 정보를 불러오는 중 오류가 발생했습니다.');
            });
    }

    // 시간대별 일정 저장
    function saveHourlySchedule() {
        const hourlySchedId = document.getElementById('hourlySchedId').value;
        const schedId = document.getElementById('parentSchedId').value;
        const name = document.getElementById('hourlySchedName').value;
        const startTime = document.getElementById('hourlyStartHour').value + ':' + document.getElementById('hourlyStartMinute').value;
        const endTime = document.getElementById('hourlyEndHour').value + ':' + document.getElementById('hourlyEndMinute').value;
        const content = document.getElementById('hourlySchedContent').value;

        if (!name || !startTime || !endTime) {
            alert('제목과 시작/종료 시간을 모두 입력하세요.');
            return;
        }

        const data = {
            schedId: schedId,
            hourlySchedName: name,
            hourlySchedStartTime: startTime,
            hourlySchedEndTime: endTime,
            hourlySchedContent: content
        };

        const url = '/schedule/api/hourly';
        const method = hourlySchedId ? 'PUT' : 'POST';

        if (hourlySchedId) data.hourlySchedId = hourlySchedId;

        fetch(url, {
            method: method,
            headers: {'Content-Type': 'application/json'},
            body: JSON.stringify(data)
        })
            .then(res => res.json())
            .then(result => {
                if (result.success) {
                    alert(hourlySchedId ? '수정되었습니다.' : '등록되었습니다.');
                    closeHourlyModal();
                    loadScheduleDetail(schedId);
                } else {
                    alert('저장에 실패했습니다: ' + (result.message || '알 수 없는 오류'));
                }
            })
            .catch(error => {
                console.error("시간대별 일정 저장 중 오류 발생:", error);
                alert("시간대별 일정 저장 중 오류가 발생했습니다.");
            });
    }

    // 시간대별 일정 삭제
    function deleteHourlySchedule() {
        if (!confirm('이 시간대별 일정을 삭제하시겠습니까?')) return;

        const hourlySchedId = document.getElementById('hourlySchedId').value;
        const schedId = document.getElementById('parentSchedId').value;

        fetch('/schedule/api/hourly/' + hourlySchedId, {method: 'DELETE'})
            .then(res => res.json())
            .then(result => {
                if (result.success) {
                    alert('삭제되었습니다.');
                    closeHourlyModal();
                    loadScheduleDetail(schedId);
                } else {
                    alert('삭제에 실패했습니다: ' + (result.message || '알 수 없는 오류'));
                }
            })
            .catch(error => {
                console.error("시간대별 일정 삭제 중 오류 발생:", error);
                alert("시간대별 일정 삭제 중 오류가 발생했습니다.");
            });
    }

    // 통계 업데이트
    function updateStats() {
        const events = calendar.getEvents();
        const today = new Date();
        const startOfWeek = new Date(today);
        startOfWeek.setDate(startOfWeek.getDate() - today.getDay()); // Start of week (Sunday)
        startOfWeek.setHours(0, 0, 0, 0);

        const endOfWeek = new Date(startOfWeek);
        endOfWeek.setDate(endOfWeek.getDate() + 6); // End of week (Saturday)
        endOfWeek.setHours(23, 59, 59, 999);

        today.setHours(0, 0, 0, 0);

        let todayCount = 0;
        let weekCount = 0;
        const monthCount = events.length;

        events.forEach(event => {
            const eventDate = new Date(event.start);
            eventDate.setHours(0,0,0,0); // Ignore time part for date comparison

            if (eventDate.getTime() === today.getTime()) {
                todayCount++;
            }
            if (eventDate >= startOfWeek && eventDate <= endOfWeek) {
                weekCount++;
            }
        });

        document.getElementById('todayCount').textContent = todayCount;
        document.getElementById('weekCount').textContent = weekCount;
        document.getElementById('monthCount').textContent = monthCount;
    }

    function formatDate(date) {
        const d = new Date(date);
        return d.getFullYear() + '-' + String(d.getMonth() + 1).padStart(2, '0') + '-' + String(d.getDate()).padStart(2, '0');
    }

    // AI 일정 추천 모달 열기
    function openAiScheduleModal() {
        document.getElementById('aiScheduleModal').classList.add('show');
        // 날짜 기본값을 오늘로 설정 (비활성화 상태)
        const today = new Date().toISOString().split('T')[0];
        document.getElementById('aiScheduleDate').value = today;

        // 추천 모드 변경 이벤트 리스너
        const modeRadios = document.querySelectorAll('input[name="recommendMode"]');
        modeRadios.forEach(radio => {
            radio.addEventListener('change', function() {
                updateRecommendModeUI();
            });
        });
        updateRecommendModeUI();

        // 특이사항 입력 시 날짜 자동 추출
        const specialNotesInput = document.getElementById('aiSpecialNotes');
        specialNotesInput.addEventListener('blur', function() {
            extractDateFromSpecialNotes();
        });
    }

    // 특이사항에서 날짜 추출
    function extractDateFromSpecialNotes() {
        const specialNotes = document.getElementById('aiSpecialNotes').value;
        if (!specialNotes || specialNotes.trim() === '') {
            // 특이사항이 없으면 오늘 날짜로 설정
            const today = new Date().toISOString().split('T')[0];
            document.getElementById('aiScheduleDate').value = today;
            return;
        }

        // 서버에 날짜 추출 요청
        fetch('/schedule/api/ai/extract-date', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({
                text: specialNotes
            })
        })
            .then(response => response.json())
            .then(data => {
                if (data.success && data.date) {
                    document.getElementById('aiScheduleDate').value = data.date;
                } else {
                    // 날짜 추출 실패 시 오늘 날짜로 설정
                    const today = new Date().toISOString().split('T')[0];
                    document.getElementById('aiScheduleDate').value = today;
                }
            })
            .catch(error => {
                console.error('날짜 추출 오류:', error);
                // 오류 시 오늘 날짜로 설정
                const today = new Date().toISOString().split('T')[0];
                document.getElementById('aiScheduleDate').value = today;
            });
    }

    // 추천 모드에 따라 UI 업데이트
    function updateRecommendModeUI() {
        const selectedMode = document.querySelector('input[name="recommendMode"]:checked').value;
        const specialNotesInput = document.getElementById('aiSpecialNotes');
        const specialNotesRequired = document.getElementById('specialNotesRequired');
        const specialNotesHint = document.getElementById('specialNotesHint');

        if (selectedMode === 'custom') {
            specialNotesRequired.style.display = 'inline';
            specialNotesInput.placeholder = '원하는 활동을 입력하세요 (예: 공원에 가고 싶어요, 도서관 방문, 친구 만나기, 쇼핑몰 가기 등)';
            specialNotesHint.textContent = '맞춤형 모드: 입력한 활동을 중심으로 노약자의 건강 상태를 고려하여 시간표를 추천합니다.';
            specialNotesHint.style.color = '#e74c3c';
        } else {
            specialNotesRequired.style.display = 'none';
            specialNotesInput.placeholder = '추가적으로 고려할 사항이 있다면 입력해주세요. 예: 오늘은 병원 방문이 있습니다.';
            specialNotesHint.textContent = '기본 모드: 입력하지 않으시면 대상자의 기존 건강 정보를 기반으로 AI가 최적의 스케줄을 추천합니다.';
            specialNotesHint.style.color = '#3498db';
        }
    }

    // AI 일정 추천 모달 닫기
    function closeAiScheduleModal() {
        document.getElementById('aiScheduleModal').classList.remove('show');
        document.getElementById('aiScheduleResult').style.display = 'none';
        document.getElementById('aiScheduleForm').reset();
    }

    // AI 일정 추천 받기
    function getAiScheduleRecommendation() {
        const recId = currentRecId;
        let targetDate = document.getElementById('aiScheduleDate').value;
        const specialNotes = document.getElementById('aiSpecialNotes').value;
        const recommendMode = document.querySelector('input[name="recommendMode"]:checked').value;

        // 날짜가 없으면 오늘 날짜로 설정
        if (!targetDate) {
            const today = new Date().toISOString().split('T')[0];
            targetDate = today;
            document.getElementById('aiScheduleDate').value = today;
        }

        if (!recId || recId === 0) {
            alert('돌봄 대상자를 선택해주세요.');
            return;
        }

        // 맞춤형 모드일 때 특이사항 필수 체크
        if (recommendMode === 'custom' && (!specialNotes || specialNotes.trim() === '')) {
            alert('맞춤형 모드를 선택하셨습니다. 특이사항에 원하는 활동을 입력해주세요.');
            return;
        }

        // 특이사항에서 날짜 재추출 (사용자가 입력한 경우)
        if (specialNotes && specialNotes.trim() !== '') {
            extractDateFromSpecialNotes();
            // 잠시 대기 후 최신 날짜 사용
            setTimeout(() => {
                const extractedDate = document.getElementById('aiScheduleDate').value;
                if (extractedDate) {
                    targetDate = extractedDate;
                }
                proceedWithRecommendation(recId, targetDate, specialNotes, recommendMode);
            }, 500);
        } else {
            proceedWithRecommendation(recId, targetDate, specialNotes, recommendMode);
        }
    }

    // 실제 추천 요청 처리
    function proceedWithRecommendation(recId, targetDate, specialNotes, recommendMode) {

        // 로딩 표시
        const resultDiv = document.getElementById('aiScheduleResult');
        resultDiv.style.display = 'block';
        resultDiv.innerHTML = '<div style="text-align: center; padding: 20px;"><i class="fas fa-spinner fa-spin"></i> AI가 일정을 추천하고 있습니다...</div>';

        // API 호출
        fetch('/schedule/api/ai/recommend', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({
                recId: parseInt(recId),
                targetDate: targetDate,
                specialNotes: specialNotes,
                recommendMode: recommendMode
            })
        })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    // 날짜 업데이트 (특이사항에서 추출된 날짜 사용)
                    const finalDate = data.date || targetDate;
                    document.getElementById('aiScheduleDate').value = finalDate;
                    displayAiScheduleResult(data.schedules, finalDate, data.scheduleName);
                } else {
                    resultDiv.innerHTML = '<div style="color: red; padding: 20px;">' + (data.message || '일정 추천에 실패했습니다.') + '</div>';
                }
            })
            .catch(error => {
                console.error('AI 일정 추천 오류:', error);
                resultDiv.innerHTML = '<div style="color: red; padding: 20px;">일정 추천 중 오류가 발생했습니다.</div>';
            });
    }

    // AI 일정 추천 결과 표시
    function displayAiScheduleResult(schedules, targetDate, scheduleName) {
        const resultDiv = document.getElementById('aiScheduleResult');

        if (!schedules || schedules.length === 0) {
            resultDiv.innerHTML = '<div style="padding: 20px; text-align: center;">추천된 일정이 없습니다.</div>';
            return;
        }

        // 날짜 포맷팅
        const dateObj = new Date(targetDate);
        const formattedDate = dateObj.getFullYear() + '년 ' +
            (dateObj.getMonth() + 1) + '월 ' +
            dateObj.getDate() + '일';

        let html = '<div class="ai-schedule-result">';
        html += '<h4 style="margin-bottom: 20px; color: #2d3748; font-size: 18px; font-weight: 700;"><i class="fas fa-calendar-day" style="color: var(--primary-color);"></i> ' + formattedDate + ' 일정 추천</h4>';
        html += '<div class="schedule-timeline">';

        // 시간순으로 정렬
        schedules.sort((a, b) => {
            const timeA = a.startTime || '00:00';
            const timeB = b.startTime || '00:00';
            return timeA.localeCompare(timeB);
        });

        schedules.forEach((schedule, index) => {
            const startTime = schedule.startTime || '00:00';
            const endTime = schedule.endTime || '00:00';
            const scheduleName = schedule.scheduleName || '일정';

            html += '<div class="timeline-item">';
            html += '<div class="timeline-time">' + startTime + ' ~ ' + endTime + '</div>';
            html += '<div class="timeline-content">';
            html += '<h5>' + scheduleName + '</h5>';
            html += '</div>';
            html += '</div>';
        });

        html += '</div>';
        html += '<button type="button" class="btn btn-success mt-3" onclick="applyAiScheduleRecommendation(\'' + targetDate + '\')" style="width: 100%;">';
        html += '<i class="fas fa-check-circle"></i> 이 일정 적용하기';
        html += '</button>';
        html += '</div>';

        resultDiv.innerHTML = html;

        // 전역 변수에 저장 (적용 시 사용)
        window.aiRecommendedSchedules = schedules;
        window.aiRecommendedDate = targetDate;
        window.aiRecommendedScheduleName = scheduleName || null;
    }

    // AI 추천 일정 적용하기
    function applyAiScheduleRecommendation(targetDate) {
        const recId = currentRecId;

        if (!window.aiRecommendedSchedules || window.aiRecommendedSchedules.length === 0) {
            alert('적용할 일정이 없습니다.');
            return;
        }

        if (!confirm('추천된 일정을 등록하시겠습니까?')) {
            return;
        }

        // 메인 일정 먼저 생성 (AI가 생성한 일정명 사용)
        const mainScheduleName = window.aiRecommendedScheduleName || (targetDate + ' 일정');
        const mainSchedule = {
            recId: parseInt(recId),
            schedName: mainScheduleName,
            schedDate: targetDate
        };

        fetch('/schedule/api/schedule', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify(mainSchedule)
        })
            .then(response => response.json())
            .then(data => {
                if (data.success && data.schedule) {
                    const schedId = data.schedule.schedId;
                    let savedCount = 0;
                    let totalCount = window.aiRecommendedSchedules.length;

                    // 시간대별 일정 생성
                    window.aiRecommendedSchedules.forEach((schedule, index) => {
                        const hourlySchedule = {
                            schedId: schedId,
                            hourlySchedName: schedule.scheduleName,
                            hourlySchedStartTime: schedule.startTime,
                            hourlySchedEndTime: schedule.endTime,
                            hourlySchedContent: schedule.description || ''
                        };

                        fetch('/schedule/api/hourly', {
                            method: 'POST',
                            headers: {
                                'Content-Type': 'application/json'
                            },
                            body: JSON.stringify(hourlySchedule)
                        })
                            .then(response => response.json())
                            .then(result => {
                                if (result.success) {
                                    savedCount++;
                                    if (savedCount === totalCount) {
                                        alert('일정이 성공적으로 등록되었습니다!');
                                        closeAiScheduleModal();
                                        calendar.refetchEvents();
                                    }
                                }
                            })
                            .catch(error => {
                                console.error('시간대별 일정 저장 오류:', error);
                            });
                    });
                } else {
                    alert('일정 등록에 실패했습니다.');
                }
            })
            .catch(error => {
                console.error('일정 저장 오류:', error);
                alert('일정 저장 중 오류가 발생했습니다.');
            });
    }
</script>