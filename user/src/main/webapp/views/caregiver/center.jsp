    <%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>요양사 정보</title>
    <!-- Bootstrap CSS 링크 (예시, 실제 프로젝트에 맞게 경로 수정 필요) -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            font-family: 'Malgun Gothic', sans-serif;
            background-color: #f8f9fa;
        }
        .container {
            max-width: 800px;
            margin-top: 50px;
            padding: 30px;
            background-color: #ffffff;
            border-radius: 8px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        }
        h2 {
            color: #343a40;
            margin-bottom: 30px;
            text-align: center;
        }
        .info-item {
            margin-bottom: 15px;
        }
        .info-item label {
            font-weight: bold;
            color: #495057;
            display: block;
            margin-bottom: 5px;
        }
        .info-item span {
            color: #6c757d;
        }
        .profile-img {
            width: 120px;
            height: 120px;
            border-radius: 50%;
            object-fit: cover;
            margin-bottom: 20px;
            border: 3px solid #007bff;
            display: block;
            margin-left: auto;
            margin-right: auto;
        }
    </style>
</head>
<body>
    <div class="container">
        <h2>담당 요양사 정보</h2>
        <div class="text-center">
            <img src="https://via.placeholder.com/120?text=요양사" alt="요양사 프로필 사진" class="profile-img">
        </div>
        
        <div class="info-item">
            <label>이름:</label>
            <span id="caregiverName">김철수</span>
        </div>
        <div class="info-item">
            <label>연락처:</label>
            <span id="caregiverContact">010-1234-5678</span>
        </div>
        <div class="info-item">
            <label>배정된 피보호자:</label>
            <span id="assignedRecipient">이영희 어르신</span>
        </div>
        <div class="info-item">
            <label>주요 업무:</label>
            <span id="mainTasks">식사 보조, 투약 관리, 산책 동행</span>
        </div>
        <div class="info-item">
            <label>특이사항:</label>
            <span id="specialNotes">경력 5년, 친절하고 꼼꼼함.</span>
        </div>
        
        <!-- 추후 동적 데이터 로드를 위한 스크립트 추가 가능 -->
        <script>
            // 여기에 요양사 정보를 동적으로 로드하는 JavaScript 코드를 추가할 수 있습니다.
            // 예: AJAX 호출로 서버에서 데이터 가져오기
            document.addEventListener('DOMContentLoaded', function() {
                console.log('요양사 정보 페이지 로드됨');
                // 실제 데이터를 가져오는 로직 (예시)
                /*
                fetch('/api/caregiver/assigned')
                    .then(response => response.json())
                    .then(data => {
                        document.getElementById('caregiverName').textContent = data.name;
                        document.getElementById('caregiverContact').textContent = data.contact;
                        document.getElementById('assignedRecipient').textContent = data.recipient;
                        document.getElementById('mainTasks').textContent = data.tasks;
                        document.getElementById('specialNotes').textContent = data.notes;
                        // 프로필 이미지 등 다른 정보도 업데이트
                    })
                    .catch(error => console.error('Error fetching caregiver info:', error));
                */
            });
        </script>
    </div>

    <!-- Bootstrap JS 번들 (예시, 실제 프로젝트에 맞게 경로 수정 필요) -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
