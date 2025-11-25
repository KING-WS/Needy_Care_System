package edu.sm.controller;

import edu.sm.app.dto.Cust;
import edu.sm.app.dto.MealPlan;
import edu.sm.app.dto.Recipient;
import edu.sm.app.service.MealPlanService;
import edu.sm.app.service.RecipientService;
import edu.sm.app.aiservice.AiMealSafetyService;
import edu.sm.app.aiservice.AiCalorieAnalysisService;
import edu.sm.app.aiservice.AiMealRecipeService;
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
    private final AiCalorieAnalysisService aiCalorieAnalysisService;
    private final AiMealRecipeService aiMealRecipeService;
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
     * AI 식단 칼로리 통계 페이지
     */
    @GetMapping("/ai-calories")
    public String aiCaloriesPage(Model model, HttpSession session,
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
            log.error("AI 식단 칼로리 통계 페이지 로드 실패", e);
            model.addAttribute("recipientList", null);
            model.addAttribute("selectedRecipient", null);
        }

        model.addAttribute("center", dir + "ai-calories");
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
     * AI 식단 칼로리 분석 (API)
     */
    @GetMapping("/api/ai-calories")
    @ResponseBody
    public ResponseEntity<?> analyzeCalories(
            @RequestParam(required = false) Integer recId,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate startDate,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate endDate) {
        try {
            if (recId == null) {
                return ResponseEntity.badRequest().body(
                        Map.of("success", false, "message", "노약자 정보가 필요합니다.")
                );
            }

            if (startDate == null) {
                startDate = LocalDate.now().minusDays(30); // 기본값: 최근 30일
            }
            if (endDate == null) {
                endDate = LocalDate.now();
            }

            Map<String, Object> result = aiCalorieAnalysisService.analyzeCalories(recId, startDate, endDate);
            return ResponseEntity.ok(result);
        } catch (Exception e) {
            log.error("AI 식단 칼로리 분석 실패", e);
            return ResponseEntity.status(500).body(
                    Map.of("success", false, "message", "AI 식단 칼로리 분석 중 오류가 발생했습니다: " + e.getMessage())
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
}

