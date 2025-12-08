<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<style>
    /* 테이블 스타일 개선 */
    .alert-table {
        width: 100%;
        border-collapse: separate; /* 행 간 간격 분리 */
        border-spacing: 0 8px; /* 행 사이 간격 */
        margin-top: 10px;
    }
    .alert-table th {
        background-color: #f8f9fc;
        color: #858796;
        font-weight: 600;
        text-transform: uppercase;
        font-size: 0.85rem;
        padding: 12px;
        border: none;
    }
    .alert-table td {
        background-color: #fff;
        padding: 15px;
        vertical-align: middle;
        border-top: 1px solid #e3e6f0;
        border-bottom: 1px solid #e3e6f0;
    }
    .alert-table tr:first-child td { border-top: none; }

    /* 긴급 알림 강조 스타일 */
    .alert-row-emergency td {
        background-color: #fff3f3 !important; /* 아주 옅은 빨강 */
        border-top: 1px solid #ffcccc;
        border-bottom: 1px solid #ffcccc;
    }
    .alert-row-emergency td:first-child {
        border-left: 4px solid #e74a3b; /* 왼쪽 빨간띠 */
    }

    /* 위협 감지 알림 강조 스타일 */
    .alert-row-danger td {
        background-color: #fffbf2 !important; /* 아주 옅은 노랑 */
        border-top: 1px solid #ffeeba;
        border-bottom: 1px solid #ffeeba;
    }
    .alert-row-danger td:first-child {
        border-left: 4px solid #ffc107; /* 왼쪽 노란띠 */
    }

    /* 상태 배지 디자인 */
    .status-badge {
        padding: 6px 12px;
        border-radius: 20px;
        font-size: 0.75rem;
        font-weight: 700;
        display: inline-flex;
        align-items: center;
        gap: 5px;
    }
    .badge-danger { background-color: #e74a3b1a; color: #e74a3b; border: 1px solid #e74a3b; }
    .badge-warning { background-color: #fff3cd; color: #856404; border: 1px solid #ffeeba; } /* DANGER용 */
    .badge-info { background-color: #36b9cc1a; color: #36b9cc; border: 1px solid #36b9cc; }
    .badge-success { background-color: #1cc88a1a; color: #1cc88a; border: 1px solid #1cc88a; }
    .badge-secondary { background-color: #8587961a; color: #858796; border: 1px solid #858796; }

    /* 액션 버튼 스타일 */
    .btn-icon {
        width: 36px;
        height: 36px;
        border-radius: 50%;
        border: none;
        display: inline-flex;
        align-items: center;
        justify-content: center;
        transition: all 0.2s;
        margin-right: 5px;
        cursor: pointer;
    }
    .btn-check-alert {
        background-color: #f0f1f5;
        color: #007bff;
    }
    .btn-check-alert:hover {
        background-color: #007bff;
        color: white;
        transform: translateY(-2px);
    }
    .btn-video-call {
        background-color: #e8f5e9;
        color: #28a745;
    }
    .btn-video-call:hover {
        background-color: #28a745;
        color: white;
        transform: translateY(-2px);
        box-shadow: 0 4px 10px rgba(40, 167, 69, 0.3);
    }


    .text-gray-500 { color: #b7b9cc !important; }
    .text-gray-600 { color: #858796 !important; }
    .small { font-size: 80%; font-weight: 400; }
</style>

<div class="container-fluid">
    <h1 class="h3 mb-4 text-gray-800">알림 관리</h1>
    <div class="card shadow mb-4">
        <div class="card-header py-3 d-flex flex-row align-items-center justify-content-between">
            <h6 class="m-0 font-weight-bold text-primary">실시간 알림 모니터링</h6>

            <button id="btnCheckAll" class="btn btn-sm btn-primary shadow-sm">
                <i class="fas fa-check-double"></i> 전체 확인
            </button>
        </div>

        <div class="card-body">
            <div class="table-responsive">
                <table class="alert-table" id="alertsTable">
                    <thead>
                    <tr>
                        <th style="width: 80px;">ID</th>
                        <th style="width: 200px;">대상자</th>
                        <th style="width: 150px;">보호자</th> <th style="width: 150px;">유형</th>
                        <th>메시지</th>
                        <th style="width: 180px;">발생 시각</th>
                        <th style="width: 120px;">상태</th>
                        <th style="width: 120px;">처리</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="alert" items="${alerts}">
                        <c:set var="rowClass" value="" />
                        <c:if test="${alert.alertType == 'EMERGENCY'}"><c:set var="rowClass" value="alert-row-emergency" /></c:if>
                        <c:if test="${alert.alertType == 'DANGER'}"><c:set var="rowClass" value="alert-row-danger" /></c:if>

                        <tr id="alertRow_${alert.alertId}" class="${rowClass}">
                            <td><strong>#${alert.alertId}</strong></td>
                            <td>
                                <div class="d-flex align-items-center">
                                    <div>
                                        <div class="font-weight-bold">${alert.recipientName}</div>
                                        <div class="small text-gray-500">ID: <c:out value="${alert.recId}"/></div>
                                    </div>
                                </div>
                            </td>
                            <td>
                                <div>
                                    <div class="font-weight-bold">${alert.protectorName != null ? alert.protectorName : '-'}</div>
                                    <div class="small text-gray-500">${alert.protectorPhone != null ? alert.protectorPhone : ''}</div>
                                </div>
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${alert.alertType == 'EMERGENCY'}">
                                        <span class="status-badge badge-danger"><i class="fas fa-exclamation-circle"></i> 긴급 호출</span>
                                    </c:when>
                                    <c:when test="${alert.alertType == 'DANGER'}">
                                        <span class="status-badge badge-warning"><i class="fas fa-video"></i> 위협 감지</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="status-badge badge-info"><i class="fas fa-phone"></i> 연락 요청</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td class="text-dark">${alert.alertMsg}</td>
                            <td class="small text-gray-600">${alert.alertRegdate.toString().replace('T', ' ').substring(0, 16)}</td>
                            <td>
                                    <span id="statusBadge_${alert.alertId}" class="status-badge ${alert.checkStatus == 'N' ? 'badge-secondary' : 'badge-success'}">
                                            ${alert.checkStatus == 'N' ? '<i class="far fa-circle"></i> 미확인' : '<i class="fas fa-check-circle"></i> 확인됨'}
                                    </span>
                            </td>
                            <td>
                                <div class="d-flex">
                                    <c:if test="${alert.checkStatus == 'N'}">
                                        <button class="btn-icon btn-check-alert" data-alert-id="${alert.alertId}" title="확인 처리">
                                            <i class="fas fa-check"></i>
                                        </button>
                                    </c:if>

                                    <c:if test="${alert.alertType == 'EMERGENCY' || alert.alertType == 'DANGER'}">
                                        <button class="btn-icon btn-video-call ${alert.alertType == 'EMERGENCY' ? 'emergency' : ''}"
                                                data-kiosk-code="${alert.kioskCode}" title="영상 연결">
                                            <i class="fas fa-video"></i>
                                        </button>
                                    </c:if>
                                </div>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty alerts}">
                        <tr>
                            <td colspan="8" style="text-align: center; padding: 30px; color: #858796;">
                                <i class="far fa-bell-slash fa-2x mb-3 d-block"></i>
                                새로운 알림이 없습니다.
                            </td>
                        </tr>
                    </c:if>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>

<script>
    // [1] 전역 함수로 선언
    function addAlertRow(data) {
        const tableBody = document.querySelector('#alertsTable tbody');
        const emptyRow = tableBody.querySelector('tr td[colspan]');
        if (emptyRow) {
            tableBody.innerHTML = '';
        }

        const tr = document.createElement('tr');
        tr.id = 'alertRow_' + data.alertId;

        // 1. 행 스타일 및 배지 HTML 설정
        let badgeHtml = '';
        let rowClass = '';

        if (data.type === 'EMERGENCY') {
            rowClass = 'alert-row-emergency';
            badgeHtml = '<span class="status-badge badge-danger"><i class="fas fa-exclamation-circle"></i> 긴급 호출</span>';
        } else if (data.type === 'DANGER') {
            rowClass = 'alert-row-danger';
            badgeHtml = '<span class="status-badge badge-warning"><i class="fas fa-video"></i> 위협 감지</span>';
        } else {
            badgeHtml = '<span class="status-badge badge-info"><i class="fas fa-phone"></i> 연락 요청</span>';
        }

        if (rowClass) tr.className = rowClass;

        // 2. 버튼 HTML 생성 (따옴표와 + 연산자 사용)
        let buttonsHtml = '<button class="btn-icon btn-check-alert" data-alert-id="' + data.alertId + '" title="확인 처리"><i class="fas fa-check"></i></button>';

        if (data.type === 'EMERGENCY' || data.type === 'DANGER') {
            buttonsHtml += ' <button class="btn-icon btn-video-call" data-kiosk-code="' + data.kioskCode + '" title="영상 연결">' +
                '<i class="fas fa-video"></i></button>';
        }

        const timeStr = data.time.replace('T', ' ').substring(0, 16);

        // [중요] 컬럼 순서: ID -> 대상자 -> 보호자 -> 유형 -> 메시지 -> 시각 -> 상태 -> 처리
        tr.innerHTML =
            '<td><strong>#' + data.alertId + '</strong></td>' +
            // 대상자
            '<td>' +
            '<div class="d-flex align-items-center">' +
            '<div>' +
            '<div class="font-weight-bold">' + data.recName + '</div>' +
            '<div class="small text-gray-500">ID: ' + data.recId + '</div>' +
            '</div>' +
            '</div>' +
            '</td>' +
            // [추가] 보호자 정보 (순서 맞춤)
            '<td>' +
            '<div>' +
            '<div class="font-weight-bold">' + (data.protectorName ? data.protectorName : '-') + '</div>' +
            '<div class="small text-gray-500">' + (data.protectorPhone ? data.protectorPhone : '') + '</div>' +
            '</div>' +
            '</td>' +
            // 유형
            '<td>' + badgeHtml + '</td>' +
            // 메시지
            '<td class="text-dark">' + data.message + '</td>' +
            // 시각
            '<td class="small text-gray-600">' + timeStr + '</td>' +
            // 상태
            '<td>' +
            '<span id="statusBadge_' + data.alertId + '" class="status-badge badge-secondary"><i class="far fa-circle"></i> 미확인</span>' +
            '</td>' +
            // 처리 버튼
            '<td>' +
            '<div class="d-flex">' + buttonsHtml + '</div>' +
            '</td>';

        tableBody.prepend(tr);
    }

    document.addEventListener('DOMContentLoaded', function() {
        const table = document.getElementById('alertsTable');

        table.addEventListener('click', function(e) {
            const videoBtn = e.target.closest('.btn-video-call');
            const checkBtn = e.target.closest('.btn-check-alert');

            // [영상 연결]
            if (videoBtn) {
                const kioskCode = videoBtn.dataset.kioskCode;
                // 문자열 연결로 변경
                const url = '/websocket/video?roomId=' + kioskCode;

                const width = 1200;
                const height = 800;
                const left = (window.screen.width / 2) - (width / 2);
                const top = (window.screen.height / 2) - (height / 2);

                // window.open 옵션 문자열 연결
                window.open(url, 'videoCallWindow', 'width=' + width + ',height=' + height + ',top=' + top + ',left=' + left + ',scrollbars=yes,resizable=yes');
                return;
            }

            // [확인 처리]
            if (checkBtn) {
                const alertId = checkBtn.getAttribute('data-alert-id');
                if (!alertId) return;

                // 문자열 연결로 변경
                if (!confirm('알림 #' + alertId + '를 확인 처리하시겠습니까?')) {
                    return;
                }

                fetch('/admin/alerts/check/' + alertId, {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' }
                })
                    .then(response => response.json())
                    .then(data => {
                        if (data.status === 'success') {
                            const statusBadge = document.getElementById('statusBadge_' + alertId);
                            if (statusBadge) {
                                statusBadge.innerHTML = '<i class="fas fa-check-circle"></i> 확인됨';
                                statusBadge.classList.remove('badge-secondary');
                                statusBadge.classList.add('badge-success');
                            }
                            checkBtn.remove();
                        } else {
                            alert('실패: ' + data.message);
                        }
                    })
                    .catch(error => {
                        console.error('Error:', error);
                        alert('오류가 발생했습니다.');
                    });
            }
        });

        // [전체 확인]
        const btnCheckAll = document.getElementById('btnCheckAll');
        if (btnCheckAll) {
            btnCheckAll.addEventListener('click', async function() {
                const checkBtns = document.querySelectorAll('.btn-check-alert');

                if (checkBtns.length === 0) {
                    alert('확인 처리할 알림이 없습니다.');
                    return;
                }

                // 문자열 연결로 변경
                if (!confirm('현재 목록에 있는 ' + checkBtns.length + '건의 알림을 모두 확인 처리하시겠습니까?')) {
                    return;
                }

                const originalText = btnCheckAll.innerHTML;
                btnCheckAll.disabled = true;
                btnCheckAll.innerHTML = '<i class="fas fa-spinner fa-spin"></i> 처리 중...';

                try {
                    const promises = Array.from(checkBtns).map(btn => {
                        const alertId = btn.getAttribute('data-alert-id');
                        // URL 문자열 연결로 변경
                        return fetch('/admin/alerts/check/' + alertId, {
                            method: 'POST',
                            headers: { 'Content-Type': 'application/json' }
                        }).then(res => res.json());
                    });

                    await Promise.all(promises);

                    alert('모든 알림이 확인되었습니다.');



                    location.reload();

                } catch (error) {
                    console.error('전체 처리 중 오류:', error);
                    alert('일부 알림 처리에 실패했습니다.');
                    btnCheckAll.disabled = false;
                    btnCheckAll.innerHTML = originalText;
                }
            });
        }
    });
</script>