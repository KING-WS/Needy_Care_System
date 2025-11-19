package edu.sm.app.repository;

import edu.sm.app.dto.MapCourse;
import edu.sm.common.frame.SmRepository;
import org.apache.ibatis.annotations.Mapper;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
@Mapper
public interface MapCourseRepository extends SmRepository<MapCourse, Integer> {
    // rec_id로 코스 목록 조회 (돌봄 대상자별 코스)
    List<MapCourse> selectByRecId(Integer recId) throws Exception;
    
    // 코스 타입별 조회 (예: 산책코스, 병원경로 등)
    List<MapCourse> selectByCourseType(String courseType) throws Exception;
}

