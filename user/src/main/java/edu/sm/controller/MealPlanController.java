package edu.sm.controller;

import edu.sm.app.dto.Cust;
import edu.sm.app.dto.MealPlan;
import edu.sm.app.dto.Recipient;
import edu.sm.app.service.MealPlanService;
import edu.sm.app.service.RecipientService;
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
}

