package edu.sm.controller;

import edu.sm.app.dto.Recipient;
import edu.sm.app.dto.Cust;
import edu.sm.app.service.RecipientService;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.List;

@Controller
@RequestMapping("/recipient")
@RequiredArgsConstructor
@Slf4j
public class CareRecipientController {

    private final RecipientService recipientService;
    private final String dir = "recipient/";

    /**
     * 노약자 등록 유도 페이지
     */
    @GetMapping("/prompt")
    public String prompt(Model model, HttpSession session) {
        Cust loginUser = (Cust) session.getAttribute("loginUser");
        
        if (loginUser == null) {
            log.warn("비로그인 사용자가 /recipient/prompt 접근 시도");
            return "redirect:/login";
        }
        
        model.addAttribute("loginUser", loginUser);
        model.addAttribute("center", dir + "prompt");
        return "home";
    }

    /**
     * 노약자 등록 페이지
     */
    @GetMapping("/register")
    public String registerForm(Model model, HttpSession session) {
        Cust loginUser = (Cust) session.getAttribute("loginUser");
        
        if (loginUser == null) {
            log.warn("비로그인 사용자가 /recipient/register 접근 시도");
            return "redirect:/login";
        }
        
        model.addAttribute("loginUser", loginUser);
        model.addAttribute("center", dir + "register");
        return "home";
    }

    /**
     * 노약자 등록 처리
     */
    @PostMapping("/register")
    public String register(
            @RequestParam("recName") String recName,
            @RequestParam("recTypeCode") String recTypeCode,
            @RequestParam("recBirthday") String recBirthday,
            @RequestParam("recGender") String recGender,
            @RequestParam("recAddress") String recAddress,
            @RequestParam(value = "recMedHistory", required = false) String recMedHistory,
            @RequestParam(value = "recAllergies", required = false) String recAllergies,
            @RequestParam(value = "recSpecNotes", required = false) String recSpecNotes,
            @RequestParam(value = "recHealthNeeds", required = false) String recHealthNeeds,
            @RequestParam(value = "recPhotoUrl", required = false) MultipartFile photo,
            HttpSession session,
            Model model) {
        
        Cust loginUser = (Cust) session.getAttribute("loginUser");
        
        if (loginUser == null) {
            return "redirect:/login";
        }
        
        try {
            // Recipient 객체 생성
            Recipient recipient = Recipient.builder()
                    .custId(loginUser.getCustId())
                    .recTypeCode(recTypeCode)
                    .recName(recName)
                    .recBirthday(LocalDate.parse(recBirthday, DateTimeFormatter.ISO_LOCAL_DATE))
                    .recGender(recGender)
                    .recAddress(recAddress)
                    .recMedHistory(recMedHistory)
                    .recAllergies(recAllergies)
                    .recSpecNotes(recSpecNotes)
                    .recHealthNeeds(recHealthNeeds)
                    .isDeleted("N")
                    .build();
            
            // TODO: 사진 업로드 처리 (추후 구현)
            if (photo != null && !photo.isEmpty()) {
                // 파일 업로드 로직 추가
                log.info("사진 업로드: {}", photo.getOriginalFilename());
            }
            
            // DB에 저장
            recipientService.registerRecipient(recipient);
            
            log.info("노약자 등록 성공: {} (고객ID: {})", recName, loginUser.getCustId());
            
            // 등록 후 홈으로 리다이렉트
            return "redirect:/home";
            
        } catch (Exception e) {
            log.error("노약자 등록 실패", e);
            model.addAttribute("error", "등록 중 오류가 발생했습니다.");
            model.addAttribute("center", dir + "register");
            return "home";
        }
    }

    /**
     * 노약자 목록 조회 (API)
     */
    @GetMapping("/list")
    @ResponseBody
    public List<Recipient> getRecipientList(HttpSession session) {
        Cust loginUser = (Cust) session.getAttribute("loginUser");
        
        if (loginUser == null) {
            return null;
        }
        
        try {
            return recipientService.getRecipientsByCustId(loginUser.getCustId());
        } catch (Exception e) {
            log.error("노약자 목록 조회 실패", e);
            return null;
        }
    }
}

