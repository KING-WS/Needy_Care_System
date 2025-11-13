<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- 페이지1 컨텐츠 -->
<section style="min-height: calc(100vh - 80px - 100px); padding: 100px 0; background: #f8f9fa;">
    <div class="container">
        <div class="row">
            <div class="col-12">
                <h1 style="font-size: 42px; font-weight: bold; color: var(--secondary-color); text-align: center; margin-bottom: 30px;">
                    <i class="fas fa-file-alt"></i> 페이지 1
                </h1>
                <p style="font-size: 18px; color: #666; text-align: center; margin-bottom: 50px;">
                    페이지 1의 내용입니다.
                </p>
            </div>
            
            <div class="col-md-6 mb-4">
                <div class="dashboard-card">
                    <i class="fas fa-info-circle" style="font-size: 60px; color: var(--primary-color); margin-bottom: 20px;"></i>
                    <h3 style="font-size: 24px; margin-bottom: 10px;">정보 1</h3>
                    <p style="color: #666;">여기에 페이지 1의 정보가 표시됩니다.</p>
                </div>
            </div>
            
            <div class="col-md-6 mb-4">
                <div class="dashboard-card">
                    <i class="fas fa-chart-bar" style="font-size: 60px; color: var(--primary-color); margin-bottom: 20px;"></i>
                    <h3 style="font-size: 24px; margin-bottom: 10px;">통계</h3>
                    <p style="color: #666;">페이지 1 관련 통계 데이터</p>
                </div>
            </div>
        </div>
    </div>
</section>

