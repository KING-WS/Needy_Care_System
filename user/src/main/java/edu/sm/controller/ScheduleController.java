package edu.sm.controller;

import edu.sm.app.dto.Cust;
import edu.sm.app.dto.HourlySchedule;
import edu.sm.app.dto.Recipient;
import edu.sm.app.dto.Schedule;
import edu.sm.app.service.RecipientService;
import edu.sm.app.service.ScheduleService;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@Slf4j
@RequestMapping("/schedule")
@RequiredArgsConstructor
public class ScheduleController {

    private final ScheduleService scheduleService;
    private final RecipientService recipientService;
    private final String dir = "schedule/";

    @RequestMapping("")
    public String main(Model model, HttpSession session,
                       @RequestParam(required = false) Integer recId) {

        Cust loginUser = (Cust) session.getAttribute("loginUser");
        if (loginUser == null) {
            return "redirect:/login";
        }

        try {
            List<Recipient> recipientList = recipientService.getRecipientsByCustId(loginUser.getCustId());

            if (recipientList == null || recipientList.isEmpty()) {
                log.warn("돌봄 대상자 없음 - custId: {}", loginUser.getCustId());
                model.addAttribute("recipientList", null);
                model.addAttribute("selectedRecipient", null);
            } else {
                Recipient selectedRecipient;
                if (recId != null && recId > 0) {
                    selectedRecipient = recipientService.getRecipientById(recId);
                    if (selectedRecipient == null) {
                        selectedRecipient = recipientList.get(0);
                    }
                } else {
                    selectedRecipient = recipientList.get(0);
                }

                log.info("일정 페이지 접근 - custId: {}, recId: {}, recName: {}",
                        loginUser.getCustId(), selectedRecipient.getRecId(), selectedRecipient.getRecName());

                model.addAttribute("recipientList", recipientList);
                model.addAttribute("selectedRecipient", selectedRecipient);
            }
        } catch (Exception e) {
            log.error("일정 페이지 로드 실패", e);
            model.addAttribute("recipientList", null);
            model.addAttribute("selectedRecipient", null);
        }

        model.addAttribute("center", dir + "center");
        model.addAttribute("left", dir + "left");
        return "home";
    }

    @GetMapping("/api/monthly")
    @ResponseBody
    public ResponseEntity<?> getMonthlySchedules(
            @RequestParam(required = false) Integer recId,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate startDate,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate endDate) {

        if (recId == null || startDate == null || endDate == null) {
            return ResponseEntity.badRequest().body(
                    Map.of("success", false, "message", "recId, startDate, and endDate are required.")
            );
        }

        try {
            List<Schedule> schedules = scheduleService.getSchedulesByDateRange(recId, startDate, endDate);
            log.info("날짜 범위 일정 조회 - recId: {}, {} ~ {}, 개수: {}", recId, startDate, endDate, schedules.size());
            return ResponseEntity.ok(schedules);
        } catch (Exception e) {
            log.error("날짜 범위 일정 조회 실패 - recId: {}", recId, e);
            return ResponseEntity.badRequest().body(
                    Map.of("success", false, "message", "일정 조회 실패: " + e.getMessage())
            );
        }
    }

    @GetMapping("/api/schedule/{schedId}")
    @ResponseBody
    public ResponseEntity<?> getSchedule(@PathVariable Integer schedId) {
        try {
            Schedule schedule = scheduleService.getScheduleById(schedId);
            if (schedule == null) {
                return ResponseEntity.badRequest().body(
                        Map.of("success", false, "message", "일정을 찾을 수 없습니다.")
                );
            }
            return ResponseEntity.ok(schedule);
        } catch (Exception e) {
            log.error("일정 조회 실패 - schedId: {}", schedId, e);
            return ResponseEntity.badRequest().body(
                    Map.of("success", false, "message", e.getMessage())
            );
        }
    }

    @GetMapping("/api/hourly/{schedId}")
    @ResponseBody
    public ResponseEntity<?> getHourlySchedules(@PathVariable Integer schedId) {
        try {
            List<HourlySchedule> hourlySchedules = scheduleService.getHourlySchedulesBySchedId(schedId);
            return ResponseEntity.ok(hourlySchedules);
        } catch (Exception e) {
            log.error("시간대별 일정 조회 실패 - schedId: {}", schedId, e);
            return ResponseEntity.badRequest().body(
                    Map.of("success", false, "message", e.getMessage())
            );
        }
    }

    @GetMapping("/api/hourly/detail/{hourlySchedId}")
    @ResponseBody
    public ResponseEntity<?> getHourlySchedule(@PathVariable Integer hourlySchedId) {
        try {
            HourlySchedule hourlySchedule = scheduleService.getHourlyScheduleById(hourlySchedId);
            if (hourlySchedule == null) {
                return ResponseEntity.badRequest().body(
                        Map.of("success", false, "message", "시간대별 일정을 찾을 수 없습니다.")
                );
            }
            return ResponseEntity.ok(hourlySchedule);
        } catch (Exception e) {
            log.error("시간대별 일정 조회 실패 - hourlySchedId: {}", hourlySchedId, e);
            return ResponseEntity.badRequest().body(
                    Map.of("success", false, "message", e.getMessage())
            );
        }
    }

    @PostMapping("/api/schedule")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> createSchedule(@RequestBody Schedule schedule) {
        Map<String, Object> result = new HashMap<>();
        try {
            log.info("일정 등록 - recId: {}, schedName: {}", schedule.getRecId(), schedule.getSchedName());

            int count = scheduleService.createSchedule(schedule);

            if (count > 0) {
                // Fetch the full schedule object to return it
                Schedule newSchedule = scheduleService.getScheduleById(schedule.getSchedId());
                result.put("success", true);
                result.put("schedule", newSchedule);
            } else {
                result.put("success", false);
                result.put("message", "일정 등록에 실패했습니다.");
            }

            return ResponseEntity.ok(result);
        } catch (Exception e) {
            log.error("일정 등록 실패", e);
            result.put("success", false);
            result.put("message", e.getMessage());
            return ResponseEntity.badRequest().body(result);
        }
    }

    @PutMapping("/api/schedule")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> updateSchedule(@RequestBody Schedule schedule) {
        Map<String, Object> result = new HashMap<>();
        try {
            log.info("일정 수정 - schedId: {}", schedule.getSchedId());

            int count = scheduleService.updateSchedule(schedule);

            if (count > 0) {
                Schedule updatedSchedule = scheduleService.getScheduleById(schedule.getSchedId());
                result.put("success", true);
                result.put("schedule", updatedSchedule);
            } else {
                result.put("success", false);
                result.put("message", "일정 수정에 실패했거나 변경된 내용이 없습니다.");
            }

            return ResponseEntity.ok(result);
        } catch (Exception e) {
            log.error("일정 수정 실패 - schedId: {}", schedule.getSchedId(), e);
            result.put("success", false);
            result.put("message", e.getMessage());
            return ResponseEntity.badRequest().body(result);
        }
    }

    @DeleteMapping("/api/schedule/{schedId}")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> deleteSchedule(@PathVariable Integer schedId) {
        Map<String, Object> result = new HashMap<>();
        try {
            int count = scheduleService.deleteSchedule(schedId);
            result.put("success", count > 0);

            if (count > 0) {
                log.info("일정 삭제 완료 - schedId: {}", schedId);
            }
            return ResponseEntity.ok(result);
        } catch (Exception e) {
            log.error("일정 삭제 실패 - schedId: {}", schedId, e);
            result.put("success", false);
            result.put("message", e.getMessage());
            return ResponseEntity.badRequest().body(result);
        }
    }

    @PostMapping("/api/hourly")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> createHourlySchedule(@RequestBody HourlySchedule hourlySchedule) {
        Map<String, Object> result = new HashMap<>();
        try {
            log.info("시간대별 일정 등록 - schedId: {}, name: {}",
                    hourlySchedule.getSchedId(), hourlySchedule.getHourlySchedName());

            int count = scheduleService.createHourlySchedule(hourlySchedule);
            result.put("success", count > 0);
            result.put("hourlySchedId", hourlySchedule.getHourlySchedId());

            return ResponseEntity.ok(result);
        } catch (Exception e) {
            log.error("시간대별 일정 등록 실패", e);
            result.put("success", false);
            result.put("message", e.getMessage());
            return ResponseEntity.badRequest().body(result);
        }
    }

    @PutMapping("/api/hourly")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> updateHourlySchedule(@RequestBody HourlySchedule hourlySchedule) {
        Map<String, Object> result = new HashMap<>();
        try {
            log.info("시간대별 일정 수정 - hourlySchedId: {}", hourlySchedule.getHourlySchedId());

            int count = scheduleService.updateHourlySchedule(hourlySchedule);
            result.put("success", count > 0);

            return ResponseEntity.ok(result);
        } catch (Exception e) {
            log.error("시간대별 일정 수정 실패 - hourlySchedId: {}", hourlySchedule.getHourlySchedId(), e);
            result.put("success", false);
            result.put("message", e.getMessage());
            return ResponseEntity.badRequest().body(result);
        }
    }

    @DeleteMapping("/api/hourly/{hourlySchedId}")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> deleteHourlySchedule(@PathVariable Integer hourlySchedId) {
        Map<String, Object> result = new HashMap<>();
        try {
            int count = scheduleService.deleteHourlySchedule(hourlySchedId);
            result.put("success", count > 0);

            if (count > 0) {
                log.info("시간대별 일정 삭제 완료 - hourlySchedId: {}", hourlySchedId);
            }
            return ResponseEntity.ok(result);
        } catch (Exception e) {
            log.error("시간대별 일정 삭제 실패 - hourlySchedId: {}", hourlySchedId, e);
            result.put("success", false);
            result.put("message", e.getMessage());
            return ResponseEntity.badRequest().body(result);
        }
    }
}