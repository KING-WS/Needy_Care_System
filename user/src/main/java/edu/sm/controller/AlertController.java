package edu.sm.controller;

import edu.sm.app.dto.AlertLog;
import edu.sm.app.dto.Recipient;
import edu.sm.app.service.AlertLogService;
import edu.sm.app.service.RecipientService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.Map;

@RestController
@RequestMapping("/api/alert")
@RequiredArgsConstructor
@Slf4j
public class AlertController {

    private final AlertLogService alertLogService;
    private final RecipientService recipientService;

    @PostMapping("/send")
    public Map<String, String> sendAlert(@RequestBody Map<String, String> requestData) {
        // 프론트에서는 코드랑 타입만 보내면 됨 (메시지 안 보내도 됨)
        String kioskCode = requestData.get("kioskCode");
        String type = requestData.get("type"); // 'emergency' 또는 'contact'

        log.info("🚨 알림 요청 수신 - 타입: {}, 코드: {}", type, kioskCode);

        try {
            // 1. 키오스크 코드로 대상자(할머니/할아버지) 찾기
            Recipient recipient = recipientService.getRecipientByKioskCode(kioskCode);
            if (recipient == null) {
                return Map.of("status", "error", "message", "유효하지 않은 사용자");
            }

            // 2. 상황에 맞는 메시지를 서버가 자동으로 생성 (DB 저장용)
            String dbType = "";
            String autoMessage = "";

            if ("emergency".equalsIgnoreCase(type)) {
                dbType = "EMERGENCY";
                autoMessage = "🚨 [" + recipient.getRecName() + "]님이 태블릿에서 '긴급 호출' 버튼을 눌렀습니다!";
            } else {
                dbType = "CONTACT";
                autoMessage = "📞 [" + recipient.getRecName() + "]님이 보호자의 연락을 기다립니다.";
            }

            // 3. DB에 저장 (자동 생성된 메시지를 alert_msg에 넣음)
            AlertLog alert = AlertLog.builder()
                    .recId(recipient.getRecId())
                    .alertType(dbType)
                    .alertMsg(autoMessage)
                    .build();

            alertLogService.register(alert);
            log.info("✅ 알림 DB 저장 완료: {}", autoMessage);

            return Map.of("status", "success", "msg", autoMessage);

        } catch (Exception e) {
            log.error("알림 처리 중 오류", e);
            return Map.of("status", "error", "message", "서버 오류가 발생했습니다.");
        }
    }
}