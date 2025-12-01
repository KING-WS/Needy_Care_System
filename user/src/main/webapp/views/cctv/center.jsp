<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<style>
    :root {
        /* === 배경 및 텍스트를 라이트 모드로 변경 === */
        --bg-light: #ffffff;      /* 전체 배경 (순백색) */
        --panel-light: #f8f9fa;   /* 대시보드 배경 (아주 밝은 회색) */
        --text-dark: #212529;     /* 텍스트 색상 (짙은 검정) */

        /* 기존 CCTV 모니터링 디자인 요소 유지 */
        --accent-blue: #007bff; /* 포인트 컬러 변경 (Bootstrap Blue) */
        --alert-red: #dc3545;
        --bezel-color: #343a40; /* 모니터 베젤 (짙은 회색) */
    }

    body {
        background-color: var(--bg-light); /* 흰색 배경 적용 */
        color: var(--text-dark);          /* 짙은 검정 텍스트 적용 */
        font-family: 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif;
    }

    /* 메인 대시보드 컨테이너 */
    .dashboard-container {
        background-color: var(--panel-light); /* 밝은 섹션 배경 적용 */
        border-radius: 15px;
        padding: 30px;
        box-shadow: 0 4px 15px rgba(0,0,0,0.1); /* 밝은 배경에 맞는 그림자 */
        margin-top: 30px;
        border: 1px solid #dee2e6; /* 연한 테두리 */
    }

    /* 헤더 섹션 */
    .header-section h1 {
        font-size: 38px;
        font-weight: 800;
        color: var(--secondary-color);
        text-shadow: 0 1px 2px rgba(0, 0, 0, 0.05);
        text-transform: uppercase;
        letter-spacing: 1.5px;
        margin-bottom: 10px;
    }

    #activity-status {
        font-size: 1.1em;
        color: #6c757d; /* 차분한 회색 */
        font-weight: 500;
        margin-bottom: 20px;
    }
    #activity-status::before {
        content: '●';
        color: var(--accent-blue);
        margin-right: 8px;
        font-size: 0.8em;
    }

    /* 알림 박스 스타일 (경고색은 유지) */
    #alert-box {
        font-size: 1.3em; font-weight: bold; padding: 15px; border-radius: 8px;
        display: none; margin-bottom: 25px; text-align: center;
        background-color: #f8d7da; /* 연한 붉은 배경 */
        border: 2px solid var(--alert-red);
        color: var(--alert-red);
        box-shadow: 0 0 15px rgba(220, 53, 69, 0.2);
    }
    .alert-active {
        display: block !important;
        animation: pulse-red 1.5s infinite;
    }
    @keyframes pulse-red {
        0% { box-shadow: 0 0 0 0 rgba(220, 53, 69, 0.7); }
        70% { box-shadow: 0 0 0 15px rgba(220, 53, 69, 0); }
        100% { box-shadow: 0 0 0 0 rgba(220, 53, 69, 0); }
    }

    /* 비디오 컨테이너 스타일 (모니터 느낌 - 내부 스타일 유지) */
    .video-monitor {
        background: #000;
        padding: 10px;
        border-radius: 12px;
        border: 4px solid var(--bezel-color);
        box-shadow: inset 0 0 20px rgba(0,0,0,0.8), 0 5px 15px rgba(0,0,0,0.3);
        margin-bottom: 20px;
    }

    .video-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 8px;
        padding: 0 5px;
    }
    /* 모니터 제목은 어두운 배경 위에 있으므로 밝은 색상 유지 */
    .video-label { font-size: 1.1em; font-weight: bold; color: #ccc; }

    .live-indicator {
        color: var(--alert-red);
        font-size: 0.8em;
        font-weight: bold;
        display: flex; align-items: center;
    }
    .live-dot {
        height: 10px; width: 10px; background-color: var(--alert-red);
        border-radius: 50%; display: inline-block; margin-right: 5px;
        animation: blink-dot 1s ease-in-out infinite;
    }
    @keyframes blink-dot { 50% { opacity: 0.3; } }

    /* 비디오 래퍼 및 스캔라인 효과 */
    .video-wrapper {
        position: relative;
        width: 100%;
        border-radius: 6px;
        overflow: hidden;
        border: 1px solid #333;
    }
    video { width: 100%; height: auto; display: block; background: #111; }

    /* CCTV 스캔라인 오버레이 효과 */
    .video-wrapper::after {
        content: "";
        position: absolute;
        top: 0; left: 0; width: 100%; height: 100%;
        background: repeating-linear-gradient(
                0deg,
                rgba(0, 0, 0, 0.15) 0px,
                rgba(0, 0, 0, 0.15) 1px,
                transparent 1px,
                transparent 3px
        );
        pointer-events: none; /* 클릭 통과 */
        z-index: 2;
    }
</style>

<section style="padding: 20px 0;">
    <div class="container-fluid dashboard-container" style="max-width: 1400px; margin: 0 auto;">
        <div class="row mb-2 header-section">
            <div class="col-12 text-center">
                <h1><i class="fas fa-shield-alt" style="color: var(--primary-color);"></i> 다중 보안 모니터링 시스템</h1>
                <div id="activity-status">시스템 정상 가동 중... AI 분석 대기</div>
            </div>
        </div>

        <div class="row justify-content-center">
            <div class="col-md-8">
                <div id="alert-box"><i class="fas fa-exclamation-triangle"></i> 경고: 움직임 감지됨!</div>
            </div>
        </div>

        <div class="row mt-3">
            <div class="col-lg-6 col-md-12">
                <div class="video-monitor">
                    <div class="video-header">
                        <span class="video-label"><i class="fas fa-video text-secondary"></i> CCTV 01 - 거실 Main</span>
                        <span class="live-indicator"><span class="live-dot"></span> LIVE</span>
                    </div>
                    <div class="video-wrapper">
                        <video id="video1" autoplay muted playsinline></video>
                    </div>
                </div>
            </div>
            <div class="col-lg-6 col-md-12">
                <div class="video-monitor">
                    <div class="video-header">
                        <span class="video-label"><i class="fas fa-video text-secondary"></i> CCTV 02 - 안방 침실</span>
                        <span class="live-indicator"><span class="live-dot"></span> LIVE</span>
                    </div>
                    <div class="video-wrapper">
                        <video id="video2" autoplay muted playsinline></video>
                    </div>
                </div>
            </div>
        </div>
    </div>
</section>

<script>
    // ==========================================
    // 기존 자바스크립트 로직 (변경 없음)
    // ==========================================

    // WebRTC 연결을 생성하는 클래스
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
                console.error('[' + this.videoId + '] 방 번호가 없습니다.');
                return;
            }
            console.log('[' + this.videoId + '] 연결 시작 (Room: ' + this.roomId + ')');

            this.signalSocket = new WebSocket(this.SIGNALING_URL);

            this.signalSocket.onopen = () => {
                this.signalSocket.send(JSON.stringify({ type: 'join', roomId: this.roomId }));
            };

            this.signalSocket.onmessage = async (event) => {
                const msg = JSON.parse(event.data);

                if (msg.type === 'offer') {
                    console.log('[' + this.videoId + '] Offer 수신');
                    await this.createAnswer(msg.sdp);
                }
                else if (msg.type === 'ice-candidate') {
                    if (this.peerConnection && msg.candidate) {
                        await this.peerConnection.addIceCandidate(new RTCIceCandidate(msg.candidate));
                    }
                }
            };
        }

        async createAnswer(offerSdp) {
            this.peerConnection = new RTCPeerConnection({ iceServers: [{ urls: 'stun:stun.l.google.com:19302' }] });

            this.peerConnection.ontrack = (event) => {
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

    // AI 분석 로직
    const aiMonitor = {
        init: function(videoId) {
            setInterval(() => {
                this.captureAndSend(videoId);
            }, 5000); // 5초마다 분석
        },
        captureAndSend: function(videoId) {
            const video = document.getElementById(videoId);
            if (!video || !video.srcObject || video.videoWidth === 0) return;

            const canvas = document.createElement('canvas');
            canvas.width = video.videoWidth;
            canvas.height = video.videoHeight;
            canvas.getContext('2d').drawImage(video, 0, 0);

            canvas.toBlob((blob) => {
                const formData = new FormData();
                formData.append('attach', blob, 'frame.png');
                formData.append('kioskCode', "${cctv1}");

                // fetch('/cctv/analyze', { method: "post", body: formData })
                //     .then(res => res.json())
                //     .then(result => this.updateDisplay(result))
                //     .catch(e => console.error("AI 분석 오류"));

                // [테스트용] 실제 서버 없이 UI 테스트를 하려면 아래 주석을 풀고 위 fetch를 주석 처리하세요.
                /*
                const mockResult = Math.random() > 0.7
                    ? { activity: "사람 감지됨 (신뢰도 89%)", alert: "침입 경고 발생!" }
                    : { activity: "특이사항 없음", alert: "없음" };
                this.updateDisplay(mockResult);
                */

            }, 'image/png');
        },
        updateDisplay: function(result) {
            const statusEl = $('#activity-status');
            const alertEl = $('#alert-box');

            if(result.activity) statusEl.text(result.activity);

            if (result.alert && result.alert !== '없음') {
                // 아이콘 추가하여 경고 메시지 표시
                alertEl.html('<i class="fas fa-exclamation-triangle"></i> ' + result.alert).addClass('alert-active');
            } else {
                alertEl.removeClass('alert-active');
                // 정상 상태일 때 기본 메시지로 복귀 (선택사항)
                setTimeout(() => {
                    if(!alertEl.hasClass('alert-active')) {
                        statusEl.text("시스템 정상 가동 중... AI 분석 대기");
                    }
                }, 2000);
            }
        }
    };

    $(() => {
        // 1. 컨트롤러에서 받은 코드로 2개의 CCTV 연결 시작
        // 주의: JSP EL 태그가 정상 동작하는 환경이어야 합니다.
        // 테스트 시에는 "${cctv1}" 대신 임의의 문자열(예: "test_room_1")을 넣으세요.
        const cctv1Code = "${cctv1}"; // 실제 환경용
        const cctv2Code = "${cctv2}"; // 실제 환경용

        // [테스트용] 만약 JSP 환경이 아니라면 아래 주석을 푸세요.
        // const cctv1Code = "room1"; const cctv2Code = "room2";

        if(cctv1Code && cctv2Code) {
            const cctv1 = new CCTVViewer('video1', cctv1Code);
            const cctv2 = new CCTVViewer('video2', cctv2Code);
            cctv1.start();
            cctv2.start();

            // 2. AI 분석 시작
            // 실제 영상이 연결되어야 분석이 시작됩니다.
            // aiMonitor.init('video1');

            // [테스트용] 영상 없이 UI 동작만 확인하려면 아래 코드를 사용하세요.
            /*
            console.log("테스트 모드: AI 분석 UI 시뮬레이션 시작");
            aiMonitor.init('video1');
            */
        } else {
            console.warn("CCTV 코드가 설정되지 않아 WebRTC 연결을 건너뛰었습니다.");
            $('#activity-status').text("CCTV 연결 대기 중... (코드가 없습니다)");
        }
    });
</script>