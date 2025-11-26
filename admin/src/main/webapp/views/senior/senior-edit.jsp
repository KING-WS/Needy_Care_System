<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<style>
    .edit-card {
        border-radius: 15px;
        overflow: hidden;
    }
    .edit-card .card-header {
        border-radius: 15px 15px 0 0;
    }
    .edit-input {
        border-radius: 10px;
    }
    .edit-btn {
        border-radius: 10px;
        padding: 10px 24px;
    }
</style>

<div class="container-fluid py-4">
    <div class="row">
        <div class="col-12">
            <div class="card shadow-sm mb-4 edit-card">
                <div class="card-header bg-primary text-white">
                    <h4 class="mb-0"><i class="bi bi-pencil-square me-2"></i>노약자 정보 수정</h4>
                </div>
                <div class="card-body">
                    <form action="<c:url value='/senior/editimpl'/>" method="post">
                        <input type="hidden" name="recId" value="${senior.recId}">
                        
                        <div class="row mb-3">
                            <div class="col-md-4">
                                <label for="recName" class="form-label">이름 <span class="text-danger">*</span></label>
                                <input type="text" class="form-control edit-input" id="recName" name="recName" value="${senior.recName}" required>
                            </div>
                            <div class="col-md-4">
                                <label for="recBirthday" class="form-label">생년월일 <span class="text-danger">*</span></label>
                                <input type="date" class="form-control edit-input" id="recBirthday" name="recBirthday" value="<fmt:formatDate value='${senior.recBirthday}' pattern='yyyy-MM-dd'/>" required>
                            </div>
                            <div class="col-md-4">
                                <label for="recGender" class="form-label">성별 <span class="text-danger">*</span></label>
                                <select class="form-select edit-input" id="recGender" name="recGender" required>
                                    <option value="M" ${senior.recGender == 'M' ? 'selected' : ''}>남</option>
                                    <option value="F" ${senior.recGender == 'F' ? 'selected' : ''}>여</option>
                                </select>
                            </div>
                        </div>

                        <div class="mb-3">
                            <label for="recAddress" class="form-label">주소</label>
                            <input type="text" class="form-control edit-input" id="recAddress" name="recAddress" value="${senior.recAddress}">
                        </div>
                        
                        <div class="mb-3">
                            <label for="recMedHistory" class="form-label">병력</label>
                            <textarea class="form-control edit-input" id="recMedHistory" name="recMedHistory" rows="2">${senior.recMedHistory}</textarea>
                        </div>

                        <div class="mb-3">
                            <label for="recAllergies" class="form-label">알레르기</label>
                            <textarea class="form-control edit-input" id="recAllergies" name="recAllergies" rows="2">${senior.recAllergies}</textarea>
                        </div>
                        
                        <div class="mb-3">
                            <label for="recSpecNotes" class="form-label">특이사항</label>
                            <textarea class="form-control edit-input" id="recSpecNotes" name="recSpecNotes" rows="2">${senior.recSpecNotes}</textarea>
                        </div>

                        <div class="mb-3">
                            <label for="recHealthNeeds" class="form-label">건강 관련 필요사항</label>
                            <textarea class="form-control edit-input" id="recHealthNeeds" name="recHealthNeeds" rows="2">${senior.recHealthNeeds}</textarea>
                        </div>
                        
                        <div class="d-flex justify-content-end gap-2">
                            <a href="<c:url value='/senior/detail/${senior.recId}'/>" class="btn btn-secondary edit-btn">
                                <i class="bi bi-x-circle me-1"></i>취소
                            </a>
                            <button type="submit" class="btn btn-primary edit-btn">
                                <i class="bi bi-check-circle me-1"></i>저장
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>
