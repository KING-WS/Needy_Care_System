package edu.sm.app.service;

import edu.sm.app.dto.AlertLog;
import edu.sm.app.repository.AlertLogRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@RequiredArgsConstructor
public class AlertLogService {
    private final AlertLogRepository alertLogRepository;

    @Transactional
    public void register(AlertLog alertLog) throws Exception {
        alertLogRepository.insert(alertLog);
    }

    // 관리자 페이지 접속 시 호출되는 메서드
    @Transactional(readOnly = true)
    public List<AlertLog> findAllAlerts() {
        try {
            return alertLogRepository.getAlerts();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    @Transactional
    public void markAsChecked(int alertId) {
        alertLogRepository.updateCheckStatus(alertId, "Y");
    }
}