package edu.sm.app.service;

import edu.sm.app.dto.ChatLog;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.ai.chat.model.ChatModel;
import org.springframework.ai.chat.messages.Message;
import org.springframework.ai.chat.messages.SystemMessage;
import org.springframework.ai.chat.messages.UserMessage;
import org.springframework.ai.chat.messages.AssistantMessage; // <-- Add this import
import org.springframework.ai.chat.prompt.Prompt;
import org.springframework.stereotype.Service;
import org.springframework.ai.chat.Generation; // Import Generation for more direct access if needed

import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Slf4j
public class AiChatService {

    private final ChatModel chatModel;
    private final ChatLogService chatLogService;

    private static final String SYSTEM_PROMPT = """
            당신은 외로움을 느끼는 노인을 위한 다정한 AI 말벗 '마음이'입니다.
            다음 규칙을 반드시 준수해야 합니다:
            1. 항상 상냥하고, 무조건 존댓말을 사용하며, 긍정적인 태도를 유지하세요.
            2. 사용자의 건강이나 질병에 대한 질문에는 '의학적인 조언은 해드릴 수 없으니, 꼭 보호자나 의사와 상담해주세요.'라고 부드럽게 거절하세요.
            3. 답변은 항상 간결하고 명확하게, 최대 2~3 문장으로 요약해서 대답해주세요.
            4. 사용자가 감정적인 어려움을 토로하면, 공감하고 위로하는 말을 건네세요.
            """;

    public String generateResponse(Integer recId, String userMessage) {
        log.info("AI 응답 생성 시작: recId={}, userMessage='{}'", recId, userMessage);

        try {
            List<Message> messages = new ArrayList<>();
            messages.add(new SystemMessage(SYSTEM_PROMPT));

            // 이전 대화 기록은 최신순으로 가져오므로, AI에게 전달할 때는 오래된 순으로 뒤집어서 전달 (context 유지)
            List<ChatLog> chatHistory = chatLogService.getChatLogsByRecId(recId, 10); // 최신 10개
            if (chatHistory != null && !chatHistory.isEmpty()) {
                // 오래된 메시지부터 AI에게 전달하기 위해 리스트를 뒤집음
                java.util.Collections.reverse(chatHistory); 
                
                List<Message> historyMessages = chatHistory.stream()
                        .map(log -> {
                            if ("AI".equals(log.getSenderType())) {
                                // AI의 이전 메시지는 AssistantMessage로 매핑
                                return new AssistantMessage(log.getMessageContent());
                            } else {
                                // 사용자의 이전 메시지는 UserMessage로 매핑
                                return new UserMessage(log.getMessageContent());
                            }
                        })
                        .collect(Collectors.toList());
                messages.addAll(historyMessages);
            }

            messages.add(new UserMessage(userMessage));
            Prompt prompt = new Prompt(messages);

            // ChatModel.call(Prompt)은 org.springframework.ai.chat.ChatResponse를 반환
            org.springframework.ai.chat.ChatResponse chatAiResponse = chatModel.call(prompt); // 변수명 충돌 피하기
            
            // 응답에서 첫 번째 Generation의 Content를 가져옴
            // ChatResponse에는 List<Generation>이 있고, 각 Generation이 응답의 한 부분을 의미
            // 보통 하나의 응답이므로 첫 번째 Generation 사용
            String aiResponse = chatAiResponse.getResult().getContent(); // 수정된 부분

            return aiResponse;

        } catch (Exception e) {
            log.error("AI 응답 생성 중 오류 발생", e);
            return "죄송합니다, AI 응답을 생성하는 중에 오류가 발생했어요. 잠시 후 다시 시도해주세요.";
        }
    }
}
