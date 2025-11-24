package edu.sm.app.repository;

import edu.sm.app.dto.CareMatching;
import edu.sm.app.dto.Caregiver;
import edu.sm.app.dto.Senior;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface CareMatchingRepository {

    /**
     * 현재 매칭되어 있는 요양사-수급자 목록을 조회합니다.
     * @return CareMatching 리스트
     */
    List<CareMatching> selectMatchedPairs();

    /**
     * 아직 매칭되지 않은 수급자(어르신) 목록을 조회합니다.
     * @return Senior 리스트
     */
    List<Senior> selectUnassignedSeniors();

    /**
     * 아직 매칭되지 않은 요양사 목록을 조회합니다.
     * @return Caregiver 리스트
     */
    List<Caregiver> selectUnassignedCaregivers();

    /**
     * 새로운 요양사-수급자 매칭을 생성합니다.
     * @param careMatching 매칭 정보
     */
    void insertMatch(CareMatching careMatching);

    /**
     * 기존 매칭을 비활성화(소프트 삭제)합니다.
     * @param matchingId 비활성화할 매칭 ID
     */
    void deleteMatch(@Param("matchingId") int matchingId);
}
