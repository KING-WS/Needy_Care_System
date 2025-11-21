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

            <div class="card shadow-sm mb-4 add-card">

                <div class="card-header bg-primary text-white">

                    <h4 class="mb-0"><i class="bi bi-person-plus me-2"></i>고객 등록</h4>

                </div>

                <div class="card-body">

                    <form id="customerAddForm" action="<c:url value='/customer/addimpl'/>" method="post">

                        <div class="row mb-3">

                            <div class="col-md-6">

                                <label for="custName" class="form-label">고객명 <span class="text-danger">*</span></label>

                                <input type="text" class="form-control add-input" id="custName" name="custName" required>

                            </div>

                            <div class="col-md-6">

                                <label for="custEmail" class="form-label">이메일 <span class="text-danger">*</span></label>

                                <input type="email" class="form-control add-input" id="custEmail" name="custEmail" required>

                            </div>

                        </div>

                        

                        <div class="row mb-3">

                            <div class="col-md-6">

                                <label for="custPwd" class="form-label">비밀번호 <span class="text-danger">*</span></label>

                                <input type="password" class="form-control add-input" id="custPwd" name="custPwd" required>

                            </div>

                            <div class="col-md-6">

                                <label for="custPhone" class="form-label">연락처 <span class="text-danger">*</span></label>

                                <input type="tel" class="form-control add-input" id="custPhone" name="custPhone" required>

                            </div>

                        </div>

                        

                        <div class="d-flex justify-content-end gap-2">

                            <button type="button" class="btn btn-secondary add-btn" onclick="history.back()">

                                <i class="bi bi-x-circle me-1"></i>취소

                            </button>

                            <button type="submit" class="btn btn-primary add-btn">

                                <i class="bi bi-check-circle me-1"></i>등록

                            </button>

                        </div>

                    </form>

                </div>

            </div>

        </div>

    </div>

</div>



