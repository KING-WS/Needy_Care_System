<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<style>
    .ai-check-section {
        padding: 20px 0 100px 0;
        background: #FFFFFF;
    }
    
    .ai-check-container {
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
    
    .recipient-select-card {
        background: #f8f9fa;
        border-radius: 12px;
        padding: 20px;
        margin-bottom: 30px;
    }
    
    .recipient-select-label {
        font-weight: 600;
        color: #2c3e50;
        margin-bottom: 10px;
        display: block;
    }
    
    .recipient-select {
        width: 100%;
        padding: 12px;
        border: 1px solid #ddd;
        border-radius: 8px;
        font-size: 16px;
    }
    
    .camera-container {
        background: #fff;
        border-radius: 15px;
        box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        padding: 30px;
        margin-bottom: 30px;
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
    }
    
    .result-container.show {
        display: block;
    }
    
    .result-header {
        display: flex;
        align-items: center;
        gap: 10px;
        margin-bottom: 20px;
        padding-bottom: 15px;
        border-bottom: 2px solid #eee;
    }
    
    .result-header h3 {
        margin: 0;
        font-size: 24px;
        color: #2c3e50;
    }
    
    .safety-badge {
        padding: 8px 16px;
        border-radius: 20px;
        font-weight: 600;
        font-size: 14px;
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
    
    .result-message {
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
    
    .detected-foods {
        margin-top: 15px;
        padding: 15px;
        background: #e7f3ff;
        border-radius: 8px;
    }
    
    .detected-foods h4 {
        font-size: 16px;
        color: #2c3e50;
        margin-bottom: 10px;
    }
    
    .detected-foods span {
        display: inline-block;
        padding: 5px 12px;
        margin: 5px;
        background: white;
        border-radius: 20px;
        font-size: 14px;
        color: #495057;
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
</style>

<section class="ai-check-section">
    <div class="ai-check-container">
        <!-- 헤더 -->
        <div class="page-header">
            <h1>
                <i class="fas fa-shield-alt"></i> AI 식단 안전성 검사
            </h1>
            <p>카메라로 음식을 촬영하거나 설명을 입력하여 안전성을 검사하세요</p>
        </div>

        <!-- 노약자 선택 -->
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

        <!-- 카메라 섹션 -->
        <div class="camera-container">
            <div class="camera-section">
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
            <p>AI가 음식을 분석하고 있습니다...</p>
        </div>

        <!-- 결과 (카메라 버튼 아래에 표시) -->
        <div class="result-container" id="resultContainer" style="margin-top: 20px;">
            <div class="result-header">
                <h3><i class="fas fa-clipboard-check"></i> 검사 결과</h3>
                <span class="safety-badge" id="safetyBadge"></span>
            </div>
            <div class="result-message" id="resultMessage"></div>
            <div class="detected-foods" id="detectedFoods" style="display: none;">
                <h4>감지된 음식</h4>
                <div id="detectedFoodsList"></div>
            </div>
            <div class="warnings-list" id="warningsList" style="display: none;">
                <h4><i class="fas fa-exclamation-triangle"></i> 주의사항</h4>
                <ul id="warningsUl"></ul>
            </div>
            <div class="recommendations-list" id="recommendationsList" style="display: none;">
                <h4><i class="fas fa-lightbulb"></i> 권장사항</h4>
                <ul id="recommendationsUl"></ul>
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
        
        // 촬영된 이미지 미리보기
        video.style.display = 'none';
        
        // 기존 이미지가 있으면 제거
        const existingImg = document.querySelector('#capturedImage');
        if (existingImg) {
            existingImg.remove();
        }
        
        // 새 이미지 생성 및 표시
        const img = document.createElement('img');
        img.src = capturedImage;
        img.style.width = '100%';
        img.style.height = 'auto';
        img.id = 'capturedImage';
        img.style.display = 'block';
        
        const preview = document.querySelector('.camera-preview');
        preview.appendChild(img);
        
        // 사진 촬영 후 자동으로 안전성 검사 시작
        setTimeout(function() {
            checkSafety();
        }, 300); // 약간의 지연을 두어 이미지가 완전히 로드되도록
    }

    function stopCamera() {
        if (stream) {
            stream.getTracks().forEach(track => track.stop());
            stream = null;
        }
        
        const video = document.getElementById('videoElement');
        video.srcObject = null;
        
        // 촬영된 이미지가 없으면 비디오 표시, 있으면 이미지 유지
        const capturedImg = document.querySelector('#capturedImage');
        if (!capturedImg) {
            video.style.display = 'block';
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
        const imageBase64 = capturedImage.split(',')[1]; // data:image/jpeg;base64, 부분 제거

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
        
        // 안전 수준에 따라 메시지 스타일 조정
        if (safetyLevel === 'DANGER') {
            messageElement.style.background = '#f8d7da';
            messageElement.style.color = '#721c24';
            messageElement.style.borderLeftColor = '#dc3545';
        } else if (safetyLevel === 'WARNING') {
            messageElement.style.background = '#fff3cd';
            messageElement.style.color = '#856404';
            messageElement.style.borderLeftColor = '#ffc107';
        } else {
            messageElement.style.background = '#d4edda';
            messageElement.style.color = '#155724';
            messageElement.style.borderLeftColor = '#28a745';
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

