<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<style>
    .add-card {
        border-radius: 15px;
        overflow: hidden;
    }
    
    .add-card .card-header {
        border-radius: 15px 15px 0 0;
    }
    
    .add-input {
        border-radius: 10px;
    }
    
    .add-btn {
        border-radius: 10px;
        padding: 10px 24px;
    }
</style>

<div class="container-fluid py-4">
    <div class="row">
        <div class="col-12">
            <div class="card shadow-sm add-card">
                <div class="card-header bg-primary text-white">
                    <h4 class="mb-0"><i class="bi bi-person-plus-fill me-2"></i>요양사 등록</h4>
                </div>
                <div class="card-body">
                    <form method="POST" action="<c:url value='/caregiver/addimpl'/>" id="caregiver-form">
                        <div class="row">
                            <!-- 기본 정보 -->
                            <div class="col-md-6">
                                <h5 class="mb-3">기본 정보</h5>
                                
                                <div class="mb-3">
                                    <label class="form-label">이름 <span class="text-danger">*</span></label>
                                    <input type="text" class="form-control add-input" name="caregiverName" placeholder="이름을 입력하세요" required>
                                </div>
                                
                                <div class="mb-3">
                                    <label class="form-label">연락처 <span class="text-danger">*</span></label>
                                    <input type="tel" class="form-control" name="caregiverPhone" placeholder="010-0000-0000" required>
                                </div>
                                
                                <div class="mb-3">
                                    <label class="form-label">주소 <span class="text-danger">*</span></label>
                                    <div class="input-group mb-2">
                                        <input type="text" id="postcode" class="form-control add-input" placeholder="우편번호" readonly>
                                        <button class="btn btn-outline-secondary" type="button" onclick="execDaumPostcode()">주소 검색</button>
                                    </div>
                                    <input type="text" id="address" class="form-control add-input mb-2" placeholder="주소" readonly>
                                    <input type="text" id="detailAddress" class="form-control add-input" placeholder="상세주소">
                                    <input type="hidden" name="caregiverAddress" id="caregiverAddress">
                                </div>
                            </div>
                            
                            <!-- 근무 정보 -->
                            <div class="col-md-6">
                                <h5 class="mb-3">근무 정보</h5>
                                
                                <div class="mb-3">
                                    <label class="form-label">자격증 <span class="text-danger">*</span></label>
                                    <input type="text" class="form-control" name="caregiverCertifications" placeholder="예: 요양보호사 1급, 간호조무사" required>
                                </div>
                                
                                <div class="mb-3">
                                    <label class="form-label">경력 (년)</label>
                                    <input type="number" class="form-control" name="caregiverCareer" placeholder="0" min="0">
                                </div>

                                <div class="mb-3">
                                    <label class="form-label">전문 분야 (복수선택 가능)</label>
                                    <div id="specialties-group">
                                        <div class="form-check form-check-inline">
                                            <input class="form-check-input" type="checkbox" id="spec1" value="치매 케어">
                                            <label class="form-check-label" for="spec1">치매 케어</label>
                                        </div>
                                        <div class="form-check form-check-inline">
                                            <input class="form-check-input" type="checkbox" id="spec2" value="뇌졸중 케어">
                                            <label class="form-check-label" for="spec2">뇌졸중 케어</label>
                                        </div>
                                        <div class="form-check form-check-inline">
                                            <input class="form-check-input" type="checkbox" id="spec3" value="당뇨 관리">
                                            <label class="form-check-label" for="spec3">당뇨 관리</label>
                                        </div>
                                        <div class="form-check form-check-inline">
                                            <input class="form-check-input" type="checkbox" id="spec4" value="재활 치료">
                                            <label class="form-check-label" for="spec4">재활 치료</label>
                                        </div>
                                    </div>
                                    <input type="hidden" name="caregiverSpecialties" id="caregiverSpecialties">
                                </div>
                            </div>
                        </div>
                        
                        <!-- 버튼 -->
                        <div class="row mt-4">
                            <div class="col-12 text-end">
                                <button type="button" class="btn btn-secondary me-2 add-btn" onclick="history.back()">
                                    <i class="bi bi-x-circle me-2"></i>취소
                                </button>
                                <button type="submit" class="btn btn-primary add-btn">
                                    <i class="bi bi-check-circle me-2"></i>등록
                                </button>
                            </div>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Daum 우편번호 API -->
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script>
document.addEventListener('DOMContentLoaded', function() {
    const form = document.getElementById('caregiver-form');
    form.addEventListener('submit', function(e) {
        // Handle specialties checkboxes
        const checkedSpecialties = [];
        const checkboxes = document.querySelectorAll('#specialties-group .form-check-input:checked');
        checkboxes.forEach(function(checkbox) {
            checkedSpecialties.push(checkbox.value);
        });
        document.getElementById('caregiverSpecialties').value = checkedSpecialties.join(', ');

        // Handle address combination
        const address = document.getElementById('address').value;
        const detailAddress = document.getElementById('detailAddress').value;
        if (address) { // Only combine if a main address has been selected
            document.getElementById('caregiverAddress').value = address + ', ' + detailAddress;
        }
    });
});

function execDaumPostcode() {
    new daum.Postcode({
        oncomplete: function(data) {
            // 팝업에서 검색결과 항목을 클릭했을때 실행할 코드를 작성하는 부분.

            // 각 주소의 노출 규칙에 따라 주소를 조합한다.
            // 내려오는 변수가 값이 없는 경우엔 공백('')값을 가지므로, 이를 참고하여 분기 한다.
            var addr = ''; // 주소 변수

            //사용자가 선택한 주소 타입에 따라 해당 주소 값을 가져온다.
            if (data.userSelectedType === 'R') { // 사용자가 도로명 주소를 선택했을 경우
                addr = data.roadAddress;
            } else { // 사용자가 지번 주소를 선택했을 경우(J)
                addr = data.jibunAddress;
            }

            // 우편번호와 주소 정보를 해당 필드에 넣는다.
            document.getElementById('postcode').value = data.zonecode;
            document.getElementById("address").value = addr;
            // 커서를 상세주소 필드로 이동한다.
            document.getElementById("detailAddress").focus();
        }
    }).open();
}
</script>

