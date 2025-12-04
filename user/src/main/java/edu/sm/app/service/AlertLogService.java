package edu.sm.app.service;

import edu.sm.app.dto.AlertLog;
import edu.sm.app.repository.AlertLogRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class AlertLogService {
    private final AlertLogRepository alertLogRepository;

    public void register(AlertLog alertLog) throws Exception {
        alertLogRepository.insert(alertLog);
    }
}