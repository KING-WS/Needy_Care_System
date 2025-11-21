package edu.sm.app.service;

import edu.sm.app.dto.Schedule;
import edu.sm.app.dto.HourlySchedule;
import edu.sm.app.repository.ScheduleRepository;
import edu.sm.app.repository.HourlyScheduleRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.util.List;

@Slf4j
@Service
@RequiredArgsConstructor
public class ScheduleService {

    private final ScheduleRepository scheduleRepository;
    private final HourlyScheduleRepository hourlyScheduleRepository;

    // ========== Schedule 조회 ==========

    /**
     * 특정 돌봄 대상자의 모든 일정 조회
     */
    public List<Schedule> getSchedulesByRecId(Integer recId) {
        log.debug("일정 조회 - recId: {}", recId);
        return scheduleRepository.selectSchedulesByRecId(recId);
    }

    /**
     * 특정 돌봄 대상자의 월별 일정 조회
     */
    public List<Schedule> getSchedulesByMonth(Integer recId, int year, int month) {
        log.debug("월별 일정 조회 - recId: {}, year: {}, month: {}", recId, year, month);
        List<Schedule> schedules = scheduleRepository.selectSchedulesByRecIdAndMonth(recId, year, month);
        log.debug("조회된 일정 개수: {}", schedules != null ? schedules.size() : 0);
        return schedules;
    }

    /**
     * 특정 돌봄 대상자의 날짜 범위 일정 조회
     */
    public List<Schedule> getSchedulesByDateRange(Integer recId, LocalDate startDate, LocalDate endDate) {
        log.debug("날짜 범위 일정 조회 - recId: {}, startDate: {}, endDate: {}", recId, startDate, endDate);
        List<Schedule> schedules = scheduleRepository.selectSchedulesByDateRange(recId, startDate, endDate);
        log.debug("조회된 일정 개수: {}", schedules != null ? schedules.size() : 0);
        return schedules;
    }

    /**
     * 일정 ID로 특정 일정 조회
     */
    public Schedule getScheduleById(Integer schedId) {
        log.debug("일정 단건 조회 - schedId: {}", schedId);
        Schedule schedule = scheduleRepository.selectScheduleById(schedId);
        if (schedule == null) {
            log.warn("일정을 찾을 수 없음 - schedId: {}", schedId);
        }
        return schedule;
    }

    // ========== Schedule 등록/수정/삭제 ==========

    /**
     * 일정 등록
     */
    @Transactional
    public int createSchedule(Schedule schedule) {
        log.info("일정 등록 - recId: {}, schedName: {}, schedDate: {}",
                schedule.getRecId(), schedule.getSchedName(), schedule.getSchedDate());

        // 기본값 설정
        if (schedule.getIsDeleted() == null) {
            schedule.setIsDeleted("N");
        }

        int result = scheduleRepository.insertSchedule(schedule);

        if (result > 0) {
            log.info("일정 등록 성공 - schedId: {}", schedule.getSchedId());
        } else {
            log.error("일정 등록 실패 - schedule: {}", schedule);
        }

        return result;
    }

    /**
     * 일정 수정
     */
    @Transactional
    public int updateSchedule(Schedule schedule) {
        log.info("일정 수정 - schedId: {}, schedName: {}",
                schedule.getSchedId(), schedule.getSchedName());

        int result = scheduleRepository.updateSchedule(schedule);

        if (result > 0) {
            log.info("일정 수정 성공 - schedId: {}", schedule.getSchedId());
        } else {
            log.warn("일정 수정 실패 또는 변경사항 없음 - schedId: {}", schedule.getSchedId());
        }

        return result;
    }

    /**
     * 일정 삭제 (시간대별 일정도 함께 삭제)
     */
    @Transactional
    public int deleteSchedule(Integer schedId) {
        log.info("일정 삭제 시작 - schedId: {}", schedId);

        try {
            // 1. 먼저 시간대별 일정 삭제
            int hourlyDeleted = hourlyScheduleRepository.deleteHourlySchedulesBySchedId(schedId);
            log.info("시간대별 일정 삭제 완료 - schedId: {}, 삭제된 개수: {}", schedId, hourlyDeleted);

            // 2. 일정 삭제
            int result = scheduleRepository.deleteSchedule(schedId);

            if (result > 0) {
                log.info("일정 삭제 성공 - schedId: {}", schedId);
            } else {
                log.warn("일정 삭제 실패 - schedId: {}", schedId);
            }

            return result;
        } catch (Exception e) {
            log.error("일정 삭제 중 오류 발생 - schedId: {}", schedId, e);
            throw e;
        }
    }

    // ========== HourlySchedule 조회 ==========

    /**
     * 특정 일정의 시간대별 일정 목록 조회
     */
    public List<HourlySchedule> getHourlySchedulesBySchedId(Integer schedId) {
        log.debug("시간대별 일정 조회 - schedId: {}", schedId);
        List<HourlySchedule> hourlySchedules = hourlyScheduleRepository.selectHourlySchedulesBySchedId(schedId);
        log.debug("조회된 시간대별 일정 개수: {}", hourlySchedules != null ? hourlySchedules.size() : 0);
        return hourlySchedules;
    }

    /**
     * 시간대별 일정 ID로 단건 조회
     */
    public HourlySchedule getHourlyScheduleById(Integer hourlySchedId) {
        log.debug("시간대별 일정 단건 조회 - hourlySchedId: {}", hourlySchedId);
        HourlySchedule hourlySchedule = hourlyScheduleRepository.selectHourlyScheduleById(hourlySchedId);
        if (hourlySchedule == null) {
            log.warn("시간대별 일정을 찾을 수 없음 - hourlySchedId: {}", hourlySchedId);
        }
        return hourlySchedule;
    }

    // ========== HourlySchedule 등록/수정/삭제 ==========

    /**
     * 시간대별 일정 등록
     */
    @Transactional
    public int createHourlySchedule(HourlySchedule hourlySchedule) {
        log.info("시간대별 일정 등록 - schedId: {}, hourlySchedName: {}",
                hourlySchedule.getSchedId(), hourlySchedule.getHourlySchedName());

        // 기본값 설정
        if (hourlySchedule.getIsDeleted() == null) {
            hourlySchedule.setIsDeleted("N");
        }

        int result = hourlyScheduleRepository.insertHourlySchedule(hourlySchedule);

        if (result > 0) {
            log.info("시간대별 일정 등록 성공 - hourlySchedId: {}", hourlySchedule.getHourlySchedId());
        } else {
            log.error("시간대별 일정 등록 실패 - hourlySchedule: {}", hourlySchedule);
        }

        return result;
    }

    /**
     * 시간대별 일정 수정
     */
    @Transactional
    public int updateHourlySchedule(HourlySchedule hourlySchedule) {
        log.info("시간대별 일정 수정 - hourlySchedId: {}",
                hourlySchedule.getHourlySchedId());

        int result = hourlyScheduleRepository.updateHourlySchedule(hourlySchedule);

        if (result > 0) {
            log.info("시간대별 일정 수정 성공 - hourlySchedId: {}", hourlySchedule.getHourlySchedId());
        } else {
            log.warn("시간대별 일정 수정 실패 또는 변경사항 없음 - hourlySchedId: {}",
                    hourlySchedule.getHourlySchedId());
        }

        return result;
    }

    /**
     * 시간대별 일정 삭제
     */
    @Transactional
    public int deleteHourlySchedule(Integer hourlySchedId) {
        log.info("시간대별 일정 삭제 - hourlySchedId: {}", hourlySchedId);

        int result = hourlyScheduleRepository.deleteHourlySchedule(hourlySchedId);

        if (result > 0) {
            log.info("시간대별 일정 삭제 성공 - hourlySchedId: {}", hourlySchedId);
        } else {
            log.warn("시간대별 일정 삭제 실패 - hourlySchedId: {}", hourlySchedId);
        }

        return result;
    }
}