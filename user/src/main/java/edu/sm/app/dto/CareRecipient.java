package edu.sm.app.dto;

import lombok.*;

import java.time.LocalDate;
import java.time.LocalDateTime;

@AllArgsConstructor
@NoArgsConstructor
@ToString
@Getter
@Setter
@Builder
public class CareRecipient {
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
}

