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
            <div class="card shadow-sm mb-4 add-card">
                <div class="card-header bg-primary text-white">
                    <h4 class="mb-0"><i class="bi bi-person-plus me-2"></i>노약자 등록</h4>
                </div>
                <div class="card-body">
                    <form id="seniorAddForm">
                        <div class="row mb-3">
                            <div class="col-md-4">
                                <label for="seniorName" class="form-label">이름 <span class="text-danger">*</span></label>
                                <input type="text" class="form-control add-input" id="seniorName" required>
                            </div>
                            <div class="col-md-4">
                                <label for="seniorAge" class="form-label">나이 <span class="text-danger">*</span></label>
                                <input type="number" class="form-control add-input" id="seniorAge" required>
                            </div>
                            <div class="col-md-4">
                                <label for="seniorGender" class="form-label">성별 <span class="text-danger">*</span></label>
                                <select class="form-select add-input" id="seniorGender" required>
                                    <option value="">선택하세요</option>
                                    <option value="male">남</option>
                                    <option value="female">여</option>
                                </select>
                            </div>
                        </div>
                        
                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label for="seniorPhone" class="form-label">연락처</label>
                                <input type="tel" class="form-control add-input" id="seniorPhone">
                            </div>
                            <div class="col-md-6">
                                <label for="guardianPhone" class="form-label">보호자 연락처 <span class="text-danger">*</span></label>
                                <input type="tel" class="form-control add-input" id="guardianPhone" required>
                            </div>
                        </div>
                        
                        <div class="row mb-3">
                            <div class="col-md-12">
                                <label for="seniorAddress" class="form-label">주소 <span class="text-danger">*</span></label>
                                <input type="text" class="form-control add-input" id="seniorAddress" required>
                            </div>
                        </div>
                        
                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label for="caregiverAssign" class="form-label">담당 요양사</label>
                                <select class="form-select add-input" id="caregiverAssign">
                                    <option value="">선택하세요</option>
                                    <option value="1">이요양</option>
                                    <option value="2">김요양</option>
                                    <option value="3">박요양</option>
                                </select>
                            </div>
                            <div class="col-md-6">
                                <label for="healthStatus" class="form-label">건강 상태</label>
                                <select class="form-select add-input" id="healthStatus">
                                    <option value="">선택하세요</option>
                                    <option value="good">양호</option>
                                    <option value="caution">주의</option>
                                    <option value="danger">위험</option>
                                </select>
                            </div>
                        </div>
                        
                        <div class="mb-3">
                            <label for="medicalHistory" class="form-label">병력 및 특이사항</label>
                            <textarea class="form-control add-input" id="medicalHistory" rows="4"></textarea>
                        </div>
                        
                        <div class="d-flex justify-content-end gap-2">
                            <button type="button" class="btn btn-secondary add-btn" onclick="history.back()">
                                <i class="bi bi-x-circle me-1"></i>취소
                            </button>
                            <button type="submit" class="btn btn-primary add-btn">
                                <i class="bi bi-check-circle me-1"></i>등록
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    document.getElementById('seniorAddForm').addEventListener('submit', function(e) {
        e.preventDefault();
        alert('노약자가 등록되었습니다.');
        window.location.href = '<c:url value="/senior/list"/>';
    });
</script>

