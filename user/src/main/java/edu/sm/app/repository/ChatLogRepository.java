package edu.sm.app.repository;

import edu.sm.app.dto.ChatLog;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface ChatLogRepository {

    /**
     * 새로운 채팅 로그를 저장합니다.
     * @param chatLog 저장할 ChatLog 객체
     * @return 저장된 행의 수
     */
    int insertChatLog(ChatLog chatLog);

    /**
     * 특정 돌봄대상자(recId)의 채팅 로그를 조회합니다.
     * @param recId 돌봄대상자 식별자
     * @param limit 조회할 로그의 최대 개수 (최신순)
     * @return ChatLog 리스트
     */
    List<ChatLog> selectChatLogsByRecId(@Param("recId") Integer recId, @Param("limit") int limit);
    
    /**
     * 특정 돌봄대상자(recId)의 모든 채팅 로그를 조회합니다.
     * @param recId 돌봄대상자 식별자
     * @return ChatLog 리스트 (최신순)
     */
    List<ChatLog> selectAllChatLogsByRecId(@Param("recId") Integer recId);

    // 향후 필요시 업데이트, 삭제(논리적), 특정 로그 조회 등의 메서드를 추가할 수 있습니다.
}
