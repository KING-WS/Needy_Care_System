package edu.sm.controller;

import edu.sm.app.dto.Recipient;
import edu.sm.app.dto.Cust;
import edu.sm.app.service.RecipientService;
import edu.sm.app.service.CustService;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;

/**
 * 노약자 전용 키오스크 컨트롤러
 * * 설명: 복잡한 로그인 과정 없이 고유 코드(kioskCode)만으로
 * 간편하게 접속하여 케어 서비스를 이용하는 기능을 처리합니다.
 */
@Controller
@RequestMapping("/kiosk")
@RequiredArgsConstructor
@Slf4j
public class KioskController {

    private final RecipientService recipientService;
    private final CustService custService;

    @Value("${app.url.websocketurl}")
    private String websocketUrl;

    /**
     * 키오스크 메인 페이지 접속
     * * @param kioskCode 노약자 고유 접속 코드 (URL 경로 변수)
     * @param model 화면에 데이터를 전달할 객체
     * @param session 사용자 정보를 유지할 HTTP 세션
     * @return 키오스크 메인 화면 (kiosk/home) 또는 에러 페이지
     */
    @GetMapping("/{kioskCode}")
    public String kioskHome(@PathVariable("kioskCode") String kioskCode,
                            Model model,
                            HttpSession session) {

        log.info("[Kiosk Connect] 접속 요청 코드: {}", kioskCode);

        try {
            // 1. 키오스크 코드로 노약자 정보 조회
            Recipient recipient = recipientService.getRecipientByKioskCode(kioskCode);

            // 2. 유효하지 않은 코드일 경우 에러 처리
            if (recipient == null) {
                log.warn("[Kiosk Connect] 실패 - 유효하지 않은 코드: {}", kioskCode);
                model.addAttribute("errorMessage", "유효하지 않은 접속 코드입니다. 보호자에게 문의하세요.");
                return "kiosk/error";
            }

            // 3. 접속 성공: 세션에 키오스크 사용자 정보 저장
            // (일반 로그인과 섞이지 않도록 별도의 속성명 사용)
            session.setAttribute("kioskUser", recipient);
            session.setAttribute("kioskCode", kioskCode);

            log.info("[Kiosk Connect] 성공 - 대상자: {}(ID:{})", recipient.getRecName(), recipient.getRecId());

            // 4. 화면에 필요한 데이터 전달 (노약자 정보)
            model.addAttribute("recipient", recipient);
            model.addAttribute("websocketUrl", websocketUrl);

            // 5. (선택) 보호자 정보가 있다면 추가 조회
            if (recipient.getCustId() != null) {
                Cust cust = custService.get(recipient.getCustId());
                if (cust != null) {
                    model.addAttribute("cust", cust);
                }
            }

            return "kiosk/home";

        } catch (Exception e) {
            log.error("[Kiosk Connect] 시스템 오류 발생", e);
            model.addAttribute("errorMessage", "접속 중 시스템 오류가 발생했습니다.");
            return "kiosk/error";
        }
    }

    /**
     * 키오스크 사용 종료 (로그아웃)
     * * 설명: 키오스크 모드를 종료하고 메인 화면으로 이동합니다.
     * 만약 연결된 보호자 계정이 있다면 보호자 모드로 전환을 시도합니다.
     */
    @GetMapping("/logout")
    public String kioskLogout(HttpSession session) {
        try {
            Recipient kioskUser = (Recipient) session.getAttribute("kioskUser");

            if (kioskUser != null) {
                log.info("[Kiosk Logout] 세션 종료 - 대상자: {}", kioskUser.getRecName());
            }

            // 1. 키오스크 관련 세션 정보 삭제
            session.removeAttribute("kioskUser");
            session.removeAttribute("kioskCode");

            // 2. 보호자 계정으로 자동 전환 로직 (연결된 보호자가 있을 경우)
            if (kioskUser != null && kioskUser.getCustId() != null) {
                Cust cust = custService.get(kioskUser.getCustId());
                if (cust != null) {
                    session.setAttribute("loginUser", cust); // 보호자 로그인 세션 생성
                    log.info("[Kiosk Switch] 보호자 모드로 전환 - 보호자: {}", cust.getCustName());
                    return "redirect:/home"; // 보호자 메인 화면으로 이동
                }
            }

            // 3. 연결된 보호자가 없거나 조회 실패 시 기본 홈으로 이동
            return "redirect:/";

        } catch (Exception e) {
            log.error("[Kiosk Logout] 로그아웃 처리 중 오류", e);
            return "redirect:/";
        }
    }
}