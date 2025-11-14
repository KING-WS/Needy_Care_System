package edu.sm.controller;

import edu.sm.app.dto.Cust;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@Slf4j
@RequestMapping("/schedule")
@RequiredArgsConstructor
public class ScheduleController {

    String dir = "schedule/";

    @RequestMapping("")
    public String main(Model model, HttpSession session) {
//        Cust loginUser = (Cust) session.getAttribute("loginUser");
//
//        if (loginUser == null) {
//            log.warn("로그인하지 않은 사용자가 /comm 접근 시도");
//            return "redirect:/login";
//        }
        
        model.addAttribute("center", dir + "center");
        model.addAttribute("left", dir + "left");
        return "home";
    }


}

