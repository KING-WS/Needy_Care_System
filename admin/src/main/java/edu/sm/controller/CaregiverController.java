package edu.sm.controller;

import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

/**
 * 요양사 관리 컨트롤러
 * doctor/ 폴더의 JSP 파일들을 처리
 */
@Controller
@Slf4j
@RequestMapping("/caregiver")
public class CaregiverController {

    @RequestMapping("/list")
    public String caregiverList(Model model) {
        log.info("Caregiver list page accessed");
        model.addAttribute("center", "doctor/caregiver-list");
        return "index";
    }

    @RequestMapping("/add")
    public String caregiverAdd(Model model) {
        log.info("Caregiver add page accessed");
        model.addAttribute("center", "doctor/caregiver-add");
        return "index";
    }

    @RequestMapping("/manage")
    public String caregiverManage(Model model) {
        log.info("Caregiver manage page accessed");
        model.addAttribute("center", "doctor/caregiver-manage");
        return "index";
    }
}

