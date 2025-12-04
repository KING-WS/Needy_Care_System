package edu.sm.controller;

import edu.sm.app.dto.ActivityItem;
import edu.sm.app.dto.CareTimelineItem;
import edu.sm.app.service.DashboardService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;
import java.util.Map;

/**
 * 대시보드 관련 데이터를 제공하는 API 컨트롤러
 */
@RestController
@RequestMapping("/api/dashboard")
public class DashboardApiController {

    @Autowired
    private DashboardService dashboardService;

    /**
     * 최근 케어 활동 목록을 반환하는 API 엔드포인트
     * @return CareTimelineItem 리스트
     */
    @GetMapping("/recent-care-activities")
    public ResponseEntity<List<CareTimelineItem>> getRecentCareActivities() {
        List<CareTimelineItem> activities = dashboardService.getRecentCareActivities();
        return ResponseEntity.ok(activities);
    }

    /**
     * 최근 활동 피드 목록을 반환하는 API 엔드포인트
     * @return ActivityItem 리스트
     */
    @GetMapping("/recent-activities")
    public ResponseEntity<List<ActivityItem>> getRecentActivities() {
        List<ActivityItem> activities = dashboardService.getRecentActivities();
        return ResponseEntity.ok(activities);
    }

    /**
     * 일별 사용자 증가량을 반환하는 API 엔드포인트
     * @return 날짜와 가입자 수를 담은 Map의 리스트
     */
    @GetMapping("/user-growth")
    public ResponseEntity<List<Map<String, Object>>> getUserGrowth() {
        List<Map<String, Object>> userGrowthData = dashboardService.getUserGrowthData();
        return ResponseEntity.ok(userGrowthData);
    }
}