package edu.sm.app.repository;

import edu.sm.app.dto.Recipient;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import java.util.List;

@Mapper
public interface RecipientRepository {

    // custId로 돌봄 대상자 목록 조회
    List<Recipient> selectRecipientsByCustId(@Param("custId") Integer custId);

    // recId로 특정 돌봄 대상자 조회
    Recipient selectRecipientById(@Param("recId") Integer recId);
}