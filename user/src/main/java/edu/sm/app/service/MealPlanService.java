package edu.sm.app.service;

import edu.sm.app.aiservice.AiMealService;
import edu.sm.app.aiservice.AiMealRecipeService;
import edu.sm.app.dto.MealPlan;
import edu.sm.app.dto.Recipient;
import edu.sm.app.repository.MealPlanRepository;
import edu.sm.common.frame.SmService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

import java.time.LocalDate;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * MealPlan(식단 관리) Service
 * 식단 정보에 대한 비즈니스 로직 처리
 */
@Service
@RequiredArgsConstructor
@Slf4j
public class MealPlanService implements SmService<MealPlan, Integer> {

    private final MealPlanRepository mealPlanRepository;
    private final RecipientService recipientService;
    private final AiMealService aiMealService;
    private final AiMealRecipeService aiMealRecipeService;


    /**
     * 새 식단 등록
     * @param mealPlan 식단 정보
     */
    @Override
    public void register(MealPlan mealPlan) throws Exception {
        log.info("식단 등록 - 노약자ID: {}, 날짜: {}, 구분: {}", 
            mealPlan.getRecId(), mealPlan.getMealDate(), mealPlan.getMealType());
        mealPlanRepository.insert(mealPlan);
    }

    /**
     * 식단 정보 수정
     * @param mealPlan 수정할 식단 정보
     */
    @Override
    public void modify(MealPlan mealPlan) throws Exception {
        log.info("식단 수정 - ID: {}, 메뉴: {}, 칼로리: {}", 
            mealPlan.getMealId(), mealPlan.getMealMenu(), mealPlan.getMealCalories());
        mealPlanRepository.update(mealPlan);
    }

    /**
     * 식단 삭제 (논리 삭제)
     * @param mealId 식단 ID
     */
    @Override
    public void remove(Integer mealId) throws Exception {
        log.info("식단 삭제 - ID: {}", mealId);
        mealPlanRepository.delete(mealId);
    }

    /**
     * 전체 식단 목록 조회
     * @return 모든 식단 목록
     */
    @Override
    public List<MealPlan> get() throws Exception {
        log.debug("전체 식단 목록 조회");
        return mealPlanRepository.selectAll();
    }

    /**
     * 특정 식단 조회
     * @param mealId 식단 ID
     * @return 식단 정보
     */
    @Override
    public MealPlan get(Integer mealId) throws Exception {
        log.debug("식단 조회 - ID: {}", mealId);
        return mealPlanRepository.select(mealId);
    }

    /**
     * 노약자별 식단 목록 조회
     * @param recId 노약자 ID
     * @return 해당 노약자의 식단 목록
     */
    public List<MealPlan> getByRecId(Integer recId) throws Exception {
        log.debug("노약자별 식단 조회 - recId: {}", recId);
        return mealPlanRepository.selectByRecId(recId);
    }

    /**
     * 특정 날짜의 식단 조회
     * @param mealDate 식단 날짜
     * @return 해당 날짜의 식단 목록
     */
    public List<MealPlan> getByDate(LocalDate mealDate) throws Exception {
        log.debug("날짜별 식단 조회 - date: {}", mealDate);
        return mealPlanRepository.selectByDate(mealDate);
    }

    /**
     * 노약자 ID와 날짜로 식단 조회
     * @param recId 노약자 ID
     * @param mealDate 식단 날짜
     * @return 해당 노약자의 특정 날짜 식단 목록
     */
    public List<MealPlan> getByRecIdAndDate(Integer recId, LocalDate mealDate) throws Exception {
        log.debug("노약자별 날짜 식단 조회 - recId: {}, date: {}", recId, mealDate);
        return mealPlanRepository.selectByRecIdAndDate(recId, mealDate);
    }

    /**
     * 식사 구분으로 식단 조회
     * @param mealType 식사 구분 (아침, 점심, 저녁)
     * @return 해당 식사 구분의 식단 목록
     */
    public List<MealPlan> getByMealType(String mealType) throws Exception {
        log.debug("식사 구분별 식단 조회 - type: {}", mealType);
        return mealPlanRepository.selectByMealType(mealType);
    }

    /**
     * 노약자 ID, 날짜, 식사 구분으로 특정 식단 조회
     * @param recId 노약자 ID
     * @param mealDate 식단 날짜
     * @param mealType 식사 구분
     * @return 해당하는 식단 정보
     */
    public MealPlan getByRecIdAndDateAndType(Integer recId, LocalDate mealDate, String mealType) throws Exception {
        log.debug("특정 식단 조회 - recId: {}, date: {}, type: {}", recId, mealDate, mealType);
        return mealPlanRepository.selectByRecIdAndDateAndType(recId, mealDate, mealType);
    }

    /**
     * 특정 기간의 식단 조회
     * @param recId 노약자 ID
     * @param startDate 시작 날짜
     * @param endDate 종료 날짜
     * @return 해당 기간의 식단 목록
     */
    public List<MealPlan> getByDateRange(Integer recId, LocalDate startDate, LocalDate endDate) throws Exception {
        log.debug("기간별 식단 조회 - recId: {}, start: {}, end: {}", recId, startDate, endDate);
        return mealPlanRepository.selectByDateRange(recId, startDate, endDate);
    }

    /**
     * 노약자의 총 칼로리 합계 조회 (특정 날짜)
     * @param recId 노약자 ID
     * @param mealDate 식단 날짜
     * @return 총 칼로리
     */
    public Integer getTotalCaloriesByDate(Integer recId, LocalDate mealDate) throws Exception {
        log.debug("일일 총 칼로리 조회 - recId: {}, date: {}", recId, mealDate);
        Integer totalCalories = mealPlanRepository.selectTotalCaloriesByDate(recId, mealDate);
        return totalCalories != null ? totalCalories : 0;
    }

    /**
     * AI 기반 식단 추천
     * @param recId 노약자 ID
     * @param specialNotes 식단 추천을 위한 사용자 특이사항
     * @return AI가 추천하는 식단 정보와 추천 근거
     */
    public Map<String, Object> getAiRecommendedMeal(Integer recId, String specialNotes, String mealType) throws Exception {
        log.info("AI 식단 추천 요청 - recId: {}, 특이사항: {}, 식사종류: {}", recId, specialNotes, mealType);

        // 1. recId로 노약자 정보 조회
        Recipient recipient = recipientService.getRecipientById(recId);
        if (recipient == null) {
            throw new Exception("ID " + recId + "에 해당하는 노약자 정보가 없습니다.");
        }

        // 2. AI에게 보낼 프롬프트 및 사용자에게 보여줄 추천 근거 생성
        StringBuilder prompt = new StringBuilder();
        prompt.append(String.format("다음 정보를 가진 사람을 위한 건강한 %s 식단을 추천해줘. 반드시 한글로 답변해줘.\n", mealType));
        prompt.append("응답 형식은 'mealName', 'calories', 'protein', 'carbohydrates', 'fats', 'description' 키를 가진 JSON 객체 형식이어야 해.\n");
        prompt.append("각 영양소의 단위는 그램(g)으로, 칼로리는 kcal로 표시해줘.\n");
        prompt.append(String.format("특히, 이 식단은 '%s' 식사임을 명심하고 그에 맞는 메뉴를 추천해줘.\n\n", mealType));

        StringBuilder basis = new StringBuilder();
        basis.append(String.format("'%s'님을 위한 %s 식단으로, 다음 정보를 바탕으로 추천합니다: ", recipient.getRecName(), mealType));

        basis.append("대상자 유형(").append(recipient.getRecTypeCode()).append(")");
        prompt.append("- 대상자 유형: ").append(recipient.getRecTypeCode()).append("\n");

        if (StringUtils.hasText(recipient.getRecMedHistory())) {
            basis.append(", 병력(").append(recipient.getRecMedHistory()).append(")");
            prompt.append("- 병력: ").append(recipient.getRecMedHistory()).append("\n");
        }
        if (StringUtils.hasText(recipient.getRecAllergies())) {
            basis.append(", 알레르기(").append(recipient.getRecAllergies()).append(")");
            prompt.append("- 알레르기: ").append(recipient.getRecAllergies()).append("\n");
        }
        if (StringUtils.hasText(recipient.getRecHealthNeeds())) {
            basis.append(", 건강 요구사항(").append(recipient.getRecHealthNeeds()).append(")");
            prompt.append("- 건강 요구사항: ").append(recipient.getRecHealthNeeds()).append("\n");
        }
        if (StringUtils.hasText(recipient.getRecSpecNotes())) {
            basis.append(", 기타 특이사항(").append(recipient.getRecSpecNotes()).append(")");
            prompt.append("- 기타 특이사항: ").append(recipient.getRecSpecNotes()).append("\n");
        }
        if (StringUtils.hasText(specialNotes)) {
            basis.append(", 추가 요청(").append(specialNotes).append(")");
            prompt.append("- 추가 요청사항: ").append(specialNotes).append("\n");
        }

        String finalPrompt = prompt.toString();
        log.debug("AI 프롬프트: {}", finalPrompt);

        // 3. AiMealService를 통해 추천 받기
        Map<String, String> recommendation = aiMealService.getMealRecommendation(finalPrompt);

        // 4. 레시피 생성 (메뉴 이름을 기반으로)
        Map<String, Object> recipeResult = null;
        String recipeText = null;
        if (recommendation.containsKey("mealName") && !recommendation.containsKey("error")) {
            try {
                recipeResult = aiMealRecipeService.getRecipeFromText(recommendation.get("mealName"));
                if (recipeResult != null && (Boolean) recipeResult.getOrDefault("success", false)) {
                    @SuppressWarnings("unchecked")
                    Map<String, Object> recipe = (Map<String, Object>) recipeResult.get("recipe");
                    if (recipe != null) {
                        // 레시피를 텍스트 형식으로 변환
                        StringBuilder recipeBuilder = new StringBuilder();
                        if (recipe.containsKey("foodName")) {
                            recipeBuilder.append("음식명: ").append(recipe.get("foodName")).append("\n\n");
                        }
                        if (recipe.containsKey("ingredients")) {
                            @SuppressWarnings("unchecked")
                            List<String> ingredients = (List<String>) recipe.get("ingredients");
                            if (ingredients != null && !ingredients.isEmpty()) {
                                recipeBuilder.append("재료:\n");
                                for (String ingredient : ingredients) {
                                    recipeBuilder.append("- ").append(ingredient).append("\n");
                                }
                                recipeBuilder.append("\n");
                            }
                        }
                        if (recipe.containsKey("steps")) {
                            @SuppressWarnings("unchecked")
                            List<Map<String, Object>> steps = (List<Map<String, Object>>) recipe.get("steps");
                            if (steps != null && !steps.isEmpty()) {
                                recipeBuilder.append("조리 방법:\n");
                                for (Map<String, Object> step : steps) {
                                    int stepNum = step.containsKey("stepNumber") ? 
                                        ((Number) step.get("stepNumber")).intValue() : 0;
                                    String desc = step.containsKey("description") ? 
                                        step.get("description").toString() : "";
                                    recipeBuilder.append(stepNum).append(". ").append(desc).append("\n");
                                }
                            }
                        }
                        recipeText = recipeBuilder.toString();
                    }
                }
            } catch (Exception e) {
                log.warn("레시피 생성 실패 (식단 추천에는 영향 없음): {}", e.getMessage());
            }
        }

        // 5. 결과와 근거, 레시피를 함께 반환
        Map<String, Object> result = new HashMap<>();
        result.put("recommendation", recommendation);
        result.put("basis", basis.toString());
        if (recipeText != null) {
            result.put("recipe", recipeText);
            if (recipeResult != null) {
                result.put("recipeDetail", recipeResult);
            }
        }
        return result;
    }
}

