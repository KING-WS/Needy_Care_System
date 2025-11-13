<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- 채팅 페이지 -->
<section style="padding: 20px;">
    <div class="container-fluid">
        <div class="row">
            <div class="col-12 mb-4">
                <h1 style="font-size: 36px; font-weight: bold; color: var(--secondary-color);">
                    <i class="fas fa-comment-dots"></i> 실시간 채팅
                </h1>
                <p style="font-size: 16px; color: #666; margin-top: 10px;">
                    담당자와 실시간으로 대화할 수 있습니다.
                </p>
            </div>
            
            <div class="col-12">
                <div class="card" style="border: none; border-radius: 15px; box-shadow: 0 5px 15px rgba(0,0,0,0.1); height: 600px;">
                    <div class="card-header" style="background: linear-gradient(135deg, #3498db 0%, #2c3e50 100%); color: white; border-radius: 15px 15px 0 0; padding: 20px;">
                        <h5 style="margin: 0;"><i class="fas fa-user-circle"></i> 채팅방</h5>
                    </div>
                    <div class="card-body" id="chat-messages" style="overflow-y: auto; height: 450px; background: #f8f9fa;">
                        <div style="text-align: center; padding: 50px; color: #999;">
                            <i class="fas fa-comments" style="font-size: 60px; margin-bottom: 20px;"></i>
                            <p>채팅을 시작해보세요!</p>
                        </div>
                    </div>
                    <div class="card-footer" style="background: white; border-radius: 0 0 15px 15px; padding: 20px;">
                        <div class="input-group">
                            <input type="text" class="form-control" placeholder="메시지를 입력하세요..." style="border-radius: 20px 0 0 20px; padding: 15px;">
                            <div class="input-group-append">
                                <button class="btn btn-primary" type="button" style="border-radius: 0 20px 20px 0; padding: 10px 30px;">
                                    <i class="fas fa-paper-plane"></i> 전송
                                </button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</section>

