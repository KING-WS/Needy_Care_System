package edu.sm.app.aiservice;

import edu.sm.app.dto.Recipient;
import edu.sm.app.service.RecipientService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * 돌봄대상자 상태 조회 서비스
 */
@Service
@Slf4j
public class RecipientStatusService {
    
    private final RecipientService recipientService;
    
    public RecipientStatusService(RecipientService recipientService) {
        this.recipientService = recipientService;
    }
    
    /**
     * 사용자 메시지에서 돌봄대상자 이름 추출
     */
    public String extractRecipientName(String userMessage) {
        // "신창영의 상태", "김철수 건강", "이영희는", "홍길동 상태" 등의 패턴 매칭
        Pattern pattern = Pattern.compile("([가-힣]{2,4})(?:의|는|이|가|상태|건강|정보)");
        Matcher matcher = pattern.matcher(userMessage);
        
        if (matcher.find()) {
            return matcher.group(1);
        }
        
        return null;
    }
    
    /**
     * 돌봄대상자 상태 조회
     */
    public String getRecipientStatus(Integer recId, String userMessage) {
        try {
            // 1. 현재 recId로 돌봄대상자 정보 조회하여 custId 얻기
            Recipient currentRecipient = recipientService.getRecipientById(recId);
            if (currentRecipient == null) {
                return "사용자 정보를 찾을 수 없어요.";
            }
            
            Integer custId = currentRecipient.getCustId();
            
            // 2. 사용자 메시지에서 돌봄대상자 이름 추출
            String recipientName = extractRecipientName(userMessage);
            if (recipientName == null || recipientName.isEmpty()) {
                return "어떤 분의 상태를 확인하고 싶으신가요? 이름을 알려주세요. (예: '신창영 상태 어때?')";
            }
            
            // 3. custId로 등록된 모든 돌봄대상자 목록 조회
            java.util.List<Recipient> recipients = recipientService.getRecipientsByCustId(custId);
            if (recipients == null || recipients.isEmpty()) {
                return "등록된 돌봄대상자가 없어요.";
            }
            
            // 4. 이름으로 돌봄대상자 찾기 (부분 일치)
            Recipient foundRecipient = null;
            for (Recipient recipient : recipients) {
                if (recipient.getRecName() != null && 
                    recipient.getRecName().contains(recipientName)) {
                    foundRecipient = recipient;
                    break;
                }
            }
            
            if (foundRecipient == null) {
                // 정확히 일치하는 것이 없으면 이름 목록 제공
                StringBuilder nameList = new StringBuilder();
                nameList.append("'").append(recipientName).append("'님을 찾을 수 없어요.\n\n");
                nameList.append("등록된 돌봄대상자 목록:\n");
                for (Recipient r : recipients) {
                    nameList.append("- ").append(r.getRecName()).append("\n");
                }
                nameList.append("\n정확한 이름을 입력해주세요.");
                return nameList.toString();
            }
            
            // 5. 돌봄대상자의 건강정보 조회 및 포맷팅
            StringBuilder statusInfo = new StringBuilder();
            statusInfo.append(String.format("'%s'님의 건강 상태 정보예요:\n\n", foundRecipient.getRecName()));
            
            // 기본 정보
            if (foundRecipient.getRecTypeCode() != null) {
                String typeName = switch(foundRecipient.getRecTypeCode()) {
                    case "ELDERLY" -> "노인/고령자";
                    case "PREGNANT" -> "임산부";
                    case "DISABLED" -> "장애인";
                    default -> foundRecipient.getRecTypeCode();
                };
                statusInfo.append(String.format("대상자 유형: %s\n", typeName));
            }
            
            // 병력
            if (foundRecipient.getRecMedHistory() != null && !foundRecipient.getRecMedHistory().trim().isEmpty()) {
                statusInfo.append(String.format("병력: %s\n", foundRecipient.getRecMedHistory()));
            } else {
                statusInfo.append("병력: 등록된 정보가 없습니다.\n");
            }
            
            // 알레르기
            if (foundRecipient.getRecAllergies() != null && !foundRecipient.getRecAllergies().trim().isEmpty()) {
                statusInfo.append(String.format("알레르기: %s\n", foundRecipient.getRecAllergies()));
            } else {
                statusInfo.append("알레르기: 등록된 정보가 없습니다.\n");
            }
            
            // 건강 요구사항
            if (foundRecipient.getRecHealthNeeds() != null && !foundRecipient.getRecHealthNeeds().trim().isEmpty()) {
                statusInfo.append(String.format("건강 요구사항: %s\n", foundRecipient.getRecHealthNeeds()));
            } else {
                statusInfo.append("건강 요구사항: 등록된 정보가 없습니다.\n");
            }
            
            // 특이사항
            if (foundRecipient.getRecSpecNotes() != null && !foundRecipient.getRecSpecNotes().trim().isEmpty()) {
                statusInfo.append(String.format("특이사항: %s\n", foundRecipient.getRecSpecNotes()));
            } else {
                statusInfo.append("특이사항: 등록된 정보가 없습니다.\n");
            }
            
            return statusInfo.toString();
            
        } catch (Exception e) {
            log.error("돌봄대상자 상태 조회 실패", e);
            return "돌봄대상자 상태를 조회하는 중 문제가 발생했어요.";
        }
    }
}

