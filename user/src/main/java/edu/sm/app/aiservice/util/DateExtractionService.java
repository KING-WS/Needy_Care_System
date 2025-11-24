package edu.sm.app.aiservice.util;

import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.extern.slf4j.Slf4j;
import org.springframework.ai.chat.client.ChatClient;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.util.Map;

/**
 * 날짜 추출 서비스
 */
@Service
@Slf4j
public class DateExtractionService {
    
    private final ChatClient chatClient;
    private final ObjectMapper objectMapper;
    private final AiUtilService aiUtilService;
    
    public DateExtractionService(
            ChatClient.Builder chatClientBuilder,
            ObjectMapper objectMapper,
            AiUtilService aiUtilService) {
        this.chatClient = chatClientBuilder.build();
        this.objectMapper = objectMapper;
        this.aiUtilService = aiUtilService;
    }
    
    /**
     * 텍스트에서 날짜 추출 (이번주 금요일, 이번달 23일 등)
     */
    public String extractDateFromText(String text) {
        try {
            String extractionPrompt = """
                다음 텍스트에서 날짜 정보를 추출해주세요.
                
                추출 가능한 날짜 표현:
                - "이번주 금요일", "다음주 월요일" 등
                - "이번달 23일", "다음달 15일" 등
                - "오늘", "내일", "모레" 등
                - "11월 26일", "12월 1일" 등
                
                응답은 반드시 JSON 형식으로만 해주세요:
                {
                  "date": "YYYY-MM-DD 형식의 날짜",
                  "found": true 또는 false
                }
                
                날짜를 찾을 수 없으면 found를 false로 하고, date는 오늘 날짜를 반환하세요.
                
                현재 날짜: %s
                텍스트: %s
                """.formatted(LocalDate.now().toString(), text);
            
            String response = chatClient.prompt()
                    .user(extractionPrompt)
                    .call()
                    .content();
            
            String json = aiUtilService.extractJson(response);
            log.debug("날짜 추출 원본 응답: {}", response);
            log.debug("추출된 JSON: {}", json);
            
            Map<String, Object> dateData = aiUtilService.parseJsonToMap(json);
            
            Boolean found = dateData.get("found") != null ? 
                Boolean.parseBoolean(dateData.get("found").toString()) : false;
            String dateStr = dateData.get("date") != null ? 
                dateData.get("date").toString() : LocalDate.now().toString();
            
            if (found && dateStr != null && !dateStr.isEmpty()) {
                // 날짜 형식 검증
                try {
                    LocalDate.parse(dateStr);
                    log.info("날짜 추출 성공: {} -> {}", text, dateStr);
                    return dateStr;
                } catch (Exception e) {
                    log.warn("날짜 형식 오류: {}", dateStr);
                }
            }
            
            // 날짜를 찾지 못했거나 형식 오류 시 오늘 날짜 반환
            log.info("날짜 추출 실패 또는 없음, 오늘 날짜 사용: {}", text);
            return LocalDate.now().toString();
            
        } catch (Exception e) {
            log.error("날짜 추출 실패", e);
            return LocalDate.now().toString();
        }
    }
    
    /**
     * 사용자 메시지에서 날짜 정보를 추출합니다.
     */
    public Map<String, Object> extractDateFromMessage(String userMessage, Map<String, Object> params) {
        try {
            // 이미 params에 날짜가 있으면 그대로 사용
            if (params.containsKey("date")) {
                return params;
            }
            
            // 간단한 날짜 추출 (오늘, 내일, 모레 등)
            LocalDate extractedDate = LocalDate.now();
            
            if (userMessage.contains("오늘") || userMessage.contains("오늘의")) {
                extractedDate = LocalDate.now();
            } else if (userMessage.contains("내일")) {
                extractedDate = LocalDate.now().plusDays(1);
            } else if (userMessage.contains("모레")) {
                extractedDate = LocalDate.now().plusDays(2);
            } else if (userMessage.contains("어제")) {
                extractedDate = LocalDate.now().minusDays(1);
            } else if (userMessage.contains("다음주")) {
                extractedDate = LocalDate.now().plusWeeks(1);
            } else if (userMessage.contains("이번주")) {
                extractedDate = LocalDate.now();
            }
            
            // 추출된 날짜를 params에 추가
            params.put("date", extractedDate.toString());
            log.debug("메시지에서 날짜 추출: {} -> {}", userMessage, extractedDate);
            
        } catch (Exception e) {
            log.warn("날짜 추출 실패, 기본값(오늘) 사용: {}", userMessage, e);
        }
        
        return params;
    }
}

