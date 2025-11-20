<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<style>
    .customer-card {
        border-radius: 15px;
        overflow: hidden;
    }
    
    .customer-card .card-header {
        border-radius: 15px 15px 0 0;
    }
    
    .customer-btn {
        border-radius: 10px;
        padding: 10px 20px;
    }
    
    .customer-table {
        border-radius: 10px;
        overflow: hidden;
    }
    
    .customer-badge {
        border-radius: 8px;
        padding: 6px 12px;
    }
</style>

<div class="container-fluid py-4">
    <div class="row">
        <div class="col-12">
            <div class="card shadow-sm customer-card">
                <div class="card-header bg-primary text-white">
                    <h4 class="mb-0"><i class="bi bi-people me-2"></i>고객 목록</h4>
                </div>
                <div class="card-body">
                    <div class="mb-4">
                        <a href="<c:url value="/customer/add"/>" class="btn btn-primary customer-btn">
                            <i class="bi bi-person-plus me-2"></i>고객 등록
                        </a>
                        <button class="btn btn-outline-secondary ms-2 customer-btn">
                            <i class="bi bi-download me-2"></i>엑셀 다운로드
                        </button>
                    </div>
                    
                    <div class="table-responsive">
                        <table class="table table-hover customer-table">
                            <thead class="table-light">
                                <tr>
                                    <th><input type="checkbox"></th>
                                    <th>번호</th>
                                    <th>고객명</th>
                                    <th>연락처</th>
                                    <th>이메일</th>
                                    <th>가입일</th>
                                    <th>상태</th>
                                    <th>관리</th>
                                </tr>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
                            </thead>
                            <tbody>
                                <c:forEach var="user" items="${users}" varStatus="status">
                                    <tr>
                                        <td><input type="checkbox"></td>
                                        <td>${user.custId}</td>
                                        <td>${user.custName}</td>
                                        <td>${user.custPhone}</td>
                                        <td>${user.custEmail}</td>
                                        <td><fmt:formatDate value="${user.custRegdate}" pattern="yyyy-MM-dd"/></td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${!user.isDeleted}">
                                                    <span class="badge bg-success customer-badge">활성</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge bg-danger customer-badge">비활성</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <button class="btn btn-sm btn-outline-primary" style="border-radius: 8px;">상세</button>
                                            <button class="btn btn-sm btn-outline-secondary" style="border-radius: 8px;">수정</button>
                                        </td>
                                    </tr>
                                </c:forEach>
                                <c:if test="${empty users}">
                                    <tr>
                                        <td colspan="8" class="text-center">등록된 고객이 없습니다.</td>
                                    </tr>
                                </c:if>
                            </tbody>
                        </table>
                    </div>
                    
                    <nav>
                        <ul class="pagination justify-content-center">
                </div>
            </div>
        </div>
    </div>
</div>

