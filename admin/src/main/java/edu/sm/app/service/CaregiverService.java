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

    public Page<Caregiver> getPage(int pageNo, String sort, String order) {
        PageHelper.startPage(pageNo, 10); // 1페이지당 요양사 10명 표시
        PageHelper.orderBy(sort + " " + order);
        return (Page<Caregiver>) caregiverRepository.selectAllCaregivers();
    }

    public Caregiver get(int id) {
        return caregiverRepository.select(id);
    }

    public void modify(Caregiver caregiver) {
        caregiverRepository.update(caregiver);
    }

    public void register(Caregiver caregiver) throws Exception {
        caregiver.setIsDeleted("N");
        caregiverRepository.insert(caregiver);
    }

    public int getCaregiverCount() {
        return caregiverRepository.selectCaregiverCount();
    }
}