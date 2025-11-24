package edu.sm.app.aiservice;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.ai.chat.client.ChatClient;
import org.springframework.stereotype.Service;

import java.util.Base64;
import java.util.HashMap;
import java.util.Map;

/**
 * AI 식단 레시피 서비스
 * 이미지에서 음식을 식별하고 조리법을 제공
 */
@Service
@Slf4j
@RequiredArgsConstructor
public class AiMealRecipeService {

    private final ChatClient chatClient;
    private final AiImageService aiImageService;
    private final ObjectMapper objectMapper;

    /**
     * 이미지에서 음식을 식별하고 레시피 생성
     * @param imageBase64 이미지 Base64 인코딩 문자열
     * @return 레시피 정보
     */
    public Map<String, Object> getRecipeFromImage(String imageBase64) {
        log.info("AI 레시피 생성 시작");

        try {
            if (imageBase64 == null || imageBase64.trim().isEmpty()) {
                return Map.of("success", false, "message", "이미지가 제공되지 않았습니다.");
            }

            // Base64 디코딩
            byte[] imageBytes = Base64.getDecoder().decode(imageBase64);

            // 이미지 분석 프롬프트
            String imageAnalysisPrompt = """
                이 이미지에 있는 음식을 정확히 식별해주세요.
                음식의 이름, 주요 재료, 특징을 자세히 설명해주세요.
                """;

            // 이미지 분석
            String imageAnalysisResult = aiImageService.imageAnalysis2(
                imageAnalysisPrompt,
                "image/jpeg",
                imageBytes
            );

            if (imageAnalysisResult == null || imageAnalysisResult.trim().isEmpty()) {
                return Map.of("success", false, "message", "이미지 분석에 실패했습니다.");
            }

            log.info("이미지 분석 결과: {}", imageAnalysisResult);

            // 레시피 생성 프롬프트
            String recipePrompt = String.format("""
                다음 이미지 분석 결과를 바탕으로 이 음식의 조리법을 순서대로 알려주세요.
                
                이미지 분석 결과:
                %s
                
                반드시 다음 JSON 형식으로만 응답해주세요:
                {
                  "foodName": "음식 이름",
                  "ingredients": ["재료1", "재료2", "재료3", ...],
                  "cookingTime": "조리 시간 (예: 30분)",
                  "difficulty": "난이도 (쉬움/보통/어려움)",
                  "steps": [
                    {
                      "stepNumber": 1,
                      "description": "첫 번째 단계 설명"
                    },
                    {
                      "stepNumber": 2,
                      "description": "두 번째 단계 설명"
                    },
                    ...
                  ],
                  "tips": ["조리 팁1", "조리 팁2", ...]
                }
                
                - foodName: 식별된 음식의 정확한 이름
                - ingredients: 필요한 재료 목록
                - cookingTime: 예상 조리 시간
                - difficulty: 조리 난이도
                - steps: 조리 단계 (순서대로, 최소 3단계 이상)
                - tips: 조리 시 유용한 팁
                """, imageAnalysisResult);

            @SuppressWarnings("null")
            String aiResponse = chatClient.prompt()
                    .user(recipePrompt)
                    .call()
                    .content();

            log.info("AI 레시피 응답: {}", aiResponse);

            // JSON 추출 및 파싱
            String json = extractJson(aiResponse);
            if (json == null || json.trim().isEmpty()) {
                return Map.of("success", false, "message", "레시피 정보를 파싱할 수 없습니다.");
            }

            @SuppressWarnings({"unchecked", "null"})
            Map<String, Object> recipe = objectMapper.readValue(json, Map.class);

            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("recipe", recipe);
            response.put("imageAnalysis", imageAnalysisResult);

            return response;

        } catch (JsonProcessingException e) {
            log.error("JSON 파싱 실패", e);
            return Map.of("success", false, "message", "레시피 정보 파싱 중 오류가 발생했습니다.");
        } catch (Exception e) {
            log.error("AI 레시피 생성 실패", e);
            return Map.of("success", false, "message", "레시피 생성 중 오류가 발생했습니다: " + e.getMessage());
        }
    }

    /**
     * 텍스트로 음식 이름을 입력받아 레시피 생성
     * @param foodName 음식 이름
     * @return 레시피 정보
     */
    public Map<String, Object> getRecipeFromText(String foodName) {
        log.info("AI 레시피 생성 시작 (텍스트) - 음식명: {}", foodName);

        try {
            if (foodName == null || foodName.trim().isEmpty()) {
                return Map.of("success", false, "message", "음식 이름이 제공되지 않았습니다.");
            }

            // 레시피 생성 프롬프트
            String recipePrompt = String.format("""
                다음 음식의 조리법을 순서대로 알려주세요.
                
                음식 이름: %s
                
                반드시 다음 JSON 형식으로만 응답해주세요:
                {
                  "foodName": "음식 이름",
                  "ingredients": ["재료1", "재료2", "재료3", ...],
                  "cookingTime": "조리 시간 (예: 30분)",
                  "difficulty": "난이도 (쉬움/보통/어려움)",
                  "steps": [
                    {
                      "stepNumber": 1,
                      "description": "첫 번째 단계 설명"
                    },
                    {
                      "stepNumber": 2,
                      "description": "두 번째 단계 설명"
                    },
                    ...
                  ],
                  "tips": ["조리 팁1", "조리 팁2", ...]
                }
                
                - foodName: 입력된 음식의 정확한 이름
                - ingredients: 필요한 재료 목록 (구체적인 양 포함)
                - cookingTime: 예상 조리 시간
                - difficulty: 조리 난이도
                - steps: 조리 단계 (순서대로, 최소 3단계 이상, 각 단계는 자세하게)
                - tips: 조리 시 유용한 팁
                
                한국 음식의 경우 전통적인 조리법을 따르되, 노약자도 쉽게 만들 수 있도록 설명해주세요.
                """, foodName.trim());

            @SuppressWarnings("null")
            String aiResponse = chatClient.prompt()
                    .user(recipePrompt)
                    .call()
                    .content();

            log.info("AI 레시피 응답: {}", aiResponse);

            // JSON 추출 및 파싱
            String json = extractJson(aiResponse);
            if (json == null || json.trim().isEmpty()) {
                return Map.of("success", false, "message", "레시피 정보를 파싱할 수 없습니다.");
            }

            @SuppressWarnings({"unchecked", "null"})
            Map<String, Object> recipe = objectMapper.readValue(json, Map.class);

            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("recipe", recipe);

            return response;

        } catch (JsonProcessingException e) {
            log.error("JSON 파싱 실패", e);
            return Map.of("success", false, "message", "레시피 정보 파싱 중 오류가 발생했습니다.");
        } catch (Exception e) {
            log.error("AI 레시피 생성 실패 (텍스트)", e);
            return Map.of("success", false, "message", "레시피 생성 중 오류가 발생했습니다: " + e.getMessage());
        }
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

