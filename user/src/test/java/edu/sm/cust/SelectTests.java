package edu.sm.cust;

import edu.sm.app.dto.Cust;
import edu.sm.app.service.CustService;
import lombok.extern.slf4j.Slf4j;
import org.jasypt.encryption.pbe.StandardPBEStringEncryptor;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;

@SpringBootTest
@Slf4j
class SelectTests {

    @Autowired
    CustService custService;
    @Autowired
    BCryptPasswordEncoder encoder;
    @Autowired
    StandardPBEStringEncryptor txtEncoder;


    @Test
    void contextLoads() throws Exception {
        // 전체 조회
        // ID, Name, Addr, regDate, update
        DateTimeFormatter sdf = DateTimeFormatter.ofPattern("yyyy년 MM월 dd일 HH시 mm분 ss초");

        List<Cust> list = null;
        list = custService.get();
        list.forEach((c)->{
            String id = c.getCustId();
            String name = c.getCustName();
            String addr = txtEncoder.decrypt(c.getCustAddr());
            LocalDateTime regdate = c.getCustRegdate();
            LocalDateTime update = c.getCustUpdate();
            log.info("{},{},{},{},{}",id,name,addr,regdate,update);
            log.info("{},{},{},{},{}",id,name,addr,sdf.format(regdate),sdf.format(update));
        });
    }

}





