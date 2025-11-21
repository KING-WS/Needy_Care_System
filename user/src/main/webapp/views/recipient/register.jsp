<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<style>
    .register-container {
        max-width: 800px;
        margin: 0 auto;
        padding: 40px 20px;
        padding-bottom: 100px;
        min-height: calc(100vh - 200px);
    }
    
    .register-header {
        text-align: center;
        margin-bottom: 40px;
    }
    
    .register-title {
        font-size: 32px;
        font-weight: 700;
        color: #2c3e50;
        margin-bottom: 10px;
    }
    
    .register-subtitle {
        font-size: 16px;
        color: #7f8c8d;
    }
    
    .register-form {
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
    
    .photo-upload-container {
        display: flex;
        flex-direction: column;
        gap: 10px;
    }
    
    .photo-preview {
        width: 150px;
        height: 150px;
        border-radius: 50%;
        border: 3px dashed #ddd;
        display: flex;
        flex-direction: column;
        align-items: center;
        justify-content: center;
        overflow: hidden;
        background: #f8f9fa;
        margin: 0 auto;
        position: relative;
    }
    
    .photo-preview i {
        font-size: 60px;
        color: #ccc;
        margin-bottom: 10px;
    }
    
    .photo-preview p {
        font-size: 12px;
        color: #999;
        margin: 0;
    }
    
    .photo-preview img {
        width: 100%;
        height: 100%;
        object-fit: cover;
        border-radius: 50%;
    }
    
    .photo-preview.has-image {
        border-style: solid;
        border-color: #667eea;
    }
    
    .btn-address-search {
        padding: 12px 20px;
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        color: white;
        border: none;
        border-radius: 10px;
        font-size: 14px;
        font-weight: 600;
        cursor: pointer;
        transition: all 0.3s ease;
        white-space: nowrap;
        box-shadow: 0 4px 12px rgba(102, 126, 234, 0.3);
    }
    
    .btn-address-search:hover {
        transform: translateY(-2px);
        box-shadow: 0 6px 16px rgba(102, 126, 234, 0.5);
    }
    
    .btn-address-search i {
        margin-right: 5px;
    }
</style>

<div class="register-container">
    <div class="register-header">
        <h1 class="register-title">돌봄 대상자 등록</h1>
        <p class="register-subtitle">돌봄 대상자의 정보를 입력해주세요</p>
    </div>
    
    <c:if test="${not empty error}">
        <div class="error-message">
            <i class="bi bi-exclamation-triangle"></i> ${error}
        </div>
    </c:if>
    
    <form class="register-form" method="post" action="<c:url value='/recipient/register'/>" enctype="multipart/form-data">
        
        <!-- 기본 정보 -->
        <div class="form-section">
            <h3 class="section-title">
                <i class="bi bi-person-badge"></i> 기본 정보
            </h3>
            
            <div class="form-group">
                <label class="form-label">
                    이름<span class="required">*</span>
                </label>
                <input type="text" name="recName" class="form-input" required placeholder="돌봄 대상자의 이름을 입력하세요">
            </div>
            
            <div class="form-group">
                <label class="form-label">
                    프로필 사진
                </label>
                <div class="photo-upload-container">
                    <div class="photo-preview" id="photoPreview">
                        <i class="bi bi-person-circle"></i>
                        <p>사진을 선택하세요</p>
                    </div>
                    <input type="file" name="recPhotoUrl" id="photoInput" class="form-input" 
                           accept="image/jpeg,image/jpg,image/png,image/gif"
                           onchange="previewPhoto(event)">
                    <small style="color: #999; font-size: 12px; display: block; margin-top: 5px;">
                        * JPG, JPEG, PNG, GIF 파일만 가능합니다
                    </small>
                </div>
            </div>
            
            <div class="form-group">
                <label class="form-label">
                    대상자 유형<span class="required">*</span>
                </label>
                <select name="recTypeCode" class="form-input" required>
                    <option value="">선택하세요</option>
                    <option value="ELDERLY">노인/고령자</option>
                    <option value="PREGNANT">임산부</option>
                    <option value="DISABLED">장애인</option>
                </select>
            </div>
            
            <div class="form-group">
                <label class="form-label">
                    생년월일<span class="required">*</span>
                </label>
                <input type="date" name="recBirthday" class="form-input" required>
            </div>
            
            <div class="form-group">
                <label class="form-label">
                    성별<span class="required">*</span>
                </label>
                <div class="radio-group">
                    <label class="radio-label">
                        <input type="radio" name="recGender" value="M" required>
                        <span>남성</span>
                    </label>
                    <label class="radio-label">
                        <input type="radio" name="recGender" value="F" required>
                        <span>여성</span>
                    </label>
                </div>
            </div>
            
            <div class="form-group">
                <label class="form-label">
                    주소<span class="required">*</span>
                </label>
                <div style="display: flex; gap: 10px; margin-bottom: 10px;">
                    <input type="text" id="postcode" class="form-input" placeholder="우편번호" readonly style="flex: 0 0 150px;">
                    <button type="button" onclick="execDaumPostcode()" class="btn-address-search">
                        <i class="bi bi-search"></i> 주소 검색
                    </button>
                </div>
                <input type="text" id="roadAddress" class="form-input" placeholder="도로명 주소" readonly style="margin-bottom: 10px; background-color: #f8f9fa;">
                <input type="text" id="jibunAddress" name="recAddress" class="form-input" required placeholder="지번 주소" readonly style="margin-bottom: 10px;">
                <input type="text" id="detailAddress" class="form-input" placeholder="상세 주소 (선택사항)">
                <small style="color: #667eea; font-size: 12px; display: block; margin-top: 5px;">
                    <i class="bi bi-info-circle"></i> 주소 검색 버튼을 눌러 지번 주소를 선택해주세요
                </small>
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
                <textarea name="recMedHistory" class="form-input form-textarea" placeholder="기존 질병이나 수술 이력 등을 입력하세요"></textarea>
            </div>
            
            <div class="form-group">
                <label class="form-label">
                    알레르기 (Allergies)
                </label>
                <textarea name="recAllergies" class="form-input form-textarea" placeholder="약물, 음식 알레르기 등을 입력하세요"></textarea>
            </div>
            
            <div class="form-group">
                <label class="form-label">
                    건강 요구사항 (Health Needs)
                </label>
                <textarea name="recHealthNeeds" class="form-input form-textarea" placeholder="특별한 건강 관리 요구사항을 입력하세요"></textarea>
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
                <textarea name="recSpecNotes" class="form-input form-textarea" placeholder="기타 특이사항이나 주의사항을 입력하세요"></textarea>
            </div>
        </div>
        
        <!-- 버튼 -->
        <div class="form-buttons">
            <button type="button" class="btn btn-secondary" onclick="history.back()">
                <i class="bi bi-x-circle"></i> 취소
            </button>
            <button type="submit" class="btn btn-primary">
                <i class="bi bi-check-circle"></i> 등록하기
            </button>
        </div>
    </form>
</div>

<script>
    // 사진 미리보기
    function previewPhoto(event) {
        const file = event.target.files[0];
        const preview = document.getElementById('photoPreview');
        
        if (file) {
            // 파일 크기 체크 (5MB)
            if (file.size > 5 * 1024 * 1024) {
                alert('파일 크기는 5MB 이하여야 합니다.');
                event.target.value = '';
                return;
            }
            
            // 이미지 파일인지 확인
            if (!file.type.match('image.*')) {
                alert('이미지 파일만 업로드 가능합니다.');
                event.target.value = '';
                return;
            }
            
            const reader = new FileReader();
            reader.onload = function(e) {
                preview.innerHTML = '<img src="' + e.target.result + '" alt="Preview">';
                preview.classList.add('has-image');
            };
            reader.readAsDataURL(file);
        }
    }
    
    // 폼 유효성 검사
    document.querySelector('.register-form').addEventListener('submit', function(e) {
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
    });
    
    // Daum 주소 API
    function execDaumPostcode() {
        new daum.Postcode({
            oncomplete: function(data) {
                // 팝업에서 검색결과 항목을 클릭했을때 실행할 코드

                // 각 주소의 노출 규칙에 따라 주소를 조합한다.
                var roadAddr = data.roadAddress; // 도로명 주소
                var jibunAddr = data.jibunAddress; // 지번 주소
                
                // 우편번호와 주소 정보를 해당 필드에 넣는다.
                document.getElementById('postcode').value = data.zonecode;
                document.getElementById('roadAddress').value = roadAddr;
                document.getElementById('jibunAddress').value = jibunAddr; // 지번 주소를 메인으로 설정
                
                // 상세주소 입력란에 포커스
                document.getElementById('detailAddress').focus();
                
                // 지번 주소가 있으면 표시, 없으면 도로명 주소 사용
                if (!jibunAddr) {
                    document.getElementById('jibunAddress').value = roadAddr;
                }
            }
        }).open();
    }
</script>

<!-- Daum 우편번호 API -->
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>

