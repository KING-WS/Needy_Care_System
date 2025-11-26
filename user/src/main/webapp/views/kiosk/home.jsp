<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=no">
    <title>키오스크 돌봄 시스템</title>
    <link rel="stylesheet" href="/css/kiosk.css">
</head>

<body>

<div class="kiosk-wrapper">
    <!-- 상단 헤더 -->
    <header class="header-info">
        <div class="header-top-row">
            <!-- 날씨 -->
            <div class="header-section section-left">
                <div class="info-widget">
                    <span id="weather-icon" class="weather-icon">⏳</span>
                    <span id="weather-text" style="font-size: 0.8em;">위치 확인 중..</span>
                </div>
            </div>
            <!-- 시계 -->
            <div class="header-section section-center">
                <div id="clock" class="info-widget kiosk-clock">--:--</div>
            </div>
            <!-- 상태 -->
            <div class="header-section section-right">
                <div class="status-indicator">
                    <div id="status-dot" class="status-dot"></div> <!-- id="status-dot" 확인 -->
                    <span id="status-text">연결 중...</span> <!-- id="status-text" 확인 -->
                </div>
            </div>
        </div>
        <!-- 인사말 -->
        <div class="header-main-row">
            <h1 class="recipient-name">${recipient.recName} 님</h1>
            <p id="greeting-text" class="welcome-text"></p>
        </div>
    </header>

    <!-- 메인 컨텐츠 -->
    <main class="main-content">
        <!-- AI 채팅 -->
        <section class="ai-companion-area">
            <div class="chat-window" id="chat-window"></div>
            <div class="chat-input-area">
                <!-- onclick에서 호출하는 함수는 전역 스코프에 있어야 함 -->
                <button class="speak-button" onclick="startSpeechRecognition()">
                    <span style="font-size: 3rem;">🎤</span>
                    <span>음성으로 말하기</span>
                </button>
                <div class="input-group">
                    <input type="text" id="chat-text-input" class="text-input" placeholder="여기에 직접 입력하세요...">
                    <button class="send-button" id="chat-send-btn">전송</button>
                </div>
            </div>
        </section>

        <!-- 긴급 호출 -->
        <section class="call-button-area">
            <button id="emergency-btn" class="call-button emergency" onclick="sendRequest(this, 'emergency', '긴급 호출')">
                <div class="button-content">
                    <span class="button-icon">🚨</span>
                    <span class="button-text">긴급 호출</span>
                </div>
                <div class="button-feedback"></div>
            </button>
            <button id="contact-btn" class="call-button contact" onclick="sendRequest(this, 'contact', '연락 요청')">
                <div class="button-content">
                    <span class="button-icon">📞</span>
                    <span class="button-text">연락 요청</span>
                </div>
                <div class="button-feedback"></div>
            </button>
        </section>
    </main>
</div>

<script>
    // [중요] 전역 변수 설정 (모든 함수에서 접근 가능하도록)
    const KIOSK_CODE = "${kioskCode}";
    const RECIPIENT_NAME = "${recipient.recName}";

    // 날씨 상태 저장용 객체
    window.weatherState = { temp: null, city: null };

    // WebSocket 관련 변수
    let kioskWs = null;
    let reconnectInterval = null;

    // ============================================================
    // 1. 전역 유틸리티 함수들 (HTML onclick에서 호출 가능)
    // ============================================================

    // [NEW] WebSocket 연결 함수
    function connectKioskWebSocket() {
        if (kioskWs && (kioskWs.readyState === WebSocket.OPEN || kioskWs.readyState === WebSocket.CONNECTING)) {
            return;
        }

        // HTTPS 환경 고려 (wss://)
        const protocol = window.location.protocol === 'https:' ? 'wss:' : 'ws:';
        const wsUrl = protocol + '//' + window.location.host + '/ws/kiosk';


        kioskWs = new WebSocket(wsUrl);

        kioskWs.onopen = function() {
            console.log('✅ Kiosk WebSocket 연결 성공');

            // UI 업데이트 (초록불)
            const statusDot = document.getElementById('status-dot');
            const statusText = document.getElementById('status-text');
            if (statusDot && statusText) {
                statusDot.className = 'status-dot online';
                statusText.textContent = '온라인';
                statusDot.style.backgroundColor = '#28a745'; // 확실하게 색상 지정
            }

            if(reconnectInterval) {
                clearInterval(reconnectInterval); // 재연결 시도 중지
                reconnectInterval = null;
            }

            // [핵심 수정] 서버 핸들러가 'kiosk_connect'를 기다리고 있습니다. ('register' -> 'kiosk_connect')
            kioskWs.send(JSON.stringify({
                type: 'kiosk_connect',
                kioskCode: KIOSK_CODE
            }));
        };

        kioskWs.onmessage = function(event) {
            console.log('메시지 수신:', event.data);
        };

        kioskWs.onclose = function(event) {
            console.warn('⚠️ WebSocket 연결 끊김');

            // UI 업데이트 (빨간불)
            const statusDot = document.getElementById('status-dot');
            const statusText = document.getElementById('status-text');
            if (statusDot && statusText) {
                statusDot.className = 'status-dot offline';
                statusText.textContent = '연결 끊김';
                statusDot.style.backgroundColor = '#dc3545'; // 확실하게 색상 지정
            }

            kioskWs = null;

            // 3초마다 재연결 시도
            if (!reconnectInterval) {
                reconnectInterval = setInterval(connectKioskWebSocket, 3000);
            }
        };

        kioskWs.onerror = function(error) {
            console.error('WebSocket 에러:', error);
            kioskWs.close(); // 에러 발생 시 명시적으로 닫고 재연결 유도
        };
    }

    // [TTS (음성 합성)]
    function speakText(text) {
        if (!window.speechSynthesis) return;
        window.speechSynthesis.cancel();

        const utterance = new SpeechSynthesisUtterance(text);
        utterance.lang = 'ko-KR';
        utterance.rate = 0.9;

        const voices = window.speechSynthesis.getVoices();
        const korVoice = voices.find(v => v.lang.includes('ko'));
        if (korVoice) utterance.voice = korVoice;

        window.speechSynthesis.speak(utterance);
    }

    // [음성 인식 STT]
    function startSpeechRecognition() {
        const SpeechRecognition = window.SpeechRecognition || window.webkitSpeechRecognition;
        if (!SpeechRecognition) {
            alert("이 브라우저는 음성 인식을 지원하지 않습니다.");
            return;
        }

        // TTS 중단 (말 겹침 방지)
        window.speechSynthesis.cancel();

        const recognition = new SpeechRecognition();
        const speakBtn = document.querySelector('.speak-button');
        const speakTextElem = speakBtn.querySelector('span:last-child');

        recognition.lang = 'ko-KR';
        recognition.interimResults = false;
        recognition.maxAlternatives = 1;

        recognition.onstart = function() {
            speakBtn.classList.add('listening');
            speakTextElem.textContent = "듣고 있어요...";
        };

        recognition.onend = function() {
            speakBtn.classList.remove('listening');
            speakTextElem.textContent = "음성으로 말하기";
        };

        recognition.onresult = function(event) {
            const transcript = event.results[0][0].transcript;
            const chatInput = document.getElementById('chat-text-input');
            chatInput.value = transcript;
            // 0.5초 뒤 전송 버튼 클릭 트리거
            setTimeout(() => { document.getElementById('chat-send-btn').click(); }, 500);
        };

        recognition.onerror = function(event) {
            speakBtn.classList.remove('listening');
            speakTextElem.textContent = "음성으로 말하기";
            if (event.error !== 'no-speech') alert("오류: " + event.error);
        };

        recognition.start();
    }

    // [호출 버튼]
    function sendRequest(btn, type, text) {
        const feedback = btn.querySelector('.button-feedback');
        const content = btn.querySelector('.button-content');

        btn.disabled = true;
        content.style.opacity = '0';
        feedback.style.opacity = '1';
        feedback.textContent = '전송 중...';

        // [수정] 웹소켓으로만 전송 (이게 DB저장 + 알림 다 처리함)
        if (kioskWs && kioskWs.readyState === WebSocket.OPEN) {
            kioskWs.send(JSON.stringify({
                type: type === 'emergency' ? 'emergency' : 'contact_request',
                kioskCode: KIOSK_CODE
            }));

            // [추가] 전송 성공 UI 처리 (1초 뒤 복구)
            setTimeout(() => {
                feedback.textContent = '호출 완료!';
                setTimeout(() => {
                    content.style.opacity = '1';
                    feedback.style.opacity = '0';
                    btn.disabled = false;
                }, 2000);
            }, 1000);

        } else {
            // 연결 안 된 경우 에러 표시
            feedback.textContent = '연결 오류';
            setTimeout(() => {
                content.style.opacity = '1';
                feedback.style.opacity = '0';
                btn.disabled = false;
            }, 2000);
        }
    }


    // [채팅 메시지 추가]
    function addMessageToChat(sender, text, id = null) {
        const chatWindow = document.getElementById('chat-window');
        const div = document.createElement('div');
        div.className = 'chat-message ' + (sender === 'user' ? 'user-message' : 'bot-message');
        if (id) div.id = id;

        const bubble = document.createElement('div');
        bubble.className = 'message-bubble';
        bubble.textContent = text;

        const timeSpan = document.createElement('span');
        timeSpan.className = 'message-time';
        const now = new Date();
        const ampm = now.getHours() >= 12 ? '오후' : '오전';
        const h = now.getHours() % 12 ? now.getHours() % 12 : 12;
        timeSpan.textContent = ampm + " " + h + ":" + String(now.getMinutes()).padStart(2, '0');

        div.appendChild(bubble);
        div.appendChild(timeSpan);
        chatWindow.appendChild(div);
        chatWindow.scrollTop = chatWindow.scrollHeight;

        // 봇 메시지는 읽어주기 (TTS)
        if (sender === 'bot' && text !== '생각 중이에요...') {
            speakText(text);
        }
    }

    // [로딩 제거]
    function removeElement(id) {
        const el = document.getElementById(id);
        if (el) el.remove();
    }

    // [날씨 UI 업데이트]
    function updateWeatherUI() {
        const textEl = document.getElementById('weather-text');
        const { temp, city } = window.weatherState;

        if (city && temp !== null) textEl.textContent = city + ", " + temp + "°C";
        else if (city) textEl.textContent = city;
        else if (temp !== null) textEl.textContent = "현재 위치, " + temp + "°C";
    }

    function getWeatherEmoji(code) {
        if (code === 0) return '☀️';
        if (code >= 1 && code <= 3) return '⛅';
        if (code >= 45) return '☁️';
        if (code >= 51) return '☔';
        return '🌈';
    }


    // ============================================================
    // 3. 페이지 로드 후 실행되는 초기화 로직 (DOMContentLoaded)
    // ============================================================
    document.addEventListener('DOMContentLoaded', function() {

        // [초기화 1] WebSocket 연결 실행
        connectKioskWebSocket();

        function fetchWeatherAndLocation() {
            if (!navigator.geolocation) {
                document.getElementById('weather-text').textContent = "위치 권한 없음";
                return;
            }
            navigator.geolocation.getCurrentPosition(
                (position) => {
                    const lat = position.coords.latitude;
                    const lon = position.coords.longitude;

                    // --- 날씨 정보 가져오기 ---
                    // Open-Meteo 호출
                    const weatherUrl = "https://api.open-meteo.com/v1/forecast?latitude=" + lat + "&longitude=" + lon + "&current=temperature_2m,weather_code&timezone=auto";
                    fetch(weatherUrl)
                        .then(res => res.ok ? res.json() : Promise.reject('Weather API failed'))
                        .then(data => {
                            if (!data || !data.current) return;
                            document.getElementById('weather-icon').textContent = getWeatherEmoji(data.current.weather_code);
                            window.weatherState.temp = Math.round(data.current.temperature_2m);
                            updateWeatherUI();
                        }).catch(() => {});

                    // BigDataCloud 호출
                    const cityUrl = "https://api.bigdatacloud.net/data/reverse-geocode-client?latitude=" + lat + "&longitude=" + lon + "&localityLanguage=ko";
                    fetch(cityUrl)
                        .then(res => res.ok ? res.json() : Promise.reject('City API failed'))
                        .then(data => {
                            if(!data) return;
                            let city = data.locality || data.city || data.principalSubdivision || "대한민국";
                            if (!city || city.trim() === "") city = "내 위치";
                            window.weatherState.city = city;
                            updateWeatherUI();
                        }).catch(() => {});
                    
                    // --- 위치 정보 전송 ---
                    sendLocationUpdate(lat, lon);
                },
                () => {
                    document.getElementById('weather-text').textContent = "위치 미수신";
                    document.getElementById('weather-icon').textContent = "❓";
                }
            );
        }

        // [수정] 위치 정보만 주기적으로 전송하는 함수
        function sendLocationUpdate(lat, lon) {
             if (kioskWs && kioskWs.readyState === WebSocket.OPEN) {
                kioskWs.send(JSON.stringify({
                    type: "location_update",
                    kioskCode: KIOSK_CODE,
                    latitude: lat.toString(),
                    longitude: lon.toString()
                }));

            }
        }
        
        // [수정] 주기적으로 위치를 가져와 전송하는 로직
        function periodicLocationSender() {
             if (!navigator.geolocation) return;
             navigator.geolocation.getCurrentPosition(
                (position) => {
                    sendLocationUpdate(position.coords.latitude, position.coords.longitude);
                },
                () => {
                    console.warn("Could not get location for periodic update.");
                },
                { enableHighAccuracy: true, timeout: 10000, maximumAge: 0 }
            );
        }

        // [수정] 초기 날씨/위치 로드 후, 10초마다 위치 전송
        fetchWeatherAndLocation();
        setInterval(periodicLocationSender, 10000); // 10초마다 위치 전송

        // [초기화 3] 시계 및 인사말
        const clockElement = document.getElementById('clock');
        const greetingElement = document.getElementById('greeting-text');

        function updateClockAndGreeting() {
            const now = new Date();
            const hours = now.getHours();
            const minutes = String(now.getMinutes()).padStart(2, '0');
            const ampm = hours >= 12 ? '오후' : '오전';
            const displayHours = hours % 12 ? hours % 12 : 12;

            if (clockElement) clockElement.textContent = ampm + " " + displayHours + ":" + minutes;

            if (greetingElement) {
                greetingElement.textContent = "안녕하세요! 무엇을 도와드릴까요?";
            }
        }
        setInterval(updateClockAndGreeting, 1000);
        updateClockAndGreeting();

        // [초기화 4] 채팅 초기 메시지
        const initMsg = '안녕하세요, ' + RECIPIENT_NAME + '님! 말벗 로봇 마음이에요.';
        addMessageToChat('bot', initMsg);

        // [초기화 5] 채팅 전송 이벤트 연결
        const chatInput = document.getElementById('chat-text-input');
        const sendBtn = document.getElementById('chat-send-btn');

        function handleSendMessage() {
            const message = chatInput.value.trim();
            if (!message) return;

            addMessageToChat('user', message);
            chatInput.value = '';

            const loadingId = 'loading-ai';
            addMessageToChat('bot', '생각 중이에요...', loadingId);

            fetch('/api/chat/ai/send', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ message: message, kioskCode: KIOSK_CODE })
            })
                .then(res => res.json())
                .then(data => {
                    removeElement(loadingId);
                    const replyText = data.reply || data.response || "응답을 받지 못했습니다.";
                    addMessageToChat('bot', replyText);
                })
                .catch(() => {
                    removeElement(loadingId);
                    addMessageToChat('bot', '죄송해요, 잠시 문제가 생겼어요.');
                });
        }

        if(sendBtn) sendBtn.addEventListener('click', handleSendMessage);
        if(chatInput) chatInput.addEventListener('keypress', (e) => {
            if (e.key === 'Enter') handleSendMessage();
        });
    });
</script>

</body>
</html>