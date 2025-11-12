package edu.sm.controller;

import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

/**
 * 차트 컨트롤러
 * chart/ 폴더의 JSP 파일들을 처리
 */
@Controller
@Slf4j
@RequestMapping("/chart")
public class ChartController {

    @RequestMapping("")
    public String chart(Model model) {
        log.info("Chart page accessed");
        model.addAttribute("center", "chart/chart");
        return "index";
    }
}

