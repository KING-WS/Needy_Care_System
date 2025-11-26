package edu.sm.app.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * 챗봇 의도 분석 결과를 담는 DTO
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
public class ChatIntent {
    /**
     * 의도 타입
     * HEALTH_QUERY: 건강 상태 조회
     * HEALTH_ANALYSIS: 건강 데이터 분석
     * MEAL_RECOMMEND: 식단 추천
     * MEAL_QUERY: 식단 조회
     * SCHEDULE_CREATE: 일정 등록
     * SCHEDULE_QUERY: 일정 조회
     * WALKING_ROUTE: 산책 경로 추천
     * GENERAL_CHAT: 일반 대화
     */
    private String intent;
    
    /**
     * 의도에 따른 추가 파라미터 (JSON 형태)
     * 예: {"date": "2024-01-15", "mealType": "아침"}
     */
    private String parameters;
    
    /**
     * 의도 확신도 (0.0 ~ 1.0)
     */
    private Double confidence;
}

