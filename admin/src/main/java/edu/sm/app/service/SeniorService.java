package edu.sm.app.service;

import com.github.pagehelper.Page;
import com.github.pagehelper.PageHelper;
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

    public Page<Senior> getPage(int pageNo) {
        PageHelper.startPage(pageNo, 5); // Show 5 seniors per page
        List<Senior> seniors = getAllSeniors(); // This will now be a paged result
        return (Page<Senior>) seniors;
    }

    public Senior get(int id) {
        Senior senior = seniorRepository.select(id);
        if (senior != null && senior.getRecBirthday() != null) {
            senior.setAge(calculateAge(senior.getRecBirthday()));
        }
        return senior;
    }

    public void register(Senior senior) {
        seniorRepository.insert(senior);
    }

    public void modify(Senior senior) {
        seniorRepository.update(senior);
    }

    public int getSeniorCount() {
        return seniorRepository.selectSeniorCount();
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
