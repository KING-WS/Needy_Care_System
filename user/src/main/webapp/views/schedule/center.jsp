<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- 통신 메인 페이지 -->
<section style="padding: 20px;">
    <div class="container-fluid">
        <div class="row">
            <div class="col-12 mb-4">
                <h1 style="font-size: 36px; font-weight: bold; color: var(--secondary-color);">
                    <i class="fas fa-comments"></i> 일정페이지
                </h1>
                <p style="font-size: 16px; color: #666; margin-top: 10px;">
                    ${sessionScope.loginUser.custName}님의 일정페이지
                </p>
            </div>

        </div>
    </div>
</section>

