package edu.sm.app.repository;

import edu.sm.app.dto.Caregiver;
import org.apache.ibatis.annotations.Mapper;
import java.util.List;

@Mapper
public interface CaregiverRepository {
    List<Caregiver> selectAllCaregivers();
    Caregiver select(int id);
    void insert(Caregiver caregiver);
    void update(Caregiver caregiver);
    int selectCaregiverCount();
}