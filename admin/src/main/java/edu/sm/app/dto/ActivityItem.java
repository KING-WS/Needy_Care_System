package edu.sm.app.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ActivityItem {
    private String message;
    private LocalDateTime timestamp;
    private String iconClass;
    private String bgClass;
    private String link;
}
