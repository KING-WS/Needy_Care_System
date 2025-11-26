package edu.sm.app.aiservice;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import edu.sm.app.dto.Recipient;
import edu.sm.app.service.RecipientService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.ai.chat.client.ChatClient;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

import java.util.Base64;
import java.util.HashMap;
import java.util.Map;

/**
 * AI 식단 안전성 검사 서비스
 * 사용자의 알레르기, 병력, 건강요구사항 등을 기반으로 음식의 안전성을 검사
 */
@Service
@Slf4j
@RequiredArgsConstructor
public class AiMealSafetyService {

    private final ChatClient chatClient;
    private final RecipientService recipientService;
    private final ObjectMapper objectMapper;
    private final AiImageService aiImageService;

    /**
     * 식단 안전성 검사
     * @param recId 노약자 ID
     * @param imageBase64 이미지 Base64 인코딩 문자열 (선택사항)
     * @param mealDescription 음식 설명 (이미지가 없을 경우)
     * @return 안전성 검사 결과
     */
    public Map<String, Object> checkMealSafety(Integer recId, String imageBase64, String mealDescription) {
        log.info("AI 식단 안전성 검사 시작 - recId: {}", recId);

        try {
            // 노약자 정보 조회
            Recipient recipient = recipientService.getRecipientById(recId);
            if (recipient == null) {
                return Map.of("success", false, "message", "노약자 정보를 찾을 수 없습니다.");
            }

            // AI 프롬프트 생성
            StringBuilder prompt = new StringBuilder();
            prompt.append("당신은 노약자 돌봄 전문가입니다. 다음 정보를 바탕으로 음식의 안전성을 검사해주세요.\n\n");
            
            prompt.append("[노약자 정보]\n");
            prompt.append("이름: ").append(recipient.getRecName()).append("\n");
            
            if (StringUtils.hasText(recipient.getRecAllergies())) {
                prompt.append("알레르기: ").append(recipient.getRecAllergies()).append("\n");
            }
            if (StringUtils.hasText(recipient.getRecMedHistory())) {
                prompt.append("병력: ").append(recipient.getRecMedHistory()).append("\n");
            }
            if (StringUtils.hasText(recipient.getRecHealthNeeds())) {
                prompt.append("건강 요구사항: ").append(recipient.getRecHealthNeeds()).append("\n");
            }
            if (StringUtils.hasText(recipient.getRecSpecNotes())) {
                prompt.append("추가 정보: ").append(recipient.getRecSpecNotes()).append("\n");
            }
            
            String aiResponse;
            
            // 이미지가 제공된 경우 이미지 분석 사용
            if (StringUtils.hasText(imageBase64)) {
                try {
                    // Base64 디코딩
                    byte[] imageBytes = Base64.getDecoder().decode(imageBase64);
                    
                    // 이미지 분석 프롬프트 생성
                    StringBuilder imagePrompt = new StringBuilder();
                    imagePrompt.append("이 이미지에 있는 음식을 식별하고 분석해주세요.\n\n");
                    imagePrompt.append(prompt.toString());
                    imagePrompt.append("\n\n위의 노약자 정보를 바탕으로 이 음식이 안전한지 검사해주세요.");
                    
                    // AiImageService를 사용하여 이미지 분석
                    String imageAnalysisResult = aiImageService.imageAnalysis2(
                        imagePrompt.toString(),
                        "image/jpeg",
                        imageBytes
                    );
                    
                    if (imageAnalysisResult == null || imageAnalysisResult.trim().isEmpty()) {
                        throw new Exception("이미지 분석 결과가 없습니다.");
                    }
                    
                    // 이미지 분석 결과를 JSON 형식으로 변환하는 프롬프트
                    String jsonConversionPrompt = String.format("""
                        다음 이미지 분석 결과를 바탕으로 JSON 형식으로 변환해주세요.
                        
                        이미지 분석 결과:
                        %s
                        
                        노약자 정보:
                        %s
                        
                        반드시 다음 JSON 형식으로만 응답해주세요:
                        {
                          "isSafe": true/false,
                          "safetyLevel": "SAFE" | "WARNING" | "DANGER",
                          "message": "안전성 검사 결과 메시지 (환자가 이 음식을 먹을 수 있는지 명확히 알려주세요)",
                          "warnings": ["주의사항1", "주의사항2", ...],
                          "recommendations": ["권장사항1", "권장사항2", ...],
                          "detectedFoods": ["감지된 음식1", "감지된 음식2", ...]
                        }
                        """, imageAnalysisResult != null ? imageAnalysisResult : "", prompt.toString());
                    
                    @SuppressWarnings("null")
                    String response = chatClient.prompt()
                            .user(jsonConversionPrompt)
                            .call()
                            .content();
                    aiResponse = response;
                } catch (Exception e) {
                    log.error("이미지 분석 실패", e);
                    // 이미지 분석 실패 시 텍스트 기반 분석으로 폴백
                    prompt.append("\n[검사할 음식]\n");
                    prompt.append("이미지 분석에 실패했습니다. 음식 설명을 제공해주세요.\n");
                    if (StringUtils.hasText(mealDescription)) {
                        prompt.append("음식 설명: ").append(mealDescription).append("\n");
                    }
                    prompt.append(createAnalysisPrompt());
                    @SuppressWarnings("null")
                    String response1 = chatClient.prompt()
                            .user(prompt.toString())
                            .call()
                            .content();
                    aiResponse = response1;
                }
            } else {
                // 텍스트 기반 분석
                prompt.append("\n[검사할 음식]\n");
                if (StringUtils.hasText(mealDescription)) {
                    prompt.append("음식 설명: ").append(mealDescription).append("\n");
                }
                prompt.append(createAnalysisPrompt());
                @SuppressWarnings("null")
                String response2 = chatClient.prompt()
                        .user(prompt.toString())
                        .call()
                        .content();
                aiResponse = response2;
            }

            log.info("AI 응답: {}", aiResponse);

            // JSON 추출 및 파싱
            String json = extractJson(aiResponse);
            if (json == null || json.trim().isEmpty()) {
                return Map.of("success", false, "message", "AI 응답을 파싱할 수 없습니다.");
            }

            @SuppressWarnings({"unchecked", "null"})
            Map<String, Object> result = objectMapper.readValue(json, Map.class);
            
            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("data", result);
            
            return response;

        } catch (JsonProcessingException e) {
            log.error("JSON 파싱 실패", e);
            return Map.of("success", false, "message", "응답 파싱 중 오류가 발생했습니다.");
        } catch (Exception e) {
            log.error("AI 식단 안전성 검사 실패", e);
            return Map.of("success", false, "message", "안전성 검사 중 오류가 발생했습니다: " + e.getMessage());
        }
    }

    /**
     * 분석 프롬프트 생성
     */
    private String createAnalysisPrompt() {
        return """
                
                [검사 항목]
                1. 알레르기 유발 성분 포함 여부
                2. 병력에 따른 금기 음식 여부
                3. 건강 요구사항에 맞는지 여부
                4. 노약자에게 적합한 음식인지 여부
                
                [응답 형식]
                반드시 다음 JSON 형식으로만 응답해주세요:
                {
                  "isSafe": true/false,
                  "safetyLevel": "SAFE" | "WARNING" | "DANGER",
                  "message": "안전성 검사 결과 메시지 (환자가 이 음식을 먹을 수 있는지 명확히 알려주세요)",
                  "warnings": ["주의사항1", "주의사항2", ...],
                  "recommendations": ["권장사항1", "권장사항2", ...],
                  "detectedFoods": ["감지된 음식1", "감지된 음식2", ...]
                }
                
                - isSafe: 안전 여부 (true/false)
                - safetyLevel: 안전 수준 (SAFE: 안전, WARNING: 주의 필요, DANGER: 위험)
                - message: 사용자에게 보여줄 메시지 (환자가 먹을 수 있는지 명확히 표시)
                - warnings: 주의사항 목록
                - recommendations: 권장사항 목록
                - detectedFoods: 감지된 음식 목록
                """;
    }

    /**
     * AI 응답에서 JSON 추출
     */
    private String extractJson(String response) {
        if (response == null || response.trim().isEmpty()) {
            return null;
        }

        int firstBrace = response.indexOf('{');
        int lastBrace = response.lastIndexOf('}');

        if (firstBrace != -1 && lastBrace != -1 && lastBrace > firstBrace) {
            return response.substring(firstBrace, lastBrace + 1);
        }

        return null;
    }
}

