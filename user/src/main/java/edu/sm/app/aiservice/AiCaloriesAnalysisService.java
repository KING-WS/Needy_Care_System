package edu.sm.app.aiservice;

import com.fasterxml.jackson.databind.ObjectMapper;
import edu.sm.app.aiservice.util.AiUtilService;
import edu.sm.app.dto.Recipient;
import lombok.extern.slf4j.Slf4j;
import org.springframework.ai.chat.client.ChatClient;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.time.Period;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 칼로리 분석 AI 서비스
 * 노약자의 칼로리 섭취 데이터를 분석하여 상태 평가 및 조절 방안을 제시합니다.
 */
@Service
@Slf4j
public class AiCaloriesAnalysisService {
    
    private final ChatClient chatClient;
    private final ObjectMapper objectMapper;
    private final AiUtilService aiUtilService;
    
    private static final String CALORIES_ANALYSIS_PROMPT = """
            당신은 전문 영양사입니다. 노약자의 칼로리 섭취 데이터를 분석하여 건강 상태를 평가하고 조절 방안을 제시해주세요.
            
            [분석 대상자 정보]
            - 이름: %s
            - 나이: %d세
            - 성별: %s
            - 병력: %s
            - 알레르기: %s
            - 건강 요구사항: %s
            - 기타 특이사항: %s
            
            [최근 칼로리 섭취 데이터]
            %s
            
            [평균 칼로리 섭취량]
            - 오늘: %d kcal
            - 최근 7일 평균: %d kcal
            - 최근 30일 평균: %d kcal
            
            위 정보를 바탕으로 다음 항목을 포함한 종합 분석을 제공해주세요:
            
            응답은 반드시 다음 JSON 형식으로만 제공해주세요:
            {
              "status": "부족|적정|과다",
              "aiAnalysis": "현재 칼로리 섭취 상태(부족, 적정, 과다)를 첫 문장에 명시하고, 그에 대한 상세 분석과 최종 요약 가이드를 포함하여 하나의 완성된 문단으로 작성해주세요.",
              "recommendedCalories": 권장칼로리숫자,
              "adjustmentPlan": "조절 방안",
              "dietSuggestion": "구체적인 식단 조절 제안"
            }
            
            중요:
            - aiAnalysis는 사용자가 가장 먼저 보게 될 핵심 요약 정보입니다. 긍정적이고 이해하기 쉬운 어조로 작성해주세요.
            - 노약자의 경우 일반 성인보다 칼로리 요구량이 낮을 수 있으므로 이를 고려해주세요.
            - 병력이나 건강 요구사항이 있으면 이를 반영해주세요.
            - 모든 텍스트는 한글로 작성해주세요.
            """;
    
    public AiCaloriesAnalysisService(
            ChatClient.Builder chatClientBuilder,
            ObjectMapper objectMapper,
            AiUtilService aiUtilService) {
        this.chatClient = chatClientBuilder.build();
        this.objectMapper = objectMapper;
        this.aiUtilService = aiUtilService;
    }
    
    /**
     * 칼로리 분석 수행
     * @param recipient 노약자 정보
     * @param todayCalories 오늘 칼로리
     * @param weekAvgCalories 최근 7일 평균 칼로리
     * @param monthAvgCalories 최근 30일 평균 칼로리
     * @param recentCaloriesData 최근 일별 칼로리 데이터 (날짜별 칼로리 맵 리스트)
     * @return 분석 결과
     */
    public Map<String, Object> analyzeCalories(
            Recipient recipient,
            Integer todayCalories,
            Integer weekAvgCalories,
            Integer monthAvgCalories,
            List<Map<String, Object>> recentCaloriesData) {
        
        try {
            // 나이 계산
            int age = 0;
            if (recipient.getRecBirthday() != null) {
                age = Period.between(recipient.getRecBirthday(), LocalDate.now()).getYears();
            }
            
            // 성별 텍스트 변환
            String genderText = "남성";
            if (recipient.getRecGender() != null && recipient.getRecGender().equals("F")) {
                genderText = "여성";
            }
            
            // 최근 칼로리 데이터 포맷팅
            StringBuilder recentDataText = new StringBuilder();
            if (recentCaloriesData != null && !recentCaloriesData.isEmpty()) {
                int count = 0;
                for (Map<String, Object> data : recentCaloriesData) {
                    if (count >= 7) break; // 최근 7일만 표시
                    if (data == null) continue;
                    
                    try {
                        Object mealDateObj = data.get("mealDate");
                        Object caloriesObj = data.get("totalCalories");
                        
                        if (mealDateObj == null || caloriesObj == null) {
                            continue;
                        }
                        
                        String dateStr = mealDateObj.toString();
                        Integer calories = 0;
                        if (caloriesObj instanceof Number) {
                            calories = ((Number) caloriesObj).intValue();
                        } else {
                            try {
                                calories = Integer.parseInt(caloriesObj.toString());
                            } catch (NumberFormatException e) {
                                log.warn("칼로리 파싱 실패: {}", caloriesObj);
                                continue;
                            }
                        }
                        
                        recentDataText.append(String.format("- %s: %d kcal\n", dateStr, calories));
                        count++;
                    } catch (Exception e) {
                        log.warn("칼로리 데이터 포맷팅 실패", e);
                        continue;
                    }
                }
            }
            
            if (recentDataText.length() == 0) {
                recentDataText.append("데이터 없음\n");
            }
            
            // 프롬프트 생성
            String prompt = String.format(
                CALORIES_ANALYSIS_PROMPT,
                recipient.getRecName() != null ? recipient.getRecName() : "대상자",
                age,
                genderText,
                recipient.getRecMedHistory() != null ? recipient.getRecMedHistory() : "없음",
                recipient.getRecAllergies() != null ? recipient.getRecAllergies() : "없음",
                recipient.getRecHealthNeeds() != null ? recipient.getRecHealthNeeds() : "없음",
                recipient.getRecSpecNotes() != null ? recipient.getRecSpecNotes() : "없음",
                recentDataText.toString(),
                todayCalories != null ? todayCalories : 0,
                weekAvgCalories != null ? weekAvgCalories : 0,
                monthAvgCalories != null ? monthAvgCalories : 0
            );
            
            log.info("칼로리 분석 프롬프트 생성 완료 - recId: {}", recipient.getRecId());
            
            // AI 호출
            String aiResponse = chatClient.prompt()
                    .user(prompt)
                    .call()
                    .content();
            
            log.debug("AI 원본 응답: {}", aiResponse);
            
            // JSON 추출
            String json = aiUtilService.extractJson(aiResponse);
            log.debug("추출된 JSON: {}", json);
            
            // JSON 파싱
            Map<String, Object> analysisResult = aiUtilService.parseJsonToMap(json);
            
            // 결과 구성
            Map<String, Object> result = new HashMap<>();
            result.put("success", true);
            result.put("status", analysisResult.getOrDefault("status", "적정").toString());
            result.put("aiAnalysis", analysisResult.getOrDefault("aiAnalysis", "AI 분석 결과를 생성할 수 없습니다.").toString());
            
            Object recommendedCaloriesObj = analysisResult.getOrDefault("recommendedCalories", 2000);
            int recommendedCalories = 2000;
            if (recommendedCaloriesObj instanceof Number) {
                recommendedCalories = ((Number) recommendedCaloriesObj).intValue();
            } else if (recommendedCaloriesObj != null) {
                try {
                    recommendedCalories = Integer.parseInt(recommendedCaloriesObj.toString());
                } catch (NumberFormatException e) {
                    log.warn("권장 칼로리 파싱 실패: {}", recommendedCaloriesObj);
                }
            }
            result.put("recommendedCalories", recommendedCalories);
            
            result.put("adjustmentPlan", analysisResult.getOrDefault("adjustmentPlan", "조절 방안을 생성할 수 없습니다.").toString());
            result.put("dietSuggestion", analysisResult.getOrDefault("dietSuggestion", "식단 조절 제안을 생성할 수 없습니다.").toString());
            
            log.info("칼로리 분석 완료 - recId: {}, 상태: {}", recipient.getRecId(), result.get("status"));
            
            return result;
            
        } catch (Exception e) {
            log.error("칼로리 분석 실패 - recId: {}", recipient.getRecId(), e);
            Map<String, Object> errorResult = new HashMap<>();
            errorResult.put("success", false);
            errorResult.put("message", "칼로리 분석 중 오류가 발생했습니다: " + e.getMessage());
            return errorResult;
        }
    }
}
