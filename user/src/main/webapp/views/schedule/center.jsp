<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<link href='https://cdn.jsdelivr.net/npm/fullcalendar/main.min.css' rel='stylesheet' />

<section style="padding: 20px 0 100px 0; background: #FFFFFF; min-height: calc(100vh - 200px);">
    <div class="container-fluid" style="max-width: 1400px; margin: 0 auto; padding: 0 40px;">
        <div class="row">
            <div class="col-12 mb-4">
                <h1 style="font-size: 36px; font-weight: bold; color: var(--secondary-color);">
                    <i class="fas fa-calendar-alt"></i> Needy 일정 관리
                </h1>
                <p style="font-size: 16px; color: #666; margin-top: 10px;">
                    <i class="fas fa-user-md"></i> ${sessionScope.loginUser.custName} 님의 Needy 스케줄
                </p>
            </div>
        </div>

        <!-- 노약자 선택 영역 추가 -->
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
                    <div class="stat-item" style="background: radial-gradient(circle at top left, #f0f9ff 0, #f4f9ff 40%, #f8fbff 100%);">
                        <div class="stat-icon"><i class="fas fa-calendar-check"></i></div>
                        <div class="stat-content">
                            <div class="stat-label">오늘 일정</div>
                            <div class="stat-value" id="todayCount">0</div>
                        </div>
                    </div>

                    <div class="stat-item" style="background: radial-gradient(circle at top left, #f0f9ff 0, #f4f9ff 40%, #f8fbff 100%);">
                        <div class="stat-icon"><i class="fas fa-calendar-week"></i></div>
                        <div class="stat-content">
                            <div class="stat-label">이번 주 일정</div>
                            <div class="stat-value" id="weekCount">0</div>
                        </div>
                    </div>

                    <div class="stat-item" style="background: radial-gradient(circle at top left, #f0f9ff 0, #f4f9ff 40%, #f8fbff 100%);">
                        <div class="stat-icon"><i class="fas fa-calendar-alt"></i></div>
                        <div class="stat-content">
                            <div class="stat-label">이번 달 일정</div>
                            <div class="stat-value" id="monthCount">0</div>
                        </div>
                    </div>
                </div>
                
                <!-- AI 일정 추천 버튼 -->
                <button class="ai-schedule-btn" onclick="openAiScheduleModal()" style="margin-top: 15px;">
                    <i class="fas fa-magic"></i>
                    <span>AI 일정 추천</span>
                </button>
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
            <div class="modal-body" id="dayDetailBody">
                <div class="day-schedule-info">
                    <h6 id="scheduleTitle">일정 제목</h6>
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
                        <div class="col-6 mb-3">
                            <label class="form-label"><i class="fas fa-clock"></i> 시작 시간</label>
                            <div class="d-flex">
                                <select id="hourlyStartHour" class="form-select me-2"></select>
                                <select id="hourlyStartMinute" class="form-select"></select>
                            </div>
                        </div>
                        <div class="col-6 mb-3">
                            <label class="form-label"><i class="fas fa-clock"></i> 종료 시간</label>
                            <div class="d-flex">
                                <select id="hourlyEndHour" class="form-select me-2"></select>
                                <select id="hourlyEndMinute" class="form-select"></select>
                            </div>
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

<!-- AI 일정 추천 모달 -->
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
                    <input type="date" id="aiScheduleDate" class="form-control" readonly style="background-color: #f7fafc; cursor: not-allowed;">
                    <small class="form-hint">특이사항에 날짜를 입력하면 자동으로 설정됩니다. (예: 이번주 금요일, 이번달 23일)</small>
                </div>
                
                <div class="form-group">
                    <label class="form-label">
                        <i class="fas fa-cog"></i> 추천 모드 <span class="required">*</span>
                    </label>
                    <div style="display: flex; flex-direction: column; gap: 10px; margin-top: 10px;">
                        <label style="display: flex; align-items: center; cursor: pointer; padding: 10px; background: #f8f9fc; border-radius: 8px;">
                            <input type="radio" name="recommendMode" value="basic" checked style="margin-right: 10px;">
                            <div>
                                <strong>기본 일정 추천</strong>
                                <div style="font-size: 12px; color: #666; margin-top: 3px;">식사 시간, 약 복용, 기본 활동 등을 포함한 일정</div>
                            </div>
                        </label>
                        <label style="display: flex; align-items: center; cursor: pointer; padding: 10px; background: #f8f9fc; border-radius: 8px;">
                            <input type="radio" name="recommendMode" value="custom" style="margin-right: 10px;">
                            <div>
                                <strong>특이사항 기반 맞춤형 추천</strong>
                                <div style="font-size: 12px; color: #666; margin-top: 3px;">특이사항에 작성한 활동을 중심으로 건강 상태를 고려한 시간표</div>
                            </div>
                        </label>
                    </div>
                </div>
                
                <div class="form-group">
                    <label class="form-label">
                        <i class="fas fa-list-alt"></i> 특이사항 <span class="required" id="specialNotesRequired" style="display: none;">*</span>
                    </label>
                    <textarea id="aiSpecialNotes" class="form-control" rows="4" 
                              placeholder="기본 모드: 추가 고려사항 입력 (예: 오늘은 병원 방문이 있습니다.)&#10;맞춤형 모드: 원하는 활동을 입력하세요 (예: 공원에 가고 싶어요, 도서관 방문, 친구 만나기 등)"></textarea>
                    <small class="form-hint" id="specialNotesHint">기본 모드: 입력하지 않으시면 대상자의 기존 건강 정보를 기반으로 추천합니다.</small>
                </div>
                <div id="aiScheduleResult" class="form-group" style="display: none;">
                    <!-- AI 추천 결과가 여기에 표시됩니다. -->
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
    let calendar, dayDetailModal, scheduleModal, hourlyModal;
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

            events: function(fetchInfo, successCallback, failureCallback) {
                const selectedRecId = document.getElementById('recipientSelect') ? document.getElementById('recipientSelect').value : currentRecId;

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
                                backgroundColor: '#667eea',
                                borderColor: '#667eea'
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
            dayDetailModal.hide();
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
                dayDetailModal.show();
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
                    container.innerHTML = '<p class="text-center text-muted">등록된 시간대별 일정이 없습니다.</p>';
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
                                                }            });
    }

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
        scheduleModal.show();
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
            recId: document.getElementById('recipientSelect') ? document.getElementById('recipientSelect').value : currentRecId,
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
                    scheduleModal.hide();
                    // [FIX] Re-fetch events from the server to ensure consistency
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
                    scheduleModal.hide();
                    dayDetailModal.hide(); // 상세 모달도 닫기
                    // [FIX] Re-fetch events from the server to ensure consistency
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
        hourlyModal.show();
    }

    // 시간대별 일정 수정 모달 열기
    function editHourlySchedule(hourlySchedId) {
        // [BUG FIX] Use the correct endpoint for fetching a single hourly schedule
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
                dayDetailModal.hide();
                hourlyModal.show();
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
                    hourlyModal.hide();
                    // Re-open the detail modal with updated hourly schedules
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
                    hourlyModal.hide();
                    // Re-open the detail modal with updated hourly schedules
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
            specialNotesHint.style.color = '#FF00FF'; // Keep custom mode color
            specialNotesHint.style.fontSize = '20px'; // Increase font size for custom mode
        } else {
            specialNotesRequired.style.display = 'none';
            specialNotesInput.placeholder = '추가적으로 고려할 사항이 있다면 입력해주세요. 예: 오늘은 병원 방문이 있습니다.';
            specialNotesHint.textContent = '기본 모드: 입력하지 않으시면 대상자의 기존 건강 정보를 데이터베이스에서 추출해 그 기반을 ai가 얻어 사용자에게 딱 맞는 스케쥴을 추천합니다.';
            specialNotesHint.style.color = '#FF00FF'; // Change to red for basic mode
            specialNotesHint.style.fontSize = '20px'; // Increase font size for basic mode
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
        const recId = document.getElementById('recipientSelect') ? document.getElementById('recipientSelect').value : currentRecId;
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
        html += '<h4 style="margin-bottom: 20px; color: #2d3748;"><i class="fas fa-calendar-day"></i> ' + formattedDate + ' 일정 추천</h4>';
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
        const recId = document.getElementById('recipientSelect') ? document.getElementById('recipientSelect').value : currentRecId;
        
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

<style>
    body {
        font-family: 'Noto Sans KR', sans-serif;
        overflow-x: hidden;
    }

    html, body {
        min-height: 100vh;
    }
    
    /* 컨텐츠 중앙 정렬 및 여백 조정 */
    section > .container-fluid {
        max-width: 1400px;
        margin: 0 auto;
        padding: 0 40px;
    }
    
    @media (max-width: 1200px) {
        section > .container-fluid {
            padding: 0 30px;
        }
    }
    
    @media (max-width: 768px) {
        section > .container-fluid {
            padding: 0 20px;
        }
    }

    .stats-card {
        display: flex;
        flex-direction: column;
        gap: 15px;
    }

    .stat-item {
        border-radius: 15px;
        border: 1px solid #eee;
        padding: 20px;
        color: #2c3e50;
        box-shadow: none;
        display: flex;
        align-items: center;
        gap: 15px;
        transition: transform 0.2s;
    }

    .stat-item:hover {
        transform: translateY(-3px);
        box-shadow: none;
    }

    .stat-icon {
        font-size: 32px;
        opacity: 0.9;
        width: 60px;
        height: 60px;
        border-radius: 12px;
        display: flex;
        align-items: center;
        justify-content: center;
        flex-shrink: 0;
        color: white;
    }

    /* 오늘 일정 이모티콘 배경색 */
    .stat-item:first-child .stat-icon {
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    }

    /* 이번 주 일정 이모티콘 배경색 */
    .stat-item:nth-child(2) .stat-icon {
        background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
    }

    /* 이번 달 일정 이모티콘 배경색 */
    .stat-item:nth-child(3) .stat-icon {
        background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
    }

    .stat-content {
        flex: 1;
    }

    .stat-label {
        font-size: 13px;
        color: #2c3e50;
        margin-bottom: 5px;
        font-weight: 500;
    }

    .stat-value {
        font-size: 28px;
        font-weight: 700;
        color: #2c3e50;
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
    
    /* AI 일정 추천 버튼 */
    .ai-schedule-btn {
        width: 100%;
        padding: 15px 20px;
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        color: white;
        border: none;
        border-radius: 12px;
        font-size: 16px;
        font-weight: 600;
        cursor: pointer;
        transition: all 0.3s ease;
        display: flex;
        align-items: center;
        justify-content: center;
        gap: 10px;
        box-shadow: 0 4px 12px rgba(102, 126, 234, 0.3);
    }
    
    .ai-schedule-btn:hover {
        transform: translateY(-2px);
        box-shadow: 0 6px 16px rgba(102, 126, 234, 0.5);
    }
    
    .ai-schedule-btn i {
        font-size: 18px;
    }
    
    /* AI 일정 추천 모달 (식단관리 페이지 스타일과 동일) */
    .modal-overlay {
        display: none;
        position: fixed;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        background: rgba(0, 0, 0, 0.6);
        z-index: 9999;
        align-items: center;
        justify-content: center;
        animation: fadeIn 0.3s ease;
    }
    
    .modal-overlay.show {
        display: flex;
    }
    
    @keyframes fadeIn {
        from {
            opacity: 0;
        }
        to {
            opacity: 1;
        }
    }
    
    .modal-content {
        background: white;
        border-radius: 20px;
        width: 90%;
        max-width: 700px;
        max-height: 90vh;
        overflow-y: auto;
        box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
        animation: slideUp 0.3s ease;
    }
    
    @keyframes slideUp {
        from {
            opacity: 0;
            transform: translateY(50px);
        }
        to {
            opacity: 1;
            transform: translateY(0);
        }
    }
    
    .modal-header {
        padding: 25px 30px;
        border-bottom: 2px solid #f7fafc;
        display: flex;
        align-items: center;
        justify-content: space-between;
    }
    
    .modal-title {
        font-size: 22px;
        font-weight: 700;
        color: #2d3748;
        margin: 0;
        display: flex;
        align-items: center;
        gap: 10px;
    }
    
    .modal-title i {
        color: #667eea;
    }
    
    .modal-close-btn {
        width: 36px;
        height: 36px;
        border: none;
        background: #f7fafc;
        color: #718096;
        border-radius: 50%;
        cursor: pointer;
        display: flex;
        align-items: center;
        justify-content: center;
        transition: all 0.3s ease;
    }
    
    .modal-close-btn:hover {
        background: #ff6b6b;
        color: white;
        transform: rotate(90deg);
    }
    
    .modal-body {
        padding: 30px;
    }
    
    .form-group {
        margin-bottom: 20px;
    }
    
    .form-label {
        display: block;
        font-size: 14px;
        font-weight: 600;
        color: #2d3748;
        margin-bottom: 8px;
    }
    
    .form-label i {
        color: #667eea;
        margin-right: 5px;
    }
    
    .required {
        color: #ff6b6b;
    }
    
    .form-control {
        width: 100%;
        padding: 12px 15px;
        border: 2px solid #e2e8f0;
        border-radius: 10px;
        font-size: 14px;
        transition: all 0.3s ease;
        font-family: inherit;
    }
    
    .form-control:focus {
        outline: none;
        border-color: #667eea;
        box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
    }
    
    textarea.form-control {
        resize: vertical;
        min-height: 100px;
    }
    
    .form-hint {
        display: block;
        font-size: 12px;
        color: #a0aec0;
        margin-top: 5px;
    }
    
    .modal-footer {
        padding: 20px 30px;
        border-top: 2px solid #f7fafc;
        display: flex;
        justify-content: flex-end;
        gap: 10px;
    }
    
    .btn {
        padding: 12px 24px;
        border: none;
        border-radius: 10px;
        font-size: 14px;
        font-weight: 600;
        cursor: pointer;
        transition: all 0.3s ease;
    }
    
    .btn-cancel {
        background: #e2e8f0;
        color: #4a5568;
    }
    
    .btn-cancel:hover {
        background: #cbd5e0;
    }
    
    .btn-primary {
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        color: white;
    }
    
    .btn-primary:hover {
        transform: translateY(-2px);
        box-shadow: 0 4px 12px rgba(102, 126, 234, 0.4);
    }
    
    .btn-success {
        background: linear-gradient(135deg, #48bb78 0%, #38a169 100%);
        color: white;
    }
    
    .btn-success:hover {
        transform: translateY(-2px);
        box-shadow: 0 4px 12px rgba(72, 187, 120, 0.4);
    }
    
    /* AI 일정 추천 결과 */
    .ai-schedule-result {
        margin-top: 20px;
    }
    
    .schedule-timeline {
        display: flex;
        flex-direction: column;
        gap: 15px;
        margin-bottom: 20px;
    }
    
    .timeline-item {
        display: flex;
        gap: 15px;
        padding: 15px;
        background: #f8f9fc;
        border-left: 4px solid #667eea;
        border-radius: 8px;
        transition: all 0.2s ease;
    }
    
    .timeline-item:hover {
        background: #eef2ff;
        transform: translateX(5px);
    }
    
    .timeline-time {
        min-width: 120px;
        font-weight: 600;
        color: #667eea;
        font-size: 14px;
        display: flex;
        align-items: center;
    }
    
    .timeline-content {
        flex: 1;
    }
    
    .timeline-content h5 {
        margin: 0;
        font-size: 16px;
        font-weight: 600;
        color: #2d3748;
    }
</style>