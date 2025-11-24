package edu.sm.app.dto;

import lombok.Data;
import java.util.Date;

@Data
public class Senior {
    private int recId;
    private String recTypeCode;
    private int custId;
    private String recName;
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