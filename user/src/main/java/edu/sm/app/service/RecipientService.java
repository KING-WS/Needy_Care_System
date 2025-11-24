package edu.sm.app.service;

import edu.sm.app.dto.Recipient;
import edu.sm.app.repository.RecipientRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;

@Service
@Slf4j
@RequiredArgsConstructor
public class RecipientService {

    private final RecipientRepository recipientRepository;

    // custId로 돌봄 대상자 목록 조회
    public List<Recipient> getRecipientsByCustId(Integer custId) {
        log.info("돌봄 대상자 목록 조회 - custId: {}", custId);
        return recipientRepository.selectRecipientsByCustId(custId);
    }

    // recId로 특정 돌봄 대상자 조회
    public Recipient getRecipientById(Integer recId) {
        log.info("돌봄 대상자 조회 - recId: {}", recId);
        return recipientRepository.selectRecipientById(recId);
    }

    // 키오스크 코드로 돌봄 대상자 조회
    public Recipient getRecipientByKioskCode(String kioskCode) {
        log.info("돌봄 대상자 조회 (키오스크) - kioskCode: {}", kioskCode);
        return recipientRepository.selectRecipientByKioskCode(kioskCode);
    }

    // 돌봄 대상자 등록
    public void registerRecipient(Recipient recipient) {
        log.info("돌봄 대상자 등록 - recName: {}, custId: {}", recipient.getRecName(), recipient.getCustId());
        
        // 키오스크 코드가 없으면 자동 생성
        if (recipient.getRecKioskCode() == null || recipient.getRecKioskCode().isEmpty()) {
            String kioskCode = generateKioskCode();
            recipient.setRecKioskCode(kioskCode);
            log.info("키오스크 코드 자동 생성: {}", kioskCode);
        }
        
        int result = recipientRepository.insertRecipient(recipient);
        if (result <= 0) {
            throw new RuntimeException("돌봄 대상자 등록 실패");
        }
    }
    
    /**
     * 키오스크 접속용 고유 코드 생성
     * 형식: XXXX-XXXX-XXXX (12자리, 대문자+숫자)
     */
    private String generateKioskCode() {
        String uuid = UUID.randomUUID().toString().replace("-", "").toUpperCase();
        // 12자리로 자르고, 4자리씩 하이픈으로 구분
        String code = uuid.substring(0, 12);
        return code.substring(0, 4) + "-" + code.substring(4, 8) + "-" + code.substring(8, 12);
    }

    // 돌봄 대상자 삭제 (논리 삭제)
    public void deleteRecipient(Integer recId) {
        log.info("돌봄 대상자 삭제 - recId: {}", recId);
        int result = recipientRepository.deleteRecipient(recId);
        if (result <= 0) {
            throw new RuntimeException("돌봄 대상자 삭제 실패");
        }
    }

    // 돌봄 대상자 수정
    public void updateRecipient(Recipient recipient) {
        log.info("돌봄 대상자 수정 - recId: {}, recName: {}", recipient.getRecId(), recipient.getRecName());
        int result = recipientRepository.updateRecipient(recipient);
        if (result <= 0) {
            throw new RuntimeException("돌봄 대상자 수정 실패");
        }
    }

    // 마지막 접속 시간 업데이트
    @Transactional
    public void updateLastConnectedAt(Integer recId, LocalDateTime lastConnectedAt) {
        log.info("돌봄 대상자 {} 마지막 접속 시간 업데이트: {}", recId, lastConnectedAt);
        recipientRepository.updateLastConnectedAt(recId, lastConnectedAt);
    }

    // 위치 정보 업데이트
    @Transactional
    public void updateLocation(Integer recId, Double recLatitude, Double recLongitude) {
        log.info("돌봄 대상자 {} 위치 정보 업데이트: 위도={}, 경도={}", recId, recLatitude, recLongitude);
        recipientRepository.updateLocation(recId, recLatitude, recLongitude);
    }
}