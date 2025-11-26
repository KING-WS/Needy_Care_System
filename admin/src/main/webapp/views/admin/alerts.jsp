<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<style>
    .alert-table {
        width: 100%;
        border-collapse: collapse;
        margin-top: 20px;
    }
    .alert-table th, .alert-table td {
        border: 1px solid #ddd;
        padding: 8px;
        text-align: left;
    }
    .alert-table th {
        background-color: #f2f2f2;
    }
    .alert-table .status-unckecked {
        background-color: #ffe0b2; /* 미확인 알림 강조 */
    }
    .alert-table .status-checked {
        background-color: #e0ffe0; /* 확인됨 알림 배경 */
    }
    .status-badge {
        display: inline-block;
        padding: .35em .65em;
        font-size: .75em;
        font-weight: 700;
        line-height: 1;
        text-align: center;
        white-space: nowrap;
        vertical-align: baseline;
        border-radius: .25rem;
    }
    .badge-danger { background-color: #dc3545; color: white; } /* EMERGENCY */
    .badge-info { background-color: #0dcaf0; color: white; } /* CONTACT */
    .badge-secondary { background-color: #6c757d; color: white; } /* 미확인 */
    .badge-success { background-color: #198754; color: white; } /* 확인됨 */
    .btn-check-alert {
        background-color: #007bff;
        color: white;
        border: none;
        padding: 5px 10px;
        border-radius: 5px;
        cursor: pointer;
    }
    .btn-check-alert:hover {
        background-color: #0056b3;
    }
</style>

<div class="container-fluid">
    <h1 class="h3 mb-4 text-gray-800">알림 관리</h1>

    <div class="card shadow mb-4">
        <div class="card-header py-3">
            <h6 class="m-0 font-weight-bold text-primary">알림 내역</h6>
        </div>
        <div class="card-body">
            <div class="table-responsive">
                <table class="alert-table" id="alertsTable">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>대상자</th>
                            <th>유형</th>
                            <th>메시지</th>
                            <th>발생 시각</th>
                            <th>상태</th>
                            <th>처리</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="alert" items="${alerts}">
                            <tr id="alertRow_${alert.alertId}" class="${alert.checkStatus == 'N' ? 'status-unckecked' : 'status-checked'}">
                                <td>${alert.alertId}</td>
                                <td>${alert.recipientName} (<c:out value="${alert.recId}"/>)</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${alert.alertType == 'EMERGENCY'}">
                                            <span class="status-badge badge-danger">긴급 호출</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="status-badge badge-info">연락 요청</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>${alert.alertMsg}</td>
                                <td>${alert.alertRegdate.toString().replace('T', ' ')}</td>
                                <td>
                                    <span id="statusBadge_${alert.alertId}" class="status-badge ${alert.checkStatus == 'N' ? 'badge-secondary' : 'badge-success'}">
                                        ${alert.checkStatus == 'N' ? '미확인' : '확인됨'}
                                    </span>
                                </td>
                                <td>
                                    <c:if test="${alert.checkStatus == 'N'}">
                                        <button class="btn-check-alert" data-alert-id="${alert.alertId}">확인 완료</button>
                                    </c:if>
                                    <c:if test="${alert.checkStatus == 'Y'}">
                                        -
                                    </c:if>
                                </td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty alerts}">
                            <tr>
                                <td colspan="7" style="text-align: center;">새로운 알림이 없습니다.</td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>

<script>
    // [1] 전역 함수로 선언 (index.jsp에서 호출할 수 있도록)
    function addAlertRow(data) {
        const tableBody = document.querySelector('#alertsTable tbody');

        // '새로운 알림이 없습니다' 메시지가 있다면 제거
        const emptyRow = tableBody.querySelector('tr td[colspan="7"]');
        if (emptyRow) {
            tableBody.innerHTML = '';
        }

        const tr = document.createElement('tr');
        tr.id = 'alertRow_' + data.alertId;
        tr.className = 'status-unckecked'; // 노란색 배경

        // 시간 포맷팅 (T 제거)
        const timeStr = data.time.replace('T', ' ').substring(0, 19);

        // 배지 스타일 결정
        let badgeHtml = '';
        if(data.type === 'EMERGENCY') {
            badgeHtml = '<span class="status-badge badge-danger">긴급 호출</span>';
        } else {
            badgeHtml = '<span class="status-badge badge-info">연락 요청</span>';
        }

        tr.innerHTML = `
            <td>\${data.alertId}</td>
            <td>\${data.recName} (\${data.recId})</td>
            <td>\${badgeHtml}</td>
            <td>\${data.message}</td>
            <td>\${timeStr}</td>
            <td>
                <span id="statusBadge_\${data.alertId}" class="status-badge badge-secondary">미확인</span>
            </td>
            <td>
                <button class="btn-check-alert" data-alert-id="\${data.alertId}">확인 완료</button>
            </td>
        `;

        // 테이블 맨 위에 삽입
        tableBody.prepend(tr);
    }

    document.addEventListener('DOMContentLoaded', function() {
        // [2] 이벤트 위임 (Event Delegation) 사용
        // 동적으로 추가된 버튼에도 클릭 이벤트가 적용되게 하려면 table에 이벤트를 걸어야 함
        const table = document.getElementById('alertsTable');

        table.addEventListener('click', function(e) {
            // 클릭한 요소가 '확인 완료' 버튼인지 확인
            if (e.target && e.target.classList.contains('btn-check-alert')) {
                const button = e.target;
                const alertId = button.dataset.alertId;

                if (!confirm(`ID \${alertId} 알림을 확인 처리하시겠습니까?`)) {
                    return;
                }

                fetch(`/admin/alerts/check/\${alertId}`, {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' }
                })
                    .then(response => response.json())
                    .then(data => {
                        if (data.status === 'success') {
                            alert(data.message);

                            // UI 업데이트
                            const statusBadge = document.getElementById(`statusBadge_\${alertId}`);
                            if (statusBadge) {
                                statusBadge.textContent = '확인됨';
                                statusBadge.classList.remove('badge-secondary');
                                statusBadge.classList.add('badge-success');
                            }

                            const alertRow = document.getElementById(`alertRow_\${alertId}`);
                            if (alertRow) {
                                alertRow.classList.remove('status-unckecked');
                                alertRow.classList.add('status-checked');
                            }

                            button.remove(); // 버튼 제거
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
    });
</script>