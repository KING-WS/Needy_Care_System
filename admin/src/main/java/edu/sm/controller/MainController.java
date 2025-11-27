package edu.sm.controller;

import edu.sm.app.service.CaregiverService;
import edu.sm.app.service.SeniorService;
import edu.sm.app.service.UserService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

/**
 * 메인 컨트롤러
 * 메인 대시보드 및 공통 페이지들을 처리
 */
@Controller
@Slf4j
@RequiredArgsConstructor
public class MainController {

    @Value("${app.api.kakao-js-key}")
    private String kakaoMapKey;

    private final UserService userService;
    private final SeniorService seniorService;
    private final CaregiverService caregiverService;

    /**
     * 메인 대시보드 페이지
     */
    @RequestMapping("/")
    public String dashboard(Model model) {
        log.info("Dashboard page accessed");
        model.addAttribute("kakaoMapKey", kakaoMapKey);
        try {
            model.addAttribute("userCount", userService.getUserCount());
            model.addAttribute("seniorCount", seniorService.getSeniorCount());
            model.addAttribute("caregiverCount", caregiverService.getCaregiverCount());
        } catch (Exception e) {
            log.error("Failed to get counts for dashboard", e);
            model.addAttribute("userCount", 0);
            model.addAttribute("seniorCount", 0);
            model.addAttribute("caregiverCount", 0);
        }
        return "index";
    }

    /**
     * 공통 페이지들
     */
    @RequestMapping("/products")
    public String products(Model model) {
        log.info("Products page accessed");
        model.addAttribute("center", "products");
        return "index";
    }

    @RequestMapping("/orders")
    public String orders(Model model) {
        log.info("Orders page accessed");
        model.addAttribute("center", "orders");
        return "index";
    }

    @RequestMapping("/forms")
    public String forms(Model model) {
        log.info("Forms page accessed");
        model.addAttribute("center", "forms");
        return "index";
    }

    @RequestMapping("/tables")
    public String tables(Model model) {
        log.info("Tables page accessed");
        model.addAttribute("center", "tables");
        return "index";
    }

    @RequestMapping("/messages")
    public String messages(Model model) {
        log.info("Messages page accessed");
        model.addAttribute("center", "messages");
        return "index";
    }

    @RequestMapping("/calendar")
    public String calendar(Model model) {
        log.info("Calendar page accessed");
        model.addAttribute("center", "calendar");
        return "index";
    }

    @RequestMapping("/files")
    public String files(Model model) {
        log.info("Files page accessed");
        model.addAttribute("center", "files");
        return "index";
    }
}
