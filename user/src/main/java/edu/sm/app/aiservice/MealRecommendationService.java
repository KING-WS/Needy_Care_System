package edu.sm.app.aiservice;

import edu.sm.app.dto.MealPlan;
import edu.sm.app.service.MealPlanService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 식단 추천 및 조회 서비스
 */
@Service
@Slf4j
public class MealRecommendationService {
    
    private final MealPlanService mealPlanService;
    
    // 최근 추천 결과를 임시 저장 (세션 대신 메모리 사용 - 실제로는 Redis나 세션 사용 권장)
    private final Map<Integer, Map<String, Object>> recentRecommendations = new HashMap<>();
    
    public MealRecommendationService(MealPlanService mealPlanService) {
        this.mealPlanService = mealPlanService;
    }
    
    /**
     * 식단 추천
     */
    public String recommendMeal(Integer recId, String userMessage) {
        try {
            // 사용자 메시지에서 식사 종류 추출 (아침, 점심, 저녁)
            String mealType = "점심"; // 기본값
            if (userMessage.contains("아침") || userMessage.contains("조식")) {
                mealType = "아침";
            } else if (userMessage.contains("저녁") || userMessage.contains("석식")) {
                mealType = "저녁";
            }
            
            // 사용자 메시지에서 추가 요청사항 추출
            String specialNotes = "";
            if (userMessage.contains("저염") || userMessage.contains("싱겁")) {
                specialNotes = "저염식";
            } else if (userMessage.contains("고단백") || userMessage.contains("단백질")) {
                specialNotes = "고단백";
            } else if (userMessage.contains("저칼로리") || userMessage.contains("다이어트")) {
                specialNotes = "저칼로리";
            }
            
            // MealPlanService의 getAiRecommendedMeal을 사용하여 모든 건강정보를 활용한 식단 추천
            Map<String, Object> result = mealPlanService.getAiRecommendedMeal(recId, specialNotes, mealType);
            
            @SuppressWarnings("unchecked")
            Map<String, String> recommendation = (Map<String, String>) result.get("recommendation");
            String basis = (String) result.get("basis");
            
            if (recommendation.containsKey("error")) {
                return recommendation.get("error");
            }
            
            // 추천 결과를 임시 저장 (사용자가 저장을 원할 때 사용)
            Map<String, Object> savedRecommendation = new HashMap<>();
            savedRecommendation.put("type", "MEAL");
            savedRecommendation.put("data", recommendation);
            savedRecommendation.put("mealType", mealType);
            savedRecommendation.put("timestamp", System.currentTimeMillis());
            recentRecommendations.put(recId, savedRecommendation);
            
            return String.format("식단을 추천해드릴게요!\n\n" +
                    "메뉴: %s\n" +
                    "칼로리: %s\n" +
                    "단백질: %s\n" +
                    "탄수화물: %s\n" +
                    "지방: %s\n" +
                    "설명: %s\n\n" +
                    "추천 근거: %s\n\n" +
                    "이 식단을 등록하시겠어요? '네' 또는 '등록해줘'라고 말씀해주세요!",
                    recommendation.get("mealName"),
                    recommendation.get("calories"),
                    recommendation.get("protein"),
                    recommendation.get("carbohydrates"),
                    recommendation.get("fats"),
                    recommendation.get("description"),
                    basis);
        } catch (Exception e) {
            log.error("식단 추천 실패", e);
            return "식단을 추천하는 중 문제가 발생했어요.";
        }
    }
    
    /**
     * 추천받은 식단을 DB에 저장
     */
    public String saveMeal(Integer recId, String userMessage) {
        try {
            Map<String, Object> savedRecommendation = recentRecommendations.get(recId);
            
            if (savedRecommendation == null || !"MEAL".equals(savedRecommendation.get("type"))) {
                return "저장할 식단 정보를 찾을 수 없어요. 먼저 식단을 추천받아주세요.";
            }
            
            @SuppressWarnings("unchecked")
            Map<String, String> mealData = (Map<String, String>) savedRecommendation.get("data");
            
            // 식사 타입 결정 (저장된 추천 결과에서 가져오거나 사용자 메시지에서 추출)
            String mealType = "점심";
            if (savedRecommendation != null && savedRecommendation.containsKey("mealType")) {
                mealType = savedRecommendation.get("mealType").toString();
            } else {
                if (userMessage.contains("아침") || userMessage.contains("조식")) {
                    mealType = "아침";
                } else if (userMessage.contains("저녁") || userMessage.contains("석식")) {
                    mealType = "저녁";
                }
            }
            
            // 칼로리 파싱
            String caloriesStr = mealData.get("calories");
            Integer calories = 0;
            if (caloriesStr != null) {
                try {
                    calories = Integer.parseInt(caloriesStr.replaceAll("[^0-9]", ""));
                } catch (NumberFormatException e) {
                    log.warn("칼로리 파싱 실패: {}", caloriesStr);
                }
            }
            
            // MealPlan 생성 및 저장
            MealPlan mealPlan = MealPlan.builder()
                    .recId(recId)
                    .mealDate(LocalDate.now())
                    .mealType(mealType)
                    .mealMenu(mealData.get("mealName"))
                    .mealCalories(calories)
                    .isDeleted("N")
                    .build();
            
            mealPlanService.register(mealPlan);
            
            // 저장된 추천 결과 제거
            recentRecommendations.remove(recId);
            
            log.info("식단 자동 저장 완료 - recId: {}, mealType: {}, menu: {}", 
                    recId, mealType, mealData.get("mealName"));
            
            return String.format("식단을 등록했어요!\n" +
                    "메뉴: %s\n" +
                    "식사: %s\n" +
                    "칼로리: %dkcal\n" +
                    "오늘 %s로 등록되었어요!",
                    mealData.get("mealName"),
                    mealType,
                    calories,
                    LocalDate.now().format(DateTimeFormatter.ofPattern("yyyy년 MM월 dd일")));
        } catch (Exception e) {
            log.error("식단 저장 실패", e);
            return "식단을 저장하는 중 문제가 발생했어요. 다시 시도해주세요.";
        }
    }
    
    /**
     * 식단 조회
     */
    public String queryMeal(Integer recId, Map<String, Object> params) {
        try {
            LocalDate date = params.containsKey("date") ? 
                    LocalDate.parse(params.get("date").toString()) : LocalDate.now();
            
            List<MealPlan> meals = mealPlanService.getByRecIdAndDate(recId, date);
            if (meals == null || meals.isEmpty()) {
                return String.format("%s 식단이 등록되지 않았어요.", 
                        date.format(DateTimeFormatter.ofPattern("yyyy년 MM월 dd일")));
            }
            
            StringBuilder sb = new StringBuilder();
            sb.append(String.format("%s 식단이에요:\n", 
                    date.format(DateTimeFormatter.ofPattern("yyyy년 MM월 dd일"))));
            
            for (MealPlan meal : meals) {
                sb.append(String.format("- %s: %s (칼로리: %dkcal)\n",
                        meal.getMealType(),
                        meal.getMealMenu(),
                        meal.getMealCalories() != null ? meal.getMealCalories() : 0));
            }
            
            return sb.toString();
        } catch (Exception e) {
            log.error("식단 조회 실패", e);
            return "식단을 조회하는 중 문제가 발생했어요.";
        }
    }
}

