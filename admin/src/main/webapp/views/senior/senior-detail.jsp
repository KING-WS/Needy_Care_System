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
                <div class="card-header bg-primary text-white ">
                    <h4 class="mb-0"><i class="bi bi-person-vcard me-2"></i>노약자 상세 정보</h4>
                </div>
                <div class="card-body">
                    <c:if test="${not empty senior}">
                        <div class="row">
                            <div class="col-md-3 text-center">
                                <c:choose>
                                    <c:when test="${not empty senior.recPhotoUrl}">
                                        <img src="${senior.recPhotoUrl}" class="img-fluid rounded-circle mb-3" alt="노약자 사진" style="width: 150px; height: 150px; object-fit: cover;">
                                    </c:when>
                                    <c:otherwise>
                                        <img src="<c:url value='/assets/images/avatar-placeholder.svg'/>" class="img-fluid rounded-circle mb-3" alt="기본 사진" style="width: 150px; height: 150px; object-fit: cover;">
                                    </c:otherwise>
                                </c:choose>
                                <h5 class="mb-1">${senior.recName}</h5>
                                <p class="text-muted">ID: ${senior.recId}</p>
                            </div>
                            <div class="col-md-9">
                                <div class="row">
                                    <div class="col-md-6">
                                        <p><strong>나이:</strong> ${senior.age}세</p>
                                        <p><strong>생년월일:</strong> <fmt:formatDate value="${senior.recBirthday}" pattern="yyyy년 MM월 dd일"/></p>
                                        <p><strong>성별:</strong> ${senior.recGender == 'M' ? '남성' : '여성'}</p>
                                        <p><strong>담당 요양사:</strong>
                                            <c:choose>
                                                <c:when test="${not empty senior.caregiverName}">${senior.caregiverName}</c:when>
                                                <c:otherwise><span class="text-muted">미지정</span></c:otherwise>
                                            </c:choose>
                                        </p>
                                    </div>
                                    <div class="col-md-6">
                                        <p><strong>주소:</strong> ${senior.recAddress}</p>
                                        <p><strong>등록일:</strong> <fmt:formatDate value="${senior.recRegdate}" pattern="yyyy-MM-dd HH:mm"/></p>
                                        <p><strong>최종 수정일:</strong> <fmt:formatDate value="${senior.recUpdate}" pattern="yyyy-MM-dd HH:mm"/></p>
                                        <p><strong>상태:</strong> ${senior.isDeleted == 'N' ? '활성' : '비활성'}</p>
                                    </div>
                                </div>
                                <hr>
                                <p><strong>병력:</strong> ${senior.recMedHistory}</p>
                                <p><strong>알레르기:</strong> ${senior.recAllergies}</p>
                                <p><strong>특이사항:</strong> ${senior.recSpecNotes}</p>
                                <p><strong>건강 관련 필요사항:</strong> ${senior.recHealthNeeds}</p>
                            </div>
                        </div>
                        <div class="mt-4 d-flex justify-content-end gap-2">
                            <a href="<c:url value='/senior/list'/>" class="btn btn-secondary">
                                <i class="bi bi-list me-1"></i> 목록으로
                            </a>
                            <a href="<c:url value='/senior/edit/${senior.recId}'/>" class="btn btn-primary">
                                <i class="bi bi-pencil-square me-1"></i> 수정
                            </a>
                        </div>
                    </c:if>
                    <c:if test="${empty senior}">
                        <p class="text-center">해당하는 노약자 정보가 없습니다.</p>
                    </c:if>
                </div>
            </div>
        </div>
    </div>
</div>
