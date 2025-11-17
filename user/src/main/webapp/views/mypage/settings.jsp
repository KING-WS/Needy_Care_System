<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- 환경 설정 페이지 -->
<section style="padding: 20px;">
    <div class="container-fluid">
        <div class="row">
            <div class="col-12 mb-4">
                <h1 style="font-size: 36px; font-weight: bold; color: var(--secondary-color);">
                    <i class="fas fa-cog"></i> 환경 설정
                </h1>
                <p style="font-size: 16px; color: #666; margin-top: 10px;">
                    서비스 이용 환경을 설정할 수 있습니다.
                </p>
            </div>
            
            <div class="col-md-8 mx-auto">
                <!-- 알림 설정 -->
                <div class="card mb-4" style="border: none; border-radius: 15px; box-shadow: 0 5px 15px rgba(0,0,0,0.1); padding: 30px;">
                    <h4 style="margin-bottom: 25px; color: var(--secondary-color);">
                        <i class="fas fa-bell"></i> 알림 설정
                    </h4>
                    
                    <div class="mb-3 pb-3" style="border-bottom: 1px solid #f0f0f0;">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <p style="font-weight: 600; margin-bottom: 5px;">이메일 알림</p>
                                <small class="text-muted">중요한 알림을 이메일로 받습니다</small>
                            </div>
                            <div class="form-check form-switch">
                                <input class="form-check-input" type="checkbox" checked
                                       style="width: 50px; height: 25px; cursor: pointer;">
                            </div>
                        </div>
                    </div>
                    
                    <div class="mb-3 pb-3" style="border-bottom: 1px solid #f0f0f0;">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <p style="font-weight: 600; margin-bottom: 5px;">푸시 알림</p>
                                <small class="text-muted">브라우저 푸시 알림을 받습니다</small>
                            </div>
                            <div class="form-check form-switch">
                                <input class="form-check-input" type="checkbox" checked
                                       style="width: 50px; height: 25px; cursor: pointer;">
                            </div>
                        </div>
                    </div>
                    
                    <div class="mb-3 pb-3" style="border-bottom: 1px solid #f0f0f0;">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <p style="font-weight: 600; margin-bottom: 5px;">SMS 알림</p>
                                <small class="text-muted">문자 메시지로 알림을 받습니다</small>
                            </div>
                            <div class="form-check form-switch">
                                <input class="form-check-input" type="checkbox"
                                       style="width: 50px; height: 25px; cursor: pointer;">
                            </div>
                        </div>
                    </div>
                    
                    <div>
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <p style="font-weight: 600; margin-bottom: 5px;">마케팅 정보 수신</p>
                                <small class="text-muted">이벤트 및 프로모션 정보를 받습니다</small>
                            </div>
                            <div class="form-check form-switch">
                                <input class="form-check-input" type="checkbox"
                                       style="width: 50px; height: 25px; cursor: pointer;">
                            </div>
                        </div>
                    </div>
                </div>
                
                <!-- 화면 설정 -->
                <div class="card mb-4" style="border: none; border-radius: 15px; box-shadow: 0 5px 15px rgba(0,0,0,0.1); padding: 30px;">
                    <h4 style="margin-bottom: 25px; color: var(--secondary-color);">
                        <i class="fas fa-palette"></i> 화면 설정
                    </h4>
                    
                    <div class="mb-4">
                        <label class="form-label" style="font-weight: 600; color: #666;">테마</label>
                        <select class="form-select" style="border-radius: 8px; padding: 12px;">
                            <option selected>라이트 모드</option>
                            <option>다크 모드</option>
                            <option>시스템 설정 따르기</option>
                        </select>
                    </div>
                    
                    <div class="mb-4">
                        <label class="form-label" style="font-weight: 600; color: #666;">언어</label>
                        <select class="form-select" style="border-radius: 8px; padding: 12px;">
                            <option selected>한국어</option>
                            <option>English</option>
                            <option>日本語</option>
                        </select>
                    </div>
                    
                    <div>
                        <label class="form-label" style="font-weight: 600; color: #666;">글꼴 크기</label>
                        <div class="btn-group w-100" role="group">
                            <button type="button" class="btn btn-outline-primary">작게</button>
                            <button type="button" class="btn btn-primary">보통</button>
                            <button type="button" class="btn btn-outline-primary">크게</button>
                        </div>
                    </div>
                </div>
                
                <!-- 개인정보 설정 -->
                <div class="card mb-4" style="border: none; border-radius: 15px; box-shadow: 0 5px 15px rgba(0,0,0,0.1); padding: 30px;">
                    <h4 style="margin-bottom: 25px; color: var(--secondary-color);">
                        <i class="fas fa-user-shield"></i> 개인정보 설정
                    </h4>
                    
                    <div class="mb-3 pb-3" style="border-bottom: 1px solid #f0f0f0;">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <p style="font-weight: 600; margin-bottom: 5px;">프로필 공개</p>
                                <small class="text-muted">다른 사용자에게 프로필을 공개합니다</small>
                            </div>
                            <div class="form-check form-switch">
                                <input class="form-check-input" type="checkbox" checked
                                       style="width: 50px; height: 25px; cursor: pointer;">
                            </div>
                        </div>
                    </div>
                    
                    <div class="mb-3 pb-3" style="border-bottom: 1px solid #f0f0f0;">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <p style="font-weight: 600; margin-bottom: 5px;">활동 내역 공개</p>
                                <small class="text-muted">최근 활동 내역을 공개합니다</small>
                            </div>
                            <div class="form-check form-switch">
                                <input class="form-check-input" type="checkbox"
                                       style="width: 50px; height: 25px; cursor: pointer;">
                            </div>
                        </div>
                    </div>
                    
                    <div>
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <p style="font-weight: 600; margin-bottom: 5px;">검색 허용</p>
                                <small class="text-muted">검색 결과에 내 계정을 표시합니다</small>
                            </div>
                            <div class="form-check form-switch">
                                <input class="form-check-input" type="checkbox" checked
                                       style="width: 50px; height: 25px; cursor: pointer;">
                            </div>
                        </div>
                    </div>
                </div>
                
                <!-- 저장 버튼 -->
                <div class="text-end">
                    <button type="button" class="btn btn-secondary me-2" style="border-radius: 20px; padding: 12px 30px;">
                        <i class="fas fa-undo"></i> 초기화
                    </button>
                    <button type="button" class="btn btn-primary" style="border-radius: 20px; padding: 12px 30px;"
                            onclick="alert('설정이 저장되었습니다.')">
                        <i class="fas fa-save"></i> 저장하기
                    </button>
                </div>
            </div>
        </div>
    </div>
</section>

