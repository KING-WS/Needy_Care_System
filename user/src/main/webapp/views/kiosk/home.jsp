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
                    <span class="weather-icon">☀️</span>
                    <span>맑음, 23°C</span>
                </div>
            </div>

            <div class="header-section section-center">
                <!-- 기존 시계 로직 유지 -->
                <div id="clock" class="info-widget kiosk-clock">오후 12:00</div>
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
            <p class="welcome-text">안녕하세요! 무엇을 도와드릴까요?</p>
        </div>
    </header>

    <main class="main-content">
        <section class="ai-companion-area">
            <div class="chat-window" id="chat-window">
                <!-- 스크립트에서 초기 메시지 추가됨 -->
            </div>
            <div class="chat-input-area">
                <!-- 음성 인식 버튼 -->
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
    document.addEventListener('DOMContentLoaded', function() {
        const KIOSK_CODE = "${kioskCode}";
        const RECIPIENT_NAME = "${recipient.recName}";

        // 1. 시계 기능 (기존 로직 유지)
        const clockElement = document.getElementById('clock');
        function updateClock() {
            if (clockElement) {
                const now = new Date();
                let hours = now.getHours();
                const minutes = String(now.getMinutes()).padStart(2, '0');

                const ampm = hours >= 12 ? '오후' : '오전';
                hours = hours % 12;
                hours = hours ? hours : 12;

                clockElement.textContent = ampm + " " + hours + ":" + minutes;
            }
        }
        setInterval(updateClock, 1000);
        updateClock();

        // 초기 봇 메시지 (기존 로직 유지)
        addMessageToChat('bot', '안녕하세요, ' + RECIPIENT_NAME + '님! 오늘 기분은 어떠세요?');

        // 2. 채팅 기능 (기존 로직 유지)
        const chatInput = document.getElementById('chat-text-input');
        const sendBtn = document.getElementById('chat-send-btn');

        function handleSendMessage() {
            const message = chatInput.value.trim();
            if (!message) return;

            addMessageToChat('user', message);
            chatInput.value = '';

            const loadingMessageId = 'loading-ai-response';
            addMessageToChat('bot', 'AI 응답을 생성 중입니다...', loadingMessageId);

            fetch('/api/chat/ai/send', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({
                    message: message,
                    kioskCode: KIOSK_CODE
                }),
            })
                .then(response => response.json())
                .then(data => {
                    removeMessageFromChat(loadingMessageId);
                    addMessageToChat('bot', data.response || data.reply); // DTO 필드명 호환
                })
                .catch(error => {
                    removeMessageFromChat(loadingMessageId);
                    addMessageToChat('bot', '오류 발생: ' + error.message);
                    console.error('AI 메시지 전송 중 오류 발생:', error);
                });
        }

        if(sendBtn) {
            sendBtn.addEventListener('click', handleSendMessage);
        }

        if(chatInput) {
            chatInput.addEventListener('keypress', function(e) {
                if (e.key === 'Enter') {
                    handleSendMessage();
                }
            });
        }
    });

    // 3. 호출 버튼 기능 (기존 로직 유지)
    function sendRequest(button, type, text) {
        console.log("호출 요청 발생: 타입=" + type);
        const content = button.querySelector('.button-content');
        const feedback = button.querySelector('.button-feedback');

        content.style.opacity = '0';
        feedback.textContent = '전송 중...';
        feedback.style.opacity = '1';
        button.disabled = true;

        setTimeout(() => { feedback.textContent = '전송 완료 ✓'; }, 2000);
        setTimeout(() => {
            content.style.opacity = '1';
            feedback.style.opacity = '0';
            button.disabled = false;
        }, 4000);
    }

    // 4. [수정됨] 음성 인식 (STT) 기능 구현
    function startSpeechRecognition() {
        const SpeechRecognition = window.SpeechRecognition || window.webkitSpeechRecognition;

        if (!SpeechRecognition) {
            alert("이 브라우저는 음성 인식을 지원하지 않습니다. (크롬 권장)");
            return;
        }

        const recognition = new SpeechRecognition();
        const speakBtn = document.querySelector('.speak-button');
        const speakText = speakBtn.querySelector('span:last-child');

        recognition.lang = 'ko-KR'; // 한국어
        recognition.interimResults = false; // 최종 결과만
        recognition.maxAlternatives = 1;

        recognition.onstart = function() {
            console.log("음성 인식 시작...");
            speakBtn.classList.add('listening'); // CSS 애니메이션
            speakText.textContent = "듣고 있어요...";
        };

        recognition.onend = function() {
            console.log("음성 인식 종료.");
            speakBtn.classList.remove('listening');
            speakText.textContent = "음성으로 말하기";
        };

        recognition.onresult = function(event) {
            const transcript = event.results[0][0].transcript;
            console.log("인식된 문장: " + transcript);

            const chatInput = document.getElementById('chat-text-input');
            chatInput.value = transcript;

            // 인식 후 0.5초 뒤 자동 전송 (버튼 클릭 트리거)
            setTimeout(() => {
                document.getElementById('chat-send-btn').click();
            }, 500);
        };

        recognition.onerror = function(event) {
            console.error("음성 인식 에러:", event.error);
            speakBtn.classList.remove('listening');
            speakText.textContent = "음성으로 말하기";

            if (event.error === 'no-speech') {
                alert("말씀이 없으셔서 종료되었어요. 다시 버튼을 눌러주세요.");
            } else {
                alert("오류가 발생했습니다: " + event.error);
            }
        };

        recognition.start();
    }

    // 5. 채팅창 메시지 추가 (기존 로직 유지)
    function addMessageToChat(sender, message, messageId = null) {
        const chatWindow = document.getElementById('chat-window');
        const messageType = sender === 'user' ? 'user-message' : 'bot-message';

        const messageDiv = document.createElement('div');
        messageDiv.className = 'chat-message ' + messageType;
        if (messageId) messageDiv.id = messageId;

        const bubble = document.createElement('div');
        bubble.className = 'message-bubble';
        bubble.textContent = message;

        const time = document.createElement('span');
        time.className = 'message-time';

        const now = new Date();
        let hours = now.getHours();
        const minutes = String(now.getMinutes()).padStart(2, '0');
        const ampm = hours >= 12 ? '오후' : '오전';
        hours = hours % 12;
        hours = hours ? hours : 12;
        time.textContent = ampm + " " + hours + ":" + minutes;

        messageDiv.appendChild(bubble);
        messageDiv.appendChild(time);
        chatWindow.appendChild(messageDiv);
        chatWindow.scrollTop = chatWindow.scrollHeight;
    }

    // 6. 로딩 메시지 제거 함수 (기존 로직 유지)
    function removeMessageFromChat(messageId) {
        const messageElement = document.getElementById(messageId);
        if (messageElement) messageElement.remove();
    }
</script>

</body>
</html>