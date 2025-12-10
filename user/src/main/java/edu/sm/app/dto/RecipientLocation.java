package edu.sm.app.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.time.LocalDateTime;

/**
 * 돌봄대상자 실시간 위치 정보 DTO
 */
@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class RecipientLocation {
    private Integer recId;           // 돌봄대상자 ID
    private Double latitude;         // 위도
    private Double longitude;        // 경도
    private LocalDateTime updateTime; // 위치 업데이트 시간
    private String status;           // 상태 (ACTIVE, INACTIVE 등)
}

