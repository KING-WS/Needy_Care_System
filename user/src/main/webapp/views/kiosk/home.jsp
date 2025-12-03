<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=no">
    <title>키오스크 돌봄 시스템</title>
    <link rel="stylesheet" href="/css/kiosk.css">
    <style>
        /* 추가: 영상 통화 오버레이 스타일 */
        .video-call-overlay {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-color: #000;
            z-index: 1000;
            display: none; /* 평소에는 숨김 */
            flex-direction: column;
            justify-content: center;
            align-items: center;
        }
        #remoteVideoKiosk {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }
        #localVideoKiosk {
            position: absolute;
            bottom: 20px;
            right: 20px;
            width: 25%;
            max-width: 320px;
            height: auto;
            border: 2px solid white;
            border-radius: 10px;
        }
        #hangup-btn {
            position: absolute;
            bottom: 40px;
            left: 50%;
            transform: translateX(-50%);
            padding: 20px 40px;
            font-size: 2rem;
            background-color: #dc3545;
            color: white;
            border: none;
            border-radius: 50px;
            cursor: pointer;
            box-shadow: 0 5px 15px rgba(0,0,0,0.3);
        }
    </style>
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

<!-- 영상 통화 UI (숨겨져 있음) -->
<div id="video-call-overlay" class="video-call-overlay">
    <video id="remoteVideoKiosk" autoplay playsinline></video>
    <video id="localVideoKiosk" autoplay playsinline muted></video>
    <button id="hangup-btn">통화 종료</button>
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
            try {
                const msg = JSON.parse(event.data);
                if (msg.type === 'start_call' && msg.roomId) {
                    console.log(`영상 통화 시작 신호 수신. Room ID: ${msg.roomId}`);
                    startVideoCall(msg.roomId);
                }
            } catch (e) {
                console.error("메시지 처리 중 오류 발생:", e);
            }
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

        if (kioskWs && kioskWs.readyState === WebSocket.OPEN) {
            kioskWs.send(JSON.stringify({
                type: type === 'emergency' ? 'emergency' : 'contact_request',
                kioskCode: KIOSK_CODE
            }));

            // 👇 [추가] 긴급 호출이면 즉시 영상통화 화면(내 얼굴) 띄우기
            if (type === 'emergency') {
                console.log("🚨 긴급 호출: 영상통화 대기 모드 진입");
                // 방 번호는 kioskCode와 동일하게 사용
                // startVideoCall(KIOSK_CODE);
            }

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
    // 2. WebRTC 영상 통화 관련 로직
    // ============================================================
    const videoOverlay = document.getElementById('video-call-overlay');
    const localVideo = document.getElementById('localVideoKiosk');
    const remoteVideo = document.getElementById('remoteVideoKiosk');
    const hangupButton = document.getElementById('hangup-btn');

    let localStream = null;
    let peerConnection = null;
    let signalWs = null;
    let videoRoomId = null;

    const configuration = {
        iceServers: [
            { urls: 'stun:stun.l.google.com:19302' },
            { urls: 'stun:stun1.l.google.com:19302' }
        ]
    };

    function startVideoCall(roomId) {
        videoRoomId = roomId;
        videoOverlay.style.display = 'flex'; // 영상 통화 UI 표시
        joinVideoRoom();
    }

    hangupButton.onclick = leaveVideoRoom;

    async function joinVideoRoom() {
        if (!videoRoomId) return;

        const isReady = await prepareMediaAndConnection();
        if (!isReady) {
            alert('카메라 또는 마이크를 사용할 수 없습니다.');
            leaveVideoRoom();
            return;
        }

        const protocol = window.location.protocol === 'https:' ? 'wss:' : 'ws:';
        const wsUrl = protocol + '//' + window.location.host + '/signal';
        console.log("WebRTC 시그널링 서버에 연결:", wsUrl);

        signalWs = new WebSocket(wsUrl);

        signalWs.onopen = async () => {
            console.log('WebRTC 시그널링 연결 성공');
            // 1. 입장 신호만 보냄 (전화 걸지 않음!)
            signalWs.send(JSON.stringify({ type: 'join', roomId: videoRoomId }));
            console.log("입장 완료. 대기 중...");
        };

        signalWs.onmessage = async (message) => {
            const signal = JSON.parse(message.data);
            console.log('시그널 수신:', signal);

            switch (signal.type) {
                case 'join':
                    // [수정] 누군가(관리자) 들어왔다! 내가 먼저 와 있었으니 Offer를 보낸다.
                    console.log('관리자 입장 확인. Offer 생성 및 전송...');
                    break;
                case 'offer':
                    console.log('Offer 수신');
                    await peerConnection.setRemoteDescription(new RTCSessionDescription(signal.data));
                    const answer = await peerConnection.createAnswer();
                    await peerConnection.setLocalDescription(answer);
                    signalWs.send(JSON.stringify({ type: 'answer', data: peerConnection.localDescription, roomId: videoRoomId }));
                    break;
                case 'answer':
                    console.log('Answer 수신');
                    await peerConnection.setRemoteDescription(new RTCSessionDescription(signal.data));
                    break;
                case 'ice-candidate':
                    if (signal.data) {
                        try {
                            await peerConnection.addIceCandidate(new RTCIceCandidate(signal.data));
                        } catch (e) {
                            console.error('ICE Candidate 추가 오류', e);
                        }
                    }
                    break;
                case 'bye':
                    console.log('상대방이 통화를 종료했습니다.');
                    leaveVideoRoom();
                    break;
            }
        };

        signalWs.onerror = (error) => {
            console.error('시그널링 WebSocket 오류:', error);
            leaveVideoRoom();
        };
    }

    async function prepareMediaAndConnection() {
        try {
            localStream = await navigator.mediaDevices.getUserMedia({ video: true, audio: true });
            localVideo.srcObject = localStream;

            peerConnection = new RTCPeerConnection(configuration);

            peerConnection.onicecandidate = (event) => {
                if (event.candidate && signalWs && signalWs.readyState === WebSocket.OPEN) {
                    signalWs.send(JSON.stringify({ type: 'ice-candidate', data: event.candidate, roomId: videoRoomId }));
                }
            };

            peerConnection.ontrack = (event) => {
                console.log("상대방 스트림 수신");
                remoteVideo.srcObject = event.streams[0];

                remoteVideo.play().catch(e => console.error("영상 자동 재생 실패:", e));
            };

            localStream.getTracks().forEach(track => {
                peerConnection.addTrack(track, localStream);
            });

            return true;
        } catch (e) {
            console.error('미디어 스트림 획득 오류:', e);
            return false;
        }
    }

    function leaveVideoRoom() {
        if (signalWs) {
            if (signalWs.readyState === WebSocket.OPEN) {
                signalWs.send(JSON.stringify({ type: 'bye', roomId: videoRoomId }));
            }
            signalWs.close();
            signalWs = null;
        }

        if (peerConnection) {
            peerConnection.close();
            peerConnection = null;
        }

        if (localStream) {
            localStream.getTracks().forEach(track => track.stop());
            localStream = null;
        }

        localVideo.srcObject = null;
        remoteVideo.srcObject = null;
        videoOverlay.style.display = 'none'; // 영상 통화 UI 숨김
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