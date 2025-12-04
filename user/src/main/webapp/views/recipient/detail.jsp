<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<style>
    /* ---------------------------------------------------- */
    /* 1. 글로벌 스타일 및 변수 정의 */
    /* ---------------------------------------------------- */
    :root {
        --primary-color: #3498db; /* 통일된 주 색상 */
        --secondary-color: #343a40;
        --secondary-bg: #F0F8FF;
        --card-bg: white;
        --danger-color: #e74c3c;
    }

    body {
        background-color: #f8f9fa; /* 전체 배경색 유지 */
    }

    /* ---------------------------------------------------- */
    /* 2. 메인 레이아웃: 2단 분리 */
    /* ---------------------------------------------------- */
    .detail-container {
        max-width: 1300px; /* 너비 확장 */
        margin: 0 auto;
        padding: 40px 20px;
        padding-bottom: 50px;
        min-height: calc(100vh - 150px);
    }

    .detail-two-column {
        display: grid;
        grid-template-columns: 1fr 2fr; /* 왼쪽 1, 오른쪽 2 비율 */
        gap: 30px;
        align-items: start;
    }

    /* ---------------------------------------------------- */
    /* 3. 섹션 카드 스타일 (좌/우 동일 적용) */
    /* ---------------------------------------------------- */
    .detail-content-card {
        background: var(--card-bg);
        border-radius: 20px;
        padding: 30px;
        box-shadow: 0 10px 30px rgba(0,0,0,0.05);
        margin-bottom: 30px; /* 각 섹션 카드 아래 여백 */
    }

    /* ---------------------------------------------------- */
    /* 4. 좌측 섹션 (프로필 헤더) 스타일 변경 */
    /* ---------------------------------------------------- */
    .detail-header {
        text-align: center;
        margin-bottom: 30px;
        padding-bottom: 0;
        border-bottom: none;
    }

    .detail-avatar {
        width: 120px;
        height: 120px;
        border-radius: 50%;
        background: var(--primary-color); /* 주 색상 적용 */
        display: flex;
        align-items: center;
        justify-content: center;
        color: white;
        font-size: 60px;
        margin: 0 auto 20px;
        border: 4px solid var(--secondary-bg); /* 강조 테두리 */
    }

    .detail-name {
        font-size: 28px; /* 크기 조정 */
        font-weight: 700;
        color: var(--secondary-color);
        margin-bottom: 10px;
    }

    .detail-type {
        display: inline-block;
        padding: 8px 15px;
        border-radius: 20px;
        font-size: 14px;
        font-weight: 600;
        margin-bottom: 15px;
    }

    .type-elderly {
        background: #e3f2fd; /* 연한 파란색 */
        color: #1976d2;
    }

    .type-pregnant {
        background: #fce4ec; /* 연한 분홍색 */
        color: #c2185b;
    }

    .type-disabled {
        background: #f3e5f5; /* 연한 보라색 */
        color: #7b1fa2;
    }

    .detail-meta {
        font-size: 14px;
        color: #7f8c8d;
        margin-top: 10px;
    }

    /* ---------------------------------------------------- */
    /* 5. 정보 섹션 스타일 */
    /* ---------------------------------------------------- */
    .info-section {
        margin-bottom: 25px;
        padding-bottom: 25px;
        border-bottom: none; /* 요청에 따라 제거 */
    }

    .info-section:last-child {
        border-bottom: none;
        margin-bottom: 0;
        padding-bottom: 0;
    }

    .section-title {
        font-size: 20px;
        font-weight: 700;
        color: #000;
        margin-bottom: 20px;
        display: flex;
        align-items: center;
        padding-bottom: 5px;
        border-bottom: 3px solid var(--secondary-bg);
    }

    .section-title i {
        margin-right: 10px;
        color: var(--primary-color);
        font-size: 22px;
    }

    .info-grid {
        display: flex; /* grid 대신 flex로 변경하여 간결하게 */
        flex-direction: column;
        gap: 10px;
    }

    .info-item {
        padding: 15px;
        background: var(--secondary-bg); /* 보조 배경색 적용 */
        border-radius: 12px;
        transition: all 0.3s ease;
        display: flex;
        flex-direction: column;
        border: 1px solid transparent;
    }

    .info-item:hover {
        background: #e9f2ff; /* hover 색상 변경 */
        transform: none;
        border-color: var(--primary-color);
    }

    .info-label {
        font-size: 13px;
        font-weight: 600;
        color: #7f8c8d;
        margin-bottom: 4px;
        text-transform: uppercase;
        letter-spacing: 0.5px;
    }

    .info-value {
        font-size: 16px;
        font-weight: 600;
        color: var(--secondary-color);
        word-break: break-word;
    }

    /* 건강/추가 정보 텍스트 영역 스타일 */
    .info-textarea {
        background: var(--secondary-bg); /* 보조 배경색 적용 */
        border-radius: 12px;
        padding: 20px;
        margin-top: 10px;
        border-left: 5px solid var(--primary-color);
    }

    .info-textarea .info-value {
        white-space: pre-wrap;
        line-height: 1.6;
        font-weight: 400; /* 폰트 두께 조절 */
        font-size: 15px;
    }

    .empty-value {
        color: #adb5bd;
        font-style: italic;
    }

    /* ---------------------------------------------------- */
    /* 6. 키오스크 정보 섹션 스타일 */
    /* ---------------------------------------------------- */
    .kiosk-info-box {
        background: linear-gradient(135deg, #7b88fa 0%, var(--primary-color) 100%);
        padding: 30px;
        border-radius: 15px;
        color: white;
        margin-top: 20px;
        box-shadow: 0 5px 20px rgba(0, 0, 0, 0.2);
    }

    .kiosk-code-display {
        background: rgba(255,255,255,0.15);
        padding: 15px;
        border-radius: 10px;
        margin-bottom: 15px;
        border: 1px solid rgba(255,255,255,0.3);
    }

    .kiosk-code-value {
        font-size: 28px; /* 코드 크기 증가 */
        font-weight: bold;
        letter-spacing: 3px;
        font-family: 'Courier New', monospace;
        text-shadow: 1px 1px 2px rgba(0,0,0,0.2);
    }

    .kiosk-url-display {
        background: rgba(255,255,255,0.1);
        padding: 12px;
        border-radius: 8px;
        margin-bottom: 15px;
        word-break: break-all;
        font-size: 13px;
    }

    .kiosk-button-group button {
        background: white;
        color: var(--primary-color);
        border: none;
        padding: 12px 24px;
        border-radius: 25px;
        font-weight: 600;
        cursor: pointer;
        flex: 1;
        min-width: 150px;
        transition: all 0.3s;
        box-shadow: 0 2px 10px rgba(0,0,0,0.1);
    }
    .kiosk-button-group button:hover {
        background: #f0f8ff;
    }

    .kiosk-button-group button:last-child {
        background: rgba(255,255,255,0.3);
        color: white;
        border: 2px solid white;
    }
    .kiosk-button-group button:last-child:hover {
        background: rgba(255,255,255,0.4);
    }

    /* ---------------------------------------------------- */
    /* 7. 액션 버튼 스타일 및 위치 재조정 */
    /* ---------------------------------------------------- */
    .action-buttons {
        display: flex;
        gap: 15px;
        justify-content: center; /* 중앙 정렬 */
        margin-top: 30px;
        padding-top: 20px;
        border-top: none; /* 요청에 따라 제거 */
        flex-wrap: nowrap; /* 버튼 줄바꿈 방지 */
    }

    .btn {
        padding: 12px 25px; /* 버튼 크기 조정 */
        border: none;
        border-radius: 50px;
        font-size: 15px;
        font-weight: 600;
        cursor: pointer;
        transition: all 0.3s ease;
        display: inline-flex;
        align-items: center;
        gap: 8px; /* 아이콘과 텍스트 간격 */
        white-space: nowrap; /* 텍스트 줄바꿈 방지 */
    }

    .btn-primary {
        background: var(--primary-color);
        color: white;
        box-shadow: 0 4px 10px rgba(52, 152, 219, 0.4);
    }

    .btn-primary:hover {
        transform: translateY(-2px);
        box-shadow: 0 6px 15px rgba(52, 152, 219, 0.6);
    }

    .btn-secondary {
        background: #e9ecef;
        color: #495057;
    }

    .btn-secondary:hover {
        background: #ced4da;
        color: #212529;
    }

    .btn-danger {
        background: #f8d7da; /* 연한 빨강 배경 */
        color: var(--danger-color);
    }

    .btn-danger:hover {
        background: var(--danger-color);
        color: white;
    }

    .status-badge {
        display: inline-block;
        padding: 5px 12px;
        border-radius: 12px;
        font-size: 12px;
        font-weight: 600;
        margin-top: 10px;
    }

    .status-active {
        background: #d4edda;
        color: #155724;
    }

    .status-deleted {
        background: #f8d7da;
        color: #721c24;
    }
</style>

<div class="detail-container">
    <div class="text-center mb-5">
        <h1 style="font-size: 38px; font-weight: 800; color: var(--secondary-color); text-shadow: 0 1px 2px rgba(0, 0, 0, 0.05);">
            <i class="bi bi-person-lines-fill" style="color: var(--primary-color);"></i> 돌봄 대상자 상세 정보
        </h1>
        <p style="font-size: 16px; color: #666; margin-top: 10px;">
            선택하신 돌봄 대상자의 상세 정보를 확인합니다.
        </p>
    </div>

    <div class="detail-two-column">
        <div>
            <div class="detail-content-card">
                <div class="info-section" style="border-bottom: none; padding-bottom: 0;">
                    <h3 class="section-title" style="border-bottom: none;">
                        <i class="bi bi-person-badge"></i> 기본 정보
                    </h3>
                </div>

                <div class="detail-header" style="margin-bottom: 20px;">
                    <div class="detail-avatar">
                        <c:choose>
                            <c:when test="${not empty recipient.recPhotoUrl}">
                                <img src="<c:url value='${recipient.recPhotoUrl}'/>" alt="${recipient.recName}" style="width: 100%; height: 100%; object-fit: cover; border-radius: 50%;">
                            </c:when>
                            <c:otherwise>
                                <i class="bi bi-person-fill"></i>
                            </c:otherwise>
                        </c:choose>
                    </div>
                    <h1 class="detail-name">${recipient.recName}</h1>
                    <c:choose>
                        <c:when test="${recipient.recTypeCode == 'ELDERLY'}">
                            <span class="detail-type type-elderly">노인/고령자</span>
                        </c:when>
                        <c:when test="${recipient.recTypeCode == 'PREGNANT'}">
                            <span class="detail-type type-pregnant">임산부</span>
                        </c:when>
                        <c:when test="${recipient.recTypeCode == 'DISABLED'}">
                            <span class="detail-type type-disabled">장애인</span>
                        </c:when>
                    </c:choose>
                </div>

                <div class="info-section">
                    <div class="info-grid">
                        <div class="info-item">
                            <div class="info-label">생년월일</div>
                            <div class="info-value">
                                <c:set var="birthday" value="${recipient.recBirthday}"/>
                                ${birthday.year}년 ${String.format('%02d', birthday.monthValue)}월 ${String.format('%02d', birthday.dayOfMonth)}일
                                <span style="color: #7f8c8d; margin-left: 10px;">(만 <span id="age"></span>세)</span>
                            </div>
                        </div>
                        <div class="info-item">
                            <div class="info-label">성별</div>
                            <div class="info-value">
                                <c:choose>
                                    <c:when test="${recipient.recGender == 'M'}">
                                        <i class="bi bi-gender-male" style="color: #3498db;"></i> 남성
                                    </c:when>
                                    <c:otherwise>
                                        <i class="bi bi-gender-female" style="color: #e91e63;"></i> 여성
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                        <div class="info-item">
                            <div class="info-label">주소</div>
                            <div class="info-value">
                                <i class="bi bi-geo-alt-fill" style="color: #e74c3c; margin-right: 5px;"></i>
                                ${recipient.recAddress}
                            </div>
                        </div>
                    </div>
                </div>

                <div class="action-buttons">
                    <button class="btn btn-secondary" onclick="history.back()">
                        <i class="bi bi-arrow-left"></i> 목록
                    </button>
                    <button class="btn btn-primary" onclick="location.href='<c:url value='/recipient/edit?recId=${recipient.recId}'/>'">
                        <i class="bi bi-pencil-fill"></i> 정보 수정
                    </button>
                    <button class="btn btn-danger" onclick="deleteRecipient(${recipient.recId}, '${recipient.recName}')">
                        <i class="bi bi-trash-fill"></i> 삭제
                    </button>
                </div>
            </div>

            <div class="detail-content-card">
                <div class="info-section" style="border-bottom: none;">
                    <h3 class="section-title">
                        <i class="bi bi-clock-history"></i> 시스템 정보
                    </h3>
                    <div class="info-grid">
                        <div class="info-item">
                            <div class="info-label">등록 번호</div>
                            <div class="info-value">#${recipient.recId}</div>
                        </div>
                        <c:if test="${recipient.recRegdate != null}">
                            <div class="info-item">
                                <div class="info-label">등록일</div>
                                <div class="info-value">
                                        ${recipient.recRegdate.toLocalDate()} ${String.format('%02d:%02d', recipient.recRegdate.hour, recipient.recRegdate.minute)}
                                </div>
                            </div>
                        </c:if>
                        <c:if test="${recipient.recUpdate != null}">
                            <div class="info-item">
                                <div class="info-label">최종 수정일</div>
                                <div class="info-value">
                                        ${recipient.recUpdate.toLocalDate()} ${String.format('%02d:%02d', recipient.recUpdate.hour, recipient.recUpdate.minute)}
                                </div>
                            </div>
                        </c:if>
                    </div>
                </div>
            </div>
        </div>

        <div>
            <c:if test="${not empty recipient.recKioskCode}">
                <div class="detail-content-card">
                    <div class="info-section" style="border-bottom: none;">
                        <h3 class="section-title">
                            <i class="bi bi-tablet"></i> 키오스크 접속 정보
                        </h3>
                        <div class="kiosk-info-box">
                            <div style="font-size: 14px; margin-bottom: 10px; opacity: 0.9;">
                                <i class="bi bi-info-circle"></i> 노약자 전용 간편 접속 링크
                            </div>
                            <div class="kiosk-code-display">
                                <div style="font-size: 12px; margin-bottom: 8px; opacity: 0.9;">접속 코드:</div>
                                <div class="kiosk-code-value">
                                        ${recipient.recKioskCode}
                                </div>
                            </div>
                            <div class="kiosk-url-display">
                                <div style="font-size: 12px; margin-bottom: 8px; opacity: 0.9;">접속 URL:</div>
                                <div id="kioskUrl" style="font-size: 14px; font-weight: 500; font-family: 'Courier New', monospace;">
                                        ${pageContext.request.scheme}://${pageContext.request.serverName}:${pageContext.request.serverPort}${pageContext.request.contextPath}/kiosk/${recipient.recKioskCode}
                                </div>
                            </div>
                            <div class="kiosk-button-group" style="display: flex; gap: 10px; flex-wrap: wrap;">
                                <button onclick="copyKioskUrl()">
                                    <i class="bi bi-clipboard"></i> 링크 복사
                                </button>
                                <button onclick="showQRCode()">
                                    <i class="bi bi-qr-code"></i> QR코드 보기
                                </button>
                            </div>
                            <div style="font-size: 13px; margin-top: 15px; opacity: 0.85; line-height: 1.6;">
                                <i class="bi bi-lightbulb"></i> <strong>사용 방법:</strong><br>
                                • 위 링크를 노약자 분께 전달하세요<br>
                                • QR코드를 스캔하면 바로 접속됩니다<br>
                                • 별도의 로그인 없이 간편하게 이용 가능합니다
                            </div>
                        </div>
                    </div>
                </div>
            </c:if>

            <div class="detail-content-card">
                <div class="info-section">
                    <h3 class="section-title">
                        <i class="bi bi-heart-pulse"></i> 건강 정보
                    </h3>

                    <div class="info-label">병력 (Medical History)</div>
                    <div class="info-textarea">
                        <div class="info-value ${empty recipient.recMedHistory ? 'empty-value' : ''}">
                            ${empty recipient.recMedHistory ? '등록된 병력 정보가 없습니다.' : recipient.recMedHistory}
                        </div>
                    </div>

                    <div class="info-label" style="margin-top: 20px;">알레르기 (Allergies)</div>
                    <div class="info-textarea">
                        <div class="info-value ${empty recipient.recAllergies ? 'empty-value' : ''}">
                            ${empty recipient.recAllergies ? '등록된 알레르기 정보가 없습니다.' : recipient.recAllergies}
                        </div>
                    </div>

                    <div class="info-label" style="margin-top: 20px;">건강 요구사항 (Health Needs)</div>
                    <div class="info-textarea">
                        <div class="info-value ${empty recipient.recHealthNeeds ? 'empty-value' : ''}">
                            ${empty recipient.recHealthNeeds ? '등록된 건강 요구사항이 없습니다.' : recipient.recHealthNeeds}
                        </div>
                    </div>
                </div>
            </div>

            <div class="detail-content-card">
                <div class="info-section" style="border-bottom: none;">
                    <h3 class="section-title">
                        <i class="bi bi-info-circle"></i> 추가 정보
                    </h3>

                    <div class="info-label">특이사항 (Special Notes)</div>
                    <div class="info-textarea">
                        <div class="info-value ${empty recipient.recSpecNotes ? 'empty-value' : ''}">
                            ${empty recipient.recSpecNotes ? '등록된 특이사항이 없습니다.' : recipient.recSpecNotes}
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="/js/homecenter/center.js"></script>
<script>
    // 나이 계산
    document.addEventListener('DOMContentLoaded', function() {
        <c:set var="birthday" value="${recipient.recBirthday}"/>
        const birthday = new Date(${birthday.year}, ${birthday.monthValue - 1}, ${birthday.dayOfMonth});
        const today = new Date();
        let age = today.getFullYear() - birthday.getFullYear();
        const monthDiff = today.getMonth() - birthday.getMonth();
        if (monthDiff < 0 || (monthDiff === 0 && today.getDate() < birthday.getDate())) {
            age--;
        }
        document.getElementById('age').textContent = age;
    });

    // 삭제 기능
    function deleteRecipient(recId, recName) {
        if (confirm(`'\${recName}' 대상자를 삭제하시겠습니까?\n이 작업은 되돌릴 수 없습니다.`)) {
            fetch(`<c:url value="/recipient/api/delete"/>?recId=\${recId}`, {
                method: 'DELETE'
            })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        alert('삭제되었습니다.');
                        location.href = '<c:url value="/recipient/list"/>';
                    } else {
                        alert('삭제 실패: ' + (data.message || '알 수 없는 오류'));
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    alert('삭제 중 오류가 발생했습니다.');
                });
        }
    }

    // 키오스크 URL 복사
    function copyKioskUrl() {
        const url = document.getElementById('kioskUrl').textContent.trim();
        navigator.clipboard.writeText(url).then(() => {
            alert('✅ 키오스크 링크가 복사되었습니다!\n\n노약자 분께 전달해주세요.');
        }).catch(err => {
            console.error('복사 실패:', err);
            alert('링크 복사에 실패했습니다.');
        });
    }

    // QR코드 모달 표시
    function showQRCode() {
        const url = document.getElementById('kioskUrl').textContent.trim();
        const qrCodeUrl = 'https://api.qrserver.com/v1/create-qr-code/?size=300x300&data=' + encodeURIComponent(url);

        const modal = document.createElement('div');
        modal.style.cssText = 'position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.8); display: flex; align-items: center; justify-content: center; z-index: 9999;';
        modal.innerHTML = `
            <div style="background: white; padding: 40px; border-radius: 20px; text-align: center; max-width: 500px;">
                <h3 style="margin-bottom: 20px; color: #2c3e50;">키오스크 접속 QR코드</h3>
                <img src="\${qrCodeUrl}" alt="QR Code" style="width: 300px; height: 300px; border: 3px solid var(--primary-color); border-radius: 15px; margin-bottom: 20px;">
                <p style="color: #7f8c8d; margin-bottom: 20px; line-height: 1.6;">
                    노약자 분이 스마트폰으로<br>
                    위 QR코드를 스캔하면<br>
                    바로 키오스크 화면으로 이동합니다
                </p>
                <div style="display: flex; gap: 10px; justify-content: center;">
                    <a href="\${qrCodeUrl}" download="kiosk_qr_${recipient.recKioskCode}.png" style="background: var(--primary-color); color: white; padding: 12px 24px; border-radius: 25px; text-decoration: none; font-weight: 600;">
                        <i class="bi bi-download"></i> 다운로드
                    </a>
                    <button onclick="this.closest('div').parentElement.parentElement.remove()" style="background: #e9ecef; color: #495057; padding: 12px 24px; border-radius: 25px; border: none; cursor: pointer; font-weight: 600;">
                        닫기
                    </button>
                </div>
            </div>
        `;

        // 모달 외부 클릭 시 닫기
        modal.addEventListener('click', (e) => {
            if (e.target === modal) {
                modal.remove();
            }
        });

        document.body.appendChild(modal);
    }

    // JSP 변수를 JavaScript 변수로 설정
    var recipientAddress = '<c:out value="${recipient.recAddress}" escapeXml="false"/>';
    var recipientName = '<c:out value="${recipient.recName}" escapeXml="false"/>';
    <c:choose>
        <c:when test="${not empty recipient.recPhotoUrl}">
            <c:set var="jsPhotoUrl" value="${recipient.recPhotoUrl}${fn:contains(recipient.recPhotoUrl, '?') ? '&' : '?'}v=${recipient.recId}"/>
            var recipientPhotoUrl = '<c:out value="${jsPhotoUrl}" escapeXml="false"/>';
        </c:when>
        <c:otherwise>
            var recipientPhotoUrl = '';
        </c:otherwise>
    </c:choose>
    var defaultRecId = <c:choose><c:when test="${not empty recipient}">${recipient.recId}</c:when><c:otherwise>null</c:otherwise></c:choose>;

    // 페이지 로드 시 지도 초기화
    window.addEventListener('load', function() {
        if (typeof kakao !== 'undefined' && kakao.maps) {
            initializeMap();
            loadHomeMarker();
        }
    });
</script>