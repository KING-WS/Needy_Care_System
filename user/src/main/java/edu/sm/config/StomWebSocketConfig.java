package edu.sm.config;

import edu.sm.rtc.KioskWebSocketHandler;
import edu.sm.rtc.WebRTCSignalingHandler;
import lombok.RequiredArgsConstructor;
import org.springframework.context.annotation.Configuration;
import org.springframework.messaging.simp.config.MessageBrokerRegistry;
import org.springframework.web.socket.config.annotation.*;

@EnableWebSocketMessageBroker
@EnableWebSocket
@Configuration
@RequiredArgsConstructor
public class StomWebSocketConfig implements WebSocketMessageBrokerConfigurer, WebSocketConfigurer {

    private final WebRTCSignalingHandler webRTCSignalingHandler;
    private final KioskWebSocketHandler kioskWebSocketHandler;


    @Override
    public void registerStompEndpoints(StompEndpointRegistry registry) {
        registry.addEndpoint("/chat").setAllowedOriginPatterns("*").withSockJS();
        registry.addEndpoint("/adminchat").setAllowedOriginPatterns("*").withSockJS();

    }
    @Override
    public void configureMessageBroker(MessageBrokerRegistry registry) {
        registry.enableSimpleBroker("/send","/adminsend");
    }
    @Override
    public void registerWebSocketHandlers(WebSocketHandlerRegistry registry) {
        registry.addHandler(webRTCSignalingHandler, "/signal")
                .setAllowedOrigins("*");
        registry.addHandler(kioskWebSocketHandler, "/ws/kiosk")
                .setAllowedOrigins("*");
    }

}
