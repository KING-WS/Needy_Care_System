<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<style>
    .add-card {
        border-radius: 15px;
        overflow: hidden;
    }
    
    .add-card .card-header {
        border-radius: 15px 15px 0 0;
    }
    
    .add-input {
        border-radius: 10px;
    }
    
    .add-btn {
        border-radius: 10px;
        padding: 10px 24px;
    }
</style>

<div class="container-fluid py-4">
    <div class="row">
        <div class="col-12">
            <div class="card shadow-sm add-card">
                <div class="card-header bg-primary text-white">
                    <h4 class="mb-0"><i class="bi bi-person-plus-fill me-2"></i>요양사 등록</h4>
                </div>
                <div class="card-body">
                    <form>
                        <div class="row">
                            <!-- 기본 정보 -->
                            <div class="col-md-6">
                                <h5 class="mb-3">기본 정보</h5>
                                
                                <div class="mb-3">
                                    <label class="form-label">이름 <span class="text-danger">*</span></label>
                                    <input type="text" class="form-control add-input" placeholder="이름을 입력하세요" required>
                                </div>
                                
                                <div class="mb-3">
                                    <label class="form-label">생년월일 <span class="text-danger">*</span></label>
                                    <input type="date" class="form-control add-input" required>
                                </div>
                                
                                <div class="mb-3">
                                    <label class="form-label">성별 <span class="text-danger">*</span></label>
                                    <select class="form-select add-input" required>
                                        <option value="">선택하세요</option>
                                        <option value="M">남성</option>
                                        <option value="F">여성</option>
                                    </select>
                                </div>
                                
                                <div class="mb-3">
                                    <label class="form-label">연락처 <span class="text-danger">*</span></label>
                                    <input type="tel" class="form-control" placeholder="010-0000-0000" required>
                                </div>
                                
                                <div class="mb-3">
                                    <label class="form-label">이메일</label>
                                    <input type="email" class="form-control" placeholder="example@email.com">
                                </div>
                                
                                <div class="mb-3">
                                    <label class="form-label">주소 <span class="text-danger">*</span></label>
                                    <input type="text" class="form-control mb-2" placeholder="우편번호" required>
                                    <input type="text" class="form-control mb-2" placeholder="기본 주소" required>
                                    <input type="text" class="form-control" placeholder="상세 주소">
                                </div>
                            </div>
                            
                            <!-- 근무 정보 -->
                            <div class="col-md-6">
                                <h5 class="mb-3">근무 정보</h5>
                                
                                <div class="mb-3">
                                    <label class="form-label">자격증 <span class="text-danger">*</span></label>
                                    <select class="form-select" required>
                                        <option value="">선택하세요</option>
                                        <option value="1">요양보호사 1급</option>
                                        <option value="2">요양보호사 2급</option>
                                        <option value="3">간호조무사</option>
                                        <option value="4">간호사</option>
                                    </select>
                                </div>
                                
                                <div class="mb-3">
                                    <label class="form-label">자격증 번호</label>
                                    <input type="text" class="form-control" placeholder="자격증 번호">
                                </div>
                                
                                <div class="mb-3">
                                    <label class="form-label">발급일</label>
                                    <input type="date" class="form-control">
                                </div>
                                
                                <div class="mb-3">
                                    <label class="form-label">경력 (년)</label>
                                    <input type="number" class="form-control" placeholder="0" min="0">
                                </div>
                                
                                <div class="mb-3">
                                    <label class="form-label">입사일 <span class="text-danger">*</span></label>
                                    <input type="date" class="form-control" required>
                                </div>
                                
                                <div class="mb-3">
                                    <label class="form-label">근무 상태 <span class="text-danger">*</span></label>
                                    <select class="form-select" required>
                                        <option value="">선택하세요</option>
                                        <option value="WORKING">근무중</option>
                                        <option value="LEAVE">휴직</option>
                                        <option value="VACATION">휴가</option>
                                        <option value="RESIGNED">퇴사</option>
                                    </select>
                                </div>
                                
                                <div class="mb-3">
                                    <label class="form-label">프로필 사진</label>
                                    <input type="file" class="form-control" accept="image/*">
                                </div>
                            </div>
                        </div>
                        
                        <!-- 추가 정보 -->
                        <div class="row mt-4">
                            <div class="col-12">
                                <h5 class="mb-3">추가 정보</h5>
                                
                                <div class="mb-3">
                                    <label class="form-label">특이사항</label>
                                    <textarea class="form-control" rows="4" placeholder="특이사항이나 메모를 입력하세요"></textarea>
                                </div>
                                
                                <div class="mb-3">
                                    <label class="form-label">전문 분야 (복수선택 가능)</label>
                                    <div>
                                        <div class="form-check form-check-inline">
                                            <input class="form-check-input" type="checkbox" id="spec1" value="dementia">
                                            <label class="form-check-label" for="spec1">치매 케어</label>
                                        </div>
                                        <div class="form-check form-check-inline">
                                            <input class="form-check-input" type="checkbox" id="spec2" value="stroke">
                                            <label class="form-check-label" for="spec2">뇌졸중 케어</label>
                                        </div>
                                        <div class="form-check form-check-inline">
                                            <input class="form-check-input" type="checkbox" id="spec3" value="diabetes">
                                            <label class="form-check-label" for="spec3">당뇨 관리</label>
                                        </div>
                                        <div class="form-check form-check-inline">
                                            <input class="form-check-input" type="checkbox" id="spec4" value="rehabilitation">
                                            <label class="form-check-label" for="spec4">재활 치료</label>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        
                        <!-- 버튼 -->
                        <div class="row mt-4">
                            <div class="col-12 text-end">
                                <button type="button" class="btn btn-secondary me-2 add-btn" onclick="history.back()">
                                    <i class="bi bi-x-circle me-2"></i>취소
                                </button>
                                <button type="submit" class="btn btn-primary add-btn">
                                    <i class="bi bi-check-circle me-2"></i>등록
                                </button>
                            </div>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>

