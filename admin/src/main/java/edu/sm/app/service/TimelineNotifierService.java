package edu.sm.app.service;

import edu.sm.app.dto.CareTimelineItem;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Service;

/**
 * WebSocket을 통해 실시간 타임라인 업데이트를 전송하는 서비스
 */
@Service
public class TimelineNotifierService {

    private final SimpMessagingTemplate messagingTemplate;

    @Autowired
    public TimelineNotifierService(SimpMessagingTemplate messagingTemplate) {
        this.messagingTemplate = messagingTemplate;
    }

    /**
     * 새로운 케어 활동 항목을 WebSocket 토픽으로 전송합니다.
     * @param item 전송할 타임라인 항목
     */
    public void notifyNewCareActivity(CareTimelineItem item) {
        // '/topic/care-timeline'을 구독하는 모든 클라이언트에게 메시지를 전송
        messagingTemplate.convertAndSend("/topic/care-timeline", item);
    }
}
