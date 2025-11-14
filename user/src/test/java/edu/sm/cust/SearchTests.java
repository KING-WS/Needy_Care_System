package edu.sm.cust;

import edu.sm.app.dto.Cust;
import edu.sm.app.service.CustService;
import lombok.extern.slf4j.Slf4j;
import org.jasypt.encryption.pbe.StandardPBEStringEncryptor;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;

import java.util.List;

@SpringBootTest
@Slf4j
class SearchTests {

    @Autowired
    CustService custService;
    
    @Autowired
    StandardPBEStringEncryptor txtEncoder;

    @Test
    void testGetAllCustomers() throws Exception {
        log.info("==================== 전체 고객 조회 테스트 ====================");
        
        List<Cust> custList = custService.get();
        
        if (custList == null || custList.isEmpty()) {
            log.warn("⚠️ DB에 저장된 고객 데이터가 없습니다.");
        } else {
            log.info("✅ 총 {}명의 고객이 조회되었습니다.", custList.size());
            log.info("=============================================================");
            
            custList.forEach(cust -> {
                String decryptedAddr = "";
                try {
                    decryptedAddr = txtEncoder.decrypt(cust.getCustAddr());
                } catch (Exception e) {
                    decryptedAddr = cust.getCustAddr(); // 암호화되지 않은 경우 그대로 출력
                }
                
                log.info("📌 고객 ID: {}", cust.getCustId());
                log.info("   이름: {}", cust.getCustName());
                log.info("   주소: {}", decryptedAddr);
                log.info("   가입일: {}", cust.getCustRegdate());
                log.info("   수정일: {}", cust.getCustUpdate());
                log.info("-------------------------------------------------------------");
            });
        }
    }

    @Test
    void testGetCustomerById() throws Exception {
        log.info("==================== 특정 고객 조회 테스트 ====================");
        
        // 먼저 전체 조회해서 존재하는 ID 확인
        List<Cust> custList = custService.get();
        
        if (custList != null && !custList.isEmpty()) {
            String testId = custList.get(0).getCustId();
            log.info("테스트 대상 고객 ID: {}", testId);
            
            Cust cust = custService.get(testId);
            
            if (cust != null) {
                log.info("✅ 고객 조회 성공!");
                log.info("=============================================================");
                
                String decryptedAddr = "";
                try {
                    decryptedAddr = txtEncoder.decrypt(cust.getCustAddr());
                } catch (Exception e) {
                    decryptedAddr = cust.getCustAddr();
                }
                
                log.info("📌 고객 ID: {}", cust.getCustId());
                log.info("   이름: {}", cust.getCustName());
                log.info("   주소: {}", decryptedAddr);
                log.info("   가입일: {}", cust.getCustRegdate());
                log.info("   수정일: {}", cust.getCustUpdate());
                log.info("=============================================================");
            } else {
                log.error("❌ 고객을 찾을 수 없습니다. ID: {}", testId);
            }
        } else {
            log.warn("⚠️ DB에 고객 데이터가 없어서 테스트를 진행할 수 없습니다.");
        }
    }

    @Test
    void testDatabaseConnection() throws Exception {
        log.info("==================== DB 연결 확인 테스트 ====================");
        
        try {
            List<Cust> custList = custService.get();
            log.info("✅ PostgreSQL 데이터베이스 연결 성공!");
            log.info("📊 현재 DB에 저장된 고객 수: {}명", 
                    custList != null ? custList.size() : 0);
            log.info("=============================================================");
        } catch (Exception e) {
            log.error("❌ 데이터베이스 연결 실패!", e);
            throw e;
        }
    }
}

