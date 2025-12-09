package edu.sm.app.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class AlertLog {
    private int alertId;
    private int recId;
    private String alertType;   // EMERGENCY, CONTACT
    private String alertMsg;
    private String checkStatus; // N: 미확인, Y: 확인됨
    private LocalDateTime alertRegdate;
    private String recipientName; // 수신자 이름 (조회용)
    private String kioskCode;

    // [추가된 필드] 보호자 정보 (조회용)
    private String protectorName;
    private String protectorPhone;
}