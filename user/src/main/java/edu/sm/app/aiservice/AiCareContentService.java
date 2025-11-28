package edu.sm.app.aiservice;

import edu.sm.app.aiservice.util.AiUtilService;
import edu.sm.app.dto.Recipient;
import lombok.extern.slf4j.Slf4j;
import org.springframework.ai.chat.client.ChatClient;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.time.Period;
import java.util.HashMap;
import java.util.Map;
import java.util.List;
import java.util.ArrayList;

/**
 * 돌봄 콘텐츠 추천 AI 서비스
 * 노약자의 상태를 분석하여 필요한 영상 및 블로그 키워드를 추천합니다.
 */
@Service
@Slf4j
public class AiCareContentService {

    private final ChatClient chatClient;
    private final AiUtilService aiUtilService;

    private static final String CARE_CONTENT_PROMPT = """
            당신은 노인 돌봄 전문가입니다. 주어진 노약자의 정보를 바탕으로 현재 돌봄에 가장 필요한 교육 영상과 정보를 찾기 위한 검색 키워드를 추천해주세요.
            
            [노약자 정보]
            - 이름: %s
            - 나이: %d세
            - 성별: %s
            - 노약자 유형 코드: %s
            - 병력: %s
            - 알레르기: %s
            - 특이사항: %s
            - 건강 요구사항: %s
            
            위 정보를 종합적으로 분석하여 다음 내용을 제공해주세요:
            
            1. 돌봄 조언: 주의점과 돌봄 포인트 (200자 이내)
            2. 영상 키워드: 돌봄 교육 영상 검색어 3개
            3. 블로그 키워드: 질환/생활 정보 검색어 3개
            4. 혜택 키워드: 정부/공공 혜택 검색어 3개
            
            응답은 JSON 형식으로만:
            {
              "careAdvice": "조언 내용",
              "videoKeywords": ["키워드1", "키워드2", "키워드3"],
              "blogKeywords": ["키워드1", "키워드2", "키워드3"],
              "benefitKeywords": ["키워드1", "키워드2", "키워드3"]
            }
            
            중요:
            - 검색어는 한국어로 작성해주세요.
            - 병력과 특이사항이 있는 경우 해당 질환 관리에 대한 내용을 우선적으로 포함해주세요.
            - 혜택 정보는 정부 지원금, 돌봄 서비스, 의료비 지원 등 실질적인 혜택 위주로 키워드를 선정해주세요.
            - 구체적이고 실용적인 키워드를 제안해주세요 (예: "당뇨병 환자 발 관리", "치매 노인 식사 보조 방법", "2024 노인 장기요양보험 혜택").
            """;

    private static final String BENEFIT_SUMMARY_PROMPT = """
            당신은 노인 복지 전문가입니다. 다음 혜택에 대한 핵심 정보를 요약해주세요.
            
            [혜택 정보]
            - 혜택명: %s
            - 관련 내용: %s
            
            위 정보를 바탕으로 다음 내용을 포함하여 2-3문장으로 명확하게 요약해주세요:
            1. 혜택의 대상 (누가 받을 수 있는지)
            2. 지원 내용 (무엇을 얼마나 지원하는지)
            3. 신청 방법 (어떻게 신청하는지) - 만약 내용에 없다면 일반적인 방법(주민센터 방문 등)을 제안해주세요.
            
            응답은 요약된 텍스트만 제공해주세요.
            """;

    private static final String PLACE_RECOMMEND_PROMPT = """
            당신은 노인 여가 및 건강 전문가입니다. 주어진 노약자 정보를 바탕으로, 해당 어르신에게 도움이 될 만한 **장소(Places)**를 추천해주세요.

            [노약자 정보]
            - 이름: %s
            - 나이: %d세
            - 성별: %s
            - 병력: %s
            - 알레르기: %s
            - 특이사항: %s
            - 주소: %s (이 주소 근처의 장소나 해당 지역을 우선적으로 고려해주세요)

            추천 기준:
            1. 건강 상태(병력, 특이사항)를 고려하여 안전하고 유익한 활동을 추천하세요.
            2. 거동이 불편할 경우 접근성이 좋은 곳을 추천하세요.
            3. 정서적 안정이나 인지 기능 향상에 도움이 되는 문화/여가 활동을 포함하세요.
            4. 장소의 별점이 3.5이상의 장소를 추천해주세요.        
            5. 최소 6개 이상의 장소를 추천해주세요.

            응답은 반드시 JSON 배열 형식으로만 해주세요:
            [
              {
                "mapName": "장소 이름 (검색 가능한 정확한 명칭)",
                "mapContent": "추천 이유 및 활동 내용 요약 (어르신에게 좋은 점)",
                "mapCategory": "카테고리 (예: 공원, 복지관, 문화센터, 병원, 산책로등)",
                "courseType": "코스 타입 (예: 산책, 드라이브, 실내활동, 운동 등)"
              },
              ...
            ]
            """;

    public AiCareContentService(
            ChatClient.Builder chatClientBuilder,
            AiUtilService aiUtilService) {
        this.chatClient = chatClientBuilder.build();
        this.aiUtilService = aiUtilService;
    }

    /**
     * 혜택 정보 AI 요약
     * @param benefitName 혜택명
     * @param description 설명
     * @return 요약된 텍스트
     */
    public String summarizeBenefit(String benefitName, String description) {
        try {
            String prompt = String.format(BENEFIT_SUMMARY_PROMPT, benefitName, description);
            
            log.info("혜택 요약 요청 - benefit: {}", benefitName);
            
            return chatClient.prompt()
                    .user(prompt)
                    .call()
                    .content();
                    
        } catch (Exception e) {
            log.error("혜택 요약 실패", e);
            return "요약을 생성할 수 없습니다.";
        }
    }

    /**
     * 노약자 상태 분석 및 콘텐츠 키워드 추천
     * @param recipient 노약자 정보
     * @return 분석 결과 및 키워드
     */
    public Map<String, Object> analyzeAndRecommend(Recipient recipient) {
        try {
            // 나이 계산
            int age = 0;
            if (recipient.getRecBirthday() != null) {
                age = Period.between(recipient.getRecBirthday(), LocalDate.now()).getYears();
            }

            // 성별 텍스트 변환
            String genderText = "남성";
            if (recipient.getRecGender() != null && recipient.getRecGender().equals("F")) {
                genderText = "여성";
            }

            // 프롬프트 생성
            String prompt = String.format(
                CARE_CONTENT_PROMPT,
                recipient.getRecName() != null ? recipient.getRecName() : "대상자",
                age,
                genderText,
                recipient.getRecTypeCode() != null ? recipient.getRecTypeCode() : "일반",
                recipient.getRecMedHistory() != null ? recipient.getRecMedHistory() : "없음",
                recipient.getRecAllergies() != null ? recipient.getRecAllergies() : "없음",
                recipient.getRecSpecNotes() != null ? recipient.getRecSpecNotes() : "없음",
                recipient.getRecHealthNeeds() != null ? recipient.getRecHealthNeeds() : "없음"
            );

            log.info("돌봄 콘텐츠 추천 프롬프트 생성 완료 - recId: {}", recipient.getRecId());

            // AI 호출
            String aiResponse = chatClient.prompt()
                    .user(prompt)
                    .call()
                    .content();

            log.debug("AI 원본 응답: {}", aiResponse);

            // JSON 추출 (AiUtilService.extractJson은 배열을 우선하므로 직접 객체 추출)
            String json = extractJsonObject(aiResponse);
            
            // JSON 파싱
            Map<String, Object> analysisResult = aiUtilService.parseJsonToMap(json);
            
            // 결과 구성
            Map<String, Object> result = new HashMap<>();
            result.put("success", true);
            result.put("careAdvice", analysisResult.getOrDefault("careAdvice", "조언을 생성할 수 없습니다."));
            result.put("videoKeywords", analysisResult.getOrDefault("videoKeywords", new ArrayList<>()));
            result.put("blogKeywords", analysisResult.getOrDefault("blogKeywords", new ArrayList<>()));
            result.put("benefitKeywords", analysisResult.getOrDefault("benefitKeywords", new ArrayList<>()));

            log.info("돌봄 콘텐츠 분석 완료 - recId: {}", recipient.getRecId());

            return result;

        } catch (Exception e) {
            log.error("돌봄 콘텐츠 분석 실패 - recId: {}", recipient.getRecId(), e);
            Map<String, Object> errorResult = new HashMap<>();
            errorResult.put("success", false);
            errorResult.put("message", "분석 중 오류가 발생했습니다: " + e.getMessage());
            return errorResult;
        }
    }

    /**
     * 노약자 맞춤 장소/행사 추천
     * @param recipient 노약자 정보
     * @return 추천 장소 리스트
     */
    public List<Map<String, Object>> recommendPlaces(Recipient recipient) {
        try {
            // 나이 계산
            int age = 0;
            if (recipient.getRecBirthday() != null) {
                age = Period.between(recipient.getRecBirthday(), LocalDate.now()).getYears();
            }

            // 성별 텍스트 변환
            String genderText = "남성";
            if (recipient.getRecGender() != null && recipient.getRecGender().equals("F")) {
                genderText = "여성";
            }

            String prompt = String.format(
                PLACE_RECOMMEND_PROMPT,
                recipient.getRecName() != null ? recipient.getRecName() : "대상자",
                age,
                genderText,
                recipient.getRecMedHistory() != null ? recipient.getRecMedHistory() : "없음",
                recipient.getRecAllergies() != null ? recipient.getRecAllergies() : "없음",
                recipient.getRecSpecNotes() != null ? recipient.getRecSpecNotes() : "없음",
                recipient.getRecAddress() != null ? recipient.getRecAddress() : "대한민국"
            );

            log.info("장소 추천 프롬프트 생성 완료 - recId: {}", recipient.getRecId());

            String aiResponse = chatClient.prompt()
                    .user(prompt)
                    .call()
                    .content();

            String json = aiUtilService.extractJson(aiResponse);
            return aiUtilService.parseJsonToList(json);

        } catch (Exception e) {
            log.error("장소 추천 실패 - recId: {}", recipient.getRecId(), e);
            return new ArrayList<>();
        }
    }

    /**
     * JSON 객체({ ... })를 우선적으로 추출하는 메서드
     */
    private String extractJsonObject(String text) {
        if (text == null || text.trim().isEmpty()) {
            return "{}";
        }

        // JSON 코드 블록 제거
        text = text.replaceAll("```json\\s*", "").replaceAll("```\\s*", "");
        
        int firstBrace = text.indexOf('{');
        int lastBrace = text.lastIndexOf('}');
        
        if (firstBrace != -1 && lastBrace != -1 && lastBrace > firstBrace) {
            return text.substring(firstBrace, lastBrace + 1);
        }
        
        return "{}";
    }
}

