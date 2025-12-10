package edu.sm.controller;

import edu.sm.app.dto.ChatRequest;
import edu.sm.app.aiservice.AiChatService;
import edu.sm.app.aiservice.AiSttService;
import edu.sm.app.service.ChatLogService;
import edu.sm.app.dto.ChatLog;
import edu.sm.app.service.RecipientService;
import edu.sm.app.service.AlertLogService;
import edu.sm.app.dto.AlertLog;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Map;
import java.time.LocalDateTime;
import java.util.HashMap; // HashMap import 추가 필요할 수 있음

@RestController
@RequestMapping("/api/chat/ai")
@RequiredArgsConstructor
@Slf4j
public class ChatAiController {

    private final ChatLogService chatLogService;
    private final RecipientService recipientService;
    private final AiSttService aiSttService;
    private final AiChatService aiChatService;
    private final AlertLogService alertLogService;

    @PostMapping("/send")
    public ResponseEntity<Map<String, Object>> sendMessage(@RequestBody ChatRequest request) {
        log.info("AI 채팅 메시지 수신: kioskCode={}, recId={}, message='{}'",
                request.getKioskCode(), request.getRecId(), request.getMessage());

        // 1. recId 조회
        Integer recId = null;
        try {
            if (request.getRecId() != null && request.getRecId() > 0) {
                recId = request.getRecId();
            } else if (request.getKioskCode() != null && !request.getKioskCode().isEmpty()) {
                var recipient = recipientService.getRecipientByKioskCode(request.getKioskCode());
                if (recipient != null) {
                    recId = recipient.getRecId();
                } else {
                    // [수정 1] "text" -> "reply"
                    return ResponseEntity.badRequest().body(Map.of("reply", "오류: 유효하지 않은 태블릿 코드입니다."));
                }
            } else {
                // [수정 2] "text" -> "reply"
                return ResponseEntity.badRequest().body(Map.of("reply", "오류: 사용자 정보가 필요합니다."));
            }
        } catch (Exception e) {
            log.error("recId 조회 중 오류 발생", e);
            // [수정 3] "text" -> "reply"
            return ResponseEntity.internalServerError().body(Map.of("reply", "오류: 사용자 정보를 찾는 중 문제가 발생했습니다."));
        }

        // --- 긴급 호출 로직 ---
        String[] emergencyKeywords = {"긴급호출", "긴급 호출", "살려줘", "우울해"};
        String userMessage = request.getMessage();
        boolean isEmergency = false;
        for (String keyword : emergencyKeywords) {
            if (userMessage.contains(keyword)) {
                isEmergency = true;
                break;
            }
        }

        if (isEmergency) {
            log.warn("긴급 키워드 감지됨: '{}' (recId: {})", userMessage, recId);
            try {
                AlertLog chatUrgentAlert = AlertLog.builder()
                        .recId(recId != null ? recId : 0)
                        .alertType("CHAT_URGENT")
                        .alertMsg("AI 챗봇 메시지를 통한 긴급 알림 감지: " + userMessage)
                        .checkStatus("N")
                        .alertRegdate(LocalDateTime.now())
                        .build();
                alertLogService.register(chatUrgentAlert);
                // [수정 4] "text" -> "reply" (여기도 고쳐야 긴급호출 답변이 보입니다)
                return ResponseEntity.ok(Map.of("reply", "긴급 알림이 어드민에게 전송되었습니다. 잠시만 기다려주세요."));
            } catch (Exception e) {
                log.error("긴급 알림 등록 중 오류 발생", e);
                // [수정 5] "text" -> "reply"
                return ResponseEntity.internalServerError().body(Map.of("reply", "긴급 알림 처리 중 오류가 발생했습니다."));
            }
        }
        // --- 긴급 호출 로직 끝 ---

        // 2. 사용자 메시지 저장
        ChatLog userLog = new ChatLog(null, recId, "USER", request.getMessage(), null, "N", null);
        chatLogService.saveChatLog(userLog);

        // 3. AI 응답 생성
        String textAnswer = aiChatService.generateResponse(recId, request.getMessage());

        // AI 응답 저장
        ChatLog aiLog = new ChatLog(null, recId, "AI", textAnswer, null, "N", null);
        chatLogService.saveChatLog(aiLog);

        // 4. TTS 음성 생성
        String base64Audio = null;
        try {
            Map<String, String> ttsResult = aiSttService.tts2(textAnswer);
            base64Audio = ttsResult.get("audio");
            log.debug("TTS 음성 생성 완료 - 길이: {}", base64Audio != null ? base64Audio.length() : 0);
        } catch (Exception e) {
            log.error("TTS 음성 생성 중 오류 발생", e);
            // TTS 실패해도 텍스트 응답은 정상 반환
        }

        // 응답 생성
        Map<String, Object> response = new HashMap<>();

        // [핵심 수정] "text" -> "reply" 로 변경!
        response.put("reply", textAnswer);

        response.put("audio", base64Audio);
        
        // recId는 항상 포함 (클라이언트에서 버튼 생성 시 필요)
        response.put("recId", recId);

        // 식단 추천 플래그 (더 유연한 감지 - 느낌표 포함 버전도 체크)
        if (textAnswer.contains("식단을 추천해드릴게요") || 
            textAnswer.contains("식단을 추천해드릴게요!") ||
            textAnswer.contains("이 식단을 등록하시겠어요") ||
            (textAnswer.contains("식단을 추천") && textAnswer.contains("등록"))) {
            response.put("hasMealRecommendation", true);
            log.info("식단 추천 플래그 설정됨 - recId: {}, 응답 일부: {}", recId, textAnswer.substring(0, Math.min(50, textAnswer.length())));
        }

        // 일정 추천 플래그 (더 유연한 감지 - 느낌표, 공백 등 무시)
        if (textAnswer.contains("일정을 추천해드릴게요") || 
            textAnswer.contains("일정을 추천해드릴게요!") ||
            textAnswer.contains("이 일정으로 등록하시겠어요") ||
            (textAnswer.contains("일정을 추천") && textAnswer.contains("등록"))) {
            response.put("hasScheduleRecommendation", true);
            log.info("일정 추천 플래그 설정됨 - recId: {}, 응답 일부: {}", recId, textAnswer.substring(0, Math.min(50, textAnswer.length())));
        }

        return ResponseEntity.ok(response);
    }
}