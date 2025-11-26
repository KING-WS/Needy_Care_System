package edu.sm.rtc;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class SignalMessage {
    private String type;
    private String roomId;
    private String targetSessionId;

    // 이전에 있던 data 필드
    private Object data;

    // [★추가됨★] WebRTC 연결에 필수적인 정보들입니다.
    // 자바스크립트에서 보낸 객체를 그대로 받기 위해 Object로 선언합니다.
    private Object sdp;
    private Object candidate;
}