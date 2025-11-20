package edu.sm.controller;

import edu.sm.app.dto.User;
import edu.sm.app.service.UserService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import java.util.List;

@Controller
@Slf4j
@RequestMapping("/customer")
@RequiredArgsConstructor
public class UserController {

    private final UserService userService;

    @RequestMapping("/list")
    public String customerList(Model model) {
        log.info("Customer list page accessed");
        try {
            List<User> users = userService.get();
            model.addAttribute("users", users);
        } catch (Exception e) {
            log.error("Error fetching customer list", e);
            // Optionally, add an error message to the model
            // model.addAttribute("errorMessage", "고객 목록을 불러오는 중 오류가 발생했습니다.");
        }
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

