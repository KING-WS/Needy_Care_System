<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<style>
    .care-card {
        border-radius: 15px;
        overflow: hidden;
    }
    
    .care-card .card-header {
        border-radius: 15px 15px 0 0;
    }
    
    .care-btn {
        border-radius: 10px;
        padding: 8px 16px;
    }
    
    .timeline-item {
        border-radius: 12px;
        padding: 15px;
        margin-bottom: 15px;
        background-color: #f8f9fa;
        border-left: 4px solid #0d6efd;
    }
</style>

<div class="container-fluid py-4">
    <div class="row">
        <!-- 좌측: 노약자 정보 -->
        <div class="col-md-4 mb-4">
            <div class="card shadow-sm care-card">
                <div class="card-header bg-primary text-white">
                    <h5 class="mb-0"><i class="bi bi-person me-2"></i>노약자 정보</h5>
                </div>
                <div class="card-body">
                    <div class="text-center mb-3">
                        <img src="https://via.placeholder.com/120" class="rounded-circle" alt="Profile">
                    </div>
                    <h5 class="text-center mb-3">김영희</h5>
                    <hr>
                    <div class="mb-2">
                        <strong><i class="bi bi-calendar me-2"></i>나이:</strong> 82세
                    </div>
                    <div class="mb-2">
                        <strong><i class="bi bi-gender-ambiguous me-2"></i>성별:</strong> 여
                    </div>
                    <div class="mb-2">
                        <strong><i class="bi bi-telephone me-2"></i>연락처:</strong> 010-1234-5678
                    </div>
                    <div class="mb-2">
                        <strong><i class="bi bi-person-heart me-2"></i>담당 요양사:</strong> 이요양
                    </div>
                    <div class="mb-2">
                        <strong><i class="bi bi-heart-pulse me-2"></i>건강 상태:</strong> 
                        <span class="badge bg-success">양호</span>
                    </div>
                    <hr>
                    <button class="btn btn-primary w-100 care-btn">
                        <i class="bi bi-pencil me-1"></i>정보 수정
                    </button>
                </div>
            </div>
        </div>
        
        <!-- 우측: 케어 기록 -->
        <div class="col-md-8 mb-4">
            <div class="card shadow-sm care-card">
                <div class="card-header bg-primary text-white d-flex justify-content-between align-items-center">
                    <h5 class="mb-0"><i class="bi bi-clipboard-heart me-2"></i>케어 기록</h5>
                    <button class="btn btn-light btn-sm care-btn" data-bs-toggle="modal" data-bs-target="#addCareModal">
                        <i class="bi bi-plus-circle me-1"></i>기록 추가
                    </button>
                </div>
                <div class="card-body" style="max-height: 600px; overflow-y: auto;">
                    <div class="timeline-item">
                        <div class="d-flex justify-content-between mb-2">
                            <h6 class="mb-0"><i class="bi bi-clock me-2"></i>2024-11-11 10:30</h6>
                            <span class="badge bg-info">건강체크</span>
                        </div>
                        <p class="mb-0">혈압 측정: 120/80 mmHg, 정상 범위 유지</p>
                        <small class="text-muted">작성자: 이요양</small>
                    </div>
                    
                    <div class="timeline-item">
                        <div class="d-flex justify-content-between mb-2">
                            <h6 class="mb-0"><i class="bi bi-clock me-2"></i>2024-11-10 14:15</h6>
                            <span class="badge bg-success">약물투여</span>
                        </div>
                        <p class="mb-0">고혈압 약 복용 확인</p>
                        <small class="text-muted">작성자: 이요양</small>
                    </div>
                    
                    <div class="timeline-item">
                        <div class="d-flex justify-content-between mb-2">
                            <h6 class="mb-0"><i class="bi bi-clock me-2"></i>2024-11-09 09:00</h6>
                            <span class="badge bg-warning">운동</span>
                        </div>
                        <p class="mb-0">산책 30분 실시, 무리 없이 완료</p>
                        <small class="text-muted">작성자: 이요양</small>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- 케어 기록 추가 모달 -->
<div class="modal fade" id="addCareModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content" style="border-radius: 15px;">
            <div class="modal-header">
                <h5 class="modal-title"><i class="bi bi-plus-circle me-2"></i>케어 기록 추가</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <form id="addCareForm">
                    <div class="mb-3">
                        <label for="careType" class="form-label">케어 유형</label>
                        <select class="form-select" id="careType" style="border-radius: 10px;">
                            <option value="health">건강체크</option>
                            <option value="medicine">약물투여</option>
                            <option value="exercise">운동</option>
                            <option value="meal">식사</option>
                            <option value="etc">기타</option>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label for="careContent" class="form-label">내용</label>
                        <textarea class="form-control" id="careContent" rows="4" style="border-radius: 10px;"></textarea>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary care-btn" data-bs-dismiss="modal">취소</button>
                <button type="button" class="btn btn-primary care-btn" onclick="addCareRecord()">저장</button>
            </div>
        </div>
    </div>
</div>

<script>
    function addCareRecord() {
        alert('케어 기록이 추가되었습니다.');
        location.reload();
    }
</script>

