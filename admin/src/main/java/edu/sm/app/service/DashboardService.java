package edu.sm.app.service;

import edu.sm.app.dto.ActivityLogDTO;
import edu.sm.app.repository.ActivityLogRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class DashboardService {

    private final ActivityLogRepository activityLogRepository;

    public List<ActivityLogDTO> getRecentActivities() {
        return activityLogRepository.getRecentActivities();
    }
}
