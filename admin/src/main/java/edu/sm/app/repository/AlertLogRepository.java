package edu.sm.app.repository;

import edu.sm.app.dto.AlertLog;
import org.apache.ibatis.annotations.Mapper;
import org.springframework.stereotype.Repository;

import java.util.List;

@Mapper
@Repository
public interface AlertLogRepository {
    // 알림 저장
    int insert(AlertLog alertLog) throws Exception;


    List<AlertLog> getAlerts() throws Exception;

    // 최신 알림 N개 조회
    List<AlertLog> getRecentAlerts(int limit);

    // 알림 상태 업데이트 (확인 처리)
    int updateCheckStatus(int alertId, String checkStatus);
}