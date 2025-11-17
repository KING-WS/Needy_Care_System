-- 자기가 추가된 테이블은 여기에다가 저장을 하고 알리기 ex) scy(브렌치이름) : 추가된 테이블
-- scy : 데이터베이스, 기본 테이블 추가


-- 데이터베이스 추가
-- 무조건 데이터베이스부터 생성
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
-- 로그인후 로그인: test@test.com, 비번: 1로 접속
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
-- ======================================================================================================================================================
-- 위에 까지만 일단 저장
-- 여기 아래는 아직 db에 저장하지 말것

CREATE TABLE Care_Recipient (
                                rec_id INT NOT NULL AUTO_INCREMENT,
                                rec_type_code VARCHAR(10) NOT NULL,
                                cust_id INT NOT NULL,
                                rec_name VARCHAR(50) NOT NULL,
                                rec_birthday DATE NOT NULL,
                                rec_gender CHAR(1) NOT NULL,
                                rec_kiosk_code VARCHAR(50),
                                rec_address VARCHAR(255) NOT NULL,
                                rec_photo_url VARCHAR(500),
                                rec_med_history TEXT,
                                rec_allergies TEXT,
                                rec_spec_notes TEXT,
                                is_deleted CHAR(1) NOT NULL,
                                rec_regdate DATETIME NOT NULL,
                                rec_update DATETIME NOT NULL,
                                rec_health_needs TEXT,
                                Field VARCHAR(255),
                                PRIMARY KEY (rec_id)
);

CREATE TABLE Health_Data (
                             health_id INT NOT NULL AUTO_INCREMENT,
                             rec_id INT NOT NULL,
                             health_type VARCHAR(20) NOT NULL,
                             health_value1 DECIMAL(6, 2) NOT NULL,
                             health_value2 DECIMAL(6, 2),
                             health_measured_at DATETIME NOT NULL,
                             is_deleted CHAR(1) NOT NULL DEFAULT 'N',
                             health_regdate DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
                             health_update DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
                             PRIMARY KEY (health_id)
);

CREATE TABLE Care_Matching (
                               matching_id INT NOT NULL AUTO_INCREMENT,
                               caregiver_id INT NOT NULL,
                               rec_id INT NOT NULL,
                               admin_id INT NOT NULL,
                               is_deleted CHAR(1) NOT NULL DEFAULT 'N',
                               match_regdate DATETIME NOT NULL,
                               match_update DATETIME NOT NULL,
                               PRIMARY KEY (matching_id)
);

CREATE TABLE QnA_Answers (
                             answer_id INT NOT NULL AUTO_INCREMENT,
                             question_id INT NOT NULL,
                             admin_id INT NOT NULL,
                             content TEXT,
                             qna_regdate DATETIME NOT NULL,
                             PRIMARY KEY (answer_id)
);

CREATE TABLE Rec_Type_Code (
                               rec_type_code VARCHAR(10) NOT NULL,
                               type_name VARCHAR(50) NOT NULL,
                               PRIMARY KEY (rec_type_code)
);

CREATE TABLE Hourly_Schedule (
                                 hourly_sched_id INT NOT NULL AUTO_INCREMENT,
                                 sched_id INT NOT NULL,
                                 hourly_sched_start_time TIME NOT NULL,
                                 hourly_sched_end_time TIME NOT NULL,
                                 hourly_sched_name VARCHAR(255) NOT NULL,
                                 hourly_sched_content TEXT NOT NULL,
                                 is_deleted CHAR(1) NOT NULL,
                                 hourly_sched_regdate DATETIME NOT NULL,
                                 hourly_sched_update DATETIME NOT NULL,
                                 PRIMARY KEY (hourly_sched_id)
);

CREATE TABLE Admin (
                       admin_id INT NOT NULL AUTO_INCREMENT,
                       admin_email VARCHAR(100) NOT NULL,
                       admin_pwd VARCHAR(255) NOT NULL,
                       admin_name VARCHAR(50) NOT NULL,
                       is_deleted CHAR(1) NOT NULL DEFAULT 'N',
                       admin_regdate DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
                       admin_update DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
                       PRIMARY KEY (admin_id)
);

CREATE TABLE Notification_Setting (
                                      setting_id INT NOT NULL AUTO_INCREMENT,
                                      rec_id INT NOT NULL,
                                      setting_type VARCHAR(20) NOT NULL,
                                      setting_min_value DECIMAL(6, 2),
                                      setting_max_value DECIMAL(6, 2),
                                      is_enabled CHAR(1) NOT NULL DEFAULT 'Y',
                                      setting_regdate DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
                                      setting_update DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
                                      PRIMARY KEY (setting_id)
);

CREATE TABLE Caregiver (
                           caregiver_id INT NOT NULL AUTO_INCREMENT,
                           caregiver_name VARCHAR(50) NOT NULL,
                           caregiver_phone VARCHAR(20) NOT NULL,
                           caregiver_address VARCHAR(255),
                           is_deleted CHAR(1) NOT NULL DEFAULT 'N',
                           caregiver_regdate DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
                           caregiver_update DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
                           caregiver_career VARCHAR(20) NOT NULL,
                           caregiver_certifications TEXT,
                           caregiver_specialties TEXT,
                           PRIMARY KEY (caregiver_id)
);

CREATE TABLE Map_Course (
                            course_id INT NOT NULL AUTO_INCREMENT,
                            rec_id INT NOT NULL,
                            course_name VARCHAR(225) NOT NULL,
                            course_type VARCHAR(20) NOT NULL,
                            course_path_data TEXT NOT NULL,
                            is_deleted CHAR(1) NOT NULL,
                            course_regdate DATETIME NOT NULL,
                            course_update DATETIME NOT NULL,
                            PRIMARY KEY (course_id)
);

CREATE TABLE Subscription (
                              sub_id INT NOT NULL AUTO_INCREMENT,
                              cust_id INT NOT NULL,
                              sub_type VARCHAR(20) NOT NULL,
                              sub_start_date DATETIME NOT NULL,
                              sub_end_date DATETIME NOT NULL,
                              is_active CHAR(1) NOT NULL DEFAULT 'N',
                              sub_regdate DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
                              sub_update DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
                              PRIMARY KEY (sub_id)
);

CREATE TABLE QnA_Questions (
                               question_id INT NOT NULL AUTO_INCREMENT,
                               cust_id INT NOT NULL,
                               title VARCHAR(20) NOT NULL,
                               content TEXT NOT NULL,
                               visibility VARCHAR(20) NOT NULL,
                               status VARCHAR(10) NOT NULL,
                               qna_regdate DATETIME NOT NULL,
                               PRIMARY KEY (question_id)
);

CREATE TABLE Schedule (
                          sched_id INT NOT NULL AUTO_INCREMENT,
                          rec_id INT NOT NULL,
                          sched_date DATE NOT NULL,
                          sched_name VARCHAR(255) NOT NULL,
                          sched_start_time TIME,
                          sched_end_time TIME,
                          is_deleted CHAR(1) NOT NULL,
                          sched_regdate DATETIME NOT NULL,
                          sched_update DATETIME NOT NULL,
                          PRIMARY KEY (sched_id)
);

CREATE TABLE Map (
                     map_id INT NOT NULL AUTO_INCREMENT,
                     rec_id INT NOT NULL,
                     map_name VARCHAR(100) NOT NULL,
                     map_content TEXT,
                     map_category VARCHAR(50),
                     map_latitude DECIMAL(10,7) NOT NULL,
                     map_longitude DECIMAL(10,7) NOT NULL,
                     is_deleted CHAR(1) NOT NULL,
                     map_regdate DATETIME NOT NULL,
                     map_update DATETIME NOT NULL,
                     PRIMARY KEY (map_id)
);

CREATE TABLE Camera (
                        cam_id INT NOT NULL AUTO_INCREMENT,
                        rec_id INT NOT NULL,
                        cam_name VARCHAR(100) NOT NULL,
                        cam_url VARCHAR(500) NOT NULL,
                        is_deleted CHAR(1) NOT NULL,
                        cam_regdate DATETIME NOT NULL,
                        cam_update DATETIME NOT NULL,
                        PRIMARY KEY (cam_id)
);

CREATE TABLE Manual (
                        manual_id INT NOT NULL AUTO_INCREMENT,
                        rec_id INT NOT NULL,
                        manual_type VARCHAR(10) NOT NULL,
                        manual_pdf_name VARCHAR(255),
                        manual_pdf_url VARCHAR(500),
                        manual_content TEXT,
                        is_deleted CHAR(1) NOT NULL DEFAULT 'N',
                        manual_regdate DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
                        manual_update DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
                        PRIMARY KEY (manual_id)
);

CREATE TABLE Payment (
                         payment_id INT NOT NULL AUTO_INCREMENT,
                         sub_id INT NOT NULL,
                         payment_amount INT NOT NULL,
                         payment_status VARCHAR(10) NOT NULL,
                         kakao_tid VARCHAR(255) NOT NULL,
                         payment_regdate DATETIME NOT NULL,
                         payment_update DATETIME NOT NULL,
                         PRIMARY KEY (payment_id)
);

CREATE TABLE Meal_Plan (
                           meal_id INT NOT NULL AUTO_INCREMENT,
                           rec_id INT NOT NULL,
                           meal_date DATE NOT NULL,
                           meal_type VARCHAR(10) NOT NULL,
                           meal_menu TEXT,
                           meal_calories INT,
                           is_deleted CHAR(1) NOT NULL,
                           meal_regdate DATETIME NOT NULL,
                           meal_update DATETIME NOT NULL,
                           PRIMARY KEY (meal_id)
);


