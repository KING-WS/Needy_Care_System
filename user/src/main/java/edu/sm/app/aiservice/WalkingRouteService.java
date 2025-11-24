package edu.sm.app.aiservice;

import edu.sm.app.dto.MapCourse;
import edu.sm.app.service.MapCourseService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * 산책 경로 추천 서비스
 */
@Service
@Slf4j
public class WalkingRouteService {
    
    private final MapCourseService mapCourseService;
    
    public WalkingRouteService(MapCourseService mapCourseService) {
        this.mapCourseService = mapCourseService;
    }
    
    /**
     * 산책 경로 추천
     */
    public String recommendWalkingRoute(Integer recId) {
        try {
            List<MapCourse> courses = mapCourseService.getCoursesByRecId(recId);
            if (courses == null || courses.isEmpty()) {
                return "등록된 산책 코스가 없어요. 먼저 산책 코스를 등록해주세요.";
            }
            
            StringBuilder sb = new StringBuilder();
            sb.append("추천 산책 코스예요:\n");
            
            for (MapCourse course : courses) {
                sb.append(String.format("- %s (타입: %s)\n",
                        course.getCourseName(),
                        course.getCourseType() != null ? course.getCourseType() : "일반"));
            }
            
            return sb.toString();
        } catch (Exception e) {
            log.error("산책 코스 조회 실패", e);
            return "산책 코스를 조회하는 중 문제가 발생했어요.";
        }
    }
}

