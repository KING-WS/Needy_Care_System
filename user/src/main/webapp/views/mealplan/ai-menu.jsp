<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<style>
    .ai-menu-section {
        padding: 20px 0 100px 0;
        background: #FFFFFF;
    }
    
    .ai-menu-container {
        max-width: 1200px;
        margin: 0 auto;
        padding: 0 20px;
    }
    
    .page-header {
        margin-bottom: 30px;
    }
    
    .page-header h1 {
        font-size: 36px;
        font-weight: bold;
        color: var(--secondary-color);
        margin-bottom: 10px;
    }
    
    .page-header p {
        font-size: 16px;
        color: #666;
    }
    
    .usage-guide-card {
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        border-radius: 12px;
        padding: 25px;
        margin-bottom: 30px;
        color: white;
        box-shadow: 0 5px 15px rgba(102, 126, 234, 0.3);
    }
    
    .usage-guide-card h3 {
        color: white;
        font-size: 22px;
        font-weight: 600;
        margin-bottom: 20px;
        display: flex;
        align-items: center;
        gap: 10px;
    }
    
    .usage-guide-list {
        list-style: none;
        padding: 0;
        margin: 0;
    }
    
    .usage-guide-item {
        display: flex;
        align-items: start;
        gap: 15px;
        margin-bottom: 15px;
        padding: 12px;
        background: rgba(255, 255, 255, 0.15);
        border-radius: 8px;
        backdrop-filter: blur(10px);
    }
    
    .usage-guide-item:last-child {
        margin-bottom: 0;
    }
    
    .usage-guide-icon {
        font-size: 20px;
        min-width: 30px;
        text-align: center;
    }
    
    .usage-guide-text {
        flex: 1;
        line-height: 1.6;
    }
    
    .usage-guide-text strong {
        display: block;
        margin-bottom: 5px;
        font-size: 16px;
    }
    
    .usage-guide-text span {
        font-size: 14px;
        opacity: 0.95;
    }
    
    .camera-container {
        background: #fff;
        border-radius: 15px;
        box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        padding: 30px;
        margin-bottom: 20px;
    }
    
    .camera-section {
        display: flex;
        flex-direction: column;
        gap: 20px;
    }
    
    .camera-preview {
        width: 100%;
        max-width: 600px;
        margin: 0 auto;
        border-radius: 12px;
        overflow: hidden;
        background: #000;
        position: relative;
    }
    
    #videoElement {
        width: 100%;
        height: auto;
        display: block;
    }
    
    #canvasElement {
        display: none;
    }
    
    .camera-controls {
        display: flex;
        gap: 10px;
        justify-content: center;
        flex-wrap: wrap;
    }
    
    .btn-camera {
        padding: 12px 24px;
        border: none;
        border-radius: 8px;
        font-size: 16px;
        font-weight: 600;
        cursor: pointer;
        transition: all 0.3s;
        display: flex;
        align-items: center;
        gap: 8px;
    }
    
    .btn-camera-primary {
        background: var(--primary-color);
        color: white;
    }
    
    .btn-camera-primary:hover {
        background: var(--primary-color-dark);
        transform: translateY(-2px);
    }
    
    .btn-camera-secondary {
        background: #6c757d;
        color: white;
    }
    
    .btn-camera-secondary:hover {
        background: #5a6268;
    }
    
    .btn-camera-danger {
        background: #dc3545;
        color: white;
    }
    
    .btn-camera-danger:hover {
        background: #c82333;
    }
    
    .result-container {
        background: #fff;
        border-radius: 15px;
        box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        padding: 30px;
        margin-top: 30px;
        display: none;
        visibility: hidden;
        opacity: 0;
        min-height: 100px;
    }
    
    .result-container.show {
        display: block !important;
        visibility: visible !important;
        opacity: 1 !important;
    }
    
    .result-section {
        margin-bottom: 40px;
        display: block;
        visibility: visible;
        opacity: 1;
    }
    
    .result-section:last-child {
        margin-bottom: 0;
    }
    
    .result-section h3 {
        font-size: 24px;
        color: #2c3e50;
        margin-bottom: 20px;
        padding-bottom: 15px;
        border-bottom: 2px solid #eee;
        display: flex;
        align-items: center;
        gap: 10px;
    }
    
    .recipe-info {
        background: #f8f9fa;
        border-radius: 12px;
        padding: 20px;
        margin-bottom: 25px;
    }
    
    .recipe-info-item {
        display: flex;
        align-items: center;
        gap: 10px;
        margin-bottom: 10px;
        font-size: 16px;
    }
    
    .recipe-info-item:last-child {
        margin-bottom: 0;
    }
    
    .recipe-info-label {
        font-weight: 600;
        color: #495057;
        min-width: 100px;
    }
    
    .recipe-info-value {
        color: #2c3e50;
    }
    
    .ingredients-list {
        display: flex;
        flex-wrap: wrap;
        gap: 10px;
        margin-top: 10px;
    }
    
    .ingredient-tag {
        padding: 8px 16px;
        background: #e7f3ff;
        border-radius: 20px;
        font-size: 14px;
        color: #495057;
    }
    
    .steps-list {
        list-style: none;
        padding: 0;
        margin: 0;
    }
    
    .step-item {
        background: #fff;
        border-left: 4px solid var(--primary-color);
        border-radius: 8px;
        padding: 20px;
        margin-bottom: 15px;
        box-shadow: 0 2px 8px rgba(0,0,0,0.05);
    }
    
    .step-number {
        display: inline-block;
        width: 30px;
        height: 30px;
        background: var(--primary-color);
        color: white;
        border-radius: 50%;
        text-align: center;
        line-height: 30px;
        font-weight: 700;
        margin-right: 15px;
    }
    
    .step-description {
        display: inline-block;
        vertical-align: top;
        width: calc(100% - 50px);
        font-size: 16px;
        line-height: 1.6;
        color: #333;
    }
    
    .tips-list {
        list-style: none;
        padding: 0;
        margin: 0;
    }
    
    .tip-item {
        padding: 12px;
        margin-bottom: 10px;
        background: #fff3cd;
        border-radius: 8px;
        color: #856404;
        display: flex;
        align-items: start;
        gap: 10px;
    }
    
    .safety-badge {
        padding: 8px 16px;
        border-radius: 20px;
        font-weight: 600;
        font-size: 14px;
        display: inline-block;
        margin-left: 10px;
    }
    
    .safety-badge.safe {
        background: #d4edda;
        color: #155724;
    }
    
    .safety-badge.warning {
        background: #fff3cd;
        color: #856404;
    }
    
    .safety-badge.danger {
        background: #f8d7da;
        color: #721c24;
    }
    
    .safety-message {
        font-size: 18px;
        line-height: 1.8;
        color: #333;
        margin-bottom: 20px;
        padding: 20px;
        background: #f8f9fa;
        border-radius: 8px;
        font-weight: 500;
        border-left: 4px solid var(--primary-color);
    }
    
    .warnings-list, .recommendations-list {
        margin-top: 15px;
    }
    
    .warnings-list h4, .recommendations-list h4 {
        font-size: 18px;
        color: #2c3e50;
        margin-bottom: 10px;
    }
    
    .warnings-list ul, .recommendations-list ul {
        list-style: none;
        padding: 0;
    }
    
    .warnings-list li, .recommendations-list li {
        padding: 10px;
        margin-bottom: 8px;
        border-radius: 8px;
        display: flex;
        align-items: start;
        gap: 10px;
    }
    
    .warnings-list li {
        background: #fff3cd;
        color: #856404;
    }
    
    .recommendations-list li {
        background: #d1ecf1;
        color: #0c5460;
    }
    
    .loading {
        text-align: center;
        padding: 40px;
        display: none;
    }
    
    .loading.show {
        display: block;
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

    .ingredient-calories {
        font-size: 0.9em;
        color: #007bff;
        font-weight: 500;
    }
    .total-calories-section {
        margin-top: 20px;
        padding: 15px;
        background-color: #f8f9fa;
        border-radius: 8px;
        display: flex;
        align-items: center;
        gap: 10px;
        font-size: 16px;
        border: 1px solid #e9ecef;
    }
    .total-calories-section i {
        color: #ff6b6b;
        font-size: 20px;
    }
    .total-calories-section strong {
        font-weight: 600;
        color: #343a40;
    }
    .total-calories-section span {
        font-weight: 700;
        color: #ff6b6b;
        font-size: 18px;
    }
    /* 모달 배경 (어두운 영역) - 핵심: position: fixed */
    .modal-overlay {
        position: fixed;        /* 스크롤과 상관없이 화면에 고정 */
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        background-color: rgba(0, 0, 0, 0.5); /* 반투명 검은 배경 */
        display: none;          /* 기본적으로 숨김 */
        justify-content: center; /* 가로 중앙 정렬 */
        align-items: center;     /* 세로 중앙 정렬 */
        z-index: 9999;          /* 다른 요소들보다 위에 뜨도록 설정 */
    }

    /* 모달창이 활성화될 때 (JS에서 display: flex로 변경됨) */
    .modal-overlay[style*="display: flex"] {
        display: flex !important;
    }

    /* 모달 내용 박스 (하얀색 박스) */
    .modal-content {
        background-color: white;
        padding: 0;             /* 내부 여백 제거 (헤더/푸터 분리를 위해) */
        border-radius: 12px;    /* 둥근 모서리 */
        width: 90%;             /* 모바일 대응 */
        max-width: 500px;       /* 최대 너비 제한 */
        box-shadow: 0 10px 25px rgba(0,0,0,0.2); /* 그림자 효과 */
        overflow: hidden;       /* 내부 내용 넘침 방지 */
        animation: slideIn 0.3s ease-out; /* 부드럽게 나타나는 애니메이션 */
    }

    /* 모달 헤더/바디/푸터 스타일 (디자인 개선) */
    .modal-header {
        padding: 15px 20px;
        background: #f8f9fa;
        border-bottom: 1px solid #eee;
        display: flex;
        justify-content: space-between;
        align-items: center;
    }

    .modal-title {
        margin: 0;
        font-size: 18px;
        font-weight: 600;
        color: #333;
    }

    .modal-body {
        padding: 20px;
        max-height: 70vh; /* 화면이 작을 때 스크롤 생기도록 */
        overflow-y: auto;
    }

    .modal-footer {
        padding: 15px 20px;
        border-top: 1px solid #eee;
        display: flex;
        justify-content: flex-end;
        gap: 10px;
    }

    /* 닫기 버튼 스타일 */
    .modal-close-btn {
        background: none;
        border: none;
        font-size: 20px;
        cursor: pointer;
        color: #666;
    }

    /* 애니메이션 효과 */
    @keyframes slideIn {
        from { transform: translateY(-20px); opacity: 0; }
        to { transform: translateY(0); opacity: 1; }
    }
</style>

<section class="ai-menu-section">
    <div class="ai-menu-container">
        <!-- 헤더 -->
        <div class="page-header">
            <h1>
                <i class="fas fa-robot"></i> AI식단 메뉴
            </h1>
            <p>카메라로 음식을 촬영하거나 음식 이름을 입력하면 레시피와 안전성 검사 결과를 제공합니다</p>
        </div>

        <!-- 사용방법 안내 -->
        <div class="usage-guide-card">
            <h3>
                <i class="fas fa-info-circle"></i> 사용방법
            </h3>
            <ul class="usage-guide-list">
                <li class="usage-guide-item">
                    <div class="usage-guide-icon">
                        <i class="fas fa-keyboard"></i>
                    </div>
                    <div class="usage-guide-text">
                        <strong>텍스트 입력 방식</strong>
                        <span>음식 이름을 입력하고 "분석하기" 버튼을 클릭하면 AI가 레시피와 안전성 검사 결과를 제공합니다.</span>
                    </div>
                </li>
                <li class="usage-guide-item">
                    <div class="usage-guide-icon">
                        <i class="fas fa-camera"></i>
                    </div>
                    <div class="usage-guide-text">
                        <strong>사진 촬영 방식</strong>
                        <span>"카메라 시작" 버튼을 눌러 카메라를 활성화한 후, "사진 촬영" 버튼으로 음식을 촬영하면 자동으로 분석이 시작됩니다.</span>
                    </div>
                </li>
                <li class="usage-guide-item">
                    <div class="usage-guide-icon">
                        <i class="fas fa-shield-alt"></i>
                    </div>
                    <div class="usage-guide-text">
                        <strong>안전성 검사</strong>
                        <span>AI가 돌봄 대상자의 건강 상태를 고려하여 음식의 안전성을 자동으로 검사하고 주의사항을 제공합니다.</span>
                    </div>
                </li>
                <li class="usage-guide-item">
                    <div class="usage-guide-icon">
                        <i class="fas fa-book"></i>
                    </div>
                    <div class="usage-guide-text">
                        <strong>레시피 제공</strong>
                        <span>조리 시간, 난이도, 필요한 재료, 조리 순서, 조리 팁 등 상세한 레시피 정보를 제공합니다.</span>
                    </div>
                </li>
            </ul>
        </div>

        <!-- 텍스트 입력 섹션 -->
        <div class="camera-container" style="margin-bottom: 20px;">
            <div class="camera-section">
                <h3 style="margin-bottom: 15px; color: #2c3e50; font-size: 20px;">
                    <i class="fas fa-keyboard"></i> 음식 이름으로 분석하기
                </h3>
                <div style="display: flex; gap: 10px; align-items: center;">
                    <input type="text" 
                           id="foodNameInput" 
                           placeholder="예: 김치찌개, 된장찌개, 비빔밥 등"
                           style="flex: 1; padding: 12px; border: 1px solid #ddd; border-radius: 8px; font-size: 16px;"
                           onkeypress="if(event.key === 'Enter') analyzeMealByText()">
                    <button class="btn-camera btn-camera-primary" onclick="analyzeMealByText()">
                        <i class="fas fa-search"></i> 분석하기
                    </button>
                </div>
            </div>
        </div>

        <!-- 카메라 섹션 -->
        <div class="camera-container">
            <div class="camera-section">
                <h3 style="margin-bottom: 15px; color: #2c3e50; font-size: 20px;">
                    <i class="fas fa-camera"></i> 사진으로 분석하기
                </h3>
                <div class="camera-preview">
                    <video id="videoElement" autoplay playsinline></video>
                    <canvas id="canvasElement"></canvas>
                </div>
                
                <div class="camera-controls">
                    <button class="btn-camera btn-camera-primary" onclick="startCamera()">
                        <i class="fas fa-video"></i> 카메라 시작
                    </button>
                    <button class="btn-camera btn-camera-secondary" onclick="capturePhoto()" id="captureBtn" disabled>
                        <i class="fas fa-camera"></i> 사진 촬영
                    </button>
                    <button class="btn-camera btn-camera-danger" onclick="stopCamera()" id="stopBtn" disabled>
                        <i class="fas fa-stop"></i> 카메라 중지
                    </button>
                </div>
            </div>
        </div>

        <!-- 로딩 -->
        <div class="loading" id="loadingDiv">
            <div class="spinner"></div>
            <p>AI가 음식을 분석하고 레시피를 생성하고 있습니다...</p>
        </div>

        <!-- 결과 -->
        <div class="result-container" id="resultContainer">
            <!-- 레시피 섹션 -->
            <div class="result-section" id="recipeSection">
                <h3><i class="fas fa-book"></i> 조리법</h3>
                <div id="recipeContent"></div>
            </div>

            <!-- 안전성 검사 섹션 -->
            <div class="result-section" id="safetySection">
                <h3>
                    <i class="fas fa-shield-alt"></i> 안전성 검사 결과
                    <span class="safety-badge" id="safetyBadge"></span>
                </h3>
                <div id="safetyContent"></div>
            </div>
        </div>
    </div>
</section>

<!-- AI 레시피 저장 모달 -->
<div class="modal-overlay" id="saveRecipeModal" style="display: none; z-index: 1050;">
    <div class="modal-content" style="max-width: 500px;">
        <div class="modal-header">
            <h3 class="modal-title">
                <i class="fas fa-save"></i> AI 레시피로 식단 저장
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
            <button class="btn btn-cancel" onclick="closeSaveRecipeModal()">
                <i class="fas fa-times"></i> 취소
            </button>
            <button class="btn btn-save" onclick="saveAiRecipe()">
                <i class="fas fa-save"></i> 저장
            </button>
        </div>
    </div>
</div>


<script>
    let currentRecId = <c:choose><c:when test="${selectedRecipient != null}">${selectedRecipient.recId}</c:when><c:otherwise>null</c:otherwise></c:choose>;
    let stream = null;
    let capturedImage = null;
    let currentFoodName = null;  // 현재 분석 중인 음식명 저장
    let currentRecipeData = null; // AI가 분석한 레시피 데이터 저장

    function startCamera() {
        const video = document.getElementById('videoElement');
        const captureBtn = document.getElementById('captureBtn');
        const stopBtn = document.getElementById('stopBtn');

        // 이미 실행 중인 스트림이 있으면 먼저 정리
        if (stream) {
            stream.getTracks().forEach(track => track.stop());
            stream = null;
        }

        // 기존 촬영된 이미지 제거
        const existingImg = document.querySelector('#capturedImage');
        if (existingImg) {
            existingImg.remove();
        }
        video.style.display = 'block';
        capturedImage = null;

        // 결과 숨기기
        document.getElementById('resultContainer').classList.remove('show');

        // 카메라 접근 요청
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
                alert('카메라 접근에 실패했습니다. 카메라 권한을 확인해주세요.\n' + err.message);
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
        
        // 촬영된 이미지 미리보기
        video.style.display = 'none';
        
        const existingImg = document.querySelector('#capturedImage');
        if (existingImg) {
            existingImg.remove();
        }
        
        const img = document.createElement('img');
        img.src = capturedImage;
        img.style.width = '100%';
        img.style.height = 'auto';
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
        video.srcObject = null;
        
        const capturedImg = document.querySelector('#capturedImage');
        if (!capturedImg) {
            video.style.display = 'block';
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

        // 로딩 표시
        document.getElementById('loadingDiv').classList.add('show');
        document.getElementById('resultContainer').classList.remove('show');

        // API 호출 (recId가 없으면 null로 전송, 서버에서 처리)
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
            console.log('응답 상태:', response.status);
            
            if (!response.ok) {
                return response.json().then(errData => {
                    throw new Error(errData.message || `HTTP ${response.status}: ${response.statusText}`);
                });
            }
            
            return response.json();
        })
        .then(data => {
            document.getElementById('loadingDiv').classList.remove('show');
            
            console.log('API 응답 데이터:', data);
            
            if (data.success) {
                displayResults(data);
            } else {
                alert('분석 중 오류가 발생했습니다: ' + (data.message || '알 수 없는 오류'));
            }
        })
        .catch(error => {
            document.getElementById('loadingDiv').classList.remove('show');
            console.error('Error:', error);
            alert('분석 중 오류가 발생했습니다: ' + error.message);
        });
    }

    function analyzeMeal() {
        if (!capturedImage) {
            alert('사진을 촬영해주세요.');
            return;
        }

        // 로딩 표시
        document.getElementById('loadingDiv').classList.add('show');
        document.getElementById('resultContainer').classList.remove('show');

        // Base64 이미지에서 데이터 부분만 추출
        const imageBase64 = capturedImage.split(',')[1];

        // API 호출 (recId가 없으면 null로 전송, 서버에서 처리)
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
            console.log('응답 상태:', response.status);
            
            if (!response.ok) {
                return response.json().then(errData => {
                    throw new Error(errData.message || `HTTP ${response.status}: ${response.statusText}`);
                });
            }
            
            return response.json();
        })
        .then(data => {
            document.getElementById('loadingDiv').classList.remove('show');
            
            console.log('API 응답 데이터:', data);
            
            if (data.success) {
                displayResults(data);
            } else {
                alert('분석 중 오류가 발생했습니다: ' + (data.message || '알 수 없는 오류'));
            }
        })
        .catch(error => {
            document.getElementById('loadingDiv').classList.remove('show');
            console.error('Error:', error);
            alert('분석 중 오류가 발생했습니다: ' + error.message);
        });
    }

    function displayResults(data) {
        const container = document.getElementById('resultContainer');
        if (!container) {
            console.error('resultContainer 요소를 찾을 수 없습니다!');
            return;
        }
        
        // 컨테이너 표시
        container.classList.add('show');
        container.style.display = 'block';
        container.style.visibility = 'visible';
        container.style.opacity = '1';
        container.style.height = 'auto';
        container.style.minHeight = '100px';
        
        // 레시피 표시
        if (data.recipe && data.recipe.success && data.recipe.recipe) {
            currentRecipeData = data.recipe.recipe; // 전역 변수에 레시피 데이터 저장
            displayRecipe(currentRecipeData);
            document.getElementById('recipeSection').style.display = 'block';
            
            // 레시피에서 음식명 추출 (이미지 분석인 경우)
            if (!currentFoodName && data.recipe.recipe.foodName) {
                currentFoodName = data.recipe.recipe.foodName;
            }
        } else {
            currentRecipeData = null;
            document.getElementById('recipeSection').style.display = 'none';
        }

        // 안전성 검사 표시
        if (data.safety && data.safety.success && data.safety.data) {
            displaySafety(data.safety.data);
            document.getElementById('safetySection').style.display = 'block';
        } else {
            document.getElementById('safetySection').style.display = 'none';
        }
        
        // 결과 컨테이너로 스크롤
        setTimeout(() => {
            container.scrollIntoView({ behavior: 'smooth', block: 'start' });
        }, 100);
    }

    function displayRecipe(recipe) {
        const recipeContent = document.getElementById('recipeContent');
        if (!recipeContent) {
            console.error('recipeContent 요소를 찾을 수 없습니다!');
            return;
        }
        
        let html = '';

        // 음식 이름
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

        // 재료 목록
        if (recipe.ingredients && recipe.ingredients.length > 0) {
            let totalCalories = 0;
            html += '<div style="margin-bottom: 25px;">';
            html += '<h4 style="font-size: 18px; color: #2c3e50; margin-bottom: 15px;">';
            html += '<i class="fas fa-shopping-basket"></i> 필요한 재료';
            html += '</h4>';
            html += '<div class="ingredients-list">';
            recipe.ingredients.forEach(function(ingredient) {
                let ingredientName = '';
                let ingredientCalories = 0;

                if (typeof ingredient === 'object' && ingredient.name) {
                    ingredientName = ingredient.name;
                    ingredientCalories = ingredient.calories || 0;
                    totalCalories += ingredientCalories;
                } else {
                    ingredientName = ingredient;
                }

                html += '<span class="ingredient-tag">' + escapeHtml(ingredientName);
                if (ingredientCalories > 0) {
                    html += ' <span class="ingredient-calories">(' + ingredientCalories + 'kcal)</span>';
                }
                html += '</span>';
            });
            html += '</div>';

            // 총 칼로리 표시
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

        // 조리 단계
        if (recipe.steps && recipe.steps.length > 0) {
            html += '<div style="margin-bottom: 25px;">';
            html += '<h4 style="font-size: 18px; color: #2c3e50; margin-bottom: 15px;">';
            html += '<i class="fas fa-list-ol"></i> 조리 순서';
            html += '</h4>';
            html += '<ul class="steps-list">';
            recipe.steps.forEach(function(step, index) {
                const stepNum = step.stepNumber !== undefined && step.stepNumber !== null 
                    ? step.stepNumber 
                    : (index + 1);
                const stepDesc = step.description || step.desc || '설명 없음';
                html += '<li class="step-item">';
                html += '<span class="step-number">' + stepNum + '</span>';
                html += '<span class="step-description">' + escapeHtml(stepDesc) + '</span>';
                html += '</li>';
            });
            html += '</ul></div>';
        }

        // 조리 팁
        if (recipe.tips && recipe.tips.length > 0) {
            html += '<div>';
            html += '<h4 style="font-size: 18px; color: #2c3e50; margin-bottom: 15px;">';
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

        // 저장하기 버튼 추가
        html += '<div style="text-align: center; margin-top: 40px;">';
        html += '    <button class="btn-camera btn-camera-primary" onclick="openSaveRecipeModal()">';
        html += '        <i class="fas fa-save"></i> 이 레시피로 식단 저장하기';
        html += '    </button>';
        html += '</div>';

        recipeContent.innerHTML = html;
        recipeContent.style.display = 'block';
        recipeContent.style.visibility = 'visible';
        recipeContent.style.opacity = '1';
    }

    function displaySafety(safetyData) {
        const safetyContent = document.getElementById('safetyContent');
        const badge = document.getElementById('safetyBadge');
        
        if (!safetyContent || !badge) {
            console.error('safetyContent 또는 safetyBadge 요소를 찾을 수 없습니다!');
            return;
        }
        
        let html = '';

        // 안전성 배지
        const safetyLevel = safetyData.safetyLevel || 'SAFE';
        
        if (safetyLevel === 'SAFE') {
            badge.className = 'safety-badge safe';
            badge.textContent = '안전';
        } else if (safetyLevel === 'WARNING') {
            badge.className = 'safety-badge warning';
            badge.textContent = '주의 필요';
        } else {
            badge.className = 'safety-badge danger';
            badge.textContent = '위험';
        }

        // 메시지
        const message = safetyData.message || '검사 결과가 없습니다.';
        let messageStyle = '';
        if (safetyLevel === 'DANGER') {
            messageStyle = 'background: #f8d7da; color: #721c24; border-left-color: #dc3545;';
        } else if (safetyLevel === 'WARNING') {
            messageStyle = 'background: #fff3cd; color: #856404; border-left-color: #ffc107;';
        } else {
            messageStyle = 'background: #d4edda; color: #155724; border-left-color: #28a745;';
        }
        
        html += '<div class="safety-message" style="' + messageStyle + '">';
        html += '<strong>' + escapeHtml(message) + '</strong>';
        html += '</div>';

        // 감지된 음식
        if (safetyData.detectedFoods && Array.isArray(safetyData.detectedFoods) && safetyData.detectedFoods.length > 0) {
            html += '<div class="detected-foods" style="margin-top: 20px; margin-bottom: 20px;">';
            html += '<h4 style="font-size: 18px; color: #2c3e50; margin-bottom: 10px;">';
            html += '<i class="fas fa-utensils"></i> 감지된 음식';
            html += '</h4>';
            html += '<div class="ingredients-list">';
            safetyData.detectedFoods.forEach(function(food) {
                html += '<span class="ingredient-tag">' + escapeHtml(food) + '</span>';
            });
            html += '</div></div>';
        }

        // 주의사항
        if (safetyData.warnings && Array.isArray(safetyData.warnings) && safetyData.warnings.length > 0) {
            html += '<div class="warnings-list">';
            html += '<h4><i class="fas fa-exclamation-triangle"></i> 주의사항</h4>';
            html += '<ul>';
            safetyData.warnings.forEach(function(warning) {
                html += '<li><i class="fas fa-exclamation-circle"></i> ' + escapeHtml(warning) + '</li>';
            });
            html += '</ul></div>';
        }

        // 권장사항
        if (safetyData.recommendations && Array.isArray(safetyData.recommendations) && safetyData.recommendations.length > 0) {
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
        safetyContent.style.visibility = 'visible';
        safetyContent.style.opacity = '1';
        
        // 권장사항 아래에 YouTube 영상 표시
        if (currentFoodName) {
            loadYouTubeVideo(currentFoodName);
        }
    }
    
    // YouTube 영상 로드
    function loadYouTubeVideo(foodName) {
        if (!foodName || foodName.trim() === '') {
            return;
        }
        
        const safetyContent = document.getElementById('safetyContent');
        if (!safetyContent) {
            return;
        }
        
        // YouTube 검색 API 호출
        fetch('/mealplan/api/youtube-search?foodName=' + encodeURIComponent(foodName))
            .then(response => response.json())
            .then(data => {
                if (data.success && data.videoId) {
                    // YouTube 영상 임베드 추가
                    const videoTitle = escapeHtml(data.videoTitle || foodName + ' 만드는 방법');
                    const videoId = data.videoId;
                    const searchUrl = data.searchUrl;
                    
                    const youtubeHtml = 
                        '<div class="youtube-video-section" style="margin-top: 30px; padding-top: 20px; border-top: 2px solid #e0e0e0;">' +
                        '<h4 style="font-size: 18px; color: #2c3e50; margin-bottom: 15px;">' +
                        '<i class="fab fa-youtube" style="color: #FF0000; margin-right: 8px;"></i>' +
                        videoTitle + ' 영상' +
                        '</h4>' +
                        '<div class="youtube-embed" style="position: relative; padding-bottom: 56.25%; height: 0; overflow: hidden; max-width: 100%; background: #000; border-radius: 8px;">' +
                        '<iframe ' +
                        'style="position: absolute; top: 0; left: 0; width: 100%; height: 100%;" ' +
                        'src="https://www.youtube.com/embed/' + videoId + '" ' +
                        'frameborder="0" ' +
                        'allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" ' +
                        'allowfullscreen>' +
                        '</iframe>' +
                        '</div>' +
                        '<div style="margin-top: 10px; text-align: right;">' +
                        '<a href="' + searchUrl + '" target="_blank" style="color: #667eea; text-decoration: none; font-size: 14px;">' +
                        '<i class="fas fa-external-link-alt"></i> YouTube에서 더 보기' +
                        '</a>' +
                        '</div>' +
                        '</div>';
                    safetyContent.insertAdjacentHTML('beforeend', youtubeHtml);
                } else if (data.searchUrl) {
                    // API 키가 없거나 검색 실패 시 검색 링크만 제공
                    const escapedFoodName = escapeHtml(foodName);
                    const searchUrl = data.searchUrl;
                    
                    const youtubeHtml = 
                        '<div class="youtube-video-section" style="margin-top: 30px; padding-top: 20px; border-top: 2px solid #e0e0e0;">' +
                        '<h4 style="font-size: 18px; color: #2c3e50; margin-bottom: 15px;">' +
                        '<i class="fab fa-youtube" style="color: #FF0000; margin-right: 8px;"></i>' +
                        escapedFoodName + ' 만드는 방법 영상' +
                        '</h4>' +
                        '<div style="text-align: center; padding: 20px; background: #f8f9fa; border-radius: 8px;">' +
                        '<p style="color: #666; margin-bottom: 15px;">YouTube에서 "' + escapedFoodName + ' 만드는 방법" 영상을 검색하세요.</p>' +
                        '<a href="' + searchUrl + '" target="_blank" ' +
                        'style="display: inline-block; padding: 12px 24px; background: #FF0000; color: white; text-decoration: none; border-radius: 5px; font-weight: bold;">' +
                        '<i class="fab fa-youtube"></i> YouTube에서 검색하기' +
                        '</a>' +
                        '</div>' +
                        '</div>';
                    safetyContent.insertAdjacentHTML('beforeend', youtubeHtml);
                }
            })
            .catch(error => {
                console.error('YouTube 영상 검색 실패:', error);
                // 에러가 발생해도 계속 진행 (YouTube 영상은 선택사항)
            });
    }

    // --- AI 레시피 저장 관련 함수 ---

    function openSaveRecipeModal() {
        if (!currentRecipeData) {
            alert('저장할 레시피 정보가 없습니다.');
            return;
        }
        if (!currentRecId) {
            alert('식단을 저장할 대상자를 선택해주세요. 홈 화면에서 대상자를 선택할 수 있습니다.');
            return;
        }

        // 모달 필드 채우기
        document.getElementById('saveMealDate').value = new Date().toISOString().split('T')[0];
        document.getElementById('saveMealType').value = '';
        document.getElementById('saveMealMenu').value = currentRecipeData.foodName || '';
        
        // 레시피 내용 채우기
        let recipeStepsText = '';
        if (currentRecipeData.steps && currentRecipeData.steps.length > 0) {
            recipeStepsText = currentRecipeData.steps.map(step => {
                return (step.stepNumber || '') + '. ' + (step.description || '');
            }).join('\\n'); // textarea에서는 줄바꿈 문자로 \n을 사용합니다.
        }
        document.getElementById('saveMealRecipe').value = recipeStepsText;

        let totalCalories = currentRecipeData.totalCalories || 0;
        if (totalCalories === 0 && currentRecipeData.ingredients) {
            totalCalories = currentRecipeData.ingredients.reduce((sum, ing) => sum + (ing.calories || 0), 0);
        }
        document.getElementById('saveMealCalories').value = totalCalories > 0 ? totalCalories : '';

        // 모달 보이기
        document.getElementById('saveRecipeModal').style.display = 'flex';
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

        // 레시피 내용을 JSON 문자열로 변환하여 저장
        const mealRecipe = JSON.stringify(currentRecipeData, null, 2);

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


    // HTML 이스케이프 함수
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

    // 페이지 이탈 시 카메라 정리
    window.addEventListener('beforeunload', function() {
        stopCamera();
    });
</script>
