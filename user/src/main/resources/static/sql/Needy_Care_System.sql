-- 데이터베이스 추가
CREATE DATABASE Needy_Care_System;

-- Cust 테이블 생성
CREATE TABLE Cust (
                      cust_id INT NOT NULL AUTO_INCREMENT,
                      cust_email VARCHAR(50) NOT NULL,
                      cust_pwd VARCHAR(255) NOT NULL,
                      cust_name VARCHAR(50) NOT NULL,
                      cust_phone VARCHAR(20) NOT NULL,
                      is_deleted CHAR(1) NOT NULL,
                      cust_regdate DATETIME NOT NULL,
                      cust_update DATETIME NOT NULL,
                      PRIMARY KEY (cust_id),
                      UNIQUE KEY UK_cust_email (cust_email)
);

-- 테스트 데이터 삽입
INSERT INTO Cust (
    cust_email,
    cust_pwd,
    cust_name,
    cust_phone,
    is_deleted,
    cust_regdate,
    cust_update
) VALUES (
             'test@test.com',
             '$2a$10$/NTDRN5diDPkmDLOxAMO9e59CrG5dz0aL/1rLdo25TqA5pC6oWYXS',
             '이말년',
             '010-1234-5678',
             'N',
             NOW(),
             NOW()
         );