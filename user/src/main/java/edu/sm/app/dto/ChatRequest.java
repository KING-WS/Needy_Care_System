package edu.sm.app.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
@NoArgsConstructor
@AllArgsConstructor
public class ChatRequest {
    private String message;
    private String kioskCode;
    private Integer recId; // kioskCode 대신 recId를 직접 사용할 수 있도록 추가
}
