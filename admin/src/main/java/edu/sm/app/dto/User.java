package edu.sm.app.dto;

import lombok.*;

import java.sql.Timestamp;
import java.util.Date;

@AllArgsConstructor
@NoArgsConstructor
@ToString
@Getter
@Setter
@Builder
public class User {
    private int custId;
    private String custEmail;
    private String custPwd;
    private String custName;
    private String custPhone;
    private String isDeleted;
    private Date custRegdate;
    private Date custUpdate;
}