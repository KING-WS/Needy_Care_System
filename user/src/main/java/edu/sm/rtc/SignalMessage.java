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

    // [★중요★] 깃 되돌리면서 이 부분이 사라졌을 겁니다. 다시 꼭 넣어주세요!
    // WebRTC 연결에 필수적인 정보들입니다.
    private Object sdp;
    private Object candidate;
}