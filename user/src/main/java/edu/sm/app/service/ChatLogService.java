package edu.sm.app.service;

import edu.sm.app.dto.ChatLog;
import edu.sm.app.repository.ChatLogRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
@Slf4j
public class ChatLogService {

    private final ChatLogRepository chatLogRepository;

    /**
     * 새로운 채팅 로그를 저장합니다.
     * @param chatLog 저장할 ChatLog 객체
     */
    public void saveChatLog(ChatLog chatLog) {
        log.info("새로운 채팅 로그 저장 시도: recId={}, senderType={}", chatLog.getRecId(), chatLog.getSenderType());
        int result = chatLogRepository.insertChatLog(chatLog);
        if (result == 0) {
            log.error("채팅 로그 저장 실패: {}", chatLog);
            throw new RuntimeException("채팅 로그 저장에 실패했습니다.");
        }
        log.info("채팅 로그 저장 성공: logId={}", chatLog.getLogId());
    }

    /**
     * 특정 노약자(recId)의 최신 채팅 로그를 조회합니다.
     * @param recId 노약자 식별자
     * @param limit 조회할 로그의 최대 개수
     * @return ChatLog 리스트 (최신순)
     */
    public List<ChatLog> getChatLogsByRecId(Integer recId, int limit) {
        log.info("recId={}의 최신 채팅 로그 {}개 조회 시도", recId, limit);
        return chatLogRepository.selectChatLogsByRecId(recId, limit);
    }

    /**
     * 특정 노약자(recId)의 모든 채팅 로그를 조회합니다.
     * @param recId 노약자 식별자
     * @return ChatLog 리스트 (오래된 순)
     */
    public List<ChatLog> getAllChatLogsByRecId(Integer recId) {
        log.info("recId={}의 모든 채팅 로그 조회 시도", recId);
        return chatLogRepository.selectAllChatLogsByRecId(recId);
    }
}
