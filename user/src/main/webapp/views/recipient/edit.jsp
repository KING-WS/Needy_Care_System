<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<style>
    .edit-container {
        max-width: 800px;
        margin: 0 auto;
        padding: 40px 20px;
    }
    
    .edit-header {
        text-align: center;
        margin-bottom: 40px;
    }
    
    .edit-title {
        font-size: 32px;
        font-weight: 700;
        color: #2c3e50;
        margin-bottom: 10px;
    }
    
    .edit-subtitle {
        font-size: 16px;
        color: #7f8c8d;
    }
    
    .edit-form {
        background: white;
        border-radius: 20px;
        padding: 40px;
        box-shadow: 0 10px 30px rgba(0,0,0,0.1);
    }
    
    .form-section {
        margin-bottom: 30px;
    }
    
    .section-title {
        font-size: 18px;
        font-weight: 600;
        color: #34495e;
        margin-bottom: 20px;
        padding-bottom: 10px;
        border-bottom: 2px solid #3498db;
    }
    
    .form-group {
        margin-bottom: 20px;
    }
    
    .form-label {
        display: block;
        font-size: 14px;
        font-weight: 600;
        color: #2c3e50;
        margin-bottom: 8px;
    }
    
    .required {
        color: #e74c3c;
        margin-left: 4px;
    }
    
    .form-input {
        width: 100%;
        padding: 12px 15px;
        border: 2px solid #ecf0f1;
        border-radius: 10px;
        font-size: 14px;
        transition: all 0.3s ease;
    }
    
    .form-input:focus {
        outline: none;
        border-color: #3498db;
        box-shadow: 0 0 0 3px rgba(52, 152, 219, 0.1);
    }
    
    .form-textarea {
        min-height: 100px;
        resize: vertical;
    }
    
    .radio-group {
        display: flex;
        gap: 20px;
    }
    
    .radio-label {
        display: flex;
        align-items: center;
        cursor: pointer;
    }
    
    .radio-label input[type="radio"] {
        margin-right: 8px;
        width: 18px;
        height: 18px;
        cursor: pointer;
    }
    
    .form-buttons {
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
    
    .error-message {
        background: #fee;
        color: #e74c3c;
        padding: 12px;
        border-radius: 8px;
        margin-bottom: 20px;
        text-align: center;
    }
    
    .info-banner {
        background: #e3f2fd;
        color: #1976d2;
        padding: 15px;
        border-radius: 12px;
        margin-bottom: 30px;
        display: flex;
        align-items: center;
        gap: 10px;
    }
    
    .info-banner i {
        font-size: 24px;
    }
</style>

<div class="edit-container">
    <div class="edit-header">
        <h1 class="edit-title">돌봄 대상자 정보 수정</h1>
        <p class="edit-subtitle">${recipient.recName}님의 정보를 수정합니다</p>
    </div>
    
    <c:if test="${not empty error}">
        <div class="error-message">
            <i class="bi bi-exclamation-triangle"></i> ${error}
        </div>
    </c:if>
    
    <div class="info-banner">
        <i class="bi bi-info-circle-fill"></i>
        <div>
            <strong>등록번호 #${recipient.recId}</strong><br>
            <c:if test="${recipient.recRegdate != null}">
                <small>등록일: ${recipient.recRegdate.toLocalDate()} ${String.format('%02d:%02d', recipient.recRegdate.hour, recipient.recRegdate.minute)}</small>
            </c:if>
        </div>
    </div>
    
    <form class="edit-form" method="post" action="<c:url value='/recipient/edit'/>" enctype="multipart/form-data">
        <!-- Hidden 필드 -->
        <input type="hidden" name="recId" value="${recipient.recId}">
        
        <!-- 기본 정보 -->
        <div class="form-section">
            <h3 class="section-title">
                <i class="bi bi-person-badge"></i> 기본 정보
            </h3>
            
            <div class="form-group">
                <label class="form-label">
                    이름<span class="required">*</span>
                </label>
                <input type="text" name="recName" class="form-input" required 
                       value="${recipient.recName}" placeholder="돌봄 대상자의 이름을 입력하세요">
            </div>
            
            <div class="form-group">
                <label class="form-label">
                    대상자 유형<span class="required">*</span>
                </label>
                <select name="recTypeCode" class="form-input" required>
                    <option value="">선택하세요</option>
                    <option value="ELDERLY" ${recipient.recTypeCode == 'ELDERLY' ? 'selected' : ''}>노인/고령자</option>
                    <option value="PREGNANT" ${recipient.recTypeCode == 'PREGNANT' ? 'selected' : ''}>임산부</option>
                    <option value="DISABLED" ${recipient.recTypeCode == 'DISABLED' ? 'selected' : ''}>장애인</option>
                </select>
            </div>
            
            <div class="form-group">
                <label class="form-label">
                    생년월일<span class="required">*</span>
                </label>
                <c:set var="birthday" value="${recipient.recBirthday}"/>
                <input type="date" name="recBirthday" class="form-input" required 
                       value="${birthday.year}-${String.format('%02d', birthday.monthValue)}-${String.format('%02d', birthday.dayOfMonth)}">
            </div>
            
            <div class="form-group">
                <label class="form-label">
                    성별<span class="required">*</span>
                </label>
                <div class="radio-group">
                    <label class="radio-label">
                        <input type="radio" name="recGender" value="M" ${recipient.recGender == 'M' ? 'checked' : ''} required>
                        <span>남성</span>
                    </label>
                    <label class="radio-label">
                        <input type="radio" name="recGender" value="F" ${recipient.recGender == 'F' ? 'checked' : ''} required>
                        <span>여성</span>
                    </label>
                </div>
            </div>
            
            <div class="form-group">
                <label class="form-label">
                    주소<span class="required">*</span>
                </label>
                <input type="text" name="recAddress" class="form-input" required 
                       value="${recipient.recAddress}" placeholder="거주지 주소를 입력하세요">
            </div>
        </div>
        
        <!-- 건강 정보 -->
        <div class="form-section">
            <h3 class="section-title">
                <i class="bi bi-heart-pulse"></i> 건강 정보
            </h3>
            
            <div class="form-group">
                <label class="form-label">
                    병력 (Medical History)
                </label>
                <textarea name="recMedHistory" class="form-input form-textarea" 
                          placeholder="기존 질병이나 수술 이력 등을 입력하세요">${recipient.recMedHistory}</textarea>
            </div>
            
            <div class="form-group">
                <label class="form-label">
                    알레르기 (Allergies)
                </label>
                <textarea name="recAllergies" class="form-input form-textarea" 
                          placeholder="약물, 음식 알레르기 등을 입력하세요">${recipient.recAllergies}</textarea>
            </div>
            
            <div class="form-group">
                <label class="form-label">
                    건강 요구사항 (Health Needs)
                </label>
                <textarea name="recHealthNeeds" class="form-input form-textarea" 
                          placeholder="특별한 건강 관리 요구사항을 입력하세요">${recipient.recHealthNeeds}</textarea>
            </div>
        </div>
        
        <!-- 추가 정보 -->
        <div class="form-section">
            <h3 class="section-title">
                <i class="bi bi-info-circle"></i> 추가 정보
            </h3>
            
            <div class="form-group">
                <label class="form-label">
                    특이사항 (Special Notes)
                </label>
                <textarea name="recSpecNotes" class="form-input form-textarea" 
                          placeholder="기타 특이사항이나 주의사항을 입력하세요">${recipient.recSpecNotes}</textarea>
            </div>
        </div>
        
        <!-- 버튼 -->
        <div class="form-buttons">
            <button type="button" class="btn btn-secondary" onclick="history.back()">
                <i class="bi bi-x-circle"></i> 취소
            </button>
            <button type="submit" class="btn btn-primary">
                <i class="bi bi-check-circle"></i> 수정 완료
            </button>
        </div>
    </form>
</div>

<script>
    // 폼 유효성 검사
    document.querySelector('.edit-form').addEventListener('submit', function(e) {
        const recName = document.querySelector('input[name="recName"]').value.trim();
        const recTypeCode = document.querySelector('select[name="recTypeCode"]').value;
        const recBirthday = document.querySelector('input[name="recBirthday"]').value;
        const recGender = document.querySelector('input[name="recGender"]:checked');
        const recAddress = document.querySelector('input[name="recAddress"]').value.trim();
        
        if (!recName || !recTypeCode || !recBirthday || !recGender || !recAddress) {
            e.preventDefault();
            alert('필수 항목을 모두 입력해주세요.');
            return false;
        }
        
        // 수정 확인
        if (!confirm('정보를 수정하시겠습니까?')) {
            e.preventDefault();
            return false;
        }
    });
</script>

