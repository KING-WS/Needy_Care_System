package edu.sm.app.service;

import edu.sm.app.aiservice.AiMealService;
import edu.sm.app.dto.MealPlan;
import edu.sm.app.repository.MealPlanRepository;
import edu.sm.common.frame.SmService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
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

    private final AiMealService aiMealService;

    /**
     * AI 기반 식단 추천
     * @param preferences 식단 추천을 위한 사용자 선호도 (예: 저염식, 고단백 등)
     * @return AI가 추천하는 식단 정보
     */
    public Map<String, String> getRecommendedMeal(String preferences) {
        log.info("AI 식단 추천 요청 - 선호도: {}", preferences);
        return aiMealService.getMealRecommendation(preferences);
    }
}

