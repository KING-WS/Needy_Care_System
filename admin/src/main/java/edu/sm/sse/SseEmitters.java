package edu.sm.sse;



import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.mvc.method.annotation.SseEmitter;

import java.io.IOException;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

@Component
@Slf4j
public class SseEmitters {
    private final Map<String, SseEmitter> emitters = new ConcurrentHashMap<>();

//    public void sendData(AdminMsg adminMsg) {
////접속되어있는 admin과 admin2에만 데이터를 단방향으로 전송을 해라
//        this.emitters.keySet().stream().filter(s->s.equals("admin") || s.equals("admin2")).forEach(key -> {
//            try {
//                log.info("-------------------------------------"+key.toString());
//                this.emitters.get(key).send(SseEmitter.event()
//                        .name("adminmsg")
//                        .data(adminMsg));
//            } catch ( IOException e) {
//                throw new RuntimeException(e);
//            }
//        });
//    }
    public void msg(String msg) {
        this.emitters.values().forEach(emitter -> {
            try {
                emitter.send(SseEmitter.event()
                        .name("msg")
                        .data(msg)); //object으로 받는데 자동으로 json형식으로 변환
            } catch ( IOException e) {
                throw new RuntimeException(e);
            }
        });
    }
//    public void msg(AiMsg aiMsg) {
//        this.emitters.values().forEach(emitter -> {
//            try {
//                emitter.send(SseEmitter.event()
//                        .name("aimsg")
//                        .data(aiMsg));
//            } catch ( IOException e) {
//                throw new RuntimeException(e);
//            }
//        });
//    }
    public void text(String text) {
        this.emitters.values().forEach(emitter -> {
            try {
                emitter.send(SseEmitter.event()
                        .name("text")
                        .data(text));
            } catch ( IOException e) {
                throw new RuntimeException(e);
            }
        });
    }


    public void question(String question) {
        this.emitters.values().forEach(emitter -> {
            try {
                emitter.send(SseEmitter.event()
                        .name("question")
                        .data(question));
            } catch ( IOException e) {
                throw new RuntimeException(e);
            }
        });
    }

    public void count(int num) {

        this.emitters.values().forEach(emitter -> {
            try {
                emitter.send(SseEmitter.event()
                        .name("count")
                        .data(num));
            } catch ( IOException e) {
                throw new RuntimeException(e);
            }
        });
    }
    public SseEmitter add(String clientId, SseEmitter emitter) {
        this.emitters.put(clientId,emitter);
        log.info("new emitter added: {}", emitter);
        log.info("emitter list size: {}", emitters.size());

        // 연결 완료, 오류, 타임아웃 이벤트 핸들러 등록
        emitter.onCompletion(() -> {
            log.info("onCompletion: {}", emitter);

            emitters.remove(clientId);
            cleanupEmitter(emitter);
        });
        emitter.onError((ex) -> {
            log.info("onError:---------------------------- ");

            emitters.remove(clientId);
            cleanupEmitter(emitter);
        });
        emitter.onTimeout(() -> {
            emitters.remove(clientId);
            cleanupEmitter(emitter);
        });
        return emitter;
    }
    public void close(String clientId) {
        emitters.remove(clientId);
        log.info("new emitter close...........: {}", clientId);
    }
    private void cleanupEmitter(SseEmitter emitter) {
        try {
            emitter.complete();
        } catch (Exception e) {
            // 예외 처리
        }
    }
}