package edu.sm.app.repository;

import edu.sm.app.dto.HealthData;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import java.util.List;

@Mapper
public interface HealthDataRepository {

    // recId로 건강 데이터 목록 조회
    List<HealthData> selectHealthDataByRecId(@Param("recId") Integer recId);

    // recId와 건강 데이터 타입으로 최신 데이터 조회
    HealthData selectLatestHealthDataByType(@Param("recId") Integer recId, @Param("healthType") String healthType);

    // recId와 건강 데이터 타입으로 최근 N개 데이터 조회
    List<HealthData> selectRecentHealthDataByType(
            @Param("recId") Integer recId, 
            @Param("healthType") String healthType, 
            @Param("limit") Integer limit);

    // 건강 데이터 등록
    int insertHealthData(HealthData healthData);

    // 건강 데이터 수정
    int updateHealthData(HealthData healthData);

    // 건강 데이터 삭제 (논리 삭제)
    int deleteHealthData(@Param("healthId") Integer healthId);
}

