<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
  <title>CCTV Camera Device</title>
  <style>
    body { margin: 0; background-color: #000; display: flex; justify-content: center; align-items: center; height: 100vh; }
    /* CCTV 작동 중임을 알리는 빨간 테두리 스타일 */
    video { width: 100%; max-width: 640px; border: 5px solid red; border-radius: 10px; }
    .status { position: absolute; top: 10px; left: 10px; color: white; background: red; padding: 5px 10px; font-weight: bold; border-radius: 5px; }
  </style>
</head>
<body>
<div class="status">REC ● (AI 감시 중)</div>
<video id="localVideo" autoplay muted playsinline></video>

<!-- [추가] 화면 캡처용 숨겨진 캔버스 -->
<canvas id="captureCanvas" style="display:none;"></canvas>

<script>
  // [1] 여기서 방 번호 규칙을 정의합니다.
  const ORIGINAL_CODE = "${kioskCode}";

  // URL 파라미터에서 카메라 번호(no)를 가져옵니다. (기본값은 1)
  const urlParams = new URLSearchParams(window.location.search);
  const CAM_NO = urlParams.get('no') || '1';

  // [핵심] 뒤에 _CCTV + 번호를 붙여서 보호자가 들어올 방 번호를 만듭니다.
  const KIOSK_CODE = ORIGINAL_CODE + "_CCTV" + CAM_NO;

  // 웹소켓 연결 주소 설정 (HTTPS 환경 고려)
  const SIGNALING_URL = (location.protocol === 'https:' ? 'wss://' : 'ws://') + location.host + "/signal";

  console.log("[CCTV Device] 시작 - Room ID:", KIOSK_CODE);

  let localStream;
  let peerConnection;
  let signalSocket;

  // 구글 무료 STUN 서버 사용
  const rtcConfig = {
    iceServers: [{ urls: 'stun:stun.l.google.com:19302' }]
  };

  async function startCamera() {
    try {
      // 영상만 필요하면 audio: false (음성도 필요하면 true)
      localStream = await navigator.mediaDevices.getUserMedia({ video: true, audio: false });
      document.getElementById('localVideo').srcObject = localStream;
      console.log("[Sender] 카메라 시작됨");

      connectSocket();

      // [★핵심 추가] 5초마다 AI 분석 요청 자동 시작 (보호자가 없어도 분석함)
      startAutoAnalysis();

    } catch (err) {
      console.error("[Sender] 카메라 접근 실패:", err);
      alert("카메라를 켤 수 없습니다: " + err.message);
    }
  }

  // [★추가된 함수] 스스로 영상을 캡처해서 서버로 보내는 함수
  function startAutoAnalysis() {
    console.log("[Auto Analysis] 자동 감시 시작 (5초 주기)");

    setInterval(() => {
      const video = document.getElementById('localVideo');
      const canvas = document.getElementById('captureCanvas');

      // 영상이 준비되지 않았으면 스킵
      if (!video || video.readyState !== 4) return;

      // 1. 현재 화면을 캔버스에 그리기 (캡처)
      canvas.width = video.videoWidth;
      canvas.height = video.videoHeight;
      const ctx = canvas.getContext('2d');
      ctx.drawImage(video, 0, 0, canvas.width, canvas.height);

      // 2. 이미지를 Blob으로 변환하여 서버 전송
      canvas.toBlob((blob) => {
        if(!blob) return;

        const formData = new FormData();
        formData.append('attach', blob, 'frame.png');
        // [중요] 누가 보냈는지(kioskCode) 알려줘야 서버가 보호자를 찾아서 알림을 보냄
        formData.append('kioskCode', ORIGINAL_CODE);

        // 3. 서버 분석 API 호출
        fetch('/cctv/analyze', { method: "post", body: formData })
                .then(res => res.json())
                .then(result => {
                  // 분석 결과 로그 (위험할 때만 콘솔 경고)
                  if(result.alert && result.alert !== "없음") {
                    console.warn("🚨 위험 감지됨:", result.alert);
                  }
                })
                .catch(e => console.error("분석 전송 실패:", e));
      }, 'image/png');
    }, 5000); // 5초 주기
  }

  function connectSocket() {
    signalSocket = new WebSocket(SIGNALING_URL);

    signalSocket.onopen = () => {
      console.log("[Sender] 소켓 연결됨. 방 입장:", KIOSK_CODE);
      // 위에서 만든 _CCTV 방 번호로 입장 메시지 전송
      signalSocket.send(JSON.stringify({ type: 'join', roomId: KIOSK_CODE }));
    };

    signalSocket.onmessage = async (event) => {
      const msg = JSON.parse(event.data);

      // 보호자(Receiver)가 방에 들어왔다는 신호(join)를 받으면 연결 시작
      if (msg.type === 'join') {
        console.log("[Sender] 보호자 접속 감지. Offer 전송 시작.");
        createPeerConnection();
      }
      else if (msg.type === 'answer') {
        if (peerConnection) {
          await peerConnection.setRemoteDescription(new RTCSessionDescription(msg.sdp));
        }
      }
      else if (msg.type === 'ice-candidate') {
        if (peerConnection && msg.candidate) {
          await peerConnection.addIceCandidate(new RTCIceCandidate(msg.candidate));
        }
      }
    };

    signalSocket.onerror = (error) => {
      console.error("[Sender] 소켓 에러:", error);
    };
  }

  async function createPeerConnection() {
    peerConnection = new RTCPeerConnection(rtcConfig);

    // 내 카메라 스트림을 연결에 추가
    localStream.getTracks().forEach(track => peerConnection.addTrack(track, localStream));

    // ICE Candidate(네트워크 경로) 찾으면 서버로 전송
    peerConnection.onicecandidate = (event) => {
      if (event.candidate) {
        signalSocket.send(JSON.stringify({
          type: 'ice-candidate',
          candidate: event.candidate,
          roomId: KIOSK_CODE
        }));
      }
    };

    // Offer(연결 제안서) 생성 및 전송
    const offer = await peerConnection.createOffer();
    await peerConnection.setLocalDescription(offer);
    signalSocket.send(JSON.stringify({
      type: 'offer',
      sdp: offer,
      roomId: KIOSK_CODE
    }));
  }

  // 페이지 로드 시 카메라 시작
  window.onload = startCamera;
</script>
</body>
</html>