package edu.sm.app.aiservice;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import edu.sm.app.dto.MealPlan;
import edu.sm.app.dto.Recipient;
import edu.sm.app.service.MealPlanService;
import edu.sm.app.service.RecipientService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.ai.chat.client.ChatClient;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * AI 식단 칼로리 분석 서비스
 * 사용자의 식단 칼로리를 분석하고 건강 상태에 맞는 조언 제공
 */
@Service
@Slf4j
@RequiredArgsConstructor
public class AiCalorieAnalysisService {

    private final ChatClient chatClient;
    private final MealPlanService mealPlanService;
    private final RecipientService recipientService;
    private final ObjectMapper objectMapper;

    /**
     * 칼로리 분석 및 건강 상태 분석
     * @param recId 노약자 ID
     * @param startDate 시작 날짜
     * @param endDate 종료 날짜
     * @return 분석 결과
     */
    public Map<String, Object> analyzeCalories(Integer recId, LocalDate startDate, LocalDate endDate) {
        log.info("AI 식단 칼로리 분석 시작 - recId: {}, 기간: {} ~ {}", recId, startDate, endDate);

        try {
            // 노약자 정보 조회
            Recipient recipient = recipientService.getRecipientById(recId);
            if (recipient == null) {
                return Map.of("success", false, "message", "노약자 정보를 찾을 수 없습니다.");
            }

            // 기간별 식단 조회
            List<MealPlan> meals = mealPlanService.getByDateRange(recId, startDate, endDate);
            
            if (meals == null || meals.isEmpty()) {
                return Map.of("success", false, "message", "해당 기간의 식단 데이터가 없습니다.");
            }

            // 칼로리 데이터 정리
            Map<String, Object> calorieData = organizeCalorieData(meals, startDate, endDate);

            // AI 분석 프롬프트 생성
            StringBuilder prompt = new StringBuilder();
            prompt.append("당신은 노약자 영양 전문가입니다. 다음 정보를 바탕으로 식단 칼로리를 분석하고 건강 상태를 평가해주세요.\n\n");
            
            prompt.append("[노약자 정보]\n");
            prompt.append("이름: ").append(recipient.getRecName()).append("\n");
            if (StringUtils.hasText(recipient.getRecMedHistory())) {
                prompt.append("병력: ").append(recipient.getRecMedHistory()).append("\n");
            }
            if (StringUtils.hasText(recipient.getRecHealthNeeds())) {
                prompt.append("건강 요구사항: ").append(recipient.getRecHealthNeeds()).append("\n");
            }
            if (StringUtils.hasText(recipient.getRecAllergies())) {
                prompt.append("알레르기: ").append(recipient.getRecAllergies()).append("\n");
            }
            if (StringUtils.hasText(recipient.getRecSpecNotes())) {
                prompt.append("추가 정보: ").append(recipient.getRecSpecNotes()).append("\n");
            }
            
            prompt.append("\n[식단 데이터]\n");
            prompt.append("분석 기간: ").append(startDate.format(DateTimeFormatter.ofPattern("yyyy-MM-dd")))
                  .append(" ~ ").append(endDate.format(DateTimeFormatter.ofPattern("yyyy-MM-dd"))).append("\n");
            prompt.append("총 식단 수: ").append(meals.size()).append("개\n");
            prompt.append("일평균 칼로리: ").append(calorieData.get("dailyAverage")).append("kcal\n");
            prompt.append("최고 칼로리: ").append(calorieData.get("maxCalories")).append("kcal\n");
            prompt.append("최저 칼로리: ").append(calorieData.get("minCalories")).append("kcal\n");
            
            prompt.append("\n[일별 칼로리 데이터]\n");
            @SuppressWarnings("unchecked")
            List<Map<String, Object>> dailyData = (List<Map<String, Object>>) calorieData.get("dailyData");
            for (Map<String, Object> day : dailyData) {
                prompt.append(day.get("date")).append(": ").append(day.get("calories")).append("kcal\n");
            }
            
            prompt.append("""
                
                [분석 요청]
                1. 현재 식단의 칼로리 수준이 노약자의 건강 상태에 적합한지 평가
                2. 칼로리 섭취 패턴 분석 (과다/부족 여부)
                3. 건강 상태에 맞는 식단 방향성 제시
                4. 주의해야 할 음식 및 권장 음식 제시
                5. 개선 사항 및 권장사항 제시
                
                [응답 형식]
                반드시 다음 JSON 형식으로만 응답해주세요:
                {
                  "analysis": {
                    "overallStatus": "GOOD" | "WARNING" | "POOR",
                    "calorieStatus": "적정" | "과다" | "부족",
                    "averageCalories": 일평균 칼로리 수치,
                    "recommendedCalories": 권장 칼로리 수치,
                    "statusMessage": "전체 상태 메시지"
                  },
                  "dietDirection": {
                    "direction": "식단 방향성 설명",
                    "focusAreas": ["중점 영역1", "중점 영역2", ...]
                  },
                  "healthStatus": {
                    "currentStatus": "현재 건강 상태 평가",
                    "concerns": ["우려사항1", "우려사항2", ...],
                    "improvements": ["개선사항1", "개선사항2", ...]
                  },
                  "foodRecommendations": {
                    "avoid": ["피해야 할 음식1", "피해야 할 음식2", ...],
                    "recommend": ["권장 음식1", "권장 음식2", ...],
                    "caution": ["주의 음식1", "주의 음식2", ...]
                  },
                  "recommendations": [
                    "권장사항1",
                    "권장사항2",
                    ...
                  ]
                }
                """);

            String aiResponse = chatClient.prompt()
                    .user(prompt.toString())
                    .call()
                    .content();

            log.info("AI 응답: {}", aiResponse);

            // JSON 추출 및 파싱
            String json = extractJson(aiResponse);
            if (json == null || json.trim().isEmpty()) {
                return Map.of("success", false, "message", "AI 응답을 파싱할 수 없습니다.");
            }

            @SuppressWarnings({"unchecked", "null"})
            Map<String, Object> analysisResult = objectMapper.readValue(json, Map.class);
            
            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("calorieData", calorieData);
            response.put("analysis", analysisResult);
            
            return response;

        } catch (JsonProcessingException e) {
            log.error("JSON 파싱 실패", e);
            return Map.of("success", false, "message", "응답 파싱 중 오류가 발생했습니다.");
        } catch (Exception e) {
            log.error("AI 식단 칼로리 분석 실패", e);
            return Map.of("success", false, "message", "칼로리 분석 중 오류가 발생했습니다: " + e.getMessage());
        }
    }

    /**
     * 칼로리 데이터 정리
     */
    private Map<String, Object> organizeCalorieData(List<MealPlan> meals, LocalDate startDate, LocalDate endDate) {
        Map<String, Integer> dailyCalories = new HashMap<>();
        int totalCalories = 0;

        for (MealPlan meal : meals) {
            if (meal.getMealCalories() != null && meal.getMealCalories() > 0) {
                String dateKey = meal.getMealDate().toString();
                dailyCalories.put(dateKey, dailyCalories.getOrDefault(dateKey, 0) + meal.getMealCalories());
                totalCalories += meal.getMealCalories();
            }
        }

        // 일별 데이터 리스트 생성
        List<Map<String, Object>> dailyData = new ArrayList<>();
        LocalDate currentDate = startDate;
        while (!currentDate.isAfter(endDate)) {
            String dateKey = currentDate.toString();
            int calories = dailyCalories.getOrDefault(dateKey, 0);
            
            Map<String, Object> dayData = new HashMap<>();
            dayData.put("date", currentDate.format(DateTimeFormatter.ofPattern("yyyy-MM-dd")));
            dayData.put("calories", calories);
            dailyData.add(dayData);
            
            currentDate = currentDate.plusDays(1);
        }

        // 통계 계산
        int dayCount = (int) startDate.datesUntil(endDate.plusDays(1)).count();
        int dailyAverage = dayCount > 0 ? totalCalories / dayCount : 0;
        
        int maxCalories = dailyCalories.values().stream().mapToInt(Integer::intValue).max().orElse(0);
        int minCalories = dailyCalories.values().stream().mapToInt(Integer::intValue).min().orElse(0);

        Map<String, Object> result = new HashMap<>();
        result.put("totalCalories", totalCalories);
        result.put("dailyAverage", dailyAverage);
        result.put("maxCalories", maxCalories);
        result.put("minCalories", minCalories);
        result.put("dailyData", dailyData);
        result.put("dayCount", dayCount);

        return result;
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

