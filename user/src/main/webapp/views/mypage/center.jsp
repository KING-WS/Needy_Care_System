<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<style>
    /* ---------------------------------------------------- */
    /* 1. 글로벌 스타일 및 변수 정의 (detail.jsp 동일) */
    /* ---------------------------------------------------- */
    :root {
        --primary-color: #3498db;
        --secondary-color: #343a40;
        --secondary-bg: #F0F8FF;
        --card-bg: white;
        --danger-color: #e74c3c;
    }

    body {
        background-color: #f8f9fa;
    }

    /* ---------------------------------------------------- */
    /* 2. 레이아웃 */
    /* ---------------------------------------------------- */
    .detail-container {
        max-width: 1300px;
        margin: 0 auto;
        padding: 40px 20px;
        padding-bottom: 50px;
        min-height: calc(100vh - 150px);
    }

    /* 마이페이지는 좌측(정보/활동)이 넓고 우측(메뉴)이 좁은 형태가 적합하므로 비율 조정 (2:1) */
    .detail-two-column {
        display: grid;
        grid-template-columns: 2fr 1fr;
        gap: 30px;
        align-items: start;
    }

    @media (max-width: 992px) {
        .detail-two-column {
            grid-template-columns: 1fr; /* 모바일/태블릿에선 1단 */
        }
    }

    /* ---------------------------------------------------- */
    /* 3. 카드 및 섹션 스타일 */
    /* ---------------------------------------------------- */
    .detail-content-card {
        background: var(--card-bg);
        border-radius: 20px;
        padding: 30px;
        box-shadow: 0 10px 30px rgba(0,0,0,0.05);
        margin-bottom: 30px;
    }

    .section-title {
        font-size: 20px;
        font-weight: 700;
        color: #000;
        margin-bottom: 20px;
        display: flex;
        align-items: center;
        padding-bottom: 5px;
        border-bottom: 3px solid var(--secondary-bg);
    }

    .section-title i {
        margin-right: 10px;
        color: var(--primary-color);
        font-size: 22px;
    }

    /* ---------------------------------------------------- */
    /* 4. 프로필 스타일 (detail.jsp의 detail-header 차용) */
    /* ---------------------------------------------------- */
    .profile-header {
        text-align: center;
        margin-bottom: 30px;
    }

    .detail-avatar {
        width: 120px;
        height: 120px;
        border-radius: 50%;
        background: var(--primary-color);
        display: flex;
        align-items: center;
        justify-content: center;
        color: white;
        font-size: 60px;
        margin: 0 auto 20px;
        border: 4px solid var(--secondary-bg);
    }

    .detail-name {
        font-size: 28px;
        font-weight: 700;
        color: var(--secondary-color);
        margin-bottom: 5px;
    }

    .detail-meta {
        font-size: 14px;
        color: #7f8c8d;
    }

    /* ---------------------------------------------------- */
    /* 5. 정보 그리드 및 아이템 (detail.jsp의 info-item 차용) */
    /* ---------------------------------------------------- */
    .info-grid {
        display: flex;
        flex-direction: column;
        gap: 10px;
    }

    /* 2열 그리드가 필요한 경우를 위한 클래스 */
    .info-grid-row {
        display: grid;
        grid-template-columns: 1fr 1fr;
        gap: 15px;
    }

    @media (max-width: 768px) {
        .info-grid-row {
            grid-template-columns: 1fr;
        }
    }

    .info-item {
        padding: 15px;
        background: var(--secondary-bg);
        border-radius: 12px;
        transition: all 0.3s ease;
        display: flex;
        flex-direction: column;
        border: 1px solid transparent;
    }

    .info-item:hover {
        background: #e9f2ff;
        border-color: var(--primary-color);
    }

    .info-label {
        font-size: 13px;
        font-weight: 600;
        color: #7f8c8d;
        margin-bottom: 4px;
        text-transform: uppercase;
    }

    .info-value {
        font-size: 16px;
        font-weight: 600;
        color: var(--secondary-color);
        word-break: break-all;
    }

    /* ---------------------------------------------------- */
    /* 6. 빠른 메뉴 (info-item 스타일 변형) */
    /* ---------------------------------------------------- */
    .menu-link {
        text-decoration: none;
        color: inherit;
        display: block;
    }

    .menu-item {
        padding: 18px 20px;
        background: white; /* 메뉴는 흰 배경 */
        border: 1px solid #e9ecef;
        border-radius: 12px;
        margin-bottom: 10px;
        display: flex;
        align-items: center;
        transition: all 0.2s ease;
        font-weight: 600;
        color: var(--secondary-color);
    }

    .menu-item i {
        margin-right: 15px;
        font-size: 20px;
        color: var(--primary-color);
    }

    .menu-item:hover {
        background: var(--secondary-bg);
        transform: translateX(5px);
        color: var(--primary-color);
        border-color: var(--primary-color);
    }

    /* ---------------------------------------------------- */
    /* 7. 최근 활동 테이블 및 기타 요소 */
    /* ---------------------------------------------------- */
    .activity-table {
        width: 100%;
        border-collapse: separate;
        border-spacing: 0;
    }

    .activity-table th {
        text-align: left;
        padding: 15px;
        font-size: 14px;
        color: #7f8c8d;
        font-weight: 600;
        border-bottom: 2px solid var(--secondary-bg);
    }

    .activity-table td {
        padding: 15px;
        border-bottom: 1px solid #f0f0f0;
        color: var(--secondary-color);
        vertical-align: middle;
    }

    .badge {
        display: inline-block;
        padding: 5px 12px;
        border-radius: 20px;
        font-size: 12px;
        font-weight: 600;
    }

    .badge-success { background: #d4edda; color: #155724; }
    .badge-info { background: #d1ecf1; color: #0c5460; }
    .badge-warning { background: #fff3cd; color: #856404; }

    /* 계정 안내 박스 (detail.jsp의 info-textarea 스타일 활용) */
    .guide-box {
        /* 그라데이션 배경을 적용하여 시각적 강조 */
        background: linear-gradient(135deg, #7b88fa 0%, var(--primary-color) 100%);
        padding: 20px;
        border-radius: 15px;
        box-shadow: 0 5px 20px rgba(0, 0, 0, 0.2);
        color: white; /* 텍스트 색상을 흰색으로 변경 */
    }

    .guide-box h4 {
        /* 타이틀 스타일 변경 */
        font-size: 16px;
        font-weight: 700;
        color: white; /* 타이틀 색상 흰색 */
        margin-bottom: 15px;
        padding-bottom: 10px;
        border-bottom: 1px solid rgba(255, 255, 255, 0.5); /* 흰색 구분선 추가 */
    }

    .guide-item {
        margin-bottom: 8px;
        font-size: 14px;
        color: rgba(255, 255, 255, 0.9); /* 연한 흰색 텍스트 */
        display: flex;
        align-items: start;
        gap: 8px;
    }
    .guide-item:last-child { margin-bottom: 0; }
    .guide-item i {
        color: white; /* 아이콘 색상 흰색 */
        margin-top: 3px;
        font-size: 16px; /* 아이콘 크기 약간 증가 */ }

    /* 버튼 스타일 */
    .btn-edit {
        display: inline-block;
        padding: 10px 25px;
        background: var(--primary-color);
        color: white;
        border-radius: 50px;
        font-weight: 600;
        text-decoration: none;
        margin-top: 20px;
        transition: all 0.3s;
    }
    .btn-edit:hover {
        transform: translateY(-2px);
        background: #2980b9;
        color: white;
    }
</style>

<div class="detail-container">
    <div class="text-center mb-5">
        <h1 style="font-size: 38px; font-weight: 800; color: var(--secondary-color); text-shadow: 0 1px 2px rgba(0, 0, 0, 0.05);">
            <i class="bi bi-person-circle" style="color: var(--primary-color);"></i> 마이페이지
        </h1>
        <p style="font-size: 16px; color: #666; margin-top: 10px;">
            ${sessionScope.loginUser.custName}님의 개인정보 및 활동 내역입니다.
        </p>
    </div>

    <div class="detail-two-column">
        <div>
            <div class="detail-content-card">
                <h3 class="section-title">
                    <i class="bi bi-person-vcard"></i> 기본 정보
                </h3>

                <div class="profile-header">
                    <div class="detail-avatar">
                        <i class="bi bi-person-fill"></i>
                    </div>
                    <div class="detail-name">${sessionScope.loginUser.custName}</div>
                    <div class="detail-meta">회원님, 환영합니다!</div>

                    <a href="<c:url value="/mypage/profile"/>" class="btn-edit">
                        <i class="bi bi-pencil-fill"></i> 정보 수정
                    </a>
                </div>

                <div class="info-grid-row">
                    <div class="info-item">
                        <div class="info-label">이름</div>
                        <div class="info-value">${sessionScope.loginUser.custName}</div>
                    </div>
                    <div class="info-item">
                        <div class="info-label">전화번호</div>
                        <div class="info-value">${sessionScope.loginUser.custPhone}</div>
                    </div>
                    <div class="info-item">
                        <div class="info-label">이메일</div>
                        <div class="info-value">${sessionScope.loginUser.custEmail}</div>
                    </div>
                    <div class="info-item">
                        <div class="info-label">가입일</div>
                        <div class="info-value">${sessionScope.loginUser.custRegdate}</div>
                    </div>
                </div>
            </div>

            <div class="detail-content-card">
                <h3 class="section-title">
                    <i class="bi bi-clock-history"></i> 최근 활동
                </h3>
                <div class="table-responsive">
                    <table class="activity-table">
                        <thead>
                        <tr>
                            <th>활동 내역</th>
                            <th>일시</th>
                            <th>상태</th>
                        </tr>
                        </thead>
                        <tbody>
                        <tr>
                            <td><i class="bi bi-box-arrow-in-right text-success" style="margin-right:8px;"></i> 로그인</td>
                            <td>방금 전</td>
                            <td><span class="badge badge-success">성공</span></td>
                        </tr>
                        <tr>
                            <td><i class="bi bi-pencil-square text-info" style="margin-right:8px;"></i> 프로필 수정</td>
                            <td>2일 전</td>
                            <td><span class="badge badge-info">완료</span></td>
                        </tr>
                        <tr>
                            <td><i class="bi bi-lock-fill text-warning" style="margin-right:8px;"></i> 비밀번호 변경</td>
                            <td>1주 전</td>
                            <td><span class="badge badge-warning">완료</span></td>
                        </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <div>
            <div class="detail-content-card">
                <h3 class="section-title">
                    <i class="bi bi-lightning-charge"></i> 빠른 메뉴
                </h3>

                <a href="<c:url value="/mypage/profile"/>" class="menu-link">
                    <div class="menu-item">
                        <i class="bi bi-person-gear"></i> 프로필 수정
                    </div>
                </a>

                <a href="<c:url value="/mypage/security"/>" class="menu-link">
                    <div class="menu-item">
                        <i class="bi bi-shield-lock"></i> 보안 설정
                    </div>
                </a>

                <a href="<c:url value="/recipient/list"/>" class="menu-link">
                    <div class="menu-item">
                        <i class="bi bi-people-fill"></i> 노약자 관리
                    </div>
                </a>
            </div>

            <div class="detail-content-card" style="background: transparent; box-shadow: none; padding: 0;">
                <div class="guide-box">
                    <h4 style="font-size: 16px; font-weight: 700; color: white; margin-bottom: 15px;">
                        <i class="bi bi-info-circle-fill"></i> 계정 안전 가이드
                    </h4>
                    <div class="guide-item">
                        <i class="bi bi-check-circle-fill"></i>
                        <span>개인정보는 안전하게 보호됩니다.</span>
                    </div>
                    <div class="guide-item">
                        <i class="bi bi-check-circle-fill"></i>
                        <span>비밀번호는 주기적으로 변경해주세요.</span>
                    </div>
                    <div class="guide-item">
                        <i class="bi bi-check-circle-fill"></i>
                        <span>의심스러운 활동 시 고객센터로 문의하세요.</span>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>