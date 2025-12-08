<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<style>
    .card.shadow-sm.mb-4 { /* Target the specific card */
        border-top-left-radius: 20px !important;
        border-top-right-radius: 20px !important;
        border-bottom-left-radius: 0 !important; /* Keep bottom corners sharp or default */
        border-bottom-right-radius: 0 !important;
    }
    .card-header {
        border-top-left-radius: 18px !important; /* Slightly smaller to fit inside card's radius */
        border-top-right-radius: 18px !important;
    }
</style>

<%-- 변수 설정 --%>
<c:set var="currentSort" value="${sort}" />
<c:set var="currentOrder" value="${order}" />

<div class="container-fluid py-4">
    <div class="row">
        <div class="col-12">
            <div class="card shadow-sm mb-4">
                <div class="card-header bg-primary text-white d-flex justify-content-between align-items-center">
                    <h4 class="mb-0"><i class="bi bi-person-badge me-2"></i>요양사 목록</h4>
                    <a href="<c:url value='/caregiver/add'/>" class="btn btn-light">
                        <i class="bi bi-person-plus me-1"></i>요양사 등록
                    </a>
                </div>
                <div class="card-body">
                    <div class="table-responsive">
                        <table class="table table-hover">
                            <thead class="table-light">
                                <tr>
                                    <%-- 각 헤더에 정렬 링크 추가 --%>
                                    <th>
                                        <c:set var="orderForId" value="${(currentSort eq 'caregiverId' and currentOrder eq 'asc') ? 'desc' : 'asc'}" />
                                        <a href="<c:url value='/caregiver/list?sort=caregiverId&order=${orderForId}'/>" class="text-decoration-none text-dark">
                                            번호
                                            <c:if test="${currentSort eq 'caregiverId'}"><i class="bi ${currentOrder eq 'asc' ? 'bi-arrow-up' : 'bi-arrow-down'}"></i></c:if>
                                        </a>
                                    </th>
                                    <th>
                                        <c:set var="orderForName" value="${(currentSort eq 'caregiverName' and currentOrder eq 'asc') ? 'desc' : 'asc'}" />
                                        <a href="<c:url value='/caregiver/list?sort=caregiverName&order=${orderForName}'/>" class="text-decoration-none text-dark">
                                            이름
                                            <c:if test="${currentSort eq 'caregiverName'}"><i class="bi ${currentOrder eq 'asc' ? 'bi-arrow-up' : 'bi-arrow-down'}"></i></c:if>
                                        </a>
                                    </th>
                                    <th>전화번호</th>
                                    <th>주소</th>
                                    <th>
                                        <c:set var="orderForCareer" value="${(currentSort eq 'caregiverCareer' and currentOrder eq 'asc') ? 'desc' : 'asc'}" />
                                        <a href="<c:url value='/caregiver/list?sort=caregiverCareer&order=${orderForCareer}'/>" class="text-decoration-none text-dark">
                                            경력
                                            <c:if test="${currentSort eq 'caregiverCareer'}"><i class="bi ${currentOrder eq 'asc' ? 'bi-arrow-up' : 'bi-arrow-down'}"></i></c:if>
                                        </a>
                                    </th>
                                    <th>자격증</th>
                                    <th>
                                        <c:set var="orderForRegdate" value="${(currentSort eq 'caregiverRegdate' and currentOrder eq 'asc') ? 'desc' : 'asc'}" />
                                        <a href="<c:url value='/caregiver/list?sort=caregiverRegdate&order=${orderForRegdate}'/>" class="text-decoration-none text-dark">
                                            등록일
                                            <c:if test="${currentSort eq 'caregiverRegdate'}"><i class="bi ${currentOrder eq 'asc' ? 'bi-arrow-up' : 'bi-arrow-down'}"></i></c:if>
                                        </a>
                                    </th>
                                    <th>관리</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:choose>
                                    <c:when test="${empty caregiverList}">
                                        <tr>
                                            <td colspan="8" class="text-center">등록된 요양사 정보가 없습니다.</td>
                                        </tr>
                                    </c:when>
                                    <c:otherwise>
                                        <c:forEach items="${caregiverList}" var="caregiver">
                                            <tr>
                                                <td>${caregiver.caregiverId}</td>
                                                <td>${caregiver.caregiverName}</td>
                                                <td>${caregiver.caregiverPhone}</td>
                                                <td>${caregiver.caregiverAddress}</td>
                                                <td>${caregiver.caregiverCareer}</td>
                                                <td>${caregiver.caregiverCertifications}</td>
                                                <td>
                                                    <fmt:formatDate value="${caregiver.caregiverRegdate}" pattern="yyyy-MM-dd"/>
                                                </td>
                                                <td>
                                                    <button class="btn btn-sm btn-primary" onclick="location.href='<c:url value="/caregiver/detail/${caregiver.caregiverId}"/>'">
                                                        <i class="bi bi-eye"></i>
                                                    </button>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </c:otherwise>
                                </c:choose>
                            </tbody>
                        </table>
                    </div>
                    
                    <%-- 페이지네이션: 정렬 상태 유지 --%>
                    <nav aria-label="Page navigation" class="mt-3">
                        <ul class="pagination justify-content-center">
                            <c:if test="${page.hasPreviousPage}">
                                <li class="page-item">
                                    <a class="page-link" href="<c:url value='/caregiver/list?pageNo=${page.prePage}&sort=${currentSort}&order=${currentOrder}'/>">이전</a>
                                </li>
                            </c:if>
                            <c:forEach items="${page.navigatepageNums}" var="i">
                                <li class="page-item <c:if test='${page.pageNum eq i}'>active</c:if>">
                                    <a class="page-link" href="<c:url value='/caregiver/list?pageNo=${i}&sort=${currentSort}&order=${currentOrder}'/>">${i}</a>
                                </li>
                            </c:forEach>
                            <c:if test="${page.hasNextPage}">
                                <li class="page-item">
                                    <a class="page-link" href="<c:url value='/caregiver/list?pageNo=${page.nextPage}&sort=${currentSort}&order=${currentOrder}'/>">다음</a>
                                </li>
                            </c:if>
                        </ul>
                    </nav>
                </div>
            </div>
        </div>
    </div>
</div>