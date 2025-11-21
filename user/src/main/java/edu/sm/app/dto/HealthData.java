package edu.sm.app.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class HealthData {
    private Integer healthId;
    private Integer recId;
    private String healthType;
    private BigDecimal healthValue1;
    private BigDecimal healthValue2;
    private LocalDateTime healthMeasuredAt;
    private String isDeleted;
    private LocalDateTime healthRegdate;
    private LocalDateTime healthUpdate;
}

