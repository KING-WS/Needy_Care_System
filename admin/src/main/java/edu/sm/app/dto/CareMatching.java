package edu.sm.app.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
@AllArgsConstructor
@NoArgsConstructor
public class CareMatching {
    private int matchingId;
    private int caregiverId;
    private int recId;
    private String isDeleted;

    // 화면 표시용으로, 요양사 및 수급자 이름을 담는 필드
    private String caregiverName;
    private String recName;
}
