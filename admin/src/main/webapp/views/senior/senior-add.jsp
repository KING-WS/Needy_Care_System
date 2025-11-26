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
                    <form action="<c:url value='/senior/addimpl'/>" method="post">
                        <div class="row mb-3">
                            <div class="col-md-4">
                                <label for="recName" class="form-label">이름 <span class="text-danger">*</span></label>
                                <input type="text" class="form-control add-input" id="recName" name="recName" required>
                            </div>
                            <div class="col-md-4">
                                <label for="recBirthday" class="form-label">생년월일 <span class="text-danger">*</span></label>
                                <input type="date" class="form-control add-input" id="recBirthday" name="recBirthday" required>
                            </div>
                            <div class="col-md-4">
                                <label for="recGender" class="form-label">성별 <span class="text-danger">*</span></label>
                                <select class="form-select add-input" id="recGender" name="recGender" required>
                                    <option value="">선택하세요</option>
                                    <option value="M">남</option>
                                    <option value="F">여</option>
                                </select>
                            </div>
                        </div>

                        <div class="mb-3">
                            <label for="recAddress" class="form-label">주소</label>
                            <input type="text" class="form-control add-input" id="recAddress" name="recAddress">
                        </div>
                        
                        <div class="mb-3">
                            <label for="recMedHistory" class="form-label">병력</label>
                            <textarea class="form-control add-input" id="recMedHistory" name="recMedHistory" rows="2"></textarea>
                        </div>

                        <div class="mb-3">
                            <label for="recAllergies" class="form-label">알레르기</label>
                            <textarea class="form-control add-input" id="recAllergies" name="recAllergies" rows="2"></textarea>
                        </div>
                        
                        <div class="mb-3">
                            <label for="recSpecNotes" class="form-label">특이사항</label>
                            <textarea class="form-control add-input" id="recSpecNotes" name="recSpecNotes" rows="2"></textarea>
                        </div>

                        <div class="mb-3">
                            <label for="recHealthNeeds" class="form-label">건강 관련 필요사항</label>
                            <textarea class="form-control add-input" id="recHealthNeeds" name="recHealthNeeds" rows="2"></textarea>
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

