package edu.sm.controller;

import com.github.pagehelper.Page;
import edu.sm.app.dto.User;
import edu.sm.app.service.UserService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.List;

@Controller
@Slf4j
@RequestMapping("/customer")
@RequiredArgsConstructor
public class UserController {

    private final UserService userService;

    @RequestMapping("/list")
    public String customerList(@RequestParam(defaultValue = "1") int pageNo, Model model) {
        log.info("Customer list page accessed, pageNo: {}", pageNo);
        try {
            Page<User> page = userService.getPage(pageNo);
            model.addAttribute("page", page);
            model.addAttribute("users", page.getResult()); // For compatibility with existing view
        } catch (Exception e) {
            log.error("Error fetching customer list", e);
            // Optionally, add an error message to the model
            // model.addAttribute("errorMessage", "고객 목록을 불러오는 중 오류가 발생했습니다.");
        }
        model.addAttribute("center", "user/customer-list");
        return "index";
    }

    @GetMapping("/add")
    public String customerAdd(Model model) {
        log.info("Customer add page accessed");
        model.addAttribute("center", "user/customer-add");
        return "index";
    }

    @PostMapping("/addimpl")
    public String customerAddImpl(User user, Model model) {
        log.info("Registering user: {}", user);
        try {
            userService.register(user);
            log.info("User registration successful");
        } catch (Exception e) {
            log.error("Error registering user", e);
            model.addAttribute("errorMessage", "사용자 등록 중 오류가 발생했습니다.");
            // Optionally, you can return to the add page to show the error
            // model.addAttribute("center", "user/customer-add");
            // return "index";
        }
        return "redirect:/customer/list";
    }

    @GetMapping("/detail")
    public String customerDetail(@RequestParam("id") int id, Model model) {
        log.info("Customer detail page accessed for id: {}", id);
        try {
            User user = userService.get(id);
            model.addAttribute("user", user);
        } catch (Exception e) {
            log.error("Error fetching user details", e);
            model.addAttribute("errorMessage", "사용자 정보를 불러오는 중 오류가 발생했습니다.");
        }
        model.addAttribute("center", "user/customer-detail");
        return "index";
    }

    @RequestMapping("/search")
    public String customerSearch(Model model) {
        log.info("Customer search page accessed");
        model.addAttribute("center", "user/customer-search");
        return "index";
    }
}

