package edu.sm.controller;

import edu.sm.app.dto.MapCourse;
import edu.sm.app.service.MapCourseService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;

/**
 * MapCourse(산책코스) Controller
 * 산책코스 정보 관리를 위한 REST API
 */
@RestController
@RequestMapping("/api/course")
@RequiredArgsConstructor
@Slf4j
public class MapCourseController {

    private final MapCourseService mapCourseService;

    /**
     * 전체 산책코스 목록 조회
     * GET /api/course
     */
    @GetMapping
    public ResponseEntity<java.util.Map<String, Object>> getAllCourses() {
        java.util.Map<String, Object> response = new HashMap<>();
        try {
            List<MapCourse> courses = mapCourseService.getAllCourses();
            response.put("success", true);
            response.put("data", courses);
            response.put("count", courses.size());
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            log.error("전체 산책코스 조회 실패", e);
            response.put("success", false);
            response.put("message", "산책코스 목록 조회 중 오류가 발생했습니다.");
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
        }
    }

    /**
     * 특정 산책코스 조회
     * GET /api/course/{courseId}
     */
    @GetMapping("/{courseId}")
    public ResponseEntity<java.util.Map<String, Object>> getCourse(@PathVariable Integer courseId) {
        java.util.Map<String, Object> response = new HashMap<>();
        try {
            MapCourse course = mapCourseService.getCourseById(courseId);
            if (course != null) {
                response.put("success", true);
                response.put("data", course);
                return ResponseEntity.ok(response);
            } else {
                response.put("success", false);
                response.put("message", "해당 산책코스를 찾을 수 없습니다.");
                return ResponseEntity.status(HttpStatus.NOT_FOUND).body(response);
            }
        } catch (Exception e) {
            log.error("산책코스 조회 실패 - courseId: {}", courseId, e);
            response.put("success", false);
            response.put("message", "산책코스 조회 중 오류가 발생했습니다.");
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
        }
    }

    /**
     * 돌봄대상자별 산책코스 목록 조회
     * GET /api/course/recipient/{recId}
     */
    @GetMapping("/recipient/{recId}")
    public ResponseEntity<java.util.Map<String, Object>> getCoursesByRecipient(@PathVariable Integer recId) {
        java.util.Map<String, Object> response = new HashMap<>();
        try {
            List<MapCourse> courses = mapCourseService.getCoursesByRecId(recId);
            response.put("success", true);
            response.put("data", courses);
            response.put("count", courses.size());
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            log.error("돌봄대상자별 산책코스 조회 실패 - recId: {}", recId, e);
            response.put("success", false);
            response.put("message", "산책코스 목록 조회 중 오류가 발생했습니다.");
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
        }
    }

    /**
     * 코스 타입별 산책코스 목록 조회
     * GET /api/course/type/{courseType}
     */
    @GetMapping("/type/{courseType}")
    public ResponseEntity<java.util.Map<String, Object>> getCoursesByType(@PathVariable String courseType) {
        java.util.Map<String, Object> response = new HashMap<>();
        try {
            List<MapCourse> courses = mapCourseService.getCoursesByType(courseType);
            response.put("success", true);
            response.put("data", courses);
            response.put("count", courses.size());
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            log.error("코스 타입별 산책코스 조회 실패 - courseType: {}", courseType, e);
            response.put("success", false);
            response.put("message", "산책코스 목록 조회 중 오류가 발생했습니다.");
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
        }
    }

    /**
     * 새 산책코스 등록
     * POST /api/course
     */
    @PostMapping
    public ResponseEntity<java.util.Map<String, Object>> createCourse(@RequestBody MapCourse mapCourse) {
        java.util.Map<String, Object> response = new HashMap<>();
        try {
            mapCourseService.registerCourse(mapCourse);
            response.put("success", true);
            response.put("message", "산책코스가 성공적으로 등록되었습니다.");
            response.put("data", mapCourse);
            return ResponseEntity.status(HttpStatus.CREATED).body(response);
        } catch (Exception e) {
            log.error("산책코스 등록 실패", e);
            response.put("success", false);
            response.put("message", "산책코스 등록 중 오류가 발생했습니다.");
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
        }
    }

    /**
     * 산책코스 정보 수정
     * PUT /api/course/{courseId}
     */
    @PutMapping("/{courseId}")
    public ResponseEntity<java.util.Map<String, Object>> updateCourse(
            @PathVariable Integer courseId,
            @RequestBody MapCourse mapCourse
    ) {
        java.util.Map<String, Object> response = new HashMap<>();
        try {
            mapCourse.setCourseId(courseId);
            mapCourseService.updateCourse(mapCourse);
            response.put("success", true);
            response.put("message", "산책코스 정보가 성공적으로 수정되었습니다.");
            response.put("data", mapCourse);
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            log.error("산책코스 수정 실패 - courseId: {}", courseId, e);
            response.put("success", false);
            response.put("message", "산책코스 정보 수정 중 오류가 발생했습니다.");
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
        }
    }

    /**
     * 산책코스 삭제 (논리 삭제)
     * DELETE /api/course/{courseId}
     */
    @DeleteMapping("/{courseId}")
    public ResponseEntity<java.util.Map<String, Object>> deleteCourse(@PathVariable Integer courseId) {
        java.util.Map<String, Object> response = new HashMap<>();
        try {
            mapCourseService.deleteCourse(courseId);
            response.put("success", true);
            response.put("message", "산책코스가 성공적으로 삭제되었습니다.");
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            log.error("산책코스 삭제 실패 - courseId: {}", courseId, e);
            response.put("success", false);
            response.put("message", "산책코스 삭제 중 오류가 발생했습니다.");
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
        }
    }
}

