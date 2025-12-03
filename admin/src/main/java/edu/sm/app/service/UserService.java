package edu.sm.app.service;

import com.github.pagehelper.Page;
import com.github.pagehelper.PageHelper;
import edu.sm.app.dto.DailyUserCountDTO;
import edu.sm.app.dto.User;
import edu.sm.app.dto.UserSearch;
import edu.sm.app.repository.UserRepository;
import edu.sm.common.frame.SmService;
import lombok.RequiredArgsConstructor;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class UserService implements SmService<User, Integer> {

    final UserRepository custRepository;
    final PasswordEncoder passwordEncoder;

    @Override
    public void register(User cust) throws Exception {
        cust.setCustPwd(passwordEncoder.encode(cust.getCustPwd()));
        cust.setIsDeleted("N"); // Set default value
        custRepository.insert(cust);
    }

    @Override
    public void modify(User cust) throws Exception {
        custRepository.update(cust);
    }

    @Override
    public void remove(Integer s) throws Exception {
        custRepository.delete(s);
    }

    @Override
    public List<User> get() throws Exception {
        return custRepository.selectAll();
    }

    @Override
    public User get(Integer s) throws Exception {
        return custRepository.select(s);
    }
    public List<User> searchUserList(UserSearch custSearch) throws Exception {
        return custRepository.searchCustList(custSearch);
    }
    public Page<User> getPage(int pageNo) throws Exception {
        PageHelper.startPage(pageNo, 3); // 3: 한화면에 출력되는 개수
        return custRepository.getpage();
    }
    public Page<User> getPageSearch(int pageNo, UserSearch custSearch) throws Exception {
        PageHelper.startPage(pageNo, 3); // 3: 한화면에 출력되는 개수
        return custRepository.getpageSearch(custSearch);
    }

    public int getUserCount() {
        return custRepository.selectUserCount();
    }

    public List<DailyUserCountDTO> getDailyUserRegistrations() {
        return custRepository.findDailyUserRegistrations();
    }
}