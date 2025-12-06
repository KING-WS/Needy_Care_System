<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

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

    .recipient-list-container {
        max-width: 1400px;
        margin: 0 auto;
        padding: 40px 20px 100px 20px;
        min-height: calc(100vh - 200px);
    }

    /* ---------------------------------------------------- */
    /* 2. 헤더 스타일 */
    /* ---------------------------------------------------- */
    .page-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 40px;
        padding-bottom: 0;
        border-bottom: none;
    }

    .page-title {
        font-size: 32px;
        font-weight: 800;
        color: var(--secondary-color);
        text-shadow: 0 1px 2px rgba(0, 0, 0, 0.05);
        display: flex;
        align-items: center;
        gap: 10px;
    }

    .page-title i {
        color: var(--primary-color);
    }

    .add-btn {
        background: var(--primary-color);
        color: white;
        border: none;
        padding: 12px 30px;
        border-radius: 50px;
        font-size: 15px;
        font-weight: 700;
        cursor: pointer;
        transition: all 0.3s ease;
        box-shadow: 0 0 0 transparent !important;
        display: flex;
        align-items: center;
        gap: 8px;
    }

    .add-btn:hover {
        background: #2980b9;
        transform: translateY(-2px);
        box-shadow: 0 0 0 transparent !important;
    }

    /* ---------------------------------------------------- */
    /* 3. 그리드 & 카드 스타일 */
    /* ---------------------------------------------------- */
    .recipient-grid {
        display: grid;
        grid-template-columns: repeat(auto-fill, minmax(320px, 1fr));
        gap: 30px;
        margin-top: 20px;
    }

    .recipient-card {
        background: var(--card-bg);
        border-radius: 20px;
        padding: 30px;
        box-shadow: 0 10px 30px rgba(0,0,0,0.05);
        transition: all 0.3s ease;
        border: 1px solid transparent;
        display: flex;
        flex-direction: column;
    }

    .recipient-card:hover {
        transform: translateY(-5px);
        box-shadow: 0 15px 35px rgba(0,0,0,0.1);
        border-color: rgba(52, 152, 219, 0.3);
    }

    .card-header {
        display: flex;
        align-items: center;
        margin-bottom: 20px;
        padding-bottom: 20px;
        border-bottom: 2px solid var(--secondary-bg);
    }

    .avatar {
        width: 80px;
        height: 80px;
        border-radius: 50%;
        background: var(--secondary-bg);
        display: flex;
        align-items: center;
        justify-content: center;
        color: var(--primary-color);
        font-size: 35px;
        margin-right: 20px;
        flex-shrink: 0;
        overflow: hidden;
        border: 3px solid white;
        box-shadow: 0 5px 15px rgba(0,0,0,0.05);
    }

    .avatar img {
        width: 100%;
        height: 100%;
        object-fit: cover;
    }

    .card-info {
        flex: 1;
    }

    .recipient-name {
        font-size: 22px;
        font-weight: 800;
        color: var(--secondary-color);
        margin-bottom: 8px;
    }

    .recipient-type {
        display: inline-block;
        padding: 5px 12px;
        border-radius: 20px;
        font-size: 13px;
        font-weight: 700;
    }

    .type-elderly { background: #e3f2fd; color: #1976d2; }
    .type-pregnant { background: #fce4ec; color: #c2185b; }
    .type-disabled { background: #f3e5f5; color: #7b1fa2; }

    .card-details {
        margin: 10px 0 25px 0;
        flex: 1;
    }

    .detail-item {
        display: flex;
        align-items: center;
        padding: 8px 0;
        color: #555;
        font-size: 15px;
        font-weight: 500;
    }

    .detail-item i {
        width: 25px;
        margin-right: 10px;
        color: var(--primary-color);
        font-size: 16px;
        text-align: center;
    }

    /* ---------------------------------------------------- */
    /* 4. 액션 버튼 스타일 */
    /* ---------------------------------------------------- */
    .card-actions {
        display: grid;
        grid-template-columns: 1fr 1fr;
        gap: 10px;
        margin-top: auto;
    }

    .action-btn {
        padding: 10px;
        border: none;
        border-radius: 12px;
        font-size: 14px;
        font-weight: 600;
        cursor: pointer;
        transition: all 0.3s ease;
        display: flex;
        align-items: center;
        justify-content: center;
        gap: 5px;
    }

    .btn-select {
        background: #e8f5e9;
        color: #2e7d32;
        grid-column: span 2; /* 선택 버튼은 전체 너비 사용 */
        padding: 12px;
        font-size: 15px;
    }
    .btn-select:hover { background: #c8e6c9; }

    .btn-view { background: var(--secondary-bg); color: var(--primary-color); }
    .btn-view:hover { background: #e3f2fd; }

    .btn-edit { background: #fff3e0; color: #f57c00; }
    .btn-edit:hover { background: #ffe0b2; }

    .btn-delete { background: #ffebee; color: #d32f2f; }
    .btn-delete:hover { background: #ffcdd2; }

    /* ---------------------------------------------------- */
    /* 5. Empty State & Loading */
    /* ---------------------------------------------------- */
    .empty-state {
        text-align: center;
        padding: 80px 20px;
        background: white;
        border-radius: 20px;
        box-shadow: 0 10px 30px rgba(0,0,0,0.05);
    }

    .empty-icon {
        font-size: 80px;
        color: #e0e0e0;
        margin-bottom: 20px;
    }

    .empty-title {
        font-size: 24px;
        font-weight: 800;
        color: var(--secondary-color);
        margin-bottom: 10px;
    }

    .empty-subtitle {
        font-size: 16px;
        color: #7f8c8d;
        margin-bottom: 30px;
    }

    .loading {
        text-align: center;
        padding: 80px;
        font-size: 18px;
        color: #95a5a6;
        font-weight: 600;
    }

    .loading i {
        font-size: 40px;
        color: var(--primary-color);
        margin-bottom: 15px;
        display: block;
        animation: spin 1s linear infinite;
    }

    @keyframes spin {
        0% { transform: rotate(0deg); }
        100% { transform: rotate(360deg); }
    }
</style>

<div class="recipient-list-container">
    <div class="page-header">
        <h1 class="page-title">
            <i class="bi bi-people-fill"></i> 돌봄 대상자 목록
        </h1>
        <button class="add-btn" onclick="location.href='<c:url value='/recipient/register'/>'">
            <i class="bi bi-plus-circle"></i> 새 대상자 등록
        </button>
    </div>

    <div id="recipientListContainer">
        <div class="loading">
            <i class="bi bi-hourglass-split"></i>
            데이터를 불러오는 중입니다...
        </div>
    </div>
</div>

<script>
    // 페이지 로드 시 데이터 가져오기
    document.addEventListener('DOMContentLoaded', function() {
        loadRecipientList();
    });

    // 돌봄 대상자 목록 로드
    function loadRecipientList() {
        fetch('<c:url value="/recipient/api/list"/>')
            .then(response => response.json())
            .then(data => {
                displayRecipientList(data);
            })
            .catch(error => {
                console.error('Error:', error);
                document.getElementById('recipientListContainer').innerHTML = `
                    <div class="empty-state">
                        <div class="empty-icon"><i class="bi bi-exclamation-triangle"></i></div>
                        <div class="empty-title">데이터를 불러올 수 없습니다</div>
                        <div class="empty-subtitle">잠시 후 다시 시도해주세요.</div>
                    </div>
                `;
            });
    }

    // 대상자 목록 표시
    function displayRecipientList(recipients) {
        const container = document.getElementById('recipientListContainer');
        if (!recipients || recipients.length === 0) {
            container.innerHTML = `
                <div class="empty-state">
                    <div class="empty-icon"><i class="bi bi-person-x"></i></div>
                    <div class="empty-title">등록된 돌봄 대상자가 없습니다</div>
                    <div class="empty-subtitle">새로운 대상자를 등록하여 돌봄 서비스를 시작하세요.</div>
                    <button class="add-btn" style="margin: 0 auto;" onclick="location.href='<c:url value='/recipient/register'/>'">
                        <i class="bi bi-plus-circle"></i> 첫 대상자 등록하기
                    </button>
                </div>
            `;
            return;
        }

        let html = '<div class="recipient-grid">';
        recipients.forEach(recipient => {
            const typeInfo = getTypeInfo(recipient.recTypeCode);
            const age = calculateAge(recipient.recBirthday);
            const gender = recipient.recGender === 'M' ? '남성' : '여성';

            // 이미지 URL 처리 (상대 경로인 경우 절대 경로로 변환)
            let photoUrl = '';
            if (recipient.recPhotoUrl) {
                photoUrl = recipient.recPhotoUrl.startsWith('/')
                    ? recipient.recPhotoUrl
                    : '/' + recipient.recPhotoUrl;
            }

            html += `
                <div class="recipient-card">
                    <div class="card-header">
                        <div class="avatar">
                            \${photoUrl
                                ? `<img src="\${photoUrl}" alt="\${recipient.recName}" onerror="this.style.display='none'; this.parentElement.innerHTML='<i class=\\'bi bi-person-fill\\'></i>';" />`
                                : `<i class="bi bi-person-fill"></i>`
        }
    </div>
        <div class="card-info">
            <div class="recipient-name">\${recipient.recName}</div>
            <span class="recipient-type \${typeInfo.class}">\${typeInfo.label}</span>
        </div>
    </div>

        <div class="card-details">
            <div class="detail-item">
                <i class="bi bi-calendar-event"></i>
                <span>\${age}세 (\${formatDate(recipient.recBirthday)})</span>
            </div>
            <div class="detail-item">
                <i class="bi bi-gender-ambiguous"></i>
                <span>\${gender}</span>
            </div>
            <div class="detail-item">
                <i class="bi bi-geo-alt-fill"></i>
                <span>\${recipient.recAddress || '주소 미등록'}</span>
            </div>
        </div>

        <div class="card-actions">
            <button class="action-btn btn-select" onclick="selectRecipient(\${recipient.recId})">
                <i class="bi bi-check-circle"></i> 관리 대상으로 선택
            </button>
            <button class="action-btn btn-view" onclick="viewRecipient(\${recipient.recId})">
                <i class="bi bi-eye"></i> 상세
            </button>
            <button class="action-btn btn-edit" onclick="editRecipient(\${recipient.recId})">
                <i class="bi bi-pencil"></i> 수정
            </button>
            <button class="action-btn btn-delete" onclick="deleteRecipient(\${recipient.recId}, '\${recipient.recName}')" style="grid-column: span 2;">
                <i class="bi bi-trash"></i> 삭제
            </button>
        </div>
    </div>
        `;
        });

        html += '</div>';
        container.innerHTML = html
    }

    // 유형 정보 가져오기
    function getTypeInfo(typeCode) {
        const types = {
            'ELDERLY': { label: '노인/고령자', class: 'type-elderly' },
            'PREGNANT': { label: '임산부', class: 'type-pregnant' },
            'DISABLED': { label: '장애인', class: 'type-disabled' }
        };
        return types[typeCode] || { label: '기타', class: 'type-elderly' };
    }

    // 나이 계산
    function calculateAge(birthday) {
        const birthDate = new Date(birthday);
        const today = new Date();
        let age = today.getFullYear() - birthDate.getFullYear();
        const monthDiff = today.getMonth() - birthDate.getMonth();
        if (monthDiff < 0 || (monthDiff === 0 && today.getDate() < birthDate.getDate())) {
            age--;
        }
        return age;
    }

    // 날짜 포맷
    function formatDate(dateString) {
        const date = new Date(dateString);
        const year = date.getFullYear();
        const month = String(date.getMonth() + 1).padStart(2, '0');
        const day = String(date.getDate()).padStart(2, '0');
        return `\${year}년 \${month}월 \${day}일`;
    }

    // 노약자 선택 (홈 화면으로 이동)
    function selectRecipient(recId) {
        location.href = '<c:url value="/home"/>?recId=' + recId;
    }

    // 상세보기
    function viewRecipient(recId) {
        location.href = '<c:url value="/recipient/detail"/>?recId=' + recId;
    }

    // 수정
    function editRecipient(recId) {
        location.href = '<c:url value="/recipient/edit"/>?recId=' + recId;
    }

    // 삭제
    function deleteRecipient(recId, recName) {
        if (confirm(`'\${recName}' 대상자를 삭제하시겠습니까?`)) {
            fetch(`<c:url value="/recipient/api/delete"/>?recId=\${recId}`, {
                method: 'DELETE'
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    alert('삭제되었습니다.');
                    loadRecipientList(); // 목록 새로고침
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
</script>