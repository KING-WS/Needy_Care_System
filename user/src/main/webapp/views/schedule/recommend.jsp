<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<style>
    /* =========================================
       1. 모달 겹침 방지 및 z-index 설정
       ========================================= */
    .modal {
        z-index: 10055 !important; /* 헤더보다 위로 */
    }
    .modal-backdrop {
        z-index: 10050 !important;
    }

    /* =========================================
       2. AI 추천 카드 스타일 (메인 화면)
       ========================================= */
    .recommend-card {
        transition: transform 0.3s ease-in-out, box-shadow 0.3s ease-in-out;
        height: 100%;
        border: none;
        border-radius: 15px;
        overflow: hidden;
        box-shadow: 0 4px 15px rgba(0,0,0,0.05);
    }
    .recommend-card:hover {
        transform: translateY(-5px);
        box-shadow: 0 15px 30px rgba(0,0,0,0.1);
    }
    .card-header-custom {
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        color: white;
        padding: 15px;
        border-bottom: none;
    }
    .badge-category {
        background-color: rgba(255,255,255,0.2);
        padding: 5px 10px;
        border-radius: 20px;
        font-size: 0.8rem;
    }
    /* 💡 수정/유지된 스타일: 길찾기 버튼 스타일 */
    .btn-map {
        background-color: #fee500;
        color: #191919;
        border: none;
        font-weight: 600;
        font-size: 0.9rem; /* 폰트 크기 CSS로 통합 */
        padding: 8px 15px; /* 버튼 패딩 조정 */
    }
    .btn-map:hover {
        background-color: #fdd835;
    }
    /* 💡 추가된 스타일: 검색 버튼 스타일 */
    .btn-outline-secondary {
        border: 1px solid #ced4da;
        color: #6c757d;
        font-weight: 600;
        font-size: 0.9rem; /* 폰트 크기 CSS로 통합 */
        padding: 8px 15px; /* 버튼 패딩 조정 */
        min-width: 0; /* flex 컨테이너에서 최소 너비 확보 */
    }
    .btn-outline-secondary:hover {
        background-color: #e9ecef;
        color: #495057;
    }

    .summary-content {
        display: none;
        background-color: #f8f9fa;
        padding: 15px;
        border-radius: 10px;
        margin-top: 15px;
        font-size: 0.95rem;
        line-height: 1.6;
        border-left: 4px solid #667eea;
    }

    /* =========================================
       3. 모달 커스텀 디자인 (깔끔한 스타일)
       ========================================= */

    /* 모달 컨텐츠 둥글게 */
    #addScheduleModal .modal-content {
        border-radius: 20px;
        border: none;
        box-shadow: 0 10px 30px rgba(0,0,0,0.1);
    }

    /* 헤더: 흰색 배경 */
    #addScheduleModal .modal-header {
        background: #fff;
        border-bottom: none;
        padding: 25px 25px 10px 25px;
    }

    #addScheduleModal .modal-title {
        font-weight: 800;
        color: #333;
        font-size: 1.4rem;
        display: flex;
        align-items: center;
        gap: 10px;
    }

    /* 제목 아이콘 */
    .title-icon {
        color: #667eea;
        font-size: 1.6rem;
    }

    /* 닫기 버튼 */
    .btn-close-custom {
        background-color: #f1f3f5;
        border-radius: 50%;
        padding: 10px;
        opacity: 0.8;
        transition: all 0.3s ease;
        transform: rotate(0deg); /* 애니메이션을 위한 초기 상태 */
    }
    .btn-close-custom:hover {
        opacity: 1;
        background-color: #e9ecef;
        transform: rotate(90deg); /* 마우스 올리면 90도 회전 */
    }
    .btn-close-custom:active {
        transform: rotate(90deg) scale(0.9); /* 클릭 시 살짝 작아지는 효과 */
        background-color: #dee2e6;
    }

    /* 폼 라벨 및 입력창 */
    .form-label-custom {
        font-weight: 700;
        color: #495057;
        font-size: 0.95rem;
        margin-bottom: 8px;
        display: flex;
        align-items: center;
        gap: 8px;
    }

    .form-label-icon {
        color: #667eea;
    }

    .form-control-custom {
        border: 1px solid #e9ecef;
        border-radius: 12px;
        padding: 12px 15px;
        font-size: 0.95rem;
        background-color: #fff;
        transition: border-color 0.2s;
    }

    .form-control-custom:focus {
        border-color: #667eea;
        box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
    }

    .form-control-custom[readonly] {
        background-color: #f8f9fa;
        color: #666;
    }

    .required-star {
        color: #ff6b6b;
        margin-left: 2px;
    }

    /* 푸터 버튼 */
    #addScheduleModal .modal-footer {
        border-top: none;
        background: #fff;
        padding: 10px 25px 25px 25px;
    }

    .btn-modal-cancel {
        background-color: #f1f3f5;
        color: #495057;
        border: none;
        border-radius: 10px;
        padding: 10px 20px;
        font-weight: 600;
    }

    .btn-modal-save {
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        color: white;
        border: none;
        border-radius: 10px;
        padding: 10px 30px;
        font-weight: 600;
        box-shadow: 0 4px 10px rgba(102, 126, 234, 0.3);
    }
    .btn-modal-save:hover {
        transform: translateY(-2px);
        box-shadow: 0 6px 15px rgba(102, 126, 234, 0.4);
    }

    /* AI 정보 박스 */
    .ai-info-box {
        background-color: #f3f0ff;
        border-radius: 15px;
        padding: 20px;
        margin-bottom: 25px;
        border: 1px solid #e0d4fc;
    }
    .ai-info-title {
        color: #667eea;
        font-weight: 700;
        margin-bottom: 10px;
        display: flex;
        align-items: center;
        gap: 8px;
    }
</style>

<section style="padding: 20px 0 100px 0; background: #FFFFFF; min-height: calc(100vh - 200px);">
    <div class="container-fluid" style="max-width: 1400px; margin: 0 auto;">

        <div class="row">
            <div class="col-12 mb-4">
                <h1 style="font-size: 36px; font-weight: bold; color: var(--secondary-color);">
                    <i class="fas fa-robot"></i> AI 장소 추천
                </h1>
            </div>
        </div>

        <div class="row mb-4 justify-content-center">
            <div class="col-lg-12">
                <div class="card shadow-sm border-0" style="background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);">
                    <div class="card-body">
                        <h3 style="color: #333; font-size: 22px; font-weight: 600; margin-bottom: 20px; display: flex; align-items: center; gap: 10px;">
                            <i class="fas fa-info-circle text-primary"></i> AI 장소 추천 사용 가이드
                        </h3>
                        <ul style="list-style: none; padding: 0; margin: 0;">
                            <li style="display: flex; align-items: start; gap: 15px; margin-bottom: 15px;">
                                <div style="font-size: 20px; min-width: 30px; text-align: center; color: #667eea;"><i class="fas fa-user-check"></i></div>
                                <div>
                                    <strong style="display: block; margin-bottom: 5px; font-size: 16px;">1. 대상자 확인</strong>
                                    <span style="font-size: 14px; color: #555;">현재 선택된 <strong>${selectedRecipient.recName}</strong> 님의 건강 상태와 선호도에 따라 맞춤형 장소가 추천됩니다. (대상자 변경은 홈 화면에서 가능)</span>
                                </div>
                            </li>
                            <li style="display: flex; align-items: start; gap: 15px; margin-bottom: 15px;">
                                <div style="font-size: 20px; min-width: 30px; text-align: center; color: #667eea;"><i class="fas fa-magic"></i></div>
                                <div>
                                    <strong style="display: block; margin-bottom: 5px; font-size: 16px;">2. 추천 시작</strong>
                                    <span style="font-size: 14px; color: #555;">'노약자 맞춤 추천 시작' 버튼을 클릭하면 AI가 분석을 시작합니다. 잠시만 기다려주세요.</span>
                                </div>
                            </li>
                            <li style="display: flex; align-items: start; gap: 15px;">
                                <div style="font-size: 20px; min-width: 30px; text-align: center; color: #667eea;"><i class="fas fa-calendar-plus"></i></div>
                                <div>
                                    <strong style="display: block; margin-bottom: 5px; font-size: 16px;">3. 결과 확인 및 저장</strong>
                                    <span style="font-size: 14px; color: #555;">추천된 장소의 'AI 요약 보기'로 상세 정보를 확인하고, '추가' 버튼을 눌러 간편하게 일정과 지도에 저장할 수 있습니다.</span>
                                </div>
                            </li>
                        </ul>
                    </div>
                </div>
            </div>
        </div>

        <div class="row mb-5">
            <div class="col-12 text-center">
                <button id="recommendBtn" class="btn btn-lg btn-primary shadow" style="font-size: 1.2rem; padding: 15px 50px; border-radius: 50px; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); border: none;">
                    <i class="fas fa-magic me-2"></i> 노약자 맞춤 추천 시작
                </button>
            </div>
        </div>

        <div id="loadingSpinner" class="text-center my-5" style="display: none;">
            <div class="spinner-border text-primary" role="status" style="width: 3rem; height: 3rem;">
                <span class="visually-hidden">Loading...</span>
            </div>
            <h5 class="mt-3 fw-bold text-secondary">AI가 대상자의 건강 상태를 분석하고 있습니다...</h5>
            <p class="text-muted">장소를 찾고 있으니 잠시만 기다려주세요.</p>
        </div>

        <div id="recommendation-results" class="row g-4">
        </div>
    </div>
</section>

<div class="modal fade" id="addScheduleModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered modal-dialog-scrollable">
        <div class="modal-content">

            <div class="modal-header">
                <h5 class="modal-title">
                    <i class="fas fa-plus-circle title-icon"></i> 일정 추가
                </h5>
                <button type="button" class="btn-close btn-close-custom" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>

            <div class="modal-body">
                <form id="saveRecommendForm">

                    <div class="ai-info-box">
                        <div class="ai-info-title">
                            <i class="fas fa-robot"></i> AI 추천 정보
                        </div>
                        <div class="mb-2">
                            <span class="badge bg-primary bg-opacity-10 text-primary px-3 py-2 rounded-pill" id="displayMapCategory" style="font-weight: 600; margin-right: 5px;"></span>
                            <strong id="displayMapName" style="font-size: 1.1rem; color: #333;"></strong>
                        </div>
                        <div class="p-3 bg-white rounded-3 border border-light text-secondary small" style="line-height: 1.6;">
                            <span id="displayMapContent"></span>
                        </div>
                    </div>

                    <input type="hidden" id="modalMapName">
                    <input type="hidden" id="modalMapContent">
                    <input type="hidden" id="modalMapCategory">

                    <div class="mb-4">
                        <label for="schedDate" class="form-label-custom">
                            <i class="fas fa-calendar-alt form-label-icon"></i> 날짜 <span class="required-star">*</span>
                        </label>
                        <input type="date" class="form-control form-control-custom" id="schedDate" required>
                    </div>

                    <div class="mb-4">
                        <label for="schedName" class="form-label-custom">
                            <i class="fas fa-pen form-label-icon"></i> 일정 이름 <span class="required-star">*</span>
                        </label>
                        <input type="text" class="form-control form-control-custom" id="schedName" required placeholder="일정 이름을 입력해주세요">
                    </div>

                    <div class="mb-4">
                        <label for="mapAddress" class="form-label-custom">
                            <i class="fas fa-map-marker-alt form-label-icon"></i> 주소 <span class="required-star">*</span>
                        </label>
                        <textarea class="form-control form-control-custom" id="mapAddress" rows="2" required readonly placeholder="주소 정보"></textarea>
                        <div class="form-text ms-1 mt-1"><small>주소가 정확하지 않으면 직접 수정할 수 있습니다.</small></div>
                    </div>

                    <div class="card border-0 bg-light rounded-4 p-3">
                        <div class="d-flex align-items-center mb-3">
                            <i class="fas fa-route text-success me-2 fs-5"></i>
                            <span class="fw-bold text-dark">산책 코스 저장</span>
                        </div>

                        <div class="mb-2">
                            <label for="courseName" class="form-label-custom" style="font-size: 0.85rem;">코스 이름</label>
                            <input type="text" class="form-control form-control-custom" id="courseName" required>
                        </div>

                        <input type="hidden" id="courseType">
                        <input type="hidden" id="startLat">
                        <input type="hidden" id="startLng">
                        <input type="hidden" id="endLat">
                        <input type="hidden" id="endLng">
                        <input type="hidden" id="courseDistance">

                        <div class="d-flex align-items-center mt-2">
                            <span class="badge bg-success me-2 rounded-pill" id="displayCourseType"></span>
                            <small class="text-muted" style="font-size: 0.8rem;">이 코스는 지도의 '산책 코스' 탭에 저장됩니다.</small>
                        </div>
                    </div>

                </form>
            </div>

            <div class="modal-footer">
                <button type="button" class="btn btn-modal-cancel" data-bs-dismiss="modal">
                    <i class="fas fa-times me-1"></i> 취소
                </button>
                <button type="button" class="btn btn-modal-save" id="saveRecommendBtn">
                    <i class="fas fa-save me-1"></i> 저장
                </button>
            </div>
        </div>
    </div>
</div>

<script>
    document.addEventListener('DOMContentLoaded', function() {
        const recommendBtn = document.getElementById('recommendBtn');
        const resultsContainer = document.getElementById('recommendation-results');
        const loadingSpinner = document.getElementById('loadingSpinner');
        const modalElement = document.getElementById('addScheduleModal');
        const modal = new bootstrap.Modal(modalElement);

        // 오늘 날짜로 초기화
        document.getElementById('schedDate').valueAsDate = new Date();

        // 1. 추천 시작 버튼 클릭
        recommendBtn.addEventListener('click', function() {
            // JSP EL로 recId 가져오기 (null 처리)
            const recId = ${not empty selectedRecipient ? selectedRecipient.recId : 'null'};

            if (!recId) {
                alert("추천을 위한 대상자 정보가 없습니다.");
                return;
            }

            resultsContainer.innerHTML = '';
            loadingSpinner.style.display = 'block';
            recommendBtn.disabled = true;

            fetch('/schedule/ai-recommend', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify({ recId: parseInt(recId) })
            })
                .then(response => response.json())
                .then(data => {
                    loadingSpinner.style.display = 'none';
                    recommendBtn.disabled = false;

                    if (!data || data.length === 0) {
                        resultsContainer.innerHTML = '<div class="col-12 text-center py-5"><h4 class="text-muted">추천 결과가 없습니다.</h4></div>';
                        return;
                    }

                    data.forEach((item, index) => {
                        const cardCol = document.createElement('div');
                        cardCol.className = 'col-lg-4 col-md-6';

                        // place_url이나 좌표가 있으면 실제 존재하는 장소이므로 "주소 정보 없음" 표시하지 않음
                        const hasValidLocation = (item.placeUrl && item.placeUrl.trim() !== '') ||
                            (item.x && item.y && item.x.trim() !== '' && item.y.trim() !== '');
                        const address = item.address && item.address.trim() !== ''
                            ? item.address
                            : (hasValidLocation ? '' : '주소 정보 없음');
                        const distance = item.distance ? `(약 \${(parseInt(item.distance)/1000).toFixed(1)}km)` : '';

                        cardCol.innerHTML = `
                        <div class="card recommend-card">
                            <div class="card-header-custom d-flex justify-content-between align-items-center">
                                <h5 class="mb-0 text-truncate" title="\${item.mapName}">\${item.mapName}</h5>
                                <span class="badge badge-category">\${item.mapCategory}</span>
                            </div>
                            <div class="card-body d-flex flex-column">
                                <p class="card-text text-muted mb-2">
                                    \${address ? `<i class="fas fa-map-marker-alt text-danger"></i> \${address} ` : ''}\${distance}
                    </p>

                        <div class="mt-auto pt-3">
                            <button class="btn btn-outline-primary w-100 mb-2 btn-summary-toggle">
                                <i class="fas fa-align-left"></i> AI 요약 보기
                            </button>
                            <div class="summary-content mb-3">
                                <strong><i class="fas fa-robot text-primary"></i> AI 추천 이유:</strong><br>
                                \${item.mapContent}
                            </div>

                            <div class="d-flex gap-2 mb-2">
                                <a href="https://map.kakao.com/?sName=\${encodeURIComponent(item.startAddress || '내 위치')}&eName=\${encodeURIComponent(item.mapName)}" target="_blank" class="btn btn-map flex-grow-1">
                                    <i class="fas fa-directions"></i> 길찾기
                                </a>
                                <a href="https://map.kakao.com/link/search/\${encodeURIComponent(item.mapName)}" target="_blank" class="btn btn-outline-secondary flex-grow-1">
                                    <i class="fas fa-search"></i> 검색
                                </a>
                            </div>

                            <div class="d-grid">
                                <button class="btn btn-success w-100 btn-add-schedule"
                                        data-mapname="\${item.mapName}"
                                        data-mapcontent="\${item.mapContent}"
                                        data-mapcategory="\${item.mapCategory}"
                                        data-mapaddress="\${address}"
                                        data-coursetype="\${item.courseType || 'WALK'}"
                                        data-startlat="\${item.startLat}"
                                        data-startlng="\${item.startLng}"
                                        data-endlat="\${item.y}"
                                        data-endlng="\${item.x}"
                                        data-distance="\${item.distance || 0}">
                                    <i class="fas fa-plus"></i> 일정에 추가
                                </button>
                            </div>
                        </div>
                    </div>
                    </div>
                        `;

                        resultsContainer.appendChild(cardCol);
                    });

                    // 동적 생성된 버튼에 이벤트 리스너 연결
                    addCardEventListeners();
                })
                .catch(error => {
                    console.error('Error:', error);
                    loadingSpinner.style.display = 'none';
                    recommendBtn.disabled = false;
                    resultsContainer.innerHTML = '<div class="col-12 text-center py-5"><h4 class="text-danger">오류가 발생했습니다. 잠시 후 다시 시도해주세요.</h4></div>';
                });
        });

        // 2. 동적 생성된 카드 버튼 이벤트
        function addCardEventListeners() {
            // 요약 보기 토글
            document.querySelectorAll('.btn-summary-toggle').forEach(btn => {
                btn.addEventListener('click', function() {
                    const summary = this.nextElementSibling;
                    if (summary.style.display === 'block') {
                        summary.style.display = 'none';
                        this.innerHTML = '<i class="fas fa-align-left"></i> AI 요약 보기';
                    } else {
                        summary.style.display = 'block';
                        this.innerHTML = '<i class="fas fa-chevron-up"></i> 요약 접기';
                    }
                });
            });

            // 추가 버튼 (모달 열기)
            document.querySelectorAll('.btn-add-schedule').forEach(btn => {
                btn.addEventListener('click', function() {
                    const mapName = this.dataset.mapname;
                    const mapContent = this.dataset.mapcontent;
                    const mapCategory = this.dataset.mapcategory;
                    const mapAddress = this.dataset.mapaddress;
                    const courseType = this.dataset.coursetype;
                    const distance = this.dataset.distance;

                    // 좌표 데이터
                    const startLat = this.dataset.startlat;
                    const startLng = this.dataset.startlng;
                    const endLat = this.dataset.endlat;
                    const endLng = this.dataset.endlng;

                    // 모달 hidden input 설정
                    document.getElementById('modalMapName').value = mapName;
                    document.getElementById('modalMapContent').value = mapContent;
                    document.getElementById('modalMapCategory').value = mapCategory;

                    // 모달 표시 데이터 설정 (텍스트)
                    document.getElementById('displayMapName').textContent = mapName;
                    document.getElementById('displayMapCategory').textContent = mapCategory;
                    document.getElementById('displayMapContent').textContent = mapContent;

                    // 폼 기본값 채우기
                    document.getElementById('schedName').value = mapName + " 방문";

                    // 코스 정보 설정
                    document.getElementById('courseName').value = mapName + " 방문 코스";
                    document.getElementById('courseType').value = courseType;
                    document.getElementById('displayCourseType').textContent = courseType;

                    // 좌표 및 거리 설정 (Hidden)
                    document.getElementById('startLat').value = startLat;
                    document.getElementById('startLng').value = startLng;
                    document.getElementById('endLat').value = endLat;
                    document.getElementById('endLng').value = endLng;
                    document.getElementById('courseDistance').value = distance;

                    const addrInput = document.getElementById('mapAddress');
                    addrInput.value = mapAddress;

                    // 주소 정보가 불분명할 경우 수정 가능하도록 처리
                    if (!mapAddress || mapAddress === '주소 정보 없음' || mapAddress === 'null') {
                        addrInput.value = '';
                        addrInput.placeholder = '주소를 직접 입력해주세요';
                        addrInput.readOnly = false;
                        addrInput.style.backgroundColor = '#ffffff';
                    } else {
                        addrInput.readOnly = true;
                        addrInput.style.backgroundColor = '#f8f9fa';
                    }

                    modal.show();
                });
            });
        }

        // 3. 모달 저장 버튼 클릭
        document.getElementById('saveRecommendBtn').addEventListener('click', function() {
            const recId = ${not empty selectedRecipient ? selectedRecipient.recId : 'null'};

            const data = {
                recId: recId,
                schedDate: document.getElementById('schedDate').value,
                schedName: document.getElementById('schedName').value,
                mapAddress: document.getElementById('mapAddress').value,
                mapName: document.getElementById('modalMapName').value,
                mapContent: document.getElementById('modalMapContent').value,
                mapCategory: document.getElementById('modalMapCategory').value,

                // 산책 코스 데이터
                courseName: document.getElementById('courseName').value,
                courseType: document.getElementById('courseType').value,
                startLat: document.getElementById('startLat').value,
                startLng: document.getElementById('startLng').value,
                endLat: document.getElementById('endLat').value,
                endLng: document.getElementById('endLng').value,
                courseDistance: document.getElementById('courseDistance').value
            };

            fetch('/schedule/save-recommendation', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify(data)
            })
                .then(response => response.json())
                .then(result => {
                    if (result.success) {
                        alert(result.message);
                        modal.hide();
                    } else {
                        alert(result.message);
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    alert('저장 중 오류가 발생했습니다.');
                });
        });
    });
</script>