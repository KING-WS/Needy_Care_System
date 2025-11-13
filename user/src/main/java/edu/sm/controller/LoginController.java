package edu.sm.controller;

import edu.sm.app.dto.Cust;
import edu.sm.app.service.CustService;
import jakarta.servlet.http.HttpSession;
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
public class LoginController {
    
    private final CustService custService;
    private final BCryptPasswordEncoder passwordEncoder;
    
    @GetMapping("/login")
    public String loginPage(HttpSession session, Model model) {
        // 이미 로그인되어 있으면 메인으로
        if (session.getAttribute("loginUser") != null) {
            return "redirect:/";
        }
        return "login";
    }
    
    @PostMapping("/login")
    public String login(
            @RequestParam("custId") String custId,
            @RequestParam("password") String password,
            HttpSession session,
            Model model) {
        
        try {
            // DB에서 사용자 조회
            Cust cust = custService.get(custId);
            
            if (cust == null) {
                model.addAttribute("error", "아이디 또는 비밀번호가 일치하지 않습니다.");
                return "login";
            }
            
            // 비밀번호 확인
            if (!passwordEncoder.matches(password, cust.getCustPwd())) {
                model.addAttribute("error", "아이디 또는 비밀번호가 일치하지 않습니다.");
                return "login";
            }
            
            // 로그인 성공 - 세션에 사용자 정보 저장
            session.setAttribute("loginUser", cust);
            log.info("로그인 성공: {}", cust.getCustName());
            
            return "redirect:/home";
            
        } catch (Exception e) {
            log.error("로그인 에러", e);
            model.addAttribute("error", "로그인 처리 중 오류가 발생했습니다.");
            return "login";
        }
    }
    
    @GetMapping("/logout")
    public String logout(HttpSession session) {
        session.invalidate();
        log.info("로그아웃 성공");
        return "redirect:/";
    }
}
