package edu.sm.controller;

import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

/**
 * 고객 관리 컨트롤러
 * user/ 폴더의 JSP 파일들을 처리
 */
@Controller
@Slf4j
@RequestMapping("/customer")
public class UserController {

    @RequestMapping("/list")
    public String customerList(Model model) {
        log.info("Customer list page accessed");
        model.addAttribute("center", "user/customer-list");
        return "index";
    }

    @RequestMapping("/add")
    public String customerAdd(Model model) {
        log.info("Customer add page accessed");
        model.addAttribute("center", "user/customer-add");
        return "index";
    }

    @RequestMapping("/search")
    public String customerSearch(Model model) {
        log.info("Customer search page accessed");
        model.addAttribute("center", "user/customer-search");
        return "index";
    }
    
    @RequestMapping("/users")
    public String users(Model model) {
        log.info("Users page accessed");
        model.addAttribute("center", "user/users");
        return "index";
    }
}

