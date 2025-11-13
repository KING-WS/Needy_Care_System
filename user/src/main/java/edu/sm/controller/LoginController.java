package edu.sm.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
public class LoginController {
    //로그인
    @GetMapping("/login")
    public String loginPage(Model model) {
        return "login";
    }
    
    @PostMapping("/login")
    public String login(
            @RequestParam("email") String email,
            @RequestParam("password") String password,
            Model model) {
        
        // 여기에 로그인 로직 추가
        // 예: userService.login(email, password)
        
        // 임시로 성공 처리
        model.addAttribute("success", "로그인 성공!");
        return "redirect:/";
    }
}
