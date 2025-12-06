package edu.sm.app.service;

import edu.sm.app.dto.*;
import edu.sm.app.repository.ActivityLogRepository;
import edu.sm.app.repository.AlertLogRepository; // 추가
import edu.sm.app.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import jakarta.annotation.PostConstruct;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.Arrays;
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.Executors;
import java.util.concurrent.TimeUnit;
import java.util.function.Function;
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
    private final AlertLogRepository alertLogRepository; // 추가
    private final SeniorService seniorService;

    @Autowired
    public DashboardService(TimelineNotifierService timelineNotifierService, UserRepository userRepository, ActivityLogRepository activityLogRepository, AlertLogRepository alertLogRepository, SeniorService seniorService) {
        this.timelineNotifierService = timelineNotifierService;
        this.userRepository = userRepository;
        this.activityLogRepository = activityLogRepository;
        this.alertLogRepository = alertLogRepository; // 추가
        this.seniorService = seniorService;
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
     * (AlertLog에서 실제 데이터를 조회)
     * @return CareTimelineItem 리스트
     */
    public List<CareTimelineItem> getRecentCareActivities() {
        // 최근 10개 알림을 가져옵니다.
        List<AlertLog> recentAlerts = alertLogRepository.getRecentAlerts(10);

        return recentAlerts.stream()
                .map(alert -> {
                    String message = alert.getAlertMsg();
                    String iconClass = "bi-bell-fill"; // 기본 아이콘
                    String bgClass = "bg-primary";    // 기본 배경색

                    switch (alert.getAlertType()) {
                        case "EMERGENCY":
                            message = alert.getRecipientName() + " 어르신, 긴급 상황 발생! 확인이 필요합니다.";
                            iconClass = "bi-exclamation-triangle-fill";
                            bgClass = "bg-danger";
                            break;
                        case "CONTACT":
                            message = alert.getRecipientName() + " 어르신에게서 연락 요청이 있습니다.";
                            iconClass = "bi-person-lines-fill";
                            bgClass = "bg-warning";
                            break;
                        default:
                            // 다른 알림 타입 처리 또는 일반 메시지 제공
                            message = alert.getRecipientName() + " 어르신 관련 알림: " + alert.getAlertMsg();
                            break;
                    }

                    return CareTimelineItem.builder()
                            .type(alert.getAlertType())
                            .message(message)
                            .timestamp(alert.getAlertRegdate())
                            .iconClass(iconClass)
                            .bgClass(bgClass)
                            .link("#") // TODO: 알림 상세 페이지 링크가 있다면 연결
                            .build();
                })
                .sorted((a1, a2) -> a2.getTimestamp().compareTo(a1.getTimestamp())) // 최신 순으로 정렬
                .collect(Collectors.toList());
    }

    /**
     * 노약자의 주소 정보를 확인하여 지역별 분포율을 계산합니다.
     * 경기도, 충청북도, 충청남도, 전라남도, 경상북도, 경상남도만 추출합니다.
     * 
     * @return 지역 이름과 노약자 수를 담은 Map (지정된 6개 지역만 포함)
     */
    public Map<String, Long> getSeniorDistributionByProvince() {
        List<Senior> allSeniors = seniorService.getAllSeniors();
        
        // 추출할 지역 목록 (긴 이름부터 우선 매칭하도록 순서 중요)
        List<String> targetProvinces = Arrays.asList(
            "경상남도", "경상북도", "충청남도", "충청북도", "전라남도", "경기도"
        );
        
        // 약칭 매핑 (전체 이름이 매칭되지 않을 경우 사용)
        Map<String, String> shortNameMap = new HashMap<>();
        shortNameMap.put("경기", "경기도");
        shortNameMap.put("충북", "충청북도");
        shortNameMap.put("충남", "충청남도");
        shortNameMap.put("전남", "전라남도");
        shortNameMap.put("경북", "경상북도");
        shortNameMap.put("경남", "경상남도");

        return allSeniors.stream()
                .map(Senior::getRecAddress)
                .filter(address -> address != null && !address.trim().isEmpty())
                .map(address -> {
                    String cleanAddress = address.trim();
                    
                    // 1. 전체 지역명 우선 매칭 (긴 이름부터 검색)
                    for (String province : targetProvinces) {
                        if (cleanAddress.contains(province)) {
                            return province;
                        }
                    }
                    
                    // 2. 약칭으로 매칭 시도
                    for (Map.Entry<String, String> entry : shortNameMap.entrySet()) {
                        if (cleanAddress.contains(entry.getKey())) {
                            return entry.getValue();
                        }
                    }
                    
                    // 3. 매칭되는 지역이 없으면 null 반환 (나중에 필터링)
                    return null;
                })
                .filter(province -> province != null) // 지정된 지역만 포함
                .collect(Collectors.groupingBy(Function.identity(), Collectors.counting()));
    }
}