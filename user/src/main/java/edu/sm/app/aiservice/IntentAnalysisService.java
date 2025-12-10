package edu.sm.app.aiservice;

import com.fasterxml.jackson.databind.ObjectMapper;
import edu.sm.app.dto.ChatIntent;
import edu.sm.app.aiservice.util.AiUtilService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.ai.chat.client.ChatClient;
import org.springframework.stereotype.Service;

import java.util.Map;

/**
 * 사용자 메시지의 의도를 분석하는 서비스
 */
@Service
@Slf4j
public class IntentAnalysisService {
    
    private final ChatClient chatClient;
    private final ObjectMapper objectMapper;
    private final AiUtilService aiUtilService;
    
    private static final String INTENT_ANALYSIS_PROMPT = """
            사용자의 메시지를 분석해서 의도를 파악해주세요.
            
            가능한 의도 타입:
            - HEALTH_QUERY: 건강 상태 조회 (예: "내 건강 어때?", "혈압 알려줘", "건강 상태 확인")
            - HEALTH_ANALYSIS: 건강 데이터 분석 (예: "건강 상태 분석해줘", "최근 건강 트렌드 알려줘")
            - RECIPIENT_STATUS: 노약자 상태 조회 (예: "신창영 상태 어때?", "김철수 건강 정보 알려줘", "이영희는 어떤가요?", "홍길동 상태 확인")
            - MEAL_RECOMMEND: 식단 추천 (예: "오늘 식단 추천해줘", "저염식 추천해줘", "식단 추천")
            - MEAL_QUERY: 식단 조회 (예: "오늘 식단 뭐야?", "오늘의 식단 알려줘", "어제 저녁 뭐 먹었어?", "오늘 밥 뭐야?", "식단 알려줘", "오늘 먹을 것 뭐야?")
            - MEAL_SAVE: 식단 저장 확인 (예: "네", "등록해줘", "저장해줘", "좋아", "그렇게 해줘" - 이전 대화에서 식단 추천이 있었을 때)
            - SCHEDULE_CREATE: 일정 등록 (예: "내일 오후 3시 병원 가기", "다음주 월요일 약 먹기", "오늘 오후 2시 약 먹기")
            - SCHEDULE_QUERY: 일정 조회 (예: "오늘 일정 알려줘", "오늘의 일정", "오늘 일정 뭐야?", "이번 주 일정 뭐야?", "일정 확인", "오늘 스케줄", "오늘 할 일")
            - SCHEDULE_RECOMMEND: 일정 추천/생성 (예: "오늘 일정 짜줘", "오늘 일정 추천해줘", "오늘 할 일 정해줘", "오늘 스케줄 만들어줘", "오늘 계획 세워줘")
            - SCHEDULE_SAVE: 일정 저장 확인 (예: "네", "등록해줘", "저장해줘", "좋아" - 이전 대화에서 일정 추천이 있었을 때)
            - WALKING_ROUTE: 산책 경로 추천 (예: "산책 경로 추천해줘", "가까운 산책 코스 알려줘")
            - GENERAL_CHAT: 일반 대화 (위의 의도에 해당하지 않는 모든 대화)
            
            중요: 
            - "오늘의 식단", "오늘 식단", "식단 알려줘", "오늘 밥" 같은 표현은 모두 MEAL_QUERY입니다.
            - "오늘의 일정", "오늘 일정", "오늘 할 일", "오늘 스케줄" 같은 표현은 모두 SCHEDULE_QUERY입니다.
            - "오늘 일정 짜줘", "오늘 일정 추천해줘", "오늘 계획 세워줘" 같은 표현은 모두 SCHEDULE_RECOMMEND입니다.
            - 이전 대화에서 식단 추천이 있었고, 사용자가 "네", "등록해줘" 등으로 응답하면 MEAL_SAVE입니다.
            - 이전 대화에서 일정 추천이 있었고, 사용자가 "네", "등록해줘" 등으로 응답하면 SCHEDULE_SAVE입니다.
            
            응답은 반드시 JSON 형식으로만 해주세요. 다른 설명 없이 JSON만 반환하세요:
            {
              "intent": "의도타입",
              "parameters": {},
              "confidence": 0.9
            }
            
            사용자 메시지: %s
            """;
    
    public IntentAnalysisService(
            ChatClient.Builder chatClientBuilder,
            ObjectMapper objectMapper,
            AiUtilService aiUtilService) {
        this.chatClient = chatClientBuilder.build();
        this.objectMapper = objectMapper;
        this.aiUtilService = aiUtilService;
    }
    
    /**
     * 사용자 메시지의 의도를 분석합니다.
     */
    public ChatIntent analyzeIntent(String userMessage) {
        try {
            String prompt = INTENT_ANALYSIS_PROMPT.formatted(userMessage);
            log.debug("의도 분석 프롬프트: {}", prompt);
            
            String response = chatClient.prompt()
                    .user(prompt)
                    .call()
                    .content();
            
            log.debug("의도 분석 원본 응답: {}", response);
            
            // JSON 추출
            String json = aiUtilService.extractJson(response);
            log.debug("추출된 JSON: {}", json);
            
            // JSON 파싱
            Map<String, Object> intentMap = aiUtilService.parseJsonToMap(json);
            
            ChatIntent intent = new ChatIntent();
            String intentType = intentMap.get("intent") != null ? 
                    intentMap.get("intent").toString() : "GENERAL_CHAT";
            intent.setIntent(intentType);
            
            Object paramsObj = intentMap.get("parameters");
            String paramsJson = "{}";
            if (paramsObj != null) {
                if (paramsObj instanceof String) {
                    paramsJson = (String) paramsObj;
                } else {
                    paramsJson = objectMapper.writeValueAsString(paramsObj);
                }
            }
            intent.setParameters(paramsJson);
            
            Object confObj = intentMap.get("confidence");
            double confidence = 0.5;
            if (confObj != null) {
                if (confObj instanceof Number) {
                    confidence = ((Number) confObj).doubleValue();
                } else {
                    try {
                        confidence = Double.parseDouble(confObj.toString());
                    } catch (NumberFormatException e) {
                        confidence = 0.5;
                    }
                }
            }
            intent.setConfidence(confidence);
            
            return intent;
        } catch (Exception e) {
            log.error("의도 분석 실패", e);
            // 기본값: 일반 대화
            return new ChatIntent("GENERAL_CHAT", "{}", 0.5);
        }
    }
}





