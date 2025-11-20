package edu.sm.controller;

import edu.sm.app.dto.ChatRequest;
import edu.sm.app.dto.ChatResponse;
import edu.sm.app.service.AiChatService;
import edu.sm.app.service.ChatLogService;
import edu.sm.app.dto.ChatLog;
import edu.sm.app.service.RecipientService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/chat/ai")
@RequiredArgsConstructor
@Slf4j
public class ChatAiController {

    private final ChatLogService chatLogService;
    private final RecipientService recipientService;
    private final AiChatService aiChatService; // AiChatService 주입

    @PostMapping("/send")
    public ResponseEntity<ChatResponse> sendMessage(@RequestBody ChatRequest request) {
        log.info("키오스크 {}로부터 AI 채팅 메시지 수신: {}", request.getKioskCode(), request.getMessage());

        // 1. kioskCode를 사용하여 recId 조회
        Integer recId = null;
        try {
            var recipient = recipientService.getRecipientByKioskCode(request.getKioskCode());
            if (recipient != null) {
                recId = recipient.getRecId();
            } else {
                log.warn("유효하지 않은 kioskCode: {}", request.getKioskCode());
                return ResponseEntity.badRequest().body(new ChatResponse("오류: 유효하지 않은 키오스크 코드입니다."));
            }
        } catch (Exception e) {
            log.error("kioskCode로 recId 조회 중 오류 발생", e);
            return ResponseEntity.internalServerError().body(new ChatResponse("오류: 사용자 정보를 찾는 중 문제가 발생했습니다."));
        }

        // 2. 사용자 메시지를 Chat_Log 테이블에 저장
        ChatLog userLog = new ChatLog(null, recId, "USER", request.getMessage(), null, "N", null);
        chatLogService.saveChatLog(userLog);

        // 3. AI 모델에 사용자 메시지 전달 및 응답 받기 (AiChatService 사용)
        String aiResponseMessage = aiChatService.generateResponse(recId, request.getMessage());

        // 4. AI 응답을 Chat_Log 테이블에 저장
        ChatLog aiLog = new ChatLog(null, recId, "AI", aiResponseMessage, null, "N", null);
        chatLogService.saveChatLog(aiLog);

        // 5. AI 응답을 클라이언트에 반환
        return ResponseEntity.ok(new ChatResponse(aiResponseMessage));
    }
}
