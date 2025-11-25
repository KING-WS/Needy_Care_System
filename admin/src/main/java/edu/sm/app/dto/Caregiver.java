package edu.sm.app.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

import java.util.Date;

@Getter
@Setter
@ToString
@AllArgsConstructor
@NoArgsConstructor
public class Caregiver {
    private int caregiverId;
    private String caregiverName;
    private String caregiverPhone;
    private String caregiverAddress;
    private String isDeleted;
    private Date caregiverRegdate;
    private Date caregiverUpdate;
    private String caregiverCareer;
    private String caregiverCertifications;
    private String caregiverSpecialties;
}
