package edu.sm.rtc;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import edu.sm.app.dto.AlertLog;
import edu.sm.app.dto.CareTimelineItem;
import edu.sm.app.dto.Recipient;
import edu.sm.app.service.AlertLogService;
import edu.sm.app.service.RecipientService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Lazy;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Component;
import org.springframework.web.socket.CloseStatus;
import org.springframework.web.socket.TextMessage;
import org.springframework.web.socket.WebSocketSession;
import org.springframework.web.socket.handler.TextWebSocketHandler;
import java.io.IOException;
import java.util.Set;

import java.time.LocalDateTime;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

@Slf4j
@Component
public class KioskWebSocketHandler extends TextWebSocketHandler {

    private final ObjectMapper objectMapper;
    private final AlertLogService alertLogService;
    private final RecipientService recipientService;
    private SimpMessagingTemplate messagingTemplate;

    @Autowired
    public KioskWebSocketHandler(ObjectMapper objectMapper, AlertLogService alertLogService, RecipientService recipientService) {
        this.objectMapper = objectMapper;
        this.alertLogService = alertLogService;
        this.recipientService = recipientService;
    }

    /**
     * [핵심 수정] @Lazy 어노테이션 추가
     * 순환 참조(Circular Reference) 문제를 해결하기 위해
     * SimpMessagingTemplate 주입 시점을 실제 사용 시점까지 지연시킵니다.
     */
    @Autowired
    public void setMessagingTemplate(@Lazy SimpMessagingTemplate messagingTemplate) {
        this.messagingTemplate = messagingTemplate;
    }

    // Kiosk Code를 키로, WebSocketSession을 값으로 저장 (온라인 키오스크 관리)
    private final Map<String, WebSocketSession> kioskSessions = new ConcurrentHashMap<>();
    // WebSocketSession ID를 키로, Kiosk Code를 값으로 저장 (세션 종료 시 kioskCode 찾기 위함)
    private final Map<String, String> sessionToKioskCode = new ConcurrentHashMap<>();


    @Override
    public void afterConnectionEstablished(WebSocketSession session) {
        log.info("[Kiosk WS] New connection established: {}", session.getId());
        // 키오스크 코드는 연결 직후 'kiosk_connect' 메시지로 받음
    }

    @Override
    public void handleTextMessage(WebSocketSession session, TextMessage message) {
        try {
            Map<String, String> payload = objectMapper.readValue(message.getPayload(), new TypeReference<>() {});
            String type = payload.get("type");
            String kioskCode = payload.get("kioskCode"); // 모든 메시지에 kioskCode 포함 가정

            log.info("[Kiosk WS] Received from {}: type={}, payload={}", kioskCode, type, message.getPayload());

            if (kioskCode == null || kioskCode.isEmpty()) {
                log.warn("[Kiosk WS] Message without kioskCode received: {}", message.getPayload());
                return;
            }

            switch (type) {
                case "kiosk_connect":
                    handleKioskConnect(session, kioskCode);
                    break;
                case "emergency":
                case "contact_request":
                case "danger": // [추가] AI 위협 감지 타입 추가
                    handleAlert(kioskCode, type);
                    break;
                case "location_update":
                    handleLocationUpdate(kioskCode, payload);
                    break;
                default:
                    log.warn("[Kiosk WS] Unknown message type from {}: {}", kioskCode, type);
            }
        } catch (Exception e) {
            log.error("[Kiosk WS] Error handling message: {}", e.getMessage(), e);
        }
    }

    // 키오스크 연결 시, 상태 업데이트
    private void handleKioskConnect(WebSocketSession session, String kioskCode) {
        kioskSessions.put(kioskCode, session);
        sessionToKioskCode.put(session.getId(), kioskCode);
        log.info("[Kiosk WS] Kiosk '{}' registered with session ID: {}", kioskCode, session.getId());

        try {
            Recipient recipient = recipientService.getRecipientByKioskCode(kioskCode);
            if (recipient != null) {
                recipientService.updateLastConnectedAt(recipient.getRecId(), LocalDateTime.now());
                log.info("[Kiosk WS] Recipient {} ({}) status updated to online.", recipient.getRecName(), kioskCode);

                // 관리자 페이지에 실시간 상태 전송
                messagingTemplate.convertAndSend("/topic/kiosk.status",
                        Map.of("kioskCode", kioskCode, "status", "online"));
            }
        } catch (Exception e) {
            log.error("[Kiosk WS] Error updating kiosk connect status for '{}': {}", kioskCode, e.getMessage());
        }
    }

    // 긴급 호출, 연락 요청, 위협 감지 처리
    private void handleAlert(String kioskCode, String type) {
        try {
            Recipient recipient = recipientService.getRecipientByKioskCode(kioskCode);
            if (recipient == null) {
                log.warn("[Kiosk WS] Invalid kioskCode '{}' for alert.", kioskCode);
                return;
            }

            String dbType = "CONTACT";
            String autoMessage = recipient.getRecName() + "님이 보호자의 연락을 기다립니다.";
            String iconClass = "bi-person-lines-fill";
            String bgClass = "bg-warning";

            if ("emergency".equalsIgnoreCase(type)) {
                dbType = "EMERGENCY";
                autoMessage = recipient.getRecName() + "님이 키오스크에서 '긴급 호출' 버튼을 눌렀습니다!";
                iconClass = "bi-exclamation-triangle-fill";
                bgClass = "bg-danger";
            } else if ("danger".equalsIgnoreCase(type)) {
                dbType = "DANGER";
                autoMessage = recipient.getRecName() + "님에게 위협 상황(AI 감지)이 발생했습니다!";
                iconClass = "bi-fire";
                bgClass = "bg-danger";
            }

            AlertLog alert = AlertLog.builder()
                    .recId(recipient.getRecId())
                    .alertType(dbType)
                    .alertMsg(autoMessage)
                    .build();

            // 1. DB 저장
            alertLogService.register(alert);
            log.info("[Kiosk WS] Alert saved to DB: {}", autoMessage);

            // 2. 관리자에게 실시간 알림 전송 (STOMP)
            CareTimelineItem timelineItem = CareTimelineItem.builder()
                    .type(dbType)
                    .message(autoMessage)
                    .timestamp(LocalDateTime.now())
                    .iconClass(iconClass)
                    .bgClass(bgClass)
                    .link("/admin/alerts") // 알림 관리 페이지 링크
                    .build();

            // '/topic/care-timeline'을 구독 중인 관리자에게 전송
            if (messagingTemplate != null) {
                messagingTemplate.convertAndSend("/topic/care-timeline", timelineItem);
                log.info("[Kiosk WS] Real-time alert sent to admin via /topic/care-timeline: {}", timelineItem);
            } else {
                log.warn("[Kiosk WS] MessagingTemplate is null. Cannot send real-time alert.");
            }

        } catch (Exception e) {
            log.error("[Kiosk WS] Error processing alert for kioskCode '{}': {}", kioskCode, e.getMessage(), e);
        }
    }

    // 위치 정보 업데이트 처리
    private void handleLocationUpdate(String kioskCode, Map<String, String> payload) {
        try {
            Double latitude = Double.parseDouble(payload.get("latitude"));
            Double longitude = Double.parseDouble(payload.get("longitude"));

            Recipient recipient = recipientService.getRecipientByKioskCode(kioskCode);
            if (recipient != null) {
                // 1. DB에 위치 정보 업데이트
                recipientService.updateLocation(recipient.getRecId(), latitude, longitude);
                log.info("[Kiosk WS] Location updated for recipient {} ({}): lat={}, lon={}", recipient.getRecName(), kioskCode, latitude, longitude);

                // 2. 보호자 페이지(center.jsp)에 실시간 위치 전송
                if (messagingTemplate != null) {
                    Map<String, Object> locationPayload = new java.util.HashMap<>();
                    locationPayload.put("recId", recipient.getRecId());
                    locationPayload.put("latitude", latitude);
                    locationPayload.put("longitude", longitude);

                    String destination = "/topic/location/" + recipient.getRecId();
                    messagingTemplate.convertAndSend(destination, locationPayload);
                    log.info("[Kiosk WS] Sent real-time location to: {}", destination);
                }
            }
        } catch (NumberFormatException e) {
            log.error("[Kiosk WS] Invalid latitude/longitude format for kioskCode '{}'", kioskCode, e);
        } catch (Exception e) {
            log.error("[Kiosk WS] Error updating location for kioskCode '{}': {}", kioskCode, e.getMessage(), e);
        }
    }


    @Override
    public void afterConnectionClosed(WebSocketSession session, CloseStatus status) {
        log.info("[Kiosk WS] Client {} disconnected. Status: {}", session.getId(), status);
        String kioskCode = sessionToKioskCode.remove(session.getId()); // 세션 맵에서 제거
        if (kioskCode != null) {
            kioskSessions.remove(kioskCode); // 키오스크 맵에서도 제거
            try {
                Recipient recipient = recipientService.getRecipientByKioskCode(kioskCode);
                if (recipient != null) {
                    // 마지막 접속 시간을 현재 시간으로 업데이트하여 오프라인 상태와 마지막 접속 시간을 기록
                    recipientService.updateLastConnectedAt(recipient.getRecId(), LocalDateTime.now());
                    log.info("[Kiosk WS] Recipient {} ({}) last connected time updated.", recipient.getRecName(), kioskCode);

                    // 관리자 페이지에 실시간 상태 전송
                    messagingTemplate.convertAndSend("/topic/kiosk.status",
                            Map.of("kioskCode", kioskCode, "status", "offline"));
                }
            } catch (Exception e) {
                log.error("[Kiosk WS] Error updating kiosk disconnect status for '{}': {}", kioskCode, e.getMessage());
            }
        }
    }

    @Override
    public void handleTransportError(WebSocketSession session, Throwable exception) {
        log.error("[Kiosk WS] Transport error for session {}: {}", session.getId(), exception.getMessage());
        // 에러 발생 시에도 afterConnectionClosed가 호출되므로 여기서 추가 처리 불필요
    }

    public void sendMessageToKiosk(String kioskCode, String message) {
        WebSocketSession session = kioskSessions.get(kioskCode);
        if (session != null && session.isOpen()) {
            try {
                log.info("Sending message to kiosk {}: {}", kioskCode, message);
                session.sendMessage(new TextMessage(message));
            } catch (IOException e) {
                log.error("Failed to send message to kiosk {}: {}", kioskCode, e.getMessage());
            }
        } else {
            log.warn("Could not find open session for kiosk code: {}", kioskCode);
        }
    }

    public Set<String> getActiveKioskCodes() {
        return kioskSessions.keySet();
    }

}