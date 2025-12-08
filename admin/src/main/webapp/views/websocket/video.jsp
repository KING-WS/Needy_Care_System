<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>영상통화 및 긴급 대응</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <style>
        body { background-color: #f8f9fa; }
        /* 긴급 버튼 스타일 */
        .btn-macro { font-size: 0.8rem; border-radius: 20px; margin-right: 5px; margin-bottom: 5px; }
    </style>
</head>
<body>

<section style="padding: 20px;">
    <div class="container-fluid">
        <div class="row">
            <div class="col-12 mb-3">
                <h2 style="color: #2c3e50; font-weight: bold;">
                    <i class="fas fa-video"></i> 실시간 관제 및 대응 시스템
                </h2>
                <p class="text-muted small">
                    현장 상황을 모니터링하고 담당 요양사에게 즉시 지시를 내릴 수 있습니다.
                </p>
            </div>
        </div>

        <div class="row">
            <div class="col-md-8">
                <div class="card bg-dark text-white" style="height: 600px; border-radius: 15px; overflow: hidden; position: relative;">
                    <video id="remoteVideo" autoplay playsinline style="width: 100%; height: 100%; object-fit: cover;"></video>

                    <video id="localVideo" autoplay playsinline muted style="position: absolute; bottom: 20px; right: 20px; width: 200px; height: 150px; border-radius: 10px; border: 2px solid rgba(255,255,255,0.7); background: #000;"></video>

                    <div id="waitingMsg" style="position: absolute; top: 50%; left: 50%; transform: translate(-50%, -50%); text-align: center;">
                        <i class="fas fa-spinner fa-spin fa-3x mb-3"></i>
                        <h4>연결 신호 대기 중...</h4>
                    </div>
                </div>
            </div>

            <div class="col-md-4">

                <div class="card mb-3 shadow-sm" style="border-radius: 15px; border: none;">
                    <div class="card-header bg-warning text-dark fw-bold">
                        <i class="fas fa-user-injured"></i> 돌봄 대상자 정보
                    </div>
                    <div class="card-body">
                        <h4 class="card-title fw-bold">
                            <c:out value="${receiverName}" default="대상자 정보 없음" />
                        </h4>
                        <p class="card-text text-muted">
                            <i class="fas fa-notes-medical"></i> 특이사항:
                            <span class="text-danger fw-bold">
                                <c:out value="${receiverCondition}" default="등록된 특이사항 없음" />
                            </span>
                        </p>
                        <hr>
                        <div class="d-flex justify-content-between align-items-center">
                            <span class="small text-muted">Room ID: <strong>${roomId}</strong></span>
                            <span id="statusBadge" class="badge bg-secondary">연결 대기중</span>
                        </div>
                    </div>
                </div>

                <div class="card mb-3 shadow-sm" style="border-radius: 15px; border: none;">
                    <div class="card-header bg-primary text-white fw-bold">
                        <i class="fas fa-user-nurse"></i> 담당 요양사 긴급 지시
                    </div>
                    <div class="card-body">
                        <div class="d-flex align-items-center mb-3 p-2 bg-light rounded">
                            <div class="flex-shrink-0">
                                <i class="fas fa-user-circle fa-3x text-secondary"></i>
                            </div>
                            <div class="flex-grow-1 ms-3">
                                <h6 class="mb-0 fw-bold"><c:out value="${caregiverName}" default="미매칭" /></h6>
                                <small class="text-primary fw-bold">
                                    <i class="fas fa-phone-alt"></i> <c:out value="${caregiverPhone}" default="번호 없음" />
                                </small>
                            </div>
                        </div>

                        <div class="mb-2">
                            <label class="form-label small fw-bold text-muted">상황 전파 메시지 전송</label>
                            <textarea id="alertMessage" class="form-control" rows="3" placeholder="내용을 입력하거나 아래 버튼을 클릭하세요."></textarea>
                        </div>

                        <div class="mb-3">
                            <button type="button" class="btn btn-outline-secondary btn-macro" onclick="fillMsg('낙상 감지! 즉시 방문하여 상태 확인 바랍니다.')">낙상 사고</button>
                            <button type="button" class="btn btn-outline-secondary btn-macro" onclick="fillMsg('대상자 움직임 없음. 안부 확인 요망.')">미움직임</button>
                            <button type="button" class="btn btn-outline-secondary btn-macro" onclick="fillMsg('센서 오작동 확인됨. 특이사항 없음.')">오작동 처리</button>
                        </div>

                        <button id="sendAlertBtn" class="btn btn-danger w-100 fw-bold">
                            <i class="fas fa-paper-plane"></i> 긴급 알림 전송
                        </button>
                    </div>
                </div>

                <div class="card shadow-sm" style="border-radius: 15px; border: none;">
                    <div class="card-body">
                        <div class="d-grid gap-2">
                            <button id="joinButton" class="btn btn-success btn-lg">
                                <i class="fas fa-video"></i> 연결 시작
                            </button>
                            <button id="leaveButton" class="btn btn-secondary btn-lg" disabled>
                                <i class="fas fa-phone-slash"></i> 연결 종료
                            </button>
                        </div>
                        <input type="hidden" id="roomIdInput" value="${roomId}">
                    </div>
                </div>

            </div>
        </div>
    </div>
</section>

<script>
    // --- [기존 WebRTC 변수들] ---
    const joinButton = document.getElementById('joinButton');
    const leaveButton = document.getElementById('leaveButton');
    const localVideo = document.getElementById('localVideo');
    const remoteVideo = document.getElementById('remoteVideo');
    const waitingMsg = document.getElementById('waitingMsg'); // 대기 화면 제어용

    // JSP에서 받은 RoomID (input hidden 값)
    const roomIdInput = document.getElementById('roomIdInput');

    let localStream;
    let peerConnection;
    let ws;
    let roomId = roomIdInput.value; // 초기값 설정

    const configuration = {
        iceServers: [
            { urls: 'stun:stun.l.google.com:19302' },
            { urls: 'stun:stun1.l.google.com:19302' }
        ]
    };

    // --- [1. 긴급 알림(문자) 전송 로직 추가] ---

    // 매크로 버튼 기능
    function fillMsg(text) {
        document.getElementById('alertMessage').value = text;
    }

    // 전송 버튼 클릭 이벤트
    document.getElementById('sendAlertBtn').addEventListener('click', function() {
        const msg = document.getElementById('alertMessage').value;
        const currentRoomId = roomIdInput.value;

        if(!currentRoomId) {
            alert("Room ID가 없습니다. 정상적인 경로로 접속해주세요.");
            return;
        }
        if(!msg) {
            alert("전송할 메시지 내용을 입력해주세요.");
            return;
        }

        if(!confirm("담당 요양사에게 알림을 전송하시겠습니까?")) return;

        // AJAX 요청 (fetch)
        fetch('/websocket/sendAlert?roomId=' + currentRoomId + '&message=' + encodeURIComponent(msg))
            .then(response => response.text())
            .then(data => {
                if(data === "OK") {
                    alert("✅ 전송 성공!\n담당 요양사에게 메시지가 전달되었습니다.");
                    document.getElementById('alertMessage').value = ''; // 입력창 초기화
                } else {
                    alert("전송 실패. 다시 시도해주세요.");
                }
            })
            .catch(err => {
                console.error(err);
                alert("서버 통신 오류 발생");
            });
    });


    // --- [2. 기존 WebRTC 로직 (유지)] ---

    joinButton.onclick = joinRoom;
    leaveButton.onclick = leaveRoom;

    // 페이지 로드 시 자동 연결 시도
    document.addEventListener('DOMContentLoaded', () => {
        if (roomId) {
            joinButton.innerText = "연결 준비 중...";
            joinButton.disabled = true;
            joinRoom();
        } else {
            alert("잘못된 접근입니다. Room ID가 없습니다.");
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
            joinButton.innerText = "카메라 오류";
            return;
        }

        const protocol = window.location.protocol === 'https:' ? 'wss:' : 'ws:';
        const currentHost = window.location.hostname;
        const userServerDomain = currentHost + ":8084";
        const wsUrl = protocol + '//' + userServerDomain + '/signal';

        console.log("Connect to:", wsUrl);

        ws = new WebSocket(wsUrl);

        ws.onopen = () => {
            console.log('WS Open');
            const joinMessage = { type: 'join', roomId: roomId };
            ws.send(JSON.stringify(joinMessage));

            // UI 업데이트
            joinButton.innerText = "신호 연결됨";
            document.getElementById('statusBadge').innerText = "서버 연결됨";
            document.getElementById('statusBadge').className = "badge bg-success";
        };

        ws.onmessage = async (message) => {
            const signal = JSON.parse(message.data);

            switch (signal.type) {
                case 'join':
                    console.log('상대방 입장 -> Offer 생성');
                    createOffer();
                    break;
                case 'offer':
                    console.log('Offer 수신');
                    await peerConnection.setRemoteDescription(new RTCSessionDescription(signal.data));
                    const answer = await peerConnection.createAnswer();
                    await peerConnection.setLocalDescription(answer);
                    ws.send(JSON.stringify({ type: 'answer', data: peerConnection.localDescription, roomId: roomId }));
                    break;
                case 'answer':
                    console.log('Answer 수신 -> 연결 성립');
                    await peerConnection.setRemoteDescription(new RTCSessionDescription(signal.data));
                    break;
                case 'ice-candidate':
                    if (signal.data) {
                        try { await peerConnection.addIceCandidate(new RTCIceCandidate(signal.data)); }
                        catch (e) { console.error(e); }
                    }
                    break;
                case 'bye':
                    handleRemoteHangup();
                    break;
            }
        };

        ws.onerror = (error) => {
            console.error('WS Error:', error);
            alert('중계 서버(8084) 연결 실패.');
            document.getElementById('statusBadge').innerText = "연결 끊김";
            document.getElementById('statusBadge').className = "badge bg-danger";
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
                console.log("Track received");
                remoteVideo.srcObject = event.streams[0];
                waitingMsg.style.display = 'none'; // 영상 나오면 대기 문구 숨김
            };

            localStream.getTracks().forEach(track => {
                peerConnection.addTrack(track, localStream);
            });

            return true;
        } catch (e) {
            console.error('Media Error:', e);
            alert('카메라/마이크 권한이 필요합니다.');
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
        waitingMsg.style.display = 'block';
        alert("상대방이 종료했습니다.");
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
        joinButton.innerText = "재연결";
        document.getElementById('statusBadge').innerText = "종료됨";
        document.getElementById('statusBadge').className = "badge bg-secondary";
    }

    window.onbeforeunload = () => { if(ws || localStream) leaveRoom(); };
</script>
</body>
</html>