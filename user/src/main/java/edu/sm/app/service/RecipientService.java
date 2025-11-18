package edu.sm.app.service;

import edu.sm.app.dto.Recipient;
import edu.sm.app.repository.RecipientRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import java.util.List;

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

    // 돌봄 대상자 등록
    public void registerRecipient(Recipient recipient) {
        log.info("돌봄 대상자 등록 - recName: {}, custId: {}", recipient.getRecName(), recipient.getCustId());
        int result = recipientRepository.insertRecipient(recipient);
        if (result <= 0) {
            throw new RuntimeException("돌봄 대상자 등록 실패");
        }
    }
}