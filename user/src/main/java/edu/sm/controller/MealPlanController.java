package edu.sm.controller;

import edu.sm.app.dto.Cust;
import edu.sm.app.dto.MealPlan;
import edu.sm.app.dto.Recipient;
import edu.sm.app.service.MealPlanService;
import edu.sm.app.service.RecipientService;
import edu.sm.app.service.YouTubeService;
import edu.sm.app.aiservice.AiMealSafetyService;
import edu.sm.app.aiservice.AiMealRecipeService;
import edu.sm.app.aiservice.AiCaloriesAnalysisService;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 식단 관리 컨트롤러
 * 노약자의 식단 등록, 조회, 수정, 삭제 기능 제공
 */
@Controller
@Slf4j
@RequestMapping("/mealplan")
@RequiredArgsConstructor
public class MealPlanController {

    private final MealPlanService mealPlanService;
    private final RecipientService recipientService;
    private final AiMealSafetyService aiMealSafetyService;
    private final AiMealRecipeService aiMealRecipeService;
    private final AiCaloriesAnalysisService aiCaloriesAnalysisService;
    private final YouTubeService youTubeService;
    private final String dir = "mealplan/";

    /**
     * 식단 관리 메인 페이지
     */
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

                log.info("식단 관리 페이지 접근 - custId: {}, recId: {}, recName: {}",
                        loginUser.getCustId(), selectedRecipient.getRecId(), selectedRecipient.getRecName());

                model.addAttribute("recipientList", recipientList);
                model.addAttribute("selectedRecipient", selectedRecipient);
            }
        } catch (Exception e) {
            log.error("식단 관리 페이지 로드 실패", e);
            model.addAttribute("recipientList", null);
            model.addAttribute("selectedRecipient", null);
        }

        model.addAttribute("center", dir + "center");
        model.addAttribute("left", dir + "left");
        return "home";
    }

    /**
     * 특정 날짜의 식단 조회 (API)
     */
    @GetMapping("/api/date")
    @ResponseBody
    public ResponseEntity<?> getMealsByDate(
            @RequestParam(required = false) Integer recId,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate mealDate) {

        if (recId == null || mealDate == null) {
            return ResponseEntity.badRequest().body(
                    Map.of("success", false, "message", "recId와 mealDate는 필수입니다.")
            );
        }

        try {
            List<MealPlan> meals = mealPlanService.getByRecIdAndDate(recId, mealDate);
            log.info("날짜별 식단 조회 - recId: {}, date: {}, 개수: {}", recId, mealDate, meals.size());
            return ResponseEntity.ok(meals);
        } catch (Exception e) {
            log.error("날짜별 식단 조회 실패 - recId: {}, date: {}", recId, mealDate, e);
            return ResponseEntity.badRequest().body(
                    Map.of("success", false, "message", "식단 조회 실패: " + e.getMessage())
            );
        }
    }

    /**
     * 특정 기간의 식단 조회 (API)
     */
    @GetMapping("/api/range")
    @ResponseBody
    public ResponseEntity<?> getMealsByDateRange(
            @RequestParam(required = false) Integer recId,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate startDate,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate endDate) {

        if (recId == null || startDate == null || endDate == null) {
            return ResponseEntity.badRequest().body(
                    Map.of("success", false, "message", "recId, startDate, endDate는 필수입니다.")
            );
        }

        try {
            List<MealPlan> meals = mealPlanService.getByDateRange(recId, startDate, endDate);
            log.info("기간별 식단 조회 - recId: {}, {} ~ {}, 개수: {}", recId, startDate, endDate, meals.size());
            return ResponseEntity.ok(meals);
        } catch (Exception e) {
            log.error("기간별 식단 조회 실패 - recId: {}", recId, e);
            return ResponseEntity.badRequest().body(
                    Map.of("success", false, "message", "식단 조회 실패: " + e.getMessage())
            );
        }
    }

    /**
     * 특정 날짜의 총 칼로리 조회 (API)
     */
    @GetMapping("/api/calories")
    @ResponseBody
    public ResponseEntity<?> getTotalCalories(
            @RequestParam(required = false) Integer recId,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate mealDate) {

        if (recId == null || mealDate == null) {
            return ResponseEntity.badRequest().body(
                    Map.of("success", false, "message", "recId와 mealDate는 필수입니다.")
            );
        }

        try {
            Integer totalCalories = mealPlanService.getTotalCaloriesByDate(recId, mealDate);
            log.info("일일 총 칼로리 조회 - recId: {}, date: {}, 칼로리: {}", recId, mealDate, totalCalories);
            return ResponseEntity.ok(Map.of("totalCalories", totalCalories));
        } catch (Exception e) {
            log.error("총 칼로리 조회 실패 - recId: {}, date: {}", recId, mealDate, e);
            return ResponseEntity.badRequest().body(
                    Map.of("success", false, "message", "칼로리 조회 실패: " + e.getMessage())
            );
        }
    }

    /**
     * 식단 등록 (API)
     */
    @PostMapping("/api/meal")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> createMeal(@RequestBody MealPlan mealPlan) {
        Map<String, Object> result = new HashMap<>();
        try {
            log.info("식단 등록 - recId: {}, date: {}, type: {}, menu: {}",
                    mealPlan.getRecId(), mealPlan.getMealDate(), mealPlan.getMealType(), mealPlan.getMealMenu());

            mealPlanService.register(mealPlan);

            result.put("success", true);
            result.put("meal", mealPlan);
            result.put("message", "식단이 등록되었습니다.");

            return ResponseEntity.ok(result);
        } catch (Exception e) {
            log.error("식단 등록 실패", e);
            result.put("success", false);
            result.put("message", "식단 등록 실패: " + e.getMessage());
            return ResponseEntity.badRequest().body(result);
        }
    }

    /**
     * 식단 수정 (API)
     */
    @PutMapping("/api/meal")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> updateMeal(@RequestBody MealPlan mealPlan) {
        Map<String, Object> result = new HashMap<>();
        try {
            log.info("식단 수정 - mealId: {}, menu: {}", mealPlan.getMealId(), mealPlan.getMealMenu());

            mealPlanService.modify(mealPlan);

            result.put("success", true);
            result.put("meal", mealPlan);
            result.put("message", "식단이 수정되었습니다.");

            return ResponseEntity.ok(result);
        } catch (Exception e) {
            log.error("식단 수정 실패 - mealId: {}", mealPlan.getMealId(), e);
            result.put("success", false);
            result.put("message", "식단 수정 실패: " + e.getMessage());
            return ResponseEntity.badRequest().body(result);
        }
    }

    /**
     * 식단 삭제 (API)
     */
    @DeleteMapping("/api/meal/{mealId}")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> deleteMeal(@PathVariable Integer mealId) {
        Map<String, Object> result = new HashMap<>();
        try {
            mealPlanService.remove(mealId);
            result.put("success", true);
            result.put("message", "식단이 삭제되었습니다.");

            log.info("식단 삭제 완료 - mealId: {}", mealId);
            return ResponseEntity.ok(result);
        } catch (Exception e) {
            log.error("식단 삭제 실패 - mealId: {}", mealId, e);
            result.put("success", false);
            result.put("message", "식단 삭제 실패: " + e.getMessage());
            return ResponseEntity.badRequest().body(result);
        }
    }

    /**
     * 특정 식단 조회 (API)
     */
    @GetMapping("/api/meal/{mealId}")
    @ResponseBody
    public ResponseEntity<?> getMeal(@PathVariable Integer mealId) {
        try {
            MealPlan meal = mealPlanService.get(mealId);
            if (meal == null) {
                return ResponseEntity.badRequest().body(
                        Map.of("success", false, "message", "식단을 찾을 수 없습니다.")
                );
            }
            return ResponseEntity.ok(meal);
        } catch (Exception e) {
            log.error("식단 조회 실패 - mealId: {}", mealId, e);
            return ResponseEntity.badRequest().body(
                    Map.of("success", false, "message", "식단 조회 실패: " + e.getMessage())
            );
        }
    }

    /**
     * AI 식단 추천 (API)
     */
    @PostMapping("/api/recommend")
    @ResponseBody
    public ResponseEntity<?> getRecommendedMeal(@RequestBody Map<String, Object> requestBody) {
        try {
            Integer recId = (Integer) requestBody.get("recId");
            String specialNotes = (String) requestBody.get("specialNotes");
            String mealType = (String) requestBody.get("mealType");

            if (recId == null) {
                return ResponseEntity.badRequest().body(
                        Map.of("success", false, "message", "노약자 정보가 필요합니다.")
                );
            }
            if (mealType == null || mealType.isEmpty()) {
                return ResponseEntity.badRequest().body(
                        Map.of("success", false, "message", "식사 종류(아침/점심/저녁) 정보가 필요합니다.")
                );
            }

            Map<String, Object> data = mealPlanService.getAiRecommendedMeal(recId, specialNotes, mealType);
            return ResponseEntity.ok(Map.of("success", true, "data", data));
        } catch (Exception e) {
            log.error("AI 식단 추천 실패", e);
            return ResponseEntity.status(500).body(
                    Map.of("success", false, "message", "AI 식단 추천 중 오류가 발생했습니다: " + e.getMessage())
            );
        }
    }

    /**
     * AI 식단 안전성 검사 페이지
     */
    @GetMapping("/ai-check")
    public String aiCheckPage(Model model, HttpSession session,
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

                model.addAttribute("recipientList", recipientList);
                model.addAttribute("selectedRecipient", selectedRecipient);
            }
        } catch (Exception e) {
            log.error("AI 식단 안전성 검사 페이지 로드 실패", e);
            model.addAttribute("recipientList", null);
            model.addAttribute("selectedRecipient", null);
        }

        model.addAttribute("center", dir + "ai-check");
        model.addAttribute("left", dir + "left");
        return "home";
    }

    /**
     * AI 식단 안전성 검사 (API) - 이미지 분석
     */
    @PostMapping("/api/ai-check")
    @ResponseBody
    public ResponseEntity<?> checkMealSafety(@RequestBody Map<String, Object> requestBody) {
        try {
            Integer recId = (Integer) requestBody.get("recId");
            String imageBase64 = (String) requestBody.get("imageBase64");
            String mealDescription = (String) requestBody.get("mealDescription");

            if (recId == null) {
                return ResponseEntity.badRequest().body(
                        Map.of("success", false, "message", "노약자 정보가 필요합니다.")
                );
            }

            Map<String, Object> result = aiMealSafetyService.checkMealSafety(recId, imageBase64, mealDescription);
            return ResponseEntity.ok(result);
        } catch (Exception e) {
            log.error("AI 식단 안전성 검사 실패", e);
            return ResponseEntity.status(500).body(
                    Map.of("success", false, "message", "AI 식단 안전성 검사 중 오류가 발생했습니다: " + e.getMessage())
            );
        }
    }

    /**
     * AI 식단 메뉴 페이지 (레시피 + 안전성 검사)
     */
    @GetMapping("/ai-menu")
    public String aiMenuPage(Model model, HttpSession session,
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

                model.addAttribute("recipientList", recipientList);
                model.addAttribute("selectedRecipient", selectedRecipient);
            }
        } catch (Exception e) {
            log.error("AI 식단 메뉴 페이지 로드 실패", e);
            model.addAttribute("recipientList", null);
            model.addAttribute("selectedRecipient", null);
        }

        model.addAttribute("center", dir + "ai-menu");
        model.addAttribute("left", dir + "left");
        return "home";
    }

    /**
     * AI 식단 메뉴 분석 (레시피 + 안전성 검사) (API)
     */
    @PostMapping("/api/ai-menu")
    @ResponseBody
    public ResponseEntity<?> analyzeMealMenu(@RequestBody Map<String, Object> requestBody) {
        try {
            Integer recId = (Integer) requestBody.get("recId");
            String imageBase64 = (String) requestBody.get("imageBase64");
            String mealDescription = (String) requestBody.get("mealDescription");

            if (recId == null) {
                return ResponseEntity.badRequest().body(
                        Map.of("success", false, "message", "노약자 정보가 필요합니다.")
                );
            }

            // 이미지 또는 음식 설명 중 하나는 필수
            boolean hasImage = imageBase64 != null && !imageBase64.trim().isEmpty();
            boolean hasDescription = mealDescription != null && !mealDescription.trim().isEmpty();

            if (!hasImage && !hasDescription) {
                return ResponseEntity.badRequest().body(
                        Map.of("success", false, "message", "이미지 또는 음식 이름이 필요합니다.")
                );
            }

            log.info("AI 식단 메뉴 분석 시작 - recId: {}, 이미지: {}, 텍스트: {}", 
                    recId, hasImage, hasDescription);

            Map<String, Object> recipeResult;
            Map<String, Object> safetyResult;

            // 레시피 생성
            if (hasImage) {
                // 이미지 기반 레시피 생성
                recipeResult = aiMealRecipeService.getRecipeFromImage(imageBase64);
                log.info("레시피 생성 결과 (이미지) - success: {}", recipeResult.get("success"));
            } else {
                // 텍스트 기반 레시피 생성
                recipeResult = aiMealRecipeService.getRecipeFromText(mealDescription);
                log.info("레시피 생성 결과 (텍스트) - success: {}", recipeResult.get("success"));
            }
            
            // 안전성 검사 (이미지가 있으면 이미지 사용, 없으면 텍스트 사용)
            safetyResult = aiMealSafetyService.checkMealSafety(recId, imageBase64, mealDescription);
            log.info("안전성 검사 결과 - success: {}", safetyResult.get("success"));

            // 결과 통합
            Map<String, Object> result = new HashMap<>();
            result.put("success", true);
            result.put("recipe", recipeResult);
            result.put("safety", safetyResult);

            log.info("AI 식단 메뉴 분석 완료 - 레시피 성공: {}, 안전성 성공: {}", 
                    recipeResult.get("success"), safetyResult.get("success"));
            
            return ResponseEntity.ok(result);
        } catch (Exception e) {
            log.error("AI 식단 메뉴 분석 실패", e);
            return ResponseEntity.status(500).body(
                    Map.of("success", false, "message", "분석 중 오류가 발생했습니다: " + e.getMessage())
            );
        }
    }

    /**
     * 칼로리 분석 페이지
     */
    @GetMapping("/calories-analysis")
    public String caloriesAnalysisPage(Model model, HttpSession session,
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

                model.addAttribute("recipientList", recipientList);
                model.addAttribute("selectedRecipient", selectedRecipient);
            }
        } catch (Exception e) {
            log.error("칼로리 분석 페이지 로드 실패", e);
            model.addAttribute("recipientList", null);
            model.addAttribute("selectedRecipient", null);
        }

        model.addAttribute("center", dir + "calories-analysis");
        model.addAttribute("left", dir + "left");
        return "home";
    }

    /**
     * 칼로리 통계 조회 (API)
     */
    @GetMapping("/api/calories-stats")
    @ResponseBody
    public ResponseEntity<?> getCaloriesStats(
            @RequestParam(required = false) Integer recId) {
        
        if (recId == null) {
            return ResponseEntity.badRequest().body(
                    Map.of("success", false, "message", "recId는 필수입니다.")
            );
        }

        try {
            Integer todayCalories = mealPlanService.getTodayTotalCalories(recId);
            Integer weekCalories = mealPlanService.getThisWeekTotalCalories(recId);
            Integer monthCalories = mealPlanService.getThisMonthTotalCalories(recId);

            Map<String, Object> result = new HashMap<>();
            result.put("success", true);
            result.put("todayCalories", todayCalories);
            result.put("weekCalories", weekCalories);
            result.put("monthCalories", monthCalories);

            log.info("칼로리 통계 조회 - recId: {}, 오늘: {}, 이번주: {}, 이번달: {}", 
                    recId, todayCalories, weekCalories, monthCalories);
            
            return ResponseEntity.ok(result);
        } catch (Exception e) {
            log.error("칼로리 통계 조회 실패 - recId: {}", recId, e);
            return ResponseEntity.badRequest().body(
                    Map.of("success", false, "message", "칼로리 통계 조회 실패: " + e.getMessage())
            );
        }
    }

    /**
     * 칼로리 차트 데이터 조회 (API)
     */
    @GetMapping("/api/calories-chart")
    @ResponseBody
    public ResponseEntity<?> getCaloriesChartData(
            @RequestParam(required = false) Integer recId,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate startDate,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate endDate) {
        
        if (recId == null) {
            return ResponseEntity.badRequest().body(
                    Map.of("success", false, "message", "recId는 필수입니다.")
            );
        }

        try {
            // 기본값: 최근 30일
            if (startDate == null) {
                startDate = LocalDate.now().minusDays(29);
            }
            if (endDate == null) {
                endDate = LocalDate.now();
            }

            // 오늘 하루만 조회하는 경우 식사별 데이터 반환
            LocalDate today = LocalDate.now();
            if (startDate.equals(today) && endDate.equals(today)) {
                List<MealPlan> todayMeals = mealPlanService.getByRecIdAndDate(recId, today);
                
                // 식사별 칼로리 데이터 구성
                Map<String, Integer> mealTypeCalories = new HashMap<>();
                mealTypeCalories.put("아침", 0);
                mealTypeCalories.put("점심", 0);
                mealTypeCalories.put("저녁", 0);
                
                for (MealPlan meal : todayMeals) {
                    String mealType = meal.getMealType();
                    Integer calories = meal.getMealCalories() != null ? meal.getMealCalories() : 0;
                    mealTypeCalories.put(mealType, mealTypeCalories.getOrDefault(mealType, 0) + calories);
                }
                
                List<String> labels = new ArrayList<>();
                List<Integer> data = new ArrayList<>();
                
                // 아침, 점심, 저녁 순서로 정렬
                String[] mealTypes = {"아침", "점심", "저녁"};
                for (String mealType : mealTypes) {
                    labels.add(mealType);
                    data.add(mealTypeCalories.get(mealType));
                }
                
                Map<String, Object> result = new HashMap<>();
                result.put("success", true);
                result.put("labels", labels);
                result.put("data", data);
                result.put("isMealType", true); // 식사별 데이터임을 표시
                
                log.info("오늘 식사별 칼로리 차트 데이터 조회 - recId: {}, 데이터 수: {}", recId, labels.size());
                return ResponseEntity.ok(result);
            }

            // 기간별 일별 데이터 조회
            List<Map<String, Object>> chartData = mealPlanService.getDailyCaloriesForChart(recId, startDate, endDate);
            
            // 차트에 필요한 형식으로 변환
            List<String> labels = new ArrayList<>();
            List<Integer> data = new ArrayList<>();
            
            for (Map<String, Object> item : chartData) {
                // mealDate는 문자열로 반환되므로 직접 파싱
                String mealDateStr = item.get("mealDate").toString();
                LocalDate date = LocalDate.parse(mealDateStr);
                Integer calories = ((Number) item.get("totalCalories")).intValue();
                labels.add(date.toString());
                data.add(calories);
            }

            Map<String, Object> result = new HashMap<>();
            result.put("success", true);
            result.put("labels", labels);
            result.put("data", data);
            result.put("isMealType", false); // 일별 데이터임을 표시

            log.info("칼로리 차트 데이터 조회 - recId: {}, 기간: {} ~ {}, 데이터 수: {}", 
                    recId, startDate, endDate, chartData.size());
            
            return ResponseEntity.ok(result);
        } catch (Exception e) {
            log.error("칼로리 차트 데이터 조회 실패 - recId: {}", recId, e);
            return ResponseEntity.badRequest().body(
                    Map.of("success", false, "message", "차트 데이터 조회 실패: " + e.getMessage())
            );
        }
    }

    /**
     * AI 칼로리 분석 (API)
     */
    @PostMapping("/api/calories-analysis")
    @ResponseBody
    public ResponseEntity<?> analyzeCalories(@RequestBody Map<String, Object> requestBody) {
        try {
            // recId 파싱 (다양한 타입 지원)
            Integer recId = null;
            Object recIdObj = requestBody.get("recId");
            if (recIdObj != null) {
                if (recIdObj instanceof Integer) {
                    recId = (Integer) recIdObj;
                } else if (recIdObj instanceof Number) {
                    recId = ((Number) recIdObj).intValue();
                } else if (recIdObj instanceof String) {
                    try {
                        recId = Integer.parseInt((String) recIdObj);
                    } catch (NumberFormatException e) {
                        log.warn("recId 파싱 실패: {}", recIdObj);
                    }
                }
            }
            
            if (recId == null) {
                return ResponseEntity.badRequest().body(
                        Map.of("success", false, "message", "recId는 필수입니다.")
                );
            }
            
            // 노약자 정보 조회
            Recipient recipient = recipientService.getRecipientById(recId);
            if (recipient == null) {
                return ResponseEntity.badRequest().body(
                        Map.of("success", false, "message", "노약자 정보를 찾을 수 없습니다.")
                );
            }
            
            // 오늘 칼로리
            Integer todayCalories = 0;
            try {
                todayCalories = mealPlanService.getTodayTotalCalories(recId);
                if (todayCalories == null) {
                    todayCalories = 0;
                }
            } catch (Exception e) {
                log.warn("오늘 칼로리 조회 실패 - recId: {}", recId, e);
                todayCalories = 0;
            }
            
            // 최근 7일 평균 칼로리 계산
            LocalDate today = LocalDate.now();
            LocalDate weekStart = today.minusDays(6);
            List<Map<String, Object>> weekDailyCalories = new ArrayList<>();
            try {
                weekDailyCalories = mealPlanService.getDailyCaloriesForChart(recId, weekStart, today);
                if (weekDailyCalories == null) {
                    weekDailyCalories = new ArrayList<>();
                }
            } catch (Exception e) {
                log.warn("최근 7일 칼로리 데이터 조회 실패 - recId: {}", recId, e);
                weekDailyCalories = new ArrayList<>();
            }
            
            int weekTotal = 0;
            int weekDays = weekDailyCalories.size();
            for (Map<String, Object> dailyData : weekDailyCalories) {
                if (dailyData != null && dailyData.get("totalCalories") != null) {
                    try {
                        Integer calories = ((Number) dailyData.get("totalCalories")).intValue();
                        weekTotal += calories;
                    } catch (Exception e) {
                        log.warn("칼로리 데이터 파싱 실패: {}", dailyData.get("totalCalories"), e);
                    }
                }
            }
            Integer weekAvgCalories = weekDays > 0 ? weekTotal / weekDays : 0;
            
            // 최근 30일 평균 칼로리 계산
            LocalDate monthStart = today.minusDays(29);
            List<Map<String, Object>> monthDailyCalories = new ArrayList<>();
            try {
                monthDailyCalories = mealPlanService.getDailyCaloriesForChart(recId, monthStart, today);
                if (monthDailyCalories == null) {
                    monthDailyCalories = new ArrayList<>();
                }
            } catch (Exception e) {
                log.warn("최근 30일 칼로리 데이터 조회 실패 - recId: {}", recId, e);
                monthDailyCalories = new ArrayList<>();
            }
            
            int monthTotal = 0;
            int monthDays = monthDailyCalories.size();
            for (Map<String, Object> dailyData : monthDailyCalories) {
                if (dailyData != null && dailyData.get("totalCalories") != null) {
                    try {
                        Integer calories = ((Number) dailyData.get("totalCalories")).intValue();
                        monthTotal += calories;
                    } catch (Exception e) {
                        log.warn("칼로리 데이터 파싱 실패: {}", dailyData.get("totalCalories"), e);
                    }
                }
            }
            Integer monthAvgCalories = monthDays > 0 ? monthTotal / monthDays : 0;
            
            // 최근 일별 칼로리 데이터 조회 (차트용)
            List<Map<String, Object>> recentCaloriesData = new ArrayList<>();
            try {
                recentCaloriesData = mealPlanService.getDailyCaloriesForChart(recId, monthStart, today);
                if (recentCaloriesData == null) {
                    recentCaloriesData = new ArrayList<>();
                }
            } catch (Exception e) {
                log.warn("최근 칼로리 데이터 조회 실패 - recId: {}", recId, e);
                recentCaloriesData = new ArrayList<>();
            }
            
            // AI 분석 수행
            Map<String, Object> analysisResult = aiCaloriesAnalysisService.analyzeCalories(
                    recipient,
                    todayCalories,
                    weekAvgCalories,
                    monthAvgCalories,
                    recentCaloriesData
            );
            
            log.info("AI 칼로리 분석 완료 - recId: {}, 성공: {}", recId, analysisResult.get("success"));
            
            return ResponseEntity.ok(analysisResult);
            
        } catch (Exception e) {
            log.error("AI 칼로리 분석 실패", e);
            return ResponseEntity.status(500).body(
                    Map.of("success", false, "message", "칼로리 분석 중 오류가 발생했습니다: " + e.getMessage())
            );
        }
    }

    /**
     * YouTube 영상 검색 (API)
     */
    @GetMapping("/api/youtube-search")
    @ResponseBody
    public ResponseEntity<?> searchYouTubeVideo(@RequestParam(required = false) String foodName) {
        try {
            if (foodName == null || foodName.trim().isEmpty()) {
                return ResponseEntity.badRequest().body(
                        Map.of("success", false, "message", "음식명은 필수입니다.")
                );
            }
            
            Map<String, Object> result = youTubeService.searchVideo(foodName.trim());
            
            log.info("YouTube 영상 검색 - 음식명: {}, 성공: {}", foodName, result.get("success"));
            
            return ResponseEntity.ok(result);
            
        } catch (Exception e) {
            log.error("YouTube 영상 검색 실패 - 음식명: {}", foodName, e);
            return ResponseEntity.status(500).body(
                    Map.of("success", false, "message", "YouTube 영상 검색 중 오류가 발생했습니다: " + e.getMessage())
            );
        }
    }
}

