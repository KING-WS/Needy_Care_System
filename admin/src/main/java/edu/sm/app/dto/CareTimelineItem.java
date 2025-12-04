package edu.sm.app.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

/**
 * 실시간 케어 활동 타임라인에 표시될 단일 항목을 나타내는 DTO
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class CareTimelineItem {

    /**
     * 이벤트 타입 (예: "ALERT", "CARE_START", "MEAL_PLAN")
     */
    private String type;

    /**
     * 타임라인에 표시될 메시지
     */
    private String message;

    /**
     * 이벤트 발생 시간
     */
    @com.fasterxml.jackson.annotation.JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private LocalDateTime timestamp;

    /**
     * 메시지와 함께 표시될 Bootstrap 아이콘 클래스 (예: "bi-person-check")
     */
    private String iconClass;

    /**
     * 아이콘 배경색 클래스 (예: "bg-danger", "bg-success")
     */
    private String bgClass;

    /**
     * 클릭 시 이동할 상세 페이지 링크
     */
    private String link;
}
