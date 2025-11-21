<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div class="container-fluid py-4">
    <div class="row">
        <div class="col-12">
            <div class="card shadow-sm">
                <div class="card-header bg-primary text-white">
                    <h4 class="mb-0"><i class="bi bi-pencil-square me-2"></i>고객 정보 수정</h4>
                </div>
                <div class="card-body">
                    <form action="<c:url value="/customer/editimpl"/>" method="post">
                        <input type="hidden" name="custId" value="${user.custId}">
                        
                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label for="custName" class="form-label">고객명</label>
                                <input type="text" class="form-control" id="custName" name="custName" value="${user.custName}" required>
                            </div>
                            <div class="col-md-6">
                                <label for="custEmail" class="form-label">이메일</label>
                                <input type="email" class="form-control" id="custEmail" name="custEmail" value="${user.custEmail}" required>
                            </div>
                        </div>
                        
                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label for="custPhone" class="form-label">연락처</label>
                                <input type="tel" class="form-control" id="custPhone" name="custPhone" value="${user.custPhone}" required>
                            </div>
                            <div class="col-md-6">
                                <label for="isDeleted" class="form-label">상태</label>
                                <select class="form-select" id="isDeleted" name="isDeleted">
                                    <option value="N" ${user.isDeleted == 'N' ? 'selected' : ''}>활성</option>
                                    <option value="Y" ${user.isDeleted == 'Y' ? 'selected' : ''}>비활성</option>
                                </select>
                            </div>
                        </div>
                        
                        <div class="mt-4 d-flex justify-content-end gap-2">
                            <a href="<c:url value='/customer/detail?id=${user.custId}'/>" class="btn btn-secondary">
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
