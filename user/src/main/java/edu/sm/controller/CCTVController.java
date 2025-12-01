package edu.sm.controller;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import edu.sm.app.aiservice.AiImageService;
import edu.sm.app.dto.AlertLog;
import edu.sm.app.dto.Cust;
import edu.sm.app.dto.Recipient;
import edu.sm.app.service.AlertLogService;
import edu.sm.app.service.RecipientService;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.Map;

@Controller
@RequestMapping("/cctv")
@Slf4j
@RequiredArgsConstructor
public class CCTVController {

    private final AiImageService aiImageService;
    private final ObjectMapper objectMapper;
    private final RecipientService recipientService;

    // [추가] 위험 알림을 DB에 저장하고, 실시간으로 보내기 위해 필요한 서비스들
    private final AlertLogService alertLogService;
    private final SimpMessagingTemplate messagingTemplate;

    String dir = "cctv/";

    @RequestMapping("")
    public String main(Model model, HttpSession session) {
        // 1. 세션에서 로그인한 보호자 정보 가져오기
        Cust loginUser = (Cust) session.getAttribute("loginUser");

        if (loginUser != null) {
            try {
                // [DB 연동] 보호자 ID로 노약자 정보 조회
                Recipient recipient = recipientService.getRecipientByCustId(loginUser.getCustId());

                if (recipient != null) {
                    String originalCode = recipient.getRecKioskCode();

                    // CCTV 기기용 방 번호 생성 (DB코드 + _CCTV1, _CCTV2)
                    String cctv1 = originalCode + "_CCTV1";
                    String cctv2 = originalCode + "_CCTV2";

                    model.addAttribute("cctv1", cctv1);
                    model.addAttribute("cctv2", cctv2);

                    log.info("CCTV 접속 - 보호자: {}, 대상자: {}", loginUser.getCustId(), recipient.getRecName());
                }
            } catch (Exception e) {
                log.error("대상 키오스크 조회 실패", e);
            }
        } else {
            // 로그인 안 했을 때 테스트용
            model.addAttribute("cctv1", "test_CCTV1");
            model.addAttribute("cctv2", "test_CCTV2");
        }

        model.addAttribute("center", dir + "center");
        // left 메뉴 제거 - 상단바에서 바로 이동
        return "home";
    }

    @ResponseBody
    @PostMapping("/analyze")
    public Map<String, String> analyzeFrame(
            @RequestParam(value = "attach") MultipartFile attach,
            @RequestParam(value = "kioskCode", required = false) String kioskCode) throws IOException { // [수정] 누가 보냈는지 알기 위해 kioskCode 받음

        if (attach == null || !attach.getContentType().contains("image/")) {
            return Map.of("activity", "이미지 없음", "alert", "없음");
        }

        String prompt = """
            You are a safety monitoring AI expert. Analyze the image for any potential dangers to the person in it.
            Your response MUST be a JSON object and nothing else.
            The JSON object must contain these three fields:
            1. "status": Must be either "DANGER" or "SAFE".
            2. "description": A detailed description, in Korean, of what you see in the image.
            3. "confidence": Your confidence level in this analysis, from 0.0 to 1.0.

            Example for a dangerous situation:
            {
              "status": "DANGER",
              "description": "노인이 바닥에 쓰러져 움직이지 않습니다. 즉각적인 조치가 필요해 보입니다.",
              "confidence": 0.95
            }
            
            Example for a safe situation:
            {
              "status": "SAFE",
              "description": "사람이 의자에 앉아 TV를 보고 있으며, 특이사항은 없습니다.",
              "confidence": 0.98
            }
            """;

        // 로그가 너무 길지 않게 debug 레벨로 변경 (application-dev.yml 설정 덕분에 안 보임)
        String analysisResult = aiImageService.imageAnalysis2(prompt, attach.getContentType(), attach.getBytes());
        log.debug("AI Raw Response: {}", analysisResult);

        String activity = "상태 분석 중...";
        String alert = "없음";

        String cleanedJson = analysisResult;
        int firstBrace = cleanedJson.indexOf('{');
        int lastBrace = cleanedJson.lastIndexOf('}');

        if (firstBrace != -1 && lastBrace != -1 && lastBrace > firstBrace) {
            cleanedJson = cleanedJson.substring(firstBrace, lastBrace + 1);
        }

        try {
            JsonNode rootNode = objectMapper.readTree(cleanedJson);
            String status = rootNode.path("status").asText();
            String description = rootNode.path("description").asText("분석 내용 없음");

            if ("DANGER".equals(status)) {
                activity = "!!! 위험 감지 !!!";
                alert = description;

                // 위험 상황 로그 출력
                log.info("🚨 위험 상황 감지됨: {}", description);

                // [핵심] 위험하고, 누가 보냈는지(kioskCode) 알면 -> 알림 발송 및 DB 저장!
                if(kioskCode != null && !kioskCode.isEmpty()) {
                    processDangerAlert(kioskCode, description);
                }

            } else if ("SAFE".equals(status)) {
                activity = description;
                alert = "없음";
            } else {
                activity = "분석 상태 불명확";
                alert = description;
            }
        } catch (JsonProcessingException e) {
            log.error("AI 파싱 실패", e);
            activity = "AI 응답 파싱 실패";
            alert = analysisResult;
        }

        return Map.of("activity", activity, "alert", alert);
    }

    // [추가] 위험 알림 처리 메소드 (DB 저장 + 웹소켓 전송)
    private void processDangerAlert(String kioskCode, String message) {
        try {
            // 1. 코드로 대상자 찾기
            Recipient recipient = recipientService.getRecipientByKioskCode(kioskCode);
            if(recipient == null) return;

            // 2. DB에 기록 (AlertLogService가 있다면 사용)
            if (alertLogService != null) {
                AlertLog alertLog = AlertLog.builder()
                        .recId(recipient.getRecId())
                        .alertType("DANGER")
                        .alertMsg("CCTV 자동 감지: " + message)
                        .build();
                alertLogService.register(alertLog);
            }

            // 3. 보호자 화면(home.jsp)으로 실시간 알림 전송
            Map<String, Object> payload = Map.of(
                    "type", "DANGER",
                    "message", message,
                    "recName", recipient.getRecName(),
                    "timestamp", java.time.LocalDateTime.now().toString()
            );

            // /topic/alert를 구독 중인 모든 클라이언트(home.jsp)에게 메시지 전송
            messagingTemplate.convertAndSend("/topic/alert", payload);
            log.info("위험 알림 전송 완료 to /topic/alert");

        } catch (Exception e) {
            log.error("위험 알림 처리 중 오류", e);
        }
    }
}