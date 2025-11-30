<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<style>
    /* =========================================
       1. 레이아웃 및 전체 테마
       ========================================= */
    :root {
        /* 사용자 정의 변수가 있다면 여기에 정의되어야 합니다.
 (예: Spring/JSP 설정) [cite_start][cite: 1, 2] */
        /* 임시 컬러 변수 (원래 코드에서 정의되지 않아 임의 지정) */
        --primary-color: #3498db;
        --primary-color-dark: #2980b9;
        --secondary-color: #2c3e50;
        --warning-light: #fef9e7;
        --danger-light: #fcebeb;
    }

    .ai-check-section {
        padding: 40px 0 100px 0;
    }

    .ai-check-container {
        max-width: 1200px;
        margin: 0 auto;
        padding: 0 20px;
    }

    .page-header {
        margin-bottom: 40px;
        text-align: center;
    }

    .page-header h1 {
        font-size: 38px;
        font-weight: 800;
        color: var(--secondary-color);
        margin-bottom: 5px;
        text-shadow: 0 1px 2px rgba(0, 0, 0, 0.05);
    }

    .page-header p {
        font-size: 16px;
        color: #7f8c8d;
    }

    /* =========================================
       2. 입력 및 컨트롤 영역
       ========================================= */
    .recipient-select-card {
        /* [수정됨] 흰색 배경을 투명도가 있는 흰색으로 변경하여 섹션 배경색이 비치도록 함 */
        background: rgba(255,255,255,0.85);
        border-radius: 15px;
        padding: 25px;
        margin-bottom: 30px;
        box-shadow: 0 4px 15px rgba(0,0,0,0.05);
        border: 1px solid #e0e0e0;
    }

    .recipient-select-label {
        font-weight: 700;
        color: var(--primary-color);
        margin-bottom: 12px;
        display: flex;
        align-items: center;
        gap: 8px;
        font-size: 1.1rem;
    }

    .recipient-select {
        width: 100%;
        padding: 12px;
        border: 2px solid #e9ecef;
        border-radius: 10px;
        font-size: 16px;
        transition: border-color 0.3s, box-shadow 0.3s;
    }
    .recipient-select:focus {
        border-color: var(--primary-color);
        box-shadow: 0 0 0 3px rgba(52, 152, 219, 0.1);
    }

    .camera-container {
        /* [수정됨] 흰색 배경을 투명도가 있는 흰색으로 변경하여 섹션 배경색이 비치도록 함 */
        background: rgba(255,255,255,0.85);
        border-radius: 15px;
        box-shadow: 0 8px 25px rgba(0,0,0,0.1);
        padding: 40px;
        margin-bottom: 30px;
        border: 1px solid #e0e0e0;
    }

    .camera-section {
        display: flex;
        flex-direction: column;
        gap: 30px;
    }

    .camera-preview {
        width: 100%;
        max-width: 700px;
        /* 미리보기 영역 확장 */
        margin: 0 auto;
        border-radius: 15px;
        overflow: hidden;
        /* [수정] 배경을 검은색 (#000)에서 밝은 회색으로 변경하여 플레이스홀더를 표시 */
        background: #f8f9fa;
        position: relative;

        /* [수정] 외곽선 두께를 5px에서 2px로 줄이고 색상을 #d2d5d9로 변경 */
        box-shadow: 0 0 0 2px #d2d5d9;

        /* 모니터 베젤 효과 */
        aspect-ratio: 16 / 9;
        /* 비율 고정 */

        /* [추가] 내부 아이콘 중앙 정렬을 위한 Flex 설정 */
        display: flex;
        align-items: center;
        justify-content: center;
    }

    #videoElement {
        width: 100%;
        height: 100%; /* 부모 컨테이너에 맞게 꽉 채움 */
        object-fit: cover;
        /* [수정] 초기에는 비디오를 숨겨서 플레이스홀더가 보이게 함 */
        display: none;
    }

    #canvasElement {
        display: none;
    }

    /* [추가] 초기 대기 화면 (플레이스홀더) 스타일 */
    .camera-placeholder {
        text-align: center;
        color: #adb5bd; /* 회색 텍스트 */
        z-index: 1; /* 비디오보다 위에 있을 필요는 없으나 안전을 위해 */
        transition: opacity 0.3s;
    }

    .camera-placeholder i {
        font-size: 60px; /* 아이콘 크기 */
        margin-bottom: 15px;
        color: #ced4da; /* 아이콘 색상 */
    }

    .camera-placeholder p {
        font-size: 20px;
        font-weight: 700;
        margin: 0;
    }

    .camera-controls {
        display: flex;
        gap: 15px;
        justify-content: center;
        flex-wrap: wrap;
    }

    .btn-camera {
        padding: 12px 28px;
        border: none;
        border-radius: 30px; /* 캡슐형 버튼 */
        font-size: 16px;
        font-weight: 700;
        cursor: pointer;
        transition: all 0.3s;
        display: flex;
        align-items: center;
        gap: 10px;
        box-shadow: 0 2px 5px rgba(0,0,0,0.1);
    }

    .btn-camera-primary {
        background: var(--primary-color);
        color: white;
    }

    .btn-camera-primary:hover {
        background: var(--primary-color-dark);
        transform: translateY(-2px);
        box-shadow: 0 4px 10px rgba(52, 152, 219, 0.4);
    }

    .btn-camera-secondary {
        background: #95a5a6;
        color: white;
    }

    .btn-camera-secondary:hover {
        background: #7f8c8d;
    }

    .btn-camera-danger {
        background: #e74c3c;
        color: white;
    }

    .btn-camera-danger:hover {
        background: #c0392b;
    }


    /* =========================================
       3. 결과 영역
       ========================================= */

    .result-container {
        /* [수정됨] 흰색 배경을 투명도가 있는 흰색으로 변경하여 섹션 배경색이 비치도록 함 */
        background: rgba(255,255,255,0.85);
        border-radius: 15px;
        box-shadow: 0 8px 25px rgba(0,0,0,0.1);
        padding: 40px;
        margin-top: 30px;
        display: none;
        border: 1px solid #e0e0e0;
    }

    .result-container.show {
        display: block;
    }

    .result-header {
        display: flex;
        align-items: center;
        justify-content: space-between;
        margin-bottom: 25px;
        padding-bottom: 20px;
        border-bottom: 2px solid #f0f0f0;
    }

    .result-header h3 {
        margin: 0;
        font-size: 28px;
        color: var(--primary-color);
        font-weight: 700;
    }

    .safety-badge {
        padding: 10px 20px;
        border-radius: 25px;
        font-weight: 700;
        font-size: 16px;
        box-shadow: 0 2px 4px rgba(0,0,0,0.1);
    }

    /* 안전 배지 색상 */
    .safety-badge.safe {
        background: #e6ffe6;
        /* 연한 녹색 */
        color: #1abc9c;
    }

    .safety-badge.warning {
        background: #fff8e1;
        /* 연한 노란색 */
        color: #f39c12;
    }

    .safety-badge.danger {
        background: #ffeded;
        /* 연한 빨간색 */
        color: #e74c3c;
    }

    .result-message {
        font-size: 18px;
        line-height: 1.8;
        color: #333;
        margin-bottom: 30px;
        padding: 25px;
        border-radius: 10px;
        font-weight: 600;
        border-left: 5px solid;
        /* 색상만 동적으로 변경 */
    }

    .warnings-list, .recommendations-list {
        margin-top: 30px;
    }

    .warnings-list h4, .recommendations-list h4 {
        font-size: 20px;
        color: var(--secondary-color);
        margin-bottom: 15px;
        font-weight: 600;
    }

    .warnings-list ul, .recommendations-list ul {
        list-style: none;
        padding: 0;
    }

    .warnings-list li, .recommendations-list li {
        padding: 15px;
        margin-bottom: 10px;
        border-radius: 10px;
        display: flex;
        align-items: start;
        gap: 15px;
        font-size: 15px;
        font-weight: 500;
    }

    /* 경고 목록 스타일 */
    .warnings-list li {
        background: var(--warning-light);
        color: #d35400; /* 진한 주황색 */
        border-left: 4px solid #f39c12;
    }

    /* 권장사항 목록 스타일 */
    .recommendations-list li {
        background: #e8f5fb;
        /* 연한 파란색 */
        color: #2980b9;
        border-left: 4px solid var(--primary-color);
    }

    .detected-foods {
        margin-top: 20px;
        padding: 20px;
        background: #f0f8ff;
        border-radius: 10px;
    }

    .detected-foods h4 {
        font-size: 17px;
        color: var(--secondary-color);
        margin-bottom: 12px;
        font-weight: 600;
    }

    .detected-foods span {
        display: inline-block;
        padding: 7px 15px;
        margin: 5px;
        background: white;
        border: 1px solid #dcdcdc;
        border-radius: 25px;
        font-size: 14px;
        color: #495057;
        box-shadow: 0 1px 3px rgba(0,0,0,0.05);
    }

    /* =========================================
       4. 로딩 스피너
       ========================================= */

    .loading {
        text-align: center;
        padding: 50px;
        /* [수정됨] 흰색 배경을 투명도가 있는 흰색으로 변경하여 섹션 배경색이 비치도록 함 */
        background: rgba(255,255,255,0.85);
        border-radius: 15px;
        box-shadow: 0 4px 15px rgba(0,0,0,0.05);
        margin-bottom: 30px;
        display: none;
    }

    .loading.show {
        display: block;
    }

    .spinner {
        border: 4px solid #eaf2f8;
        /* 밝은 회색 테두리 */
        border-top: 4px solid var(--primary-color);
        /* 포인트 색상 */
        border-radius: 50%;
        width: 60px;
        height: 60px;
        animation: spin 1s linear infinite;
        margin: 0 auto 20px;
    }

    @keyframes spin {
        0% { transform: rotate(0deg); }
        100% { transform: rotate(360deg); }
    }
</style>

<section class="ai-check-section">
    <div class="ai-check-container">
        <div class="page-header">
            <h1>
                <i class="fas fa-shield-alt" style="color: var(--primary-color);"></i> AI 식단 안전성 검사
            </h1>
            <p>카메라로 음식을 촬영하거나 설명을 입력하여 돌봄 대상자의 식단 안전성을 검사하세요</p>
        </div>

        <c:if test="${not empty recipientList}">
            <div class="recipient-select-card">
                <label class="recipient-select-label">
                    <i class="fas fa-user-injured"></i> 돌봄 대상자 선택
                </label>
                <select id="recipientSelect" class="recipient-select" onchange="changeRecipient()">
                    <c:forEach items="${recipientList}" var="rec">
                        <option value="${rec.recId}" ${rec.recId == selectedRecipient.recId ? 'selected' : ''}>
                                ${rec.recName}
                        </option>
                    </c:forEach>
                </select>
            </div>
        </c:if>

        <div class="camera-container">
            <div class="camera-section">
                <div class="camera-preview">
                    <video id="videoElement" autoplay playsinline></video>
                    <canvas id="canvasElement"></canvas>

                    <div id="cameraPlaceholder" class="camera-placeholder">
                        <i class="fas fa-camera"></i>
                        <p>음식 촬영</p>
                    </div>

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

        <div class="loading" id="loadingDiv">
            <div class="spinner"></div>
            <p style="font-size: 18px; font-weight: 600; color: var(--secondary-color);">AI가 음식을 분석하고 있습니다...</p>
            <p style="font-size: 14px; color: #999;">분석이 완료될 때까지 잠시만 기다려주세요.</p>
        </div>

        <div class="result-container" id="resultContainer" style="margin-top: 20px;">
            <div class="result-header">
                <h3><i class="fas fa-clipboard-check"></i> 검사 결과</h3>
                <span class="safety-badge" id="safetyBadge"></span>
            </div>

            <div class="result-message" id="resultMessage"></div>

            <div class="row">
                <div class="col-lg-12">
                    <div class="detected-foods" id="detectedFoods" style="display: none;">
                        <h4><i class="fas fa-search"></i> 감지된 음식</h4>

                        <div id="detectedFoodsList"></div>
                    </div>
                </div>

                <div class="col-lg-6">
                    <div class="warnings-list" id="warningsList" style="display: none;">
                        <h4><i class="fas fa-exclamation-triangle"></i> 주의사항</h4>
                        <ul id="warningsUl"></ul>
                    </div>
                </div>
                <div class="col-lg-6">

                    <div class="recommendations-list" id="recommendationsList" style="display: none;">
                        <h4><i class="fas fa-lightbulb"></i> 권장사항</h4>
                        <ul id="recommendationsUl"></ul>
                    </div>
                </div>
            </div>
        </div>
    </div>
</section>

<script>
    let currentRecId = ${selectedRecipient != null ? selectedRecipient.recId : 'null'};
    let stream = null;
    let capturedImage = null;

    function changeRecipient() {
        const select = document.getElementById('recipientSelect');
        currentRecId = parseInt(select.value);
        window.location.href = '/mealplan/ai-check?recId=' + currentRecId;
    }

    function startCamera() {
        const video = document.getElementById('videoElement');
        const placeholder = document.getElementById('cameraPlaceholder'); // [추가]
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

        // [수정] 카메라 시작 시 비디오 보이기 & 플레이스홀더 숨기기
        video.style.display = 'block';
        if (placeholder) placeholder.style.display = 'none'; // [추가]

        capturedImage = null;

        // 카메라 접근 요청
        navigator.mediaDevices.getUserMedia({
            video: {
                facingMode: 'environment', // 후면 카메라 우선
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

                // [추가] 오류 발생 시 비디오 숨기고 플레이스홀더 다시 보이기
                video.style.display = 'none';
                if (placeholder) placeholder.style.display = 'flex'; // camera-preview가 flex이므로 flex로 설정
            });
    }

    function capturePhoto() {
        if (!currentRecId) {
            alert('돌봄 대상자를 선택해주세요.');
            return;
        }

        const video = document.getElementById('videoElement');
        // 비디오가 재생 중인지 확인
        if (!video.srcObject) {
            alert('먼저 카메라를 시작해주세요.');
            return;
        }

        const canvas = document.getElementById('canvasElement');
        const ctx = canvas.getContext('2d');
        // 비디오 크기에 맞춰 캔버스 크기 설정
        canvas.width = video.videoWidth;
        canvas.height = video.videoHeight;
        // 비디오 프레임을 캔버스에 그리기
        ctx.drawImage(video, 0, 0, canvas.width, canvas.height);
        // 캔버스를 이미지로 변환
        capturedImage = canvas.toDataURL('image/jpeg', 0.8);

        // [수정] 촬영된 이미지 미리보기를 위해 비디오 숨기기
        video.style.display = 'none';

        // [추가] 플레이스홀더 숨기기 (혹시 모를 상황 대비)
        const placeholder = document.getElementById('cameraPlaceholder');
        if (placeholder) placeholder.style.display = 'none';

        // 기존 이미지가 있으면 제거
        const existingImg = document.querySelector('#capturedImage');
        if (existingImg) {
            existingImg.remove();
        }

        // 새 이미지 생성 및 표시
        const img = document.createElement('img');
        img.src = capturedImage;
        img.style.width = '100%';
        img.style.height = '100%'; // [수정] 높이를 100%로 설정
        img.style.objectFit = 'cover'; // [추가]
        img.id = 'capturedImage';
        img.style.display = 'block';

        const preview = document.querySelector('.camera-preview');
        preview.appendChild(img);

        // 사진 촬영 후 자동으로 안전성 검사 시작
        setTimeout(function() {
            checkSafety();
        }, 300);
    }

    function stopCamera() {
        if (stream) {
            stream.getTracks().forEach(track => track.stop());
            stream = null;
        }

        const video = document.getElementById('videoElement');
        const placeholder = document.getElementById('cameraPlaceholder'); // [추가]

        video.srcObject = null;
        video.style.display = 'none'; // [수정] 비디오 숨기기

        // 촬영된 이미지가 없으면 플레이스홀더(아이콘) 다시 표시
        const capturedImg = document.querySelector('#capturedImage');
        if (!capturedImg) {
            if (placeholder) placeholder.style.display = 'flex'; // [추가]
        }

        document.getElementById('captureBtn').disabled = true;
        document.getElementById('stopBtn').disabled = true;
    }

    function checkSafety() {
        if (!currentRecId) {
            alert('돌봄 대상자를 선택해주세요.');
            return;
        }

        if (!capturedImage) {
            alert('사진을 촬영해주세요.');
            return;
        }

        // 로딩 표시
        document.getElementById('loadingDiv').classList.add('show');
        document.getElementById('resultContainer').classList.remove('show');

        // Base64 이미지에서 데이터 부분만 추출
        const imageBase64 = capturedImage.split(',')[1];
        // data:image/jpeg;base64, 부분 제거

        // API 호출
        fetch('/mealplan/api/ai-check', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({
                recId: currentRecId,
                imageBase64: imageBase64,
                mealDescription: null
            })
        })
            .then(response => response.json())
            .then(data => {
                document.getElementById('loadingDiv').classList.remove('show');

                if (data.success) {
                    displayResult(data.data);
                } else {
                    alert('검사 중 오류가 발생했습니다: ' + (data.message || '알 수 없는 오류'));
                }
            })
            .catch(error => {
                document.getElementById('loadingDiv').classList.remove('show');
                console.error('Error:', error);
                alert('검사 중 오류가 발생했습니다.');
            });
    }

    function displayResult(result) {
        const container = document.getElementById('resultContainer');
        container.classList.add('show');

        // 안전성 배지
        const badge = document.getElementById('safetyBadge');
        const safetyLevel = result.safetyLevel || 'SAFE';
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

        // 메시지 (더 명확하게 표시)
        const messageElement = document.getElementById('resultMessage');
        const message = result.message || '검사 결과가 없습니다.';
        messageElement.innerHTML = '<strong>' + message + '</strong>';

        // 안전 수준에 따라 메시지 스타일 조정 (CSS 변수 활용)
        if (safetyLevel === 'DANGER') {
            messageElement.style.background = '#ffeded';
            messageElement.style.color = '#e74c3c';
            messageElement.style.borderLeftColor = '#e74c3c';
        } else if (safetyLevel === 'WARNING') {
            messageElement.style.background = '#fff8e1';
            messageElement.style.color = '#d35400';
            messageElement.style.borderLeftColor = '#f39c12';
        } else {
            messageElement.style.background = '#e6ffe6';
            messageElement.style.color = '#1abc9c';
            messageElement.style.borderLeftColor = '#1abc9c';
        }

        // 감지된 음식
        if (result.detectedFoods && result.detectedFoods.length > 0) {
            const foodsDiv = document.getElementById('detectedFoods');
            const foodsList = document.getElementById('detectedFoodsList');
            foodsList.innerHTML = '';
            result.detectedFoods.forEach(food => {
                const span = document.createElement('span');
                span.textContent = food;
                foodsList.appendChild(span);
            });
            foodsDiv.style.display = 'block';
        } else {
            document.getElementById('detectedFoods').style.display = 'none';
        }

        // 주의사항
        if (result.warnings && result.warnings.length > 0) {
            const warningsUl = document.getElementById('warningsUl');
            warningsUl.innerHTML = '';
            result.warnings.forEach(warning => {
                const li = document.createElement('li');
                li.innerHTML = '<i class="fas fa-exclamation-circle"></i> ' + warning;
                warningsUl.appendChild(li);
            });
            document.getElementById('warningsList').style.display = 'block';
        } else {
            document.getElementById('warningsList').style.display = 'none';
        }

        // 권장사항
        if (result.recommendations && result.recommendations.length > 0) {
            const recommendationsUl = document.getElementById('recommendationsUl');
            recommendationsUl.innerHTML = '';
            result.recommendations.forEach(rec => {
                const li = document.createElement('li');
                li.innerHTML = '<i class="fas fa-check-circle"></i> ' + rec;
                recommendationsUl.appendChild(li);
            });
            document.getElementById('recommendationsList').style.display = 'block';
        } else {
            document.getElementById('recommendationsList').style.display = 'none';
        }
    }

    // 페이지 이탈 시 카메라 정리
    window.addEventListener('beforeunload', function() {
        stopCamera();
    });
</script>