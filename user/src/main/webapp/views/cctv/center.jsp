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
    // CCTV 모니터링 로직
    const cctvMonitor = {
        analysisInterval: null,

        init: function () {
            console.log("cctvMonitor: init() 호출됨");
            this.previewCamera('video');

            // 5초마다 상태 분석
            console.log("cctvMonitor: 5초 간격으로 프레임 캡처 및 전송을 시작합니다.");
            this.analysisInterval = setInterval(() => {
                this.captureFrame("video", (pngBlob) => {
                    this.send(pngBlob);
                });
            }, 5000);
        },

        previewCamera: function (videoId) {
            console.log(`cctvMonitor: previewCamera() 호출됨 (videoId: ${videoId})`);
            const video = document.getElementById(videoId);
            if (!video) {
                console.error('cctvMonitor: 비디오 요소를 찾을 수 없습니다. ID:', videoId);
                return;
            }

            // 보안 경고 (localhost가 아닌 http 환경)
            if (location.protocol !== 'https:' && location.hostname !== 'localhost' && location.hostname !== '127.0.0.1') {
                console.warn('cctvMonitor: 카메라 API는 보안 컨텍스트(HTTPS)에서만 안정적으로 작동합니다. 현재 프로토콜:', location.protocol);
                alert('카메라를 사용하려면 HTTPS 프로토콜로 접속해야 합니다.');
            }

            console.log("cctvMonitor: 카메라 접근을 요청합니다...");
            navigator.mediaDevices.getUserMedia({ video: true })
                .then((stream) => {
                    console.log("cctvMonitor: 카메라 접근 성공. 스트림을 비디오에 연결합니다.", stream);
                    video.srcObject = stream;
                    video.onloadedmetadata = () => {
                        video.play().catch(e => console.error("cctvMonitor: 비디오 재생 실패.", e));
                        console.log("cctvMonitor: 비디오가 성공적으로 재생되었습니다.");
                    };
                })
                .catch((error) => {
                    console.error('cctvMonitor: 카메라 접근 중 오류 발생.', error);
                    if (error.name === 'NotAllowedError') {
                        alert('카메라 접근 권한이 거부되었습니다. 브라우저 설정에서 권한을 허용해주세요.');
                    } else if (error.name === 'NotFoundError') {
                        alert('연결된 카메라를 찾을 수 없습니다. 카메라가 제대로 연결되었는지 확인해주세요.');
                    } else {
                        alert(`카메라 접근에 실패했습니다: ${error.name}`);
                    }
                });
        },

        captureFrame: function (videoId, handleFrame) {
            const video = document.getElementById(videoId);
            if (!video || !video.srcObject || video.videoWidth === 0 || video.videoHeight === 0) {
                // console.warn('cctvMonitor: 비디오가 캡처 준비되지 않았습니다. (스트림이 없거나, 비디오 크기가 0)');
                return;
            }
            console.log("cctvMonitor: 현재 프레임을 캡처합니다.");
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
            if (!pngBlob) {
                console.warn("cctvMonitor: 전송할 PNG Blob이 없습니다.");
                return;
            }
            console.log("cctvMonitor: 캡처된 프레임을 서버로 전송합니다.");

            const formData = new FormData();
            formData.append('attach', pngBlob, 'frame.png');

            try {
                const response = await fetch('/cctv/analyze', {
                    method: "post",
                    body: formData
                });

                if (response.ok) {
                    const result = await response.json();
                    console.log("cctvMonitor: 서버로부터 분석 결과를 받았습니다.", result);
                    this.updateDisplay(result);
                } else {
                    console.error("cctvMonitor: 서버 응답 오류.", response.status, response.statusText);
                    this.updateDisplay({ activity: "상태 분석 실패", alert: "없음" });
                }
            } catch (error) {
                console.error("cctvMonitor: 프레임 분석 요청 중 네트워크 오류 발생:", error);
                this.updateDisplay({ activity: "연결 오류", alert: "없음" });
            }
        },

        updateDisplay: function(result) {
            const statusEl = $('#activity-status');
            const alertEl = $('#alert-box');

            if (result.activity) {
                statusEl.text(result.activity);
            } else {
                statusEl.text("---");
            }

            if (result.alert && result.alert !== "없음" && result.alert !== null) {
                alertEl.text(result.alert);
                alertEl.addClass('alert-active');
            } else {
                alertEl.text('');
                alertEl.removeClass('alert-active');
            }
        }
    }

    // DOM이 준비되면 스크립트 초기화 실행
    $(() => {
        console.log("DOM이 준비되었습니다. cctvMonitor를 초기화합니다.");
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