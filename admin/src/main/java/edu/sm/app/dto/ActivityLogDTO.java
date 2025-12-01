package edu.sm.app.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.util.Date;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class ActivityLogDTO {
    private String type;
    private String message;
    private Date timestamp;
    private String iconClass;
    private String bgClass;
}
