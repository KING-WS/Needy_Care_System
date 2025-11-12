package edu.sm.controller;

import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

/**
 * 노약자 관리 컨트롤러
 * senior/ 폴더의 JSP 파일들을 처리
 */
@Controller
@Slf4j
@RequestMapping("/senior")
public class SeniorController {

    @RequestMapping("/list")
    public String seniorList(Model model) {
        log.info("Senior list page accessed");
        model.addAttribute("center", "senior/senior-list");
        return "index";
    }

    @RequestMapping("/add")
    public String seniorAdd(Model model) {
        log.info("Senior add page accessed");
        model.addAttribute("center", "senior/senior-add");
        return "index";
    }

    @RequestMapping("/care")
    public String seniorCare(Model model) {
        log.info("Senior care page accessed");
        model.addAttribute("center", "senior/senior-care");
        return "index";
    }
}

