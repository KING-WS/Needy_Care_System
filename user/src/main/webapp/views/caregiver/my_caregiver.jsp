<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<style>
    .caregiver-section {
        padding: 20px 0 100px 0;
        background: #f8f9fa;
    }

    .caregiver-container {
        max-width: 900px;
        margin: 0 auto;
        padding: 0 20px;
    }

    .caregiver-card {
        background: #fff;
        border-radius: 15px;
        box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        padding: 40px;
        margin-top: 20px;
    }

    .no-caregiver-card {
        text-align: center;
        padding: 60px 40px;
    }

    .no-caregiver-card i {
        font-size: 48px;
        color: var(--primary-color);
        margin-bottom: 20px;
    }

    .no-caregiver-card h4 {
        font-size: 22px;
        font-weight: 600;
        color: #495057;
    }

    .caregiver-header {
        text-align: center;
        margin-bottom: 40px;
    }

    .caregiver-header h2 {
        font-size: 32px;
        font-weight: bold;
        color: var(--secondary-color);
        margin-bottom: 30px;
    }

    .profile-section {
        display: flex;
        flex-direction: column;
        align-items: center;
        margin-bottom: 40px;
    }

    .profile-img-container {
        width: 150px;
        height: 150px;
        border-radius: 50%;
        border: 4px solid var(--primary-color);
        display: flex;
        align-items: center;
        justify-content: center;
        background: #f8f9fa;
        margin-bottom: 20px;
        overflow: hidden;
    }

    .profile-img {
        width: 100%;
        height: 100%;
        object-fit: cover;
    }

    .profile-placeholder {
        width: 100%;
        height: 100%;
        display: flex;
        align-items: center;
        justify-content: center;
        color: #999;
        font-size: 48px;
    }

    .info-section {
        display: grid;
        grid-template-columns: 1fr;
        gap: 25px;
    }

    .info-item {
        padding: 20px;
        background: #f8f9fa;
        border-radius: 10px;
        border-left: 4px solid var(--primary-color);
    }

    .info-item label {
        font-weight: 600;
        color: #495057;
        display: block;
        margin-bottom: 10px;
        font-size: 16px;
    }

    .info-item span {
        color: #2c3e50;
        font-size: 16px;
        line-height: 1.6;
    }

    @media (min-width: 768px) {
        .info-section {
            grid-template-columns: 1fr 1fr;
        }
    }
</style>

<section class="caregiver-section">
    <div class="caregiver-container">
        <c:choose>
            <c:when test="${not empty assignedCaregiver}">
                <div class="caregiver-card">
                    <div class="caregiver-header">
                        <h2>
                             ${recipient.recName}님의 담당 요양사 정보
                        </h2>
                    </div>

                    <div class="profile-section">
                        <div class="profile-img-container">
                            <div class="profile-placeholder">
                                <i class="fas fa-user"></i>
                            </div>
                        </div>
                    </div>

                    <div class="info-section">
                        <div class="info-item">
                            <label><i class="fas fa-user"></i> 이름</label>
                            <span>${assignedCaregiver.caregiverName}</span>
                        </div>

                        <div class="info-item">
                            <label><i class="fas fa-phone"></i> 연락처</label>
                            <span>${assignedCaregiver.caregiverPhone}</span>
                        </div>

                        <div class="info-item" style="grid-column: 1 / -1;">
                            <label><i class="fas fa-map-marker-alt"></i> 주소</label>
                            <span>${assignedCaregiver.caregiverAddress}</span>
                        </div>

                        <div class="info-item">
                            <label><i class="fas fa-briefcase"></i> 경력</label>
                            <span>${assignedCaregiver.caregiverCareer}</span>
                        </div>

                        <div class="info-item">
                            <label><i class="fas fa-tasks"></i> 전문 분야</label>
                            <span>${assignedCaregiver.caregiverSpecialties}</span>
                        </div>

                        <div class="info-item" style="grid-column: 1 / -1;">
                            <label><i class="fas fa-certificate"></i> 보유 자격증</label>
                            <span>${assignedCaregiver.caregiverCertifications}</span>
                        </div>
                    </div>
                </div>
            </c:when>
            <c:otherwise>
                <div class="caregiver-card no-caregiver-card">
                    <i class="fas fa-info-circle"></i>
                    <h4>현재 배정된 요양사 정보가 없습니다.</h4>
                    <p style="margin-top: 20px; font-size: 30px; font-weight: bold; color: var(--primary-color); line-height: 1.5; padding: 0 10px;">
                        이제 AI가 돌봄 대상자의 특이사항들을 면밀히 체크 후 최적의 요양사를 배정해 드립니다.
                    </p>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</section>

