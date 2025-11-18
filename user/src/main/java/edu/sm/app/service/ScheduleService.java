package edu.sm.app.service;

import edu.sm.app.dto.Schedule;
import edu.sm.app.dto.HourlySchedule;
import edu.sm.app.repository.ScheduleRepository;
import edu.sm.app.repository.HourlyScheduleRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.util.List;

@Service
@RequiredArgsConstructor
public class ScheduleService {

    private final ScheduleRepository scheduleRepository;
    private final HourlyScheduleRepository hourlyScheduleRepository;

    // Schedule 조회
    public List<Schedule> getSchedulesByRecId(Integer recId) {
        return scheduleRepository.selectSchedulesByRecId(recId);
    }

    public List<Schedule> getSchedulesByMonth(Integer recId, int year, int month) {
        return scheduleRepository.selectSchedulesByRecIdAndMonth(recId, year, month);
    }

    public Schedule getScheduleById(Integer schedId) {
        return scheduleRepository.selectScheduleById(schedId);
    }

    // Schedule 등록
    @Transactional
    public int createSchedule(Schedule schedule) {
        schedule.setIsDeleted("N");
        return scheduleRepository.insertSchedule(schedule);
    }

    // Schedule 수정
    @Transactional
    public int updateSchedule(Schedule schedule) {
        return scheduleRepository.updateSchedule(schedule);
    }

    // Schedule 삭제 (시간대별 일정도 함께 삭제)
    @Transactional
    public int deleteSchedule(Integer schedId) {
        // 먼저 시간대별 일정 삭제
        hourlyScheduleRepository.deleteHourlySchedulesBySchedId(schedId);
        // 그 다음 일정 삭제
        return scheduleRepository.deleteSchedule(schedId);
    }

    // HourlySchedule 조회
    public List<HourlySchedule> getHourlySchedulesBySchedId(Integer schedId) {
        return hourlyScheduleRepository.selectHourlySchedulesBySchedId(schedId);
    }

    public HourlySchedule getHourlyScheduleById(Integer hourlySchedId) {
        return hourlyScheduleRepository.selectHourlyScheduleById(hourlySchedId);
    }

    // HourlySchedule 등록
    @Transactional
    public int createHourlySchedule(HourlySchedule hourlySchedule) {
        hourlySchedule.setIsDeleted("N");
        return hourlyScheduleRepository.insertHourlySchedule(hourlySchedule);
    }

    // HourlySchedule 수정
    @Transactional
    public int updateHourlySchedule(HourlySchedule hourlySchedule) {
        return hourlyScheduleRepository.updateHourlySchedule(hourlySchedule);
    }

    // HourlySchedule 삭제
    @Transactional
    public int deleteHourlySchedule(Integer hourlySchedId) {
        return hourlyScheduleRepository.deleteHourlySchedule(hourlySchedId);
    }
}