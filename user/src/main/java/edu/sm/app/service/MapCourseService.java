package edu.sm.app.service;

import edu.sm.app.dto.MapCourse;
import edu.sm.app.repository.MapCourseRepository;
import edu.sm.common.frame.SmService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class MapCourseService implements SmService<MapCourse, Integer> {

    final MapCourseRepository mapCourseRepository;

    @Override
    public void register(MapCourse mapCourse) throws Exception {
        mapCourseRepository.insert(mapCourse);
    }

    @Override
    public void modify(MapCourse mapCourse) throws Exception {
        mapCourseRepository.update(mapCourse);
    }

    @Override
    public void remove(Integer courseId) throws Exception {
        mapCourseRepository.delete(courseId);
    }

    @Override
    public List<MapCourse> get() throws Exception {
        return mapCourseRepository.selectAll();
    }

    @Override
    public MapCourse get(Integer courseId) throws Exception {
        return mapCourseRepository.select(courseId);
    }

    // 돌봄 대상자별 코스 목록 조회
    public List<MapCourse> getByRecId(Integer recId) throws Exception {
        return mapCourseRepository.selectByRecId(recId);
    }

    // 코스 타입별 조회
    public List<MapCourse> getByCourseType(String courseType) throws Exception {
        return mapCourseRepository.selectByCourseType(courseType);
    }
}

