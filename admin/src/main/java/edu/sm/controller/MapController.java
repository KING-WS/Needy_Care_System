package edu.sm.controller;

import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

/**
 * 지도 컨트롤러
 * map/ 폴더의 JSP 파일들을 처리
 */
@Controller
@Slf4j
@RequestMapping("/map")
public class MapController {

    @RequestMapping("")
    public String map(Model model) {
        log.info("Map page accessed");
        model.addAttribute("center", "map/map");
        return "index";
    }
}


