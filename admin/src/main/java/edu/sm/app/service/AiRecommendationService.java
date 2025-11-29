package edu.sm.app.service;

import edu.sm.app.dto.Caregiver;
import edu.sm.app.dto.Senior;
import lombok.AllArgsConstructor;
import lombok.Getter;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.stream.Collectors;

@Service
public class AiRecommendationService {

    /**
     * AI 추천 로직을 흉내 내는 간단한 규칙 기반 추천 메서드
     * @param senior 추천 대상자
     * @param availableCaregivers 추천 가능한 요양사 목록
     * @return 추천 순으로 정렬된 요양사 목록
     */
    public List<Caregiver> getRecommendations(Senior senior, List<Caregiver> availableCaregivers) {
        if (senior == null || availableCaregivers == null || availableCaregivers.isEmpty()) {
            return Collections.emptyList();
        }

        List<ScoredCaregiver> scoredCaregivers = new ArrayList<>();

        for (Caregiver caregiver : availableCaregivers) {
            int score = 0;

            // 1. 전문 분야와 특이사항 매칭 (가장 높은 점수)
            if (StringUtils.hasText(caregiver.getCaregiverSpecialties()) && StringUtils.hasText(senior.getRecSpecNotes())) {
                String[] seniorNotes = senior.getRecSpecNotes().split("[,\\s]+");
                for (String note : seniorNotes) {
                    if (caregiver.getCaregiverSpecialties().contains(note)) {
                        score += 10;
                    }
                }
            }
            
            // 2. 건강 요구사항과 전문 분야 매칭
            if (StringUtils.hasText(caregiver.getCaregiverSpecialties()) && StringUtils.hasText(senior.getRecHealthNeeds())) {
                String[] healthNeeds = senior.getRecHealthNeeds().split("[,\\s]+");
                for (String need : healthNeeds) {
                    if (caregiver.getCaregiverSpecialties().contains(need)) {
                        score += 8;
                    }
                }
            }

            // 3. 주소 매칭 (간단히 첫 단어만 비교)
            if (StringUtils.hasText(caregiver.getCaregiverAddress()) && StringUtils.hasText(senior.getRecAddress())) {
                String caregiverCity = caregiver.getCaregiverAddress().split(" ")[0];
                String seniorCity = senior.getRecAddress().split(" ")[0];
                if (caregiverCity.equals(seniorCity)) {
                    score += 5;
                }
            }

            scoredCaregivers.add(new ScoredCaregiver(caregiver, score));
        }

        // 점수가 높은 순으로 정렬, 점수가 같으면 ID 순으로 정렬
        Collections.sort(scoredCaregivers);

        // 정렬된 리스트에서 Caregiver 객체만 추출하여 반환
        return scoredCaregivers.stream()
                .map(ScoredCaregiver::getCaregiver)
                .collect(Collectors.toList());
    }

    /**
     * 추천 점수를 포함하는 내부 DTO 클래스
     */
    @Getter
    @AllArgsConstructor
    private static class ScoredCaregiver implements Comparable<ScoredCaregiver> {
        private Caregiver caregiver;
        private int score;

        @Override
        public int compareTo(ScoredCaregiver other) {
            // 점수가 높은 순으로 정렬
            int scoreCompare = Integer.compare(other.score, this.score);
            if (scoreCompare == 0) {
                // 점수가 같으면 caregiverId 오름차순으로 정렬
                return Integer.compare(this.caregiver.getCaregiverId(), other.caregiver.getCaregiverId());
            }
            return scoreCompare;
        }
    }
}
