package edu.sm.controller;

import edu.sm.rtc.KioskWebSocketHandler;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.Set;

@RestController
@RequiredArgsConstructor
public class KioskStatusController {

    // User 프로젝트에는 이 핸들러가 있습니다!
    private final KioskWebSocketHandler kioskWebSocketHandler;

    // Admin 서버(8085)에서 요청하므로 CORS 허용 필수
    @CrossOrigin(origins = "*")
    @GetMapping("/api/kiosk/active")
    public Set<String> getActiveKioskList() {
        return kioskWebSocketHandler.getActiveKioskCodes();
    }
}