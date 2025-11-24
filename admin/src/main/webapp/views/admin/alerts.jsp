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
                                <td><fmt:formatDate value="${alert.alertRegdate}" pattern="yyyy-MM-dd HH:mm:ss"/></td>
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
document.addEventListener('DOMContentLoaded', function() {
    const checkButtons = document.querySelectorAll('.btn-check-alert');

    checkButtons.forEach(button => {
        button.addEventListener('click', function() {
            const alertId = this.dataset.alertId;
            const confirmCheck = confirm(`ID ${alertId} 알림을 확인 처리하시겠습니까?`);

            if (confirmCheck) {
                fetch(`/admin/alerts/check/${alertId}`, {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json'
                    }
                })
                .then(response => response.json())
                .then(data => {
                    if (data.status === 'success') {
                        alert(data.message);
                        // UI 업데이트
                        const statusBadge = document.getElementById(`statusBadge_${alertId}`);
                        if (statusBadge) {
                            statusBadge.textContent = '확인됨';
                            statusBadge.classList.remove('badge-secondary');
                            statusBadge.classList.add('badge-success');
                        }
                        const alertRow = document.getElementById(`alertRow_${alertId}`);
                        if (alertRow) {
                            alertRow.classList.remove('status-unckecked');
                            alertRow.classList.add('status-checked');
                        }
                        this.remove(); // 버튼 제거
                    } else {
                        alert('알림 확인 처리 실패: ' + data.message);
                    }
                })
                .catch(error => {
                    console.error('알림 확인 처리 중 오류:', error);
                    alert('알림 확인 처리 중 오류가 발생했습니다.');
                });
            }
        });
    });
});
</script>