package edu.sm.controller;

import edu.sm.app.dto.Cust;
import edu.sm.app.dto.Recipient;
import edu.sm.app.dto.Schedule;
import edu.sm.app.dto.HourlySchedule;
import edu.sm.app.service.ScheduleService;
import edu.sm.app.service.RecipientService;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@Slf4j
@RequestMapping("/schedule")
@RequiredArgsConstructor
public class ScheduleController {

    private final ScheduleService scheduleService;
    private final RecipientService recipientService; // ✅ 추가

    String dir = "schedule/";

    // ✅ 수정: 일정 페이지 이동 시 돌봄 대상자 정보 로드
    @RequestMapping("")
    public String main(
            Model model,
            HttpSession session,
            @RequestParam(required = false) Integer recId) {

        Cust loginUser = (Cust) session.getAttribute("loginUser");

        if (loginUser == null) {
            log.warn("로그인하지 않은 사용자가 /schedule 접근 시도");
            return "redirect:/login";
        }

        try {
            // 1. 해당 보호자의 돌봄 대상자 목록 조회
            List<Recipient> recipientList = recipientService.getRecipientsByCustId(loginUser.getCustId());

            if (recipientList == null || recipientList.isEmpty()) {
                log.warn("돌봄 대상자가 없습니다 - custId: {}", loginUser.getCustId());
                model.addAttribute("errorMessage", "등록된 돌봄 대상자가 없습니다. 먼저 돌봄 대상자를 등록해주세요.");
                model.addAttribute("center", dir + "center");
                model.addAttribute("left", dir + "left");
                return "home";
            }

            // 2. 선택된 돌봄 대상자 결정
            Recipient selectedRecipient;
            if (recId != null) {
                // URL 파라미터로 recId가 전달된 경우
                selectedRecipient = recipientService.getRecipientById(recId);
                if (selectedRecipient == null) {
                    log.warn("존재하지 않는 recId: {}", recId);
                    selectedRecipient = recipientList.get(0);
                }
            } else {
                // 첫 번째 돌봄 대상자를 기본으로 선택
                selectedRecipient = recipientList.get(0);
            }

            // 3. Model에 데이터 추가
            model.addAttribute("recipientList", recipientList);
            model.addAttribute("selectedRecipient", selectedRecipient);

            log.info("일정 페이지 로드 - custId: {}, recId: {}",
                    loginUser.getCustId(), selectedRecipient.getRecId());

        } catch (Exception e) {
            log.error("일정 페이지 로드 중 오류 발생", e);
            model.addAttribute("errorMessage", "일정을 불러오는 중 오류가 발생했습니다.");
        }

        model.addAttribute("center", dir + "center");
        model.addAttribute("left", dir + "left");
        return "home";
    }

    // 월별 일정 조회 API
    @GetMapping("/api/monthly")
    @ResponseBody
    public ResponseEntity<List<Schedule>> getMonthlySchedules(
            @RequestParam Integer recId,
            @RequestParam int year,
            @RequestParam int month) {
        log.info("월별 일정 조회 - recId: {}, year: {}, month: {}", recId, year, month);
        List<Schedule> schedules = scheduleService.getSchedulesByMonth(recId, year, month);
        return ResponseEntity.ok(schedules);
    }

    // 특정 일정 조회 API
    @GetMapping("/api/schedule/{schedId}")
    @ResponseBody
    public ResponseEntity<Schedule> getSchedule(@PathVariable Integer schedId) {
        log.info("일정 조회 - schedId: {}", schedId);
        Schedule schedule = scheduleService.getScheduleById(schedId);
        return ResponseEntity.ok(schedule);
    }

    // 특정 일정의 시간대별 일정 조회 API
    @GetMapping("/api/hourly/{schedId}")
    @ResponseBody
    public ResponseEntity<List<HourlySchedule>> getHourlySchedules(@PathVariable Integer schedId) {
        log.info("시간대별 일정 조회 - schedId: {}", schedId);
        List<HourlySchedule> hourlySchedules = scheduleService.getHourlySchedulesBySchedId(schedId);
        return ResponseEntity.ok(hourlySchedules);
    }

    // 일정 등록 API
    @PostMapping("/api/schedule")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> createSchedule(@RequestBody Schedule schedule) {
        log.info("일정 등록 - schedule: {}", schedule);
        Map<String, Object> result = new HashMap<>();
        try {
            int count = scheduleService.createSchedule(schedule);
            result.put("success", count > 0);
            result.put("schedId", schedule.getSchedId());
            log.info("일정 등록 완료 - schedId: {}", schedule.getSchedId());
            return ResponseEntity.ok(result);
        } catch (Exception e) {
            log.error("일정 등록 실패", e);
            result.put("success", false);
            result.put("message", e.getMessage());
            return ResponseEntity.badRequest().body(result);
        }
    }

    // 일정 수정 API
    @PutMapping("/api/schedule")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> updateSchedule(@RequestBody Schedule schedule) {
        log.info("일정 수정 - schedule: {}", schedule);
        Map<String, Object> result = new HashMap<>();
        try {
            int count = scheduleService.updateSchedule(schedule);
            result.put("success", count > 0);
            log.info("일정 수정 완료 - schedId: {}", schedule.getSchedId());
            return ResponseEntity.ok(result);
        } catch (Exception e) {
            log.error("일정 수정 실패", e);
            result.put("success", false);
            result.put("message", e.getMessage());
            return ResponseEntity.badRequest().body(result);
        }
    }

    // 일정 삭제 API
    @DeleteMapping("/api/schedule/{schedId}")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> deleteSchedule(@PathVariable Integer schedId) {
        log.info("일정 삭제 - schedId: {}", schedId);
        Map<String, Object> result = new HashMap<>();
        try {
            int count = scheduleService.deleteSchedule(schedId);
            result.put("success", count > 0);
            log.info("일정 삭제 완료 - schedId: {}", schedId);
            return ResponseEntity.ok(result);
        } catch (Exception e) {
            log.error("일정 삭제 실패", e);
            result.put("success", false);
            result.put("message", e.getMessage());
            return ResponseEntity.badRequest().body(result);
        }
    }

    // 시간대별 일정 등록 API
    @PostMapping("/api/hourly")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> createHourlySchedule(@RequestBody HourlySchedule hourlySchedule) {
        log.info("시간대별 일정 등록 - hourlySchedule: {}", hourlySchedule);
        Map<String, Object> result = new HashMap<>();
        try {
            int count = scheduleService.createHourlySchedule(hourlySchedule);
            result.put("success", count > 0);
            result.put("hourlySchedId", hourlySchedule.getHourlySchedId());
            log.info("시간대별 일정 등록 완료 - hourlySchedId: {}", hourlySchedule.getHourlySchedId());
            return ResponseEntity.ok(result);
        } catch (Exception e) {
            log.error("시간대별 일정 등록 실패", e);
            result.put("success", false);
            result.put("message", e.getMessage());
            return ResponseEntity.badRequest().body(result);
        }
    }

    // 시간대별 일정 수정 API
    @PutMapping("/api/hourly")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> updateHourlySchedule(@RequestBody HourlySchedule hourlySchedule) {
        log.info("시간대별 일정 수정 - hourlySchedule: {}", hourlySchedule);
        Map<String, Object> result = new HashMap<>();
        try {
            int count = scheduleService.updateHourlySchedule(hourlySchedule);
            result.put("success", count > 0);
            log.info("시간대별 일정 수정 완료 - hourlySchedId: {}", hourlySchedule.getHourlySchedId());
            return ResponseEntity.ok(result);
        } catch (Exception e) {
            log.error("시간대별 일정 수정 실패", e);
            result.put("success", false);
            result.put("message", e.getMessage());
            return ResponseEntity.badRequest().body(result);
        }
    }

    // 시간대별 일정 삭제 API
    @DeleteMapping("/api/hourly/{hourlySchedId}")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> deleteHourlySchedule(@PathVariable Integer hourlySchedId) {
        log.info("시간대별 일정 삭제 - hourlySchedId: {}", hourlySchedId);
        Map<String, Object> result = new HashMap<>();
        try {
            int count = scheduleService.deleteHourlySchedule(hourlySchedId);
            result.put("success", count > 0);
            log.info("시간대별 일정 삭제 완료 - hourlySchedId: {}", hourlySchedId);
            return ResponseEntity.ok(result);
        } catch (Exception e) {
            log.error("시간대별 일정 삭제 실패", e);
            result.put("success", false);
            result.put("message", e.getMessage());
            return ResponseEntity.badRequest().body(result);
        }
    }
}