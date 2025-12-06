<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<style>
    #matching .card {
        border-radius: 20px !important;
    }
    #matching .card-header {
        border-top-left-radius: 18px !important;
        border-top-right-radius: 18px !important;
    }
    #matching .card-body {
        border-bottom-left-radius: 18px !important;
        border-bottom-right-radius: 18px !important;
    }

</style>

<div id="matching" class="container-fluid py-4">
    <div class="row">
        <div class="col-12">
            <div class="card shadow-sm">
                <div class="card-header bg-primary text-white">
                    <h4 class="mb-0"><i class="bi bi-person-lines-fill me-2"></i>고객 상세 정보</h4>
                </div>
                <div class="card-body">
                    <c:if test="${not empty user}">
                        <div class="row">
                            <div class="col-md-6">
                                <p><strong>고객 ID:</strong> ${user.custId}</p>
                                <p><strong>고객명:</strong> ${user.custName}</p>
                                <p><strong>이메일:</strong> ${user.custEmail}</p>
                            </div>
                            <div class="col-md-6">
                                <p><strong>연락처:</strong> ${user.custPhone}</p>
                                <p><strong>가입일:</strong> <fmt:formatDate value="${user.custRegdate}" pattern="yyyy-MM-dd HH:mm:ss"/></p>
                                <p><strong>상태:</strong>
                                    <c:choose>
                                        <c:when test="${!user.isDeleted}">
                                            <span class="badge bg-success">활성</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge bg-danger">비활성</span>
                                        </c:otherwise>
                                    </c:choose>
                                </p>
                            </div>
                        </div>
                        <div class="mt-4">
                            <a href="<c:url value='/customer/list'/>" class="btn btn-secondary">
                                <i class="bi bi-list me-1"></i>목록으로
                            </a>
                            <a href="<c:url value='/customer/edit?id=${user.custId}'/>" class="btn btn-primary">
                                <i class="bi bi-pencil-square me-1"></i>수정
                            </a>
                        </div>
                    </c:if>
                    <c:if test="${empty user}">
                        <p class="text-center">해당하는 고객 정보가 없습니다.</p>
                    </c:if>
                </div>
            </div>
        </div>
    </div>
</div>
