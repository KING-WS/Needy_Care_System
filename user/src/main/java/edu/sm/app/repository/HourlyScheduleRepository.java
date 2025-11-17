package edu.sm.app.repository;

import edu.sm.app.dto.HourlySchedule;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import java.util.List;

@Mapper
public interface HourlyScheduleRepository {

    // HourlySchedule CRUD
    List<HourlySchedule> selectHourlySchedulesBySchedId(@Param("schedId") Integer schedId);

    HourlySchedule selectHourlyScheduleById(@Param("hourlySchedId") Integer hourlySchedId);

    int insertHourlySchedule(HourlySchedule hourlySchedule);

    int updateHourlySchedule(HourlySchedule hourlySchedule);

    int deleteHourlySchedule(@Param("hourlySchedId") Integer hourlySchedId);

    int deleteHourlySchedulesBySchedId(@Param("schedId") Integer schedId);
}