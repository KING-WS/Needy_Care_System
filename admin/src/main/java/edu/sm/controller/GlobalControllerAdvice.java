package edu.sm.controller;

import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ModelAttribute;

@Slf4j
@ControllerAdvice // 모든 컨트롤러에 적용되는 전역 설정임을 명시 어드민 모든 화면에 알림뜨게하는 파일
public class GlobalControllerAdvice {

    // application-dev.yml에 있는 설정값을 가져옴
    @Value("${kiosk.server.url}")
    private String kioskServerUrl;

    // 모든 요청 시 모델에 자동으로 담김
    @ModelAttribute
    public void addGlobalAttributes(Model model) {
        model.addAttribute("kioskServerUrl", kioskServerUrl);
        // log.info("Global Env Loaded - Kiosk URL: {}", kioskServerUrl); // 필요시 주석 해제 확인
    }
}