package edu.sm.controller;

import edu.sm.app.dto.Cust;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@Slf4j
@RequestMapping("/comm")
@RequiredArgsConstructor
public class CommController {


    @Value("${app.url.websocketurl:https://localhost:8084}")
    private String websocketUrl;

    String dir = "comm/";

    @RequestMapping("")
    public String main(Model model, HttpSession session) {
//        Cust loginUser = (Cust) session.getAttribute("loginUser");
//
//        if (loginUser == null) {
//            log.warn("로그인하지 않은 사용자가 /comm 접근 시도");
//            return "redirect:/login";
//        }
        
        model.addAttribute("center", dir + "center");
        // left 메뉴 제거 - 상단바에서 바로 이동
        return "home";
    }

    @RequestMapping("/chat")
    public String chat(Model model, HttpSession session) {
        Cust loginUser = (Cust) session.getAttribute("loginUser");
        
        if (loginUser == null) {
            return "redirect:/login";
        }
        
        model.addAttribute("center", dir + "chat");
        model.addAttribute("left", dir + "left");
        return "home";
    }

    @RequestMapping("/video")
    public String video(Model model, HttpSession session) {
        Cust loginUser = (Cust) session.getAttribute("loginUser");
        
        if (loginUser == null) {
            return "redirect:/login";
        }

        model.addAttribute("websocketUrl", websocketUrl);
        model.addAttribute("center", dir + "video");
        model.addAttribute("left", dir + "left");
        return "home";
    }
}

