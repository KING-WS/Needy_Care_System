<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<style>
    #alert-box {
        font-size: 1.5em; font-weight: bold; padding: 15px; border-radius: 8px;
        display: none; margin-top: 15px; text-align: center;
    }
    .alert-active {
        background-color: #dc3545; color: white; display: block !important;
        animation: blinker 1s linear infinite;
    }
    #activity-status { font-size: 1.2em; color: #333; font-weight: bold; }
    @keyframes blinker { 50% { opacity: 0.5; } }

    /* 비디오 컨테이너 스타일 */
    .video-container { margin-bottom: 20px; border: 1px solid #ddd; padding: 10px; border-radius: 8px; }
    .video-label { font-size: 1.1em; font-weight: bold; margin-bottom: 5px; display: block;}
    video { width: 100%; height: auto; border-radius: 5px; background: #000; }
</style>

<section style="padding: 20px 0;">
    <div class="container-fluid" style="max-width: 1400px; margin: 0 auto;">
        <!-- 헤더 -->
        <div class="row mb-4">
            <div class="col-12">
                <h1 style="font-size: 28px; font-weight: bold;">
                    <i class="fas fa-video"></i> 다중 모니터링
                </h1>
                <div id="activity-status">시스템 가동 중...</div>
                <div id="alert-box"></div>
            </div>
        </div>

        <!-- 비디오 영역 (2개 배치) -->
        <div class="row">
            <!-- CCTV 1번 -->
            <div class="col-md-6">
                <div class="video-container">
                    <span class="video-label">📺 CCTV 1 (거실)</span>
                    <video id="video1" autoplay muted playsinline></video>
                </div>
            </div>
            <!-- CCTV 2번 -->
            <div class="col-md-6">
                <div class="video-container">
                    <span class="video-label">📺 CCTV 2 (안방)</span>
                    <video id="video2" autoplay muted playsinline></video>
                </div>
            </div>
        </div>
    </div>
</section>

<script>
    // WebRTC 연결을 생성하는 클래스 (복사해서 여러 개 쓰기 위함)
    class CCTVViewer {
        constructor(videoId, roomId) {
            this.videoId = videoId;
            this.roomId = roomId;
            this.peerConnection = null;
            this.signalSocket = null;
            this.SIGNALING_URL = (location.protocol === 'https:' ? 'wss://' : 'ws://') + location.host + "/signal";
        }

        start() {
            if (!this.roomId) {
                // [수정] JSP 파싱 오류 방지를 위해 문자열 연결(+) 사용
                console.error('[' + this.videoId + '] 방 번호가 없습니다.');
                return;
            }
            // [수정] JSP 파싱 오류 방지를 위해 문자열 연결(+) 사용
            console.log('[' + this.videoId + '] 연결 시작 (Room: ' + this.roomId + ')');

            this.signalSocket = new WebSocket(this.SIGNALING_URL);

            this.signalSocket.onopen = () => {
                // "나 들어왔어!" (Receiver Join)
                this.signalSocket.send(JSON.stringify({ type: 'join', roomId: this.roomId }));
            };

            this.signalSocket.onmessage = async (event) => {
                const msg = JSON.parse(event.data);

                // CCTV(Sender)가 보낸 초대장(Offer) 도착
                if (msg.type === 'offer') {
                    // [수정] JSP 파싱 오류 방지를 위해 문자열 연결(+) 사용
                    console.log('[' + this.videoId + '] Offer 수신');
                    await this.createAnswer(msg.sdp);
                }
                // 연결 경로 후보(Candidate) 도착
                else if (msg.type === 'ice-candidate') {
                    if (this.peerConnection && msg.candidate) {
                        await this.peerConnection.addIceCandidate(new RTCIceCandidate(msg.candidate));
                    }
                }
            };
        }

        async createAnswer(offerSdp) {
            this.peerConnection = new RTCPeerConnection({ iceServers: [{ urls: 'stun:stun.l.google.com:19302' }] });

            // 영상 트랙이 들어오면 화면에 띄우기
            this.peerConnection.ontrack = (event) => {
                // [수정] JSP 파싱 오류 방지를 위해 문자열 연결(+) 사용
                console.log('[' + this.videoId + '] 영상 수신 성공!');
                const video = document.getElementById(this.videoId);
                video.srcObject = event.streams[0];
                video.play().catch(e => console.error("재생 오류", e));
            };

            this.peerConnection.onicecandidate = (event) => {
                if (event.candidate) {
                    this.signalSocket.send(JSON.stringify({
                        type: 'ice-candidate',
                        candidate: event.candidate,
                        roomId: this.roomId
                    }));
                }
            };

            await this.peerConnection.setRemoteDescription(new RTCSessionDescription(offerSdp));
            const answer = await this.peerConnection.createAnswer();
            await this.peerConnection.setLocalDescription(answer);

            this.signalSocket.send(JSON.stringify({
                type: 'answer',
                sdp: answer,
                roomId: this.roomId
            }));
        }
    }

    // AI 분석 로직 (영상 1개만 분석하거나, 번갈아 분석 가능 - 여기선 1번만 분석 예시)
    const aiMonitor = {
        init: function(videoId) {
            setInterval(() => {
                this.captureAndSend(videoId);
            }, 5000); // 5초마다 분석
        },
        captureAndSend: function(videoId) {
            const video = document.getElementById(videoId);
            // 영상이 나오고 있을 때만 분석
            if (!video || !video.srcObject || video.videoWidth === 0) return;

            const canvas = document.createElement('canvas');
            canvas.width = video.videoWidth;
            canvas.height = video.videoHeight;
            canvas.getContext('2d').drawImage(video, 0, 0);

            canvas.toBlob((blob) => {
                const formData = new FormData();
                formData.append('attach', blob, 'frame.png');
                formData.append('kioskCode', "${cctv1}");

                fetch('/cctv/analyze', { method: "post", body: formData })
                    .then(res => res.json())
                    .then(result => this.updateDisplay(result))
                    .catch(e => console.error("AI 분석 오류"));
            }, 'image/png');
        },
        updateDisplay: function(result) {
            const statusEl = $('#activity-status');
            const alertEl = $('#alert-box');

            if(result.activity) statusEl.text(result.activity);

            if (result.alert && result.alert !== "없음") {
                alertEl.text(result.alert).addClass('alert-active');
            } else {
                alertEl.text('').removeClass('alert-active');
            }
        }
    };

    $(() => {
        // 1. 컨트롤러에서 받은 코드로 2개의 CCTV 연결 시작
        // JSP EL 태그(${cctv1})로 값을 주입받음
        const cctv1 = new CCTVViewer('video1', "${cctv1}");
        const cctv2 = new CCTVViewer('video2', "${cctv2}");

        cctv1.start();
        cctv2.start();

        // 2. AI 분석 시작 (일단 1번 카메라만 분석하도록 설정됨)
        aiMonitor.init('video1');
    });
</script>