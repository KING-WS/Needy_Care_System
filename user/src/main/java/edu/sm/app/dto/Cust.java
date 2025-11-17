package edu.sm.app.dto;


import lombok.*;

import java.time.LocalDateTime;

@AllArgsConstructor
@NoArgsConstructor
@ToString
@Getter
@Setter
@Builder
public class Cust {
    private Integer custId;
    private String custEmail;
    private String custPwd;
    private String custName;
    private String custPhone;
    private String isDeleted;
    private LocalDateTime custRegdate;
    private LocalDateTime custUpdate;
}

