package edu.sm.app.repository;

import edu.sm.app.dto.Senior;
import org.apache.ibatis.annotations.Mapper;
import java.util.List;
import java.util.Map;

@Mapper
public interface SeniorRepository {
    List<Senior> selectAllSeniors();
    Senior select(int id);
    void insert(Senior senior);
    void update(Senior senior);
    int selectSeniorCount();

    Map<String, Object> getCallDetail(String roomId);
}
