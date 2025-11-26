package edu.sm.app.dto;

import lombok.*;

import java.time.LocalDate;
import java.time.LocalDateTime;

/**
 * MealPlan DTO
 * 식단 관리 정보를 담는 데이터 전송 객체
 */
@AllArgsConstructor
@NoArgsConstructor
@ToString
@Getter
@Setter
@Builder
public class MealPlan {
    /**
     * 식단 ID (Primary Key)
     */
    private Integer mealId;
    
    /**
     * 노약자 ID (Foreign Key)
     */
    private Integer recId;
    
    /**
     * 식단 날짜
     */
    private LocalDate mealDate;
    
    /**
     * 식사 구분 (아침, 점심, 저녁)
     */
    private String mealType;
    
    /**
     * 식사 메뉴
     */
    private String mealMenu;
    
    /**
     * 칼로리 정보
     */
    private Integer mealCalories;
    
    /**
     * 식단 레시피
     */
    private String mealRecipe;
    
    /**
     * 삭제 여부 ('N' 또는 'Y')
     */
    private String isDeleted;
    
    /**
     * 등록 일자
     */
    private LocalDateTime mealRegdate;
    
    /**
     * 수정 일자
     */
    private LocalDateTime mealUpdate;
}

