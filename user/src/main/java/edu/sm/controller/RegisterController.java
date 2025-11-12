package edu.sm.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
public class RegisterController {
    
    @GetMapping("/register")
    public String registerPage(Model model) {
        return "register";
    }
    
    @PostMapping("/register")
    public String register(
            @RequestParam("username") String username,
            @RequestParam("password") String password,
            @RequestParam("passwordConfirm") String passwordConfirm,
            @RequestParam("patientName") String patientName,
            @RequestParam("patientFeature") String patientFeature,
            @RequestParam("guardianName") String guardianName,
            @RequestParam("address") String address,
            Model model) {
        
        // 비밀번호 확인
        if (!password.equals(passwordConfirm)) {
            model.addAttribute("error", "비밀번호가 일치하지 않습니다.");
            return "register";
        }
        
        // 여기에 회원가입 로직 추가
        // 예: userService.register(...)
        
        model.addAttribute("success", "회원가입이 완료되었습니다!");
        return "redirect:/";
    }
}

