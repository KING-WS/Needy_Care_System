<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div class="container-fluid py-4">
    <div class="row">
        <div class="col-12">
            <div class="card shadow-sm mb-4">
                <div class="card-header bg-primary text-white">
                    <h4 class="mb-0"><i class="bi bi-person-plus me-2"></i>돌봄대상자 등록</h4>
                </div>
                <div class="card-body">
                    <c:if test="${not empty error}">
                        <div class="alert alert-danger">
                            <i class="bi bi-exclamation-triangle-fill"></i> ${error}
                        </div>
                    </c:if>

                    <form method="post" action="<c:url value='/senior/addimpl'/>" enctype="multipart/form-data">
                        
                        <%-- Section 1: 기본 정보 --%>
                        <h5 class="mb-3"><i class="bi bi-person-badge text-primary"></i> 기본 정보</h5>
                        <hr class="mt-0">

                        <div class="row">
                             <div class="col-md-8">
                                <div class="mb-3">
                                    <label for="custId" class="form-label">고객(보호자) ID <span class="text-danger">*</span></label>
                                    <input type="number" id="custId" name="custId" class="form-control" required placeholder="연결할 고객의 숫자 ID를 입력하세요">
                                    <small class="form-text text-muted">돌봄대상자를 관리할 고객(보호자) 계정의 ID입니다.</small>
                                </div>
                                <div class="mb-3">
                                    <label for="recName" class="form-label">이름<span class="text-danger">*</span></label>
                                    <input type="text" id="recName" name="recName" class="form-control" required placeholder="돌봄 대상자의 이름을 입력하세요">
                                </div>
                                <div class="mb-3">
                                    <label for="recTypeCode" class="form-label">대상자 유형<span class="text-danger">*</span></label>
                                    <select id="recTypeCode" name="recTypeCode" class="form-select" required>
                                        <option value="">선택하세요</option>
                                        <option value="ELDERLY">노인/고령자</option>
                                        <option value="PREGNANT">임산부</option>
                                        <option value="DISABLED">장애인</option>
                                    </select>
                                </div>
                             </div>
                             <div class="col-md-4">
                                <label class="form-label">프로필 사진</label>
                                <div class="text-center">
                                    <div id="photoPreview" style="width: 150px; height: 150px; border-radius: 50%; border: 4px dashed #ccc; display: flex; align-items: center; justify-content: center; overflow: hidden; margin: 0 auto 10px;">
                                        <i class="bi bi-person-circle" style="font-size: 50px; color: #ccc;"></i>
                                    </div>
                                    <input type="file" name="recPhotoUrl" id="photoInput" class="form-control" accept="image/*" onchange="previewPhoto(event)">
                                </div>
                            </div>
                        </div>

                        <div class="mb-3">
                            <label class="form-label">성별<span class="text-danger">*</span></label>
                            <div>
                                <div class="form-check form-check-inline">
                                    <input class="form-check-input" type="radio" name="recGender" id="genderM" value="M" required>
                                    <label class="form-check-label" for="genderM">남성</label>
                                </div>
                                <div class="form-check form-check-inline">
                                    <input class="form-check-input" type="radio" name="recGender" id="genderF" value="F" required>
                                    <label class="form-check-label" for="genderF">여성</label>
                                </div>
                            </div>
                        </div>

                        <div class="mb-3">
                            <label for="recBirthday" class="form-label">생년월일<span class="text-danger">*</span></label>
                            <input type="date" id="recBirthday" name="recBirthday" class="form-control" required>
                        </div>

                        <div class="mb-3">
                            <label class="form-label">주소<span class="text-danger">*</span></label>
                            <div class="input-group mb-2">
                                <input type="text" id="postcode" class="form-control" placeholder="우편번호" readonly style="max-width: 150px;">
                                <button type="button" onclick="execDaumPostcode()" class="btn btn-outline-secondary">주소 검색</button>
                            </div>
                            <input type="text" id="roadAddress" class="form-control mb-2" placeholder="도로명 주소" readonly>
                            <input type="text" id="jibunAddress" name="recAddress" class="form-control mb-2" required placeholder="지번 주소" readonly>
                            <input type="text" id="detailAddress" class="form-control" placeholder="상세 주소 (선택사항)">
                            <%-- Latitude and Longitude hidden fields --%>
                            <input type="hidden" id="latitude" name="recLatitude">
                            <input type="hidden" id="longitude" name="recLongitude">
                        </div>

                        <%-- Section 2: 건강 정보 --%>
                        <h5 class="mt-4 mb-3"><i class="bi bi-heart-pulse text-primary"></i> 건강 정보</h5>
                        <hr class="mt-0">
                        
                        <div class="mb-3">
                            <label class="form-label">병력</label>
                            <div class="p-3 bg-light border rounded mb-2">
                                <div class="row">
                                    <div class="col-12 col-md-6"><div class="form-check"><input class="form-check-input" type="checkbox" id="medHistory_hypertension" value="고혈압" onchange="updateMedHistory()"><label class="form-check-label" for="medHistory_hypertension">고혈압</label></div></div>
                                    <div class="col-12 col-md-6"><div class="form-check"><input class="form-check-input" type="checkbox" id="medHistory_diabetes" value="당뇨" onchange="updateMedHistory()"><label class="form-check-label" for="medHistory_diabetes">당뇨</label></div></div>
                                    <div class="col-12 col-md-6"><div class="form-check"><input class="form-check-input" type="checkbox" id="medHistory_heart" value="심장 질환" onchange="updateMedHistory()"><label class="form-check-label" for="medHistory_heart">심장 질환</label></div></div>
                                    <div class="col-12 col-md-6"><div class="form-check"><input class="form-check-input" type="checkbox" id="medHistory_respiratory" value="호흡기 질환" onchange="updateMedHistory()"><label class="form-check-label" for="medHistory_respiratory">호흡기 질환</label></div></div>
                                    <div class="col-12 col-md-6"><div class="form-check"><input class="form-check-input" type="checkbox" id="medHistory_none" value="해당 사항 없음" onchange="updateMedHistory()"><label class="form-check-label" for="medHistory_none">해당 사항 없음</label></div></div>
                                    <div class="col-12 col-md-6"><div class="form-check"><input class="form-check-input" type="checkbox" id="medHistory_other" onchange="toggleOtherInput('medHistory')"><label class="form-check-label" for="medHistory_other">기타</label></div></div>
                                </div>
                                <input type="text" id="medHistory_other_input" class="form-control mt-2" placeholder="기타 질환 입력" style="display:none;" onchange="updateMedHistory()">
                            </div>
                            <textarea name="recMedHistory" id="recMedHistory" class="form-control" rows="2" placeholder="선택한 항목이 자동으로 입력됩니다" readonly></textarea>
                        </div>

                        <div class="mb-3">
                            <label class="form-label">알레르기</label>
                            <div class="p-3 bg-light border rounded mb-2">
                                <div class="row">
                                    <div class="col-12 col-md-6"><div class="form-check"><input class="form-check-input" type="checkbox" id="allergy_antibiotic" value="항생제" onchange="updateAllergies()"><label class="form-check-label" for="allergy_antibiotic">항생제</label></div></div>
                                    <div class="col-12 col-md-6"><div class="form-check"><input class="form-check-input" type="checkbox" id="allergy_painkiller" value="진통제" onchange="updateAllergies()"><label class="form-check-label" for="allergy_painkiller">진통제</label></div></div>
                                    <div class="col-12 col-md-6"><div class="form-check"><input class="form-check-input" type="checkbox" id="allergy_food" value="음식" onchange="updateAllergies()"><label class="form-check-label" for="allergy_food">특정 음식</label></div></div>
                                    <div class="col-12 col-md-6"><div class="form-check"><input class="form-check-input" type="checkbox" id="allergy_none" value="해당 사항 없음" onchange="updateAllergies()"><label class="form-check-label" for="allergy_none">해당 사항 없음</label></div></div>
                                    <div class="col-12 col-md-6"><div class="form-check"><input class="form-check-input" type="checkbox" id="allergy_other" onchange="toggleOtherInput('allergy')"><label class="form-check-label" for="allergy_other">기타</label></div></div>
                                </div>
                                <input type="text" id="allergy_other_input" class="form-control mt-2" placeholder="기타 알레르기 입력" style="display:none;" onchange="updateAllergies()">
                            </div>
                            <textarea name="recAllergies" id="recAllergies" class="form-control" rows="2" placeholder="선택한 항목이 자동으로 입력됩니다" readonly></textarea>
                        </div>
                        
                        <div class="mb-3">
                            <label class="form-label">건강 관련 필요사항</label>
                            <div class="p-3 bg-light border rounded mb-2">
                                <div class="row">
                                    <div class="col-12 col-md-6"><div class="form-check"><input class="form-check-input" type="checkbox" id="healthNeed_pregnant" value="임산부입니다. (안정이 필요합니다)" onchange="updateHealthNeeds()"><label class="form-check-label" for="healthNeed_pregnant">임산부입니다. (안정이 필요합니다)</label></div></div>
                                    <div class="col-12 col-md-6"><div class="form-check"><input class="form-check-input" type="checkbox" id="healthNeed_wheelchair" value="휠체어를 사용합니다. (경사로/엘리베이터 필요)" onchange="updateHealthNeeds()"><label class="form-check-label" for="healthNeed_wheelchair">휠체어를 사용합니다. (경사로/엘리베이터 필요)</label></div></div>
                                    <div class="col-12 col-md-6"><div class="form-check"><input class="form-check-input" type="checkbox" id="healthNeed_mobility" value="거동이 불편하여 부축이나 지팡이가 필요합니다" onchange="updateHealthNeeds()"><label class="form-check-label" for="healthNeed_mobility">거동이 불편하여 부축이나 지팡이가 필요합니다</label></div></div>
                                    <div class="col-12 col-md-6"><div class="form-check"><input class="form-check-input" type="checkbox" id="healthNeed_sensory" value="시각/청각에 불편함이 있어 안내가 필요합니다" onchange="updateHealthNeeds()"><label class="form-check-label" for="healthNeed_sensory">시각/청각에 불편함이 있어 안내가 필요합니다</label></div></div>
                                    <div class="col-12 col-md-6"><div class="form-check"><input class="form-check-input" type="checkbox" id="healthNeed_ok" value="괜찮습니다. 스스로 이동 가능합니다" onchange="updateHealthNeeds()"><label class="form-check-label" for="healthNeed_ok">괜찮습니다. 스스로 이동 가능합니다</label></div></div>
                                    <div class="col-12 col-md-6"><div class="form-check"><input class="form-check-input" type="checkbox" id="healthNeed_other" onchange="toggleOtherInput('healthNeed')"><label class="form-check-label" for="healthNeed_other">기타</label></div></div>
                                </div>
                                <input type="text" id="healthNeed_other_input" class="form-control mt-2" placeholder="기타 건강 요구사항을 입력하세요" style="display:none;" onchange="updateHealthNeeds()">
                            </div>
                            <textarea name="recHealthNeeds" id="recHealthNeeds" class="form-control" rows="2" placeholder="선택한 항목이 자동으로 입력됩니다" readonly></textarea>
                        </div>
                        
                        <%-- Section 3: 추가 정보 --%>
                        <h5 class="mt-4 mb-3"><i class="bi bi-info-circle text-primary"></i> 추가 정보</h5>
                        <hr class="mt-0">

                        <div class="mb-3">
                            <label for="recSpecNotes" class="form-label">특이사항</label>
                            <textarea id="recSpecNotes" name="recSpecNotes" class="form-control" rows="3" placeholder="기타 특이사항이나 주의사항을 입력하세요"></textarea>
                        </div>
                        
                        <div class="d-flex justify-content-end gap-2 mt-4">
                            <button type="button" class="btn btn-secondary" onclick="history.back()">
                                <i class="bi bi-x-circle me-1"></i>취소
                            </button>
                            <button type="submit" class="btn btn-primary">
                                <i class="bi bi-check-circle me-1"></i>등록
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script src="//dapi.kakao.com/v2/maps/sdk.js?appkey=${kakaoMapKey}&libraries=services"></script>

<script>
    // 사진 미리보기
    function previewPhoto(event) {
        const file = event.target.files[0];
        const preview = document.getElementById('photoPreview');
        if (file) {
            const reader = new FileReader();
            reader.onload = function(e) {
                preview.innerHTML = '<img src="' + e.target.result + '" alt="Preview" style="width:100%; height:100%; object-fit:cover;">';
            };
            reader.readAsDataURL(file);
        }
    }

    // Daum 주소 API
    function execDaumPostcode() {
        new daum.Postcode({
            oncomplete: function(data) {
                document.getElementById('postcode').value = data.zonecode;
                document.getElementById('roadAddress').value = data.roadAddress;
                document.getElementById('jibunAddress').value = data.jibunAddress || data.roadAddress;
                
                // 주소로 좌표 검색
                var geocoder = new kakao.maps.services.Geocoder();
                geocoder.addressSearch(data.address, function(result, status) {
                    if (status === kakao.maps.services.Status.OK) {
                        document.getElementById('latitude').value = result[0].y;
                        document.getElementById('longitude').value = result[0].x;
                    }
                });
                
                document.getElementById('detailAddress').focus();
            }
        }).open();
    }

    // 체크박스 "기타" 토글
    function toggleOtherInput(type) {
        const checkbox = document.getElementById(type + '_other');
        const input = document.getElementById(type + '_other_input');
        input.style.display = checkbox.checked ? 'block' : 'none';
        if (!checkbox.checked) {
            input.value = '';
        }
        if (type === 'medHistory') updateMedHistory();
        else if (type === 'allergy') updateAllergies();
    }

    // 병력 업데이트
    function updateMedHistory() {
        const selected = [];
        document.querySelectorAll('input[id^="medHistory_"]:checked').forEach(cb => {
            if (cb.id === 'medHistory_none') return;
            if (cb.id !== 'medHistory_other') selected.push(cb.value);
        });
        const otherValue = document.getElementById('medHistory_other_input').value.trim();
        if (document.getElementById('medHistory_other').checked && otherValue) {
            selected.push(otherValue);
        }
        
        if (document.getElementById('medHistory_none').checked) {
             document.querySelectorAll('input[id^="medHistory_"]:checked').forEach(cb => {
                if (cb.id !== 'medHistory_none') cb.checked = false;
             });
             toggleOtherInput('medHistory');
             document.getElementById('recMedHistory').value = '해당 사항 없음';
        } else {
             document.getElementById('recMedHistory').value = selected.join(', ');
        }
    }

    // 알레르기 업데이트
    function updateAllergies() {
        const selected = [];
        document.querySelectorAll('input[id^="allergy_"]:checked').forEach(cb => {
            if (cb.id === 'allergy_none') return;
            if (cb.id !== 'allergy_other') selected.push(cb.value);
        });
        const otherValue = document.getElementById('allergy_other_input').value.trim();
        if (document.getElementById('allergy_other').checked && otherValue) {
            selected.push(otherValue);
        }
        
        if (document.getElementById('allergy_none').checked) {
             document.querySelectorAll('input[id^="allergy_"]:checked').forEach(cb => {
                if (cb.id !== 'allergy_none') cb.checked = false;
             });
             toggleOtherInput('allergy');
             document.getElementById('recAllergies').value = '해당 사항 없음';
        } else {
            document.getElementById('recAllergies').value = selected.join(', ');
        }
    }
    
    // 주소 합치기
    document.querySelector('form').addEventListener('submit', function(e) {
        var jibun = document.getElementById('jibunAddress').value || '';
        var detail = document.getElementById('detailAddress').value || '';
        document.getElementById('jibunAddress').value = (jibun + ' ' + detail).trim();
    });
</script>