package edu.sm.app.repository;

import edu.sm.app.dto.MealPlan;
import edu.sm.common.frame.SmRepository;
import org.apache.ibatis.annotations.Mapper;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.util.List;
import java.util.Map;

/**
 * MealPlan(식단 관리) Repository
 * 식단 정보에 대한 데이터베이스 접근 인터페이스
 */
@Repository
@Mapper
public interface MealPlanRepository extends SmRepository<MealPlan, Integer> {
    
    /**
     * 돌봄대상자 ID로 식단 목록 조회
     * @param recId 돌봄대상자 ID
     * @return 해당 돌봄대상자의 식단 목록
     */
    List<MealPlan> selectByRecId(Integer recId) throws Exception;
    
    /**
     * 특정 날짜의 식단 조회
     * @param mealDate 식단 날짜
     * @return 해당 날짜의 식단 목록
     */
    List<MealPlan> selectByDate(LocalDate mealDate) throws Exception;
    
    /**
     * 돌봄대상자 ID와 날짜로 식단 조회
     * @param recId 돌봄대상자 ID
     * @param mealDate 식단 날짜
     * @return 해당 돌봄대상자의 특정 날짜 식단 목록
     */
    List<MealPlan> selectByRecIdAndDate(Integer recId, LocalDate mealDate) throws Exception;
    
    /**
     * 식사 구분으로 식단 조회 (아침, 점심, 저녁)
     * @param mealType 식사 구분
     * @return 해당 식사 구분의 식단 목록
     */
    List<MealPlan> selectByMealType(String mealType) throws Exception;
    
    /**
     * 돌봄대상자 ID, 날짜, 식사 구분으로 특정 식단 조회
     * @param recId 돌봄대상자 ID
     * @param mealDate 식단 날짜
     * @param mealType 식사 구분
     * @return 해당하는 식단 정보
     */
    MealPlan selectByRecIdAndDateAndType(Integer recId, LocalDate mealDate, String mealType) throws Exception;
    
    /**
     * 특정 기간의 식단 조회
     * @param recId 돌봄대상자 ID
     * @param startDate 시작 날짜
     * @param endDate 종료 날짜
     * @return 해당 기간의 식단 목록
     */
    List<MealPlan> selectByDateRange(Integer recId, LocalDate startDate, LocalDate endDate) throws Exception;
    
    /**
     * 돌봄대상자의 총 칼로리 합계 조회 (특정 날짜)
     * @param recId 돌봄대상자 ID
     * @param mealDate 식단 날짜
     * @return 총 칼로리
     */
    Integer selectTotalCaloriesByDate(Integer recId, LocalDate mealDate) throws Exception;
    
    /**
     * 돌봄대상자의 총 칼로리 합계 조회 (특정 기간)
     * @param recId 돌봄대상자 ID
     * @param startDate 시작 날짜
     * @param endDate 종료 날짜
     * @return 총 칼로리
     */
    Integer selectTotalCaloriesByDateRange(Integer recId, LocalDate startDate, LocalDate endDate) throws Exception;
    
    /**
     * 돌봄대상자의 일별 칼로리 데이터 조회 (차트용)
     * @param recId 돌봄대상자 ID
     * @param startDate 시작 날짜
     * @param endDate 종료 날짜
     * @return 날짜별 칼로리 맵 (날짜, 칼로리)
     */
    List<Map<String, Object>> selectDailyCaloriesForChart(Integer recId, LocalDate startDate, LocalDate endDate) throws Exception;
}

