package edu.sm.app.repository;

import edu.sm.app.dto.AlertLog;
import org.apache.ibatis.annotations.Mapper;
import org.springframework.stereotype.Repository;

@Mapper
@Repository
public interface AlertLogRepository {
    // 알림 저장
    int insert(AlertLog alertLog) throws Exception;
}