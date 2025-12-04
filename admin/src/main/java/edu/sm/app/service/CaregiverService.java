package edu.sm.app.service;

import com.github.pagehelper.Page;
import com.github.pagehelper.PageHelper;
import edu.sm.app.dto.ActivityItem;
import edu.sm.app.dto.Caregiver;
import edu.sm.app.repository.CaregiverRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;

@Service
@RequiredArgsConstructor
public class CaregiverService {

    private final CaregiverRepository caregiverRepository;
    private final ActivityFeedNotifierService activityFeedNotifierService;

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
        caregiverRepository.insert(caregiver); // DB에 먼저 삽입

        // 활동 피드에 실시간 알림 전송
        ActivityItem activityItem = ActivityItem.builder()
                .message("새로운 요양사님이 가입했습니다: " + caregiver.getCaregiverName())
                .timestamp(LocalDateTime.now())
                .iconClass("bi-person-plus-fill")
                .bgClass("bg-primary")
                .link("/caregiver/detail/" + caregiver.getCaregiverId())
                .build();
        activityFeedNotifierService.notifyNewActivity(activityItem);
    }

    public int getCaregiverCount() {
        return caregiverRepository.selectCaregiverCount();
    }
}