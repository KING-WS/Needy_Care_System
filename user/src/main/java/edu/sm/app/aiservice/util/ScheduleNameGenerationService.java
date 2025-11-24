package edu.sm.app.aiservice.util;

import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.extern.slf4j.Slf4j;
import org.springframework.ai.chat.client.ChatClient;
import org.springframework.stereotype.Service;

import java.util.Map;

/**
 * 일정명 생성 서비스
 */
@Service
@Slf4j
public class ScheduleNameGenerationService {
    
    private final ChatClient chatClient;
    private final ObjectMapper objectMapper;
    private final AiUtilService aiUtilService;
    
    public ScheduleNameGenerationService(
            ChatClient.Builder chatClientBuilder,
            ObjectMapper objectMapper,
            AiUtilService aiUtilService) {
        this.chatClient = chatClientBuilder.build();
        this.objectMapper = objectMapper;
        this.aiUtilService = aiUtilService;
    }
    
    /**
     * 활동 설명에서 일정명 생성
     */
    public String generateScheduleNameFromActivity(String activity) {
        try {
            String prompt = """
                다음 텍스트에서 일정의 핵심 키워드를 추출하여 간단하고 의미있는 일정명을 만들어주세요.
                
                예시:
                - "요양원과 사람을 만나게 될 날" → "요양원 방문"
                - "공원에 가고 싶어요" → "공원 산책"
                - "도서관에 가서 책을 읽고 싶어요" → "도서관 방문"
                - "친구를 만나서 이야기하고 싶어요" → "친구 만나기"
                
                응답은 반드시 JSON 형식으로만 해주세요:
                {
                  "scheduleName": "일정명"
                }
                
                텍스트: %s
                """.formatted(activity);
            
            String response = chatClient.prompt()
                    .user(prompt)
                    .call()
                    .content();
            
            String json = aiUtilService.extractJson(response);
            Map<String, Object> data = aiUtilService.parseJsonToMap(json);
            
            String name = data.get("scheduleName") != null ? 
                data.get("scheduleName").toString() : activity;
            
            return name;
            
        } catch (Exception e) {
            log.warn("일정명 생성 실패, 원본 사용: {}", activity, e);
            return activity;
        }
    }
}

