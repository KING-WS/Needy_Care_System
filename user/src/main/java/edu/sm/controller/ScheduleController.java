package edu.sm.controller;

import edu.sm.app.aiservice.AiCareContentService;
import edu.sm.app.aiservice.AiChatService;
import edu.sm.app.dto.*;
import edu.sm.app.service.KakaoMapService;
import edu.sm.app.service.MapService;
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

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.*;

@Controller
@Slf4j
@RequestMapping("/schedule")
@RequiredArgsConstructor
public class ScheduleController {

    private final ScheduleService scheduleService;
    private final RecipientService recipientService;
    private final AiChatService aiChatService;
    private final AiCareContentService aiCareContentService;
    private final KakaoMapService kakaoMapService;
    private final MapService mapService;
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

    @GetMapping("/recommend")
    public String recommend(Model model, HttpSession session, @RequestParam(required = false) Integer recId) {
        Cust loginUser = (Cust) session.getAttribute("loginUser");
        if (loginUser == null) {
            return "redirect:/login";
        }

        try {
            List<Recipient> recipientList = recipientService.getRecipientsByCustId(loginUser.getCustId());
            if (recipientList != null && !recipientList.isEmpty()) {
                Recipient selectedRecipient = recipientList.get(0);
                if (recId != null) {
                    for (Recipient r : recipientList) {
                        if (r.getRecId().equals(recId)) {
                            selectedRecipient = r;
                            break;
                        }
                    }
                }
                model.addAttribute("recipientList", recipientList);
                model.addAttribute("selectedRecipient", selectedRecipient);
            }
        } catch (Exception e) {
            log.error("추천 페이지 로드 중 오류", e);
        }

        model.addAttribute("center", dir + "recommend");
        model.addAttribute("left", dir + "left");
        return "home";
    }

    @PostMapping("/ai-recommend")
    @ResponseBody
    public ResponseEntity<List<Map<String, Object>>> aiRecommend(@RequestBody Map<String, Integer> request, HttpSession session) {
        Cust loginUser = (Cust) session.getAttribute("loginUser");
        if (loginUser == null) {
            return ResponseEntity.status(401).build();
        }

        try {
            Integer recId = request.get("recId");
            Recipient recipient;
            if (recId != null) {
                recipient = recipientService.getRecipientById(recId);
            } else {
                List<Recipient> list = recipientService.getRecipientsByCustId(loginUser.getCustId());
                if (list == null || list.isEmpty()) return ResponseEntity.ok(List.of());
                recipient = list.get(0);
            }

            if (recipient == null) return ResponseEntity.ok(List.of());

            // 1. AI 추천 (장소/행사)
            List<Map<String, Object>> recommendations = aiCareContentService.recommendPlaces(recipient);

            // 2. 위치 기반 정보 보정 (Kakao Map API)
            String address = recipient.getRecAddress();
            // 주소가 없거나 Kakao API 키가 없어서 좌표를 못 구할 수 있음
            String lat = null;
            String lng = null;
            
            if (address != null && !address.isEmpty()) {
                Map<String, String> userCoords = kakaoMapService.getCoordinates(address);
                lat = userCoords.get("y");
                lng = userCoords.get("x");
            }

            for (Map<String, Object> item : recommendations) {
                String placeName = (String) item.get("mapName");
                List<Map<String, Object>> searchResults = new ArrayList<>();
                
                // 사용자 위치 기반 검색 시도
                if (lat != null && lng != null) {
                    searchResults = kakaoMapService.searchPlace(placeName, lat, lng);
                }
                
                // 결과가 없으면 키워드로만 재검색 (전국 범위)
                if (searchResults.isEmpty()) {
                     searchResults = kakaoMapService.searchPlace(placeName, null, null);
                }

                if (!searchResults.isEmpty()) {
                    Map<String, Object> firstResult = searchResults.get(0);
                    item.put("distance", firstResult.get("distance")); // 거리 (미터)
                    item.put("address", firstResult.get("road_address_name"));
                    item.put("placeUrl", firstResult.get("place_url"));
                    item.put("x", firstResult.get("x"));
                    item.put("y", firstResult.get("y"));
                } else {
                    // 검색 결과 없음 (주소 정보 없음)
                    item.put("address", "주소 정보 없음");
                    item.put("placeUrl", "");
                    item.put("distance", null);
                }
            }

            // 3. 거리순 정렬 (거리가 있는 항목 우선)
            recommendations.sort((o1, o2) -> {
                String d1 = (String) o1.get("distance");
                String d2 = (String) o2.get("distance");
                if (d1 == null && d2 == null) return 0;
                if (d1 == null) return 1;
                if (d2 == null) return -1;
                return Integer.compare(Integer.parseInt(d1), Integer.parseInt(d2));
            });

            return ResponseEntity.ok(recommendations);

        } catch (Exception e) {
            log.error("AI 추천 실패", e);
            return ResponseEntity.badRequest().build();
        }
    }

    @PostMapping("/save-recommendation")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> saveRecommendation(@RequestBody Map<String, Object> request) {
        Map<String, Object> response = new HashMap<>();
        try {
            Integer recId = Integer.parseInt(request.get("recId").toString());
            String schedDate = (String) request.get("schedDate");
            String schedName = (String) request.get("schedName");
            String mapAddress = (String) request.get("mapAddress");
            String mapName = (String) request.get("mapName");
            String mapContent = (String) request.get("mapContent");
            String mapCategory = (String) request.get("mapCategory");

            // 1. Schedule 저장
            Schedule schedule = new Schedule();
            schedule.setRecId(recId);
            schedule.setSchedDate(LocalDate.parse(schedDate));
            schedule.setSchedName(schedName);
            schedule.setSchedStartTime("09:00"); // 기본값
            schedule.setSchedEndTime("11:00");   // 기본값
            scheduleService.createSchedule(schedule);

            // 2. MapLocation 저장
            MapLocation mapLocation = new MapLocation();
            mapLocation.setRecId(recId);
            mapLocation.setMapName(mapName);
            // 주소 정보를 내용에 포함하여 저장 (DTO에 주소 필드가 없으므로)
            String finalContent = mapContent;
            if (mapAddress != null && !mapAddress.isEmpty() && !mapAddress.equals("주소 정보 없음")) {
                finalContent = "[주소: " + mapAddress + "]\n" + mapContent;
            }
            mapLocation.setMapContent(finalContent);
            mapLocation.setMapCategory(mapCategory);
            
            // 좌표 정보 구하기 (사용자가 입력한 주소 기반)
            if (mapAddress != null && !mapAddress.isEmpty() && !mapAddress.equals("주소 정보 없음")) {
                 Map<String, String> coords = kakaoMapService.getCoordinates(mapAddress);
                 if(coords.containsKey("y")) mapLocation.setMapLatitude(new BigDecimal(coords.get("y")));
                 if(coords.containsKey("x")) mapLocation.setMapLongitude(new BigDecimal(coords.get("x")));
            }

            mapService.register(mapLocation);

            response.put("success", true);
            response.put("message", "일정과 장소가 추가되었습니다.");
            return ResponseEntity.ok(response);

        } catch (Exception e) {
            log.error("추천 저장 실패", e);
            response.put("success", false);
            response.put("message", "저장 실패: " + e.getMessage());
            return ResponseEntity.badRequest().body(response);
        }
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