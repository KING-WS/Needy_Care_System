<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- 마이페이지 메인 -->
<style>
    /* 컨텐츠 중앙 정렬 및 여백 조정 */
    section > .container-fluid {
        max-width: 1400px;
        margin: 0 auto;
        padding: 0 40px;
    }
    
    @media (max-width: 1200px) {
        section > .container-fluid {
            padding: 0 30px;
        }
    }
    
    @media (max-width: 768px) {
        section > .container-fluid {
            padding: 0 20px;
        }
    }
</style>

<section style="padding: 20px 0 100px 0;">
    <div class="container-fluid">
        <div class="row">
            <div class="col-12 mb-4">
                <h1 style="font-size: 36px; font-weight: bold; color: var(--secondary-color);">
                    <i class="fas fa-user-circle"></i> 마이페이지
                </h1>
                <p style="font-size: 16px; color: #666; margin-top: 10px;">
                    ${sessionScope.loginUser.custName}님의 개인정보 관리 페이지입니다.
                </p>
            </div>
            
            <!-- 사용자 정보 카드 -->
            <div class="col-md-8 mb-4">
                <div class="card" style="border: none; border-radius: 15px; box-shadow: 0 5px 15px rgba(0,0,0,0.1); padding: 30px;">
                    <h4 style="margin-bottom: 25px; color: var(--secondary-color);">
                        <i class="fas fa-id-card"></i> 기본 정보
                    </h4>
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label style="font-weight: 600; color: #666; margin-bottom: 8px;">이름</label>
                            <p style="font-size: 16px; color: var(--secondary-color); background: #f8f9fa; padding: 12px; border-radius: 8px;">
                                ${sessionScope.loginUser.custName}
                            </p>
                        </div>
                        <div class="col-md-6 mb-3">
                            <label style="font-weight: 600; color: #666; margin-bottom: 8px;">전화번호</label>
                            <p style="font-size: 16px; color: var(--secondary-color); background: #f8f9fa; padding: 12px; border-radius: 8px;">
                                ${sessionScope.loginUser.custPhone}
                            </p>
                        </div>
                        <div class="col-12 mb-3">
                            <label style="font-weight: 600; color: #666; margin-bottom: 8px;">이메일</label>
                            <p style="font-size: 16px; color: var(--secondary-color); background: #f8f9fa; padding: 12px; border-radius: 8px;">
                                ${sessionScope.loginUser.custEmail}
                            </p>
                        </div>
                        <div class="col-12 mb-3">
                            <label style="font-weight: 600; color: #666; margin-bottom: 8px;">가입일</label>
                            <p style="font-size: 16px; color: var(--secondary-color); background: #f8f9fa; padding: 12px; border-radius: 8px;">
                                ${sessionScope.loginUser.custRegdate}
                            </p>
                        </div>
                    </div>
                    <div style="text-align: right; margin-top: 20px;">
                        <a href="<c:url value="/mypage/profile"/>" class="btn btn-primary" style="border-radius: 20px; padding: 10px 30px;">
                            <i class="fas fa-edit"></i> 프로필 수정
                        </a>
                    </div>
                </div>
            </div>
            
            <!-- 빠른 메뉴 -->
            <div class="col-md-4 mb-4">
                <div class="card" style="border: none; border-radius: 15px; box-shadow: 0 5px 15px rgba(0,0,0,0.1); padding: 20px; margin-bottom: 20px;">
                    <h5 style="margin-bottom: 20px; color: var(--secondary-color);">
                        <i class="fas fa-bolt"></i> 빠른 메뉴
                    </h5>
                    <ul style="list-style: none; padding: 0; margin: 0;">
                        <li style="margin-bottom: 12px;">
                            <a href="<c:url value="/mypage/profile"/>" style="text-decoration: none; color: var(--secondary-color); display: flex; align-items: center; padding: 10px; border-radius: 8px; transition: all 0.3s;">
                                <i class="fas fa-user-edit" style="margin-right: 10px; color: var(--primary-color);"></i>
                                프로필 수정
                            </a>
                        </li>
                        <li style="margin-bottom: 12px;">
                            <a href="<c:url value="/mypage/security"/>" style="text-decoration: none; color: var(--secondary-color); display: flex; align-items: center; padding: 10px; border-radius: 8px; transition: all 0.3s;">
                                <i class="fas fa-lock" style="margin-right: 10px; color: var(--primary-color);"></i>
                                보안 설정
                            </a>
                        </li>
                        <li style="margin-bottom: 12px;">
                            <a href="<c:url value="/mypage/settings"/>" style="text-decoration: none; color: var(--secondary-color); display: flex; align-items: center; padding: 10px; border-radius: 8px; transition: all 0.3s;">
                                <i class="fas fa-cog" style="margin-right: 10px; color: var(--primary-color);"></i>
                                환경 설정
                            </a>
                        </li>
                    </ul>
                </div>
                
                <div class="card" style="border: none; border-radius: 15px; box-shadow: 0 5px 15px rgba(0,0,0,0.1); padding: 20px; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white;">
                    <h6 style="margin-bottom: 15px;">
                        <i class="fas fa-info-circle"></i> 계정 안내
                    </h6>
                    <ul style="font-size: 14px; padding-left: 20px; margin: 0;">
                        <li style="margin-bottom: 8px;">개인정보는 안전하게 보호됩니다</li>
                        <li style="margin-bottom: 8px;">비밀번호는 정기적으로 변경해주세요</li>
                        <li style="margin-bottom: 8px;">의심스러운 활동 발견 시 즉시 신고</li>
                    </ul>
                </div>
            </div>
            
            <!-- 최근 활동 -->
            <div class="col-12">
                <div class="card" style="border: none; border-radius: 15px; box-shadow: 0 5px 15px rgba(0,0,0,0.1); padding: 30px;">
                    <h4 style="margin-bottom: 20px; color: var(--secondary-color);">
                        <i class="fas fa-history"></i> 최근 활동
                    </h4>
                    <div class="table-responsive">
                        <table class="table" style="margin-bottom: 0;">
                            <thead style="background: #f8f9fa;">
                                <tr>
                                    <th>활동 내역</th>
                                    <th>일시</th>
                                    <th>상태</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td><i class="fas fa-sign-in-alt text-success"></i> 로그인</td>
                                    <td>방금 전</td>
                                    <td><span class="badge bg-success">성공</span></td>
                                </tr>
                                <tr>
                                    <td><i class="fas fa-edit text-info"></i> 프로필 수정</td>
                                    <td>2일 전</td>
                                    <td><span class="badge bg-info">완료</span></td>
                                </tr>
                                <tr>
                                    <td><i class="fas fa-lock text-warning"></i> 비밀번호 변경</td>
                                    <td>1주 전</td>
                                    <td><span class="badge bg-warning">완료</span></td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>
</section>

<style>
    a:hover {
        background: #f0f0f0 !important;
    }
</style>

