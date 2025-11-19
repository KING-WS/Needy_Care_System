package edu.sm.app.service;

import edu.sm.app.dto.HealthData;
import edu.sm.app.repository.HealthDataRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import java.util.List;

@Service
@Slf4j
@RequiredArgsConstructor
public class HealthDataService {

    private final HealthDataRepository healthDataRepository;

    // recId로 건강 데이터 목록 조회
    public List<HealthData> getHealthDataByRecId(Integer recId) {
        log.info("건강 데이터 목록 조회 - recId: {}", recId);
        return healthDataRepository.selectHealthDataByRecId(recId);
    }

    // recId와 건강 데이터 타입으로 최신 데이터 조회
    public HealthData getLatestHealthDataByType(Integer recId, String healthType) {
        log.info("최신 건강 데이터 조회 - recId: {}, healthType: {}", recId, healthType);
        return healthDataRepository.selectLatestHealthDataByType(recId, healthType);
    }

    // recId와 건강 데이터 타입으로 최근 N개 데이터 조회
    public List<HealthData> getRecentHealthDataByType(Integer recId, String healthType, Integer limit) {
        log.info("최근 건강 데이터 조회 - recId: {}, healthType: {}, limit: {}", recId, healthType, limit);
        return healthDataRepository.selectRecentHealthDataByType(recId, healthType, limit);
    }

    // 건강 데이터 등록
    public void registerHealthData(HealthData healthData) {
        log.info("건강 데이터 등록 - recId: {}, healthType: {}", healthData.getRecId(), healthData.getHealthType());
        int result = healthDataRepository.insertHealthData(healthData);
        if (result <= 0) {
            throw new RuntimeException("건강 데이터 등록 실패");
        }
    }

    // 건강 데이터 수정
    public void updateHealthData(HealthData healthData) {
        log.info("건강 데이터 수정 - healthId: {}", healthData.getHealthId());
        int result = healthDataRepository.updateHealthData(healthData);
        if (result <= 0) {
            throw new RuntimeException("건강 데이터 수정 실패");
        }
    }

    // 건강 데이터 삭제
    public void deleteHealthData(Integer healthId) {
        log.info("건강 데이터 삭제 - healthId: {}", healthId);
        int result = healthDataRepository.deleteHealthData(healthId);
        if (result <= 0) {
            throw new RuntimeException("건강 데이터 삭제 실패");
        }
    }
}

