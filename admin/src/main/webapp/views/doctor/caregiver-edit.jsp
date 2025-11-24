<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<div class="container-fluid py-4">
    <div class="row">
        <div class="col-12">
            <div class="card shadow-sm mb-4">
                <div class="card-header bg-primary text-white">
                    <h4 class="mb-0"><i class="bi bi-pencil-square me-2"></i>요양사 정보 수정</h4>
                </div>
                <div class="card-body">
                    <form action="<c:url value='/caregiver/editimpl'/>" method="post">
                        <input type="hidden" name="caregiverId" value="${caregiver.caregiverId}">
                        
                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label for="caregiverName" class="form-label">이름 <span class="text-danger">*</span></label>
                                <input type="text" class="form-control" id="caregiverName" name="caregiverName" value="${caregiver.caregiverName}" required>
                            </div>
                            <div class="col-md-6">
                                <label for="caregiverPhone" class="form-label">전화번호 <span class="text-danger">*</span></label>
                                <input type="text" class="form-control" id="caregiverPhone" name="caregiverPhone" value="${caregiver.caregiverPhone}" required>
                            </div>
                        </div>

                        <div class="mb-3">
                            <label for="caregiverAddress" class="form-label">주소</label>
                            <input type="text" class="form-control" id="caregiverAddress" name="caregiverAddress" value="${caregiver.caregiverAddress}">
                        </div>
                        
                        <div class="mb-3">
                            <label for="caregiverCareer" class="form-label">경력</label>
                            <input type="text" class="form-control" id="caregiverCareer" name="caregiverCareer" value="${caregiver.caregiverCareer}">
                        </div>

                        <div class="mb-3">
                            <label for="caregiverCertifications" class="form-label">자격증</label>
                            <textarea class="form-control" id="caregiverCertifications" name="caregiverCertifications" rows="2">${caregiver.caregiverCertifications}</textarea>
                        </div>
                        
                        <div class="mb-3">
                            <label for="caregiverSpecialties" class="form-label">특이사항</label>
                            <textarea class="form-control" id="caregiverSpecialties" name="caregiverSpecialties" rows="2">${caregiver.caregiverSpecialties}</textarea>
                        </div>
                        
                        <div class="d-flex justify-content-end gap-2">
                            <a href="<c:url value='/caregiver/detail/${caregiver.caregiverId}'/>" class="btn btn-secondary">
                                <i class="bi bi-x-circle me-1"></i>취소
                            </a>
                            <button type="submit" class="btn btn-primary">
                                <i class="bi bi-check-circle me-1"></i>저장
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>
