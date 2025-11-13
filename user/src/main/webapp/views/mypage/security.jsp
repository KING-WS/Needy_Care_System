<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- 보안 설정 페이지 -->
<section style="padding: 20px;">
    <div class="container-fluid">
        <div class="row">
            <div class="col-12 mb-4">
                <h1 style="font-size: 36px; font-weight: bold; color: var(--secondary-color);">
                    <i class="fas fa-lock"></i> 보안 설정
                </h1>
                <p style="font-size: 16px; color: #666; margin-top: 10px;">
                    계정의 보안을 강화하고 비밀번호를 관리할 수 있습니다.
                </p>
            </div>
            
            <div class="col-md-8 mx-auto">
                <!-- 비밀번호 변경 -->
                <div class="card mb-4" style="border: none; border-radius: 15px; box-shadow: 0 5px 15px rgba(0,0,0,0.1); padding: 30px;">
                    <h4 style="margin-bottom: 25px; color: var(--secondary-color);">
                        <i class="fas fa-key"></i> 비밀번호 변경
                    </h4>
                    <form action="<c:url value="/mypage/security/password"/>" method="post">
                        <div class="mb-3">
                            <label class="form-label" style="font-weight: 600; color: #666;">현재 비밀번호</label>
                            <input type="password" name="currentPassword" class="form-control" required
                                   style="border-radius: 8px; padding: 12px;">
                        </div>
                        <div class="mb-3">
                            <label class="form-label" style="font-weight: 600; color: #666;">새 비밀번호</label>
                            <input type="password" name="newPassword" class="form-control" required
                                   style="border-radius: 8px; padding: 12px;">
                            <small class="text-muted">8자 이상, 영문/숫자/특수문자 조합</small>
                        </div>
                        <div class="mb-4">
                            <label class="form-label" style="font-weight: 600; color: #666;">새 비밀번호 확인</label>
                            <input type="password" name="confirmPassword" class="form-control" required
                                   style="border-radius: 8px; padding: 12px;">
                        </div>
                        <button type="submit" class="btn btn-primary" style="border-radius: 20px; padding: 10px 30px; width: 100%;">
                            <i class="fas fa-check"></i> 비밀번호 변경
                        </button>
                    </form>
                </div>
                
                <!-- 2단계 인증 -->
                <div class="card mb-4" style="border: none; border-radius: 15px; box-shadow: 0 5px 15px rgba(0,0,0,0.1); padding: 30px;">
                    <h4 style="margin-bottom: 20px; color: var(--secondary-color);">
                        <i class="fas fa-shield-alt"></i> 2단계 인증
                    </h4>
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <p style="font-weight: 600; margin-bottom: 5px;">2단계 인증 활성화</p>
                            <small class="text-muted">계정 보안을 한층 더 강화합니다</small>
                        </div>
                        <div class="form-check form-switch">
                            <input class="form-check-input" type="checkbox" id="twoFactorAuth" 
                                   style="width: 50px; height: 25px; cursor: pointer;">
                        </div>
                    </div>
                </div>
                
                <!-- 로그인 활동 -->
                <div class="card mb-4" style="border: none; border-radius: 15px; box-shadow: 0 5px 15px rgba(0,0,0,0.1); padding: 30px;">
                    <h4 style="margin-bottom: 20px; color: var(--secondary-color);">
                        <i class="fas fa-history"></i> 최근 로그인 활동
                    </h4>
                    <div class="table-responsive">
                        <table class="table">
                            <thead style="background: #f8f9fa;">
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
                                    <td><span class="badge bg-success">현재 세션</span></td>
                                </tr>
                                <tr>
                                    <td>2시간 전</td>
                                    <td><i class="fas fa-mobile-alt"></i> Mobile</td>
                                    <td>서울, 한국</td>
                                    <td><span class="badge bg-secondary">완료</span></td>
                                </tr>
                                <tr>
                                    <td>1일 전</td>
                                    <td><i class="fas fa-desktop"></i> Windows PC</td>
                                    <td>서울, 한국</td>
                                    <td><span class="badge bg-secondary">완료</span></td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
                
                <!-- 계정 삭제 -->
                <div class="card" style="border: 2px solid #dc3545; border-radius: 15px; padding: 30px;">
                    <h4 style="margin-bottom: 20px; color: #dc3545;">
                        <i class="fas fa-exclamation-triangle"></i> 위험 구역
                    </h4>
                    <p style="color: #666; margin-bottom: 20px;">
                        계정을 삭제하면 모든 데이터가 영구적으로 삭제되며 복구할 수 없습니다.
                    </p>
                    <button type="button" class="btn btn-danger" style="border-radius: 20px; padding: 10px 30px;"
                            onclick="if(confirm('정말로 계정을 삭제하시겠습니까?')) alert('계정 삭제 기능은 구현 예정입니다.')">
                        <i class="fas fa-trash"></i> 계정 삭제
                    </button>
                </div>
            </div>
        </div>
    </div>
</section>

