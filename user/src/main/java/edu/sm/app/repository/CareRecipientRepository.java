package edu.sm.app.repository;

import edu.sm.app.dto.CareRecipient;
import edu.sm.common.frame.SmRepository;
import org.apache.ibatis.annotations.Mapper;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
@Mapper
public interface CareRecipientRepository extends SmRepository<CareRecipient, Integer> {
    List<CareRecipient> selectByCustId(Integer custId) throws Exception;
}

