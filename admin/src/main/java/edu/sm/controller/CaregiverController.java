package edu.sm.controller;

import com.github.pagehelper.Page;
import com.github.pagehelper.PageInfo;
import edu.sm.app.dto.CareMatching;
import edu.sm.app.dto.Caregiver;
import edu.sm.app.dto.Senior;
import edu.sm.app.service.CareMatchingService;
import edu.sm.app.service.CaregiverService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.List;

/**
 * 요양사 관리 컨트롤러
 * doctor/ 폴더의 JSP 파일들을 처리
 */
@Controller
@Slf4j
@RequestMapping("/caregiver")
@RequiredArgsConstructor
public class CaregiverController {

    private final CaregiverService caregiverService;
    private final CareMatchingService careMatchingService;

    @RequestMapping("/list")
    public String caregiverList(@RequestParam(defaultValue = "1") int pageNo,
                                @RequestParam(defaultValue = "caregiverRegdate") String sort,
                                @RequestParam(defaultValue = "desc") String order,
                                Model model) {
        log.info("Caregiver list page accessed, pageNo: {}, sort: {}, order: {}", pageNo, sort, order);
        try {
            Page<Caregiver> page = caregiverService.getPage(pageNo, sort, order);
            PageInfo<Caregiver> pageInfo = new PageInfo<>(page);
            model.addAttribute("page", pageInfo);
            model.addAttribute("caregiverList", pageInfo.getList());
            model.addAttribute("sort", sort);
            model.addAttribute("order", order);
        } catch (Exception e) {
            log.error("Error fetching caregiver list", e);
            model.addAttribute("errorMessage", "요양사 목록을 불러오는 중 오류가 발생했습니다.");
        }
        model.addAttribute("center", "doctor/caregiver-list");
        return "index";
    }
    
    @GetMapping("/detail/{id}")
    public String caregiverDetail(@PathVariable("id") int id, Model model) {
        log.info("Caregiver detail page accessed for id: {}", id);
        try {
            Caregiver caregiver = caregiverService.get(id);
            model.addAttribute("caregiver", caregiver);
        } catch (Exception e) {
            log.error("Error fetching caregiver details", e);
            model.addAttribute("errorMessage", "요양사 정보를 불러오는 중 오류가 발생했습니다.");
        }
        model.addAttribute("center", "doctor/caregiver-detail");
        return "index";
    }

    @GetMapping("/edit/{id}")
    public String caregiverEdit(@PathVariable("id") int id, Model model) {
        log.info("Caregiver edit page accessed for id: {}", id);
        try {
            Caregiver caregiver = caregiverService.get(id);
            model.addAttribute("caregiver", caregiver);
        } catch (Exception e) {
            log.error("Error fetching caregiver for editing", e);
            model.addAttribute("errorMessage", "요양사 정보를 불러오는 중 오류가 발생했습니다.");
        }
        model.addAttribute("center", "doctor/caregiver-edit");
        return "index";
    }

    @PostMapping("/editimpl")
    public String caregiverEditImpl(Caregiver caregiver, Model model) {
        log.info("Updating caregiver: {}", caregiver);
        try {
            caregiverService.modify(caregiver);
            log.info("Caregiver update successful");
        } catch (Exception e) {
            log.error("Error updating caregiver", e);
            model.addAttribute("errorMessage", "요양사 정보 수정 중 오류가 발생했습니다.");
        }
        return "redirect:/caregiver/detail/" + caregiver.getCaregiverId();
    }

    @RequestMapping("/add")
    public String caregiverAdd(Model model) {
        log.info("Caregiver add page accessed");
        model.addAttribute("center", "doctor/caregiver-add");
        return "index";
    }

    @GetMapping("/manage")
    public String caregiverManage(Model model) {
        log.info("Caregiver manage page accessed");
        try {
            List<CareMatching> matchedPairs = careMatchingService.getMatchedPairs();
            List<Senior> unassignedSeniors = careMatchingService.getUnassignedSeniors();
            List<Caregiver> unassignedCaregivers = careMatchingService.getUnassignedCaregivers();

            model.addAttribute("matchedPairs", matchedPairs);
            model.addAttribute("unassignedSeniors", unassignedSeniors);
            model.addAttribute("unassignedCaregivers", unassignedCaregivers);
        } catch (Exception e) {
            log.error("Error loading caregiver management page", e);
            model.addAttribute("errorMessage", "매칭 관리 페이지를 불러오는 중 오류가 발생했습니다.");
        }
        model.addAttribute("center", "doctor/caregiver-manage");
        return "index";
    }

    @PostMapping("/match/add")
    public String createMatch(@RequestParam("caregiverId") int caregiverId,
                              @RequestParam("recId") int recId) {
        log.info("Request to create a match between caregiver {} and senior {}", caregiverId, recId);
        try {
            CareMatching newMatch = new CareMatching();
            newMatch.setCaregiverId(caregiverId);
            newMatch.setRecId(recId);
            careMatchingService.createMatch(newMatch);
        } catch (Exception e) {
            log.error("Error creating match", e);
            // Redirect with an error message if needed
        }
        return "redirect:/caregiver/manage";
    }

    @GetMapping("/match/delete/{id}")
    public String deleteMatch(@PathVariable("id") int matchingId) {
        log.info("Request to delete match with id {}", matchingId);
        try {
            careMatchingService.removeMatch(matchingId);
        } catch (Exception e) {
            log.error("Error deleting match", e);
            // Redirect with an error message if needed
        }
        return "redirect:/caregiver/manage";
    }
}

