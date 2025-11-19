package edu.sm.mapcourse;

import edu.sm.app.dto.MapCourse;
import edu.sm.app.service.MapCourseService;
import lombok.extern.slf4j.Slf4j;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;

@SpringBootTest
@Slf4j
public class MapCourseInsertTest {
    
    @Autowired
    MapCourseService mapCourseService;

    @Test
    void insertMapCourse() throws Exception {
        // 샘플 코스 데이터 생성
        MapCourse mapCourse = MapCourse.builder()
                .recId(1)  // 돌봄 대상자 ID (실제 존재하는 rec_id 사용)
                .courseName("아산역에서 병원까지")
                .courseType("병원")
                .coursePathData("{\"waypoints\":[{\"lat\":36.789,\"lng\":127.004},{\"lat\":36.790,\"lng\":127.005}]}")
                .build();

        mapCourseService.register(mapCourse);
        log.info("Map Course inserted: {}", mapCourse);
    }

    @Test
    void insertWalkCourse() throws Exception {
        // 산책 코스 샘플
        MapCourse walkCourse = MapCourse.builder()
                .recId(1)
                .courseName("선문대 캠퍼스 산책로")
                .courseType("산책")
                .coursePathData("{\"waypoints\":[{\"lat\":36.789,\"lng\":127.004},{\"lat\":36.788,\"lng\":127.006},{\"lat\":36.790,\"lng\":127.007}]}")
                .build();

        mapCourseService.register(walkCourse);
        log.info("Walk Course inserted: {}", walkCourse);
    }
}

