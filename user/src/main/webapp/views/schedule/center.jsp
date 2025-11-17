<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- FullCalendar CSS -->
<link href='https://cdn.jsdelivr.net/npm/fullcalendar@6.1.10/main.min.css' rel='stylesheet' />

<!-- 병원 일정 페이지 -->
<section style="padding: 20px 20px 100px 20px; background: #f8f9fc; min-height: calc(100vh - 200px);">
    <div class="container-fluid">
        <div class="row">
            <div class="col-12 mb-4">
                <div style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); padding: 30px; border-radius: 12px; box-shadow: 0 4px 15px rgba(102, 126, 234, 0.3);">
                    <h1 style="font-size: 32px; font-weight: 600; color: white; margin: 0;">
                        <i class="fas fa-calendar-alt"></i> Needy 일정 관리
                    </h1>
                    <p style="font-size: 15px; color: rgba(255,255,255,0.9); margin: 10px 0 0 0;">
                        <i class="fas fa-user-md"></i> ${sessionScope.loginUser.custName} 님의 Needy 스케줄
                    </p>
                </div>
            </div>
        </div>

        <div class="row">
            <!-- 왼쪽: 일정 통계 -->
            <div class="col-lg-3 mb-4">
                <div class="stats-card">
                    <div class="stat-item" style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);">
                        <div class="stat-icon"><i class="fas fa-calendar-check"></i></div>
                        <div class="stat-content">
                            <div class="stat-label">오늘 산책 횟수</div>
                            <div class="stat-value" id="todayCount">0</div>
                        </div>
                    </div>

                    <div class="stat-item" style="background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);">
                        <div class="stat-icon"><i class="fas fa-procedures"></i></div>
                        <div class="stat-content">
                            <div class="stat-label">오늘 식사 횟수</div>
                            <div class="stat-value" id="surgeryCount">0</div>
                        </div>
                    </div>

                    <div class="stat-item" style="background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);">
                        <div class="stat-icon"><i class="fas fa-stethoscope"></i></div>
                        <div class="stat-content">
                            <div class="stat-label">?????</div>
                            <div class="stat-value" id="checkupCount">0</div>
                        </div>
                    </div>

                    <div class="stat-item" style="background: linear-gradient(135deg, #43e97b 0%, #38f9d7 100%);">
                        <div class="stat-icon"><i class="fas fa-user-friends"></i></div>
                        <div class="stat-content">
                            <div class="stat-label">?????</div>
                            <div class="stat-value" id="monthCount">0</div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- 오른쪽: 캘린더 -->
            <div class="col-lg-9">
                <div class="calendar-card">
                    <div id="calendar"></div>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- 날짜별 상세 일정 모달 -->
<div class="modal fade" id="dayDetailModal" tabindex="-1">
    <div class="modal-dialog modal-lg modal-dialog-centered">
        <div class="modal-content day-detail-modal">
            <div class="modal-header">
                <h5 class="modal-title" id="dayDetailTitle">
                    <i class="fas fa-calendar-day"></i> 날짜
                </h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body" id="dayDetailBody"></div>
            <div class="modal-footer">
                <button type="button" class="btn btn-primary" onclick="openAddEventModal()">
                    <i class="fas fa-plus"></i> 일정 추가
                </button>
                <button type="button" class="btn btn-light" data-bs-dismiss="modal">
                    <i class="fas fa-times"></i> 닫기
                </button>
            </div>
        </div>
    </div>
</div>

<!-- 일정 등록/수정 모달 -->
<div class="modal fade" id="eventModal" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content medical-modal">
            <div class="modal-header">
                <h5 class="modal-title" id="modalTitle">
                    <i class="fas fa-plus-circle"></i> 일정 등록
                </h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <form id="eventForm">
                    <input type="hidden" id="eventId">
                    <input type="hidden" id="selectedDate">

                    <div class="mb-3">
                        <label class="form-label"><i class="fas fa-clipboard-list"></i> 일정 유형</label>
                        <select class="form-select" id="eventType" required>
                            <option value="">선택하세요</option>
                            <option value="outpatient">외래 진료</option>
                            <option value="surgery">수술</option>
                            <option value="checkup">건강 검진</option>
                            <option value="rounds">회진</option>
                            <option value="conference">컨퍼런스</option>
                            <option value="emergency">응급</option>
                        </select>
                    </div>

                    <div class="mb-3">
                        <label class="form-label"><i class="fas fa-user"></i> 환자명 / 제목</label>
                        <input type="text" class="form-control" id="eventTitle" placeholder="환자명 또는 일정 제목" required>
                    </div>

                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label class="form-label"><i class="fas fa-clock"></i> 시작 시간</label>
                            <input type="time" class="form-control" id="eventStartTime" required>
                        </div>
                        <div class="col-md-6 mb-3">
                            <label class="form-label"><i class="fas fa-clock"></i> 종료 시간</label>
                            <input type="time" class="form-control" id="eventEndTime" required>
                        </div>
                    </div>

                    <div class="mb-3">
                        <label class="form-label"><i class="fas fa-notes-medical"></i> 상세 내용</label>
                        <textarea class="form-control" id="eventDescription" rows="3" placeholder="증상, 처치 내용, 특이사항 등"></textarea>
                    </div>

                    <div class="mb-3">
                        <label class="form-label"><i class="fas fa-map-marker-alt"></i> 진료실 / 장소</label>
                        <input type="text" class="form-control" id="eventLocation" placeholder="예: 1층 내과 진료실">
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-light" data-bs-dismiss="modal">
                    <i class="fas fa-times"></i> 취소
                </button>
                <button type="button" class="btn btn-danger" id="deleteBtn" style="display:none;">
                    <i class="fas fa-trash"></i> 삭제
                </button>
                <button type="button" class="btn btn-primary" id="saveBtn">
                    <i class="fas fa-save"></i> 저장
                </button>
            </div>
        </div>
    </div>
</div>

<!-- FullCalendar JS -->
<script src='https://cdn.jsdelivr.net/npm/fullcalendar@6.1.10/index.global.min.js'></script>
<script src='https://cdn.jsdelivr.net/npm/@fullcalendar/core@6.1.10/locales/ko.global.min.js'></script>

<script>
    let calendar, dayDetailModal, eventModal, currentSelectedDate;

    document.addEventListener('DOMContentLoaded', function() {
        const calendarEl = document.getElementById('calendar');
        dayDetailModal = new bootstrap.Modal(document.getElementById('dayDetailModal'));
        eventModal = new bootstrap.Modal(document.getElementById('eventModal'));

        const eventColors = {
            'outpatient': '#667eea',
            'surgery': '#f5576c',
            'checkup': '#4facfe',
            'rounds': '#43e97b',
            'conference': '#feca57',
            'emergency': '#ff6b6b'
        };

        const eventTypeNames = {
            'outpatient': '외래 진료',
            'surgery': '수술',
            'checkup': '건강 검진',
            'rounds': '회진',
            'conference': '컨퍼런스',
            'emergency': '응급'
        };

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
                showDayDetail(info.date);
            },

            eventClick: function(info) {
                info.jsEvent.preventDefault();
                const event = info.event;
                openEventModal('edit', event);
            },

            events: [
                {
                    id: '1',
                    title: '김철수 - 정기검진',
                    start: '2025-11-18T10:00:00',
                    end: '2025-11-18T10:30:00',
                    backgroundColor: eventColors.outpatient,
                    extendedProps: {
                        type: 'outpatient',
                        description: '혈압 및 당뇨 정기 체크',
                        location: '1층 내과 진료실'
                    }
                }
            ]
        });

        calendar.render();
        updateStats();

        function updateStats() {
            const events = calendar.getEvents();
            const today = new Date();
            today.setHours(0, 0, 0, 0);
            const weekEnd = new Date(today);
            weekEnd.setDate(weekEnd.getDate() + 7);

            const monthStart = new Date(today.getFullYear(), today.getMonth(), 1);
            const monthEnd = new Date(today.getFullYear(), today.getMonth() + 1, 0);

            let todayCount = 0;
            let surgeryCount = 0;
            let checkupCount = 0;
            let monthCount = 0;

            events.forEach(event => {
                const eventDate = new Date(event.start);
                eventDate.setHours(0, 0, 0, 0);

                if (eventDate.getTime() === today.getTime()) {
                    todayCount++;
                }

                if (event.start >= today && event.start <= weekEnd) {
                    if (event.extendedProps.type === 'surgery') surgeryCount++;
                    if (event.extendedProps.type === 'checkup') checkupCount++;
                }

                if (event.start >= monthStart && event.start <= monthEnd) {
                    monthCount++;
                }
            });

            document.getElementById('todayCount').textContent = todayCount;
            document.getElementById('surgeryCount').textContent = surgeryCount;
            document.getElementById('checkupCount').textContent = checkupCount;
            document.getElementById('monthCount').textContent = monthCount;
        }

        function showDayDetail(date) {
            currentSelectedDate = date;
            const events = calendar.getEvents().filter(event => {
                const eventDate = new Date(event.start);
                return eventDate.toDateString() === date.toDateString();
            });

            const dateStr = formatDateKorean(date);
            document.getElementById('dayDetailTitle').innerHTML = '<i class="fas fa-calendar-day"></i> ' + dateStr;

            const bodyEl = document.getElementById('dayDetailBody');

            if (events.length === 0) {
                bodyEl.innerHTML = '<div class="text-center py-4"><p>등록된 일정이 없습니다.</p></div>';
            } else {
                events.sort((a, b) => a.start - b.start);

                let html = '<div class="timeline-container">';
                events.forEach(event => {
                    const startTime = formatTime(event.start);
                    const endTime = formatTime(event.end);
                    const typeName = eventTypeNames[event.extendedProps.type] || '일정';

                    html += `
                    <div class="timeline-item" onclick="editEvent('${event.id}')" style="cursor:pointer; border-left:4px solid ${event.backgroundColor}; padding:15px; margin-bottom:15px; background:#f8f9fa; border-radius:8px;">
                        <div><strong>${startTime} - ${endTime}</strong></div>
                        <div><span style="background:${event.backgroundColor}; color:white; padding:2px 8px; border-radius:4px; font-size:12px;">${typeName}</span> ${event.title}</div>
                        ${event.extendedProps.location ? '<div><i class="fas fa-map-marker-alt"></i> ' + event.extendedProps.location + '</div>' : ''}
                    </div>
                `;
                });
                html += '</div>';
                bodyEl.innerHTML = html;
            }

            dayDetailModal.show();
        }

        window.openAddEventModal = function() {
            dayDetailModal.hide();
            setTimeout(() => openEventModal('create', null, currentSelectedDate), 300);
        };

        window.editEvent = function(eventId) {
            const event = calendar.getEventById(eventId);
            if (event) {
                dayDetailModal.hide();
                setTimeout(() => openEventModal('edit', event), 300);
            }
        };

        function openEventModal(mode, event, date) {
            if (mode === 'create') {
                document.getElementById('modalTitle').innerHTML = '<i class="fas fa-plus-circle"></i> 일정 등록';
                document.getElementById('deleteBtn').style.display = 'none';
                document.getElementById('eventId').value = '';
                document.getElementById('eventType').value = '';
                document.getElementById('eventTitle').value = '';
                document.getElementById('eventStartTime').value = '09:00';
                document.getElementById('eventEndTime').value = '10:00';
                document.getElementById('eventDescription').value = '';
                document.getElementById('eventLocation').value = '';

                if (date) {
                    document.getElementById('selectedDate').value = formatDate(date);
                }
            } else {
                document.getElementById('modalTitle').innerHTML = '<i class="fas fa-edit"></i> 일정 수정';
                document.getElementById('deleteBtn').style.display = 'block';
                document.getElementById('eventId').value = event.id;
                document.getElementById('eventType').value = event.extendedProps.type || '';
                document.getElementById('eventTitle').value = event.title;
                document.getElementById('eventStartTime').value = formatTimeInput(event.start);
                document.getElementById('eventEndTime').value = formatTimeInput(event.end);
                document.getElementById('eventDescription').value = event.extendedProps.description || '';
                document.getElementById('eventLocation').value = event.extendedProps.location || '';
                document.getElementById('selectedDate').value = formatDate(event.start);
            }
            eventModal.show();
        }

        document.getElementById('saveBtn').addEventListener('click', function() {
            const id = document.getElementById('eventId').value;
            const type = document.getElementById('eventType').value;
            const title = document.getElementById('eventTitle').value;
            const dateStr = document.getElementById('selectedDate').value;
            const startTime = document.getElementById('eventStartTime').value;
            const endTime = document.getElementById('eventEndTime').value;
            const description = document.getElementById('eventDescription').value;
            const location = document.getElementById('eventLocation').value;

            if (!type || !title || !startTime || !endTime) {
                alert('필수 항목을 입력해주세요.');
                return;
            }

            const start = dateStr + 'T' + startTime + ':00';
            const end = dateStr + 'T' + endTime + ':00';
            const color = eventColors[type];

            const eventData = {
                title: title,
                start: start,
                end: end,
                backgroundColor: color,
                extendedProps: {
                    type: type,
                    description: description,
                    location: location
                }
            };

            if (id) {
                const event = calendar.getEventById(id);
                event.setProp('title', title);
                event.setStart(start);
                event.setEnd(end);
                event.setProp('backgroundColor', color);
                event.setExtendedProp('type', type);
                event.setExtendedProp('description', description);
                event.setExtendedProp('location', location);
            } else {
                eventData.id = Date.now().toString();
                calendar.addEvent(eventData);
            }

            updateStats();
            eventModal.hide();
        });

        document.getElementById('deleteBtn').addEventListener('click', function() {
            if (confirm('일정을 삭제하시겠습니까?')) {
                const id = document.getElementById('eventId').value;
                calendar.getEventById(id).remove();
                updateStats();
                eventModal.hide();
            }
        });

        function formatDateKorean(date) {
            const days = ['일', '월', '화', '수', '목', '금', '토'];
            return date.getFullYear() + '년 ' + (date.getMonth() + 1) + '월 ' + date.getDate() + '일 (' + days[date.getDay()] + ')';
        }

        function formatDate(date) {
            const d = new Date(date);
            return d.getFullYear() + '-' + String(d.getMonth() + 1).padStart(2, '0') + '-' + String(d.getDate()).padStart(2, '0');
        }

        function formatTime(date) {
            const d = new Date(date);
            return String(d.getHours()).padStart(2, '0') + ':' + String(d.getMinutes()).padStart(2, '0');
        }

        function formatTimeInput(date) {
            if (!date) return '';
            return formatTime(date);
        }
    });
</script>

<style>
    body {
        font-family: 'Noto Sans KR', sans-serif;
        overflow-x: hidden;
    }

    html, body {
        min-height: 100vh;
    }

    /* 통계 카드 */
    .stats-card {
        display: flex;
        flex-direction: column;
        gap: 15px;
    }

    .stat-item {
        border-radius: 12px;
        padding: 20px;
        color: white;
        box-shadow: 0 4px 12px rgba(0,0,0,0.1);
        display: flex;
        align-items: center;
        gap: 15px;
        transition: transform 0.2s;
    }

    .stat-item:hover {
        transform: translateY(-3px);
        box-shadow: 0 6px 20px rgba(0,0,0,0.15);
    }

    .stat-icon {
        font-size: 32px;
        opacity: 0.9;
    }

    .stat-content {
        flex: 1;
    }

    .stat-label {
        font-size: 13px;
        opacity: 0.9;
        margin-bottom: 5px;
    }

    .stat-value {
        font-size: 28px;
        font-weight: 700;
    }

    .calendar-card {
        background: white;
        border-radius: 12px;
        padding: 30px;
        box-shadow: 0 2px 12px rgba(0,0,0,0.08);
        min-height: 600px;
    }

    .fc {
        font-size: 14px;
        min-height: 550px;
    }

    .fc-toolbar-title {
        font-size: 22px !important;
        font-weight: 600 !important;
        color: #2d3748;
    }

    .fc-button {
        padding: 8px 16px !important;
        font-size: 13px !important;
        border-radius: 6px !important;
        border: none !important;
        background: #667eea !important;
        font-weight: 500 !important;
    }

    .fc-button:hover {
        background: #5568d3 !important;
    }

    .fc-daygrid-day {
        cursor: pointer;
    }

    .fc-daygrid-day:hover {
        background: #f8f9fc;
    }

    .fc-event {
        cursor: pointer;
        border-radius: 4px;
        padding: 2px 4px;
        margin-bottom: 2px;
    }

    .fc-event:hover {
        opacity: 0.8;
    }

    .day-detail-modal .modal-header {
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        color: white;
        border: none;
        padding: 20px 25px;
    }

    .day-detail-modal .modal-title {
        font-weight: 600;
        font-size: 18px;
    }

    .day-detail-modal .btn-close {
        filter: brightness(0) invert(1);
    }

    .medical-modal .modal-header {
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        color: white;
        border: none;
        padding: 20px 25px;
    }

    .medical-modal .modal-title {
        font-weight: 600;
        font-size: 18px;
    }

    .medical-modal .btn-close {
        filter: brightness(0) invert(1);
    }

    .medical-modal .form-label {
        font-weight: 500;
        color: #4a5568;
        margin-bottom: 8px;
        font-size: 14px;
    }

    .medical-modal .form-label i {
        color: #667eea;
        margin-right: 5px;
    }

    .medical-modal .form-control,
    .medical-modal .form-select {
        border-radius: 8px;
        border: 1px solid #e2e8f0;
        padding: 10px 15px;
        font-size: 14px;
    }

    .medical-modal .btn {
        border-radius: 8px;
        padding: 10px 20px;
        font-weight: 500;
        border: none;
    }

    .medical-modal .btn-primary {
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    }

    /* 반응형 */
    @media (max-width: 991px) {
        .stats-card {
            flex-direction: row;
            flex-wrap: wrap;
        }

        .stat-item {
            flex: 1 1 calc(50% - 8px);
            min-width: 200px;
        }
    }

    @media (max-width: 767px) {
        .stat-item {
            flex: 1 1 100%;
        }
    }
</style>