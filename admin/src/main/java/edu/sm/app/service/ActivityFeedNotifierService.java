package edu.sm.app.service;

import edu.sm.app.dto.ActivityItem;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Service;

/**
 * WebSocket을 통해 실시간 활동 피드 업데이트를 전송하는 서비스
 */
@Service
public class ActivityFeedNotifierService {

    private final SimpMessagingTemplate messagingTemplate;

    @Autowired
    public ActivityFeedNotifierService(SimpMessagingTemplate messagingTemplate) {
        this.messagingTemplate = messagingTemplate;
    }

    /**
     * 새로운 활동 항목을 WebSocket 토픽으로 전송합니다.
     * @param item 전송할 활동 항목
     */
    public void notifyNewActivity(ActivityItem item) {
        // '/topic/activity-feed'를 구독하는 모든 클라이언트에게 메시지를 전송
        messagingTemplate.convertAndSend("/topic/activity-feed", item);
    }
}
