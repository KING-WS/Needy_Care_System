package edu.sm.rtc;

import com.fasterxml.jackson.databind.ObjectMapper;
import edu.sm.app.dto.Recipient;
import edu.sm.app.service.RecipientService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;
import org.springframework.web.socket.CloseStatus;
import org.springframework.web.socket.TextMessage;
import org.springframework.web.socket.WebSocketSession;
import org.springframework.web.socket.handler.TextWebSocketHandler;

import java.io.IOException;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

@Component
@Slf4j
@RequiredArgsConstructor
public class WebRTCSignalingHandler extends TextWebSocketHandler {

    private final KioskWebSocketHandler kioskWebSocketHandler;
    private final RecipientService recipientService;
    private final ObjectMapper objectMapper;

    private final Map<String, WebSocketSession> sessions = new ConcurrentHashMap<>();
    private final Map<String, String> roomSessions = new ConcurrentHashMap<>();

    @Override
    public void afterConnectionEstablished(WebSocketSession session) {
        log.info("New WebSocket connection established: {}", session.getId());
    }

    @Override
    public void handleTextMessage(WebSocketSession wsession, TextMessage message) {
        try {
            log.info("Received message from client {}: {}", wsession.getId(), message.getPayload());

            SignalMessage signalMessage = objectMapper.readValue(message.getPayload(), SignalMessage.class);
            String roomId = signalMessage.getRoomId();

            log.info("Processing {} message for room: {}", signalMessage.getType(), roomId);

            switch (signalMessage.getType()) {
                case "join":
                    handleJoinMessage(wsession, roomId);
                    signalMessage.setType("join");
                    broadcastToRoom(wsession, new TextMessage(objectMapper.writeValueAsString(signalMessage)), roomId);
                    break;
                case "bye":
                    log.info("Received bye from: {}", wsession.getId());
//                    Map<String, Object> chatData = new HashMap<>();
//                    chatData.put("content", "Bye ...");
//                    signalMessage.setData(chatData);
                    signalMessage.setType("bye");
                    broadcastToRoom(wsession, new TextMessage(objectMapper.writeValueAsString(signalMessage)), roomId);
                    break;
                case "offer":
                    log.info("1Received offer from: {}", wsession.getId());
                    log.info("2Received offer from: {}", message);
                    broadcastToRoom(wsession, message, roomId);
                    break;
                case "answer":
                    log.info("Received answer from: {}", wsession.getId());
                    broadcastToRoom(wsession, message, roomId);
                    break;
                case "ice-candidate":
                    log.info("Received ICE candidate from: {}", wsession.getId());
                    broadcastToRoom(wsession, message, roomId);
                    break;
                default:
                    log.warn("Unknown message type: {}", signalMessage.getType());
            }
        } catch (Exception e) {
            log.error("Error handling message: ", e);
        }
    }

    private void broadcastToRoom(WebSocketSession sender, TextMessage message, String roomId) {
        sessions.forEach((sessionId, webSocketSession) -> {
            if (!sender.getId().equals(sessionId) &&
                    roomId.equals(roomSessions.get(sessionId))) {
                try {
                    log.info("Broadcasting message to session {} in room {}", sessionId, roomId);
                    webSocketSession.sendMessage(message);
                } catch (IOException e) {
                    log.error("Error sending message to session {}: {}", sessionId, e.getMessage());
                }
            }
        });
    }

    private void handleJoinMessage(WebSocketSession session, String roomId) {
        sessions.put(session.getId(), session);
        roomSessions.put(session.getId(), roomId);
        log.info("Client {} joined room: {}", session.getId(), roomId);

        long roomParticipants = roomSessions.values().stream()
                .filter(r -> r.equals(roomId))
                .count();
        log.info("Room {} now has {} participants", roomId, roomParticipants);

        // ============================================================
        // [수정 완료] 방 번호 형식 상관없이, 관리자가 먼저 들어오면(1명) 무조건 호출
        // ============================================================
        if (roomParticipants == 1) { // 👈 startsWith 조건 삭제함!
            try {
                // 방 번호를 키오스크 코드로 간주하고 전송
                String kioskCode = roomId;

                Map<String, String> messageMap = Map.of(
                        "type", "start_call",
                        "roomId", roomId
                );
                String jsonMessage = objectMapper.writeValueAsString(messageMap);

                // 키오스크에게 호출 신호 전송
                kioskWebSocketHandler.sendMessageToKiosk(kioskCode, jsonMessage);
                log.info("Sent 'start_call' signal to kiosk: {}", kioskCode);

            } catch (Exception e) {
                log.error("Error sending start_call signal to kiosk for room {}", roomId, e);
            }
        }
    }

    @Override
    public void afterConnectionClosed(WebSocketSession wsession, CloseStatus status) {
        try {
            String roomId = roomSessions.get(wsession.getId());
            sessions.remove(wsession.getId());
            roomSessions.remove(wsession.getId());
            log.info("Client {} disconnected from room {}", wsession.getId(), roomId);

            if (roomId != null) {
                long remainingParticipants = roomSessions.values().stream()
                        .filter(room -> room.equals(roomId))
                        .count();
                log.info("Room {} now has {} participants remaining", roomId, remainingParticipants);

                // 다른 참여자에게 'bye' 메시지 전송
                broadcastToRoom(wsession, new TextMessage("{\"type\":\"bye\"}"), roomId);
            }
        } catch (Exception e) {
            log.error("Error during connection closing for session {}: {}", wsession.getId(), e.getMessage());
        }
    }

    @Override
    public void handleTransportError(WebSocketSession session, Throwable exception) {
        log.error("Transport error for session {}: {}", session.getId(), exception.getMessage());
    }
}