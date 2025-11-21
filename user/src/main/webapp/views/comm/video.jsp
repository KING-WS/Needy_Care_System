<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<section style="padding: 20px;">
    <div class="container-fluid">
        <div class="row">
            <div class="col-12 mb-4">
                <h1 style="font-size: 36px; font-weight: bold; color: var(--secondary-color);">
                    <i class="fas fa-video"></i> 화상통화
                </h1>
                <p style="font-size: 16px; color: #666; margin-top: 10px;">
                    담당자와 화상으로 대면 상담할 수 있습니다.
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
                        <h5 style="margin-bottom: 20px;"><i class="fas fa-network-wired"></i> Connection</h5>
                        <div class="form-group">
                            <label for="roomId">Room ID</label>
                            <input type="text" id="roomId" class="form-control" value="room1" />
                        </div>
                        <button id="joinButton" class="btn btn-primary mt-2">Join Room</button>
                        <button id="leaveButton" class="btn btn-danger mt-2" disabled>Leave Room</button>
                    </div>
                </div>
                 <div class="card" style="border: none; border-radius: 15px; box-shadow: 0 5px 15px rgba(0,0,0,0.1); background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%); color: white;">
                    <div class="card-body">
                        <h6><i class="fas fa-info-circle"></i> 이용 안내</h6>
                        <ul style="font-size: 14px; padding-left: 20px;">
                            <li>Join Room 버튼을 눌러 통화를 시작하세요.</li>
                            <li>안정적인 인터넷 환경에서 이용하세요.</li>
                            <li>카메라와 마이크 권한을 허용해주세요.</li>
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

    async function joinRoom() {
        roomId = roomIdInput.value;
        if (!roomId) {
            alert('Please enter a room ID');
            return;
        }

        joinButton.disabled = true;
        leaveButton.disabled = false;

        // [수정 1] WebSocket 연결 전에 미디어(카메라/마이크)와 PeerConnection을 먼저 준비합니다.
        const isReady = await prepareMediaAndConnection();
        if (!isReady) {
            joinButton.disabled = false;
            leaveButton.disabled = true;
            return;
        }

        // [수정 2] URL 처리 안전성 확보 (끝에 /가 없으면 추가)
        let baseUrl = "${websocketUrl}";
        if (!baseUrl.endsWith('/')) baseUrl += '/';

        // Use ws:// for local development, wss:// for production
        const wsUrl = baseUrl.replace(/^http/, 'ws') + "signal";
        console.log("Connecting to WebSocket at:", wsUrl);

        ws = new WebSocket(wsUrl);

        ws.onopen = () => {
            console.log('WebSocket connection opened');
            const joinMessage = { type: 'join', roomId: roomId };
            ws.send(JSON.stringify(joinMessage));
        };

        ws.onmessage = async (message) => {
            const signal = JSON.parse(message.data);
            console.log('Received signal:', signal);

            switch (signal.type) {
                case 'join':
                    console.log('Another peer joined the room. Creating offer...');
                    // 이미 prepareMediaAndConnection에서 준비했으므로 startCall 중복 호출 제거
                    createOffer();
                    break;
                case 'offer':
                    console.log('Received offer');
                    // 이미 준비됨. startCall 중복 호출 제거
                    await peerConnection.setRemoteDescription(new RTCSessionDescription(signal.data));
                    const answer = await peerConnection.createAnswer();
                    await peerConnection.setLocalDescription(answer);
                    ws.send(JSON.stringify({ type: 'answer', data: peerConnection.localDescription, roomId: roomId }));
                    break;
                case 'answer':
                    console.log('Received answer');
                    await peerConnection.setRemoteDescription(new RTCSessionDescription(signal.data));
                    break;
                case 'ice-candidate':
                    if (signal.data) {
                        console.log('Received ICE candidate');
                        try {
                            await peerConnection.addIceCandidate(new RTCIceCandidate(signal.data));
                        } catch (e) {
                            console.error("Error adding ICE candidate", e);
                        }
                    }
                    break;
                case 'bye':
                    console.log('Peer left the room');
                    // 상대가 나가면 화면 정리 (통화 종료 여부는 선택 사항)
                    handleRemoteHangup();
                    break;
            }
        };

        ws.onerror = (error) => {
            console.error('WebSocket error:', error);
        };

        ws.onclose = () => {
            console.log('WebSocket connection closed');
        };

        // await startCall(); <- [수정 3] 맨 끝에 있던 호출 제거 (위에서 이미 함)
    }

    // [수정 4] 미디어 준비 및 PC 생성 로직 분리
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
                remoteVideo.srcObject = event.streams[0];
            };

            localStream.getTracks().forEach(track => {
                peerConnection.addTrack(track, localStream);
            });

            return true;
        } catch (e) {
            console.error('Error getting media stream:', e);
            alert('카메라/마이크 권한을 확인할 수 없습니다. HTTPS 환경인지 확인해주세요.');
            return false;
        }
    }

    async function createOffer() {
        try {
            const offer = await peerConnection.createOffer();
            await peerConnection.setLocalDescription(offer);
            ws.send(JSON.stringify({ type: 'offer', data: peerConnection.localDescription, roomId: roomId }));
        } catch (e) {
            console.error("Error creating offer:", e);
        }
    }

    function handleRemoteHangup() {
        remoteVideo.srcObject = null;
        alert("상담원과의 연결이 종료되었습니다.");
        leaveRoom();
    }

    function leaveRoom() {
        if (ws) {
            if(ws.readyState === WebSocket.OPEN) {
                const leaveMessage = { type: 'bye', roomId: roomId };
                ws.send(JSON.stringify(leaveMessage));
            }
            ws.close();
            ws = null;
        }

        if (peerConnection) {
            peerConnection.close();
            peerConnection = null;
        }

        if (localStream) {
            localStream.getTracks().forEach(track => track.stop());
            localStream = null;
        }

        localVideo.srcObject = null;
        remoteVideo.srcObject = null;

        joinButton.disabled = false;
        leaveButton.disabled = true;
    }

    // 페이지 닫을 때 정리
    window.onbeforeunload = () => {
        if (ws || localStream) {
            leaveRoom();
        }
    };

</script>