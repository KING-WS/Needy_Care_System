package edu.sm.app.service;

import edu.sm.app.dto.CareMatching;
import edu.sm.app.dto.Caregiver;
import edu.sm.app.dto.Senior;
import edu.sm.app.repository.CareMatchingRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@RequiredArgsConstructor
public class CareMatchingService {

    private final CareMatchingRepository careMatchingRepository;

    /**
     * 현재 매칭된 모든 쌍을 가져옵니다.
     * @return 매칭 정보 리스트
     */
    public List<CareMatching> getMatchedPairs() {
        return careMatchingRepository.selectMatchedPairs();
    }

    /**
     * 매칭되지 않은 모든 수급자를 가져옵니다.
     * @return 수급자 정보 리스트
     */
    public List<Senior> getUnassignedSeniors() {
        return careMatchingRepository.selectUnassignedSeniors();
    }

    /**
     * 매칭되지 않은 모든 요양사를 가져옵니다.
     * @return 요양사 정보 리스트
     */
    public List<Caregiver> getUnassignedCaregivers() {
        return careMatchingRepository.selectUnassignedCaregivers();
    }

    /**
     * 새로운 매칭을 생성합니다.
     * @param careMatching 생성할 매칭 정보
     */
    @Transactional
    public void createMatch(CareMatching careMatching) {
        careMatchingRepository.insertMatch(careMatching);
    }

    /**
     * 기존 매칭을 삭제(비활성화)합니다.
     * @param matchingId 삭제할 매칭 ID
     */
    @Transactional
    public void removeMatch(int matchingId) {
        careMatchingRepository.deleteMatch(matchingId);
    }
}
