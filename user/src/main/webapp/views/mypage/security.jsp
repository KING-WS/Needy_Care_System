<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<style>
    /* ---------------------------------------------------- */
    /* 1. 디자인 시스템 (공통 변수 재정의) */
    /* ---------------------------------------------------- */
    :root {
        --primary-color: #3498db;      /* 통일된 주 색상 */
        --secondary-color: #343a40;    /* 진한 회색 텍스트 */
        --secondary-bg: #F0F8FF;       /* 연한 배경색 (입력창 등) */
        --card-bg: white;
        --danger-color: #e74c3c;
    }

    body {
        background-color: #f8f9fa; /* 전체 배경색 유지 */
        font-family: 'Noto Sans KR', sans-serif;
    }

    /* ---------------------------------------------------- */
    /* 2. 레이아웃 및 컨테이너 */
    /* ---------------------------------------------------- */
    .security-container {
        max-width: 800px;
        margin: 0 auto;
        padding: 40px 20px 100px 20px;
    }

    .page-header {
        text-align: center;
        margin-bottom: 40px;
    }

    .page-title {
        font-size: 38px;
        font-weight: 800;
        color: var(--secondary-color);
        margin-bottom: 10px;
        text-shadow: 0 1px 2px rgba(0, 0, 0, 0.05);
    }

    .page-title i {
        color: var(--primary-color);
        margin-right: 10px;
    }

    /* ---------------------------------------------------- */
    /* 3. 섹션 카드 스타일 (detail.jsp / edit.jsp 공통) */
    /* ---------------------------------------------------- */
    .section-card {
        background: var(--card-bg);
        border-radius: 20px;
        padding: 30px;
        box-shadow: 0 10px 30px rgba(0,0,0,0.05);
        margin-bottom: 30px;
    }

    .section-title {
        font-size: 20px;
        font-weight: 700;
        color: var(--secondary-color);
        margin-bottom: 25px;
        padding-bottom: 10px;
        border-bottom: 2px solid #f0f0f0;
        display: flex;
        align-items: center;
        gap: 10px;
    }

    .section-title i {
        color: var(--primary-color);
        font-size: 22px;
    }

    /* 위험 구역 카드 */
    .danger-card {
        border: 2px solid var(--danger-color);
        border-radius: 20px;
        padding: 30px;
        background: #fffafa; /* 연한 위험색 배경 */
        box-shadow: 0 5px 15px rgba(231, 76, 60, 0.1);
    }

    .danger-card .section-title {
        color: var(--danger-color);
        border-bottom-color: #fcebeb;
    }

    .danger-card .section-title i {
        color: var(--danger-color);
    }

    /* ---------------------------------------------------- */
    /* 4. 폼 및 입력 필드 스타일 */
    /* ---------------------------------------------------- */
    .form-group {
        margin-bottom: 20px;
    }

    .form-label {
        display: block;
        font-size: 14px;
        font-weight: 700;
        color: var(--secondary-color);
        margin-bottom: 8px;
    }

    .form-control {
        width: 100%;
        padding: 12px 15px;
        background: var(--secondary-bg);
        border: 1px solid transparent;
        border-radius: 12px;
        font-size: 15px;
        transition: all 0.3s ease;
        color: var(--secondary-color);
    }

    .form-control:focus {
        outline: none;
        background: white;
        border-color: var(--primary-color);
        box-shadow: 0 0 0 3px rgba(52, 152, 219, 0.1);
    }

    /* ---------------------------------------------------- */
    /* 5. 버튼 스타일 */
    /* ---------------------------------------------------- */
    .btn-action {
        padding: 12px 30px;
        border: none;
        border-radius: 50px;
        font-size: 15px;
        font-weight: 700;
        cursor: pointer;
        transition: all 0.3s ease;
        display: inline-flex;
        align-items: center;
        gap: 8px;
        text-decoration: none;
    }

    .btn-primary {
        background: var(--primary-color);
        color: white;
        box-shadow: none;
    }

    .btn-primary:hover {
        background: #2980b9;
        transform: translateY(-2px);
        box-shadow: none;
    }

    .btn-danger-wide {
        width: 100%;
        background: var(--danger-color);
        color: white;
        box-shadow: none;
    }

    .btn-danger-wide:hover {
        background: #c0392b;
        transform: translateY(-2px);
        box-shadow: none;
    }

    /* ---------------------------------------------------- */
    /* 6. 로그인 활동 테이블 */
    /* ---------------------------------------------------- */
    .activity-table {
        width: 100%;
        border-collapse: separate;
        border-spacing: 0;
    }

    .activity-table thead {
        background: var(--secondary-bg);
    }

    .activity-table th {
        text-align: left;
        padding: 15px;
        font-size: 14px;
        color: #7f8c8d;
        font-weight: 600;
        border-bottom: 2px solid #f0f0f0;
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
    .badge-secondary { background: #e9ecef; color: #495057; }
</style>

<div class="security-container">
    <div class="page-header">
        <h1 class="page-title">
            <i class="fas fa-lock"></i> 보안 설정
        </h1>
        <p style="font-size: 16px; color: #7f8c8d; margin-top: 10px;">
            계정의 보안을 강화하고 비밀번호를 관리할 수 있습니다.
        </p>
    </div>

    <div class="row">
        <div class="col-12">
            <div class="section-card">
                <h4 class="section-title">
                    <i class="fas fa-key"></i> 비밀번호 변경
                </h4>
                <form action="<c:url value="/mypage/security/password"/>" method="post">
                    <div class="form-group">
                        <label class="form-label">현재 비밀번호</label>
                        <input type="password" name="currentPassword" class="form-control" required>
                    </div>
                    <div class="form-group">
                        <label class="form-label">새 비밀번호</label>
                        <input type="password" name="newPassword" class="form-control" required>
                        <small class="text-muted">8자 이상, 영문/숫자/특수문자 조합</small>
                    </div>
                    <div class="form-group">
                        <label class="form-label">새 비밀번호 확인</label>
                        <input type="password" name="confirmPassword" class="form-control" required>
                    </div>
                    <button type="submit" class="btn-action btn-primary" style="width: 100%; margin-top: 15px;">
                        <i class="fas fa-check"></i> 비밀번호 변경
                    </button>
                </form>
            </div>


            <div class="section-card">
                <h4 class="section-title">
                    <i class="fas fa-history"></i> 최근 로그인 활동
                </h4>
                <div class="table-responsive">
                    <table class="activity-table">
                        <thead>
                        <tr>
                            <th>일시</th>
                            <th>기기</th>
                            <th>위치</th>
                            <th>상태</th>
                        </tr>
                        </thead>
                        <tbody>
                        <tr>
                            <td>방금 전</td>
                            <td><i class="fas fa-desktop"></i> Windows PC</td>
                            <td>서울, 한국</td>
                            <td><span class="badge badge-success">현재 세션</span></td>
                        </tr>
                        <tr>
                            <td>2시간 전</td>
                            <td><i class="fas fa-mobile-alt"></i> Mobile</td>
                            <td>서울, 한국</td>
                            <td><span class="badge badge-secondary">완료</span></td>
                        </tr>
                        <tr>
                            <td>1일 전</td>
                            <td><i class="fas fa-desktop"></i> Windows PC</td>
                            <td>서울, 한국</td>
                            <td><span class="badge badge-secondary">완료</span></td>
                        </tr>
                        </tbody>
                    </table>
                </div>
            </div>

            <div class="danger-card">
                <h4 class="section-title">
                    <i class="fas fa-exclamation-triangle"></i> 위험 구역
                </h4>
                <p style="color: #666; margin-bottom: 20px;">
                    계정을 삭제하면 모든 데이터가 영구적으로 삭제되며 복구할 수 없습니다.
                </p>
                <button type="button" class="btn-action btn-danger-wide"
                        onclick="if(confirm('정말로 계정을 삭제하시겠습니까?')) alert('계정 삭제 기능은 구현 예정입니다.')">
                    <i class="fas fa-trash"></i> 계정 삭제
                </button>
            </div>
        </div>
    </div>
</div>