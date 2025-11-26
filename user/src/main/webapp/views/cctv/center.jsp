<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<style>
    /* 위험 경보 스타일 */
    #alert-box {
        font-size: 1.8em;
        font-weight: bold;
        padding: 15px;
        border-radius: 8px;
        display: none; /* 평소에는 숨김 */
        margin-top: 15px;
    }

    /* 위험 감지 시 활성화될 스타일 */
    .alert-active {
        background-color: #dc3545; /* 빨간색 배경 */
        color: white;
        display: block !important; /* 보이도록 설정 */
        animation: blinker 1s linear infinite; /* 깜빡임 효과 */
    }

    /* 평상시 활동 상태 */
    #activity-status {
        font-size: 1.5em;
        color: #333;
        font-weight: bold;
    }

    /* 깜빡임 애니메이션 */
    @keyframes blinker {
        50% {
            opacity: 0.5;
        }
    }
</style>

<script>
    // CCTV 모니터링 로직 (WebRTC 수신 버전)
    const cctvMonitor = {
        analysisInterval: null,
        peerConnection: null,
        signalSocket: null,
        targetRoomId: "${targetKioskCode}", // 컨트롤러에서 넘겨준 키오스크 코드

        init: function () {
            console.log("cctvMonitor: WebRTC 수신 모드로 초기화합니다.");

            // 1. WebRTC 연결 시작
            this.startWebRTC();

            // 2. 5초마다 AI 분석 (기존 로직 유지)
            console.log("cctvMonitor: 5초 간격으로 프레임 캡처 및 전송을 시작합니다.");
            this.analysisInterval = setInterval(() => {
                // video 태그에 키오스크 영상이 나오고 있으면 그걸 캡처함
                this.captureFrame("video", (pngBlob) => {
                    this.send(pngBlob);
                });
            }, 5000);
        },

        startWebRTC: function() {
            const SIGNALING_URL = (location.protocol === 'https:' ? 'wss://' : 'ws://') + location.host + "/signal";
            this.signalSocket = new WebSocket(SIGNALING_URL);

            this.signalSocket.onopen = () => {
                console.log("[Receiver] 소켓 연결됨. 방 입장:", this.targetRoomId);
                // 방 입장 (이걸 보내면 키오스크 쪽 cam.jsp가 반응해서 offer를 보냄)
                this.signalSocket.send(JSON.stringify({ type: 'join', roomId: this.targetRoomId }));
            };

            this.signalSocket.onmessage = async (event) => {
                const msg = JSON.parse(event.data);

                if (msg.type === 'offer') {
                    console.log("[Receiver] Offer 수신. 응답 준비.");
                    await this.createAnswer(msg.sdp);
                }
                else if (msg.type === 'ice-candidate') {
                    if (this.peerConnection && msg.candidate) {
                        await this.peerConnection.addIceCandidate(new RTCIceCandidate(msg.candidate));
                    }
                }
            };
        },

        createAnswer: async function(offerSdp) {
            const rtcConfig = { iceServers: [{ urls: 'stun:stun.l.google.com:19302' }] };
            this.peerConnection = new RTCPeerConnection(rtcConfig);

            // 영상 트랙이 들어오면 화면(<video>)에 연결
            this.peerConnection.ontrack = (event) => {
                console.log("[Receiver] 영상 스트림 수신 성공!");
                const video = document.getElementById('video');
                video.srcObject = event.streams[0];
                video.play().catch(e => console.error("비디오 재생 실패", e));
            };

            // ICE Candidate 발생 시 서버로 전송
            this.peerConnection.onicecandidate = (event) => {
                if (event.candidate) {
                    this.signalSocket.send(JSON.stringify({
                        type: 'ice-candidate',
                        candidate: event.candidate,
                        roomId: this.targetRoomId
                    }));
                }
            };

            await this.peerConnection.setRemoteDescription(new RTCSessionDescription(offerSdp));
            const answer = await this.peerConnection.createAnswer();
            await this.peerConnection.setLocalDescription(answer);

            // Answer 전송
            this.signalSocket.send(JSON.stringify({
                type: 'answer',
                sdp: answer,
                roomId: this.targetRoomId
            }));
        },

        // --- 아래는 기존 AI 분석용 코드 (변경 없음) ---
        captureFrame: function (videoId, handleFrame) {
            const video = document.getElementById(videoId);
            if (!video || !video.srcObject || video.videoWidth === 0 || video.videoHeight === 0) return;

            const canvas = document.createElement('canvas');
            canvas.width = video.videoWidth;
            canvas.height = video.videoHeight;
            const context = canvas.getContext('2d');
            context.drawImage(video, 0, 0, canvas.width, canvas.height);
            canvas.toBlob((blob) => {
                handleFrame(blob);
            }, 'image/png');
        },

        send: async function (pngBlob) {
            if (!pngBlob) return;
            const formData = new FormData();
            formData.append('attach', pngBlob, 'frame.png');

            try {
                const response = await fetch('/cctv/analyze', { method: "post", body: formData });
                if (response.ok) {
                    const result = await response.json();
                    this.updateDisplay(result);
                } else {
                    this.updateDisplay({ activity: "상태 분석 실패", alert: "없음" });
                }
            } catch (error) {
                this.updateDisplay({ activity: "연결 오류", alert: "없음" });
            }
        },

        updateDisplay: function(result) {
            const statusEl = $('#activity-status');
            const alertEl = $('#alert-box');

            if (result.activity) statusEl.text(result.activity);
            else statusEl.text("---");

            if (result.alert && result.alert !== "없음" && result.alert !== null) {
                alertEl.text(result.alert);
                alertEl.addClass('alert-active');
            } else {
                alertEl.text('');
                alertEl.removeClass('alert-active');
            }
        }
    }

    // DOM이 준비되면 실행
    $(() => {
        cctvMonitor.init();
    });
</script>


<style>
    /* 컨텐츠 중앙 정렬 및 여백 조정 */
    section > .container-fluid {
        max-width: 1400px;
        margin: 0 auto;
        padding: 0 40px;
    }
    
    @media (max-width: 1200px) {
        section > .container-fluid {
            padding: 0 30px;
        }
    }
    
    @media (max-width: 768px) {
        section > .container-fluid {
            padding: 0 20px;
        }
    }
</style>

<section style="padding: 20px 0 100px 0;">
    <div class="container-fluid">
        <div class="row">
            <div class="col-12 mb-4">
                <h1 style="font-size: 36px; font-weight: bold; color: var(--secondary-color);">
                    <i class="fas fa-video"></i> 실시간 모니터링
                </h1>
                <p style="font-size: 16px; color: #666; margin-top: 10px;">
                    ${sessionScope.loginUser.custName}님의 CCTV | AI가 실시간으로 상황을 분석합니다.
                </p>
            </div>
        </div>

        <div class="row">
            <div class="col-12">
                <div class="text-center">
                    <div id="activity-status">분석 대기 중...</div>
                    <div id="alert-box"></div> </div>
                <hr>
                <div class="container p-3 my-3 border">
                    <div class="row">
                        <div class="col-12 text-center">
                            <video id="video" style="max-width: 100%; height: auto; border-radius: 8px;" autoplay muted playsinline></video>
                        </div>
                    </div>
                </div>

        </div>
    </div>
</section>