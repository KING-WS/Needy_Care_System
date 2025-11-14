package edu.sm.controller;

import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

/**
 * 웹소켓 컨트롤러
 * websocket/ 폴더의 JSP 파일들을 처리
 */
@Controller
@Slf4j
public class WebSocketController {

    @RequestMapping("/websocket")
    public String websocket(Model model) {
        log.info("WebSocket page accessed");
        model.addAttribute("center", "websocket/websocket");
        return "index";
    }
}

