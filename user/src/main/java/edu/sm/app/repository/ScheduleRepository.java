package edu.sm.app.repository;

import edu.sm.app.dto.Schedule;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import java.util.List;

@Mapper
public interface ScheduleRepository {

    // Schedule CRUD
    List<Schedule> selectSchedulesByRecId(@Param("recId") Integer recId);

    List<Schedule> selectSchedulesByRecIdAndMonth(
            @Param("recId") Integer recId,
            @Param("year") int year,
            @Param("month") int month
    );

    Schedule selectScheduleById(@Param("schedId") Integer schedId);

    int insertSchedule(Schedule schedule);

    int updateSchedule(Schedule schedule);

    int deleteSchedule(@Param("schedId") Integer schedId);
}