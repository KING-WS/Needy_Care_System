<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

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
                                    <th>번호</th>
                                    <th>이름</th>
                                    <th>전화번호</th>
                                    <th>주소</th>
                                    <th>경력</th>
                                    <th>자격증</th>
                                    <th>등록일</th>
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
                    
                    <nav aria-label="Page navigation" class="mt-3">
                        <ul class="pagination justify-content-center">
                            <c:if test="${page.hasPreviousPage}">
                                <li class="page-item">
                                    <a class="page-link" href="<c:url value='/caregiver/list?pageNo=${page.prePage}'/>">이전</a>
                                </li>
                            </c:if>
                            <c:forEach begin="1" end="${page.pages}" var="i">
                                <li class="page-item <c:if test='${page.pageNum eq i}'>active</c:if>">
                                    <a class="page-link" href="<c:url value='/caregiver/list?pageNo=${i}'/>">${i}</a>
                                </li>
                            </c:forEach>
                            <c:if test="${page.hasNextPage}">
                                <li class="page-item">
                                    <a class="page-link" href="<c:url value='/caregiver/list?pageNo=${page.nextPage}'/>">다음</a>
                                </li>
                            </c:if>
                        </ul>
                    </nav>
                </div>
            </div>
        </div>
    </div>
</div>