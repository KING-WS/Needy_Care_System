package edu.sm.controller;

import edu.sm.app.dto.Recipient;
import edu.sm.app.dto.Cust;
import edu.sm.app.dto.HealthData;
import edu.sm.app.dto.Schedule;
import edu.sm.app.service.RecipientService;
import edu.sm.app.service.HealthDataService;
import edu.sm.app.service.ScheduleService;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.time.LocalDate;
import java.util.List;

@Controller
@Slf4j
@RequiredArgsConstructor
public class HomeController {
    
    private final RecipientService recipientService;
    private final HealthDataService healthDataService;
    private final ScheduleService scheduleService;
    
    @GetMapping("/")
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
            
            // 노약자 등록 여부 체크
            try {
                List<Recipient> recipients = recipientService.getRecipientsByCustId(loginUser.getCustId());
                if (recipients == null || recipients.isEmpty()) {
                    log.info("등록된 노약자가 없음 - 등록 유도 페이지로 이동");
                    return "redirect:/recipient/prompt";
                }
                log.info("등록된 노약자 수: {}", recipients.size());
                
                // 첫 번째 노약자의 정보와 건강 데이터 조회
                if (!recipients.isEmpty()) {
                    Recipient firstRecipient = recipients.get(0);
                    model.addAttribute("recipient", firstRecipient);
                    
                    // 최신 혈압 데이터 조회
                    try {
                        HealthData latestBloodPressure = healthDataService.getLatestHealthDataByType(
                            firstRecipient.getRecId(), "혈압");
                        model.addAttribute("bloodPressure", latestBloodPressure);
                        log.info("혈압 데이터 조회 성공 - recId: {}", firstRecipient.getRecId());
                    } catch (Exception e) {
                        log.warn("혈압 데이터 조회 실패 - recId: {}", firstRecipient.getRecId());
                    }
                    
                    // 현재 월의 일정 조회
                    try {
                        LocalDate now = LocalDate.now();
                        List<Schedule> schedules = scheduleService.getSchedulesByMonth(
                            firstRecipient.getRecId(), now.getYear(), now.getMonthValue());
                        model.addAttribute("schedules", schedules);
                        log.info("일정 조회 성공 - recId: {}, 개수: {}", firstRecipient.getRecId(), schedules.size());
                    } catch (Exception e) {
                        log.warn("일정 조회 실패 - recId: {}", firstRecipient.getRecId());
                    }
                    
                    // 오늘의 일정 조회
                    try {
                        LocalDate today = LocalDate.now();
                        List<Schedule> todaySchedules = scheduleService.getSchedulesByDateRange(
                            firstRecipient.getRecId(), today, today);
                        model.addAttribute("todaySchedules", todaySchedules);
                        log.info("오늘의 일정 조회 성공 - recId: {}, 개수: {}", firstRecipient.getRecId(), todaySchedules.size());
                    } catch (Exception e) {
                        log.warn("오늘의 일정 조회 실패 - recId: {}", firstRecipient.getRecId());
                    }
                }
            } catch (Exception e) {
                log.error("노약자 조회 중 오류", e);
            }
            
            model.addAttribute("loginUser", loginUser);
            return "home";  // home.jsp로
        }
        
        log.info("비로그인 사용자 접속 - index 페이지 표시");
        return "index";  // index.jsp로
    }
    
    @GetMapping("/home")
    public String home(HttpSession session, Model model,
                      @RequestParam(value = "center", required = false) String center) {
        Cust loginUser = (Cust) session.getAttribute("loginUser");
        
        if (loginUser == null) {
            log.warn("로그인하지 않은 사용자가 /home 접근 시도");
            return "redirect:/login";
        }
        
        // 노약자 등록 여부 체크 (center 파라미터가 없을 때만)
        if (center == null) {
            try {
                List<Recipient> recipients = recipientService.getRecipientsByCustId(loginUser.getCustId());
                if (recipients == null || recipients.isEmpty()) {
                    log.info("등록된 노약자가 없음 - 등록 유도 페이지로 이동");
                    return "redirect:/recipient/prompt";
                }
                
                // 첫 번째 노약자의 정보와 건강 데이터 조회
                if (!recipients.isEmpty()) {
                    Recipient firstRecipient = recipients.get(0);
                    model.addAttribute("recipient", firstRecipient);
                    
                    // 최신 혈압 데이터 조회
                    try {
                        HealthData latestBloodPressure = healthDataService.getLatestHealthDataByType(
                            firstRecipient.getRecId(), "혈압");
                        model.addAttribute("bloodPressure", latestBloodPressure);
                    } catch (Exception e) {
                        log.warn("혈압 데이터 조회 실패");
                    }
                    
                    // 현재 월의 일정 조회
                    try {
                        LocalDate now = LocalDate.now();
                        List<Schedule> schedules = scheduleService.getSchedulesByMonth(
                            firstRecipient.getRecId(), now.getYear(), now.getMonthValue());
                        model.addAttribute("schedules", schedules);
                    } catch (Exception e) {
                        log.warn("일정 조회 실패");
                    }
                    
                    // 오늘의 일정 조회
                    try {
                        LocalDate today = LocalDate.now();
                        List<Schedule> todaySchedules = scheduleService.getSchedulesByDateRange(
                            firstRecipient.getRecId(), today, today);
                        model.addAttribute("todaySchedules", todaySchedules);
                    } catch (Exception e) {
                        log.warn("오늘의 일정 조회 실패");
                    }
                }
            } catch (Exception e) {
                log.error("노약자 조회 중 오류", e);
            }
        }
        
        model.addAttribute("loginUser", loginUser);
        model.addAttribute("center", center);
        
        log.info("center 페이지 요청: {}", center == null ? "기본 페이지" : center);
        
        return "home";
    }
}
