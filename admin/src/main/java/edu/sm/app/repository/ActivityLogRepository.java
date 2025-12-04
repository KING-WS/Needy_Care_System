package edu.sm.app.repository;

import edu.sm.app.dto.ActivityLogDTO;
import org.apache.ibatis.annotations.Mapper;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
@Mapper
public interface ActivityLogRepository {
    List<ActivityLogDTO> getRecentActivities();
}
