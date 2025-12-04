<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<link rel="stylesheet" href="<c:url value='/css/mealplan.css'/>" />

<style>
    /* ---------------------------------------------------- */
    /* 1. 디자인 시스템 (center.jsp 통일) */
    /* ---------------------------------------------------- */
    :root {
        --primary-color: #3498db;   /* 메인 블루 */
        --secondary-color: #343a40; /* 진한 회색 텍스트 */
        --secondary-bg: #F0F8FF;    /* 연한 배경색 (입력창 등) */
        --card-bg: white;
        --danger-color: #e74c3c;
        --success-color: #2ecc71;
    }

    body {
        background-color: #f8f9fa;
        font-family: 'Noto Sans KR', sans-serif;
    }

    /* ---------------------------------------------------- */
    /* 2. 레이아웃 & 컨테이너 */
    /* ---------------------------------------------------- */
    .edit-container {
        max-width: 800px;
        margin: 0 auto;
        padding: 40px 20px 100px 20px;
    }

    .edit-header {
        text-align: center;
        margin-bottom: 40px;
    }

    .edit-title {
        font-size: 38px;
        font-weight: 800;
        color: var(--secondary-color);
        margin-bottom: 10px;
        text-shadow: 0 1px 2px rgba(0, 0, 0, 0.05);
    }

    .edit-subtitle {
        font-size: 16px;
        color: #7f8c8d;
    }

    /* ---------------------------------------------------- */
    /* 3. 폼 카드 스타일 */
    /* ---------------------------------------------------- */
    .edit-form {
        background: var(--card-bg);
        border-radius: 20px;
        padding: 40px;
        box-shadow: 0 10px 30px rgba(0,0,0,0.05);
    }

    .form-section {
        margin-bottom: 40px;
    }

    .section-title {
        font-size: 20px;
        font-weight: 700;
        color: var(--secondary-color);
        margin-bottom: 25px;
        padding-bottom: 10px;
        border-bottom: 2px solid #f0f0f0;
        display: flex;
        align-items: center;
        gap: 10px;
    }

    .section-title i {
        color: var(--primary-color);
        font-size: 22px;
    }

    /* ---------------------------------------------------- */
    /* 4. 입력 필드 스타일 */
    /* ---------------------------------------------------- */
    .form-group {
        margin-bottom: 25px;
    }

    .form-label {
        display: block;
        font-size: 14px;
        font-weight: 700;
        color: var(--secondary-color);
        margin-bottom: 8px;
    }

    .required {
        color: var(--danger-color);
        margin-left: 4px;
    }

    .form-input, select.form-input {
        width: 100%;
        padding: 12px 15px;
        background: var(--secondary-bg);
        border: 1px solid transparent;
        border-radius: 12px;
        font-size: 15px;
        transition: all 0.3s ease;
        color: var(--secondary-color);
        box-sizing: border-box; /* 패딩 포함 너비 계산 */
    }

    .form-input:focus {
        outline: none;
        background: white;
        border-color: var(--primary-color);
        box-shadow: 0 0 0 3px rgba(52, 152, 219, 0.1);
    }

    .form-textarea {
        min-height: 120px;
        resize: vertical;
        line-height: 1.6;
    }

    /* 라디오 버튼 스타일 */
    .radio-group {
        display: flex;
        gap: 20px;
        background: var(--secondary-bg);
        padding: 15px;
        border-radius: 12px;
    }

    .radio-label {
        display: flex;
        align-items: center;
        cursor: pointer;
        font-weight: 500;
    }

    .radio-label input[type="radio"] {
        margin-right: 8px;
        width: 18px;
        height: 18px;
        cursor: pointer;
        accent-color: var(--primary-color);
    }

    /* ---------------------------------------------------- */
    /* 5. 사진 업로드 스타일 */
    /* ---------------------------------------------------- */
    .photo-upload-container {
        display: flex;
        flex-direction: column;
        align-items: center;
        gap: 15px;
        padding: 20px;
        background: var(--secondary-bg);
        border-radius: 15px;
    }

    .photo-preview {
        width: 150px;
        height: 150px;
        border-radius: 50%;
        border: 4px dashed #cbd5e0;
        display: flex;
        flex-direction: column;
        align-items: center;
        justify-content: center;
        overflow: hidden;
        background: white;
        position: relative;
        transition: all 0.3s ease;
    }

    .photo-preview.has-image {
        border: 4px solid var(--primary-color);
    }

    .photo-preview i {
        font-size: 50px;
        color: #cbd5e0;
        margin-bottom: 5px;
    }

    .photo-preview p {
        font-size: 12px;
        color: #a0aec0;
        margin: 0;
    }

    .photo-preview img {
        width: 100%;
        height: 100%;
        object-fit: cover;
    }

    /* 파일 인풋 커스텀 */
    input[type="file"] {
        padding: 10px;
        background: white;
    }

    /* ---------------------------------------------------- */
    /* 6. 주소 검색 버튼 */
    /* ---------------------------------------------------- */
    .btn-address-search {
        padding: 12px 20px;
        background: var(--primary-color);
        color: white;
        border: none;
        border-radius: 12px;
        font-size: 14px;
        font-weight: 600;
        cursor: pointer;
        transition: all 0.3s ease;
        white-space: nowrap;
        box-shadow: 0 4px 10px rgba(52, 152, 219, 0.3);
    }

    .btn-address-search:hover {
        background: #2980b9;
        transform: translateY(-2px);
    }

    /* ---------------------------------------------------- */
    /* 7. 체크박스 그룹 스타일 */
    /* ---------------------------------------------------- */
    .checkbox-group {
        background: var(--secondary-bg); /* 연한 배경 */
        border-radius: 15px;
        padding: 20px;
        margin-bottom: 10px;
    }

    .checkbox-section-title {
        font-size: 14px;
        font-weight: 700;
        color: var(--primary-color);
        margin-bottom: 15px;
        display: block;
    }

    .checkbox-section-subtitle {
        font-size: 13px;
        color: #7f8c8d;
        margin-bottom: 15px;
        display: block;
    }

    .checkbox-item {
        display: flex;
        align-items: center;
        padding: 12px 15px;
        margin-bottom: 8px;
        background: white;
        border-radius: 10px;
        cursor: pointer;
        transition: all 0.2s ease;
        border: 1px solid transparent;
        box-shadow: 0 2px 5px rgba(0,0,0,0.02);
    }

    .checkbox-item:hover {
        border-color: var(--primary-color);
        transform: translateX(3px);
        box-shadow: 0 4px 10px rgba(0,0,0,0.05);
    }

    .checkbox-item input[type="checkbox"] {
        width: 18px;
        height: 18px;
        margin-right: 12px;
        cursor: pointer;
        accent-color: var(--primary-color);
    }

    .checkbox-item label {
        cursor: pointer;
        flex: 1;
        font-size: 14px;
        color: var(--secondary-color);
        margin: 0;
        font-weight: 500;
    }

    /* 기타 입력 필드 */
    .other-input-wrapper {
        margin-top: 10px;
        padding-top: 10px;
        border-top: 1px dashed #cbd5e0;
    }

    .other-input {
        width: 100%;
        padding: 12px;
        border: 2px solid #e2e8f0;
        border-radius: 10px;
        font-size: 14px;
        margin-top: 5px;
        display: none;
    }

    .other-input:focus {
        outline: none;
        border-color: var(--primary-color);
    }

    .other-input.show {
        display: block;
    }

    /* ---------------------------------------------------- */
    /* 8. 하단 버튼 및 기타 요소 */
    /* ---------------------------------------------------- */
    .form-buttons {
        display: flex;
        gap: 15px;
        justify-content: center;
        margin-top: 50px;
        padding-top: 30px;
        border-top: 2px solid #f0f0f0;
    }

    .btn {
        padding: 14px 35px;
        border: none;
        border-radius: 50px;
        font-size: 16px;
        font-weight: 700;
        cursor: pointer;
        transition: all 0.3s ease;
        display: inline-flex;
        align-items: center;
        gap: 8px;
    }

    .btn-primary {
        background: var(--primary-color);
        color: white;
        box-shadow: 0 4px 15px rgba(52, 152, 219, 0.4);
    }

    .btn-primary:hover {
        background: #2980b9;
        transform: translateY(-2px);
        box-shadow: 0 6px 20px rgba(52, 152, 219, 0.6);
    }

    .btn-secondary {
        background: #e9ecef;
        color: #495057;
    }

    .btn-secondary:hover {
        background: #ced4da;
        transform: translateY(-2px);
    }

    .error-message {
        background: #fff5f5;
        color: var(--danger-color);
        padding: 15px;
        border-radius: 12px;
        margin-bottom: 25px;
        text-align: center;
        border: 1px solid #fed7d7;
        font-weight: 600;
    }

    .info-banner {
        background: #e3f2fd;
        color: #1976d2;
        padding: 20px;
        border-radius: 15px;
        margin-bottom: 30px;
        display: flex;
        align-items: center;
        gap: 15px;
        border-left: 5px solid #1976d2;
    }

        .info-banner i {

            font-size: 28px;

        }

    </style>

<div class="edit-container">
    <div class="edit-header">
        <h1 class="edit-title">돌봄 대상자 정보 수정</h1>
        <p class="edit-subtitle">${recipient.recName}님의 정보를 수정합니다</p>
    </div>

    <c:if test="${not empty error}">
        <div class="error-message">
            <i class="bi bi-exclamation-triangle-fill"></i> ${error}
        </div>
    </c:if>

    <div class="info-banner">
        <i class="bi bi-info-circle-fill"></i>
        <div>
            <strong>등록번호 #${recipient.recId}</strong><br>
            <c:if test="${recipient.recRegdate != null}">
                <small style="opacity: 0.8;">등록일: ${recipient.recRegdate.toLocalDate()} ${String.format('%02d:%02d', recipient.recRegdate.hour, recipient.recRegdate.minute)}</small>
            </c:if>
        </div>
    </div>

    <form class="edit-form" method="post" action="<c:url value='/recipient/edit'/>" enctype="multipart/form-data">
        <input type="hidden" name="recId" value="${recipient.recId}">

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
                    프로필 사진
                </label>
                <div class="photo-upload-container">
                    <div class="photo-preview ${not empty recipient.recPhotoUrl ? 'has-image' : ''}" id="photoPreview">
                        <c:choose>
                            <c:when test="${not empty recipient.recPhotoUrl}">
                                <img src="<c:url value='${recipient.recPhotoUrl}'/>" alt="Current Photo">
                            </c:when>
                            <c:otherwise>
                                <i class="bi bi-person-circle"></i>
                                <p>사진을 선택하세요</p>
                            </c:otherwise>
                        </c:choose>
                    </div>
                    <input type="file" name="recPhotoUrl" id="photoInput" class="form-input"
                           accept="image/jpeg,image/jpg,image/png,image/gif"
                           onchange="previewPhoto(event)" style="border: 1px solid #ddd;">
                    <small style="color: #7f8c8d; font-size: 13px; text-align: center;">
                        <i class="bi bi-info-circle"></i> 새 사진을 선택하면 기존 사진이 교체됩니다
                    </small>
                </div>
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
                <div style="display: flex; gap: 10px; margin-bottom: 10px;">
                    <input type="text" id="postcode" class="form-input" placeholder="우편번호" readonly style="flex: 0 0 150px; background-color: #eee;">
                    <button type="button" onclick="execDaumPostcode()" class="btn-address-search">
                        <i class="bi bi-search"></i> 주소 검색
                    </button>
                </div>
                <input type="text" id="roadAddress" class="form-input" placeholder="도로명 주소" readonly style="margin-bottom: 10px; background-color: #eee;">
                <input type="text" id="jibunAddress" name="recAddress" class="form-input" required placeholder="지번 주소" readonly style="margin-bottom: 10px; font-weight: 600;"
                       value="${recipient.recAddress}">
                <input type="text" id="detailAddress" class="form-input" placeholder="상세 주소 (선택사항)">
            </div>
        </div>

        <div class="form-section">
            <h3 class="section-title">
                <i class="bi bi-heart-pulse"></i> 건강 정보
            </h3>

            <div class="form-group">
                <label class="form-label">
                    현재 앓고 계신 질환이 있으신가요? (병력)
                </label>
                <div class="checkbox-group">
                    <span class="checkbox-section-title">해당하는 곳에 모두 체크해 주세요.</span>
                    <div class="checkbox-item">
                        <input type="checkbox" id="medHistory_hypertension" value="고혈압" onchange="updateMedHistory()">
                        <label for="medHistory_hypertension">고혈압</label>
                    </div>
                    <div class="checkbox-item">
                        <input type="checkbox" id="medHistory_diabetes" value="당뇨" onchange="updateMedHistory()">
                        <label for="medHistory_diabetes">당뇨</label>
                    </div>
                    <div class="checkbox-item">
                        <input type="checkbox" id="medHistory_heart" value="심장 질환 (부정맥 등)" onchange="updateMedHistory()">
                        <label for="medHistory_heart">심장 질환 (부정맥 등)</label>
                    </div>
                    <div class="checkbox-item">
                        <input type="checkbox" id="medHistory_respiratory" value="호흡기 질환 (천식 등)" onchange="updateMedHistory()">
                        <label for="medHistory_respiratory">호흡기 질환 (천식 등)</label>
                    </div>
                    <div class="checkbox-item">
                        <input type="checkbox" id="medHistory_joint" value="관절염 / 허리 디스크" onchange="updateMedHistory()">
                        <label for="medHistory_joint">관절염 / 허리 디스크</label>
                    </div>
                    <div class="checkbox-item">
                        <input type="checkbox" id="medHistory_none" value="해당 사항 없음" onchange="updateMedHistory()">
                        <label for="medHistory_none">해당 사항 없음</label>
                    </div>
                    <div class="checkbox-item">
                        <input type="checkbox" id="medHistory_other" onchange="toggleOtherInput('medHistory')">
                        <label for="medHistory_other">그외의 항목 입력하기</label>
                    </div>
                    <div class="other-input-wrapper">
                        <input type="text" id="medHistory_other_input" class="other-input"
                               placeholder="기타 질환을 입력하세요" onchange="updateMedHistory()">
                    </div>
                </div>
                <textarea name="recMedHistory" id="recMedHistory" class="form-input form-textarea"
                          placeholder="선택한 항목이 자동으로 입력됩니다" style="margin-top: 10px; background-color: #f1f3f5;" readonly>${recipient.recMedHistory}</textarea>
            </div>

            <div class="form-group">
                <label class="form-label">
                    주의해야 할 알레르기가 있으신가요?
                </label>
                <div class="checkbox-group">
                    <span class="checkbox-section-subtitle">약물이나 음식에 민감하시다면 체크해 주세요.</span>
                    <div class="checkbox-item">
                        <input type="checkbox" id="allergy_antibiotic" value="항생제 알레르기" onchange="updateAllergies()">
                        <label for="allergy_antibiotic">항생제 알레르기</label>
                    </div>
                    <div class="checkbox-item">
                        <input type="checkbox" id="allergy_painkiller" value="진통제/해열제 알레르기" onchange="updateAllergies()">
                        <label for="allergy_painkiller">진통제/해열제 알레르기</label>
                    </div>
                    <div class="checkbox-item">
                        <input type="checkbox" id="allergy_food" value="특정 음식 알레르기 (계란, 우유, 땅콩 등)" onchange="updateAllergies()">
                        <label for="allergy_food">특정 음식 알레르기 (계란, 우유, 땅콩 등)</label>
                    </div>
                    <div class="checkbox-item">
                        <input type="checkbox" id="allergy_other_type" value="기타 알레르기" onchange="updateAllergies()">
                        <label for="allergy_other_type">기타 알레르기</label>
                    </div>
                    <div class="checkbox-item">
                        <input type="checkbox" id="allergy_none" value="해당 사항 없음" onchange="updateAllergies()">
                        <label for="allergy_none">해당 사항 없음</label>
                    </div>
                    <div class="checkbox-item">
                        <input type="checkbox" id="allergy_other" onchange="toggleOtherInput('allergy')">
                        <label for="allergy_other">그외의 항목을 입력하기</label>
                    </div>
                    <div class="other-input-wrapper">
                        <input type="text" id="allergy_other_input" class="other-input"
                               placeholder="기타 알레르기를 입력하세요" onchange="updateAllergies()">
                    </div>
                </div>
                <textarea name="recAllergies" id="recAllergies" class="form-input form-textarea"
                          placeholder="선택한 항목이 자동으로 입력됩니다" style="margin-top: 10px; background-color: #f1f3f5;" readonly>${recipient.recAllergies}</textarea>
            </div>

            <div class="form-group">
                <label class="form-label">
                    특별히 도움이 필요하신 부분이 있나요? (건강 요구사항)
                </label>
                <div class="checkbox-group">
                    <span class="checkbox-section-subtitle">저희가 미리 준비할 수 있도록 알려주세요.</span>
                    <div class="checkbox-item">
                        <input type="checkbox" id="healthNeed_pregnant" value="임산부입니다. (안정이 필요합니다)" onchange="updateHealthNeeds()">
                        <label for="healthNeed_pregnant">임산부입니다. (안정이 필요합니다)</label>
                    </div>
                    <div class="checkbox-item">
                        <input type="checkbox" id="healthNeed_wheelchair" value="휠체어를 사용합니다. (경사로/엘리베이터 필요)" onchange="updateHealthNeeds()">
                        <label for="healthNeed_wheelchair">휠체어를 사용합니다. (경사로/엘리베이터 필요)</label>
                    </div>
                    <div class="checkbox-item">
                        <input type="checkbox" id="healthNeed_mobility" value="거동이 불편하여 부축이나 지팡이가 필요합니다" onchange="updateHealthNeeds()">
                        <label for="healthNeed_mobility">거동이 불편하여 부축이나 지팡이가 필요합니다</label>
                    </div>
                    <div class="checkbox-item">
                        <input type="checkbox" id="healthNeed_sensory" value="시각/청각에 불편함이 있어 안내가 필요합니다" onchange="updateHealthNeeds()">
                        <label for="healthNeed_sensory">시각/청각에 불편함이 있어 안내가 필요합니다</label>
                    </div>
                    <div class="checkbox-item">
                        <input type="checkbox" id="healthNeed_ok" value="괜찮습니다. 스스로 이동 가능합니다" onchange="updateHealthNeeds()">
                        <label for="healthNeed_ok">괜찮습니다. 스스로 이동 가능합니다</label>
                    </div>
                    <div class="checkbox-item">
                        <input type="checkbox" id="healthNeed_other" onchange="toggleOtherInput('healthNeed')">
                        <label for="healthNeed_other">그외의 항목을 입력하기</label>
                    </div>
                    <div class="other-input-wrapper">
                        <input type="text" id="healthNeed_other_input" class="other-input"
                               placeholder="기타 건강 요구사항을 입력하세요" onchange="updateHealthNeeds()">
                    </div>
                </div>
                <textarea name="recHealthNeeds" id="recHealthNeeds" class="form-input form-textarea"
                          placeholder="선택한 항목이 자동으로 입력됩니다" style="margin-top: 10px; background-color: #f1f3f5;" readonly>${recipient.recHealthNeeds}</textarea>
            </div>
        </div>

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

    // 체크박스 "그외의 항목 입력하기" 토글
    function toggleOtherInput(type) {
        const checkbox = document.getElementById(type + '_other');
        const input = document.getElementById(type + '_other_input');

        if (checkbox.checked) {
            input.classList.add('show');
            input.focus();
        } else {
            input.classList.remove('show');
            input.value = '';
            if (type === 'medHistory') {
                updateMedHistory();
            } else if (type === 'allergy') {
                updateAllergies();
            } else if (type === 'healthNeed') {
                updateHealthNeeds();
            }
        }
    }

    // 병력 업데이트
    function updateMedHistory() {
        const checkboxes = document.querySelectorAll('input[id^="medHistory_"]:not([id="medHistory_other"]):not([id="medHistory_other_input"])');
        const otherInput = document.getElementById('medHistory_other_input');
        const textarea = document.getElementById('recMedHistory');
        const selected = [];
        checkboxes.forEach(cb => {
            if (cb.checked && cb.id !== 'medHistory_none') {
                selected.push(cb.value);
            }
        });
        // "해당 사항 없음"이 체크되면 다른 항목들 해제
        const noneCheckbox = document.getElementById('medHistory_none');
        if (noneCheckbox.checked) {
            checkboxes.forEach(cb => {
                if (cb.id !== 'medHistory_none' && cb.id !== 'medHistory_other') {
                    cb.checked = false;
                }
            });
            document.getElementById('medHistory_other').checked = false;
            otherInput.classList.remove('show');
            otherInput.value = '';
            textarea.value = '해당 사항 없음';
            return;
        }

        // 기타 항목 입력 추가
        if (document.getElementById('medHistory_other').checked && otherInput.value.trim()) {
            selected.push(otherInput.value.trim());
        }

        textarea.value = selected.join(', ');
    }

    // 알레르기 업데이트
    function updateAllergies() {
        const checkboxes = document.querySelectorAll('input[id^="allergy_"]:not([id="allergy_other"]):not([id="allergy_other_input"])');
        const otherInput = document.getElementById('allergy_other_input');
        const textarea = document.getElementById('recAllergies');
        const selected = [];
        checkboxes.forEach(cb => {
            if (cb.checked && cb.id !== 'allergy_none') {
                selected.push(cb.value);
            }
        });
        // "해당 사항 없음"이 체크되면 다른 항목들 해제
        const noneCheckbox = document.getElementById('allergy_none');
        if (noneCheckbox.checked) {
            checkboxes.forEach(cb => {
                if (cb.id !== 'allergy_none' && cb.id !== 'allergy_other') {
                    cb.checked = false;
                }
            });
            document.getElementById('allergy_other').checked = false;
            otherInput.classList.remove('show');
            otherInput.value = '';
            textarea.value = '해당 사항 없음';
            return;
        }

        // 기타 항목 입력 추가
        if (document.getElementById('allergy_other').checked && otherInput.value.trim()) {
            selected.push(otherInput.value.trim());
        }

        textarea.value = selected.join(', ');
    }

    // 건강 요구사항 업데이트
    function updateHealthNeeds() {
        const checkboxes = document.querySelectorAll('input[id^="healthNeed_"]:not([id="healthNeed_other"]):not([id="healthNeed_other_input"])');
        const otherInput = document.getElementById('healthNeed_other_input');
        const textarea = document.getElementById('recHealthNeeds');
        const selected = [];
        checkboxes.forEach(cb => {
            if (cb.checked && cb.id !== 'healthNeed_ok') {
                selected.push(cb.value);
            }
        });
        // "괜찮습니다"가 체크되면 다른 항목들 해제
        const okCheckbox = document.getElementById('healthNeed_ok');
        if (okCheckbox.checked) {
            checkboxes.forEach(cb => {
                if (cb.id !== 'healthNeed_ok' && cb.id !== 'healthNeed_other') {
                    cb.checked = false;
                }
            });
            document.getElementById('healthNeed_other').checked = false;
            otherInput.classList.remove('show');
            otherInput.value = '';
            textarea.value = '괜찮습니다. 스스로 이동 가능합니다';
            return;
        }

        // 기타 항목 입력 추가
        if (document.getElementById('healthNeed_other').checked && otherInput.value.trim()) {
            selected.push(otherInput.value.trim());
        }

        textarea.value = selected.join(', ');
    }

    // 페이지 로드 시 기존 데이터를 체크박스에 반영
    document.addEventListener('DOMContentLoaded', function() {
        // 병력 데이터 파싱 및 체크
        const medHistoryText = document.getElementById('recMedHistory').value.trim();
        if (medHistoryText) {
            parseAndCheckHealthData(medHistoryText, 'medHistory');
        }

        // 알레르기 데이터 파싱 및 체크
        const allergiesText = document.getElementById('recAllergies').value.trim();
        if (allergiesText) {
            parseAndCheckHealthData(allergiesText, 'allergy');
        }

        // 건강 요구사항 데이터 파싱 및 체크
        const healthNeedsText = document.getElementById('recHealthNeeds').value.trim();
        if (healthNeedsText) {
            parseAndCheckHealthData(healthNeedsText, 'healthNeed');
        }


        // --- PDF/Image Drag and Drop & AI Analysis Logic ---
        const dropArea = document.getElementById('pdfDropArea');
        const fileInput = document.getElementById('pdfFileInput');
        const fileList = document.getElementById('pdfFileList');
        const analyzeBtn = document.getElementById('aiAnalyzePdfBtn');
        let uploadedFiles = [];

        if (dropArea && fileInput && fileList && analyzeBtn) {
            // Helper function to prevent default behavior
            const preventDefaults = (e) => {
                e.preventDefault();
                e.stopPropagation();
            };

            // Trigger file input on click
            dropArea.addEventListener('click', () => {
                fileInput.click();
            });
            
            // Add drag event listeners
            ['dragenter', 'dragover', 'dragleave', 'drop'].forEach(eventName => {
                dropArea.addEventListener(eventName, preventDefaults, false);
            });

            ['dragenter', 'dragover'].forEach(eventName => {
                dropArea.addEventListener(eventName, () => dropArea.classList.add('highlight'), false);
            });

            ['dragleave', 'drop'].forEach(eventName => {
                dropArea.addEventListener(eventName, () => dropArea.classList.remove('highlight'), false);
            });

            // Handle dropped files
            dropArea.addEventListener('drop', (e) => {
                handleFiles(e.dataTransfer.files);
            }, false);

            // Handle file selection from input
            fileInput.addEventListener('change', (e) => {
                handleFiles(e.target.files);
                e.target.value = ''; // Reset input to allow re-uploading the same file
            });

            // Central function to process files
            function handleFiles(files) {
                for (const file of files) {
                    if (file.type.startsWith('image/') || file.type === 'application/pdf') {
                        uploadedFiles.push(file);
                        renderFile(file);
                    } else {
                        alert('이미지 또는 PDF 파일만 업로드할 수 있습니다.');
                    }
                }
            }
            
            function renderFile(file) {
                const listItem = document.createElement('li');
                
                const leftDiv = document.createElement('div');
                leftDiv.style.display = 'flex';
                leftDiv.style.alignItems = 'center';
                leftDiv.style.gap = '10px';

                if (file.type.startsWith('image/')) {
                    const img = document.createElement('img');
                    img.src = URL.createObjectURL(file);
                    img.className = 'file-preview-img';
                    leftDiv.appendChild(img);
                } else {
                    const pdfIcon = document.createElement('i');
                    pdfIcon.className = 'bi bi-file-earmark-pdf-fill file-preview-icon';
                    leftDiv.appendChild(pdfIcon);
                }
                
                const fileInfo = document.createElement('span');
                const fileSizeMB = (file.size / 1024 / 1024).toFixed(2);
                fileInfo.textContent = `${file.name} (${fileSizeMB} MB)`;
                leftDiv.appendChild(fileInfo);
                
                listItem.appendChild(leftDiv);

                const removeBtn = document.createElement('i');
                removeBtn.className = 'bi bi-x-circle-fill file-remove-btn';
                removeBtn.title = '파일 제거';
                removeBtn.onclick = (e) => {
                    e.stopPropagation();
                    // Remove file from array
                    uploadedFiles = uploadedFiles.filter(f => f.name !== file.name);
                    
                    const preview = listItem.querySelector('.file-preview-img');
                    if (preview) {
                        URL.revokeObjectURL(preview.src);
                    }
                    listItem.remove();
                };
                listItem.appendChild(removeBtn);

                fileList.appendChild(listItem);
            }

            // --- AI Analysis Button Click Handler ---
            analyzeBtn.addEventListener('click', async () => {
                if (uploadedFiles.length === 0) {
                    alert('분석할 파일을 먼저 추가해주세요.');
                    return;
                }

                // Show loading state
                analyzeBtn.disabled = true;
                analyzeBtn.innerHTML = '<span class="spinner-border spinner-border-sm" role="status" aria-hidden="true"></span> 분석 중...';

                // Create FormData
                const formData = new FormData();
                uploadedFiles.forEach(file => {
                    formData.append('files', file);
                });

                try {
                    const response = await fetch('/api/ai/analyze-document', {
                        method: 'POST',
                        body: formData
                    });

                    if (!response.ok) {
                        const errorData = await response.json();
                        throw new Error(errorData.error || '서버 오류가 발생했습니다.');
                    }
                    
                    const result = await response.json();
                    displayAnalysisResult(result.analysis_result);

                } catch (error) {
                    alert(`분석 실패: ${error.message}`);
                    console.error('AI Analysis Error:', error);
                } finally {
                    // Restore button state
                    analyzeBtn.disabled = false;
                    analyzeBtn.innerHTML = '<i class="bi bi-cpu"></i> AI 분석';
                }
            });

            function displayAnalysisResult(resultText) {
                // Remove existing result area if any
                const existingResult = document.getElementById('aiResultArea');
                if (existingResult) {
                    existingResult.remove();
                }

                const resultArea = document.createElement('div');
                resultArea.id = 'aiResultArea';
                resultArea.style.marginTop = '15px';
                resultArea.style.padding = '15px';
                resultArea.style.backgroundColor = '#e6f7ff';
                resultArea.style.border = '1px solid #91d5ff';
                resultArea.style.borderRadius = '8px';

                const title = document.createElement('h5');
                title.innerHTML = '<i class="bi bi-lightbulb"></i> AI 분석 결과';
                title.style.marginBottom = '10px';
                title.style.color = '#0056b3';

                const resultPre = document.createElement('pre');
                resultPre.textContent = resultText;
                resultPre.style.whiteSpace = 'pre-wrap';
                resultPre.style.fontFamily = 'inherit';
                resultPre.style.fontSize = '14px';
                resultPre.style.margin = '0';
                resultPre.style.padding = '10px';
                resultPre.style.backgroundColor = 'white';
                resultPre.style.borderRadius = '5px';
                
                const saveBtn = document.createElement('button');
                saveBtn.type = 'button';
                saveBtn.textContent = '특이사항에 저장';
                saveBtn.className = 'btn btn-primary';
                saveBtn.style.marginTop = '15px';
                saveBtn.style.width = '100%';

                saveBtn.onclick = () => {
                    const specNotesTextarea = document.getElementById('recSpecNotes');
                    const currentNotes = specNotesTextarea.value.trim();
                    const separator = currentNotes ? '\n\n' : '';
                    specNotesTextarea.value = currentNotes + separator + "--- AI 분석 결과 ---\n" + resultText;
                    alert('특이사항에 분석 결과가 추가되었습니다.');
                    resultArea.remove(); // Remove result area after saving
                };

                resultArea.appendChild(title);
                resultArea.appendChild(resultPre);
                resultArea.appendChild(saveBtn);

                // Insert the result area after the analyze button
                analyzeBtn.parentNode.insertBefore(resultArea, analyzeBtn.nextSibling);
            }
        }
    });

    // 저장된 텍스트 데이터를 파싱하여 체크박스에 반영
    function parseAndCheckHealthData(text, type) {
        if (!text || text.trim() === '') return;
        const items = text.split(',').map(item => item.trim());
        const prefix = type === 'medHistory' ? 'medHistory' : (type === 'allergy' ? 'allergy' : 'healthNeed');

        items.forEach(item => {
            // 정확히 일치하는 체크박스 찾기
            const checkboxes = document.querySelectorAll(`input[id^="${prefix}_"]`);
            let found = false;

            checkboxes.forEach(cb => {
                if (cb.value === item && cb.id !== prefix + '_other' && cb.id !== prefix + '_other_input') {
                    cb.checked = true;
                    found = true;
                }
            });

            // 일치하는 체크박스가 없으면 "그외의 항목"으로 처리
            if (!found && item !== '해당 사항 없음' && item !== '괜찮습니다. 스스로 이동 가능합니다') {
                const otherCheckbox = document.getElementById(prefix + '_other');
                const otherInput = document.getElementById(prefix + '_other_input');
                if (otherCheckbox && otherInput) {
                    otherCheckbox.checked = true;
                    otherInput.value = item;
                    otherInput.classList.add('show');
                }
            }
        });
    }
</script>

<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>