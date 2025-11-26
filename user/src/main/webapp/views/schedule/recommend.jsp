<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<style>
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
    .btn-map {
        background-color: #fee500;
        color: #191919;
        border: none;
        font-weight: 600;
    }
    .btn-map:hover {
        background-color: #fdd835;
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
</style>

<section style="padding: 20px 0 100px 0; background: #FFFFFF; min-height: calc(100vh - 200px);">
    <div class="container-fluid" style="max-width: 1400px; margin: 0 auto; padding: 0 40px;">
        
        <div class="row">
            <div class="col-12 mb-4">
                <h1 style="font-size: 36px; font-weight: bold; color: var(--secondary-color);">
                    <i class="fas fa-robot"></i> AI 장소 추천
                </h1>
                <p style="font-size: 16px; color: #666; margin-top: 10px;">
                    노약자 맞춤형 장소 및 행사를 AI가 분석하여 추천해드립니다.
                </p>
            </div>
        </div>

        <!-- 노약자 선택 (ScheduleController가 recipientList를 넘겨준다고 가정) -->
        <c:if test="${not empty recipientList}">
            <div class="row mb-4 justify-content-center">
                <div class="col-md-6">
                    <div class="card shadow-sm border-0">
                        <div class="card-body d-flex align-items-center gap-3">
                            <label class="fw-bold text-nowrap"><i class="fas fa-user-injured"></i> 대상자:</label>
                            <select id="recipientSelect" class="form-select">
                                <c:forEach items="${recipientList}" var="rec">
                                    <option value="${rec.recId}" ${rec.recId == selectedRecipient.recId ? 'selected' : ''}>
                                        ${rec.recName}
                                    </option>
                                </c:forEach>
                            </select>
                        </div>
                    </div>
                </div>
            </div>
        </c:if>

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
            <p class="text-muted">최적의 장소와 행사를 찾고 있으니 잠시만 기다려주세요.</p>
        </div>

        <div id="recommendation-results" class="row g-4">
            <!-- Results will be injected here -->
        </div>
    </div>
</section>

<!-- Modal for Adding to Schedule -->
<div class="modal fade" id="addScheduleModal" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content border-0 shadow-lg" style="border-radius: 15px;">
      <div class="modal-header bg-light">
        <h5 class="modal-title fw-bold"><i class="fas fa-plus-circle text-primary"></i> 일정/지도 추가하기</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
      <div class="modal-body p-4">
        <form id="saveRecommendForm">
            <!-- AI 분석 정보 표시 영역 -->
            <div class="alert alert-primary mb-3" role="alert">
                <h6 class="alert-heading fw-bold"><i class="fas fa-robot"></i> AI 자동 분석 정보</h6>
                <hr>
                <div class="mb-1">
                    <small class="text-muted">장소명:</small> <strong id="displayMapName"></strong>
                    <span id="displayMapCategory" class="badge bg-info text-dark ms-2"></span>
                </div>
                <div class="mt-2 p-2 bg-white rounded border">
                    <small class="text-muted d-block mb-1">AI 추천 내용:</small>
                    <p id="displayMapContent" class="mb-0 small text-dark"></p>
                </div>
            </div>

            <input type="hidden" id="modalMapName">
            <input type="hidden" id="modalMapContent">
            <input type="hidden" id="modalMapCategory">
            
            <div class="mb-3">
                <label for="schedDate" class="form-label fw-bold">날짜</label>
                <input type="date" class="form-control" id="schedDate" required>
            </div>
            <div class="mb-3">
                <label for="schedName" class="form-label fw-bold">일정 이름</label>
                <input type="text" class="form-control" id="schedName" required placeholder="예: 주말 공원 산책">
            </div>
            <div class="mb-3">
                <label for="mapAddress" class="form-label fw-bold">주소 (위치 정보)</label>
                <input type="text" class="form-control" id="mapAddress" required readonly style="background-color: #f8f9fa;">
                <div class="form-text">주소가 정확하지 않으면 직접 수정할 수 있습니다.</div>
            </div>
        </form>
      </div>
      <div class="modal-footer border-top-0">
        <button type="button" class="btn btn-light" data-bs-dismiss="modal">취소</button>
        <button type="button" class="btn btn-primary px-4" id="saveRecommendBtn" style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); border: none;">저장하기</button>
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
        
        // Set default date to today
        document.getElementById('schedDate').valueAsDate = new Date();

        recommendBtn.addEventListener('click', function() {
            const recId = document.getElementById('recipientSelect') ? document.getElementById('recipientSelect').value : null;
            
            if (!recId) {
                alert("대상자를 선택해주세요.");
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
                    
                    const address = item.address || '주소 정보 없음';
                    const distance = item.distance ? `(약 \${(parseInt(item.distance)/1000).toFixed(1)}km)` : '';
                    
                    cardCol.innerHTML = `
                        <div class="card recommend-card">
                            <div class="card-header-custom d-flex justify-content-between align-items-center">
                                <h5 class="mb-0 text-truncate" title="\${item.mapName}">\${item.mapName}</h5>
                                <span class="badge badge-category">\${item.mapCategory}</span>
                            </div>
                            <div class="card-body d-flex flex-column">
                                <p class="card-text text-muted mb-2"><i class="fas fa-map-marker-alt text-danger"></i> \${address} \${distance}</p>
                                
                                <div class="mt-auto pt-3">
                                    <button class="btn btn-outline-primary w-100 mb-2 btn-summary-toggle">
                                        <i class="fas fa-align-left"></i> AI 요약 보기
                                    </button>
                                    <div class="summary-content mb-3">
                                        <strong><i class="fas fa-robot text-primary"></i> AI 추천 이유:</strong><br>
                                        \${item.mapContent}
                                    </div>
                                    
                                    <div class="d-flex gap-2">
                                        <a href="https://map.kakao.com/link/search/\${encodeURIComponent(item.mapName)}" target="_blank" class="btn btn-map flex-grow-1">
                                            <i class="fas fa-map"></i> 지도 검색
                                        </a>
                                        <button class="btn btn-success flex-grow-1 btn-add-schedule"
                                            data-mapname="\${item.mapName}"
                                            data-mapcontent="\${item.mapContent}"
                                            data-mapcategory="\${item.mapCategory}"
                                            data-mapaddress="\${address}">
                                            <i class="fas fa-plus"></i> 추가
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </div>
                    `;
                    
                    resultsContainer.appendChild(cardCol);
                });

                // Event delegation for dynamically created buttons
                addCardEventListeners();
            })
            .catch(error => {
                console.error('Error:', error);
                loadingSpinner.style.display = 'none';
                recommendBtn.disabled = false;
                resultsContainer.innerHTML = '<div class="col-12 text-center py-5"><h4 class="text-danger">오류가 발생했습니다. 잠시 후 다시 시도해주세요.</h4></div>';
            });
        });

        function addCardEventListeners() {
            // Summary Toggle
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

            // Add Schedule Button
            document.querySelectorAll('.btn-add-schedule').forEach(btn => {
                btn.addEventListener('click', function() {
                    const mapName = this.dataset.mapname;
                    const mapContent = this.dataset.mapcontent;
                    const mapCategory = this.dataset.mapcategory;
                    const mapAddress = this.dataset.mapaddress;

                    document.getElementById('modalMapName').value = mapName;
                    document.getElementById('modalMapContent').value = mapContent;
                    document.getElementById('modalMapCategory').value = mapCategory;

                    // 모달 내 표시용 데이터 설정
                    document.getElementById('displayMapName').textContent = mapName;
                    document.getElementById('displayMapCategory').textContent = mapCategory;
                    document.getElementById('displayMapContent').textContent = mapContent;
                    
                    document.getElementById('schedName').value = mapName + " 방문";
                    
                    const addrInput = document.getElementById('mapAddress');
                    addrInput.value = mapAddress;
                    
                    // 주소 정보가 없거나 '정보 없음'인 경우 수정 가능하게 변경
                    if (!mapAddress || mapAddress === '주소 정보 없음' || mapAddress === 'null') {
                        addrInput.value = '';
                        addrInput.placeholder = '주소를 직접 입력해주세요';
                        addrInput.readOnly = false;
                        addrInput.style.backgroundColor = '#ffffff';
                    } else {
                        addrInput.readOnly = true; // 이미 주소가 있으면 읽기 전용 유지
                        addrInput.style.backgroundColor = '#f8f9fa';
                    }

                    modal.show();
                });
            });
        }

        // Save Button in Modal
        document.getElementById('saveRecommendBtn').addEventListener('click', function() {
            const recId = document.getElementById('recipientSelect') ? document.getElementById('recipientSelect').value : null;
            
            const data = {
                recId: recId,
                schedDate: document.getElementById('schedDate').value,
                schedName: document.getElementById('schedName').value,
                mapAddress: document.getElementById('mapAddress').value,
                mapName: document.getElementById('modalMapName').value,
                mapContent: document.getElementById('modalMapContent').value,
                mapCategory: document.getElementById('modalMapCategory').value
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

