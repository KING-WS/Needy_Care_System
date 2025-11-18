-- ==========================================================
-- 0. 초기화 (FK 체크 해제 및 기존 테이블 삭제)
-- ==========================================================

-- 외래키 검사를 잠시 끕니다 (삭제 순서 꼬임 방지용 안전장치)
SET FOREIGN_KEY_CHECKS = 0;

-- 1. 자식 테이블 (가장 하위 종속성) 부터 삭제
DROP TABLE IF EXISTS QnA_Answers;
DROP TABLE IF EXISTS QnA_Questions;
DROP TABLE IF EXISTS Payment;
DROP TABLE IF EXISTS Subscription;
DROP TABLE IF EXISTS Care_Matching;
DROP TABLE IF EXISTS Hourly_Schedule;
DROP TABLE IF EXISTS Schedule;
DROP TABLE IF EXISTS Meal_Plan;
DROP TABLE IF EXISTS Camera;
DROP TABLE IF EXISTS Manual;
DROP TABLE IF EXISTS Map_Course;
DROP TABLE IF EXISTS Map;
DROP TABLE IF EXISTS Notification_Setting;
DROP TABLE IF EXISTS Health_Data;

-- 2. 중간 부모 테이블 삭제
DROP TABLE IF EXISTS Caregiver;
DROP TABLE IF EXISTS Care_Recipient;

-- 3. 최상위 부모 테이블 (독립적인 테이블) 삭제
DROP TABLE IF EXISTS Rec_Type_Code;
DROP TABLE IF EXISTS Admin;
DROP TABLE IF EXISTS Cust;

-- 외래키 검사를 다시 켭니다
SET FOREIGN_KEY_CHECKS = 1;


-- ==========================================================
-- 1. 데이터베이스 생성 및 선택
-- ==========================================================
CREATE DATABASE IF NOT EXISTS Needy_Care_System;
USE Needy_Care_System;


-- ==========================================================
-- 2. 테이블 생성 (Table Creation)
-- ==========================================================

-- [1] Cust (고객/보호자)
CREATE TABLE Cust (
                      cust_id INT NOT NULL AUTO_INCREMENT,
                      cust_email VARCHAR(50) NOT NULL,
                      cust_pwd VARCHAR(255) NOT NULL,
                      cust_name VARCHAR(50) NOT NULL,
                      cust_phone VARCHAR(20) NOT NULL,
                      is_deleted CHAR(1) NOT NULL,
                      cust_regdate DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
                      cust_update DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
                      PRIMARY KEY (cust_id),
                      UNIQUE KEY UK_cust_email (cust_email)
);

-- Cust 초기 테스트 데이터
INSERT INTO Cust (cust_email, cust_pwd, cust_name, cust_phone, is_deleted, cust_regdate, cust_update)
VALUES ('test@test.com', '$2a$10$/NTDRN5diDPkmDLOxAMO9e59CrG5dz0aL/1rLdo25TqA5pC6oWYXS', '이말년', '010-1234-5678', 'N', NOW(), NOW());

-- [2] Rec_Type_Code (대상자 유형 코드)
CREATE TABLE Rec_Type_Code (
                               rec_type_code VARCHAR(10) NOT NULL,
                               type_name VARCHAR(50) NOT NULL,
                               PRIMARY KEY (rec_type_code)
);

INSERT INTO Rec_Type_Code (rec_type_code, type_name) VALUES ('ELDERLY', '노인/고령자');
INSERT INTO Rec_Type_Code (rec_type_code, type_name) VALUES ('PREGNANT', '임산부');
INSERT INTO Rec_Type_Code (rec_type_code, type_name) VALUES ('DISABLED', '장애인');

-- [3] Care_Recipient (케어 대상자)
CREATE TABLE Care_Recipient (
                                rec_id INT NOT NULL AUTO_INCREMENT,
                                rec_type_code VARCHAR(10) NOT NULL,
                                cust_id INT NOT NULL,
                                rec_name VARCHAR(50) NOT NULL,
                                rec_birthday DATE NOT NULL,
                                rec_gender CHAR(1) NOT NULL,
                                rec_kiosk_code VARCHAR(50) COMMENT '키오스크 접속용 고유 코드',
                                rec_address VARCHAR(255) NOT NULL,
                                rec_photo_url VARCHAR(500),
                                rec_med_history TEXT,
                                rec_allergies TEXT,
                                rec_spec_notes TEXT,
                                is_deleted CHAR(1) NOT NULL,
                                rec_regdate DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
                                rec_update DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
                                rec_health_needs TEXT COMMENT '(AI용) 건강 요구사항',
                                PRIMARY KEY (rec_id),
                                UNIQUE KEY UK_rec_kiosk_code (rec_kiosk_code)
);

-- [4] Health_Data (건강 데이터)
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

-- [5] Admin (관리자)
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

-- [6] Caregiver (요양보호사)
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

-- [7] Care_Matching (매칭)
CREATE TABLE Care_Matching (
                               matching_id INT NOT NULL AUTO_INCREMENT,
                               caregiver_id INT NOT NULL,
                               rec_id INT NOT NULL,
                               admin_id INT NOT NULL,
                               is_deleted CHAR(1) NOT NULL DEFAULT 'N',
                               match_regdate DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
                               match_update DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
                               PRIMARY KEY (matching_id)
);

-- [8] Notification_Setting (알림 설정)
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

-- [9] Schedule (일정)
CREATE TABLE Schedule (
                          sched_id INT NOT NULL AUTO_INCREMENT,
                          rec_id INT NOT NULL,
                          sched_date DATE NOT NULL,
                          sched_name VARCHAR(255) NOT NULL,
                          sched_start_time TIME,
                          sched_end_time TIME,
                          is_deleted CHAR(1) NOT NULL,
                          sched_regdate DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
                          sched_update DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
                          PRIMARY KEY (sched_id)
);

-- [10] Hourly_Schedule (시간대별 세부 일정)
CREATE TABLE Hourly_Schedule (
                                 hourly_sched_id INT NOT NULL AUTO_INCREMENT,
                                 sched_id INT NOT NULL,
                                 hourly_sched_start_time TIME NOT NULL,
                                 hourly_sched_end_time TIME NOT NULL,
                                 hourly_sched_name VARCHAR(255) NOT NULL,
                                 hourly_sched_content TEXT NOT NULL,
                                 is_deleted CHAR(1) NOT NULL,
                                 hourly_sched_regdate DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
                                 hourly_sched_update DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
                                 PRIMARY KEY (hourly_sched_id)
);

-- [11] Meal_Plan (식단)
CREATE TABLE Meal_Plan (
                           meal_id INT NOT NULL AUTO_INCREMENT,
                           rec_id INT NOT NULL,
                           meal_date DATE NOT NULL,
                           meal_type VARCHAR(10) NOT NULL,
                           meal_menu TEXT,
                           meal_calories INT,
                           is_deleted CHAR(1) NOT NULL,
                           meal_regdate DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
                           meal_update DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
                           PRIMARY KEY (meal_id)
);

-- [12] Map (지도/장소)
CREATE TABLE Map (
                     map_id INT NOT NULL AUTO_INCREMENT,
                     rec_id INT NOT NULL,
                     map_name VARCHAR(100) NOT NULL,
                     map_content TEXT,
                     map_category VARCHAR(50),
                     map_latitude DECIMAL(10,7) NOT NULL,
                     map_longitude DECIMAL(10,7) NOT NULL,
                     is_deleted CHAR(1) NOT NULL,
                     map_regdate DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
                     map_update DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
                     PRIMARY KEY (map_id)
);

-- [13] Map_Course (경로)
CREATE TABLE Map_Course (
                            course_id INT NOT NULL AUTO_INCREMENT,
                            rec_id INT NOT NULL,
                            course_name VARCHAR(225) NOT NULL,
                            course_type VARCHAR(20) NOT NULL,
                            course_path_data TEXT NOT NULL,
                            is_deleted CHAR(1) NOT NULL,
                            course_regdate DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
                            course_update DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
                            PRIMARY KEY (course_id)
);

-- [14] Camera (카메라)
CREATE TABLE Camera (
                        cam_id INT NOT NULL AUTO_INCREMENT,
                        rec_id INT NOT NULL,
                        cam_name VARCHAR(100) NOT NULL,
                        cam_url VARCHAR(500) NOT NULL,
                        is_deleted CHAR(1) NOT NULL,
                        cam_regdate DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
                        cam_update DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
                        PRIMARY KEY (cam_id)
);

-- [15] Manual (매뉴얼/AI 텍스트)
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

-- [16] Subscription (구독)
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

-- [17] Payment (결제)
CREATE TABLE Payment (
                         payment_id INT NOT NULL AUTO_INCREMENT,
                         sub_id INT NOT NULL,
                         payment_amount INT NOT NULL,
                         payment_status VARCHAR(10) NOT NULL,
                         kakao_tid VARCHAR(255) NOT NULL,
                         payment_regdate DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
                         payment_update DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
                         PRIMARY KEY (payment_id)
);

-- [18] QnA_Questions (질문)
CREATE TABLE QnA_Questions (
                               question_id INT NOT NULL AUTO_INCREMENT,
                               cust_id INT NOT NULL,
                               title VARCHAR(100) NOT NULL,
                               content TEXT NOT NULL,
                               visibility VARCHAR(20) NOT NULL,
                               status VARCHAR(10) NOT NULL,
                               qna_regdate DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
                               PRIMARY KEY (question_id)
);

-- [19] QnA_Answers (답변)
CREATE TABLE QnA_Answers (
                             answer_id INT NOT NULL AUTO_INCREMENT,
                             question_id INT NOT NULL,
                             admin_id INT NOT NULL,
                             content TEXT,
                             qna_regdate DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
                             PRIMARY KEY (answer_id)
);


-- ==========================================================
-- 3. 외래키(Foreign Key) 연결
-- ==========================================================

-- Care_Recipient 관련
ALTER TABLE Care_Recipient ADD CONSTRAINT FK_Rec_Type_Code_TO_Care_Recipient FOREIGN KEY (rec_type_code) REFERENCES Rec_Type_Code (rec_type_code);
ALTER TABLE Care_Recipient ADD CONSTRAINT FK_Cust_TO_Care_Recipient FOREIGN KEY (cust_id) REFERENCES Cust (cust_id);

-- Health_Data 관련
ALTER TABLE Health_Data ADD CONSTRAINT FK_Care_Recipient_TO_Health_Data FOREIGN KEY (rec_id) REFERENCES Care_Recipient (rec_id);

-- Care_Matching 관련
ALTER TABLE Care_Matching ADD CONSTRAINT FK_Caregiver_TO_Care_Matching FOREIGN KEY (caregiver_id) REFERENCES Caregiver (caregiver_id);
ALTER TABLE Care_Matching ADD CONSTRAINT FK_Care_Recipient_TO_Care_Matching FOREIGN KEY (rec_id) REFERENCES Care_Recipient (rec_id);
ALTER TABLE Care_Matching ADD CONSTRAINT FK_Admin_TO_Care_Matching FOREIGN KEY (admin_id) REFERENCES Admin (admin_id);

-- Hourly_Schedule 관련
ALTER TABLE Hourly_Schedule ADD CONSTRAINT FK_Schedule_TO_Hourly_Schedule FOREIGN KEY (sched_id) REFERENCES Schedule (sched_id);

-- Notification_Setting 관련
ALTER TABLE Notification_Setting ADD CONSTRAINT FK_Care_Recipient_TO_Notification_Setting FOREIGN KEY (rec_id) REFERENCES Care_Recipient (rec_id);

-- Map & Map_Course 관련
ALTER TABLE Map_Course ADD CONSTRAINT FK_Care_Recipient_TO_Map_Course FOREIGN KEY (rec_id) REFERENCES Care_Recipient (rec_id);
ALTER TABLE Map ADD CONSTRAINT FK_Care_Recipient_TO_Map FOREIGN KEY (rec_id) REFERENCES Care_Recipient (rec_id);

-- Subscription & Payment 관련
ALTER TABLE Subscription ADD CONSTRAINT FK_Cust_TO_Subscription FOREIGN KEY (cust_id) REFERENCES Cust (cust_id);
ALTER TABLE Payment ADD CONSTRAINT FK_Subscription_TO_Payment FOREIGN KEY (sub_id) REFERENCES Subscription (sub_id);

-- QnA 관련
ALTER TABLE QnA_Questions ADD CONSTRAINT FK_Cust_TO_QnA_Questions FOREIGN KEY (cust_id) REFERENCES Cust (cust_id);
ALTER TABLE QnA_Answers ADD CONSTRAINT FK_QnA_Questions_TO_QnA_Answers FOREIGN KEY (question_id) REFERENCES QnA_Questions (question_id);
ALTER TABLE QnA_Answers ADD CONSTRAINT FK_Admin_TO_QnA_Answers FOREIGN KEY (admin_id) REFERENCES Admin (admin_id);

-- 기타 Care_Recipient 종속 테이블들
ALTER TABLE Schedule ADD CONSTRAINT FK_Care_Recipient_TO_Schedule FOREIGN KEY (rec_id) REFERENCES Care_Recipient (rec_id);
ALTER TABLE Meal_Plan ADD CONSTRAINT FK_Care_Recipient_TO_Meal_Plan FOREIGN KEY (rec_id) REFERENCES Care_Recipient (rec_id);
ALTER TABLE Camera ADD CONSTRAINT FK_Care_Recipient_TO_Camera FOREIGN KEY (rec_id) REFERENCES Care_Recipient (rec_id);
ALTER TABLE Manual ADD CONSTRAINT FK_Care_Recipient_TO_Manual FOREIGN KEY (rec_id) REFERENCES Care_Recipient (rec_id);