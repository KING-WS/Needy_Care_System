package edu.sm.app.repository;

import edu.sm.app.dto.Caregiver;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

@Mapper
public interface CareMatchingRepository {
    Caregiver getMatchedCaregiverByRecId(@Param("recId") int recId);
}
