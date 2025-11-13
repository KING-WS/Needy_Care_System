package edu.sm.controller;

import jakarta.servlet.http.HttpSession;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/mypage")
@Slf4j
public class MyPageController {

    String dir = "mypage/";

    @RequestMapping("")
    public String main(Model model, HttpSession session) {
        if (session.getAttribute("loginUser") == null) {
            log.warn("비로그인 사용자가 /mypage 접근 시도");
            return "redirect:/login";
        }
        model.addAttribute("center", dir + "center");
        model.addAttribute("left", dir + "left");
        return "home";
    }

    @RequestMapping("/profile")
    public String profile(Model model, HttpSession session) {
        if (session.getAttribute("loginUser") == null) {
            log.warn("비로그인 사용자가 /mypage/profile 접근 시도");
            return "redirect:/login";
        }
        model.addAttribute("center", dir + "profile");
        model.addAttribute("left", dir + "left");
        return "home";
    }

    @RequestMapping("/settings")
    public String settings(Model model, HttpSession session) {
        if (session.getAttribute("loginUser") == null) {
            log.warn("비로그인 사용자가 /mypage/settings 접근 시도");
            return "redirect:/login";
        }
        model.addAttribute("center", dir + "settings");
        model.addAttribute("left", dir + "left");
        return "home";
    }

    @RequestMapping("/security")
    public String security(Model model, HttpSession session) {
        if (session.getAttribute("loginUser") == null) {
            log.warn("비로그인 사용자가 /mypage/security 접근 시도");
            return "redirect:/login";
        }
        model.addAttribute("center", dir + "security");
        model.addAttribute("left", dir + "left");
        return "home";
    }
}

