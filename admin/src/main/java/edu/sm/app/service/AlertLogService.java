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

    @Transactional(readOnly = true)
    public List<AlertLog> findAllAlerts() {
        return alertLogRepository.findAll();
    }

    @Transactional
    public void markAsChecked(int alertId) {
        // 'Y'는 확인됨을 의미
        alertLogRepository.updateCheckStatus(alertId, "Y");
    }
}