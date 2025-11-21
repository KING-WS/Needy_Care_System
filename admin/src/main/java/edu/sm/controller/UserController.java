package edu.sm.controller;

import com.github.pagehelper.Page;
import com.github.pagehelper.PageInfo;
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
            PageInfo<User> pageInfo = new PageInfo<>(page);
            model.addAttribute("page", pageInfo);
            model.addAttribute("users", pageInfo.getList());
        } catch (Exception e) {
            log.error("Error fetching customer list", e);
            model.addAttribute("errorMessage", "고객 목록을 불러오는 중 오류가 발생했습니다.");
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

    @GetMapping("/edit")
    public String customerEdit(@RequestParam("id") int id, Model model) {
        log.info("Customer edit page accessed for id: {}", id);
        try {
            User user = userService.get(id);
            model.addAttribute("user", user);
        } catch (Exception e) {
            log.error("Error fetching user details for editing", e);
            model.addAttribute("errorMessage", "사용자 정보를 불러오는 중 오류가 발생했습니다.");
        }
        model.addAttribute("center", "user/customer-edit");
        return "index";
    }

    @PostMapping("/editimpl")
    public String customerEditImpl(User user, Model model) {
        log.info("Updating user: {}", user);
        try {
            userService.modify(user);
            log.info("User update successful");
        } catch (Exception e) {
            log.error("Error updating user", e);
            model.addAttribute("errorMessage", "사용자 정보 수정 중 오류가 발생했습니다.");
            // Optionally, return to the edit page to show the error
            // model.addAttribute("user", user);

            // model.addAttribute("center", "user/customer-edit");
            // return "index";
        }
        return "redirect:/customer/detail?id=" + user.getCustId();
    }

    @RequestMapping("/search")
    public String customerSearch(Model model) {
        log.info("Customer search page accessed");
        model.addAttribute("center", "user/customer-search");
        return "index";
    }
}

