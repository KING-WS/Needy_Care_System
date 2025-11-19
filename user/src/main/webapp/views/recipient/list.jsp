<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<style>
    .recipient-list-container {
        padding: 30px;
        padding-bottom: 100px;
        min-height: calc(100vh - 200px);
    }
    
    .page-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 30px;
        padding-bottom: 20px;
        border-bottom: 2px solid #f0f0f0;
    }
    
    .page-title {
        font-size: 28px;
        font-weight: 700;
        color: #2c3e50;
    }
    
    .page-title i {
        margin-right: 10px;
        color: #667eea;
    }
    
    .add-btn {
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        color: white;
        border: none;
        padding: 12px 30px;
        border-radius: 50px;
        font-weight: 600;
        cursor: pointer;
        transition: all 0.3s ease;
        box-shadow: 0 4px 15px rgba(102, 126, 234, 0.4);
    }
    
    .add-btn:hover {
        transform: translateY(-2px);
        box-shadow: 0 6px 20px rgba(102, 126, 234, 0.6);
    }
    
    .recipient-grid {
        display: grid;
        grid-template-columns: repeat(auto-fill, minmax(350px, 1fr));
        gap: 25px;
        margin-top: 20px;
    }
    
    .recipient-card {
        background: white;
        border-radius: 20px;
        padding: 25px;
        box-shadow: 0 5px 20px rgba(0,0,0,0.08);
        transition: all 0.3s ease;
        border: 2px solid transparent;
    }
    
    .recipient-card:hover {
        transform: translateY(-5px);
        box-shadow: 0 10px 30px rgba(0,0,0,0.15);
        border-color: #667eea;
    }
    
    .card-header {
        display: flex;
        align-items: center;
        margin-bottom: 20px;
        padding-bottom: 15px;
        border-bottom: 2px solid #f8f9fa;
    }
    
    .avatar {
        width: 70px;
        height: 70px;
        border-radius: 50%;
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        display: flex;
        align-items: center;
        justify-content: center;
        color: white;
        font-size: 32px;
        margin-right: 15px;
        flex-shrink: 0;
    }
    
    .card-info {
        flex: 1;
    }
    
    .recipient-name {
        font-size: 20px;
        font-weight: 700;
        color: #2c3e50;
        margin-bottom: 5px;
    }
    
    .recipient-type {
        display: inline-block;
        padding: 4px 12px;
        border-radius: 12px;
        font-size: 12px;
        font-weight: 600;
    }
    
    .type-elderly {
        background: #e3f2fd;
        color: #1976d2;
    }
    
    .type-pregnant {
        background: #fce4ec;
        color: #c2185b;
    }
    
    .type-disabled {
        background: #f3e5f5;
        color: #7b1fa2;
    }
    
    .card-details {
        margin: 15px 0;
    }
    
    .detail-item {
        display: flex;
        align-items: center;
        padding: 8px 0;
        color: #555;
        font-size: 14px;
    }
    
    .detail-item i {
        width: 20px;
        margin-right: 10px;
        color: #667eea;
    }
    
    .card-actions {
        display: flex;
        gap: 10px;
        margin-top: 20px;
    }
    
    .action-btn {
        flex: 1;
        padding: 10px;
        border: none;
        border-radius: 10px;
        font-size: 14px;
        font-weight: 600;
        cursor: pointer;
        transition: all 0.3s ease;
    }
    
    .btn-view {
        background: #e3f2fd;
        color: #1976d2;
    }
    
    .btn-view:hover {
        background: #1976d2;
        color: white;
    }
    
    .btn-edit {
        background: #fff3e0;
        color: #f57c00;
    }
    
    .btn-edit:hover {
        background: #f57c00;
        color: white;
    }
    
    .btn-delete {
        background: #ffebee;
        color: #d32f2f;
    }
    
    .btn-delete:hover {
        background: #d32f2f;
        color: white;
    }
    
    .empty-state {
        text-align: center;
        padding: 80px 20px;
    }
    
    .empty-icon {
        font-size: 80px;
        color: #e0e0e0;
        margin-bottom: 20px;
    }
    
    .empty-title {
        font-size: 24px;
        font-weight: 700;
        color: #666;
        margin-bottom: 10px;
    }
    
    .empty-subtitle {
        font-size: 16px;
        color: #999;
        margin-bottom: 30px;
    }
    
    .loading {
        text-align: center;
        padding: 50px;
        font-size: 18px;
        color: #666;
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
            <i class="bi bi-hourglass-split"></i> 로딩중...
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
                    <button class="add-btn" onclick="location.href='<c:url value='/recipient/register'/>'">
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
            
            html += `
                <div class="recipient-card">
                    <div class="card-header">
                        <div class="avatar">
                            <i class="bi bi-person-fill"></i>
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
                        <button class="action-btn btn-view" onclick="viewRecipient(\${recipient.recId})">
                            <i class="bi bi-eye"></i> 상세보기
                        </button>
                        <button class="action-btn btn-edit" onclick="editRecipient(\${recipient.recId})">
                            <i class="bi bi-pencil"></i> 수정
                        </button>
                        <button class="action-btn btn-delete" onclick="deleteRecipient(\${recipient.recId}, '\${recipient.recName}')">
                            <i class="bi bi-trash"></i> 삭제
                        </button>
                    </div>
                </div>
            `;
        });
        
        html += '</div>';
        container.innerHTML = html;
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

