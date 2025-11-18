<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<link href='https://cdn.jsdelivr.net/npm/@fullcalendar/core@6.1.10/main.min.css' rel='stylesheet' />

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

        <c:if test="${not empty recipientList}">
            <div class="row mb-3">
                <div class="col-12">
                    <div class="card" style="border-radius: 12px; border: none; box-shadow: 0 2px 8px rgba(0,0,0,0.08);">
                        <div class="card-body" style="padding: 20px;">
                            <label style="font-weight: 600; color: #2d3748; margin-bottom: 10px;">
                                <i class="fas fa-user-injured"></i> 돌봄 대상자 선택
                            </label>
                            <select id="recipientSelect" class="form-select" style="font-size: 15px; padding: 10px;" onchange="changeRecipient()">
                                <c:forEach items="${recipientList}" var="rec">
                                    <option value="${rec.recId}" ${rec.recId == selectedRecipient.recId ? 'selected' : ''}>
                                            ${rec.recName}
                                    </option>
                                </c:forEach>
                            </select>
                        </div>
                    </div>
                </div>
            </div>
        </c:if>

        <div class="row">
            <div class="col-lg-3 mb-4">
                <div class="stats-card">
                    <div class="stat-item" style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);">
                        <div class="stat-icon"><i class="fas fa-calendar-check"></i></div>
                        <div class="stat-content">
                            <div class="stat-label">오늘 일정</div>
                            <div class="stat-value" id="todayCount">0</div>
                        </div>
                    </div>

                    <div class="stat-item" style="background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);">
                        <div class="stat-icon"><i class="fas fa-calendar-week"></i></div>
                        <div class="stat-content">
                            <div class="stat-label">이번 주 일정</div>
                            <div class="stat-value" id="weekCount">0</div>
                        </div>
                    </div>

                    <div class="stat-item" style="background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);">
                        <div class="stat-icon"><i class="fas fa-calendar-alt"></i></div>
                        <div class="stat-content">
                            <div class="stat-label">이번 달 일정</div>
                            <div class="stat-value" id="monthCount">0</div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="col-lg-9">
                <div class="calendar-card">
                    <div id="calendar"></div>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- 날짜별 일정 상세 모달 -->
<div class="modal fade" id="dayDetailModal" tabindex="-1">
    <div class="modal-dialog modal-lg modal-dialog-centered modal-dialog-scrollable">
        <div class="modal-content day-detail-modal">
            <div class="modal-header">
                <h5 class="modal-title" id="dayDetailTitle">
                    <i class="fas fa-calendar-day"></i> 날짜
                </h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <div class="day-schedule-info">
                    <h6 id="scheduleTitle">일정 제목</h6>
                    <p id="scheduleTime"><i class="fas fa-clock"></i> 시간</p>
                </div>
                <hr>
                <div id="hourlySchedulesContainer"></div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-primary" id="addHourlyBtn">
                    <i class="fas fa-plus"></i> 시간대별 일정 추가
                </button>
                <button type="button" class="btn btn-secondary" id="editScheduleBtn">
                    <i class="fas fa-edit"></i> 일정 수정
                </button>
                <button type="button" class="btn btn-light" data-bs-dismiss="modal">
                    <i class="fas fa-times"></i> 닫기
                </button>
            </div>
        </div>
    </div>
</div>

<!-- 일정 등록/수정 모달 -->
<div class="modal fade" id="scheduleModal" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content medical-modal">
            <div class="modal-header">
                <h5 class="modal-title" id="scheduleModalTitle">
                    <i class="fas fa-plus-circle"></i> 일정 등록
                </h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <form id="scheduleForm">
                    <input type="hidden" id="schedId">
                    <input type="hidden" id="selectedDate">

                    <div class="mb-3">
                        <label class="form-label"><i class="fas fa-heading"></i> 일정 제목</label>
                        <input type="text" class="form-control" id="schedName" placeholder="예: 오늘의 일정" required>
                    </div>

                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label class="form-label"><i class="fas fa-clock"></i> 시작 시간</label>
                            <input type="time" class="form-control" id="schedStartTime">
                        </div>
                        <div class="col-md-6 mb-3">
                            <label class="form-label"><i class="fas fa-clock"></i> 종료 시간</label>
                            <input type="time" class="form-control" id="schedEndTime">
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-light" data-bs-dismiss="modal">
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
</div>

<!-- 시간대별 일정 등록/수정 모달 -->
<div class="modal fade" id="hourlyModal" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content medical-modal">
            <div class="modal-header">
                <h5 class="modal-title" id="hourlyModalTitle">
                    <i class="fas fa-plus-circle"></i> 시간대별 일정 추가
                </h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <form id="hourlyForm">
                    <input type="hidden" id="hourlySchedId">
                    <input type="hidden" id="parentSchedId">

                    <div class="mb-3">
                        <label class="form-label"><i class="fas fa-heading"></i> 제목</label>
                        <input type="text" class="form-control" id="hourlySchedName" placeholder="예: 점심 식사" required>
                    </div>

                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label class="form-label"><i class="fas fa-clock"></i> 시작 시간</label>
                            <input type="time" class="form-control" id="hourlyStartTime" required>
                        </div>
                        <div class="col-md-6 mb-3">
                            <label class="form-label"><i class="fas fa-clock"></i> 종료 시간</label>
                            <input type="time" class="form-control" id="hourlyEndTime" required>
                        </div>
                    </div>

                    <div class="mb-3">
                        <label class="form-label"><i class="fas fa-align-left"></i> 상세 내용</label>
                        <textarea class="form-control" id="hourlySchedContent" rows="3" placeholder="상세 내용을 입력하세요"></textarea>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-light" data-bs-dismiss="modal">
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
</div>

<script src='https://cdn.jsdelivr.net/npm/fullcalendar@6.1.10/index.global.min.js'></script>
<script src='https://cdn.jsdelivr.net/npm/@fullcalendar/core@6.1.10/locales/ko.global.min.js'></script>

<script>
    let calendar, dayDetailModal, scheduleModal, hourlyModal;
    let currentSchedule = null;
    let currentRecId = 0;

    <c:choose>
    <c:when test="${not empty selectedRecipient}">
    currentRecId = ${selectedRecipient.recId};
    console.log('✅ currentRecId 설정 완료:', currentRecId);
    </c:when>
    <c:otherwise>
    console.error('❌ selectedRecipient가 없습니다');
    </c:otherwise>
    </c:choose>

    function changeRecipient() {
        const recId = document.getElementById('recipientSelect').value;
        if (recId) location.href = '/schedule?recId=' + recId;
    }

    document.addEventListener('DOMContentLoaded', function() {
        if (!currentRecId || currentRecId === 0) {
            console.error('❌ currentRecId가 유효하지 않음:', currentRecId);
            document.getElementById('calendar').innerHTML =
                '<div style="text-align:center; padding:50px; color:#999;">' +
                '<i class="fas fa-exclamation-circle" style="font-size:48px;"></i>' +
                '<p style="margin-top:20px;">등록된 돌봄 대상자가 없습니다.</p></div>';
            return;
        }

        console.log('✅ 캘린더 초기화 시작 - recId:', currentRecId);

        const calendarEl = document.getElementById('calendar');
        dayDetailModal = new bootstrap.Modal(document.getElementById('dayDetailModal'));
        scheduleModal = new bootstrap.Modal(document.getElementById('scheduleModal'));
        hourlyModal = new bootstrap.Modal(document.getElementById('hourlyModal'));

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
            datesSet: function(dateInfo) {
                console.log('📅 datesSet 호출:', dateInfo);
                // dateInfo.start는 Date 객체
                loadMonthlySchedules(dateInfo.start);
            },
            events: []
        });

        calendar.render();
        console.log('✅ 캘린더 렌더링 완료');

        // 초기 데이터 로드
        loadMonthlySchedules(new Date());

        document.getElementById('saveScheduleBtn').addEventListener('click', saveSchedule);
        document.getElementById('deleteScheduleBtn').addEventListener('click', deleteSchedule);
        document.getElementById('addHourlyBtn').addEventListener('click', () => openHourlyModal('create'));
        document.getElementById('editScheduleBtn').addEventListener('click', () => {
            dayDetailModal.hide();
            setTimeout(() => openScheduleModal('edit', null, currentSchedule), 300);
        });
        document.getElementById('saveHourlyBtn').addEventListener('click', saveHourlySchedule);
        document.getElementById('deleteHourlyBtn').addEventListener('click', deleteHourlySchedule);
    });

    function loadMonthlySchedules(date) {
        // date 객체 검증
        if (!date || !(date instanceof Date)) {
            console.error('❌ 유효하지 않은 date 객체:', date);
            date = new Date(); // 현재 날짜로 대체
        }

        const year = date.getFullYear();
        const month = date.getMonth() + 1;

        console.log('📅 월별 일정 로드:', {date, year, month, recId: currentRecId});

        fetch(`/schedule/api/monthly?recId=${currentRecId}&year=${year}&month=${month}`)
            .then(res => res.json())
            .then(data => {
                console.log('✅ 일정 데이터 수신:', data);

                // 배열이 아니면 에러 처리
                if (!Array.isArray(data)) {
                    console.error('❌ 배열이 아닌 데이터:', data);
                    if (data.message) alert(data.message);
                    return;
                }

                calendar.removeAllEvents();
                data.forEach(schedule => {
                    calendar.addEvent({
                        id: schedule.schedId,
                        title: schedule.schedName,
                        start: schedule.schedDate,
                        backgroundColor: '#667eea',
                        borderColor: '#667eea'
                    });
                });
                updateStats();
            })
            .catch(error => {
                console.error('❌ 일정 로드 실패:', error);
                alert('일정을 불러오는데 실패했습니다.');
            });
    }

    function loadScheduleDetail(schedId) {
        fetch(`/schedule/api/schedule/${schedId}`)
            .then(res => res.json())
            .then(schedule => {
                currentSchedule = schedule;
                document.getElementById('dayDetailTitle').innerHTML =
                    '<i class="fas fa-calendar-day"></i> ' + formatDateKorean(schedule.schedDate);
                document.getElementById('scheduleTitle').textContent = schedule.schedName;
                document.getElementById('scheduleTime').innerHTML =
                    `<i class="fas fa-clock"></i> ${schedule.schedStartTime || '시간 미정'} - ${schedule.schedEndTime || ''}`;
                loadHourlySchedules(schedId);
                dayDetailModal.show();
            })
            .catch(error => {
                console.error('일정 상세 로드 실패:', error);
                alert('일정을 불러오는데 실패했습니다.');
            });
    }

    function loadHourlySchedules(schedId) {
        fetch(`/schedule/api/hourly/${schedId}`)
            .then(res => res.json())
            .then(data => {
                const container = document.getElementById('hourlySchedulesContainer');
                if (!data || data.length === 0) {
                    container.innerHTML = '<p class="text-center text-muted">등록된 시간대별 일정이 없습니다.</p>';
                } else {
                    let html = '<div class="hourly-list">';
                    data.forEach(hourly => {
                        html += `
                        <div class="hourly-item" onclick="editHourlySchedule(${hourly.hourlySchedId})">
                            <div class="hourly-time">
                                <i class="fas fa-clock"></i>
                                ${hourly.hourlySchedStartTime} - ${hourly.hourlySchedEndTime}
                            </div>
                            <div class="hourly-content">
                                <h6>${hourly.hourlySchedName}</h6>
                                <p>${hourly.hourlySchedContent || ''}</p>
                            </div>
                        </div>`;
                    });
                    html += '</div>';
                    container.innerHTML = html;
                }
            })
            .catch(error => console.error('시간대별 일정 로드 실패:', error));
    }

    function openScheduleModal(mode, date, schedule) {
        if (mode === 'create') {
            document.getElementById('scheduleModalTitle').innerHTML = '<i class="fas fa-plus-circle"></i> 일정 등록';
            document.getElementById('deleteScheduleBtn').style.display = 'none';
            document.getElementById('schedId').value = '';
            document.getElementById('schedName').value = '';
            document.getElementById('schedStartTime').value = '';
            document.getElementById('schedEndTime').value = '';
            document.getElementById('selectedDate').value = formatDate(date);
        } else {
            document.getElementById('scheduleModalTitle').innerHTML = '<i class="fas fa-edit"></i> 일정 수정';
            document.getElementById('deleteScheduleBtn').style.display = 'block';
            document.getElementById('schedId').value = schedule.schedId;
            document.getElementById('schedName').value = schedule.schedName;
            document.getElementById('schedStartTime').value = schedule.schedStartTime || '';
            document.getElementById('schedEndTime').value = schedule.schedEndTime || '';
            document.getElementById('selectedDate').value = schedule.schedDate;
        }
        scheduleModal.show();
    }

    function saveSchedule() {
        const schedId = document.getElementById('schedId').value;
        const schedName = document.getElementById('schedName').value;
        const schedDate = document.getElementById('selectedDate').value;
        const schedStartTime = document.getElementById('schedStartTime').value || null;
        const schedEndTime = document.getElementById('schedEndTime').value || null;

        if (!schedName) {
            alert('일정 제목을 입력하세요.');
            return;
        }

        const data = {
            recId: currentRecId,
            schedName: schedName,
            schedDate: schedDate,
            schedStartTime: schedStartTime,
            schedEndTime: schedEndTime
        };

        const url = '/schedule/api/schedule';
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
                    scheduleModal.hide();
                    loadMonthlySchedules(calendar.getDate());
                } else {
                    alert('저장 실패: ' + (result.message || '알 수 없는 오류'));
                }
            })
            .catch(error => {
                console.error('일정 저장 실패:', error);
                alert('일정 저장에 실패했습니다.');
            });
    }

    function deleteSchedule() {
        if (!confirm('일정을 삭제하시겠습니까?')) return;

        const schedId = document.getElementById('schedId').value;
        fetch(`/schedule/api/schedule/${schedId}`, {method: 'DELETE'})
            .then(res => res.json())
            .then(result => {
                if (result.success) {
                    alert('삭제되었습니다.');
                    scheduleModal.hide();
                    loadMonthlySchedules(calendar.getDate());
                } else {
                    alert('삭제 실패: ' + (result.message || '알 수 없는 오류'));
                }
            })
            .catch(error => {
                console.error('일정 삭제 실패:', error);
                alert('일정 삭제에 실패했습니다.');
            });
    }

    function openHourlyModal(mode) {
        if (mode === 'create') {
            document.getElementById('hourlyModalTitle').innerHTML = '<i class="fas fa-plus-circle"></i> 시간대별 일정 추가';
            document.getElementById('deleteHourlyBtn').style.display = 'none';
            document.getElementById('hourlySchedId').value = '';
            document.getElementById('hourlySchedName').value = '';
            document.getElementById('hourlyStartTime').value = '';
            document.getElementById('hourlyEndTime').value = '';
            document.getElementById('hourlySchedContent').value = '';
            document.getElementById('parentSchedId').value = currentSchedule.schedId;
        }
        hourlyModal.show();
    }

    function editHourlySchedule(hourlySchedId) {
        fetch(`/schedule/api/hourly/detail/${hourlySchedId}`)
            .then(res => res.json())
            .then(hourly => {
                document.getElementById('hourlyModalTitle').innerHTML = '<i class="fas fa-edit"></i> 시간대별 일정 수정';
                document.getElementById('deleteHourlyBtn').style.display = 'block';
                document.getElementById('hourlySchedId').value = hourly.hourlySchedId;
                document.getElementById('hourlySchedName').value = hourly.hourlySchedName;
                document.getElementById('hourlyStartTime').value = hourly.hourlySchedStartTime;
                document.getElementById('hourlyEndTime').value = hourly.hourlySchedEndTime;
                document.getElementById('hourlySchedContent').value = hourly.hourlySchedContent || '';
                document.getElementById('parentSchedId').value = hourly.schedId;
                dayDetailModal.hide();
                hourlyModal.show();
            })
            .catch(error => {
                console.error('시간대별 일정 조회 실패:', error);
                alert('시간대별 일정을 불러오는데 실패했습니다.');
            });
    }

    function saveHourlySchedule() {
        const hourlySchedId = document.getElementById('hourlySchedId').value;
        const schedId = document.getElementById('parentSchedId').value;
        const name = document.getElementById('hourlySchedName').value;
        const startTime = document.getElementById('hourlyStartTime').value;
        const endTime = document.getElementById('hourlyEndTime').value;
        const content = document.getElementById('hourlySchedContent').value;

        if (!name || !startTime || !endTime) {
            alert('필수 항목을 입력하세요.');
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
                    hourlyModal.hide();
                    loadScheduleDetail(schedId);
                } else {
                    alert('저장 실패: ' + (result.message || '알 수 없는 오류'));
                }
            })
            .catch(error => {
                console.error('시간대별 일정 저장 실패:', error);
                alert('시간대별 일정 저장에 실패했습니다.');
            });
    }

    function deleteHourlySchedule() {
        if (!confirm('시간대별 일정을 삭제하시겠습니까?')) return;

        const hourlySchedId = document.getElementById('hourlySchedId').value;
        const schedId = document.getElementById('parentSchedId').value;

        fetch(`/schedule/api/hourly/${hourlySchedId}`, {method: 'DELETE'})
            .then(res => res.json())
            .then(result => {
                if (result.success) {
                    alert('삭제되었습니다.');
                    hourlyModal.hide();
                    loadScheduleDetail(schedId);
                } else {
                    alert('삭제 실패: ' + (result.message || '알 수 없는 오류'));
                }
            })
            .catch(error => {
                console.error('시간대별 일정 삭제 실패:', error);
                alert('시간대별 일정 삭제에 실패했습니다.');
            });
    }

    function updateStats() {
        const events = calendar.getEvents();
        const today = new Date();
        today.setHours(0, 0, 0, 0);
        const weekEnd = new Date(today);
        weekEnd.setDate(weekEnd.getDate() + 7);

        let todayCount = 0, weekCount = 0, monthCount = events.length;

        events.forEach(event => {
            const eventDate = new Date(event.start);
            eventDate.setHours(0, 0, 0, 0);

            if (eventDate.getTime() === today.getTime()) todayCount++;
            if (event.start >= today && event.start <= weekEnd) weekCount++;
        });

        document.getElementById('todayCount').textContent = todayCount;
        document.getElementById('weekCount').textContent = weekCount;
        document.getElementById('monthCount').textContent = monthCount;
    }

    function formatDateKorean(dateStr) {
        const days = ['일', '월', '화', '수', '목', '금', '토'];
        const date = new Date(dateStr);
        return `${date.getFullYear()}년 ${date.getMonth() + 1}월 ${date.getDate()}일 (${days[date.getDay()]})`;
    }

    function formatDate(date) {
        const d = new Date(date);
        return d.getFullYear() + '-' + String(d.getMonth() + 1).padStart(2, '0') + '-' + String(d.getDate()).padStart(2, '0');
    }
</script>

<style>
    body {
        font-family: 'Noto Sans KR', sans-serif;
        overflow-x: hidden;
    }

    html, body {
        min-height: 100vh;
    }

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

    .day-detail-modal .modal-header,
    .medical-modal .modal-header {
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        color: white;
        border: none;
        padding: 20px 25px;
    }

    .day-detail-modal .modal-title,
    .medical-modal .modal-title {
        font-weight: 600;
        font-size: 18px;
    }

    .day-detail-modal .btn-close,
    .medical-modal .btn-close {
        filter: brightness(0) invert(1);
    }

    .day-schedule-info h6 {
        font-size: 18px;
        font-weight: 600;
        color: #2d3748;
        margin-bottom: 10px;
    }

    .day-schedule-info p {
        color: #64748b;
        margin: 0;
    }

    .hourly-list {
        display: flex;
        flex-direction: column;
        gap: 10px;
    }

    .hourly-item {
        background: #f8f9fc;
        border-left: 4px solid #667eea;
        padding: 15px;
        border-radius: 8px;
        cursor: pointer;
        transition: all 0.2s;
    }

    .hourly-item:hover {
        background: #eef2ff;
        transform: translateX(5px);
    }

    .hourly-time {
        font-weight: 600;
        color: #667eea;
        font-size: 14px;
        margin-bottom: 8px;
    }

    .hourly-content h6 {
        font-size: 16px;
        font-weight: 600;
        color: #2d3748;
        margin-bottom: 5px;
    }

    .hourly-content p {
        font-size: 14px;
        color: #64748b;
        margin: 0;
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