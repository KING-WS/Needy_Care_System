package edu.sm.controller;

import edu.sm.app.dto.Cust;
import edu.sm.app.dto.HourlySchedule;
import edu.sm.app.dto.Recipient;
import edu.sm.app.dto.Schedule;
import edu.sm.app.aiservice.AiChatService;
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
    private final AiChatService aiChatService;
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
    
    /**
     * AI 일정 추천 API
     */
    @PostMapping("/api/ai/recommend")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> getAiScheduleRecommendation(@RequestBody Map<String, Object> request) {
        Map<String, Object> result = new HashMap<>();
        try {
            Integer recId = (Integer) request.get("recId");
            String targetDateStr = (String) request.get("targetDate");
            String specialNotes = (String) request.get("specialNotes");
            String recommendMode = (String) request.get("recommendMode"); // "basic" or "custom"
            
            if (recId == null || targetDateStr == null) {
                result.put("success", false);
                result.put("message", "recId와 targetDate는 필수입니다.");
                return ResponseEntity.badRequest().body(result);
            }
            
            LocalDate targetDate = LocalDate.parse(targetDateStr);
            
            // 특이사항에서 날짜 추출 (특이사항이 있는 경우)
            if (specialNotes != null && !specialNotes.trim().isEmpty()) {
                String extractedDateStr = aiChatService.extractDateFromText(specialNotes);
                try {
                    LocalDate extractedDate = LocalDate.parse(extractedDateStr);
                    targetDate = extractedDate;
                    log.info("특이사항에서 날짜 추출: {} -> {}", specialNotes, extractedDate);
                } catch (Exception e) {
                    log.warn("추출된 날짜 파싱 실패, 원래 날짜 사용: {}", extractedDateStr);
                }
            }
            
            // 추천 모드에 따라 다른 메서드 호출
            Map<String, Object> recommendationResult;
            if ("custom".equals(recommendMode) && specialNotes != null && !specialNotes.trim().isEmpty()) {
                // 맞춤형 모드: 특이사항 기반 추천
                recommendationResult = aiChatService.getCustomScheduleRecommendation(
                    recId, targetDate, specialNotes);
            } else {
                // 기본 모드: 일반 일정 추천
                recommendationResult = aiChatService.getScheduleRecommendation(
                    recId, targetDate, specialNotes);
            }
            
            if ((Boolean) recommendationResult.get("success")) {
                @SuppressWarnings("unchecked")
                List<Map<String, Object>> schedules = (List<Map<String, Object>>) recommendationResult.get("schedules");
                String scheduleName = (String) recommendationResult.get("scheduleName");
                
                result.put("success", true);
                result.put("schedules", schedules);
                result.put("scheduleName", scheduleName);
                result.put("date", targetDate.toString());
                
                log.info("AI 일정 추천 성공 - recId: {}, targetDate: {}, 일정명: {}, 일정 개수: {}", 
                    recId, targetDate, scheduleName, schedules != null ? schedules.size() : 0);
            } else {
                result.put("success", false);
                result.put("message", recommendationResult.get("message"));
            }
            
            return ResponseEntity.ok(result);
            
        } catch (Exception e) {
            log.error("AI 일정 추천 실패", e);
            result.put("success", false);
            result.put("message", "일정 추천 중 오류가 발생했습니다: " + e.getMessage());
            return ResponseEntity.badRequest().body(result);
        }
    }
    
    /**
     * 특이사항에서 날짜 추출 API
     */
    @PostMapping("/api/ai/extract-date")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> extractDateFromText(@RequestBody Map<String, Object> request) {
        Map<String, Object> result = new HashMap<>();
        try {
            String text = (String) request.get("text");
            
            if (text == null || text.trim().isEmpty()) {
                // 텍스트가 없으면 오늘 날짜 반환
                result.put("success", true);
                result.put("date", LocalDate.now().toString());
                return ResponseEntity.ok(result);
            }
            
            // AiChatService를 통해 날짜 추출
            String extractedDate = aiChatService.extractDateFromText(text);
            
            result.put("success", true);
            result.put("date", extractedDate);
            
            return ResponseEntity.ok(result);
            
        } catch (Exception e) {
            log.error("날짜 추출 실패", e);
            result.put("success", true);
            result.put("date", LocalDate.now().toString()); // 실패 시 오늘 날짜 반환
            return ResponseEntity.ok(result);
        }
    }
}