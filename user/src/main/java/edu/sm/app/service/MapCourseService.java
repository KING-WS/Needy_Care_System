package edu.sm.app.service;

import edu.sm.app.dto.MapCourse;
import edu.sm.app.repository.MapCourseRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * 산책코스(MapCourse) Service
 * 산책코스 정보에 대한 비즈니스 로직 처리
 */
@Service
@RequiredArgsConstructor
@Slf4j
public class MapCourseService {

    private final MapCourseRepository mapCourseRepository;

    /**
     * 전체 산책코스 목록 조회
     * @return 모든 산책코스 목록
     */
    public List<MapCourse> getAllCourses() {
        log.info("전체 산책코스 목록 조회");
        return mapCourseRepository.selectAll();
    }

    /**
     * 특정 산책코스 조회
     * @param courseId 산책코스 ID
     * @return 산책코스 정보
     */
    public MapCourse getCourseById(Integer courseId) {
        log.info("산책코스 조회 - courseId: {}", courseId);
        return mapCourseRepository.select(courseId);
    }

    /**
     * 노약자별 산책코스 목록 조회
     * @param recId 노약자 ID
     * @return 해당 노약자의 산책코스 목록
     */
    public List<MapCourse> getCoursesByRecId(Integer recId) {
        log.info("노약자별 산책코스 목록 조회 - recId: {}", recId);
        return mapCourseRepository.selectByRecId(recId);
    }

    /**
     * 코스 타입별 산책코스 목록 조회
     * @param courseType 코스 타입 (예: 산책, 병원경로 등)
     * @return 해당 타입의 산책코스 목록
     */
    public List<MapCourse> getCoursesByType(String courseType) {
        log.info("코스 타입별 산책코스 목록 조회 - courseType: {}", courseType);
        return mapCourseRepository.selectByCourseType(courseType);
    }

    /**
     * 산책코스 등록
     * @param mapCourse 산책코스 정보
     */
    public void registerCourse(MapCourse mapCourse) {
        log.info("산책코스 등록 - courseName: {}, recId: {}", mapCourse.getCourseName(), mapCourse.getRecId());
        int result = mapCourseRepository.insert(mapCourse);
        if (result <= 0) {
            throw new RuntimeException("산책코스 등록 실패");
        }
        log.info("산책코스 등록 성공 - courseId: {}", mapCourse.getCourseId());
    }

    /**
     * 산책코스 수정
     * @param mapCourse 수정할 산책코스 정보
     */
    public void updateCourse(MapCourse mapCourse) {
        log.info("산책코스 수정 - courseId: {}, courseName: {}", mapCourse.getCourseId(), mapCourse.getCourseName());
        int result = mapCourseRepository.update(mapCourse);
        if (result <= 0) {
            throw new RuntimeException("산책코스 수정 실패");
        }
    }

    /**
     * 산책코스 삭제 (논리 삭제)
     * @param courseId 산책코스 ID
     */
    public void deleteCourse(Integer courseId) {
        log.info("산책코스 삭제 - courseId: {}", courseId);
        int result = mapCourseRepository.delete(courseId);
        if (result <= 0) {
            throw new RuntimeException("산책코스 삭제 실패");
        }
    }
}

