package edu.sm.app.service;

import com.github.pagehelper.Page;
import com.github.pagehelper.PageHelper;
import edu.sm.app.dto.Caregiver;
import edu.sm.app.repository.CaregiverRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class CaregiverService {

    private final CaregiverRepository caregiverRepository;

    public List<Caregiver> getAllCaregivers() {
        return caregiverRepository.selectAllCaregivers();
    }

    public Page<Caregiver> getPage(int pageNo) {
        PageHelper.startPage(pageNo, 5); // Show 5 caregivers per page
        return (Page<Caregiver>) caregiverRepository.selectAllCaregivers();
    }

    public Caregiver get(int id) {
        return caregiverRepository.select(id);
    }

    public void modify(Caregiver caregiver) {
        caregiverRepository.update(caregiver);
    }
}