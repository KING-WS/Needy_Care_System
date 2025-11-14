package edu.sm.controller;

import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

/**
 * 대시보드 컨트롤러
 * dashboard/ 폴더의 JSP 파일들을 처리
 */
@Controller
@Slf4j
public class DashboardController {

    @RequestMapping("/analytics")
    public String analytics(Model model) {
        log.info("Analytics page accessed");
        model.addAttribute("center", "dashboard/analytics");
        return "index";
    }
}

