package edu.sm.app.aiservice;

import edu.sm.app.dto.HealthData;
import edu.sm.app.service.HealthDataService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.time.format.DateTimeFormatter;
import java.util.List;

/**
 * 건강 데이터 조회 및 분석 서비스
 */
@Service
@Slf4j
public class HealthQueryService {
    
    private final HealthDataService healthDataService;
    
    public HealthQueryService(HealthDataService healthDataService) {
        this.healthDataService = healthDataService;
    }
    
    /**
     * 건강 상태 조회
     */
    public String queryHealth(Integer recId) {
        try {
            List<HealthData> healthDataList = healthDataService.getHealthDataByRecId(recId);
            if (healthDataList == null || healthDataList.isEmpty()) {
                return "아직 건강 데이터가 등록되지 않았어요. 건강 데이터를 먼저 등록해주세요.";
            }
            
            HealthData latest = healthDataList.get(0);
            String healthType = latest.getHealthType();
            String value1 = latest.getHealthValue1() != null ? latest.getHealthValue1().toString() : "-";
            String value2 = latest.getHealthValue2() != null ? latest.getHealthValue2().toString() : "-";
            String measuredAt = latest.getHealthMeasuredAt() != null ? 
                    latest.getHealthMeasuredAt().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm")) : "-";
            
            return String.format("최근 건강 데이터를 확인했어요.\n" +
                    "종류: %s\n" +
                    "값1: %s\n" +
                    "값2: %s\n" +
                    "측정 시간: %s", healthType, value1, value2, measuredAt);
        } catch (Exception e) {
            log.error("건강 상태 조회 실패", e);
            return "건강 데이터를 조회하는 중 문제가 발생했어요.";
        }
    }
    
    /**
     * 건강 데이터 분석
     */
    public String analyzeHealth(Integer recId) {
        try {
            List<HealthData> healthDataList = healthDataService.getHealthDataByRecId(recId);
            if (healthDataList == null || healthDataList.isEmpty()) {
                return "아직 건강 데이터가 등록되지 않았어요. 건강 데이터를 먼저 등록해주세요.";
            }
            
            // 최근 10개 데이터 분석
            int count = Math.min(10, healthDataList.size());
            StringBuilder analysis = new StringBuilder("최근 " + count + "개의 건강 데이터를 분석했어요:\n\n");
            
            for (int i = 0; i < count; i++) {
                HealthData data = healthDataList.get(i);
                String measuredAt = data.getHealthMeasuredAt() != null ? 
                        data.getHealthMeasuredAt().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm")) : "-";
                String value1 = data.getHealthValue1() != null ? data.getHealthValue1().toString() : "-";
                String value2 = data.getHealthValue2() != null ? data.getHealthValue2().toString() : "-";
                
                analysis.append(String.format("%d. %s - 값1: %s, 값2: %s (%s)\n", 
                        i + 1, data.getHealthType(), value1, value2, measuredAt));
            }
            
            return analysis.toString();
        } catch (Exception e) {
            log.error("건강 데이터 분석 실패", e);
            return "건강 데이터를 분석하는 중 문제가 발생했어요.";
        }
    }
}

