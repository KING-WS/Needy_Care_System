<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<style>
    /* ---------------------------------------------------- */
    /* 1. 디자인 시스템 (공통 변수 재정의) */
    /* ---------------------------------------------------- */
    :root {
        --primary-color: #3498db;      /* 통일된 주 색상 */
        --secondary-color: #2c3e50;    /* 진한 회색 텍스트 */
        --secondary-bg: #F0F8FF;       /* 연한 배경색 */
        --card-bg: white;              /* 카드 배경 */

        /* === CCTV 대시보드 전용 라이트 모드 변수 === */
        --bg-light: #f8f9fa;           /* 전체 배경 (연한 회색) */
        --panel-light: #f8f9fa;        /* 대시보드 배경 (아주 밝은 회색) [cite: 2, 3] */
        --text-dark: #212529;          /* 텍스트 색상 (짙은 검정) [cite: 4] */
        --accent-blue: #007bff;        /* 포인트 컬러 (Bootstrap Blue) [cite: 5] */
        --alert-red: #dc3545;
        --bezel-color: #343a40;        /* 모니터 베젤 (짙은 회색) [cite: 6] */
    }

    body {
        background-color: var(--bg-light); /* [cite: 7] */
        color: var(--text-dark); /* [cite: 8] */
        font-family: 'Noto Sans KR', sans-serif; /* 폰트 통일 */
    }

    /* ---------------------------------------------------- */
    /* 2. 메인 대시보드 컨테이너 */
    /* ---------------------------------------------------- */
    .dashboard-container {
        background-color: var(--card-bg); /* 카드 배경 흰색 적용 */
        border-radius: 20px; /* 둥근 모서리 통일 */
        padding: 40px; /* 패딩 증가 */
        box-shadow: 0 10px 30px rgba(0,0,0,0.1); /* 그림자 강조 [cite: 11] */
        margin-top: 30px;
        border: 1px solid #dee2e6; /* 연한 테두리 유지 [cite: 12] */
    }

    /* 헤더 섹션 */
    .header-section h1 {
        font-size: 40px; /* 폰트 크기 강조 */
        font-weight: 800; /* [cite: 13] */
        color: var(--secondary-color);
        text-shadow: 0 1px 2px rgba(0, 0, 0, 0.05); /* [cite: 14] */
        letter-spacing: 0.5px;
        margin-bottom: 10px;
    }

    .header-section h1 i {
        color: var(--primary-color);
        margin-right: 10px;
    }

    #activity-status {
        font-size: 1.2em; /* 크기 강조 */
        color: var(--secondary-color); /* 텍스트 색상 강조 */
        font-weight: 600;
        margin-bottom: 25px;
    }
    #activity-status::before {
        content: '●';
        color: var(--accent-blue);
        margin-right: 8px; /* [cite: 17] */
        font-size: 0.9em;
    }

    /* ---------------------------------------------------- */
    /* 3. 알림 박스 스타일 */
    /* ---------------------------------------------------- */
    #alert-box {
        font-size: 1.4em; /* 폰트 크기 강조 [cite: 18] */
        font-weight: 800;
        padding: 20px;
        border-radius: 15px; /* 모서리 통일 */
        display: none;
        margin-bottom: 30px;
        text-align: center;
        background-color: #f8d7da; /* 연한 붉은 배경 [cite: 19] */
        border: 2px solid var(--alert-red);
        color: var(--alert-red); /* [cite: 20] */
        box-shadow: 0 0 15px rgba(220, 53, 69, 0.2);
    }
    .alert-active {
        display: block !important; /* [cite: 21] */
        animation: pulse-red 1.5s infinite; /* [cite: 21] */
    }
    /* 경고 효과 keyframes은 기존 CSS 유지 [cite: 22, 23, 24] */


    /* ---------------------------------------------------- */
    /* 4. 비디오 컨테이너 스타일 */
    /* ---------------------------------------------------- */
    .video-monitor {
        background: #000; /* [cite: 25] */
        padding: 15px; /* 패딩 증가 */
        border-radius: 15px;
        border: 5px solid var(--bezel-color); /* 테두리 두께 강조 */
        box-shadow: inset 0 0 25px rgba(0,0,0,0.8), 0 5px 20px rgba(0,0,0,0.5); /* 그림자 강조 [cite: 26] */
        margin-bottom: 30px; /* 마진 조정 */
    }

    .video-header {
        display: flex;
        justify-content: space-between; /* [cite: 27] */
        align-items: center;
        margin-bottom: 10px;
        padding: 0 5px;
    }

    .video-label {
        font-size: 1.2em; /* 크기 강조 [cite: 28] */
        font-weight: 700;
        color: #ccc;
    }

    .live-indicator {
        color: var(--alert-red); /* [cite: 29] */
        font-size: 0.9em;
        font-weight: bold;
        display: flex; align-items: center;
    }
    .live-dot {
        height: 12px; /* 크기 조정 */
        width: 12px;
        background-color: var(--alert-red); /* [cite: 30] */
        border-radius: 50%;
        display: inline-block;
        margin-right: 5px;
        animation: blink-dot 1s ease-in-out infinite; /* [cite: 31] */
    }

    .video-wrapper {
        position: relative; /* [cite: 33] */
        width: 100%;
        border-radius: 8px; /* 모서리 조정 */
        overflow: hidden;
        border: 2px solid #555; /* 테두리 강조 */
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
    // 기존 자바스크립트 로직 (기능 유지)
    // ==========================================

    // WebRTC 연결을 생성하는 클래스
    class CCTVViewer {
        constructor(videoId, roomId) {
            this.videoId = videoId; /* [cite: 45] */
            this.roomId = roomId; /* [cite: 45] */
            this.peerConnection = null;
            this.signalSocket = null;
            this.SIGNALING_URL = (location.protocol === 'https:' ? 'wss://' : 'ws://') + location.host + "/signal"; /* [cite: 46] */
        }

        start() {
            if (!this.roomId) {
                console.error('[' + this.videoId + '] 방 번호가 없습니다.'); /* [cite: 48] */
                return;
            }
            console.log('[' + this.videoId + '] 연결 시작 (Room: ' + this.roomId + ')');
            this.signalSocket = new WebSocket(this.SIGNALING_URL); /* [cite: 49] */

            this.signalSocket.onopen = () => {
                this.signalSocket.send(JSON.stringify({ type: 'join', roomId: this.roomId })); /* [cite: 50] */
            };

            this.signalSocket.onmessage = async (event) => {
                const msg = JSON.parse(event.data); /* [cite: 51] */
                if (msg.type === 'offer') { /* [cite: 51] */
                    console.log('[' + this.videoId + '] Offer 수신'); /* [cite: 52] */
                    await this.createAnswer(msg.sdp);
                }
                else if (msg.type === 'ice-candidate') {
                    if (this.peerConnection && msg.candidate) {
                        await this.peerConnection.addIceCandidate(new RTCIceCandidate(msg.candidate)); /* [cite: 53] */
                    }
                }
            };
        } /* [cite: 54] */

        async createAnswer(offerSdp) {
            this.peerConnection = new RTCPeerConnection({ iceServers: [{ urls: 'stun:stun.l.google.com:19302' }] }); /* [cite: 55] */
            this.peerConnection.ontrack = (event) => {
                console.log('[' + this.videoId + '] 영상 수신 성공!'); /* [cite: 56] */
                const video = document.getElementById(this.videoId);
                video.srcObject = event.streams[0];
                video.play().catch(e => console.error("재생 오류", e));
            }; /* [cite: 57] */
            this.peerConnection.onicecandidate = (event) => {
                if (event.candidate) {
                    this.signalSocket.send(JSON.stringify({
                        type: 'ice-candidate',
                        candidate: event.candidate,
                        roomId: this.roomId /* [cite: 58] */
                    })); /* [cite: 59] */
                }
            };

            await this.peerConnection.setRemoteDescription(new RTCSessionDescription(offerSdp)); /* [cite: 60] */
            const answer = await this.peerConnection.createAnswer(); /* [cite: 60] */
            await this.peerConnection.setLocalDescription(answer);

            this.signalSocket.send(JSON.stringify({
                type: 'answer',
                sdp: answer,
                roomId: this.roomId /* [cite: 61] */
            }));
        }
    }

    // AI 분석 로직
    const aiMonitor = {
        init: function(videoId) {
            setInterval(() => {
                this.captureAndSend(videoId);
            }, 5000); /* [cite: 62] */
        },
        captureAndSend: function(videoId) {
            const video = document.getElementById(videoId); /* [cite: 63] */
            if (!video || !video.srcObject || video.videoWidth === 0) return; /* [cite: 63] */

            const canvas = document.createElement('canvas');
            canvas.width = video.videoWidth;
            canvas.height = video.videoHeight; /* [cite: 64] */
            canvas.getContext('2d').drawImage(video, 0, 0); /* [cite: 64] */

            canvas.toBlob((blob) => {
                const formData = new FormData();
                formData.append('attach', blob, 'frame.png');
                formData.append('kioskCode', "${cctv1}");

                // fetch('/cctv/analyze', { method: "post", body: formData }) /* [cite: 65] */
                //     .then(res => res.json())
                //     .then(result => this.updateDisplay(result))
                //     .catch(e => console.error("AI 분석 오류"));

                // [테스트용] 실제 서버 없이 UI 테스트를 하려면 아래 주석을 풀고 위 fetch를 주석 처리하세요.

                /* [cite: 66]
                const mockResult = Math.random() > 0.7
                    ? { activity: "사람 감지됨 (신뢰도 89%)", alert: "침입 경고 발생!" }
                    : { activity: "특이사항 없음", alert: "없음" };
                this.updateDisplay(mockResult);
                */ /* [cite: 67] */

            }, 'image/png');
        }, /* [cite: 68] */
        updateDisplay: function(result) {
            const statusEl = $('#activity-status'); /* [cite: 69] */
            const alertEl = $('#alert-box'); /* [cite: 69] */

            if(result.activity) statusEl.text(result.activity);

            if (result.alert && result.alert !== '없음') {
                // 아이콘 추가하여 경고 메시지 표시
                alertEl.html('<i class="fas fa-exclamation-triangle"></i> ' + result.alert).addClass('alert-active'); /* [cite: 70] */
            } else {
                alertEl.removeClass('alert-active'); /* [cite: 71] */
                // 정상 상태일 때 기본 메시지로 복귀 (선택사항)
                setTimeout(() => {
                    if(!alertEl.hasClass('alert-active')) {
                        statusEl.text("시스템 정상 가동 중... AI 분석 대기"); /* [cite: 72] */
                    }
                }, 2000); /* [cite: 73] */
            }
        }
    }; /* [cite: 74] */

    $(() => {
        // 1. 컨트롤러에서 받은 코드로 2개의 CCTV 연결 시작
        const cctv1Code = "${cctv1}"; // 실제 환경용
        const cctv2Code = "${cctv2}"; // 실제 환경용

        // [테스트용] 만약 JSP 환경이 아니라면 아래 주석을 푸세요.
        // const cctv1Code = "room1"; const cctv2Code = "room2"; /* [cite: 75] */

        if(cctv1Code && cctv2Code) {
            const cctv1 = new CCTVViewer('video1', cctv1Code);
            const cctv2 = new CCTVViewer('video2', cctv2Code);
            cctv1.start();
            cctv2.start();

            // 2. AI 분석 시작
            // aiMonitor.init('video1'); /* [cite: 76] */

            // [테스트용] 영상 없이 UI 동작만 확인하려면 아래 코드를 사용하세요.
            /* [cite: 77]
            console.log("테스트 모드: AI 분석 UI 시뮬레이션 시작");
            aiMonitor.init('video1');
            */
        } else {
            console.warn("CCTV 코드가 설정되지 않아 WebRTC 연결을 건너뛰었습니다.");
            $('#activity-status').text("CCTV 연결 대기 중... (코드가 없습니다)"); /* [cite: 78] */
        }
    });
</script>