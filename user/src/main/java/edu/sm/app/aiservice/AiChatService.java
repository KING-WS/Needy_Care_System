package edu.sm.app.aiservice;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import edu.sm.app.aiservice.util.AiUtilService;
import edu.sm.app.aiservice.util.DateExtractionService;
import edu.sm.app.aiservice.util.ScheduleNameGenerationService;
import edu.sm.app.dto.*;
import edu.sm.app.service.*;
import lombok.extern.slf4j.Slf4j;
import org.springframework.ai.chat.client.ChatClient;
import org.springframework.ai.chat.messages.Message;
import org.springframework.ai.chat.messages.SystemMessage;
import org.springframework.ai.chat.messages.UserMessage;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
@Slf4j
public class AiChatService {

    private final ChatClient chatClient;
    private final ChatLogService chatLogService;
    private final ObjectMapper objectMapper;

    // 분리된 서비스들
    private final IntentAnalysisService intentAnalysisService;
    private final HealthQueryService healthQueryService;
    private final RecipientStatusService recipientStatusService;
    private final MealRecommendationService mealRecommendationService;
    private final WalkingRouteService walkingRouteService;
    private final DateExtractionService dateExtractionService;
    private final AiUtilService aiUtilService;
    private final ScheduleNameGenerationService scheduleNameGenerationService;

    // Schedule 관련 서비스는 아직 분리 전이므로 직접 의존성 주입
    private final RecipientService recipientService;
    private final HealthDataService healthDataService;
    private final MealPlanService mealPlanService;
    private final ScheduleService scheduleService;

    // Schedule 추천 결과 임시 저장 (추후 ScheduleRecommendationService로 분리 시 제거)
    private final Map<Integer, Map<String, Object>> recentScheduleRecommendations = new HashMap<>();

    public AiChatService(
            ChatClient.Builder chatClientBuilder,
            ChatLogService chatLogService,
            ObjectMapper objectMapper,
            IntentAnalysisService intentAnalysisService,
            HealthQueryService healthQueryService,
            RecipientStatusService recipientStatusService,
            MealRecommendationService mealRecommendationService,
            WalkingRouteService walkingRouteService,
            DateExtractionService dateExtractionService,
            AiUtilService aiUtilService,
            ScheduleNameGenerationService scheduleNameGenerationService,
            RecipientService recipientService,
            HealthDataService healthDataService,
            MealPlanService mealPlanService,
            ScheduleService scheduleService) {
        this.chatClient = chatClientBuilder.build();
        this.chatLogService = chatLogService;
        this.objectMapper = objectMapper;
        this.intentAnalysisService = intentAnalysisService;
        this.healthQueryService = healthQueryService;
        this.recipientStatusService = recipientStatusService;
        this.mealRecommendationService = mealRecommendationService;
        this.walkingRouteService = walkingRouteService;
        this.dateExtractionService = dateExtractionService;
        this.aiUtilService = aiUtilService;
        this.scheduleNameGenerationService = scheduleNameGenerationService;
        this.recipientService = recipientService;
        this.healthDataService = healthDataService;
        this.mealPlanService = mealPlanService;
        this.scheduleService = scheduleService;
    }

    private static final String SYSTEM_PROMPT = """
            당신은 노약자 돌봄 시스템의 AI 어시스턴트입니다.
            보호자가 사용하는 시스템이므로 정확하고 실용적인 정보를 제공하세요.
            
            [대화 원칙]
            1. **말투**: 정중하고 명확한 존댓말을 사용하세요. 불필요한 감정 표현은 피하세요.
            2. **정보 제공**: 요청된 정보를 정확하고 간결하게 제공하세요.
            3. **전문 용어**: 필요시 적절한 전문 용어를 사용할 수 있으나, 이해하기 쉽게 설명하세요.
            4. **건강/안전**: 의학적 조언은 피하고, 필요시 전문의 상담을 권장하세요.
            5. **길이**: 정보를 명확하게 전달하되, 불필요하게 길지 않게 작성하세요.
            
            [상황별 가이드]
            - **정보 요청**: 요청된 정보를 정확하고 체계적으로 제공하세요.
            - **기능 안내**: 시스템 기능에 대해 명확하게 설명하세요.
            - **오류 발생 시**: 문제 상황을 명확히 설명하고 해결 방법을 제시하세요.
            """;


    public String generateResponse(Integer recId, String userMessage) {
        log.info("AI 응답 생성 시작: recId={}, userMessage='{}'", recId, userMessage);

        try {
            // 1. 의도 분석
            ChatIntent intent = analyzeIntent(userMessage);
            log.info("의도 분석 결과: intent={}, confidence={}", intent.getIntent(), intent.getConfidence());

            // 2. 의도에 따라 적절한 기능 수행
            String functionResult = executeFunction(recId, intent, userMessage);

            // 3. 결과를 자연어로 변환하여 응답 생성
            String aiResponse = generateNaturalResponse(recId, userMessage, intent, functionResult);

            log.info("AI 모델로부터 응답 수신 완료: {}", aiResponse);
            return aiResponse;

        } catch (Exception e) {
            log.error("AI 응답 생성 중 오류 발생", e);
            return "죄송합니다, 잠시 후 다시 시도해주세요.";
        }
    }

    /**
     * 사용자 메시지의 의도를 분석합니다.
     */
    private ChatIntent analyzeIntent(String userMessage) {
        return intentAnalysisService.analyzeIntent(userMessage);
    }

    /**
     * 의도에 따라 적절한 기능을 실행합니다.
     */
    private String executeFunction(Integer recId, ChatIntent intent, String userMessage) {
        try {
            Map<String, Object> params = parseParameters(intent.getParameters());

            // 사용자 메시지에서 날짜 정보 추출 (일정 조회/생성/추천 시)
            if ("SCHEDULE_QUERY".equals(intent.getIntent()) ||
                    "SCHEDULE_CREATE".equals(intent.getIntent()) ||
                    "SCHEDULE_RECOMMEND".equals(intent.getIntent())) {
                params = dateExtractionService.extractDateFromMessage(userMessage, params);
            }

            switch (intent.getIntent()) {
                case "HEALTH_QUERY":
                    return healthQueryService.queryHealth(recId);
                case "HEALTH_ANALYSIS":
                    return healthQueryService.analyzeHealth(recId);
                case "RECIPIENT_STATUS":
                    return recipientStatusService.getRecipientStatus(recId, userMessage);
                case "MEAL_RECOMMEND":
                    return mealRecommendationService.recommendMeal(recId, userMessage);
                case "MEAL_QUERY":
                    return mealRecommendationService.queryMeal(recId, params);
                case "MEAL_SAVE":
                    return mealRecommendationService.saveMeal(recId, userMessage);
                case "WALKING_ROUTE":
                    return walkingRouteService.recommendWalkingRoute(recId);
                // TODO: Schedule 관련 서비스 분리 후 추가
                case "SCHEDULE_CREATE":
                    return handleScheduleCreate(recId, params, userMessage);
                case "SCHEDULE_QUERY":
                    return handleScheduleQuery(recId, params);
                case "SCHEDULE_RECOMMEND":
                    return handleScheduleRecommend(recId, params, userMessage);
                case "SCHEDULE_SAVE":
                    return handleScheduleSave(recId, params, userMessage);
                default:
                    return null; // 일반 대화는 함수 실행 없음
            }
        } catch (Exception e) {
            log.error("기능 실행 중 오류 발생", e);
            return "기능을 실행하는 중 문제가 발생했어요.";
        }
    }

    /**
     * 기능 실행 결과를 바탕으로 자연어 응답을 생성합니다.
     */
    private String generateNaturalResponse(Integer recId, String userMessage, ChatIntent intent, String functionResult) {
        try {
            List<Message> messages = new ArrayList<>();
            messages.add(new SystemMessage(SYSTEM_PROMPT));

            // 이전 대화 기록 추가
            List<ChatLog> chatHistory = chatLogService.getChatLogsByRecId(recId, 10);
            if (chatHistory != null && !chatHistory.isEmpty()) {
                for (ChatLog logItem : chatHistory) {
                    String prefix = "AI".equals(logItem.getSenderType()) ? "이전 대화(AI): " : "이전 대화(사용자): ";
                    messages.add(new UserMessage(prefix + logItem.getMessageContent()));
                }
            }

            // 사용자 메시지와 함수 실행 결과를 함께 전달
            String contextMessage = userMessage;
            if (functionResult != null && !functionResult.isEmpty()) {
                contextMessage += "\n\n[시스템 정보]\n" + functionResult;
            }
            messages.add(new UserMessage(contextMessage));

            String aiResponse = chatClient.prompt()
                    .messages(messages)
                    .call()
                    .content();

            return aiResponse;
        } catch (Exception e) {
            log.error("자연어 응답 생성 중 오류 발생", e);
            return functionResult != null ? functionResult : "죄송합니다, 잠시 후 다시 시도해주세요.";
        }
    }

    // ========== Schedule 관련 메서드 (추후 ScheduleRecommendationService로 분리 예정) ==========

    private String handleScheduleCreate(Integer recId, Map<String, Object> params, String userMessage) {
        try {
            // GPT를 사용해서 자연어에서 일정 정보 추출
            String extractionPrompt = """
                다음 자연어 문장에서 일정 정보를 추출해주세요.
                
                추출할 정보:
                1. 일정명 (무엇을 할 것인지)
                2. 날짜 (오늘, 내일, 다음주 월요일 등)
                3. 시작 시간 (오후 3시, 14시 등)
                4. 종료 시간 (선택사항)
                
                응답은 반드시 JSON 형식으로만 해주세요:
                {
                  "scheduleName": "일정명",
                  "date": "YYYY-MM-DD 형식의 날짜 (오늘이면 오늘 날짜)",
                  "startTime": "HH:mm 형식 (예: 14:00)",
                  "endTime": "HH:mm 형식 (예: 15:00, 없으면 시작시간 + 1시간)"
                }
                
                현재 날짜: %s
                사용자 메시지: %s
                """.formatted(LocalDate.now().toString(), userMessage);

            String extractionResponse = chatClient.prompt()
                    .user(extractionPrompt)
                    .call()
                    .content();

            String json = aiUtilService.extractJson(extractionResponse);
            @SuppressWarnings("unchecked")
            Map<String, Object> scheduleData = objectMapper.readValue(json, Map.class);

            // Schedule 객체 생성
            Schedule schedule = new Schedule();
            schedule.setRecId(recId);

            // 날짜 파싱
            String dateStr = scheduleData.get("date") != null ?
                    scheduleData.get("date").toString() : LocalDate.now().toString();
            schedule.setSchedDate(LocalDate.parse(dateStr));

            // 일정명
            String scheduleName = scheduleData.get("scheduleName") != null ?
                    scheduleData.get("scheduleName").toString() : userMessage;
            schedule.setSchedName(scheduleName);

            // 시작 시간
            String startTime = scheduleData.get("startTime") != null ?
                    scheduleData.get("startTime").toString() : "09:00";
            schedule.setSchedStartTime(startTime);

            // 종료 시간
            String endTime = scheduleData.get("endTime") != null ?
                    scheduleData.get("endTime").toString() :
                    (startTime.contains(":") ?
                            String.format("%02d:00", (Integer.parseInt(startTime.split(":")[0]) + 1) % 24) :
                            "10:00");
            schedule.setSchedEndTime(endTime);

            // DB에 저장
            int result = scheduleService.createSchedule(schedule);

            if (result > 0) {
                log.info("일정 자동 저장 완료 - recId: {}, scheduleName: {}, date: {}",
                        recId, scheduleName, dateStr);

                return String.format("일정을 등록했어요!\n" +
                                "일정명: %s\n" +
                                "날짜: %s\n" +
                                "시간: %s ~ %s",
                        scheduleName,
                        schedule.getSchedDate().format(DateTimeFormatter.ofPattern("yyyy년 MM월 dd일")),
                        startTime,
                        endTime);
            } else {
                return "일정 등록에 실패했어요. 다시 시도해주세요.";
            }
        } catch (Exception e) {
            log.error("일정 등록 실패", e);
            return "일정을 등록하는 중 문제가 발생했어요. 날짜와 시간을 명확히 말씀해주세요.";
        }
    }

    private String handleScheduleQuery(Integer recId, Map<String, Object> params) {
        try {
            // 사용자 메시지에서 날짜 추출 시도 (GPT 사용)
            LocalDate queryDate = LocalDate.now(); // 기본값: 오늘

            // params에 날짜가 있으면 사용
            if (params.containsKey("date")) {
                try {
                    queryDate = LocalDate.parse(params.get("date").toString());
                } catch (Exception e) {
                    log.warn("날짜 파싱 실패, 오늘 날짜 사용: {}", params.get("date"));
                }
            }

            // 오늘 날짜로 일정 조회
            List<Schedule> schedules = scheduleService.getSchedulesByDateRange(recId, queryDate, queryDate);

            if (schedules == null || schedules.isEmpty()) {
                return String.format("%s 일정이 없어요. 오늘은 편하게 쉬시면 돼요! 😊",
                        queryDate.format(DateTimeFormatter.ofPattern("yyyy년 MM월 dd일")));
            }

            // 시간순으로 정렬
            schedules.sort((s1, s2) -> {
                if (s1.getSchedStartTime() == null) return 1;
                if (s2.getSchedStartTime() == null) return -1;
                return s1.getSchedStartTime().compareTo(s2.getSchedStartTime());
            });

            StringBuilder sb = new StringBuilder();
            sb.append(String.format("%s 일정이에요:\n\n",
                    queryDate.format(DateTimeFormatter.ofPattern("yyyy년 MM월 dd일"))));

            int index = 1;
            for (Schedule schedule : schedules) {
                String startTime = schedule.getSchedStartTime() != null ?
                        schedule.getSchedStartTime() : "시간 미정";
                String endTime = schedule.getSchedEndTime() != null ?
                        schedule.getSchedEndTime() : "";

                if (!endTime.isEmpty() && !endTime.equals(startTime)) {
                    sb.append(String.format("%d. %s\n   시간: %s ~ %s\n\n",
                            index++,
                            schedule.getSchedName(),
                            startTime,
                            endTime));
                } else {
                    sb.append(String.format("%d. %s\n   시간: %s\n\n",
                            index++,
                            schedule.getSchedName(),
                            startTime));
                }
            }

            sb.append("일정을 잘 확인하셨나요? 궁금한 게 있으면 언제든 물어보세요!");

            return sb.toString();
        } catch (Exception e) {
            log.error("일정 조회 실패", e);
            return "일정을 조회하는 중 문제가 발생했어요. 잠시 후 다시 시도해주세요.";
        }
    }

    /**
     * 텍스트에서 날짜 추출 (이번주 금요일, 이번달 23일 등)
     * DateExtractionService를 사용하여 처리
     */
    public String extractDateFromText(String text) {
        return dateExtractionService.extractDateFromText(text);
    }

    /**
     * 특이사항 기반 맞춤형 일정 추천 (기본 식사/약 복용 시간 제외, 특이사항 활동 중심)
     */
    public Map<String, Object> getCustomScheduleRecommendation(Integer recId, LocalDate targetDate, String specialActivity) {
        try {
            // 사용자 정보 조회
            Recipient recipient = recipientService.getRecipientById(recId);
            if (recipient == null) {
                return Map.of("success", false, "message", "사용자 정보를 찾을 수 없습니다.");
            }

            if (specialActivity == null || specialActivity.trim().isEmpty()) {
                return Map.of("success", false, "message", "특이사항에 활동을 입력해주세요.");
            }

            // 건강 데이터 조회
            List<HealthData> healthDataList = healthDataService.getHealthDataByRecId(recId);
            HealthData latestHealth = healthDataList != null && !healthDataList.isEmpty() ?
                    healthDataList.get(0) : null;

            // 기존 일정 조회
            List<Schedule> existingSchedules = scheduleService.getSchedulesByDateRange(recId, targetDate, targetDate);

            // GPT에게 맞춤형 일정 추천 요청
            StringBuilder contextBuilder = new StringBuilder();
            contextBuilder.append(String.format("날짜는 %s입니다.\n\n",
                    targetDate.format(DateTimeFormatter.ofPattern("yyyy년 MM월 dd일"))));

            // 사용자 정보
            contextBuilder.append("[사용자 정보]\n");
            contextBuilder.append(String.format("이름: %s\n", recipient.getRecName()));
            if (recipient.getRecHealthNeeds() != null) {
                contextBuilder.append(String.format("건강 요구사항: %s\n", recipient.getRecHealthNeeds()));
            }
            if (recipient.getRecMedHistory() != null) {
                contextBuilder.append(String.format("병력: %s\n", recipient.getRecMedHistory()));
            }
            if (recipient.getRecAllergies() != null) {
                contextBuilder.append(String.format("알레르기: %s\n", recipient.getRecAllergies()));
            }
            if (recipient.getRecSpecNotes() != null) {
                contextBuilder.append(String.format("특이사항: %s\n", recipient.getRecSpecNotes()));
            }
            contextBuilder.append("\n");

            // 건강 데이터
            if (latestHealth != null) {
                contextBuilder.append("[최근 건강 데이터]\n");
                contextBuilder.append(String.format("종류: %s\n", latestHealth.getHealthType()));
                if (latestHealth.getHealthValue1() != null) {
                    contextBuilder.append(String.format("값1: %s\n", latestHealth.getHealthValue1()));
                }
                if (latestHealth.getHealthValue2() != null) {
                    contextBuilder.append(String.format("값2: %s\n", latestHealth.getHealthValue2()));
                }
                contextBuilder.append("\n");
            }

            // 기존 일정
            if (existingSchedules != null && !existingSchedules.isEmpty()) {
                contextBuilder.append("[기존 일정]\n");
                for (Schedule schedule : existingSchedules) {
                    contextBuilder.append(String.format("- %s (%s ~ %s)\n",
                            schedule.getSchedName(),
                            schedule.getSchedStartTime() != null ? schedule.getSchedStartTime() : "",
                            schedule.getSchedEndTime() != null ? schedule.getSchedEndTime() : ""));
                }
                contextBuilder.append("\n");
            }

            String customRecommendationPrompt = """
                당신은 노인 돌봄 전문가입니다. 위의 사용자 정보를 바탕으로, 사용자가 원하는 활동을 중심으로 건강 상태에 맞는 일정을 추천해주세요.
                
                사용자가 원하는 활동: "%s"
                
                중요 사항:
                1. 사용자가 원하는 활동을 반드시 포함해야 합니다.
                2. 사용자가 시간을 명시한 경우 (예: "저녁 5시", "오후 3시", "17시") 그 시간을 정확히 반영해주세요.
                3. 사용자의 건강 상태(병력, 알레르기, 건강 요구사항, 특이사항)를 반드시 고려하여 활동에 적합한 시간과 방법을 추천해주세요.
                4. 기본적인 식사 시간이나 약 복용 시간은 제외하고, 사용자가 원하는 활동과 관련된 일정만 추천해주세요.
                5. 활동 전후 휴식 시간, 이동 시간 등을 고려해주세요.
                6. 건강 상태에 따라 활동 강도나 시간을 조절해주세요.
                
                예시:
                - "공원에 가고 싶어요" → 공원 산책 시간, 공원에서의 활동, 이동 시간, 휴식 시간 등을 건강 상태에 맞게 추천
                - "도서관 방문" → 도서관 방문 시간, 이동 시간, 독서 시간, 휴식 시간 등을 고려
                - "친구 만나기" → 만남 시간, 이동 시간, 대화/활동 시간 등을 고려
                - "저녁 5시에 요양사 선생을 만날예정" → 저녁 5시(17:00)에 요양사 만남 일정을 포함
                
                응답은 반드시 JSON 객체 형식으로만 해주세요. 다른 설명 없이 JSON만 반환해주세요:
                {
                  "scheduleName": "일정명 (사용자가 입력한 활동을 바탕으로 의미있는 이름, 예: '공원 산책', '도서관 방문', '요양원 방문' 등)",
                  "schedules": [
                    {
                      "scheduleName": "일정명",
                      "startTime": "HH:mm",
                      "endTime": "HH:mm",
                      "description": "일정 설명 (건강 상태를 고려한 이유 포함)"
                    },
                    ...
                  ]
                }
                
                일정명(scheduleName)은 사용자가 입력한 활동을 바탕으로 의미있게 작성해주세요.
                예를 들어, "요양원과 사람을 만나게 될 날"이라고 입력했다면 "요양원 방문" 또는 "요양원 만남" 같은 이름을 사용하세요.
                "저녁 5시에 요양사 선생을 만날예정"이라고 입력했다면 "요양사 만남" 같은 이름을 사용하세요.
                단순히 날짜만 사용하지 마세요 (예: "2025-11-26 일정" ❌).
                
                일정은 오전 7시부터 오후 9시까지, 사용자가 원하는 활동을 중심으로 시간표를 짜주세요.
                사용자가 특정 시간을 명시한 경우 그 시간을 정확히 포함해주세요.
                기존 일정과 겹치지 않도록 주의하세요.
                건강 상태에 따라 활동 시간, 강도, 방법을 조절하여 추천해주세요.
                
                %s
                """.formatted(specialActivity.trim(), contextBuilder.toString());

            String response = chatClient.prompt()
                    .user(customRecommendationPrompt)
                    .call()
                    .content();

            String json = aiUtilService.extractJson(response);
            log.info("맞춤형 일정 추천 원본 응답: {}", response);
            log.info("추출된 JSON: {}", json);

            // JSON이 배열인지 확인
            if (json == null || json.trim().isEmpty() || json.equals("{}")) {
                log.warn("JSON 추출 실패 또는 빈 응답");
                return Map.of("success", false, "message", "AI 응답에서 일정 정보를 추출할 수 없습니다.");
            }

            // JSON 파싱
            List<Map<String, Object>> scheduleList;
            String scheduleName = null;

            try {
                // 먼저 JSON이 배열인지 객체인지 확인
                String trimmedJson = json.trim();
                boolean isArray = trimmedJson.startsWith("[");
                boolean isObject = trimmedJson.startsWith("{");

                if (isObject) {
                    // 객체 형식으로 파싱 시도
                    @SuppressWarnings("unchecked")
                    Map<String, Object> obj = objectMapper.readValue(json, Map.class);

                    // scheduleName 추출
                    if (obj.containsKey("scheduleName")) {
                        scheduleName = obj.get("scheduleName").toString();
                    }

                    // schedules 배열 추출
                    if (obj.containsKey("schedules") && obj.get("schedules") instanceof List) {
                        @SuppressWarnings("unchecked")
                        List<Map<String, Object>> schedules = (List<Map<String, Object>>) obj.get("schedules");
                        scheduleList = schedules;
                        log.info("객체에서 schedules 배열 추출 성공 - 일정명: {}, 일정 개수: {}", scheduleName, scheduleList.size());
                    } else {
                        // schedules 키가 없으면 빈 리스트
                        log.warn("객체에 schedules 키가 없음: {}", obj.keySet());
                        scheduleList = new ArrayList<>();
                    }
                } else if (isArray) {
                    // 배열 형식으로 직접 파싱
                    @SuppressWarnings("unchecked")
                    List<Map<String, Object>> parsedList = objectMapper.readValue(json, List.class);
                    scheduleList = parsedList;

                    // 일정명이 없으면 활동 설명에서 생성
                    if (scheduleName == null && specialActivity != null && !specialActivity.trim().isEmpty()) {
                        scheduleName = scheduleNameGenerationService.generateScheduleNameFromActivity(specialActivity.trim());
                    }

                    log.info("배열로 파싱 성공 - 일정명: {}, 일정 개수: {}", scheduleName, scheduleList.size());
                } else {
                    log.error("JSON 형식이 올바르지 않음 (배열도 객체도 아님): {}", json.substring(0, Math.min(200, json.length())));
                    return Map.of("success", false, "message", "AI 응답 형식을 인식할 수 없습니다. 다시 시도해주세요.");
                }

                if (scheduleList == null || scheduleList.isEmpty()) {
                    log.warn("파싱된 일정 리스트가 비어있음");
                    return Map.of("success", false, "message", "추천된 일정이 없습니다.");
                }

                // 일정명이 없으면 기본값 생성
                if (scheduleName == null || scheduleName.trim().isEmpty()) {
                    scheduleName = scheduleNameGenerationService.generateScheduleNameFromActivity(specialActivity != null ? specialActivity.trim() : "");
                    if (scheduleName == null || scheduleName.trim().isEmpty()) {
                        scheduleName = targetDate.format(DateTimeFormatter.ofPattern("yyyy년 MM월 dd일")) + " 일정";
                    }
                }

                log.info("맞춤형 일정 추천 성공 - 일정명: {}, 일정 개수: {}", scheduleName, scheduleList.size());
            } catch (JsonProcessingException e) {
                log.error("JSON 파싱 실패 - JSON 길이: {}, 시작 부분: {}", json.length(),
                        json.substring(0, Math.min(500, json.length())), e);
                log.error("파싱 에러 상세: {}", e.getMessage());
                return Map.of("success", false, "message",
                        "AI 응답을 파싱하는 중 오류가 발생했습니다: " + e.getMessage() + ". 다시 시도해주세요.");
            } catch (Exception e) {
                log.error("예상치 못한 오류 발생 - JSON: {}", json.substring(0, Math.min(200, json.length())), e);
                return Map.of("success", false, "message", "일정 추천 중 오류가 발생했습니다: " + e.getMessage());
            }

            // 결과 반환
            Map<String, Object> result = new HashMap<>();
            result.put("success", true);
            result.put("schedules", scheduleList);
            result.put("scheduleName", scheduleName);
            result.put("date", targetDate.toString());

            return result;

        } catch (Exception e) {
            log.error("맞춤형 일정 추천 실패", e);
            return Map.of("success", false, "message", "일정 추천 중 오류가 발생했습니다: " + e.getMessage());
        }
    }

    /**
     * AI 일정 추천 결과를 직접 반환하는 public 메서드 (API용) - 기본 모드
     */
    public Map<String, Object> getScheduleRecommendation(Integer recId, LocalDate targetDate, String specialNotes) {
        try {
            // 사용자 정보 조회
            Recipient recipient = recipientService.getRecipientById(recId);
            if (recipient == null) {
                return Map.of("success", false, "message", "사용자 정보를 찾을 수 없습니다.");
            }

            // 건강 데이터 조회
            List<HealthData> healthDataList = healthDataService.getHealthDataByRecId(recId);
            HealthData latestHealth = healthDataList != null && !healthDataList.isEmpty() ?
                    healthDataList.get(0) : null;

            // 해당 날짜 식단 조회
            List<MealPlan> dayMeals = mealPlanService.getByRecIdAndDate(recId, targetDate);

            // 기존 일정 조회
            List<Schedule> existingSchedules = scheduleService.getSchedulesByDateRange(recId, targetDate, targetDate);

            // GPT에게 일정 추천 요청
            StringBuilder contextBuilder = new StringBuilder();
            contextBuilder.append(String.format("날짜는 %s입니다.\n\n",
                    targetDate.format(DateTimeFormatter.ofPattern("yyyy년 MM월 dd일"))));

            // 사용자 정보
            contextBuilder.append("[사용자 정보]\n");
            contextBuilder.append(String.format("이름: %s\n", recipient.getRecName()));
            if (recipient.getRecHealthNeeds() != null) {
                contextBuilder.append(String.format("건강 요구사항: %s\n", recipient.getRecHealthNeeds()));
            }
            if (recipient.getRecMedHistory() != null) {
                contextBuilder.append(String.format("병력: %s\n", recipient.getRecMedHistory()));
            }
            if (recipient.getRecAllergies() != null) {
                contextBuilder.append(String.format("알레르기: %s\n", recipient.getRecAllergies()));
            }
            if (recipient.getRecSpecNotes() != null) {
                contextBuilder.append(String.format("특이사항: %s\n", recipient.getRecSpecNotes()));
            }
            contextBuilder.append("\n");

            // 건강 데이터
            if (latestHealth != null) {
                contextBuilder.append("[최근 건강 데이터]\n");
                contextBuilder.append(String.format("종류: %s\n", latestHealth.getHealthType()));
                if (latestHealth.getHealthValue1() != null) {
                    contextBuilder.append(String.format("값1: %s\n", latestHealth.getHealthValue1()));
                }
                if (latestHealth.getHealthValue2() != null) {
                    contextBuilder.append(String.format("값2: %s\n", latestHealth.getHealthValue2()));
                }
                contextBuilder.append("\n");
            }

            // 해당 날짜 식단
            if (dayMeals != null && !dayMeals.isEmpty()) {
                contextBuilder.append(String.format("[%s 식단]\n",
                        targetDate.format(DateTimeFormatter.ofPattern("yyyy년 MM월 dd일"))));
                for (MealPlan meal : dayMeals) {
                    contextBuilder.append(String.format("- %s: %s\n", meal.getMealType(), meal.getMealMenu()));
                }
                contextBuilder.append("\n");
            }

            // 기존 일정
            if (existingSchedules != null && !existingSchedules.isEmpty()) {
                contextBuilder.append("[기존 일정]\n");
                for (Schedule schedule : existingSchedules) {
                    contextBuilder.append(String.format("- %s (%s ~ %s)\n",
                            schedule.getSchedName(),
                            schedule.getSchedStartTime() != null ? schedule.getSchedStartTime() : "",
                            schedule.getSchedEndTime() != null ? schedule.getSchedEndTime() : ""));
                }
                contextBuilder.append("\n");
            }

            // 특이사항 추가
            String activityDescription = "";
            if (specialNotes != null && !specialNotes.trim().isEmpty()) {
                contextBuilder.append("[추가 요청사항]\n");
                contextBuilder.append(specialNotes).append("\n\n");
                activityDescription = specialNotes.trim();
            }

            String recommendationPrompt = """
                당신은 노인 돌봄 전문가입니다. 위의 정보를 바탕으로 해당 날짜의 건강하고 즐거운 일정을 추천해주세요.
                
                일정은 다음을 포함해야 합니다:
                1. 식사 시간 (아침, 점심, 저녁)
                2. 약 복용 시간 (필요시)
                3. 산책/운동 시간
                4. 휴식 시간
                5. 취미 활동 시간
                
                응답은 반드시 JSON 객체 형식으로만 해주세요:
                {
                  "scheduleName": "일정명 (사용자가 입력한 활동이나 목적을 반영한 의미있는 이름, 예: '요양원 방문', '공원 산책', '친구 만나기' 등)",
                  "schedules": [
                    {
                      "scheduleName": "일정명",
                      "startTime": "HH:mm",
                      "endTime": "HH:mm",
                      "description": "일정 설명"
                    },
                    ...
                  ]
                }
                
                일정명(scheduleName)은 사용자가 입력한 내용을 바탕으로 의미있게 작성해주세요.
                예를 들어, "요양원과 사람을 만나게 될 날"이라고 입력했다면 "요양원 방문" 또는 "요양원 만남" 같은 이름을 사용하세요.
                단순히 날짜만 사용하지 마세요 (예: "2025-11-26 일정" ❌).
                
                일정은 오전 7시부터 오후 9시까지, 1-2시간 간격으로 5-7개 정도 추천해주세요.
                기존 일정과 겹치지 않도록 주의하세요.
                사용자의 건강 상태(병력, 알레르기, 건강 요구사항)를 반드시 고려하여 추천해주세요.
                
                %s
                """.formatted(contextBuilder.toString());

            String response = chatClient.prompt()
                    .user(recommendationPrompt)
                    .call()
                    .content();

            String json = aiUtilService.extractJson(response);
            log.info("일정 추천 원본 응답: {}", response);
            log.info("추출된 JSON: {}", json);

            // JSON이 배열인지 확인
            if (json == null || json.trim().isEmpty() || json.equals("{}")) {
                log.warn("JSON 추출 실패 또는 빈 응답");
                return Map.of("success", false, "message", "AI 응답에서 일정 정보를 추출할 수 없습니다.");
            }

            // JSON 파싱
            List<Map<String, Object>> scheduleList;
            String scheduleName = null;

            try {
                // 먼저 JSON이 배열인지 객체인지 확인
                String trimmedJson = json.trim();
                boolean isArray = trimmedJson.startsWith("[");
                boolean isObject = trimmedJson.startsWith("{");

                if (isObject) {
                    // 객체 형식으로 파싱 시도
                    @SuppressWarnings("unchecked")
                    Map<String, Object> obj = objectMapper.readValue(json, Map.class);

                    // scheduleName 추출
                    if (obj.containsKey("scheduleName")) {
                        scheduleName = obj.get("scheduleName").toString();
                    }

                    // schedules 배열 추출
                    if (obj.containsKey("schedules") && obj.get("schedules") instanceof List) {
                        @SuppressWarnings("unchecked")
                        List<Map<String, Object>> schedules = (List<Map<String, Object>>) obj.get("schedules");
                        scheduleList = schedules;
                        log.info("객체에서 schedules 배열 추출 성공 - 일정명: {}, 일정 개수: {}", scheduleName, scheduleList.size());
                    } else {
                        // schedules 키가 없으면 빈 리스트
                        log.warn("객체에 schedules 키가 없음: {}", obj.keySet());
                        scheduleList = new ArrayList<>();
                    }
                } else if (isArray) {
                    // 배열 형식으로 직접 파싱
                    @SuppressWarnings("unchecked")
                    List<Map<String, Object>> parsedList = objectMapper.readValue(json, List.class);
                    scheduleList = parsedList;

                    // 일정명이 없으면 활동 설명에서 생성
                    if (scheduleName == null && activityDescription != null && !activityDescription.isEmpty()) {
                        scheduleName = scheduleNameGenerationService.generateScheduleNameFromActivity(activityDescription);
                    }

                    log.info("배열로 파싱 성공 - 일정명: {}, 일정 개수: {}", scheduleName, scheduleList.size());
                } else {
                    log.error("JSON 형식이 올바르지 않음 (배열도 객체도 아님): {}", json.substring(0, Math.min(200, json.length())));
                    return Map.of("success", false, "message", "AI 응답 형식을 인식할 수 없습니다. 다시 시도해주세요.");
                }

                if (scheduleList == null || scheduleList.isEmpty()) {
                    log.warn("파싱된 일정 리스트가 비어있음");
                    return Map.of("success", false, "message", "추천된 일정이 없습니다.");
                }

                // 일정명이 없으면 기본값 생성
                if (scheduleName == null || scheduleName.trim().isEmpty()) {
                    scheduleName = scheduleNameGenerationService.generateScheduleNameFromActivity(activityDescription != null ? activityDescription : "");
                    if (scheduleName == null || scheduleName.trim().isEmpty()) {
                        scheduleName = targetDate.format(DateTimeFormatter.ofPattern("yyyy년 MM월 dd일")) + " 일정";
                    }
                }

                log.info("일정 추천 성공 - 일정명: {}, 일정 개수: {}", scheduleName, scheduleList.size());
            } catch (JsonProcessingException e) {
                log.error("JSON 파싱 실패 - JSON 길이: {}, 시작 부분: {}", json.length(),
                        json.substring(0, Math.min(500, json.length())), e);
                log.error("파싱 에러 상세: {}", e.getMessage());
                return Map.of("success", false, "message",
                        "AI 응답을 파싱하는 중 오류가 발생했습니다: " + e.getMessage() + ". 다시 시도해주세요.");
            } catch (Exception e) {
                log.error("예상치 못한 오류 발생 - JSON: {}", json.substring(0, Math.min(200, json.length())), e);
                return Map.of("success", false, "message", "일정 추천 중 오류가 발생했습니다: " + e.getMessage());
            }

            // 결과 반환
            Map<String, Object> result = new HashMap<>();
            result.put("success", true);
            result.put("schedules", scheduleList);
            result.put("scheduleName", scheduleName);
            result.put("date", targetDate.toString());

            return result;

        } catch (Exception e) {
            log.error("AI 일정 추천 실패", e);
            return Map.of("success", false, "message", "일정 추천 중 오류가 발생했습니다: " + e.getMessage());
        }
    }

    /**
     * 오늘의 일정을 AI가 추천/생성합니다.
     */
    private String handleScheduleRecommend(Integer recId, Map<String, Object> params, String userMessage) {
        try {
            LocalDate targetDate = params.containsKey("date") ?
                    LocalDate.parse(params.get("date").toString()) : LocalDate.now();

            // 사용자 정보 조회
            Recipient recipient = recipientService.getRecipientById(recId);
            if (recipient == null) {
                return "사용자 정보를 찾을 수 없어요.";
            }

            // 건강 데이터 조회
            List<HealthData> healthDataList = healthDataService.getHealthDataByRecId(recId);
            HealthData latestHealth = healthDataList != null && !healthDataList.isEmpty() ?
                    healthDataList.get(0) : null;

            // 오늘 식단 조회
            List<MealPlan> todayMeals = mealPlanService.getByRecIdAndDate(recId, targetDate);

            // 기존 일정 조회
            List<Schedule> existingSchedules = scheduleService.getSchedulesByDateRange(recId, targetDate, targetDate);

            // GPT에게 일정 추천 요청
            StringBuilder contextBuilder = new StringBuilder();
            contextBuilder.append(String.format("오늘은 %s입니다.\n\n",
                    targetDate.format(DateTimeFormatter.ofPattern("yyyy년 MM월 dd일"))));

            // 사용자 정보
            contextBuilder.append("[사용자 정보]\n");
            contextBuilder.append(String.format("이름: %s\n", recipient.getRecName()));
            if (recipient.getRecHealthNeeds() != null) {
                contextBuilder.append(String.format("건강 요구사항: %s\n", recipient.getRecHealthNeeds()));
            }
            if (recipient.getRecMedHistory() != null) {
                contextBuilder.append(String.format("병력: %s\n", recipient.getRecMedHistory()));
            }
            contextBuilder.append("\n");

            // 건강 데이터
            if (latestHealth != null) {
                contextBuilder.append("[최근 건강 데이터]\n");
                contextBuilder.append(String.format("종류: %s\n", latestHealth.getHealthType()));
                if (latestHealth.getHealthValue1() != null) {
                    contextBuilder.append(String.format("값1: %s\n", latestHealth.getHealthValue1()));
                }
                if (latestHealth.getHealthValue2() != null) {
                    contextBuilder.append(String.format("값2: %s\n", latestHealth.getHealthValue2()));
                }
                contextBuilder.append("\n");
            }

            // 오늘 식단
            if (todayMeals != null && !todayMeals.isEmpty()) {
                contextBuilder.append("[오늘 식단]\n");
                for (MealPlan meal : todayMeals) {
                    contextBuilder.append(String.format("- %s: %s\n", meal.getMealType(), meal.getMealMenu()));
                }
                contextBuilder.append("\n");
            }

            // 기존 일정
            if (existingSchedules != null && !existingSchedules.isEmpty()) {
                contextBuilder.append("[기존 일정]\n");
                for (Schedule schedule : existingSchedules) {
                    contextBuilder.append(String.format("- %s (%s ~ %s)\n",
                            schedule.getSchedName(),
                            schedule.getSchedStartTime(),
                            schedule.getSchedEndTime()));
                }
                contextBuilder.append("\n");
            }

            String recommendationPrompt = """
                당신은 노인 돌봄 전문가입니다. 위의 정보를 바탕으로 오늘 하루 건강하고 즐거운 일정을 추천해주세요.
                
                일정은 다음을 포함해야 합니다:
                1. 식사 시간 (아침, 점심, 저녁)
                2. 약 복용 시간 (필요시)
                3. 산책/운동 시간
                4. 휴식 시간
                5. 취미 활동 시간
                
                응답은 반드시 JSON 배열 형식으로만 해주세요:
                [
                  {
                    "scheduleName": "일정명",
                    "startTime": "HH:mm",
                    "endTime": "HH:mm"
                  },
                  ...
                ]
                
                일정은 오전 7시부터 오후 9시까지, 1-2시간 간격으로 5-7개 정도 추천해주세요.
                기존 일정과 겹치지 않도록 주의하세요.
                
                %s
                """.formatted(contextBuilder.toString());

            String response = chatClient.prompt()
                    .user(recommendationPrompt)
                    .call()
                    .content();

            String json = aiUtilService.extractJson(response);
            log.debug("일정 추천 원본 응답: {}", response);
            log.debug("추출된 JSON: {}", json);

            // JSON 파싱
            @SuppressWarnings("unchecked")
            List<Map<String, Object>> scheduleList = objectMapper.readValue(json, List.class);

            // 추천 결과를 임시 저장
            Map<String, Object> savedRecommendation = new HashMap<>();
            savedRecommendation.put("type", "SCHEDULE");
            savedRecommendation.put("date", targetDate.toString());
            savedRecommendation.put("data", scheduleList);
            savedRecommendation.put("timestamp", System.currentTimeMillis());
            recentScheduleRecommendations.put(recId, savedRecommendation);

            // 추천 일정을 자연어로 변환
            StringBuilder sb = new StringBuilder();
            sb.append(String.format("오늘(%s) 일정을 추천해드릴게요!\n\n",
                    targetDate.format(DateTimeFormatter.ofPattern("yyyy년 MM월 dd일"))));

            int index = 1;
            for (Map<String, Object> schedule : scheduleList) {
                String name = schedule.get("scheduleName") != null ?
                        schedule.get("scheduleName").toString() : "일정";
                String start = schedule.get("startTime") != null ?
                        schedule.get("startTime").toString() : "09:00";
                String end = schedule.get("endTime") != null ?
                        schedule.get("endTime").toString() : "10:00";

                sb.append(String.format("%d. %s\n   시간: %s ~ %s\n\n", index++, name, start, end));
            }

            sb.append("이 일정으로 등록하시겠어요? '네' 또는 '등록해줘'라고 말씀해주세요!");

            return sb.toString();
        } catch (Exception e) {
            log.error("일정 추천 실패", e);
            return "일정을 추천하는 중 문제가 발생했어요. 잠시 후 다시 시도해주세요.";
        }
    }

    /**
     * 추천받은 일정을 DB에 저장합니다.
     */
    private String handleScheduleSave(Integer recId, Map<String, Object> params, String userMessage) {
        try {
            Map<String, Object> savedRecommendation = recentScheduleRecommendations.get(recId);

            if (savedRecommendation == null || !"SCHEDULE".equals(savedRecommendation.get("type"))) {
                return "저장할 일정 정보를 찾을 수 없어요. 먼저 일정을 추천받아주세요.";
            }

            String dateStr = savedRecommendation.get("date").toString();
            LocalDate targetDate = LocalDate.parse(dateStr);

            @SuppressWarnings("unchecked")
            List<Map<String, Object>> scheduleList = (List<Map<String, Object>>) savedRecommendation.get("data");

            int savedCount = 0;
            StringBuilder savedSchedules = new StringBuilder();

            for (Map<String, Object> scheduleData : scheduleList) {
                Schedule schedule = new Schedule();
                schedule.setRecId(recId);
                schedule.setSchedDate(targetDate);
                schedule.setSchedName(scheduleData.get("scheduleName").toString());
                schedule.setSchedStartTime(scheduleData.get("startTime").toString());
                schedule.setSchedEndTime(scheduleData.get("endTime") != null ?
                        scheduleData.get("endTime").toString() :
                        scheduleData.get("startTime").toString());

                int result = scheduleService.createSchedule(schedule);
                if (result > 0) {
                    savedCount++;
                    savedSchedules.append(String.format("- %s (%s ~ %s)\n",
                            schedule.getSchedName(),
                            schedule.getSchedStartTime(),
                            schedule.getSchedEndTime()));
                }
            }

            // 저장된 추천 결과 제거
            recentScheduleRecommendations.remove(recId);

            log.info("일정 자동 저장 완료 - recId: {}, date: {}, 개수: {}",
                    recId, targetDate, savedCount);

            return String.format("일정을 등록했어요!\n\n" +
                            "등록된 일정 (%d개):\n%s\n" +
                            "%s로 모두 등록되었어요!",
                    savedCount,
                    savedSchedules.toString(),
                    targetDate.format(DateTimeFormatter.ofPattern("yyyy년 MM월 dd일")));
        } catch (Exception e) {
            log.error("일정 저장 실패", e);
            return "일정을 저장하는 중 문제가 발생했어요. 다시 시도해주세요.";
        }
    }


    private Map<String, Object> parseParameters(String parametersJson) {
        try {
            if (parametersJson == null || parametersJson.isEmpty() || parametersJson.equals("{}")) {
                return new HashMap<>();
            }
            @SuppressWarnings("unchecked")
            Map<String, Object> result = objectMapper.readValue(parametersJson, Map.class);
            return result;
        } catch (JsonProcessingException e) {
            log.warn("파라미터 파싱 실패: {}", parametersJson, e);
            return new HashMap<>();
        }
    }
}