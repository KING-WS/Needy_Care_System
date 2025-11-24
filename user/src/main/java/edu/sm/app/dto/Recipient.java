package edu.sm.app.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.time.LocalDate;
import java.time.LocalDateTime;

@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class Recipient {
    private Integer recId;
    private String recTypeCode;
    private Integer custId;
    private String recName;
    private LocalDate recBirthday;
    private String recGender;
    private String recKioskCode;
    private String recAddress;
    private String recPhotoUrl;
    private String recMedHistory;
    private String recAllergies;
    private String recSpecNotes;
    private String isDeleted;
    private LocalDateTime recRegdate;
    private LocalDateTime recUpdate;
    private String recHealthNeeds;
    private LocalDateTime lastConnectedAt; // 마지막 접속 시간
    private Double recLatitude; // 현재 위도
    private Double recLongitude; // 현재 경도
}