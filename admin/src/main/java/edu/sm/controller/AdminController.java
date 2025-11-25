package edu.sm.controller;

import edu.sm.app.service.AlertLogService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.Map;

/**
 * 관리자 설정 컨트롤러
 * admin/ 폴더의 JSP 파일들을 처리
 */
@Controller
@Slf4j
@RequestMapping("/admin")
@RequiredArgsConstructor // AlertLogService 주입을 위해 추가
public class AdminController {

    private final AlertLogService alertLogService; // AlertLogService 주입

    @RequestMapping("/settings")
    public String settings(Model model) {
        log.info("Settings page accessed");
        model.addAttribute("center", "admin/settings");
        return "index";
    }

    @RequestMapping("/security")
    public String security(Model model) {
        log.info("Security page accessed");
        model.addAttribute("center", "admin/security");
        return "index";
    }

    @RequestMapping("/help")
    public String help(Model model) {
        log.info("Help page accessed");
        model.addAttribute("center", "admin/help");
        return "index";
    }

    @RequestMapping("/profile")
    public String profile(Model model) {
        log.info("Profile page accessed");
        model.addAttribute("center", "admin/profile");
        return "index";
    }


    @GetMapping("/alerts")
    public String alerts(Model model) {
        log.info("Admin Alerts page accessed");
        model.addAttribute("alerts", alertLogService.findAllAlerts());


        model.addAttribute("center", "admin/alerts");
        return "index";
    }

    /**
     * 알림 확인 처리 (AJAX 요청용)
     * @param alertId
     * @return
     */
    @PostMapping("/alerts/check/{alertId}")
    @ResponseBody // JSON 응답을 위해
    public ResponseEntity<Map<String, String>> markAlertAsChecked(@PathVariable("alertId") int alertId) {
        log.info("Alert ID {} check request received.", alertId);
        try {
            alertLogService.markAsChecked(alertId);
            return ResponseEntity.ok(Map.of("status", "success", "message", "알림이 확인 처리되었습니다."));
        } catch (Exception e) {
            log.error("Failed to mark alert {} as checked", alertId, e);
            return ResponseEntity.status(500).body(Map.of("status", "error", "message", "알림 확인 처리 실패: " + e.getMessage()));
        }
    }
}

