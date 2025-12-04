<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<link rel="stylesheet" href="<c:url value='/css/mealplan.css'/>" />

<style>
    /* ---------------------------------------------------- */
    /* 1. 디자인 시스템 (center.jsp와 통일) */
    /* ---------------------------------------------------- */
    :root {
        --primary-color: #3498db;   /* 메인 블루 */
        --secondary-color: #343a40; /* 진한 회색 텍스트 */
        --secondary-bg: #F0F8FF;    /* 연한 배경색 */
        --card-bg: white;
        --danger-color: #e74c3c;
        --success-color: #2ecc71;
        --warning-color: #f1c40f;
    }

    body {
        background-color: #f8f9fa;
    }

    /* ---------------------------------------------------- */
    /* 2. 레이아웃 & 카드 스타일 */
    /* ---------------------------------------------------- */
    .ai-menu-section {
        max-width: 1200px;
        margin: 0 auto;
        padding: 40px 20px 100px 20px;
    }

    /* center.jsp의 카드 스타일 적용 */
    .detail-content-card {
        background: var(--card-bg);
        border-radius: 20px;
        padding: 30px;
        box-shadow: 0 10px 30px rgba(0,0,0,0.05);
        margin-bottom: 30px;
        transition: transform 0.3s ease;
    }

    /* 페이지 헤더 (center.jsp 스타일) */
    .page-header {
        text-align: center;
        margin-bottom: 40px;
    }

    .page-header h1 {
        font-size: 38px;
        font-weight: 800;
        text-shadow: 0 1px 2px rgba(0, 0, 0, 0.05);
        margin-bottom: 10px;
        color: var(--secondary-color);
    }

    .page-header h5 {
        font-size: 16px;
        color: #7f8c8d;
        font-weight: 400;
    }

    /* 섹션 제목 스타일 */
    .section-title {
        font-size: 20px;
        font-weight: 700;
        margin-bottom: 20px;
        color: var(--secondary-color);
        display: flex;
        align-items: center;
        gap: 10px;
    }

    /* ---------------------------------------------------- */
    /* 3. 입력 필드 & 버튼 (center.jsp 스타일) */
    /* ---------------------------------------------------- */
    /* center.jsp의 input 스타일 */
    .form-control {
        width: 100%;
        background: var(--secondary-bg);
        border: 1px solid transparent;
        border-radius: 12px;
        padding: 12px 15px;
        font-size: 15px;
        transition: all 0.3s ease;
        color: var(--secondary-color);
    }

    .form-control:focus {
        background: white;
        outline: none;
        border-color: var(--primary-color);
        box-shadow: 0 0 0 3px rgba(52, 152, 219, 0.1);
    }

    /* center.jsp의 버튼 스타일 */
    .btn-custom {
        padding: 12px 24px;
        border-radius: 50px;
        font-weight: 600;
        border: none;
        display: inline-flex;
        align-items: center;
        justify-content: center;
        gap: 8px;
        cursor: pointer;
        transition: all 0.3s;
        font-size: 15px;
    }

    .btn-primary-custom {
        background: var(--primary-color);
        color: white;
        box-shadow: 0 4px 10px rgba(52, 152, 219, 0.4);
    }
    .btn-primary-custom:hover {
        background: #2980b9;
        transform: translateY(-2px);
        box-shadow: 0 6px 15px rgba(52, 152, 219, 0.6);
    }

    .btn-secondary-custom {
        background: #95a5a6;
        color: white;
    }
    .btn-secondary-custom:hover {
        background: #7f8c8d;
        transform: translateY(-2px);
    }

    .btn-danger-custom {
        background: var(--danger-color);
        color: white;
        box-shadow: 0 4px 10px rgba(231, 76, 60, 0.4);
    }
    .btn-danger-custom:hover {
        background: #c0392b;
        transform: translateY(-2px);
    }

    /* ---------------------------------------------------- */
    /* 4. 카메라 영역 */
    /* ---------------------------------------------------- */
    .camera-preview {
        width: 100%;
        max-width: 600px;
        margin: 0 auto 20px auto;
        border-radius: 20px; /* 카드와 동일한 라운드 */
        overflow: hidden;
        background: #f1f3f5; /* 약간 더 진한 회색 */
        position: relative;
        box-shadow: inset 0 0 20px rgba(0,0,0,0.05);
        aspect-ratio: 16 / 9;
        display: flex;
        align-items: center;
        justify-content: center;
        border: 2px dashed #d2d5d9; /* 대기 상태일 때 점선 */
    }

    /* 비디오가 활성화되면 테두리 스타일 변경 */
    .camera-preview.active {
        border: none;
    }

    #videoElement, #canvasElement {
        width: 100%;
        height: 100%;
        object-fit: cover;
        display: none;
    }

    .camera-placeholder {
        text-align: center;
        color: #adb5bd;
        z-index: 1;
        transition: opacity 0.3s;
    }

    .camera-placeholder i {
        font-size: 50px;
        margin-bottom: 10px;
        color: #ced4da;
    }

    .camera-controls {
        display: flex;
        gap: 10px;
        justify-content: center;
        flex-wrap: wrap;
        margin-top: 20px;
    }

    /* ---------------------------------------------------- */
    /* 5. 결과 영역 (레시피 & 안전성) */
    /* ---------------------------------------------------- */
    .result-container {
        display: none;
        animation: slideUp 0.4s ease-out;
    }
    .result-container.show {
        display: block;
    }

    @keyframes slideUp {
        from { opacity: 0; transform: translateY(20px); }
        to { opacity: 1; transform: translateY(0); }
    }

    /* 레시피 정보 박스 */
    .recipe-info {
        background: var(--secondary-bg);
        border-radius: 15px;
        padding: 20px;
        margin-bottom: 25px;
        border: 1px solid rgba(52, 152, 219, 0.1);
    }

    .recipe-info-item {
        display: flex;
        align-items: center;
        gap: 10px;
        margin-bottom: 8px;
        font-size: 16px;
    }

    .recipe-info-label {
        font-weight: 600;
        color: #7f8c8d;
        min-width: 90px;
    }

    .recipe-info-value {
        color: var(--secondary-color);
        font-weight: 500;
    }

    /* 재료 태그 */
    .ingredient-tag {
        display: inline-block;
        padding: 6px 14px;
        background: white;
        border: 1px solid #e2e8f0;
        border-radius: 20px;
        font-size: 14px;
        color: var(--secondary-color);
        margin: 0 8px 8px 0;
        box-shadow: 0 2px 5px rgba(0,0,0,0.03);
    }

    .ingredient-calories {
        color: var(--primary-color);
        font-weight: 600;
        font-size: 0.9em;
        margin-left: 4px;
    }

    /* 조리 순서 */
    .step-item {
        background: white;
        border: 1px solid #eee;
        border-radius: 15px;
        padding: 20px;
        margin-bottom: 15px;
        box-shadow: 0 4px 15px rgba(0,0,0,0.03);
        display: flex;
        gap: 15px;
        transition: transform 0.2s;
    }
    .step-item:hover {
        transform: translateY(-2px);
        border-color: var(--primary-color);
    }

    .step-number {
        flex-shrink: 0;
        width: 32px;
        height: 32px;
        background: var(--primary-color);
        color: white;
        border-radius: 50%;
        text-align: center;
        line-height: 32px;
        font-weight: 700;
        font-size: 14px;
        box-shadow: 0 4px 10px rgba(52, 152, 219, 0.4);
    }

    .step-description {
        font-size: 16px;
        line-height: 1.6;
        color: var(--secondary-color);
    }

    /* 팁 박스 */
    .tip-item {
        padding: 15px;
        margin-bottom: 10px;
        background: #fff3cd; /* center.jsp 아침 배지 색상 활용 */
        border-radius: 12px;
        color: #856404;
        display: flex;
        align-items: start;
        gap: 10px;
    }

    /* 안전성 배지 (center.jsp의 .meal-badge 스타일 활용) */
    .safety-badge {
        padding: 6px 14px;
        border-radius: 12px;
        font-weight: 700;
        font-size: 14px;
        display: inline-flex;
        align-items: center;
        gap: 5px;
        margin-left: 10px;
    }
    .safety-badge.safe { background: #d4edda; color: #155724; }
    .safety-badge.warning { background: #fff3cd; color: #856404; }
    .safety-badge.danger { background: #f8d7da; color: #721c24; }
    .safety-badge.unknown { background: #e2e8f0; color: #495057; }

    /* 안전성 메시지 박스 */
    .safety-message {
        padding: 20px;
        border-radius: 15px;
        font-weight: 500;
        margin-bottom: 20px;
        display: flex;
        align-items: center;
        gap: 15px;
        box-shadow: 0 4px 15px rgba(0,0,0,0.03);
    }

    /* 주의사항 리스트 */
    .warnings-list li, .recommendations-list li {
        padding: 12px;
        margin-bottom: 8px;
        border-radius: 12px;
        display: flex;
        align-items: start;
        gap: 10px;
        font-size: 15px;
    }
    .warnings-list li { background: #fff3cd; color: #856404; }
    .recommendations-list li { background: #d1ecf1; color: #0c5460; }

    /* 로딩 스피너 */
    .loading-modal-content {
        background: white;
        border-radius: 20px;
        text-align: center;
        padding: 40px 50px;
        box-shadow: 0 20px 60px rgba(0,0,0,0.15);
    }
    .spinner {
        border: 4px solid #f3f3f3;
        border-top: 4px solid var(--primary-color);
        border-radius: 50%;
        width: 50px;
        height: 50px;
        animation: spin 1s linear infinite;
        margin: 0 auto 20px;
    }
    @keyframes spin {
        0% { transform: rotate(0deg); }
        100% { transform: rotate(360deg); }
    }

    /* ---------------------------------------------------- */
    /* 6. 모달 스타일 (center.jsp 스타일) */
    /* ---------------------------------------------------- */
    .modal-overlay {
        display: none;
        position: fixed;
        top: 0; left: 0; width: 100%; height: 100%;
        background: rgba(0, 0, 0, 0.5); /* 좀 더 연하게 */
        z-index: 9999;
        align-items: center;
        justify-content: center;
        backdrop-filter: blur(3px); /* 블러 효과 */
    }
    .modal-overlay[style*="display: flex"] { display: flex !important; }

    .modal-content {
        background: white;
        border-radius: 20px;
        width: 90%;
        max-width: 550px;
        max-height: 90vh;
        overflow-y: auto;
        box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.25);
        animation: slideUp 0.3s ease;
        border: none;
    }

    .modal-header {
        padding: 25px 30px 10px 30px; /* 하단 패딩 줄임 */
        border-bottom: none; /* center.jsp처럼 구분선 제거 */
        display: flex;
        align-items: center;
        justify-content: space-between;
    }

    .modal-title {
        font-size: 22px;
        font-weight: 800;
        color: var(--secondary-color);
        margin: 0;
        display: flex;
        align-items: center;
        gap: 10px;
    }

    .modal-close-btn {
        width: 36px;
        height: 36px;
        border: none;
        background: #f1f3f5;
        color: #868e96;
        border-radius: 50%;
        cursor: pointer;
        display: flex;
        align-items: center;
        justify-content: center;
        transition: all 0.2s;
    }
    .modal-close-btn:hover {
        background: var(--danger-color);
        color: white;
    }

    .modal-body { padding: 10px 30px 30px 30px; }
    .form-group { margin-bottom: 20px; }

    .form-label {
        display: block;
        font-size: 14px;
        font-weight: 600;
        color: var(--secondary-color);
        margin-bottom: 8px;
    }
    .form-label i { color: var(--primary-color); margin-right: 5px; }
    .required { color: var(--danger-color); }

    .modal-footer {
        padding: 20px 30px;
        border-top: none; /* 구분선 제거 혹은 연하게 */
        display: flex;
        gap: 10px;
        justify-content: flex-end;
        background: #fafafa; /* 하단 배경 살짝 다르게 */
        border-radius: 0 0 20px 20px;
    }

    /* 모달 내부 textarea 스타일 조정 */
    textarea.form-control {
        resize: vertical;
        min-height: 100px;
        line-height: 1.6;
    }
</style>

<section class="ai-menu-section">
    <div class="page-header">
        <h1>
            <i class="fas fa-robot" style="color: var(--primary-color);"></i> AI 식단 메뉴
        </h1>
        <br>
        <h5>카메라로 음식을 촬영하거나 음식 이름을 입력하면 <br>레시피와 안전성 검사 결과를 제공합니다</h5>
    </div>

    <div class="detail-content-card">
        <h3 class="section-title">
            <i class="fas fa-keyboard" style="color: var(--primary-color);"></i> 음식 이름으로 분석하기
        </h3>

        <div style="display: flex; gap: 10px; align-items: center;">
            <input type="text"
                   id="foodNameInput"
                   class="form-control"
                   placeholder="예: 김치찌개, 된장찌개, 비빔밥 등"
                   onkeypress="if(event.key === 'Enter') analyzeMealByText()">
            <button class="btn-custom btn-primary-custom" onclick="analyzeMealByText()" style="flex-shrink: 0;">
                <i class="fas fa-search"></i> 분석하기
            </button>
        </div>
    </div>

    <div class="detail-content-card">
        <h3 class="section-title">
            <i class="fas fa-camera" style="color: var(--primary-color);"></i> 사진으로 분석하기
        </h3>

        <div class="camera-preview">
            <video id="videoElement" autoplay playsinline></video>
            <canvas id="canvasElement"></canvas>

            <div id="cameraPlaceholder" class="camera-placeholder">
                <i class="fas fa-camera"></i>
                <p style="font-weight: 600;">여기를 눌러 촬영하거나 아래 버튼을 사용하세요</p>
            </div>
        </div>

        <div class="camera-controls">
            <button class="btn-custom btn-primary-custom" onclick="startCamera()">
                <i class="fas fa-video"></i> 카메라 시작
            </button>
            <button class="btn-custom btn-secondary-custom" onclick="capturePhoto()" id="captureBtn" disabled>
                <i class="fas fa-camera"></i> 사진 촬영
            </button>
            <button class="btn-custom btn-danger-custom" onclick="stopCamera()" id="stopBtn" disabled>
                <i class="fas fa-stop"></i> 카메라 중지
            </button>
        </div>
    </div>

    <div class="result-container" id="resultContainer">

        <div class="detail-content-card result-section" id="recipeSection">
            <div id="aiGuideSection" style="margin-bottom: 25px; display: none;">
                <h3 id="aiGuideTitle" class="section-title">
                    <i class="fas fa-robot"></i> AI 가이드
                </h3>
                <div id="aiGuideContent" class="safety-message" style="background: var(--secondary-bg); color: var(--primary-color);">
                </div>
            </div>

            <h3 class="section-title"><i class="fas fa-book" style="color: var(--primary-color);"></i> 조리법</h3>
            <div id="recipeContent"></div>
        </div>

        <div class="detail-content-card result-section" id="safetySection">
            <h3 class="section-title">
                <span>
                    <i class="fas fa-shield-alt" style="color: var(--primary-color);"></i> 안전성 검사 결과
                </span>
                <span class="safety-badge" id="safetyBadge"></span>
            </h3>
            <div id="safetyContent"></div>
        </div>
    </div>
</section>

<div class="modal-overlay" id="saveRecipeModal" style="z-index: 9999;">
    <div class="modal-content">
        <div class="modal-header">
            <h3 class="modal-title">
                <i class="fas fa-save" style="color: var(--primary-color);"></i> AI 레시피로 식단 저장
            </h3>
            <button class="modal-close-btn" onclick="closeSaveRecipeModal()">
                <i class="fas fa-times"></i>
            </button>
        </div>
        <div class="modal-body">
            <form id="saveRecipeForm">
                <div class="form-group">
                    <label class="form-label">
                        <i class="fas fa-calendar"></i> 날짜 <span class="required">*</span>
                    </label>
                    <input type="date" id="saveMealDate" class="form-control" required>
                </div>

                <div class="form-group">
                    <label class="form-label">
                        <i class="fas fa-clock"></i> 식사 구분 <span class="required">*</span>
                    </label>
                    <select id="saveMealType" class="form-control" required>
                        <option value="">선택하세요</option>
                        <option value="아침">🌅 아침</option>
                        <option value="점심">☀️ 점심</option>
                        <option value="저녁">🌙 저녁</option>
                    </select>
                </div>

                <div class="form-group">
                    <label class="form-label">
                        <i class="fas fa-utensils"></i> 메뉴
                    </label>
                    <textarea id="saveMealMenu" class="form-control" rows="2" readonly style="background: #f8f9fa;"></textarea>
                </div>

                <div class="form-group">
                    <label class="form-label">
                        <i class="fas fa-book"></i> 레시피
                    </label>
                    <textarea id="saveMealRecipe" class="form-control" rows="5" readonly style="background: #f8f9fa;"></textarea>
                </div>

                <div class="form-group">
                    <label class="form-label">
                        <i class="fas fa-fire"></i> 칼로리 (kcal)
                    </label>
                    <input type="number" id="saveMealCalories" class="form-control" readonly style="background: #f8f9fa;">
                </div>
            </form>
        </div>
        <div class="modal-footer">
            <button class="btn-custom btn-secondary-custom" onclick="closeSaveRecipeModal()">
                <i class="fas fa-times"></i> 취소
            </button>
            <button class="btn-custom btn-primary-custom" onclick="saveAiRecipe()">
                <i class="fas fa-save"></i> 저장
            </button>
        </div>
    </div>
</div>

<div class="modal-overlay" id="loadingModal" style="z-index: 1060;">
    <div class="loading-modal-content">
        <div class="spinner"></div>
        <p style="font-size: 18px; font-Weight: 700; color: var(--secondary-color); margin-top: 10px; margin-bottom: 5px;">AI가 식단을 분석 중입니다...</p>
        <p style="font-size: 14px; color: #7f8c8d; margin: 0;">잠시만 기다려주세요.</p>
    </div>
</div>

<script>
    let currentRecId = <c:choose><c:when test="${not empty selectedRecipient and not empty selectedRecipient.recId}">${selectedRecipient.recId}</c:when><c:otherwise>null</c:otherwise></c:choose>;
    let stream = null;
    let capturedImage = null;
    let currentFoodName = null;
    let currentRecipeData = null;

    function startCamera() {
        const video = document.getElementById('videoElement');
        const placeholder = document.getElementById('cameraPlaceholder');
        const captureBtn = document.getElementById('captureBtn');
        const stopBtn = document.getElementById('stopBtn');
        const preview = document.querySelector('.camera-preview');

        // 이미 실행 중인 스트림 정리
        if (stream) {
            stream.getTracks().forEach(track => track.stop());
            stream = null;
        }

        // 기존 촬영 이미지 제거
        const existingImg = document.querySelector('#capturedImage');
        if (existingImg) {
            existingImg.remove();
        }

        if(placeholder) placeholder.style.display = 'none';
        video.style.display = 'block';
        preview.classList.add('active'); // 테두리 제거용 클래스

        capturedImage = null;
        document.getElementById('resultContainer').classList.remove('show');
        navigator.mediaDevices.getUserMedia({
            video: {
                facingMode: 'environment',
                width: { ideal: 1280 },
                height: { ideal: 720 }
            }
        })
            .then(function(mediaStream) {
                stream = mediaStream;
                video.srcObject = mediaStream;
                video.play();
                captureBtn.disabled = false;
                stopBtn.disabled = false;
            })
            .catch(function(err) {
                console.error('카메라 접근 오류:', err);
                alert('카메라 접근 실패: ' + err.message);

                // 실패 시 원상복구
                video.style.display = 'none';
                preview.classList.remove('active');
                if(placeholder) placeholder.style.display = 'block';
            });
    }

    function capturePhoto() {
        const video = document.getElementById('videoElement');
        if (!video.srcObject) {
            alert('먼저 카메라를 시작해주세요.');
            return;
        }

        const canvas = document.getElementById('canvasElement');
        const ctx = canvas.getContext('2d');

        canvas.width = video.videoWidth;
        canvas.height = video.videoHeight;
        ctx.drawImage(video, 0, 0, canvas.width, canvas.height);

        capturedImage = canvas.toDataURL('image/jpeg', 0.8);
        video.style.display = 'none';

        const placeholder = document.getElementById('cameraPlaceholder');
        if(placeholder) placeholder.style.display = 'none';

        const existingImg = document.querySelector('#capturedImage');
        if (existingImg) {
            existingImg.remove();
        }

        const img = document.createElement('img');
        img.src = capturedImage;
        img.style.width = '100%';
        img.style.height = '100%';
        img.style.objectFit = 'cover';
        img.id = 'capturedImage';
        img.style.display = 'block';

        const preview = document.querySelector('.camera-preview');
        preview.appendChild(img);

        // 사진 촬영 후 자동으로 분석 시작
        setTimeout(function() {
            analyzeMeal();
        }, 300);
    }

    function stopCamera() {
        if (stream) {
            stream.getTracks().forEach(track => track.stop());
            stream = null;
        }

        const video = document.getElementById('videoElement');
        const placeholder = document.getElementById('cameraPlaceholder');
        const preview = document.querySelector('.camera-preview');

        video.srcObject = null;
        video.style.display = 'none';

        const capturedImg = document.querySelector('#capturedImage');
        if (!capturedImg) {
            if(placeholder) placeholder.style.display = 'block';
            preview.classList.remove('active');
        }

        document.getElementById('captureBtn').disabled = true;
        document.getElementById('stopBtn').disabled = true;
    }

    function analyzeMealByText() {
        const foodNameInput = document.getElementById('foodNameInput');
        const foodName = foodNameInput.value.trim();

        if (!foodName) {
            alert('음식 이름을 입력해주세요.');
            foodNameInput.focus();
            return;
        }

        // 음식명 저장
        currentFoodName = foodName;

        document.getElementById('loadingModal').style.display = 'flex';
        document.getElementById('resultContainer').classList.remove('show');

        fetch('/mealplan/api/ai-menu', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({
                recId: currentRecId || null,
                mealDescription: foodName
            })
        })
            .then(response => {
                if (!response.ok) {
                    return response.json().then(errData => {
                        throw new Error(errData.message || `HTTP ${response.status}: ${response.statusText}`);
                    });
                }
                return response.json();
            })
            .then(data => {
                document.getElementById('loadingModal').style.display = 'none';
                if (data.success) {
                    displayResults(data);
                } else {
                    alert('분석 중 오류가 발생했습니다: ' + (data.message || '알 수 없는 오류'));
                }
            })
            .catch(error => {
                document.getElementById('loadingModal').style.display = 'none';
                console.error('Error:', error);
                alert('분석 중 오류가 발생했습니다: ' + error.message);
            });
    }

    function analyzeMeal() {
        if (!capturedImage) {
            alert('사진을 촬영해주세요.');
            return;
        }

        document.getElementById('loadingModal').style.display = 'flex';
        document.getElementById('resultContainer').classList.remove('show');

        const imageBase64 = capturedImage.split(',')[1];

        fetch('/mealplan/api/ai-menu', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({
                recId: currentRecId || null,
                imageBase64: imageBase64
            })
        })
            .then(response => {
                if (!response.ok) {
                    return response.json().then(errData => {
                        throw new Error(errData.message || `HTTP ${response.status}: ${response.statusText}`);
                    });
                }
                return response.json();
            })
            .then(data => {
                document.getElementById('loadingModal').style.display = 'none';
                if (data.success) {
                    displayResults(data);
                } else {
                    alert('분석 중 오류가 발생했습니다: ' + (data.message || '알 수 없는 오류'));
                }
            })
            .catch(error => {
                document.getElementById('loadingModal').style.display = 'none';
                console.error('Error:', error);
                alert('분석 중 오류가 발생했습니다: ' + error.message);
            });
    }

    function displayResults(data) {
        const container = document.getElementById('resultContainer');
        if (!container) return;

        container.classList.add('show');
        container.style.display = 'block';

        if (data.recipe && data.recipe.success && data.recipe.recipe) {
            currentRecipeData = data.recipe.recipe;
            displayRecipe(currentRecipeData);
            document.getElementById('recipeSection').style.display = 'block';

            if (!currentFoodName && data.recipe.recipe.foodName) {
                currentFoodName = data.recipe.recipe.foodName;
            }
        } else {
            currentRecipeData = null;
            document.getElementById('recipeSection').style.display = 'none';
        }

        if (data.safety && data.safety.success && data.safety.data) {
            displaySafety(data.safety.data);
            document.getElementById('safetySection').style.display = 'block';
        } else {
            document.getElementById('safetySection').style.display = 'none';
        }

        setTimeout(() => {
            container.scrollIntoView({ behavior: 'smooth', block: 'start' });
        }, 100);
    }

    function displayRecipe(recipe) {
        const recipeContent = document.getElementById('recipeContent');
        const aiGuideSection = document.getElementById('aiGuideSection');
        const aiGuideContent = document.getElementById('aiGuideContent');

        if (!recipeContent || !aiGuideSection || !aiGuideContent) return;

        if (recipe.aiGuide) {
            aiGuideContent.textContent = recipe.aiGuide;
            aiGuideSection.style.display = 'block';
        } else {
            aiGuideSection.style.display = 'none';
        }

        let html = '';
        if (recipe.foodName) {
            html += '<div class="recipe-info">';
            html += '<div class="recipe-info-item">';
            html += '<span class="recipe-info-label"><i class="fas fa-utensils"></i> 음식명:</span>';
            html += '<span class="recipe-info-value"><strong style="font-size: 20px;">' + escapeHtml(recipe.foodName) + '</strong></span>';
            html += '</div>';
            if (recipe.cookingTime) {
                html += '<div class="recipe-info-item">';
                html += '<span class="recipe-info-label"><i class="fas fa-clock"></i> 조리 시간:</span>';
                html += '<span class="recipe-info-value">' + escapeHtml(recipe.cookingTime) + '</span>';
                html += '</div>';
            }
            if (recipe.difficulty) {
                html += '<div class="recipe-info-item">';
                html += '<span class="recipe-info-label"><i class="fas fa-star"></i> 난이도:</span>';
                html += '<span class="recipe-info-value">' + escapeHtml(recipe.difficulty) + '</span>';
                html += '</div>';
            }
            html += '</div>';
        }

        if (recipe.ingredients && recipe.ingredients.length > 0) {
            let totalCalories = 0;
            html += '<div style="margin-bottom: 25px;">';
            html += '<h4 style="font-size: 18px; color: var(--secondary-color); margin-bottom: 15px;">';
            html += '<i class="fas fa-shopping-basket"></i> 필요한 재료';
            html += '</h4>';
            html += '<div class="ingredients-list">';
            recipe.ingredients.forEach(function(ingredient) {
                let ingredientName = '';
                let ingredientCalories = 0;
                let ingredientAmount = '';

                if (typeof ingredient === 'object' && ingredient.name) {
                    ingredientName = ingredient.name;
                    ingredientAmount = ingredient.amount || '';
                    ingredientCalories = ingredient.calories || 0;
                    totalCalories += ingredientCalories;
                } else {
                    ingredientName = ingredient;
                }

                let fullIngredientName = ingredientName;
                if (ingredientAmount) {
                    fullIngredientName += ' (' + ingredientAmount + ')';
                }

                html += '<span class="ingredient-tag">' + escapeHtml(fullIngredientName);
                if (ingredientCalories > 0) {
                    html += ' <span class="ingredient-calories">(' + ingredientCalories + 'kcal)</span>';
                }
                html += '</span>';
            });
            html += '</div>';

            const finalTotalCalories = recipe.totalCalories || totalCalories;
            if (finalTotalCalories > 0) {
                html += '<div class="total-calories-section">';
                html += '   <i class="fas fa-fire-alt"></i>';
                html += '   <strong>총 예상 소비 칼로리:</strong>';
                html += '   <span>' + finalTotalCalories + ' kcal</span>';
                html += '</div>';
            }
            html += '</div>';
        }

        if (recipe.steps && recipe.steps.length > 0) {
            html += '<div style="margin-bottom: 25px;">';
            html += '<h4 style="font-size: 18px; color: var(--secondary-color); margin-bottom: 15px;">';
            html += '<i class="fas fa-list-ol"></i> 조리 순서';
            html += '</h4>';
            html += '<ul class="steps-list">';
            recipe.steps.forEach(function(step, index) {
                const stepNum = step.stepNumber !== undefined && step.stepNumber !== null ? step.stepNumber : (index + 1);
                const stepDesc = step.description || step.desc || '설명 없음';
                html += '<li class="step-item">';
                html += '<span class="step-number">' + stepNum + '</span>';
                html += '<span class="step-description">' + escapeHtml(stepDesc) + '</span>';
                html += '</li>';
            });
            html += '</ul></div>';
        }

        if (recipe.tips && recipe.tips.length > 0) {
            html += '<div>';
            html += '<h4 style="font-size: 18px; color: var(--secondary-color); margin-bottom: 15px;">';
            html += '<i class="fas fa-lightbulb"></i> 조리 팁';
            html += '</h4>';
            html += '<ul class="tips-list">';
            recipe.tips.forEach(function(tip) {
                html += '<li class="tip-item">';
                html += '<i class="fas fa-check-circle"></i>';
                html += '<span>' + escapeHtml(tip) + '</span>';
                html += '</li>';
            });
            html += '</ul></div>';
        }

        // 버튼 스타일 적용
        html += '<div style="text-align: center; margin-top: 40px;">';
        html += '    <button class="btn-custom btn-primary-custom" onclick="openSaveRecipeModal()">';
        html += '        <i class="fas fa-save"></i> 이 레시피로 식단 저장하기';
        html += '    </button>';
        html += '</div>';

        recipeContent.innerHTML = html;
        recipeContent.style.display = 'block';
        recipeContent.style.opacity = '1';
    }

    function displaySafety(safetyData) {
        const safetyContent = document.getElementById('safetyContent');
        const badge = document.getElementById('safetyBadge');
        const aiGuideSection = document.getElementById('aiGuideSection');
        const aiGuideTitle = document.getElementById('aiGuideTitle');
        const aiGuideContent = document.getElementById('aiGuideContent');

        if (!safetyContent || !badge || !aiGuideSection || !aiGuideTitle || !aiGuideContent) return;

        let html = '';
        const safetyLevel = safetyData.safetyLevel || 'UNKNOWN';

        if (safetyLevel === 'SAFE') {
            badge.className = 'safety-badge safe';
            badge.textContent = '안전';
            aiGuideTitle.innerHTML = '<i class="fas fa-robot"></i> AI 가이드';
            aiGuideContent.style.background = '#e7f3ff';
            aiGuideContent.style.color = '#004085';
            aiGuideContent.style.borderLeft = '4px solid #3498db';
            if (currentRecipeData && currentRecipeData.aiGuide) {
                aiGuideContent.textContent = currentRecipeData.aiGuide;
                aiGuideSection.style.display = 'block';
            }
        } else if (safetyLevel === 'WARNING') {
            badge.className = 'safety-badge warning';
            badge.textContent = '주의 필요';
            aiGuideTitle.innerHTML = '<i class="fas fa-exclamation-triangle"></i> 섭취 주의 사유';
            aiGuideContent.textContent = safetyData.reason || '특별한 주의가 필요합니다.';
            aiGuideContent.style.background = '#fff3cd';
            aiGuideContent.style.color = '#856404';
            aiGuideContent.style.borderLeft = '4px solid #ffc107';
            aiGuideSection.style.display = 'block';
        } else if (safetyLevel === 'DANGER') {
            badge.className = 'safety-badge danger';
            badge.textContent = '위험';
            aiGuideTitle.innerHTML = '<i class="fas fa-times-circle"></i> 섭취 불가 사유';
            aiGuideContent.textContent = safetyData.reason || '섭취에 위험 요소가 있습니다.';
            aiGuideContent.style.background = '#f8d7da';
            aiGuideContent.style.color = '#721c24';
            aiGuideContent.style.borderLeft = '4px solid #dc3545';
            aiGuideSection.style.display = 'block';
        } else {
            badge.className = 'safety-badge unknown';
            badge.textContent = '검사 필요';
            aiGuideSection.style.display = 'none';
        }

        const message = safetyData.message || '검사 결과가 없습니다.';
        let messageStyle = '';
        if (safetyLevel === 'DANGER') {
            messageStyle = 'background: #f8d7da; color: #721c24; border-left: 4px solid #dc3545;';
        } else if (safetyLevel === 'WARNING') {
            messageStyle = 'background: #fff3cd; color: #856404; border-left: 4px solid #ffc107;';
        } else if (safetyLevel === 'SAFE') {
            messageStyle = 'background: #d4edda; color: #155724; border-left: 4px solid #28a745;';
        } else {
            messageStyle = 'background: #e9ecef; color: #495057; border-left: 4px solid #6c757d;';
        }

        html += '<div class="safety-message" style="' + messageStyle + '">';
        html += '<strong>' + escapeHtml(message) + '</strong>';
        html += '</div>';

        if (safetyLevel !== 'UNKNOWN' && safetyData.detectedFoods && Array.isArray(safetyData.detectedFoods) && safetyData.detectedFoods.length > 0) {
            html += '<div class="detected-foods" style="margin-top: 20px; margin-bottom: 20px;">';
            html += '<h4 style="font-size: 18px; color: var(--secondary-color); margin-bottom: 10px;">';
            html += '<i class="fas fa-utensils"></i> 감지된 음식';
            html += '</h4>';
            html += '<div class="ingredients-list">';
            safetyData.detectedFoods.forEach(function(food) {
                html += '<span class="ingredient-tag">' + escapeHtml(food) + '</span>';
            });
            html += '</div></div>';
        }

        if (safetyLevel !== 'UNKNOWN' && safetyData.warnings && Array.isArray(safetyData.warnings) && safetyData.warnings.length > 0) {
            html += '<div class="warnings-list">';
            html += '<h4><i class="fas fa-exclamation-triangle"></i> 주의사항</h4>';
            html += '<ul>';
            safetyData.warnings.forEach(function(warning) {
                html += '<li><i class="fas fa-exclamation-circle"></i> ' + escapeHtml(warning) + '</li>';
            });
            html += '</ul></div>';
        }

        if (safetyLevel !== 'UNKNOWN' && safetyData.recommendations && Array.isArray(safetyData.recommendations) && safetyData.recommendations.length > 0) {
            html += '<div class="recommendations-list">';
            html += '<h4><i class="fas fa-lightbulb"></i> 권장사항</h4>';
            html += '<ul>';
            safetyData.recommendations.forEach(function(rec) {
                html += '<li><i class="fas fa-check-circle"></i> ' + escapeHtml(rec) + '</li>';
            });
            html += '</ul></div>';
        }

        safetyContent.innerHTML = html;
        safetyContent.style.display = 'block';
        safetyContent.style.opacity = '1';

        if (currentFoodName) {
            loadYouTubeVideo(currentFoodName);
        }
    }

    function loadYouTubeVideo(foodName) {
        if (!foodName || foodName.trim() === '') return;
        const safetyContent = document.getElementById('safetyContent');
        if (!safetyContent) return;

        fetch('/mealplan/api/youtube-search?foodName=' + encodeURIComponent(foodName))
            .then(response => response.json())
            .then(data => {
                if (data.success && data.videoId) {
                    const videoTitle = escapeHtml(data.videoTitle || foodName + ' 만드는 방법');
                    const videoId = data.videoId;
                    const searchUrl = data.searchUrl;

                    const youtubeHtml =
                        '<div class="youtube-video-section" style="margin-top: 30px; padding-top: 20px; border-top: 2px solid #e0e0e0;">' +
                        '<h4 style="font-size: 18px; color: var(--secondary-color); margin-bottom: 15px;">' +
                        '<i class="fab fa-youtube" style="color: #FF0000; margin-right: 8px;"></i>' +
                        videoTitle + ' 영상' +
                        '</h4>' +
                        '<div class="youtube-embed" style="position: relative; padding-bottom: 56.25%; height: 0; overflow: hidden; max-width: 100%; background: #000; border-radius: 15px;">' +
                        '<iframe style="position: absolute; top: 0; left: 0; width: 100%; height: 100%;" ' +
                        'src="https://www.youtube.com/embed/' + videoId + '" ' +
                        'frameborder="0" ' +
                        'allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" ' +
                        'allowfullscreen></iframe>' +
                        '</div>' +
                        '<div style="margin-top: 10px; text-align: right;">' +
                        '<a href="' + searchUrl + '" target="_blank" style="color: var(--primary-color); text-decoration: none; font-size: 14px; font-weight: 600;">' +
                        '<i class="fas fa-external-link-alt"></i> YouTube에서 더 보기' +
                        '</a>' +
                        '</div>' +
                        '</div>';
                    safetyContent.insertAdjacentHTML('beforeend', youtubeHtml);
                } else if (data.searchUrl) {
                    const escapedFoodName = escapeHtml(foodName);
                    const searchUrl = data.searchUrl;
                    const youtubeHtml =
                        '<div class="youtube-video-section" style="margin-top: 30px; padding-top: 20px; border-top: 2px solid #e0e0e0;">' +
                        '<h4 style="font-size: 18px; color: var(--secondary-color); margin-bottom: 15px;">' +
                        '<i class="fab fa-youtube" style="color: #FF0000; margin-right: 8px;"></i>' +
                        escapedFoodName + ' 만드는 방법 영상' +
                        '</h4>' +
                        '<div style="text-align: center; padding: 20px; background: var(--secondary-bg); border-radius: 15px;">' +
                        '<p style="color: #666; margin-bottom: 15px;">YouTube에서 "' + escapedFoodName + ' 만드는 방법" 영상을 검색하세요.</p>' +
                        '<a href="' + searchUrl + '" target="_blank" ' +
                        'style="display: inline-block; padding: 12px 24px; background: #FF0000; color: white; text-decoration: none; border-radius: 50px; font-weight: bold;">' +
                        '<i class="fab fa-youtube"></i> YouTube에서 검색하기' +
                        '</a>' +
                        '</div>' +
                        '</div>';
                    safetyContent.insertAdjacentHTML('beforeend', youtubeHtml);
                }
            })
            .catch(error => {
                console.error('YouTube 영상 검색 실패:', error);
            });
    }

    // --- AI 레시피 저장 관련 함수 ---
    function formatRecipeForSaving(recipe) {
        if (!recipe) return '';

        let recipeText = '';
        if (recipe.ingredients && Array.isArray(recipe.ingredients) && recipe.ingredients.length > 0) {
            recipeText += '필요한 재료:\n';
            recipe.ingredients.forEach((ing, index) => {
                let namePart = '';
                let amountPart = '';
                let caloriesPart = '';

                if (typeof ing === 'object' && ing !== null) {
                    namePart = ing.name || ing.ingredient || '';
                    if (!namePart) namePart = '재료 ' + (index + 1);
                    if (ing.amount) amountPart = ' (' + ing.amount + ')';
                    if (ing.calories) caloriesPart = ' - ' + ing.calories + 'kcal';
                } else {
                    namePart = String(ing);
                }
                recipeText += (index + 1) + '. ' + namePart + amountPart + caloriesPart + '\n';
            });
            recipeText += '\n';
        }

        if (recipe.steps && Array.isArray(recipe.steps) && recipe.steps.length > 0) {
            recipeText += '조리 순서:\n';
            recipe.steps.forEach((step, index) => {
                let stepNum = index + 1;
                let stepDesc = '';
                if (typeof step === 'object' && step !== null) {
                    stepNum = (step.stepNumber !== undefined && step.stepNumber !== null) ? step.stepNumber : (index + 1);
                    stepDesc = step.description || step.desc || step.step || '';
                } else {
                    stepDesc = String(step);
                }
                if (stepDesc) {
                    recipeText += stepNum + '. ' + stepDesc + '\n';
                }
            });
            recipeText += '\n';
        }

        if (recipe.tips && Array.isArray(recipe.tips) && recipe.tips.length > 0) {
            recipeText += '조리 팁:\n';
            recipe.tips.forEach((tip, index) => {
                if (tip) {
                    recipeText += '• ' + String(tip) + '\n';
                }
            });
        }
        return recipeText.trim();
    }

    function openSaveRecipeModal() {
        if (!currentRecipeData) {
            alert('저장할 레시피 정보가 없습니다.');
            return;
        }
        if (!currentRecId) {
            alert('식단을 저장할 대상자를 선택해주세요. 홈 화면에서 대상자를 선택할 수 있습니다.');
            return;
        }

        let modal = document.getElementById('saveRecipeModal');
        if (modal && modal.parentElement && modal.parentElement !== document.body) {
            document.body.appendChild(modal);
        }

        const today = new Date();
        const year = today.getFullYear();
        const month = String(today.getMonth() + 1).padStart(2, '0');
        const day = String(today.getDate()).padStart(2, '0');
        document.getElementById('saveMealDate').value = `${year}-${month}-${day}`;
        document.getElementById('saveMealType').value = '';
        document.getElementById('saveMealMenu').value = currentRecipeData.foodName || '';
        document.getElementById('saveMealRecipe').value = formatRecipeForSaving(currentRecipeData);

        let totalCalories = currentRecipeData.totalCalories || 0;
        if (totalCalories === 0 && currentRecipeData.ingredients && Array.isArray(currentRecipeData.ingredients)) {
            totalCalories = currentRecipeData.ingredients.reduce((sum, ing) => {
                if (typeof ing === 'object' && ing.calories) {
                    return sum + (parseInt(ing.calories) || 0);
                }
                return sum;
            }, 0);
        }
        document.getElementById('saveMealCalories').value = totalCalories > 0 ? totalCalories : '';

        if (modal) {
            modal.style.display = 'flex';
        }
    }

    function closeSaveRecipeModal() {
        document.getElementById('saveRecipeModal').style.display = 'none';
    }

    function saveAiRecipe() {
        const mealDate = document.getElementById('saveMealDate').value;
        const mealType = document.getElementById('saveMealType').value;
        const mealMenu = document.getElementById('saveMealMenu').value;
        const mealCalories = document.getElementById('saveMealCalories').value;

        if (!mealDate || !mealType) {
            alert('날짜와 식사 구분을 선택해주세요.');
            return;
        }

        const mealRecipe = document.getElementById('saveMealRecipe').value;
        const data = {
            recId: currentRecId,
            mealDate: mealDate,
            mealType: mealType,
            mealMenu: mealMenu,
            mealRecipe: mealRecipe,
            mealCalories: mealCalories || null
        };

        fetch('/mealplan/api/meal', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify(data)
        })
            .then(response => response.json())
            .then(result => {
                if (result.success) {
                    alert('AI 레시피가 식단에 성공적으로 저장되었습니다.');
                    closeSaveRecipeModal();
                } else {
                    alert('식단 저장에 실패했습니다: ' + (result.message || '알 수 없는 오류'));
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert('식단 저장 중 오류가 발생했습니다.');
            });
    }

    function escapeHtml(text) {
        if (text == null) return '';
        const map = {
            '&': '&amp;',
            '<': '&lt;',
            '>': '&gt;',
            '"': '&quot;',
            "'": '&#039;'
        };
        return String(text).replace(/[&<>"']/g, function(m) { return map[m]; });
    }

    window.addEventListener('beforeunload', function() {
        stopCamera();
    });
</script>