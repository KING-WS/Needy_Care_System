package edu.sm.app.repository;


import com.github.pagehelper.Page;
import edu.sm.app.dto.User;
import edu.sm.app.dto.UserSearch;
import edu.sm.common.frame.SmRepository;
import org.apache.ibatis.annotations.Mapper;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
@Mapper
public interface UserRepository extends SmRepository<User, Integer> {
    Page<User> getpage() throws Exception;
    Page<User> getpageSearch(UserSearch custSearch) throws Exception;
    List<User> searchCustList(UserSearch custSearch) throws Exception;
    int selectUserCount();
}