package edu.sm.controller;

import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

/**
 * Q&A 관리 컨트롤러
 * Q&A/ 폴더의 JSP 파일들을 처리
 */
@Controller
@Slf4j
public class QnaController {

    @RequestMapping("/qna")
    public String qna(Model model) {
        log.info("Q&A page accessed");
        model.addAttribute("center", "Q&A/qna");
        return "index";
    }
}

