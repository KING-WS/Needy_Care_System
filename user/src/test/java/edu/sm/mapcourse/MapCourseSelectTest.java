package edu.sm.mapcourse;

import edu.sm.app.dto.MapCourse;
import edu.sm.app.service.MapCourseService;
import lombok.extern.slf4j.Slf4j;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;

import java.util.List;

@SpringBootTest
@Slf4j
public class MapCourseSelectTest {
    
    @Autowired
    MapCourseService mapCourseService;

    @Test
    void selectAll() throws Exception {
        List<MapCourse> courses = mapCourseService.get();
        log.info("Total courses: {}", courses.size());
        for (MapCourse course : courses) {
            log.info("Course: {}", course);
        }
    }

    @Test
    void selectByRecId() throws Exception {
        Integer recId = 1;
        List<MapCourse> courses = mapCourseService.getByRecId(recId);
        log.info("Courses for rec_id {}: {}", recId, courses.size());
        for (MapCourse course : courses) {
            log.info("Course: {}", course);
        }
    }

    @Test
    void selectByCourseType() throws Exception {
        String courseType = "산책";
        List<MapCourse> courses = mapCourseService.getByCourseType(courseType);
        log.info("Courses of type '{}': {}", courseType, courses.size());
        for (MapCourse course : courses) {
            log.info("Course: {}", course);
        }
    }

    @Test
    void selectOne() throws Exception {
        Integer courseId = 1;
        MapCourse course = mapCourseService.get(courseId);
        if (course != null) {
            log.info("Course found: {}", course);
        } else {
            log.info("Course not found with id: {}", courseId);
        }
    }
}

