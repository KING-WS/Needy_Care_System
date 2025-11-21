package edu.sm.app.service;

import edu.sm.app.dto.Senior;
import edu.sm.app.repository.SeniorRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.Calendar;
import java.util.List;
import java.util.Date;

@Service
@RequiredArgsConstructor
public class SeniorService {

    private final SeniorRepository seniorRepository;

    public List<Senior> getAllSeniors() {
        List<Senior> seniors = seniorRepository.selectAllSeniors();
        for (Senior senior : seniors) {
            if (senior.getRecBirthday() != null) {
                senior.setAge(calculateAge(senior.getRecBirthday()));
            }
        }
        return seniors;
    }

    private int calculateAge(Date birthDate) {
        if (birthDate == null) {
            return 0;
        }
        Calendar birth = Calendar.getInstance();
        birth.setTime(birthDate);
        Calendar today = Calendar.getInstance();

        int age = today.get(Calendar.YEAR) - birth.get(Calendar.YEAR);
        if (today.get(Calendar.DAY_OF_YEAR) < birth.get(Calendar.DAY_OF_YEAR)) {
            age--;
        }
        return age;
    }
}
