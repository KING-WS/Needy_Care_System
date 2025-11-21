package edu.sm.controller;

import edu.sm.app.dto.Recipient;
import edu.sm.app.dto.Cust;
import edu.sm.app.service.RecipientService;
import edu.sm.app.service.CustService;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;

/**
 * 노약자 전용 키오스크 컨트롤러
 * 키오스크 코드를 통해 별도 로그인 없이 접속 가능
 */
@Controller
@RequestMapping("/kiosk")
@RequiredArgsConstructor
@Slf4j
public class KioskController {

    private final RecipientService recipientService;
    private final CustService custService;

    /**
     * 키오스크 메인 페이지
     * URL: /kiosk/{kioskCode}
     * 예: /kiosk/ABC123XYZ
     * 
     * @param kioskCode 노약자 고유 키오스크 코드
     * @param model 모델
     * @param session 세션 (키오스크 사용자 정보 저장)
     * @return 키오스크 메인 화면
     */
    @GetMapping("/{kioskCode}")
    public String kioskHome(@PathVariable("kioskCode") String kioskCode, 
                           Model model, 
                           HttpSession session) {
        
        log.info("====================================");
        log.info("키오스크 접속 시도");
        log.info("키오스크 코드: {}", kioskCode);
        log.info("====================================");
        
        try {
            // 키오스크 코드로 노약자 정보 조회
            Recipient recipient = recipientService.getRecipientByKioskCode(kioskCode);
            
            log.info("DB 조회 결과: {}", recipient != null ? "성공 (recId: " + recipient.getRecId() + ")" : "실패 (NULL)");
            
            if (recipient == null) {
                log.warn("유효하지 않은 키오스크 코드: {}", kioskCode);
                log.warn("DB에 해당 코드가 없거나 삭제된 데이터입니다.");
                model.addAttribute("errorMessage", "유효하지 않은 접속 코드입니다. 보호자에게 문의하세요.");
                model.addAttribute("kioskCode", kioskCode);
                return "kiosk/error";
            }
            
            // 세션에 키오스크 사용자 정보 저장
            session.setAttribute("kioskUser", recipient);
            session.setAttribute("kioskCode", kioskCode);
            
            log.info("키오스크 접속 성공!");
            log.info("- 노약자 이름: {}", recipient.getRecName());
            log.info("- 노약자 ID: {}", recipient.getRecId());
            log.info("- 생년월일: {}", recipient.getRecBirthday());
            log.info("====================================");
            
            // 모델에 노약자 정보 추가
            model.addAttribute("recipient", recipient);
            
            // 보호자(고객) 정보도 조회하여 모델에 추가
            if (recipient.getCustId() != null) {
                try {
                    Cust cust = custService.get(recipient.getCustId());
                    if (cust != null) {
                        model.addAttribute("cust", cust);
                        log.info("보호자 정보 추가 - custName: {}", cust.getCustName());
                    }
                } catch (Exception e) {
                    log.warn("보호자 정보 조회 실패 - custId: {}", recipient.getCustId(), e);
                }
            }
            
            return "kiosk/home";
            
        } catch (Exception e) {
            log.error("====================================");
            log.error("키오스크 접속 중 오류 발생!");
            log.error("에러 메시지: {}", e.getMessage());
            log.error("에러 타입: {}", e.getClass().getName());
            log.error("====================================", e);
            
            model.addAttribute("errorMessage", "시스템 오류가 발생했습니다. 관리자에게 문의하세요.");
            model.addAttribute("errorDetail", e.getMessage());
            return "kiosk/error";
        }
    }

    /**
     * 키오스크 세션 종료
     * 노약자를 돌보고 있는 보호자(고객)의 로그인된 home 화면으로 이동
     */
    @GetMapping("/logout")
    public String kioskLogout(HttpSession session) {
        try {
            // 세션에서 키오스크 사용자(노약자) 정보 가져오기
            Recipient kioskUser = (Recipient) session.getAttribute("kioskUser");
            String kioskCode = (String) session.getAttribute("kioskCode");
            
            log.info("키오스크 세션 종료 - kioskCode: {}", kioskCode);
            
            // 키오스크 세션 제거
            session.removeAttribute("kioskUser");
            session.removeAttribute("kioskCode");
            
            // 노약자 정보가 있으면 보호자(고객) 정보 조회 및 자동 로그인
            if (kioskUser != null && kioskUser.getCustId() != null) {
                try {
                    Cust cust = custService.get(kioskUser.getCustId());
                    if (cust != null) {
                        // 보호자 정보를 세션에 로그인 사용자로 설정
                        session.setAttribute("loginUser", cust);
                        log.info("보호자 자동 로그인 성공 - custId: {}, custName: {}", cust.getCustId(), cust.getCustName());
                        log.info("보호자 home 화면으로 이동");
                        return "redirect:/home";
                    } else {
                        log.warn("보호자 정보를 찾을 수 없음 - custId: {}", kioskUser.getCustId());
                    }
                } catch (Exception e) {
                    log.error("보호자 정보 조회 중 오류 발생 - custId: {}", kioskUser.getCustId(), e);
                }
            } else {
                log.warn("키오스크 사용자 정보가 없거나 custId가 없음");
            }
            
            // 보호자 정보 조회 실패 시 일반 홈으로 이동
            log.info("보호자 정보 조회 실패 - index 페이지로 이동");
            return "redirect:/";
            
        } catch (Exception e) {
            log.error("키오스크 로그아웃 처리 중 오류 발생", e);
            return "redirect:/";
        }
    }
    
    /**
     * 키오스크 컨트롤러 테스트 (개발용)
     * URL: /kiosk/test
     */
    @GetMapping("/test")
    @org.springframework.web.bind.annotation.ResponseBody
    public String kioskTest() {
        log.info("키오스크 테스트 엔드포인트 호출됨");
        
        StringBuilder sb = new StringBuilder();
        sb.append("=== 키오스크 시스템 테스트 ===\n\n");
        sb.append("✅ KioskController가 정상 작동 중입니다!\n\n");
        sb.append("📋 테스트 방법:\n");
        sb.append("1. MySQL에서 노약자 데이터 확인\n");
        sb.append("2. rec_kiosk_code 값 복사\n");
        sb.append("3. https://127.0.0.1:8084/kiosk/{코드} 접속\n\n");
        sb.append("예시: https://127.0.0.1:8084/kiosk/TEST-ABCD-1234\n\n");
        
        try {
            // 모든 키오스크 코드 조회
            sb.append("🔍 DB에 등록된 키오스크 코드:\n");
            // 여기서는 Service를 통해 조회할 수 없으므로 안내만
            sb.append("(MySQL에서 직접 확인하세요)\n\n");
            sb.append("SQL 쿼리:\n");
            sb.append("SELECT rec_id, rec_name, rec_kiosk_code FROM Care_Recipient WHERE is_deleted = 'N';\n");
        } catch (Exception e) {
            sb.append("❌ 에러: ").append(e.getMessage()).append("\n");
        }
        
        return sb.toString();
    }
}

