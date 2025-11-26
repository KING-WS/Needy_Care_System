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
            
            1. 돌봄 조언 요약: 현재 노약자의 상태를 고려했을 때 가장 주의해야 할 점과 돌봄 포인트 (300자 이내)
            2. 영상 검색 키워드: 유튜브 등에서 유용한 돌봄 교육 영상을 찾기 위한 구체적인 검색어 3~5개
            3. 블로그/정보 검색 키워드: 질환 관리, 식단, 생활 수칙 등 유용한 정보를 찾기 위한 검색어 3~5개
            
            응답은 반드시 다음 JSON 형식으로만 제공해주세요:
            {
              "careAdvice": "돌봄 조언 요약 내용",
              "videoKeywords": ["키워드1", "키워드2", "키워드3"],
              "blogKeywords": ["키워드1", "키워드2", "키워드3"]
            }
            
            중요:
            - 검색어는 한국어로 작성해주세요.
            - 병력과 특이사항이 있는 경우 해당 질환 관리에 대한 내용을 우선적으로 포함해주세요.
            - 구체적이고 실용적인 키워드를 제안해주세요 (예: "당뇨병 환자 발 관리", "치매 노인 식사 보조 방법").
            """;

    public AiCareContentService(
            ChatClient.Builder chatClientBuilder,
            AiUtilService aiUtilService) {
        this.chatClient = chatClientBuilder.build();
        this.aiUtilService = aiUtilService;
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

