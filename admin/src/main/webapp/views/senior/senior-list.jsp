<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<style>
    .senior-card {
        border-radius: 15px;
        overflow: hidden;
    }
    
    .senior-card .card-header {
        border-radius: 15px 15px 0 0;
    }
    
    .senior-btn {
        border-radius: 10px;
        padding: 10px 20px;
    }
    
    .senior-table {
        border-radius: 10px;
        overflow: hidden;
    }
    
    .senior-badge {
        border-radius: 8px;
        padding: 6px 12px;
    }
</style>

<div class="container-fluid py-4">
    <div class="row">
        <div class="col-12">
            <div class="card shadow-sm mb-4 senior-card">
                <div class="card-header bg-primary text-white d-flex justify-content-between align-items-center">
                    <h4 class="mb-0"><i class="bi bi-person-wheelchair me-2"></i>노약자 목록</h4>
                    <a href="<c:url value='/senior/add'/>" class="btn btn-light senior-btn">
                        <i class="bi bi-person-plus me-1"></i>노약자 등록
                    </a>
                </div>
                <div class="card-body">
                    <div class="table-responsive senior-table">
                        <table class="table table-hover">
                            <thead class="table-light">
                                <tr>
                                    <th>번호</th>
                                    <th>이름</th>
                                    <th>나이</th>
                                    <th>성별</th>
                                    <th>담당 요양사</th>
                                    <th>건강 상태</th>
                                    <th>등록일</th>
                                    <th>관리</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:choose>
                                    <c:when test="${empty seniorList}">
                                        <tr>
                                            <td colspan="8" class="text-center">등록된 노약자 정보가 없습니다.</td>
                                        </tr>
                                    </c:when>
                                    <c:otherwise>
                                        <c:forEach items="${seniorList}" var="senior">
                                            <tr>
                                                <td>${senior.recId}</td>
                                                <td>${senior.recName}</td>
                                                <td>${senior.age}세</td>
                                                <td>
                                                    <c:if test="${senior.recGender == 'M'}">남</c:if>
                                                    <c:if test="${senior.recGender == 'F'}">여</c:if>
                                                </td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${not empty senior.caregiverName}">
                                                            ${senior.caregiverName}
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="text-muted">미지정</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <%-- 건강 상태 로직 추가 필요 --%>
                                                    <span class="badge bg-success senior-badge">${senior.recHealthNeeds}</span>
                                                </td>
                                                <td>
                                                    <fmt:formatDate value="${senior.recRegdate}" pattern="yyyy-MM-dd"/>
                                                </td>
                                                <td>
                                                    <button class="btn btn-sm btn-primary senior-btn" onclick="location.href='<c:url value="/senior/details/${senior.recId}"/>'">
                                                        <i class="bi bi-eye"></i>
                                                    </button>
                                                    <button class="btn btn-sm btn-warning senior-btn" onclick="location.href='<c:url value="/senior/edit/${senior.recId}"/>'">
                                                        <i class="bi bi-pencil"></i>
                                                    </button>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </c:otherwise>
                                </c:choose>
                            </tbody>
                        </table>
                    </div>
                    
                    <nav aria-label="Page navigation" class="mt-3">
                        <ul class="pagination justify-content-center">
                            <li class="page-item disabled">
                                <a class="page-link" href="#" tabindex="-1">이전</a>
                            </li>
                            <li class="page-item active"><a class="page-link" href="#">1</a></li>
                            <li class="page-item"><a class="page-link" href="#">2</a></li>
                            <li class="page-item"><a class="page-link" href="#">3</a></li>
                            <li class="page-item">
                                <a class="page-link" href="#">다음</a>
                            </li>
                        </ul>
                    </nav>
                </div>
            </div>
        </div>
    </div>
</div>

