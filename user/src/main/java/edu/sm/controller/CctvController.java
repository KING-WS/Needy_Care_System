package edu.sm.controller;


import edu.sm.app.dto.Cust;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@Slf4j
@RequestMapping("/cctv")
@RequiredArgsConstructor
public class CctvController {
    @GetMapping("")
    public String index(HttpSession session, Model model) {
        // 로그인된 사용자가 있으면 home으로, 없으면 index로
        Cust loginUser = null;
        try {
            loginUser = (Cust) session.getAttribute("loginUser");
        } catch (Exception e) {
            // 세션이 invalidate된 경우 무시
            log.debug("세션 조회 중 오류 (무시): {}", e.getMessage());
        }

        if (loginUser != null) {
            log.info("로그인된 사용자 접속: {}", loginUser.getCustName());
            model.addAttribute("loginUser", loginUser);
            return "home";  // home.jsp로
        }

        log.info("비로그인 사용자 접속 - index 페이지 표시");
        return "index";  // index.jsp로
    }

}
