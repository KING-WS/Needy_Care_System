package edu.sm.app.repository;

import edu.sm.app.dto.MapCourse;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import java.util.List;

/**
 * 산책코스(MapCourse) Repository
 * 산책코스 데이터베이스 접근 인터페이스
 */
@Mapper
public interface MapCourseRepository {
    
    /**
     * 전체 산책코스 목록 조회
     * @return 모든 산책코스 목록
     */
    List<MapCourse> selectAll();
    
    /**
     * 특정 산책코스 조회
     * @param courseId 산책코스 ID
     * @return 산책코스 정보
     */
    MapCourse select(@Param("courseId") Integer courseId);
    
    /**
     * 노약자별 산책코스 목록 조회
     * @param recId 노약자 ID
     * @return 해당 노약자의 산책코스 목록
     */
    List<MapCourse> selectByRecId(@Param("recId") Integer recId);
    
    /**
     * 코스 타입별 산책코스 목록 조회
     * @param courseType 코스 타입
     * @return 해당 타입의 산책코스 목록
     */
    List<MapCourse> selectByCourseType(@Param("courseType") String courseType);
    
    /**
     * 산책코스 등록
     * @param mapCourse 산책코스 정보
     * @return 등록된 행 수
     */
    int insert(MapCourse mapCourse);
    
    /**
     * 산책코스 수정
     * @param mapCourse 수정할 산책코스 정보
     * @return 수정된 행 수
     */
    int update(MapCourse mapCourse);
    
    /**
     * 산책코스 삭제 (논리 삭제)
     * @param courseId 산책코스 ID
     * @return 삭제된 행 수
     */
    int delete(@Param("courseId") Integer courseId);
}

