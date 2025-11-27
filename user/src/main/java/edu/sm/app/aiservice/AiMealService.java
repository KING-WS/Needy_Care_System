package edu.sm.app.aiservice;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.ai.chat.client.ChatClient;
import org.springframework.stereotype.Service;

import java.util.Map;

@Service
@Slf4j
@RequiredArgsConstructor
public class AiMealService {

    private final ChatClient chatClient;
    private final ObjectMapper objectMapper;

    public Map<String, String> getMealRecommendation(String preferences) {
        log.info("AI Meal Service - getMealRecommendation called with preferences: {}", preferences);

        String prompt = """
            You are an expert nutritionist and chef specializing in Korean cuisine.
            Based on the following user preferences, create a single, healthy, and delicious Korean meal recommendation.
            User preferences: "%s"

            Your response MUST be a JSON object and nothing else.
            The JSON object must contain these fields, with Korean values:
            1. "mealName": The name of the meal.
            2. "calories": Estimated calories (e.g., "550kcal").
            3. "protein": Grams of protein (e.g., "35g").
            4. "carbohydrates": Grams of carbohydrates (e.g., "60g").
            5. "fats": Grams of fats (e.g., "18g").
            6. "description": A brief, appealing description of the meal and why it fits the user's preferences.

            Example response:
            {
              "mealName": "버섯 불고기 덮밥",
              "calories": "600kcal",
              "protein": "40g",
              "carbohydrates": "70g",
              "fats": "20g",
              "description": "신선한 버섯과 부드러운 불고기를 현미밥 위에 올린 영양 만점 한 끼 식사입니다. 사용자의 '고단백' 선호도에 맞춰 쇠고기 양을 늘렸습니다."
            }
            """.formatted(preferences);

        String aiResponse = chatClient.prompt()
                .user(prompt)
                .call()
                .content();

        log.info("Raw AI Response: {}", aiResponse);

        // AI 응답에서 JSON 부분만 추출하는 전처리 로직 추가
        String cleanedJson = extractJson(aiResponse);
        
        log.info("Cleaned JSON for parsing: {}", cleanedJson);

        try {
            Map<String, String> recommendation = objectMapper.readValue(cleanedJson, Map.class);
            log.info("Successfully parsed AI recommendation: {}", recommendation);
            return recommendation;
        } catch (JsonProcessingException e) {
            log.error("Failed to parse AI response JSON", e);
            return Map.of("error", "AI 응답을 파싱하는 데 실패했습니다.");
        }
    }

    /**
     * AI에게 프롬프트를 보내고, 응답에서 순수한 JSON 문자열만 추출하여 반환합니다.
     * @param prompt AI에게 보낼 전체 프롬프트 문자열
     * @return AI가 생성한 JSON 형식의 문자열
     */
    public String getSingleJsonResponse(String prompt) {
        log.info("AI Service - getSingleJsonResponse 호출됨");

        String aiResponse = chatClient.prompt()
                .user(prompt)
                .call()
                .content();

        log.info("Raw AI Response: {}", aiResponse);

        String cleanedJson = extractJson(aiResponse);
        
        if (cleanedJson == null) {
            log.error("AI 응답에서 유효한 JSON 객체를 찾을 수 없습니다.");
            // 오류 상황을 나타내는 JSON 문자열을 대신 반환할 수 있습니다.
            return "{\"error\": \"AI가 유효한 응답을 생성하지 못했습니다.\"}";
        }
        
        log.info("Cleaned JSON for parsing: {}", cleanedJson);
        return cleanedJson;
    }

    /**
     * 응답 문자열에서 JSON 부분만 추출합니다.
     * @param response AI의 전체 응답 문자열
     * @return 추출된 JSON 문자열 또는 null
     */
    private String extractJson(String response) {
        if (response == null) {
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
