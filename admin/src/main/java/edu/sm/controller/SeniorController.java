package edu.sm.controller;

import com.github.pagehelper.Page;
import com.github.pagehelper.PageInfo;
import edu.sm.app.dto.Senior;
import edu.sm.app.service.SeniorService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

/**
 * 노약자 관리 컨트롤러
 * senior/ 폴더의 JSP 파일들을 처리
 */
@Controller
@Slf4j
@RequestMapping("/senior")
@RequiredArgsConstructor
public class SeniorController {

    private final SeniorService seniorService;


    @RequestMapping("/list")
    public String seniorList(@RequestParam(defaultValue = "1") int pageNo, Model model) {
        log.info("Senior list page accessed, pageNo: {}", pageNo);
        try {
            Page<Senior> page = seniorService.getPage(pageNo);
            PageInfo<Senior> pageInfo = new PageInfo<>(page);
            model.addAttribute("page", pageInfo);
            model.addAttribute("seniorList", pageInfo.getList());
        } catch (Exception e) {
            log.error("Error fetching senior list", e);
            model.addAttribute("errorMessage", "노약자 목록을 불러오는 중 오류가 발생했습니다.");
        }
        model.addAttribute("center", "senior/senior-list");
        return "index";
    }

    @GetMapping("/detail/{id}")
    public String seniorDetail(@PathVariable("id") int id, Model model) {
        log.info("Senior detail page accessed for id: {}", id);
        try {
            Senior senior = seniorService.get(id);
            model.addAttribute("senior", senior);
        } catch (Exception e) {
            log.error("Error fetching senior details", e);
            model.addAttribute("errorMessage", "노약자 정보를 불러오는 중 오류가 발생했습니다.");
        }
        model.addAttribute("center", "senior/senior-detail");
        return "index";
    }

    @GetMapping("/edit/{id}")
    public String seniorEdit(@PathVariable("id") int id, Model model) {
        log.info("Senior edit page accessed for id: {}", id);
        try {
            Senior senior = seniorService.get(id);
            model.addAttribute("senior", senior);
        } catch (Exception e) {
            log.error("Error fetching senior for editing", e);
            model.addAttribute("errorMessage", "노약자 정보를 불러오는 중 오류가 발생했습니다.");
        }
        model.addAttribute("center", "senior/senior-edit");
        return "index";
    }

    @PostMapping("/editimpl")
    public String seniorEditImpl(Senior senior, Model model) {
        log.info("Updating senior: {}", senior);
        try {
            seniorService.modify(senior);
            log.info("Senior update successful");
        } catch (Exception e) {
            log.error("Error updating senior", e);
            model.addAttribute("errorMessage", "노약자 정보 수정 중 오류가 발생했습니다.");
        }
        return "redirect:/senior/detail/" + senior.getRecId();
    }

    @GetMapping("/add")
    public String seniorAdd(Model model) {
        log.info("Senior add page accessed");
        model.addAttribute("center", "senior/senior-add");
        return "index";
    }

    @PostMapping("/addimpl")
    public String seniorAddImpl(Senior senior, Model model) {
        log.info("Registering senior: {}", senior);
        try {
            seniorService.register(senior);
            log.info("Senior registration successful");
        } catch (Exception e) {
            log.error("Error registering senior", e);
            model.addAttribute("errorMessage", "노약자 등록 중 오류가 발생했습니다.");
        }
        return "redirect:/senior/list";
    }

    @RequestMapping("/care")
    public String seniorCare(Model model) {
        log.info("Senior care page accessed");
        model.addAttribute("center", "senior/senior-care");
        return "index";
    }
}
