package edu.sm.controller;

import edu.sm.app.aiservice.AiImageService;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.Map;

@Controller
@RequestMapping("/cctv")
@Slf4j
@RequiredArgsConstructor
public class CCTVController {

    private final AiImageService aiImageService;
    String dir = "cctv/";

    @RequestMapping("")
    public String main(Model model, HttpSession session) {
        model.addAttribute("center", dir + "center");
        model.addAttribute("left", dir + "left");
        return "home";
    }


    @ResponseBody
    @PostMapping("/analyze")
    public Map<String, String> analyzeFrame(
            @RequestParam(value = "attach") MultipartFile attach) throws IOException {

        if (attach == null || !attach.getContentType().contains("image/")) {
            return Map.of("activity", "이미지 없음", "alert", "없음");
        }

        String prompt = """
                Analyze the attached image for any potential dangers to the person in it.
                Look for signs of falls, medical emergencies, fire, intruders, or other hazards.
                Your response MUST start with one of two keywords: 'DANGER' or 'SAFE'.
                If danger is detected, briefly describe the danger after the keyword.
                Example for danger: 'DANGER: The person appears to have fallen.'
                Example for safe: 'SAFE: The person is sitting on a chair and appears to be fine.'
                """;
        String analysisResult = aiImageService.imageAnalysis2(prompt, attach.getContentType(), attach.getBytes());
        log.info("AI Response: {}", analysisResult);

        String activity = "상태 분석 중...";
        String alert = "없음";

        if (analysisResult != null) {
            analysisResult = analysisResult.trim();
            if (analysisResult.startsWith("DANGER")) {
                activity = "위험 감지!";
                alert = analysisResult; // 'DANGER: The person appears to have fallen.'
            } else if (analysisResult.startsWith("SAFE")) {
                activity = "안전 상태";
                // 'SAFE: ...' 에서 'SAFE: ' 부분을 제거하고 설명만 남김
                alert = "없음";
                activity = analysisResult.substring(5).trim();
            } else {
                activity = "분석 결과 불명확";
                alert = "없음";
            }
        } else {
            activity = "AI 서버 응답 없음";
            alert = "없음";
        }

        return Map.of("activity", activity, "alert", alert);
    }
}
