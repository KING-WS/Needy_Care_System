package edu.sm.app.service;

import edu.sm.app.dto.Caregiver;
import edu.sm.app.repository.CareMatchingRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class CareMatchingService {

    private final CareMatchingRepository careMatchingRepository;

    public Caregiver getMatchedCaregiverByRecId(int recId) {
        return careMatchingRepository.getMatchedCaregiverByRecId(recId);
    }
}
