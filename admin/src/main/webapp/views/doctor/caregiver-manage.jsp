<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<div class="container-fluid py-4">

    <!-- 탭 네비게이션 -->
    <ul class="nav nav-tabs mb-3" id="caregiverManageTabs" role="tablist">
        <li class="nav-item" role="presentation">
            <button class="nav-link active" id="matching-tab" data-bs-toggle="tab" data-bs-target="#matching" type="button" role="tab" aria-controls="matching" aria-selected="true">
                <i class="bi bi-people me-2"></i>매칭 관리
            </button>
        </li>
        <li class="nav-item" role="presentation">
            <button class="nav-link" id="schedule-tab" data-bs-toggle="tab" data-bs-target="#schedule" type="button" role="tab" aria-controls="schedule" aria-selected="false">
                <i class="bi bi-calendar-week me-2"></i>스케줄 관리
            </button>
        </li>
    </ul>

    <!-- 탭 콘텐츠 -->
    <div class="tab-content" id="caregiverManageTabsContent">
        <!-- 매칭 관리 탭 -->
        <div class="tab-pane fade show active" id="matching" role="tabpanel" aria-labelledby="matching-tab">
            <!-- 신규 매칭 생성 -->
            <div class="row mb-4">
                <div class="col-12">
                    <div class="card shadow-sm">
                        <div class="card-header bg-primary text-white">
                            <h5 class="mb-0"><i class="bi bi-link-45deg me-2"></i>신규 매칭 생성</h5>
                        </div>
                        <div class="card-body">
                            <c:choose>
                                <c:when test="${empty unassignedCaregivers or empty unassignedSeniors}">
                                    <div class="alert alert-warning text-center" role="alert">
                                        매칭 가능한 요양사 또는 수급자가 없습니다.
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <form action="<c:url value='/caregiver/match/add'/>" method="post" class="row g-3 align-items-end">
                                        <div class="col-md-5">
                                            <label for="caregiverId" class="form-label">요양사 선택</label>
                                            <select class="form-select" id="caregiverId" name="caregiverId" required>
                                                <option value="" disabled selected>담당할 요양사를 선택하세요</option>
                                                <c:forEach items="${unassignedCaregivers}" var="caregiver">
                                                    <option value="${caregiver.caregiverId}">${caregiver.caregiverName} (ID: ${caregiver.caregiverId})</option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                        <div class="col-md-5">
                                            <label for="recId" class="form-label">수급자 선택</label>
                                            <select class="form-select" id="recId" name="recId" required>
                                                <option value="" disabled selected>돌봄이 필요한 수급자를 선택하세요</option>
                                                <c:forEach items="${unassignedSeniors}" var="senior">
                                                    <option value="${senior.recId}">${senior.recName} (ID: ${senior.recId})</option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                        <div class="col-md-2">
                                            <button type="submit" class="btn btn-primary w-100">
                                                <i class="bi bi-check-circle me-1"></i> 매칭하기
                                            </button>
                                        </div>
                                    </form>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>
            </div>

            <!-- 현재 매칭 현황 -->
            <div class="row">
                <div class="col-12">
                    <div class="card shadow-sm">
                        <div class="card-header bg-success text-white">
                            <h5 class="mb-0"><i class="bi bi-people me-2"></i>현재 매칭 현황</h5>
                        </div>
                        <div class="card-body">
                            <div class="table-responsive">
                                <table class="table table-hover">
                                    <thead class="table-light">
                                    <tr>
                                        <th>요양사 이름</th>
                                        <th>수급자 이름</th>
                                        <th>관리</th>
                                    </tr>
                                    </thead>
                                    <tbody>
                                    <c:choose>
                                        <c:when test="${empty matchedPairs}">
                                            <tr>
                                                <td colspan="3" class="text-center">현재 매칭된 정보가 없습니다.</td>
                                            </tr>
                                        </c:when>
                                        <c:otherwise>
                                            <c:forEach items="${matchedPairs}" var="match">
                                                <tr>
                                                    <td>${match.caregiverName}</td>
                                                    <td>${match.recName}</td>
                                                    <td>
                                                        <a href="<c:url value='/caregiver/match/delete/${match.matchingId}'/>" class="btn btn-sm btn-danger" onclick="return confirm('정말로 이 매칭을 해제하시겠습니까?');">
                                                            <i class="bi bi-trash"></i>
                                                        </a>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </c:otherwise>
                                    </c:choose>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- 스케줄 관리 탭 -->
        <div class="tab-pane fade" id="schedule" role="tabpanel" aria-labelledby="schedule-tab">
            <div class="card">
                <div class="card-body">
                    <h5 class="card-title">스케줄 관리</h5>
                    <p class="card-text">이곳에 스케줄 관리 기능이 추가될 예정입니다.</p>
                </div>
            </div>
        </div>
    </div>

</div>
