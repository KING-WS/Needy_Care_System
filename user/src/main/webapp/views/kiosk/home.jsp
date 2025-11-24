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
    <header class="header-info">
        <div class="header-top-row">
            <div class="header-section section-left">
                <div class="info-widget">
                    <span id="weather-icon" class="weather-icon">⏳</span>
                    <span id="weather-text" style="font-size: 0.8em;">위치 확인 중..</span>
                </div>
            </div>
            <div class="header-section section-center">
                <div id="clock" class="info-widget kiosk-clock">--:--</div>
            </div>
            <div class="header-section section-right">
                <div class="status-indicator">
                    <div class="status-dot"></div>
                    <span>온라인</span>
                </div>
            </div>
        </div>
        <div class="header-main-row">
            <h1 class="recipient-name">${recipient.recName} 님</h1>
            <p id="greeting-text" class="welcome-text"></p>
        </div>
    </header>

    <main class="main-content">
        <section class="ai-companion-area">
            <div class="chat-window" id="chat-window"></div>
            <div class="chat-input-area">
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

    // ============================================================
    // 1. 전역 유틸리티 함수들
    // ============================================================

    // [개선된 기능] Google 목소리를 우선 사용하는 TTS 함수
    function speakText(text) {
        if (!window.speechSynthesis) {
            console.error("이 브라우저는 음성 합성을 지원하지 않습니다.");
            return;
        }

        // 말하고 있던 게 있다면 중단
        window.speechSynthesis.cancel();

        const utterance = new SpeechSynthesisUtterance(text);
        utterance.lang = 'ko-KR';
        utterance.rate = 1.0; // 속도 (어르신용이면 0.9 추천)
        utterance.pitch = 1.0;

        // [핵심] 브라우저에 있는 목소리 리스트를 가져옵니다.
        const voices = window.speechSynthesis.getVoices();

        // 'Google'이 포함된 한국어 목소리를 찾습니다. (이게 훨씬 자연스럽습니다)
        // 만약 없으면 그냥 아무 한국어 목소리나 씁니다.
        const googleVoice = voices.find(v => v.lang.includes('ko') && v.name.includes('Google'));
        const anyKoreanVoice = voices.find(v => v.lang.includes('ko'));

        if (googleVoice) {
            utterance.voice = googleVoice;
        } else if (anyKoreanVoice) {
            utterance.voice = anyKoreanVoice;
        }

        // 말하기 시작
        window.speechSynthesis.speak(utterance);
    }

    // [중요] 크롬은 목소리 리스트를 비동기로 가져오므로 이 이벤트가 필요합니다.
    if (window.speechSynthesis.onvoiceschanged !== undefined) {
        window.speechSynthesis.onvoiceschanged = function() {
            window.speechSynthesis.getVoices();
        };
    }

    // [음성 인식 STT]
    function startSpeechRecognition() {
        const SpeechRecognition = window.SpeechRecognition || window.webkitSpeechRecognition;
        if (!SpeechRecognition) {
            alert("이 브라우저는 음성 인식을 지원하지 않습니다.");
            return;
        }

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

    // 5. 호출 버튼 (실제 서버 API 호출 로직)
    function sendRequest(btn, type, text) {
        const feedback = btn.querySelector('.button-feedback');
        const content = btn.querySelector('.button-content');

        btn.disabled = true;
        content.style.opacity = '0';
        feedback.style.opacity = '1';
        feedback.textContent = '전송 중...';

        console.log(`🚨 알림 요청 발생: 타입=${type}, 키오스크 코드=${KIOSK_CODE}`);

        fetch('/api/alert/send', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ kioskCode: KIOSK_CODE, type: type })
        })
            .then(res => res.json())
            .then(data => {
                if (data.status === 'success') {
                    feedback.textContent = '요청 완료!';
                } else {
                    feedback.textContent = '요청 실패! 😥';
                    alert("알림 요청에 실패했습니다: " + data.message);
                }
            })
            .catch(err => {
                feedback.textContent = '연결 오류! 😥';
                alert("알림 서버 연결에 실패했습니다.");
            })
            .finally(() => {
                setTimeout(() => {
                    content.style.opacity = '1';
                    feedback.style.opacity = '0';
                    btn.disabled = false;
                }, 3000);
            });
    }

    // [채팅 메시지 UI 추가]
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
    // 2. 페이지 로드 후 실행되는 초기화 로직
    // ============================================================
    document.addEventListener('DOMContentLoaded', function() {

        // [초기화 1] 날씨 기능 실행
        function fetchWeather() {
            if (!navigator.geolocation) {
                document.getElementById('weather-text').textContent = "위치 권한 없음";
                return;
            }
            navigator.geolocation.getCurrentPosition(
                (position) => {
                    const lat = position.coords.latitude;
                    const lon = position.coords.longitude;

                    // Open-Meteo 호출
                    const weatherUrl = "https://api.open-meteo.com/v1/forecast?latitude=" + lat + "&longitude=" + lon + "&current=temperature_2m,weather_code&timezone=auto";
                    fetch(weatherUrl)
                        .then(res => res.ok ? res.json() : null)
                        .then(data => {
                            if (!data || !data.current) return;
                            document.getElementById('weather-icon').textContent = getWeatherEmoji(data.current.weather_code);
                            window.weatherState.temp = Math.round(data.current.temperature_2m);
                            updateWeatherUI();
                        }).catch(() => {});

                    // BigDataCloud 호출
                    const cityUrl = "https://api.bigdatacloud.net/data/reverse-geocode-client?latitude=" + lat + "&longitude=" + lon + "&localityLanguage=ko";
                    fetch(cityUrl)
                        .then(res => res.ok ? res.json() : null)
                        .then(data => {
                            if(!data) return;
                            let city = data.locality || data.city || data.principalSubdivision || "대한민국";
                            if (!city || city.trim() === "") city = "내 위치";
                            window.weatherState.city = city;
                            updateWeatherUI();
                        }).catch(() => {});
                },
                () => {
                    document.getElementById('weather-text').textContent = "위치 미수신";
                    document.getElementById('weather-icon').textContent = "❓";
                }
            );
        }
        fetchWeather();

        // [초기화 2] 시계 및 인사말
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

        // [초기화 3] 초기 메시지 & 음성 출력
        // *목소리가 로드될 시간을 주기 위해 약간의 지연(500ms) 후 첫 인사 실행
        setTimeout(() => {
            const initialMsg = '안녕하세요, ' + RECIPIENT_NAME + '님! 말벗 로봇 마음이에요.';
            addMessageToChat('bot', initialMsg);
            speakText(initialMsg);
        }, 500);

        // [초기화 4] 채팅 전송 이벤트 연결
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
                    speakText(replyText); // 답변 읽어주기
                })
                .catch(() => {
                    removeElement(loadingId);
                    const errorMsg = '죄송해요, 잠시 문제가 생겼어요.';
                    addMessageToChat('bot', errorMsg);
                    speakText(errorMsg);
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