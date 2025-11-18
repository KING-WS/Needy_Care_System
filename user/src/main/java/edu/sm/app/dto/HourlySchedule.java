package edu.sm.app.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.time.LocalTime;
import java.time.LocalDateTime;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class HourlySchedule {
    private Integer hourlySchedId;
    private Integer schedId;
    private LocalTime hourlySchedStartTime;
    private LocalTime hourlySchedEndTime;
    private String hourlySchedName;
    private String hourlySchedContent;
    private String isDeleted;
    private LocalDateTime hourlySchedRegdate;
    private LocalDateTime hourlySchedUpdate;
}
