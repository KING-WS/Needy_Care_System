package edu.sm.controller;

import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

/**
 * 관리자 설정 컨트롤러
 * admin/ 폴더의 JSP 파일들을 처리
 */
@Controller
@Slf4j
@RequestMapping("/admin")
public class AdminController {

    @RequestMapping("/settings")
    public String settings(Model model) {
        log.info("Settings page accessed");
        model.addAttribute("center", "admin/settings");
        return "index";
    }

    @RequestMapping("/security")
    public String security(Model model) {
        log.info("Security page accessed");
        model.addAttribute("center", "admin/security");
        return "index";
    }

    @RequestMapping("/help")
    public String help(Model model) {
        log.info("Help page accessed");
        model.addAttribute("center", "admin/help");
        return "index";
    }

    @RequestMapping("/profile")
    public String profile(Model model) {
        log.info("Profile page accessed");
        model.addAttribute("center", "admin/profile");
        return "index";
    }
}

