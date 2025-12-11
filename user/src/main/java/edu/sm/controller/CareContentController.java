package edu.sm.controller;

import edu.sm.app.aiservice.AiCareContentService;
import edu.sm.app.dto.Cust;
import edu.sm.app.dto.Recipient;
import edu.sm.app.service.NaverSearchService;
import edu.sm.app.service.RecipientService;
import edu.sm.app.service.YouTubeService;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

/**
 * 돌봄 콘텐츠 컨트롤러
 * 돌봄대상자 맞춤형 돌봄 영상 및 정보 추천 기능 제공
 */
@Controller
@Slf4j
@RequestMapping("/care")
@RequiredArgsConstructor
public class CareContentController {

    private final RecipientService recipientService;
    private final AiCareContentService aiCareContentService;
    private final YouTubeService youTubeService;
    private final NaverSearchService naverSearchService;
    private final String dir = "care/";

    /**
     * 돌봄 콘텐츠 메인 페이지
     */
    @GetMapping("")
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

                log.info("돌봄 콘텐츠 페이지 접근 - custId: {}, recId: {}",
                        loginUser.getCustId(), selectedRecipient.getRecId());

                model.addAttribute("recipientList", recipientList);
                model.addAttribute("selectedRecipient", selectedRecipient);
            }
        } catch (Exception e) {
            log.error("돌봄 콘텐츠 페이지 로드 실패", e);
            model.addAttribute("recipientList", null);
            model.addAttribute("selectedRecipient", null);
        }

        model.addAttribute("center", dir + "content");
        model.addAttribute("left", dir + "left");
        return "home";
    }

    /**
     * AI 돌봄 콘텐츠 분석 및 추천 (API)
     */
    @PostMapping("/api/analyze")
    @ResponseBody
    public ResponseEntity<?> analyzeContent(@RequestBody Map<String, Object> requestBody) {
        try {
            Integer recId = null;
            Object recIdObj = requestBody.get("recId");
            if (recIdObj instanceof Integer) {
                recId = (Integer) recIdObj;
            } else if (recIdObj instanceof String) {
                recId = Integer.parseInt((String) recIdObj);
            }

            if (recId == null) {
                return ResponseEntity.badRequest().body(
                        Map.of("success", false, "message", "돌봄대상자 정보가 필요합니다.")
                );
            }

            Recipient recipient = recipientService.getRecipientById(recId);
            if (recipient == null) {
                return ResponseEntity.badRequest().body(
                        Map.of("success", false, "message", "돌봄대상자 정보를 찾을 수 없습니다.")
                );
            }

            // AI 분석 수행
            Map<String, Object> result = aiCareContentService.analyzeAndRecommend(recipient);
            
            return ResponseEntity.ok(result);

        } catch (Exception e) {
            log.error("돌봄 콘텐츠 분석 실패", e);
            return ResponseEntity.status(500).body(
                    Map.of("success", false, "message", "분석 중 오류가 발생했습니다: " + e.getMessage())
            );
        }
    }

    /**
     * 키워드로 YouTube 영상 검색 (API)
     */
    @GetMapping("/api/video-search")
    @ResponseBody
    public ResponseEntity<?> searchVideo(@RequestParam String keyword) {
        try {
            if (keyword == null || keyword.trim().isEmpty()) {
                return ResponseEntity.badRequest().body(
                        Map.of("success", false, "message", "검색어는 필수입니다.")
                );
            }
            
            Map<String, Object> result = youTubeService.searchVideoByQuery(keyword);
            
            return ResponseEntity.ok(result);
            
        } catch (Exception e) {
            log.error("영상 검색 실패", e);
            return ResponseEntity.status(500).body(
                    Map.of("success", false, "message", "영상 검색 중 오류가 발생했습니다: " + e.getMessage())
            );
        }
    }

    /**
     * 키워드로 블로그 검색 (API)
     */
    @GetMapping("/api/blog-search")
    @ResponseBody
    public ResponseEntity<?> searchBlog(@RequestParam String keyword) {
        try {
            if (keyword == null || keyword.trim().isEmpty()) {
                return ResponseEntity.badRequest().body(
                        Map.of("success", false, "message", "검색어는 필수입니다.")
                );
            }
            
            Map<String, Object> result = naverSearchService.searchBlog(keyword);
            
            return ResponseEntity.ok(result);
            
        } catch (Exception e) {
            log.error("블로그 검색 실패", e);
            return ResponseEntity.status(500).body(
                    Map.of("success", false, "message", "블로그 검색 중 오류가 발생했습니다: " + e.getMessage())
            );
        }
    }

    /**
     * 키워드로 뉴스 검색 (API)
     */
    @GetMapping("/api/news-search")
    @ResponseBody
    public ResponseEntity<?> searchNews(@RequestParam String keyword) {
        try {
            if (keyword == null || keyword.trim().isEmpty()) {
                return ResponseEntity.badRequest().body(
                        Map.of("success", false, "message", "검색어는 필수입니다.")
                );
            }
            
            Map<String, Object> result = naverSearchService.searchNews(keyword);
            
            return ResponseEntity.ok(result);
            
        } catch (Exception e) {
            log.error("뉴스 검색 실패", e);
            return ResponseEntity.status(500).body(
                    Map.of("success", false, "message", "뉴스 검색 중 오류가 발생했습니다: " + e.getMessage())
            );
        }
    }

    /**
     * 혜택 정보 AI 요약 (API)
     */
    @PostMapping("/api/summarize-benefit")
    @ResponseBody
    public ResponseEntity<?> summarizeBenefit(@RequestBody Map<String, String> requestBody) {
        try {
            String benefitName = requestBody.get("benefitName");
            String description = requestBody.get("description");
            
            if (benefitName == null || benefitName.trim().isEmpty()) {
                return ResponseEntity.badRequest().body(
                        Map.of("success", false, "message", "혜택명은 필수입니다.")
                );
            }
            
            String summary = aiCareContentService.summarizeBenefit(benefitName, description);
            
            return ResponseEntity.ok(Map.of("success", true, "summary", summary));
            
        } catch (Exception e) {
            log.error("혜택 요약 실패", e);
            return ResponseEntity.status(500).body(
                    Map.of("success", false, "message", "요약 중 오류가 발생했습니다: " + e.getMessage())
            );
        }
    }
}

