package edu.sm.controller;

import edu.sm.app.repository.SeniorRepository; // 방금 수정한 레포지토리 import
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.Map;

@Controller
@Slf4j
public class WebSocketController {

    @Value("${app.url.websocketurl:https://localhost:8084}")
    private String websocketUrl;

    // [핵심] SeniorRepository 주입 (여기에 쿼리 추가했으니까요)
    @Autowired
    SeniorRepository seniorRepository;

    @RequestMapping("/websocket")
    public String websocket(Model model) {
        model.addAttribute("center", "websocket/websocket");
        return "index";
    }

    @RequestMapping("/websocket/video")
    public String videoCall(@RequestParam(required = false) String roomId, Model model) {
        log.info("영상통화 진입 - RoomID: " + roomId);

        model.addAttribute("websocketUrl", websocketUrl);
        model.addAttribute("roomId", roomId);

        // DB 연동 부분
        if (roomId != null && !roomId.equals("")) {
            try {

                Map<String, Object> info = seniorRepository.getCallDetail(roomId);

                if(info != null) {
                    // JSP로 데이터 전달
                    model.addAttribute("receiverName", info.get("r_name"));
                    model.addAttribute("receiverCondition", info.get("r_condition")); // 특이사항

                    // 요양사 정보 (이제 전화번호도 나옴!)
                    model.addAttribute("caregiverName", info.get("c_name"));
                    model.addAttribute("caregiverPhone", info.get("c_phone"));
                }
            } catch (NumberFormatException e) {
                log.warn("Room ID가 숫자가 아닙니다: " + roomId);
            } catch (Exception e) {
                log.error("DB 조회 오류", e);
            }
        }

        return "websocket/video";
    }

    // 긴급 메시지 전송 (가짜 전송 처리)
    @RequestMapping("/websocket/sendAlert")
    @ResponseBody
    public String sendAlert(@RequestParam("roomId") String roomId,
                            @RequestParam("message") String message) {
        log.info("긴급 문자 전송 시뮬레이션 [To Room: " + roomId + "] : " + message);
        // DB에 로그 남기려면 여기에 AlertLogRepository.insert() 쓰면 됨 (시간 없으면 생략 가능)
        return "OK";
    }
}