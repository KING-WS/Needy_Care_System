package edu.sm.app.service;

import edu.sm.app.dto.CareRecipient;
import edu.sm.app.repository.CareRecipientRepository;
import edu.sm.common.frame.SmService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class CareRecipientService implements SmService<CareRecipient, Integer> {

    final CareRecipientRepository careRecipientRepository;

    @Override
    public void register(CareRecipient careRecipient) throws Exception {
        careRecipientRepository.insert(careRecipient);
    }

    @Override
    public void modify(CareRecipient careRecipient) throws Exception {
        careRecipientRepository.update(careRecipient);
    }

    @Override
    public void remove(Integer s) throws Exception {
        careRecipientRepository.delete(s);
    }

    @Override
    public List<CareRecipient> get() throws Exception {
        return careRecipientRepository.selectAll();
    }

    @Override
    public CareRecipient get(Integer s) throws Exception {
        return careRecipientRepository.select(s);
    }

    public List<CareRecipient> getByCustId(Integer custId) throws Exception {
        return careRecipientRepository.selectByCustId(custId);
    }
}

