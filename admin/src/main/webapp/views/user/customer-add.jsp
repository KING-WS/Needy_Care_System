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
                    <h4 class="mb-0"><i class="bi bi-person-plus me-2"></i>고객 등록</h4>
                </div>
                <div class="card-body">
                    <form id="customerAddForm">
                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label for="customerName" class="form-label">고객명 <span class="text-danger">*</span></label>
                                <input type="text" class="form-control add-input" id="customerName" required>
                            </div>
                            <div class="col-md-6">
                                <label for="customerEmail" class="form-label">이메일 <span class="text-danger">*</span></label>
                                <input type="email" class="form-control add-input" id="customerEmail" required>
                            </div>
                        </div>
                        
                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label for="customerPhone" class="form-label">연락처 <span class="text-danger">*</span></label>
                                <input type="tel" class="form-control add-input" id="customerPhone" required>
                            </div>
                            <div class="col-md-6">
                                <label for="customerAddress" class="form-label">주소</label>
                                <input type="text" class="form-control add-input" id="customerAddress">
                            </div>
                        </div>
                        
                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label for="subscriptionType" class="form-label">구독 등급 <span class="text-danger">*</span></label>
                                <select class="form-select add-input" id="subscriptionType" required>
                                    <option value="">선택하세요</option>
                                    <option value="basic">베이직</option>
                                    <option value="standard">스탠다드</option>
                                    <option value="premium">프리미엄</option>
                                </select>
                            </div>
                            <div class="col-md-6">
                                <label for="joinDate" class="form-label">가입일</label>
                                <input type="date" class="form-control add-input" id="joinDate">
                            </div>
                        </div>
                        
                        <div class="mb-3">
                            <label for="customerMemo" class="form-label">메모</label>
                            <textarea class="form-control add-input" id="customerMemo" rows="4"></textarea>
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
    document.getElementById('customerAddForm').addEventListener('submit', function(e) {
        e.preventDefault();
        alert('고객이 등록되었습니다.');
        window.location.href = '<c:url value="/list"/>';
    });
</script>

