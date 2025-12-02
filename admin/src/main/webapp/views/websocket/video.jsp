<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>영상통화 연결</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <style>
        body { background-color: #f8f9fa; } /* 배경색 지정 */
    </style>
</head>
<body>

<section style="padding: 20px;">
    <div class="container-fluid">
        <div class="row">
            <div class="col-12 mb-4">
                <h1 style="font-size: 28px; font-weight: bold; color: #2c3e50;">
                    <i class="fas fa-video"></i> 관리자 화상통화
                </h1>
                <p style="font-size: 14px; color: #666; margin-top: 5px;">
                    사용자와 화상으로 대면 상담할 수 있습니다.
                </p>
            </div>
        </div>
        <div class="row">
            <div class="col-md-8">
                <div class="card" style="border: none; border-radius: 15px; box-shadow: 0 5px 15px rgba(0,0,0,0.1); height: 500px; background: #000; overflow: hidden; position: relative;">
                    <video id="remoteVideo" autoplay playsinline style="width: 100%; height: 100%; object-fit: cover;"></video>
                    <video id="localVideo" autoplay playsinline muted style="position: absolute; bottom: 20px; right: 20px; width: 25%; height: 25%; border-radius: 10px; border: 2px solid white;"></video>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card" style="border: none; border-radius: 15px; box-shadow: 0 5px 15px rgba(0,0,0,0.1); margin-bottom: 20px;">
                    <div class="card-body">
                        <h5 style="margin-bottom: 20px;"><i class="fas fa-network-wired"></i> 연결 상태</h5>
                        <div class="form-group mb-3">
                            <label for="roomId" class="form-label text-muted small">연결 코드 (Room ID)</label>
                            <input type="text" id="roomId" class="form-control fw-bold" value="room1" readonly />
                        </div>
                        <div class="d-grid gap-2">
                            <button id="joinButton" class="btn btn-primary btn-lg">
                                <i class="fas fa-phone"></i> 연결 시작
                            </button>
                            <button id="leaveButton" class="btn btn-danger btn-lg" disabled>
                                <i class="fas fa-phone-slash"></i> 종료
                            </button>
                        </div>
                    </div>
                </div>
                <div class="card" style="border: none; border-radius: 15px; box-shadow: 0 5px 15px rgba(0,0,0,0.1); background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%); color: white;">
                    <div class="card-body">
                        <h6><i class="fas fa-info-circle"></i> 이용 안내</h6>
                        <ul style="font-size: 13px; padding-left: 20px; margin-bottom: 0;">
                            <li>자동으로 연결이 시작됩니다.</li>
                            <li>연결이 안 되면 새로고침 하세요.</li>
                            <li>카메라/마이크 권한을 허용해주세요.</li>
                        </ul>
                    </div>
                </div>
            </div>
        </div>
    </div>
</section>

<script>
    const joinButton = document.getElementById('joinButton');
    const leaveButton = document.getElementById('leaveButton');
    const localVideo = document.getElementById('localVideo');
    const remoteVideo = document.getElementById('remoteVideo');
    const roomIdInput = document.getElementById('roomId');

    let localStream;
    let peerConnection;
    let ws;
    let roomId;

    const configuration = {
        iceServers: [
            { urls: 'stun:stun.l.google.com:19302' },
            { urls: 'stun:stun1.l.google.com:19302' }
        ]
    };

    joinButton.onclick = joinRoom;
    leaveButton.onclick = leaveRoom;

    // 페이지 로드 시 자동 연결
    document.addEventListener('DOMContentLoaded', () => {
        const urlParams = new URLSearchParams(window.location.search);
        const urlRoomId = urlParams.get('roomId');

        if (urlRoomId) {
            roomIdInput.value = urlRoomId;
            joinButton.innerText = "연결 중...";
            joinButton.disabled = true;
            joinRoom();
        }
    });

    async function joinRoom() {
        roomId = roomIdInput.value;
        if (!roomId) { alert('Room ID가 없습니다.'); return; }

        joinButton.disabled = true;
        leaveButton.disabled = false;

        const isReady = await prepareMediaAndConnection();
        if (!isReady) {
            joinButton.disabled = false;
            leaveButton.disabled = true;
            joinButton.innerText = "연결 실패 (재시도)";
            return;
        }

        // [핵심] 키오스크(User) 서버 포트(8084)로 연결 설정
        const protocol = window.location.protocol === 'https:' ? 'wss:' : 'ws:';
        // 팀원들도 되게 하려면 localhost 대신 hostname을 씁니다.
        const currentHost = window.location.hostname;
        const userServerDomain = currentHost + ":8084"; // 포트 8084 강제 지정
        const wsUrl = protocol + '//' + userServerDomain + '/signal';

        console.log("키오스크 서버 연결 시도:", wsUrl);

        ws = new WebSocket(wsUrl);

        ws.onopen = () => {
            console.log('WebSocket 연결됨');
            const joinMessage = { type: 'join', roomId: roomId };
            ws.send(JSON.stringify(joinMessage));
            joinButton.innerText = "연결됨";
            joinButton.classList.remove('btn-primary');
            joinButton.classList.add('btn-success');
        };

        ws.onmessage = async (message) => {
            const signal = JSON.parse(message.data);
            console.log('신호 수신:', signal.type);

            switch (signal.type) {
                case 'join':
                    console.log('키오스크 입장. Offer 전송...');
                    createOffer();
                    break;
                case 'offer':
                    console.log('Offer 수신 (키오스크가 먼저 검)');
                    await peerConnection.setRemoteDescription(new RTCSessionDescription(signal.data));
                    const answer = await peerConnection.createAnswer();
                    await peerConnection.setLocalDescription(answer);
                    ws.send(JSON.stringify({ type: 'answer', data: peerConnection.localDescription, roomId: roomId }));
                    break;
                case 'answer':
                    console.log('Answer 수신 (연결 완료)');
                    await peerConnection.setRemoteDescription(new RTCSessionDescription(signal.data));
                    break;
                case 'ice-candidate':
                    if (signal.data) {
                        try {
                            await peerConnection.addIceCandidate(new RTCIceCandidate(signal.data));
                        } catch (e) { console.error(e); }
                    }
                    break;
                case 'bye':
                    console.log('상대방 종료');
                    handleRemoteHangup();
                    break;
            }
        };

        ws.onerror = (error) => {
            console.error('WS 오류:', error);
            alert('키오스크 서버에 연결할 수 없습니다.\n서버가 켜져 있는지 확인하세요.');
        };
    }

    async function prepareMediaAndConnection() {
        try {
            localStream = await navigator.mediaDevices.getUserMedia({ video: true, audio: true });
            localVideo.srcObject = localStream;

            peerConnection = new RTCPeerConnection(configuration);

            peerConnection.onicecandidate = (event) => {
                if (event.candidate && ws && ws.readyState === WebSocket.OPEN) {
                    ws.send(JSON.stringify({ type: 'ice-candidate', data: event.candidate, roomId: roomId }));
                }
            };

            peerConnection.ontrack = (event) => {
                console.log("상대방 영상 수신");
                remoteVideo.srcObject = event.streams[0];
            };

            localStream.getTracks().forEach(track => {
                peerConnection.addTrack(track, localStream);
            });

            return true;
        } catch (e) {
            console.error('미디어 오류:', e);
            alert('카메라 권한을 확인해주세요.');
            return false;
        }
    }

    async function createOffer() {
        try {
            const offer = await peerConnection.createOffer();
            await peerConnection.setLocalDescription(offer);
            ws.send(JSON.stringify({ type: 'offer', data: peerConnection.localDescription, roomId: roomId }));
        } catch (e) { console.error(e); }
    }

    function handleRemoteHangup() {
        remoteVideo.srcObject = null;
        alert("상대방이 연결을 종료했습니다.");
        leaveRoom();
    }

    function leaveRoom() {
        if (ws) {
            if(ws.readyState === WebSocket.OPEN) ws.send(JSON.stringify({ type: 'bye', roomId: roomId }));
            ws.close(); ws = null;
        }
        if (peerConnection) { peerConnection.close(); peerConnection = null; }
        if (localStream) { localStream.getTracks().forEach(track => track.stop()); localStream = null; }

        localVideo.srcObject = null;
        remoteVideo.srcObject = null;
        joinButton.disabled = false;
        leaveButton.disabled = true;
        joinButton.innerText = "연결 시작";
        joinButton.classList.remove('btn-success');
        joinButton.classList.add('btn-primary');

        // 팝업창 닫기 (선택 사항)
        // window.close();
    }

    window.onbeforeunload = () => { if(ws || localStream) leaveRoom(); };
</script>
</body>
</html>