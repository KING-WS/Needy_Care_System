package edu.sm.app.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.time.LocalDate;
import java.time.LocalDateTime;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class Schedule {
    private Integer schedId;
    private Integer recId;
    private LocalDate schedDate;
    private String schedName;
    private String schedStartTime;
    private String schedEndTime;
    private String isDeleted;
    private LocalDateTime schedRegdate;
    private LocalDateTime schedUpdate;
}