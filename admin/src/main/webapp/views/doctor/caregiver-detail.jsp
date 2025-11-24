<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<div class="container-fluid py-4">
    <div class="row">
        <div class="col-12">
            <div class="card shadow-sm">
                <div class="card-header bg-primary text-white">
                    <h4 class="mb-0"><i class="bi bi-person-vcard me-2"></i>요양사 상세 정보</h4>
                </div>
                <div class="card-body">
                    <c:if test="${not empty caregiver}">
                        <div class="row">
                            <div class="col-md-3 text-center">
                                <h5 class="mb-1">${caregiver.caregiverName}</h5>
                                <p class="text-muted">ID: ${caregiver.caregiverId}</p>
                            </div>
                            <div class="col-md-9">
                                <div class="row">
                                    <div class="col-md-6">
                                        <p><strong>전화번호:</strong> ${caregiver.caregiverPhone}</p>
                                        <p><strong>주소:</strong> ${caregiver.caregiverAddress}</p>
                                        <p><strong>경력:</strong> ${caregiver.caregiverCareer}</p>
                                    </div>
                                    <div class="col-md-6">
                                        <p><strong>등록일:</strong> <fmt:formatDate value="${caregiver.caregiverRegdate}" pattern="yyyy-MM-dd HH:mm"/></p>
                                        <p><strong>최종 수정일:</strong> <fmt:formatDate value="${caregiver.caregiverUpdate}" pattern="yyyy-MM-dd HH:mm"/></p>
                                        <p><strong>상태:</strong> ${caregiver.isDeleted == 'N' ? '활성' : '비활성'}</p>
                                    </div>
                                </div>
                                <hr>
                                <p><strong>자격증:</strong> ${caregiver.caregiverCertifications}</p>
                                <p><strong>특이사항:</strong> ${caregiver.caregiverSpecialties}</p>
                            </div>
                        </div>
                        <div class="mt-4 d-flex justify-content-end gap-2">
                            <a href="<c:url value='/caregiver/list'/>" class="btn btn-secondary">
                                <i class="bi bi-list me-1"></i> 목록으로
                            </a>
                            <a href="<c:url value='/caregiver/edit/${caregiver.caregiverId}'/>" class="btn btn-primary">
                                <i class="bi bi-pencil-square me-1"></i> 수정
                            </a>
                        </div>
                    </c:if>
                    <c:if test="${empty caregiver}">
                        <p class="text-center">해당하는 요양사 정보가 없습니다.</p>
                    </c:if>
                </div>
            </div>
        </div>
    </div>
</div>
