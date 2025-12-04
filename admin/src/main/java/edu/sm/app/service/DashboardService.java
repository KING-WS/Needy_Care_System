package edu.sm.app.service;

import edu.sm.app.dto.ActivityItem;
import edu.sm.app.dto.ActivityLogDTO;
import edu.sm.app.dto.CareTimelineItem;
import edu.sm.app.dto.DailyUserCountDTO;
import edu.sm.app.repository.ActivityLogRepository;
import edu.sm.app.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import jakarta.annotation.PostConstruct;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.Executors;
import java.util.concurrent.TimeUnit;
import java.util.stream.Collectors;
import java.util.stream.Stream;

/**
 * 대시보드 관련 비즈니스 로직을 처리하는 서비스
 */
@Service
public class DashboardService {

    private final TimelineNotifierService timelineNotifierService;
    private final UserRepository userRepository;
    private final ActivityLogRepository activityLogRepository;

    @Autowired
    public DashboardService(TimelineNotifierService timelineNotifierService, UserRepository userRepository, ActivityLogRepository activityLogRepository) {
        this.timelineNotifierService = timelineNotifierService;
        this.userRepository = userRepository;
        this.activityLogRepository = activityLogRepository;
    }


    /**
     * (임시) 15초마다 실시간 알림을 발생시키는 테스트용 메소드
     */
    @PostConstruct
    public void startMockNotification() {
        Executors.newSingleThreadScheduledExecutor().scheduleAtFixedRate(() -> {
            CareTimelineItem newItem = CareTimelineItem.builder()
                    .type("NEW_USER")
                    .message("새로운 요양사님이 가입했습니다: " + "김요양")
                    .timestamp(LocalDateTime.now())
                    .iconClass("bi-person-plus-fill")
                    .bgClass("bg-primary")
                    .link("#")
                    .build();
            timelineNotifierService.notifyNewCareActivity(newItem);
        }, 15, 15, TimeUnit.SECONDS);
    }

    /**
     * 최근 일반 활동 로그를 가져옵니다.
     * @return ActivityItem 리스트
     */
    public List<ActivityItem> getRecentActivities() {
        List<ActivityLogDTO> dtoList = activityLogRepository.getRecentActivities();
        return dtoList.stream().map(dto -> ActivityItem.builder()
                .message(dto.getMessage())
                .timestamp(dto.getTimestamp().toInstant().atZone(ZoneId.systemDefault()).toLocalDateTime())
                .iconClass(dto.getIconClass())
                .bgClass(dto.getBgClass())
                .link(dto.getLink())
                .build()).collect(Collectors.toList());
    }

    /**
     * 최근 30일간의 일별 사용자 가입 수를 가져옵니다.
     * @return 날짜와 가입자 수를 담은 Map의 리스트
     */
    public List<Map<String, Object>> getUserGrowthData() {
        List<DailyUserCountDTO> dailyCounts = userRepository.findDailyUserRegistrations();
        return dailyCounts.stream().map(dto -> {
            Map<String, Object> map = new HashMap<>();
            map.put("date", dto.getDate());
            map.put("count", dto.getCount());
            return map;
        }).collect(Collectors.toList());
    }


    /**
     * 최근 케어 활동 목록을 가져옵니다.
     * (현재는 Mock 데이터를 반환)
     * @return CareTimelineItem 리스트
     */
    public List<CareTimelineItem> getRecentCareActivities() {
        // TODO: 실제 데이터베이스에서 최근 활동들을 조회하는 로직으로 교체해야 합니다.
        // (예: Alert, CareLog, Schedule 등 여러 테이블에서 데이터를 종합)
        return Stream.of(
                CareTimelineItem.builder()
                        .type("CARE_START")
                        .message("김민준 요양사님이 박영희 어르신의 오늘의 케어를 시작했습니다.")
                        .timestamp(LocalDateTime.now().minusMinutes(5))
                        .iconClass("bi-play-circle-fill")
                        .bgClass("bg-success")
                        .link("#")
                        .build(),
                CareTimelineItem.builder()
                        .type("ALERT")
                        .message("최진우 어르신, 낙상 감지! 확인이 필요합니다.")
                        .timestamp(LocalDateTime.now().minusMinutes(15))
                        .iconClass("bi-exclamation-triangle-fill")
                        .bgClass("bg-danger")
                        .link("#")
                        .build(),
                CareTimelineItem.builder()
                        .type("MEAL_PLAN")
                        .message("이지은 요양사님이 최진우 어르신의 식단 계획을 업데이트했습니다.")
                        .timestamp(LocalDateTime.now().minusHours(1))
                        .iconClass("bi-card-checklist")
                        .bgClass("bg-info")
                        .link("#")
                        .build(),
                CareTimelineItem.builder()
                        .type("CARE_END")
                        .message("김민준 요양사님이 박영희 어르신의 케어를 종료했습니다.")
                        .timestamp(LocalDateTime.now().minusHours(2))
                        .iconClass("bi-stop-circle-fill")
                        .bgClass("bg-secondary")
                        .link("#")
                        .build()
        ).collect(Collectors.toList());
    }
}