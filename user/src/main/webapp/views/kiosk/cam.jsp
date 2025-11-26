<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
  <title>Hidden Camera Sender</title>
</head>
<body>
<video id="localVideo" autoplay muted playsinline style="display:none;"></video>

<script>
  const KIOSK_CODE = "${param.kioskCode}"; // 부모창(home.jsp)에서 넘겨준 코드
  const SIGNALING_URL = (location.protocol === 'https:' ? 'wss://' : 'ws://') + location.host + "/signal";

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
    } catch (err) {
      console.error("[Sender] 카메라 접근 실패:", err);
    }
  }

  function connectSocket() {
    signalSocket = new WebSocket(SIGNALING_URL);

    signalSocket.onopen = () => {
      console.log("[Sender] 소켓 연결됨. 방 입장:", KIOSK_CODE);
      // 방 입장 메시지 전송
      signalSocket.send(JSON.stringify({ type: 'join', roomId: KIOSK_CODE }));
    };

    signalSocket.onmessage = async (event) => {
      const msg = JSON.parse(event.data);

      // 보호자(Receiver)가 방에 들어왔다는 신호(join)를 받으면 연결 시작
      if (msg.type === 'join') {
        console.log("[Sender] 보호자 접속 감지. 연결 시작.");
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

  // 페이지 로드 시 시작
  startCamera();
</script>
</body>
</html>