package edu.sm.app.dto;

import lombok.*;

import java.time.LocalDateTime;

@AllArgsConstructor
@NoArgsConstructor
@ToString
@Getter
@Setter
@Builder
public class MapCourse {
    private Integer courseId;
    private Integer recId;
    private String courseName;
    private String courseType;
    private String coursePathData;
    private String isDeleted;
    private LocalDateTime courseRegdate;
    private LocalDateTime courseUpdate;
}

