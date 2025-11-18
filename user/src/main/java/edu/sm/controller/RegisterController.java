package edu.sm.controller;

import edu.sm.app.dto.Cust;
import edu.sm.app.service.CustService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
@RequiredArgsConstructor
@Slf4j
public class RegisterController {
    
    private final CustService custService;
    private final BCryptPasswordEncoder passwordEncoder;
    
    @GetMapping("/register")
    public String registerPage(Model model) {
        return "register";
    }
    
    @PostMapping("/register")
    public String register(
            @RequestParam("custEmail") String custEmail,
            @RequestParam("custPwd") String custPwd,
            @RequestParam("passwordConfirm") String passwordConfirm,
            @RequestParam("custName") String custName,
            @RequestParam("custPhone") String custPhone,
            Model model) {
        
        try {
            // 비밀번호 확인
            if (!custPwd.equals(passwordConfirm)) {
                model.addAttribute("error", "비밀번호가 일치하지 않습니다.");
                return "register";
            }
            
            // 이메일 중복 체크
            Cust existingCust = custService.getByEmail(custEmail);
            if (existingCust != null) {
                model.addAttribute("error", "이미 사용 중인 이메일입니다.");
                return "register";
            }
            
            // 비밀번호 암호화
            String encodedPassword = passwordEncoder.encode(custPwd);
            
            // Cust 객체 생성
            Cust cust = Cust.builder()
                    .custEmail(custEmail)
                    .custPwd(encodedPassword)
                    .custName(custName)
                    .custPhone(custPhone)
                    .build();
            
            // 회원가입 처리
            custService.register(cust);
            
            log.info("회원가입 성공: {}", custEmail);
            model.addAttribute("success", "회원가입이 완료되었습니다! 로그인해주세요.");
            return "redirect:/login";
            
        } catch (Exception e) {
            log.error("회원가입 에러", e);
            model.addAttribute("error", "회원가입 처리 중 오류가 발생했습니다.");
            return "register";
        }
    }
}

