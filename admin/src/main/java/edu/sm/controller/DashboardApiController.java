package edu.sm.controller;

import edu.sm.app.dto.ActivityLogDTO;
import edu.sm.app.dto.DailyUserCountDTO;
import edu.sm.app.service.DashboardService;
import edu.sm.app.service.UserService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/api/dashboard")
@RequiredArgsConstructor
@Slf4j
public class DashboardApiController {

    private final UserService userService;
    private final DashboardService dashboardService;

    @GetMapping("/user-growth")
    public List<DailyUserCountDTO> getUserGrowthData() {
        log.info("Fetching daily user registrations data.");
        return userService.getDailyUserRegistrations();
    }

    @GetMapping("/recent-activities")
    public List<ActivityLogDTO> getRecentActivities() {
        log.info("Fetching recent activities.");
        return dashboardService.getRecentActivities();
    }
}
