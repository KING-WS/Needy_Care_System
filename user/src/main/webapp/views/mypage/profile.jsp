<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- 프로필 수정 페이지 -->
<section style="padding: 20px;">
    <div class="container-fluid">
        <div class="row">
            <div class="col-12 mb-4">
                <h1 style="font-size: 36px; font-weight: bold; color: var(--secondary-color);">
                    <i class="fas fa-user-edit"></i> 프로필 수정
                </h1>
                <p style="font-size: 16px; color: #666; margin-top: 10px;">
                    회원님의 프로필 정보를 수정할 수 있습니다.
                </p>
            </div>
            
            <div class="col-md-8 mx-auto">
                <div class="card" style="border: none; border-radius: 15px; box-shadow: 0 5px 15px rgba(0,0,0,0.1); padding: 40px;">
                    <form action="<c:url value="/mypage/profile"/>" method="post">
                        <!-- 프로필 이미지 -->
                        <div class="text-center mb-4">
                            <div style="position: relative; display: inline-block;">
                                <i class="fas fa-user-circle" style="font-size: 120px; color: var(--primary-color);"></i>
                                <button type="button" class="btn btn-sm btn-primary" style="position: absolute; bottom: 0; right: 0; border-radius: 50%; width: 40px; height: 40px;">
                                    <i class="fas fa-camera"></i>
                                </button>
                            </div>
                        </div>
                        
                        <!-- 아이디 (수정 불가) -->
                        <div class="mb-4">
                            <label class="form-label" style="font-weight: 600; color: #666;">
                                <i class="fas fa-id-badge"></i> 아이디
                            </label>
                            <input type="text" class="form-control" value="${sessionScope.loginUser.custId}" 
                                   disabled style="background: #f8f9fa; border-radius: 8px; padding: 12px;">
                            <small class="text-muted">아이디는 변경할 수 없습니다.</small>
                        </div>
                        
                        <!-- 이름 -->
                        <div class="mb-4">
                            <label class="form-label" style="font-weight: 600; color: #666;">
                                <i class="fas fa-user"></i> 이름
                            </label>
                            <input type="text" name="custName" class="form-control" 
                                   value="${sessionScope.loginUser.custName}" 
                                   style="border-radius: 8px; padding: 12px;">
                        </div>
                        
                        <!-- 이메일 -->
                        <div class="mb-4">
                            <label class="form-label" style="font-weight: 600; color: #666;">
                                <i class="fas fa-envelope"></i> 이메일
                            </label>
                            <input type="email" name="email" class="form-control" 
                                   value="${sessionScope.loginUser.custId}@example.com" 
                                   style="border-radius: 8px; padding: 12px;">
                        </div>
                        
                        <!-- 전화번호 -->
                        <div class="mb-4">
                            <label class="form-label" style="font-weight: 600; color: #666;">
                                <i class="fas fa-phone"></i> 전화번호
                            </label>
                            <input type="tel" name="phone" class="form-control" 
                                   placeholder="010-0000-0000" 
                                   style="border-radius: 8px; padding: 12px;">
                        </div>
                        
                        <!-- 주소 -->
                        <div class="mb-4">
                            <label class="form-label" style="font-weight: 600; color: #666;">
                                <i class="fas fa-map-marker-alt"></i> 주소
                            </label>
                            <input type="text" name="address" class="form-control mb-2" 
                                   placeholder="주소를 입력하세요" 
                                   style="border-radius: 8px; padding: 12px;">
                            <input type="text" name="addressDetail" class="form-control" 
                                   placeholder="상세주소를 입력하세요" 
                                   style="border-radius: 8px; padding: 12px;">
                        </div>
                        
                        <!-- 자기소개 -->
                        <div class="mb-4">
                            <label class="form-label" style="font-weight: 600; color: #666;">
                                <i class="fas fa-comment-alt"></i> 자기소개
                            </label>
                            <textarea name="bio" class="form-control" rows="4" 
                                      placeholder="간단한 자기소개를 입력하세요" 
                                      style="border-radius: 8px; padding: 12px;"></textarea>
                        </div>
                        
                        <!-- 버튼 -->
                        <div class="d-flex justify-content-between mt-4">
                            <a href="<c:url value="/mypage"/>" class="btn btn-secondary" style="border-radius: 20px; padding: 12px 30px;">
                                <i class="fas fa-times"></i> 취소
                            </a>
                            <button type="submit" class="btn btn-primary" style="border-radius: 20px; padding: 12px 30px;">
                                <i class="fas fa-save"></i> 저장하기
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</section>

