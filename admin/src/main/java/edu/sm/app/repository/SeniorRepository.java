package edu.sm.app.repository;

import edu.sm.app.dto.Senior;
import org.apache.ibatis.annotations.Mapper;
import java.util.List;

@Mapper
public interface SeniorRepository {
    List<Senior> selectAllSeniors();
}
