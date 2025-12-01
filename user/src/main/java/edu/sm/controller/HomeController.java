package edu.sm.controller;

import edu.sm.app.dto.Caregiver;
import edu.sm.app.dto.Cust;
import edu.sm.app.dto.HealthData;
import edu.sm.app.dto.HourlySchedule;
import edu.sm.app.dto.MapCourse;
import edu.sm.app.dto.MapLocation;
import edu.sm.app.dto.MealPlan;
import edu.sm.app.dto.Recipient;
import edu.sm.app.dto.Schedule;
import edu.sm.app.service.CareMatchingService;
import edu.sm.app.service.HealthDataService;
import edu.sm.app.service.MapCourseService;
import edu.sm.app.service.MapService;
import edu.sm.app.service.MealPlanService;
import edu.sm.app.service.RecipientService;
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
    private final MapService mapService;
    private final MapCourseService mapCourseService;
    private final MealPlanService mealPlanService;
    private final CareMatchingService careMatchingService;
    
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
                
                // 선택된 노약자 결정
                Recipient selectedRecipient = null;
                
                // 1. 세션에 저장된 노약자가 있으면 사용 (하지만 항상 DB에서 최신 정보를 다시 조회)
                Recipient sessionRecipient = (Recipient) session.getAttribute("selectedRecipient");
                // 세션의 노약자가 현재 사용자의 노약자인지 확인
                if (sessionRecipient != null && sessionRecipient.getCustId().equals(loginUser.getCustId())) {
                    // 세션에 저장된 recipient의 recId로 DB에서 최신 정보를 다시 조회
                    selectedRecipient = recipientService.getRecipientById(sessionRecipient.getRecId());
                    if (selectedRecipient != null) {
                        // 세션에 최신 정보로 업데이트
                        session.setAttribute("selectedRecipient", selectedRecipient);
                    }
                }
                
                // 2. 세션에도 없으면 첫 번째 노약자 사용
                if (selectedRecipient == null && !recipients.isEmpty()) {
                    selectedRecipient = recipients.get(0);
                    // 세션에 저장
                    session.setAttribute("selectedRecipient", selectedRecipient);
                }
                
                // 선택된 노약자의 정보와 건강 데이터 조회
                if (selectedRecipient != null) {
                    model.addAttribute("recipient", selectedRecipient);
                    
                    // 최신 혈압 데이터 조회
                    try {
                        HealthData latestBloodPressure = healthDataService.getLatestHealthDataByType(
                            selectedRecipient.getRecId(), "혈압");
                        model.addAttribute("bloodPressure", latestBloodPressure);
                        log.info("혈압 데이터 조회 성공 - recId: {}", selectedRecipient.getRecId());
                    } catch (Exception e) {
                        log.warn("혈압 데이터 조회 실패 - recId: {}", selectedRecipient.getRecId());
                    }
                    
                    // 현재 월의 일정 조회
                    try {
                        LocalDate now = LocalDate.now();
                        List<Schedule> schedules = scheduleService.getSchedulesByMonth(
                            selectedRecipient.getRecId(), now.getYear(), now.getMonthValue());
                        model.addAttribute("schedules", schedules);
                        log.info("일정 조회 성공 - recId: {}, 개수: {}", selectedRecipient.getRecId(), schedules.size());
                    } catch (Exception e) {
                        log.warn("일정 조회 실패 - recId: {}", selectedRecipient.getRecId());
                    }
                    
                    // 오늘의 일정 조회
                    try {
                        LocalDate today = LocalDate.now();
                        List<Schedule> todaySchedules = scheduleService.getSchedulesByDateRange(
                            selectedRecipient.getRecId(), today, today);
                        model.addAttribute("todaySchedules", todaySchedules);
                        log.info("오늘의 일정 조회 성공 - recId: {}, 개수: {}", selectedRecipient.getRecId(), todaySchedules.size());
                        
                        // 오늘의 HourlySchedule 조회
                        List<HourlySchedule> todayHourlySchedules = new java.util.ArrayList<>();
                        for (Schedule schedule : todaySchedules) {
                            List<HourlySchedule> hourlySchedules = scheduleService.getHourlySchedulesBySchedId(schedule.getSchedId());
                            todayHourlySchedules.addAll(hourlySchedules);
                        }
                        // 시작 시간으로 정렬
                        todayHourlySchedules.sort((h1, h2) -> {
                            if (h1.getHourlySchedStartTime() == null) return 1;
                            if (h2.getHourlySchedStartTime() == null) return -1;
                            return h1.getHourlySchedStartTime().compareTo(h2.getHourlySchedStartTime());
                        });
                        model.addAttribute("todayHourlySchedules", todayHourlySchedules);
                        log.info("오늘의 시간대별 일정 조회 성공 - 개수: {}", todayHourlySchedules.size());
                    } catch (Exception e) {
                        log.warn("오늘의 일정 조회 실패", e);
                    }
                    
                    // 오늘의 식단 조회
                    try {
                        LocalDate today = LocalDate.now();
                        List<MealPlan> todayMeals = mealPlanService.getByRecIdAndDate(
                            selectedRecipient.getRecId(), today);
                        // 식단 정렬: 타입 순서(아침->점심->저녁) -> 등록 시간 순서
                        todayMeals.sort((m1, m2) -> {
                            // 타입 순서 정의
                            java.util.Map<String, Integer> typeOrder = new java.util.HashMap<>();
                            typeOrder.put("아침", 1);
                            typeOrder.put("점심", 2);
                            typeOrder.put("저녁", 3);
                            
                            int typeOrder1 = typeOrder.getOrDefault(m1.getMealType(), 99);
                            int typeOrder2 = typeOrder.getOrDefault(m2.getMealType(), 99);
                            
                            // 타입이 다르면 타입 순서로 정렬
                            if (typeOrder1 != typeOrder2) {
                                return Integer.compare(typeOrder1, typeOrder2);
                            }
                            
                            // 타입이 같으면 등록 시간 순서로 정렬
                            if (m1.getMealRegdate() == null) return 1;
                            if (m2.getMealRegdate() == null) return -1;
                            return m1.getMealRegdate().compareTo(m2.getMealRegdate());
                        });
                        model.addAttribute("todayMeals", todayMeals);
                        log.info("오늘의 식단 조회 성공 - recId: {}, 개수: {}", selectedRecipient.getRecId(), todayMeals.size());
                    } catch (Exception e) {
                        log.warn("오늘의 식단 조회 실패", e);
                    }
                    
                    // 지도 장소 조회
                    try {
                        List<MapLocation> maps = mapService.getByRecId(selectedRecipient.getRecId());
                        model.addAttribute("maps", maps);
                        log.info("지도 장소 조회 성공 - recId: {}, 개수: {}", selectedRecipient.getRecId(), maps.size());
                    } catch (Exception e) {
                        log.warn("지도 장소 조회 실패 - recId: {}", selectedRecipient.getRecId());
                    }

                    // 선택된 돌봄 대상자에게 배정된 요양사 정보 조회
                    try {
                        Caregiver assignedCaregiver = careMatchingService.getMatchedCaregiverByRecId(selectedRecipient.getRecId());
                        model.addAttribute("assignedCaregiver", assignedCaregiver);
                        if (assignedCaregiver != null) {
                            log.info("배정된 요양사 조회 성공: {} (recId: {})", assignedCaregiver.getCaregiverName(), selectedRecipient.getRecId());
                        } else {
                            log.info("배정된 요양사 없음 (recId: {})", selectedRecipient.getRecId());
                        }
                    } catch (Exception e) {
                        log.error("배정된 요양사 조회 중 오류", e);
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
                       @RequestParam(value = "center", required = false) String center,
                       @RequestParam(value = "recId", required = false) Integer recId) {
        Cust loginUser = (Cust) session.getAttribute("loginUser");

        if (loginUser == null) {
            log.warn("로그인하지 않은 사용자가 /home 접근 시도");
            return "redirect:/login";
        }

        // ==========================================
        // [수정 포인트 1] 대상자 선택 로직을 if(center==null) 밖으로 꺼냄 (모든 페이지 공통 적용)
        // ==========================================
        Recipient selectedRecipient = null;
        try {
            List<Recipient> recipients = recipientService.getRecipientsByCustId(loginUser.getCustId());
            if (recipients == null || recipients.isEmpty()) {
                log.info("등록된 노약자가 없음 - 등록 유도 페이지로 이동");
                return "redirect:/recipient/prompt";
            }

            // 1. recId 파라미터가 있으면 해당 노약자 사용
            if (recId != null && recId > 0) {
                selectedRecipient = recipientService.getRecipientById(recId);
                // 해당 노약자가 현재 사용자의 노약자인지 확인
                if (selectedRecipient != null && selectedRecipient.getCustId().equals(loginUser.getCustId())) {
                    session.setAttribute("selectedRecipient", selectedRecipient);
                    log.info("노약자 선택됨 - recId: {}, recName: {}", selectedRecipient.getRecId(), selectedRecipient.getRecName());
                } else {
                    selectedRecipient = null;
                }
            }

            // 2. 세션에 저장된 노약자가 있으면 사용 (항상 DB 최신 정보 갱신)
            if (selectedRecipient == null) {
                Recipient sessionRecipient = (Recipient) session.getAttribute("selectedRecipient");
                if (sessionRecipient != null && sessionRecipient.getCustId().equals(loginUser.getCustId())) {
                    selectedRecipient = recipientService.getRecipientById(sessionRecipient.getRecId());
                    if (selectedRecipient != null) {
                        session.setAttribute("selectedRecipient", selectedRecipient);
                    }
                }
            }

            // 3. 세션에도 없으면 첫 번째 노약자 사용
            if (selectedRecipient == null && !recipients.isEmpty()) {
                selectedRecipient = recipients.get(0);
                session.setAttribute("selectedRecipient", selectedRecipient);
            }

            // [중요] 선택된 대상자 정보 모델에 담기
            if (selectedRecipient != null) {
                model.addAttribute("recipient", selectedRecipient);

                // ==========================================
                // [수정 포인트 2] 요양사 조회 로직도 밖으로 꺼냄 (메뉴 이동 시에도 보여야 하므로)
                // ==========================================
                try {
                    Caregiver assignedCaregiver = careMatchingService.getMatchedCaregiverByRecId(selectedRecipient.getRecId());
                    model.addAttribute("assignedCaregiver", assignedCaregiver);
                    if (assignedCaregiver != null) {
                        log.info("배정된 요양사 조회 성공: {} (recId: {})", assignedCaregiver.getCaregiverName(), selectedRecipient.getRecId());
                    } else {
                        log.info("배정된 요양사 없음 (recId: {})", selectedRecipient.getRecId());
                    }
                } catch (Exception e) {
                    log.error("배정된 요양사 조회 중 오류", e);
                }
                
                // center.jsp에서 사용하는 courses와 maps는 항상 초기화 (빈 리스트라도)
                // center가 null이 아닐 때도 center.jsp가 로드될 수 있으므로
                if (!model.containsAttribute("courses")) {
                    try {
                        List<MapCourse> courses = mapCourseService.getCoursesByRecId(selectedRecipient.getRecId());
                        model.addAttribute("courses", courses != null ? courses : new java.util.ArrayList<>());
                    } catch (Exception e) {
                        log.warn("산책코스 조회 실패 (빈 리스트로 초기화)", e);
                        model.addAttribute("courses", new java.util.ArrayList<>());
                    }
                }
                if (!model.containsAttribute("maps")) {
                    try {
                        List<MapLocation> maps = mapService.getByRecId(selectedRecipient.getRecId());
                        model.addAttribute("maps", maps != null ? maps : new java.util.ArrayList<>());
                    } catch (Exception e) {
                        log.warn("지도 장소 조회 실패 (빈 리스트로 초기화)", e);
                        model.addAttribute("maps", new java.util.ArrayList<>());
                    }
                }
            }
        } catch (Exception e) {
            log.error("노약자 조회 중 오류", e);
        }

        // ==========================================
        // [원래 코드 유지] 메인 대시보드(center == null)일 때만 무거운 데이터(차트, 일정 등) 조회
        // ==========================================
        if (center == null && selectedRecipient != null) {
            // 최신 혈압 데이터 조회
            try {
                HealthData latestBloodPressure = healthDataService.getLatestHealthDataByType(
                        selectedRecipient.getRecId(), "혈압");
                model.addAttribute("bloodPressure", latestBloodPressure);
            } catch (Exception e) {
                log.warn("혈압 데이터 조회 실패");
            }

            // 현재 월의 일정 조회
            try {
                LocalDate now = LocalDate.now();
                List<Schedule> schedules = scheduleService.getSchedulesByMonth(
                        selectedRecipient.getRecId(), now.getYear(), now.getMonthValue());
                model.addAttribute("schedules", schedules);
            } catch (Exception e) {
                log.warn("일정 조회 실패");
            }

            // 오늘의 일정 조회 (복잡한 로직 그대로 복구)
            try {
                LocalDate today = LocalDate.now();
                List<Schedule> todaySchedules = scheduleService.getSchedulesByDateRange(
                        selectedRecipient.getRecId(), today, today);
                model.addAttribute("todaySchedules", todaySchedules);

                // 오늘의 HourlySchedule 조회 및 정렬
                List<HourlySchedule> todayHourlySchedules = new java.util.ArrayList<>();
                for (Schedule schedule : todaySchedules) {
                    List<HourlySchedule> hourlySchedules = scheduleService.getHourlySchedulesBySchedId(schedule.getSchedId());
                    todayHourlySchedules.addAll(hourlySchedules);
                }
                // 시작 시간으로 정렬
                todayHourlySchedules.sort((h1, h2) -> {
                    if (h1.getHourlySchedStartTime() == null) return 1;
                    if (h2.getHourlySchedStartTime() == null) return -1;
                    return h1.getHourlySchedStartTime().compareTo(h2.getHourlySchedStartTime());
                });
                model.addAttribute("todayHourlySchedules", todayHourlySchedules);
            } catch (Exception e) {
                log.warn("오늘의 일정 조회 실패", e);
            }

            // 오늘의 식단 조회 (복잡한 정렬 로직 그대로 복구)
            try {
                LocalDate today = LocalDate.now();
                List<MealPlan> todayMeals = mealPlanService.getByRecIdAndDate(
                        selectedRecipient.getRecId(), today);
                // 식단 정렬: 타입 순서(아침->점심->저녁) -> 등록 시간 순서
                todayMeals.sort((m1, m2) -> {
                    // 타입 순서 정의
                    java.util.Map<String, Integer> typeOrder = new java.util.HashMap<>();
                    typeOrder.put("아침", 1);
                    typeOrder.put("점심", 2);
                    typeOrder.put("저녁", 3);

                    int typeOrder1 = typeOrder.getOrDefault(m1.getMealType(), 99);
                    int typeOrder2 = typeOrder.getOrDefault(m2.getMealType(), 99);

                    // 타입이 다르면 타입 순서로 정렬
                    if (typeOrder1 != typeOrder2) {
                        return Integer.compare(typeOrder1, typeOrder2);
                    }

                    // 타입이 같으면 등록 시간 순서로 정렬
                    if (m1.getMealRegdate() == null) return 1;
                    if (m2.getMealRegdate() == null) return -1;
                    return m1.getMealRegdate().compareTo(m2.getMealRegdate());
                });
                model.addAttribute("todayMeals", todayMeals);
            } catch (Exception e) {
                log.warn("오늘의 식단 조회 실패", e);
            }

            // 지도 장소 조회
            try {
                List<MapLocation> maps = mapService.getByRecId(selectedRecipient.getRecId());
                model.addAttribute("maps", maps);
            } catch (Exception e) {
                log.warn("지도 장소 조회 실패", e);
            }

            // 산책코스 조회
            try {
                List<MapCourse> courses = mapCourseService.getCoursesByRecId(selectedRecipient.getRecId());
                model.addAttribute("courses", courses);
            } catch (Exception e) {
                log.warn("산책코스 조회 실패", e);
            }
        }

        model.addAttribute("loginUser", loginUser);
        model.addAttribute("center", center);

        log.info("center 페이지 요청: {}", center == null ? "기본 페이지" : center);

        return "home";
    }

    @GetMapping("/caregiver")
    public String caregiver() {
        return "redirect:/home?center=caregiver/my_caregiver";
    }
}
