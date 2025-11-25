package edu.sm.app.aiservice.util;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.Map;

/**
 * AI 관련 유틸리티 서비스
 * - JSON 추출
 * - 날짜 추출
 * - 일정명 생성
 */
@Service
@Slf4j
public class AiUtilService {
    
    private final ObjectMapper objectMapper;
    
    public AiUtilService(ObjectMapper objectMapper) {
        this.objectMapper = objectMapper;
    }
    
    /**
     * 텍스트에서 JSON 추출
     */
    public String extractJson(String text) {
        if (text == null || text.trim().isEmpty()) {
            return "{}";
        }
        
        // JSON 코드 블록 제거 (```json ... ``` 형식)
        text = text.replaceAll("```json\\s*", "").replaceAll("```\\s*", "");
        text = text.replaceAll("```\\s*", "");
        
        // 배열 우선 확인 (일정 추천 등에서 사용)
        int firstBracket = text.indexOf('[');
        int lastBracket = text.lastIndexOf(']');
        
        if (firstBracket != -1 && lastBracket != -1 && lastBracket > firstBracket) {
            String arrayJson = text.substring(firstBracket, lastBracket + 1);
            // 간단한 유효성 검사: 대괄호가 짝이 맞는지 확인
            if (isValidJson(arrayJson)) {
                return arrayJson;
            }
        }
        
        // 배열이 없으면 객체 확인
        int firstBrace = text.indexOf('{');
        int lastBrace = text.lastIndexOf('}');
        
        if (firstBrace != -1 && lastBrace != -1 && lastBrace > firstBrace) {
            String objectJson = text.substring(firstBrace, lastBrace + 1);
            // 간단한 유효성 검사: 중괄호가 짝이 맞는지 확인
            if (isValidJson(objectJson)) {
                return objectJson;
            }
        }
        
        log.warn("JSON 추출 실패 - 텍스트: {}", text.substring(0, Math.min(200, text.length())));
        return "{}";
    }
    
    /**
     * 간단한 JSON 유효성 검사 (중괄호/대괄호 짝 확인)
     */
    private boolean isValidJson(String json) {
        if (json == null || json.trim().isEmpty()) {
            return false;
        }
        
        int braceCount = 0;
        int bracketCount = 0;
        
        for (char c : json.toCharArray()) {
            if (c == '{') braceCount++;
            else if (c == '}') braceCount--;
            else if (c == '[') bracketCount++;
            else if (c == ']') bracketCount--;
            
            // 음수가 되면 잘못된 형식
            if (braceCount < 0 || bracketCount < 0) {
                return false;
            }
        }
        
        // 0이면 짝이 맞음
        return braceCount == 0 && bracketCount == 0;
    }
    
    /**
     * JSON 문자열을 Map으로 파싱
     */
    @SuppressWarnings("unchecked")
    public Map<String, Object> parseJsonToMap(String json) throws JsonProcessingException {
        if (json == null || json.trim().isEmpty() || json.equals("{}")) {
            return new HashMap<>();
        }
        return objectMapper.readValue(json, Map.class);
    }
}

