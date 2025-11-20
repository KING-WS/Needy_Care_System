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
        String cleanedJson = aiResponse;
        int firstBrace = cleanedJson.indexOf('{');
        int lastBrace = cleanedJson.lastIndexOf('}');

        if (firstBrace != -1 && lastBrace != -1 && lastBrace > firstBrace) {
            cleanedJson = cleanedJson.substring(firstBrace, lastBrace + 1);
        } else {
            log.error("Could not find a valid JSON object in the AI response.");
            return Map.of("error", "AI가 유효한 응답을 생성하지 못했습니다.");
        }
        
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
}
