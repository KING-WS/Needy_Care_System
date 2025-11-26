package edu.sm.app.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;
import org.springframework.format.annotation.DateTimeFormat;

import java.util.Date;

@Getter
@Setter
@ToString
@AllArgsConstructor
@NoArgsConstructor
public class Senior {
    private int recId;
    private String recTypeCode;
    private int custId;
    private String recName;
    
    @DateTimeFormat(pattern = "yyyy-MM-dd")
    private Date recBirthday;
    
    private int age;
    private String recGender;
    private String recKioskCode;
    private String recAddress;
    private String recPhotoUrl;
    private String recMedHistory;
    private String recAllergies;
    private String recSpecNotes;
    private String isDeleted;
    private Date recRegdate;
    private Date recUpdate;
    private String recHealthNeeds;
    private String caregiverName;
}