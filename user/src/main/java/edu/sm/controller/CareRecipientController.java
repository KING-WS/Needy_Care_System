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
        model.addAttribute("left", dir + "left");
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
            
            // 등록 후 목록 페이지로 리다이렉트
            return "redirect:/recipient/list";
            
        } catch (Exception e) {
            log.error("노약자 등록 실패", e);
            model.addAttribute("error", "등록 중 오류가 발생했습니다.");
            model.addAttribute("center", dir + "register");
            return "home";
        }
    }

    /**
     * 노약자 목록 페이지
     */
    @GetMapping("/list")
    public String listPage(Model model, HttpSession session) {
        Cust loginUser = (Cust) session.getAttribute("loginUser");
        
        if (loginUser == null) {
            log.warn("비로그인 사용자가 /recipient/list 접근 시도");
            return "redirect:/login";
        }
        
        model.addAttribute("loginUser", loginUser);
        model.addAttribute("left", dir + "left");
        model.addAttribute("center", dir + "list");
        return "home";
    }

    /**
     * 노약자 목록 조회 (API)
     */
    @GetMapping("/api/list")
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

    /**
     * 노약자 삭제 (API)
     */
    @DeleteMapping("/api/delete")
    @ResponseBody
    public java.util.Map<String, Object> deleteRecipient(
            @RequestParam("recId") Integer recId,
            HttpSession session) {
        Cust loginUser = (Cust) session.getAttribute("loginUser");
        java.util.Map<String, Object> result = new java.util.HashMap<>();
        
        if (loginUser == null) {
            result.put("success", false);
            result.put("message", "로그인이 필요합니다.");
            return result;
        }
        
        try {
            recipientService.deleteRecipient(recId);
            result.put("success", true);
            log.info("노약자 삭제 성공: recId={}, custId={}", recId, loginUser.getCustId());
        } catch (Exception e) {
            log.error("노약자 삭제 실패", e);
            result.put("success", false);
            result.put("message", e.getMessage());
        }
        
        return result;
    }

    /**
     * 노약자 상세보기 페이지
     */
    @GetMapping("/detail")
    public String detailPage(@RequestParam("recId") Integer recId, Model model, HttpSession session) {
        Cust loginUser = (Cust) session.getAttribute("loginUser");
        
        if (loginUser == null) {
            return "redirect:/login";
        }
        
        try {
            Recipient recipient = recipientService.getRecipientById(recId);
            model.addAttribute("recipient", recipient);
            model.addAttribute("loginUser", loginUser);
            model.addAttribute("left", dir + "left");
            model.addAttribute("center", dir + "detail");
            return "home";
        } catch (Exception e) {
            log.error("노약자 상세정보 조회 실패", e);
            return "redirect:/recipient/list";
        }
    }

    /**
     * 노약자 수정 페이지
     */
    @GetMapping("/edit")
    public String editPage(@RequestParam("recId") Integer recId, Model model, HttpSession session) {
        Cust loginUser = (Cust) session.getAttribute("loginUser");
        
        if (loginUser == null) {
            return "redirect:/login";
        }
        
        try {
            Recipient recipient = recipientService.getRecipientById(recId);
            model.addAttribute("recipient", recipient);
            model.addAttribute("loginUser", loginUser);
            model.addAttribute("left", dir + "left");
            model.addAttribute("center", dir + "edit");
            return "home";
        } catch (Exception e) {
            log.error("노약자 수정 페이지 로드 실패", e);
            return "redirect:/recipient/list";
        }
    }

    /**
     * 노약자 수정 처리
     */
    @PostMapping("/edit")
    public String edit(
            @RequestParam("recId") Integer recId,
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
            // 기존 정보 조회
            Recipient existingRecipient = recipientService.getRecipientById(recId);
            
            // 권한 확인 (본인의 대상자인지)
            if (!existingRecipient.getCustId().equals(loginUser.getCustId())) {
                log.warn("권한 없는 수정 시도 - recId: {}, custId: {}", recId, loginUser.getCustId());
                model.addAttribute("error", "수정 권한이 없습니다.");
                return "redirect:/recipient/list";
            }
            
            // Recipient 객체 업데이트
            Recipient recipient = Recipient.builder()
                    .recId(recId)
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
                    .isDeleted(existingRecipient.getIsDeleted())
                    .build();
            
            // TODO: 사진 업로드 처리 (추후 구현)
            if (photo != null && !photo.isEmpty()) {
                log.info("사진 업로드: {}", photo.getOriginalFilename());
            }
            
            // DB 업데이트
            recipientService.updateRecipient(recipient);
            
            log.info("노약자 수정 성공: recId={}, recName={}", recId, recName);
            
            // 수정 후 상세 페이지로 리다이렉트
            return "redirect:/recipient/detail?recId=" + recId;
            
        } catch (Exception e) {
            log.error("노약자 수정 실패", e);
            model.addAttribute("error", "수정 중 오류가 발생했습니다.");
            model.addAttribute("left", dir + "left");
            model.addAttribute("center", dir + "edit");
            return "home";
        }
    }

    /**
     * 통계 페이지 (추후 구현)
     */
    @GetMapping("/stats")
    public String statsPage(Model model, HttpSession session) {
        Cust loginUser = (Cust) session.getAttribute("loginUser");
        
        if (loginUser == null) {
            return "redirect:/login";
        }
        
        model.addAttribute("loginUser", loginUser);
        model.addAttribute("left", dir + "left");
        model.addAttribute("center", dir + "stats");
        return "home";
    }
}

