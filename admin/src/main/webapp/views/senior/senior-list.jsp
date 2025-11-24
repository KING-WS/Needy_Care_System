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

    .status-dot {
        height: 10px;
        width: 10px;
        background-color: #bbb; /* 기본 회색 */
        border-radius: 50%;
        display: inline-block;
        margin-right: 5px;
    }

    .status-dot.online {
        background-color: #28a745; /* 녹색 */
    }

    .status-dot.offline {
        background-color: #dc3545; /* 빨간색 */
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
                                    <th>접속 상태</th>
                                    <th>관리</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="senior" items="${seniorList}" varStatus="status">
                                    <tr data-rec-id="${senior.recId}" data-kiosk-code="${senior.recKioskCode}">
                                        <td>${status.count + (page.pageNum - 1) * page.pageSize}</td>
                                        <td>${senior.recName}</td>
                                        <td>${senior.age}세</td>
                                        <td>${senior.recGender}</td>
                                        <td>${senior.caregiverName}</td>
                                        <td><span class="badge bg-success senior-badge">${senior.recHealthNeeds}</span></td>
                                        <td>${senior.recRegdate}</td>
                                        <td>
                                            <span class="status-dot offline" id="status-dot-${senior.recKioskCode}"></span>
                                            <span id="status-text-${senior.recKioskCode}">오프라인</span>
                                        </td>
                                        <td>
                                            <a href="<c:url value='/senior/detail/${senior.recId}'/>" class="btn btn-sm btn-primary senior-btn">
                                                <i class="bi bi-eye"></i>
                                            </a>
                                        </td>
                                    </tr>
                                </c:forEach>
                                <c:if test="${empty seniorList}">
                                    <tr>
                                        <td colspan="9" class="text-center">등록된 노약자가 없습니다.</td>
                                    </tr>
                                </c:if>
                            </tbody>
                        </table>
                    </div>
                    
                    <nav aria-label="Page navigation" class="mt-3">
                        <ul class="pagination justify-content-center">
                            <c:if test="${page.hasPreviousPage}">
                                <li class="page-item">
                                    <a class="page-link" href="<c:url value='/senior/list?pageNo=${page.pageNum - 1}'/>">이전</a>
                                </li>
                            </c:if>
                            <c:forEach var="pNum" begin="${page.navigateFirstPage}" end="${page.navigateLastPage}">
                                <li class="page-item ${pNum == page.pageNum ? 'active' : ''}">
                                    <a class="page-link" href="<c:url value='/senior/list?pageNo=${pNum}'/>">${pNum}</a>
                                </li>
                            </c:forEach>
                            <c:if test="${page.hasNextPage}">
                                <li class="page-item">
                                    <a class="page-link" href="<c:url value='/senior/list?pageNo=${page.pageNum + 1}'/>">다음</a>
                                </li>
                            </c:if>
                        </ul>
                    </nav>
                </div>
            </div>
        </div>
    </div>
</div>

