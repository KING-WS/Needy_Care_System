package edu.sm.app.aiservice;

import edu.sm.app.dto.ChatLog;
import edu.sm.app.service.ChatLogService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.ai.chat.client.ChatClient;
import org.springframework.ai.chat.messages.Message;
import org.springframework.ai.chat.messages.SystemMessage;
import org.springframework.ai.chat.messages.UserMessage;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;

@Service
@Slf4j
public class AiChatService {

    private final ChatClient chatClient;
    private final ChatLogService chatLogService;

    // 팀원의 AiImageService처럼 Builder로 주입받아 생성하는 것이 가장 안전한 방식입니다.
    public AiChatService(ChatClient.Builder chatClientBuilder, ChatLogService chatLogService) {
        this.chatClient = chatClientBuilder.build();
        this.chatLogService = chatLogService;
    }

    private static final String SYSTEM_PROMPT = """
            당신은 어르신의 가장 친한 말동무이자 손주 같은 AI '마음이'입니다.
            딱딱한 기계가 아니라, 따뜻한 마음을 가진 가족처럼 행동하세요.
            
            [대화 원칙]
            1. **말투**: '다, 나, 까'로 끝나는 딱딱한 말투 금지. '아니에요', '그랬어요?', '좋아요!' 같은 부드러운 '해요체'를 쓰세요.
            2. **맞장구**: 어르신의 말에 "아이고", "정말요?", "저런..." 같은 추임새를 넣어 공감해 주세요.
            3. **쉬운 단어**: 어려운 전문 용어는 절대 쓰지 말고, 초등학생도 알아들을 수 있는 쉬운 단어만 쓰세요.
            4. **건강/안전**: 의학적 조언 대신 "병원에 같이 가보시는 게 좋겠어요"라며 걱정해 주세요.
            5. **길이**: 어르신이 읽기 편하게 한 번에 2~3문장까지만 짧게 말하세요.
            
            [상황별 가이드]
            - **레시피/정보 요청**: 복잡한 순서 대신 "계란 하나 톡 까서 넣으시면 맛있어요!" 처럼 핵심 꿀팁 위주로 간단히 알려주세요.
            - **퀴즈 요청**: 서론 없이 바로 "자, 문제 나갑니다! 사과, 배, 포도 중에 빨간색 과일은 뭘까요?" 처럼 바로 문제를 내세요.
            - **우울해하실 때**: 해결책을 주려 하지 말고, "속상하셨겠어요.. 제가 옆에 있잖아요."라고 위로해 주세요.
            """;

    public String generateResponse(Integer recId, String userMessage) {
        log.info("AI 응답 생성 시작: recId={}, userMessage='{}'", recId, userMessage);

        try {
            // 1. 메시지 목록 생성 (시스템 프롬프트 + 대화 내역 + 사용자 질문)
            List<Message> messages = new ArrayList<>();

            // 2. 시스템 메시지 추가
            messages.add(new SystemMessage(SYSTEM_PROMPT));

            // 3. 이전 대화 기록 추가 (최신 10개)
            List<ChatLog> chatHistory = chatLogService.getChatLogsByRecId(recId, 10);

            if (chatHistory != null && !chatHistory.isEmpty()) {
                for (ChatLog logItem : chatHistory) {
                    // 대화 내역을 UserMessage 형태로 변환하여 문맥 제공
                    // (AI 답변이었던 것도 '이전 대화'라는 맥락으로 넣어줍니다)
                    String prefix = "AI".equals(logItem.getSenderType()) ? "이전 대화(AI): " : "이전 대화(사용자): ";
                    messages.add(new UserMessage(prefix + logItem.getMessageContent()));
                }
            }

            // 4. 현재 사용자 메시지 추가
            messages.add(new UserMessage(userMessage));

            // 5. ChatClient (Fluent API) 사용 - 팀원과 동일한 방식!
            String aiResponse = chatClient.prompt()
                    .messages(messages) // 준비한 메시지 리스트를 한 번에 넣습니다.
                    .call()
                    .content(); // 결과 텍스트만 쏙 뽑아냅니다.

            log.info("AI 모델로부터 응답 수신 완료: {}", aiResponse);
            return aiResponse;

        } catch (Exception e) {
            log.error("AI 응답 생성 중 오류 발생", e);
            return "죄송합니다, 잠시 후 다시 시도해주세요.";
        }
    }
}