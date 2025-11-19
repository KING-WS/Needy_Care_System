<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<style>
    .detail-container {
        max-width: 900px;
        margin: 0 auto;
        padding: 40px 20px;
        padding-bottom: 100px;
        min-height: calc(100vh - 200px);
    }
    
    .detail-header {
        text-align: center;
        margin-bottom: 40px;
        padding-bottom: 30px;
        border-bottom: 2px solid #f0f0f0;
    }
    
    .detail-avatar {
        width: 120px;
        height: 120px;
        border-radius: 50%;
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        display: flex;
        align-items: center;
        justify-content: center;
        color: white;
        font-size: 60px;
        margin: 0 auto 20px;
        box-shadow: 0 10px 30px rgba(102, 126, 234, 0.3);
    }
    
    .detail-name {
        font-size: 32px;
        font-weight: 700;
        color: #2c3e50;
        margin-bottom: 10px;
    }
    
    .detail-type {
        display: inline-block;
        padding: 8px 20px;
        border-radius: 20px;
        font-size: 14px;
        font-weight: 600;
        margin-bottom: 10px;
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
    
    .detail-meta {
        font-size: 16px;
        color: #7f8c8d;
        margin-top: 10px;
    }
    
    .detail-content {
        background: white;
        border-radius: 20px;
        padding: 40px;
        box-shadow: 0 10px 30px rgba(0,0,0,0.1);
    }
    
    .info-section {
        margin-bottom: 35px;
        padding-bottom: 35px;
        border-bottom: 1px solid #ecf0f1;
    }
    
    .info-section:last-child {
        border-bottom: none;
        margin-bottom: 0;
        padding-bottom: 0;
    }
    
    .section-title {
        font-size: 20px;
        font-weight: 700;
        color: #2c3e50;
        margin-bottom: 20px;
        display: flex;
        align-items: center;
    }
    
    .section-title i {
        margin-right: 10px;
        color: #667eea;
        font-size: 24px;
    }
    
    .info-grid {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
        gap: 20px;
    }
    
    .info-item {
        padding: 20px;
        background: #f8f9fa;
        border-radius: 12px;
        transition: all 0.3s ease;
    }
    
    .info-item:hover {
        background: #e3f2fd;
        transform: translateY(-2px);
    }
    
    .info-label {
        font-size: 13px;
        font-weight: 600;
        color: #7f8c8d;
        margin-bottom: 8px;
        text-transform: uppercase;
        letter-spacing: 0.5px;
    }
    
    .info-value {
        font-size: 16px;
        font-weight: 600;
        color: #2c3e50;
        word-break: break-word;
    }
    
    .info-textarea {
        background: #f8f9fa;
        border-radius: 12px;
        padding: 20px;
        margin-top: 10px;
    }
    
    .info-textarea .info-value {
        white-space: pre-wrap;
        line-height: 1.6;
    }
    
    .empty-value {
        color: #bdc3c7;
        font-style: italic;
    }
    
    .action-buttons {
        display: flex;
        gap: 15px;
        justify-content: center;
        margin-top: 40px;
    }
    
    .btn {
        padding: 14px 40px;
        border: none;
        border-radius: 50px;
        font-size: 16px;
        font-weight: 600;
        cursor: pointer;
        transition: all 0.3s ease;
        display: inline-flex;
        align-items: center;
        gap: 8px;
    }
    
    .btn-primary {
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        color: white;
        box-shadow: 0 5px 15px rgba(102, 126, 234, 0.4);
    }
    
    .btn-primary:hover {
        transform: translateY(-2px);
        box-shadow: 0 8px 20px rgba(102, 126, 234, 0.6);
    }
    
    .btn-secondary {
        background: #ecf0f1;
        color: #7f8c8d;
    }
    
    .btn-secondary:hover {
        background: #bdc3c7;
        color: #2c3e50;
    }
    
    .btn-danger {
        background: #fee;
        color: #e74c3c;
    }
    
    .btn-danger:hover {
        background: #e74c3c;
        color: white;
    }
    
    .status-badge {
        display: inline-block;
        padding: 5px 12px;
        border-radius: 12px;
        font-size: 12px;
        font-weight: 600;
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
    <div class="detail-header">
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
        <div class="detail-meta">
            <c:choose>
                <c:when test="${recipient.isDeleted == 'N'}">
                    <span class="status-badge status-active"><i class="bi bi-check-circle"></i> 활성</span>
                </c:when>
                <c:otherwise>
                    <span class="status-badge status-deleted"><i class="bi bi-x-circle"></i> 삭제됨</span>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
    
    <div class="detail-content">
        <!-- 기본 정보 -->
        <div class="info-section">
            <h3 class="section-title">
                <i class="bi bi-person-badge"></i> 기본 정보
            </h3>
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
                <div class="info-item" style="grid-column: 1 / -1;">
                    <div class="info-label">주소</div>
                    <div class="info-value">
                        <i class="bi bi-geo-alt-fill" style="color: #e74c3c; margin-right: 5px;"></i>
                        ${recipient.recAddress}
                    </div>
                </div>
            </div>
        </div>
        
        <!-- 건강 정보 -->
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
        
        <!-- 추가 정보 -->
        <div class="info-section">
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
        
        <!-- 시스템 정보 -->
        <div class="info-section">
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
        
        <!-- 액션 버튼 -->
        <div class="action-buttons">
            <button class="btn btn-secondary" onclick="history.back()">
                <i class="bi bi-arrow-left"></i> 목록으로
            </button>
            <button class="btn btn-primary" onclick="location.href='<c:url value='/recipient/edit?recId=${recipient.recId}'/>'">
                <i class="bi bi-pencil-fill"></i> 정보 수정
            </button>
            <button class="btn btn-danger" onclick="deleteRecipient(${recipient.recId}, '${recipient.recName}')">
                <i class="bi bi-trash-fill"></i> 삭제
            </button>
        </div>
    </div>
</div>

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
</script>

