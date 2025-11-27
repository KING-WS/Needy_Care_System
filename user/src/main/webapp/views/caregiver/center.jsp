<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<style>
    .caregiver-section {
        padding: 20px 0 100px 0;
        background: #FFFFFF;
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
        font-size: 14px;
        text-align: center;
        padding: 10px;
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
        <div class="caregiver-card">
            <div class="caregiver-header">
                <h2>
                    <i class="fas fa-user-nurse"></i> 담당 요양사 정보
                </h2>
            </div>
            
            <div class="profile-section">
                <div class="profile-img-container" id="profileImgContainer">
                    <div class="profile-placeholder">
                        요양사<br>프로필 사진
                    </div>
                </div>
            </div>
            
            <div class="info-section">
                <div class="info-item">
                    <label><i class="fas fa-user"></i> 이름</label>
                    <span id="caregiverName">김철수</span>
                </div>
                
                <div class="info-item">
                    <label><i class="fas fa-phone"></i> 연락처</label>
                    <span id="caregiverContact">010-1234-5678</span>
                </div>
                
                <div class="info-item">
                    <label><i class="fas fa-users"></i> 배정된 피보호자</label>
                    <span id="assignedRecipient">이영희 어르신</span>
                </div>
                
                <div class="info-item">
                    <label><i class="fas fa-tasks"></i> 주요 업무</label>
                    <span id="mainTasks">식사 보조, 투약 관리, 산책 동행</span>
                </div>
                
                <div class="info-item" style="grid-column: 1 / -1;">
                    <label><i class="fas fa-sticky-note"></i> 특이사항</label>
                    <span id="specialNotes">경력 5년, 친절하고 꼼꼼함.</span>
                </div>
            </div>
        </div>
    </div>
</section>

<script>
    // 요양사 정보를 동적으로 로드하는 함수
    function loadCaregiverInfo() {
        // 추후 API 호출로 실제 데이터를 가져올 수 있습니다
        /*
        fetch('/api/caregiver/assigned')
            .then(response => response.json())
            .then(data => {
                if (data.success && data.caregiver) {
                    document.getElementById('caregiverName').textContent = data.caregiver.name || '정보 없음';
                    document.getElementById('caregiverContact').textContent = data.caregiver.contact || '정보 없음';
                    document.getElementById('assignedRecipient').textContent = data.caregiver.recipient || '정보 없음';
                    document.getElementById('mainTasks').textContent = data.caregiver.tasks || '정보 없음';
                    document.getElementById('specialNotes').textContent = data.caregiver.notes || '정보 없음';
                    
                    // 프로필 이미지 업데이트
                    if (data.caregiver.profileImage) {
                        const imgContainer = document.getElementById('profileImgContainer');
                        imgContainer.innerHTML = '<img src="' + data.caregiver.profileImage + '" alt="요양사 프로필 사진" class="profile-img">';
                    }
                }
            })
            .catch(error => {
                console.error('Error fetching caregiver info:', error);
            });
        */
    }
    
    // 페이지 로드 시 실행
    document.addEventListener('DOMContentLoaded', function() {
        console.log('요양사 정보 페이지 로드됨');
        loadCaregiverInfo();
    });
</script>
