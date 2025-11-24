package edu.sm.app.aiservice;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
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
    private final HealthDataService healthDataService;
    private final MealPlanService mealPlanService;
    private final ScheduleService scheduleService;
    private final MapCourseService mapCourseService;
    private final RecipientService recipientService;
    private final AiMealService aiMealService;
    private final ObjectMapper objectMapper;
    
    // 최근 추천 결과를 임시 저장 (세션 대신 메모리 사용 - 실제로는 Redis나 세션 사용 권장)
    private final Map<Integer, Map<String, Object>> recentRecommendations = new HashMap<>();

    // 팀원의 AiImageService처럼 Builder로 주입받아 생성하는 것이 가장 안전한 방식입니다.
    public AiChatService(
            ChatClient.Builder chatClientBuilder, 
            ChatLogService chatLogService,
            HealthDataService healthDataService,
            MealPlanService mealPlanService,
            ScheduleService scheduleService,
            MapCourseService mapCourseService,
            RecipientService recipientService,
            AiMealService aiMealService,
            ObjectMapper objectMapper) {
        this.chatClient = chatClientBuilder.build();
        this.chatLogService = chatLogService;
        this.healthDataService = healthDataService;
        this.mealPlanService = mealPlanService;
        this.scheduleService = scheduleService;
        this.mapCourseService = mapCourseService;
        this.recipientService = recipientService;
        this.aiMealService = aiMealService;
        this.objectMapper = objectMapper;
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
    
    private static final String INTENT_ANALYSIS_PROMPT = """
            사용자의 메시지를 분석해서 의도를 파악해주세요.
            
            가능한 의도 타입:
            - HEALTH_QUERY: 건강 상태 조회 (예: "내 건강 어때?", "혈압 알려줘", "건강 상태 확인")
            - HEALTH_ANALYSIS: 건강 데이터 분석 (예: "건강 상태 분석해줘", "최근 건강 트렌드 알려줘")
            - MEAL_RECOMMEND: 식단 추천 (예: "오늘 식단 추천해줘", "저염식 추천해줘", "식단 추천")
            - MEAL_QUERY: 식단 조회 (예: "오늘 식단 뭐야?", "오늘의 식단 알려줘", "어제 저녁 뭐 먹었어?", "오늘 밥 뭐야?", "식단 알려줘", "오늘 먹을 것 뭐야?")
            - MEAL_SAVE: 식단 저장 확인 (예: "네", "등록해줘", "저장해줘", "좋아", "그렇게 해줘" - 이전 대화에서 식단 추천이 있었을 때)
            - SCHEDULE_CREATE: 일정 등록 (예: "내일 오후 3시 병원 가기", "다음주 월요일 약 먹기", "오늘 오후 2시 약 먹기")
            - SCHEDULE_QUERY: 일정 조회 (예: "오늘 일정 알려줘", "오늘의 일정", "오늘 일정 뭐야?", "이번 주 일정 뭐야?", "일정 확인", "오늘 스케줄", "오늘 할 일")
            - SCHEDULE_RECOMMEND: 일정 추천/생성 (예: "오늘 일정 짜줘", "오늘 일정 추천해줘", "오늘 할 일 정해줘", "오늘 스케줄 만들어줘", "오늘 계획 세워줘")
            - SCHEDULE_SAVE: 일정 저장 확인 (예: "네", "등록해줘", "저장해줘", "좋아" - 이전 대화에서 일정 추천이 있었을 때)
            - WALKING_ROUTE: 산책 경로 추천 (예: "산책 경로 추천해줘", "가까운 산책 코스 알려줘")
            - GENERAL_CHAT: 일반 대화 (위의 의도에 해당하지 않는 모든 대화)
            
            중요: 
            - "오늘의 식단", "오늘 식단", "식단 알려줘", "오늘 밥" 같은 표현은 모두 MEAL_QUERY입니다.
            - "오늘의 일정", "오늘 일정", "오늘 할 일", "오늘 스케줄" 같은 표현은 모두 SCHEDULE_QUERY입니다.
            - "오늘 일정 짜줘", "오늘 일정 추천해줘", "오늘 계획 세워줘" 같은 표현은 모두 SCHEDULE_RECOMMEND입니다.
            - 이전 대화에서 식단 추천이 있었고, 사용자가 "네", "등록해줘" 등으로 응답하면 MEAL_SAVE입니다.
            - 이전 대화에서 일정 추천이 있었고, 사용자가 "네", "등록해줘" 등으로 응답하면 SCHEDULE_SAVE입니다.
            
            응답은 반드시 JSON 형식으로만 해주세요. 다른 설명 없이 JSON만 반환하세요:
            {
              "intent": "의도타입",
              "parameters": {},
              "confidence": 0.9
            }
            
            사용자 메시지: %s
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
        try {
            String prompt = INTENT_ANALYSIS_PROMPT.formatted(userMessage);
            log.debug("의도 분석 프롬프트: {}", prompt);
            
            String response = chatClient.prompt()
                    .user(prompt)
                    .call()
                    .content();
            
            log.debug("의도 분석 원본 응답: {}", response);
            
            // JSON 추출
            String json = extractJson(response);
            log.debug("추출된 JSON: {}", json);
            
            // JSON 파싱
            @SuppressWarnings("unchecked")
            Map<String, Object> intentMap = objectMapper.readValue(json, Map.class);
            
            ChatIntent intent = new ChatIntent();
            String intentType = intentMap.get("intent") != null ? 
                    intentMap.get("intent").toString() : "GENERAL_CHAT";
            intent.setIntent(intentType);
            
            Object paramsObj = intentMap.get("parameters");
            String paramsJson = "{}";
            if (paramsObj != null) {
                if (paramsObj instanceof String) {
                    paramsJson = (String) paramsObj;
                } else {
                    paramsJson = objectMapper.writeValueAsString(paramsObj);
                }
            }
            intent.setParameters(paramsJson);
            
            Object confObj = intentMap.get("confidence");
            double confidence = 0.5;
            if (confObj != null) {
                if (confObj instanceof Number) {
                    confidence = ((Number) confObj).doubleValue();
                } else {
                    try {
                        confidence = Double.parseDouble(confObj.toString());
                    } catch (NumberFormatException e) {
                        confidence = 0.5;
                    }
                }
            }
            intent.setConfidence(confidence);
            
            return intent;
        } catch (Exception e) {
            log.error("의도 분석 실패", e);
            // 기본값: 일반 대화
            return new ChatIntent("GENERAL_CHAT", "{}", 0.5);
        }
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
                params = extractDateFromMessage(userMessage, params);
            }
            
            switch (intent.getIntent()) {
                case "HEALTH_QUERY":
                    return handleHealthQuery(recId, params);
                case "HEALTH_ANALYSIS":
                    return handleHealthAnalysis(recId, params);
                case "MEAL_RECOMMEND":
                    return handleMealRecommend(recId, params, userMessage);
                case "MEAL_QUERY":
                    return handleMealQuery(recId, params);
                case "MEAL_SAVE":
                    return handleMealSave(recId, params, userMessage);
                case "SCHEDULE_CREATE":
                    return handleScheduleCreate(recId, params, userMessage);
                case "SCHEDULE_QUERY":
                    return handleScheduleQuery(recId, params);
                case "SCHEDULE_RECOMMEND":
                    return handleScheduleRecommend(recId, params, userMessage);
                case "SCHEDULE_SAVE":
                    return handleScheduleSave(recId, params, userMessage);
                case "WALKING_ROUTE":
                    return handleWalkingRoute(recId, params);
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
    
    // ========== 기능별 핸들러 메서드 ==========
    
    private String handleHealthQuery(Integer recId, Map<String, Object> params) {
        try {
            List<HealthData> healthDataList = healthDataService.getHealthDataByRecId(recId);
            if (healthDataList == null || healthDataList.isEmpty()) {
                return "아직 건강 데이터가 등록되지 않았어요. 건강 데이터를 먼저 등록해주세요.";
            }
            
            HealthData latest = healthDataList.get(0);
            String healthType = latest.getHealthType();
            String value1 = latest.getHealthValue1() != null ? latest.getHealthValue1().toString() : "-";
            String value2 = latest.getHealthValue2() != null ? latest.getHealthValue2().toString() : "-";
            String measuredAt = latest.getHealthMeasuredAt() != null ? 
                    latest.getHealthMeasuredAt().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm")) : "-";
            
            return String.format("최근 건강 데이터를 확인했어요.\n" +
                    "종류: %s\n" +
                    "값1: %s\n" +
                    "값2: %s\n" +
                    "측정 시간: %s", healthType, value1, value2, measuredAt);
        } catch (Exception e) {
            log.error("건강 데이터 조회 실패", e);
            return "건강 데이터를 조회하는 중 문제가 발생했어요.";
        }
    }
    
    private String handleHealthAnalysis(Integer recId, Map<String, Object> params) {
        try {
            List<HealthData> healthDataList = healthDataService.getRecentHealthDataByType(recId, "BLOOD_PRESSURE", 7);
            if (healthDataList == null || healthDataList.isEmpty()) {
                return "분석할 건강 데이터가 충분하지 않아요. 더 많은 데이터를 등록해주세요.";
            }
            
            // 간단한 통계 계산
            double avgValue1 = healthDataList.stream()
                    .filter(h -> h.getHealthValue1() != null)
                    .mapToDouble(h -> h.getHealthValue1().doubleValue())
                    .average()
                    .orElse(0.0);
            
            return String.format("최근 7일간의 건강 데이터를 분석했어요.\n" +
                    "평균값: %.1f\n" +
                    "데이터 개수: %d개\n" +
                    "전반적으로 건강 상태를 잘 관리하고 계시는 것 같아요!", 
                    avgValue1, healthDataList.size());
        } catch (Exception e) {
            log.error("건강 데이터 분석 실패", e);
            return "건강 데이터를 분석하는 중 문제가 발생했어요.";
        }
    }
    
    private String handleMealRecommend(Integer recId, Map<String, Object> params, String userMessage) {
        try {
            Recipient recipient = recipientService.getRecipientById(recId);
            String preferences = recipient != null && recipient.getRecHealthNeeds() != null ? 
                    recipient.getRecHealthNeeds() : "건강한 식단";
            
            // 사용자 메시지에서 선호도 추출 시도
            if (userMessage.contains("저염") || userMessage.contains("싱겁")) {
                preferences = "저염식";
            } else if (userMessage.contains("고단백") || userMessage.contains("단백질")) {
                preferences = "고단백";
            } else if (userMessage.contains("저칼로리") || userMessage.contains("다이어트")) {
                preferences = "저칼로리";
            }
            
            Map<String, String> recommendation = aiMealService.getMealRecommendation(preferences);
            
            if (recommendation.containsKey("error")) {
                return recommendation.get("error");
            }
            
            // 추천 결과를 임시 저장 (사용자가 저장을 원할 때 사용)
            Map<String, Object> savedRecommendation = new HashMap<>();
            savedRecommendation.put("type", "MEAL");
            savedRecommendation.put("data", recommendation);
            savedRecommendation.put("timestamp", System.currentTimeMillis());
            recentRecommendations.put(recId, savedRecommendation);
            
            return String.format("식단을 추천해드릴게요!\n" +
                    "메뉴: %s\n" +
                    "칼로리: %s\n" +
                    "단백질: %s\n" +
                    "탄수화물: %s\n" +
                    "지방: %s\n" +
                    "설명: %s\n\n" +
                    "이 식단을 등록하시겠어요? '네' 또는 '등록해줘'라고 말씀해주세요!",
                    recommendation.get("mealName"),
                    recommendation.get("calories"),
                    recommendation.get("protein"),
                    recommendation.get("carbohydrates"),
                    recommendation.get("fats"),
                    recommendation.get("description"));
        } catch (Exception e) {
            log.error("식단 추천 실패", e);
            return "식단을 추천하는 중 문제가 발생했어요.";
        }
    }
    
    /**
     * 추천받은 식단을 DB에 저장합니다.
     */
    private String handleMealSave(Integer recId, Map<String, Object> params, String userMessage) {
        try {
            Map<String, Object> savedRecommendation = recentRecommendations.get(recId);
            
            if (savedRecommendation == null || !"MEAL".equals(savedRecommendation.get("type"))) {
                return "저장할 식단 정보를 찾을 수 없어요. 먼저 식단을 추천받아주세요.";
            }
            
            @SuppressWarnings("unchecked")
            Map<String, String> mealData = (Map<String, String>) savedRecommendation.get("data");
            
            // 식사 타입 결정 (사용자 메시지에서 추출 시도, 없으면 점심으로 기본값)
            String mealType = "점심";
            if (userMessage.contains("아침") || userMessage.contains("조식")) {
                mealType = "아침";
            } else if (userMessage.contains("저녁") || userMessage.contains("석식")) {
                mealType = "저녁";
            }
            
            // 칼로리 파싱
            String caloriesStr = mealData.get("calories");
            Integer calories = 0;
            if (caloriesStr != null) {
                try {
                    calories = Integer.parseInt(caloriesStr.replaceAll("[^0-9]", ""));
                } catch (NumberFormatException e) {
                    log.warn("칼로리 파싱 실패: {}", caloriesStr);
                }
            }
            
            // MealPlan 생성 및 저장
            MealPlan mealPlan = MealPlan.builder()
                    .recId(recId)
                    .mealDate(LocalDate.now())
                    .mealType(mealType)
                    .mealMenu(mealData.get("mealName"))
                    .mealCalories(calories)
                    .isDeleted("N")
                    .build();
            
            mealPlanService.register(mealPlan);
            
            // 저장된 추천 결과 제거
            recentRecommendations.remove(recId);
            
            log.info("식단 자동 저장 완료 - recId: {}, mealType: {}, menu: {}", 
                    recId, mealType, mealData.get("mealName"));
            
            return String.format("식단을 등록했어요!\n" +
                    "메뉴: %s\n" +
                    "식사: %s\n" +
                    "칼로리: %dkcal\n" +
                    "오늘 %s로 등록되었어요!",
                    mealData.get("mealName"),
                    mealType,
                    calories,
                    LocalDate.now().format(DateTimeFormatter.ofPattern("yyyy년 MM월 dd일")));
        } catch (Exception e) {
            log.error("식단 저장 실패", e);
            return "식단을 저장하는 중 문제가 발생했어요. 다시 시도해주세요.";
        }
    }
    
    private String handleMealQuery(Integer recId, Map<String, Object> params) {
        try {
            LocalDate date = params.containsKey("date") ? 
                    LocalDate.parse(params.get("date").toString()) : LocalDate.now();
            
            List<MealPlan> meals = mealPlanService.getByRecIdAndDate(recId, date);
            if (meals == null || meals.isEmpty()) {
                return String.format("%s 식단이 등록되지 않았어요.", 
                        date.format(DateTimeFormatter.ofPattern("yyyy년 MM월 dd일")));
            }
            
            StringBuilder sb = new StringBuilder();
            sb.append(String.format("%s 식단이에요:\n", 
                    date.format(DateTimeFormatter.ofPattern("yyyy년 MM월 dd일"))));
            
            for (MealPlan meal : meals) {
                sb.append(String.format("- %s: %s (칼로리: %dkcal)\n",
                        meal.getMealType(),
                        meal.getMealMenu(),
                        meal.getMealCalories() != null ? meal.getMealCalories() : 0));
            }
            
            return sb.toString();
        } catch (Exception e) {
            log.error("식단 조회 실패", e);
            return "식단을 조회하는 중 문제가 발생했어요.";
        }
    }
    
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
            
            String json = extractJson(extractionResponse);
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
            
            String json = extractJson(response);
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
            recentRecommendations.put(recId, savedRecommendation);
            
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
            Map<String, Object> savedRecommendation = recentRecommendations.get(recId);
            
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
            recentRecommendations.remove(recId);
            
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
    
    private String handleWalkingRoute(Integer recId, Map<String, Object> params) {
        try {
            List<MapCourse> courses = mapCourseService.getCoursesByRecId(recId);
            if (courses == null || courses.isEmpty()) {
                return "등록된 산책 코스가 없어요. 먼저 산책 코스를 등록해주세요.";
            }
            
            StringBuilder sb = new StringBuilder();
            sb.append("추천 산책 코스예요:\n");
            
            for (MapCourse course : courses) {
                sb.append(String.format("- %s (타입: %s)\n",
                        course.getCourseName(),
                        course.getCourseType() != null ? course.getCourseType() : "일반"));
            }
            
            return sb.toString();
        } catch (Exception e) {
            log.error("산책 코스 조회 실패", e);
            return "산책 코스를 조회하는 중 문제가 발생했어요.";
        }
    }
    
    // ========== 유틸리티 메서드 ==========
    
    /**
     * 사용자 메시지에서 날짜 정보를 추출합니다.
     */
    private Map<String, Object> extractDateFromMessage(String userMessage, Map<String, Object> params) {
        try {
            // 이미 params에 날짜가 있으면 그대로 사용
            if (params.containsKey("date")) {
                return params;
            }
            
            // 간단한 날짜 추출 (오늘, 내일, 모레 등)
            LocalDate extractedDate = LocalDate.now();
            
            if (userMessage.contains("오늘") || userMessage.contains("오늘의")) {
                extractedDate = LocalDate.now();
            } else if (userMessage.contains("내일")) {
                extractedDate = LocalDate.now().plusDays(1);
            } else if (userMessage.contains("모레")) {
                extractedDate = LocalDate.now().plusDays(2);
            } else if (userMessage.contains("어제")) {
                extractedDate = LocalDate.now().minusDays(1);
            } else if (userMessage.contains("다음주")) {
                extractedDate = LocalDate.now().plusWeeks(1);
            } else if (userMessage.contains("이번주")) {
                extractedDate = LocalDate.now();
            }
            
            // 추출된 날짜를 params에 추가
            params.put("date", extractedDate.toString());
            log.debug("메시지에서 날짜 추출: {} -> {}", userMessage, extractedDate);
            
        } catch (Exception e) {
            log.warn("날짜 추출 실패, 기본값(오늘) 사용: {}", userMessage, e);
        }
        
        return params;
    }
    
    private String extractJson(String text) {
        int firstBrace = text.indexOf('{');
        int lastBrace = text.lastIndexOf('}');
        
        if (firstBrace != -1 && lastBrace != -1 && lastBrace > firstBrace) {
            return text.substring(firstBrace, lastBrace + 1);
        }
        return "{}";
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