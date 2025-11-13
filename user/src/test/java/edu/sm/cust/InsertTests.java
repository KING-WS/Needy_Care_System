package edu.sm.cust;

import edu.sm.app.dto.Cust;
import edu.sm.app.service.CustService;
import lombok.extern.slf4j.Slf4j;
import org.jasypt.encryption.pbe.StandardPBEStringEncryptor;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;

@SpringBootTest
@Slf4j
public class InsertTests {
    @Autowired
    CustService custService;
    @Autowired
    BCryptPasswordEncoder encoder;
    @Autowired
    StandardPBEStringEncryptor txtEncoder;


    @Test
    void contextLoads() throws Exception {
        String id = "id01";
        String pwd = "111111";
        String name = "신창영";
        String addr = "충청도 아산시";

        Cust cust = Cust.builder().
                custId(id).
                custPwd(encoder.encode(pwd)).
                custName(name).
                custAddr(txtEncoder.encrypt(addr)).
                        build();

        custService.register(cust);
        log.info("Inserted cust: {}", cust);
    }





}
