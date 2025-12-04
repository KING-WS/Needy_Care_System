package edu.sm.controller;

import edu.sm.app.dto.ChatRequest;
import edu.sm.app.dto.ChatResponse; // ChatResponse 임포트
import edu.sm.app.aiservice.AiChatService;   // AiChatService 임포트
import edu.sm.app.aiservice.AiSttService;
import edu.sm.app.service.ChatLogService;
import edu.sm.app.dto.ChatLog;
import edu.sm.app.service.RecipientService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@RestController
@RequestMapping("/api/chat/ai")
@RequiredArgsConstructor
@Slf4j
public class ChatAiController {

    private final ChatLogService chatLogService;
    private final RecipientService recipientService;
    private final AiSttService aiSttService;
    private final AiChatService aiChatService; // AiChatService 다시 추가

    @PostMapping("/send")
    public ResponseEntity<Map<String, String>> sendMessage(@RequestBody ChatRequest request) {
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
                    return ResponseEntity.badRequest().body(Map.of("text", "오류: 유효하지 않은 키오스크 코드입니다."));
                }
            } else {
                return ResponseEntity.badRequest().body(Map.of("text", "오류: 사용자 정보가 필요합니다."));
            }
        } catch (Exception e) {
            log.error("recId 조회 중 오류 발생", e);
            return ResponseEntity.internalServerError().body(Map.of("text", "오류: 사용자 정보를 찾는 중 문제가 발생했습니다."));
        }

        // 2. 사용자 메시지를 Chat_Log 테이블에 저장
        ChatLog userLog = new ChatLog(null, recId, "USER", request.getMessage(), null, "N", null);
        chatLogService.saveChatLog(userLog);

        // 3. AiChatService를 사용하여 지능적인 텍스트 응답 생성
        String textAnswer = aiChatService.generateResponse(recId, request.getMessage());

        // 4. AiSttService를 사용하여 텍스트를 음성으로 변환
        byte[] audioBytes = aiSttService.tts(textAnswer);
        String base64Audio = java.util.Base64.getEncoder().encodeToString(audioBytes);

        // 5. AI 응답(텍스트)을 Chat_Log 테이블에 저장
        ChatLog aiLog = new ChatLog(null, recId, "AI", textAnswer, null, "N", null);
        chatLogService.saveChatLog(aiLog);

        // 6. 텍스트와 오디오가 포함된 Map을 클라이언트에 반환
        Map<String, String> response = new java.util.HashMap<>();
        response.put("text", textAnswer);
        response.put("audio", base64Audio);
        
        return ResponseEntity.ok(response);
    }
}
