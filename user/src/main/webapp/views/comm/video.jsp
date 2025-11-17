<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- 화상통화 페이지 -->
<section style="padding: 20px;">
    <div class="container-fluid">
        <div class="row">
            <div class="col-12 mb-4">
                <h1 style="font-size: 36px; font-weight: bold; color: var(--secondary-color);">
                    <i class="fas fa-video"></i> 화상통화
                </h1>
                <p style="font-size: 16px; color: #666; margin-top: 10px;">
                    담당자와 화상으로 대면 상담할 수 있습니다.
                </p>
            </div>
            
            <div class="col-md-8">
                <div class="card" style="border: none; border-radius: 15px; box-shadow: 0 5px 15px rgba(0,0,0,0.1); height: 500px;">
                    <div class="card-body" style="background: #000; border-radius: 15px; display: flex; align-items: center; justify-content: center;">
                        <div style="text-align: center; color: white;">
                            <i class="fas fa-video-slash" style="font-size: 80px; margin-bottom: 20px; opacity: 0.5;"></i>
                            <p style="font-size: 18px; opacity: 0.7;">화상통화가 연결되지 않았습니다</p>
                            <button class="btn btn-success btn-lg mt-3" style="border-radius: 20px; padding: 15px 40px;">
                                <i class="fas fa-phone"></i> 통화 시작
                            </button>
                        </div>
                    </div>
                </div>
            </div>
            
            <div class="col-md-4">
                <div class="card" style="border: none; border-radius: 15px; box-shadow: 0 5px 15px rgba(0,0,0,0.1); margin-bottom: 20px;">
                    <div class="card-body">
                        <h5 style="margin-bottom: 20px;"><i class="fas fa-cog"></i> 통화 설정</h5>
                        <div class="form-group mb-3">
                            <label><i class="fas fa-microphone"></i> 마이크</label>
                            <select class="form-control">
                                <option>기본 마이크</option>
                            </select>
                        </div>
                        <div class="form-group mb-3">
                            <label><i class="fas fa-camera"></i> 카메라</label>
                            <select class="form-control">
                                <option>기본 카메라</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label><i class="fas fa-volume-up"></i> 스피커</label>
                            <select class="form-control">
                                <option>기본 스피커</option>
                            </select>
                        </div>
                    </div>
                </div>
                
                <div class="card" style="border: none; border-radius: 15px; box-shadow: 0 5px 15px rgba(0,0,0,0.1); background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%); color: white;">
                    <div class="card-body">
                        <h6><i class="fas fa-info-circle"></i> 이용 안내</h6>
                        <ul style="font-size: 14px; padding-left: 20px;">
                            <li>안정적인 인터넷 환경에서 이용하세요</li>
                            <li>카메라와 마이크 권한을 허용해주세요</li>
                            <li>통화 내용은 보안을 위해 암호화됩니다</li>
                        </ul>
                    </div>
                </div>
            </div>
        </div>
    </div>
</section>

