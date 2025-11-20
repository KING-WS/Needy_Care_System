<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<style>
    .customer-card {
        border-radius: 15px;
        overflow: hidden;
    }
    
    .customer-card .card-header {
        border-radius: 15px 15px 0 0;
    }
    
    .customer-btn {
        border-radius: 10px;
        padding: 10px 20px;
    }
    
    .customer-table {
        border-radius: 10px;
        overflow: hidden;
    }
    
    .customer-badge {
        border-radius: 8px;
        padding: 6px 12px;
    }
</style>

<div class="container-fluid py-4">
    <div class="row">
        <div class="col-12">
            <div class="card shadow-sm customer-card">
                <div class="card-header bg-primary text-white">
                    <h4 class="mb-0"><i class="bi bi-people me-2"></i>고객 목록</h4>
                </div>
                <div class="card-body">
                    <div class="mb-4">
                        <a href="<c:url value="/customer/add"/>" class="btn btn-primary customer-btn">
                            <i class="bi bi-person-plus me-2"></i>고객 등록
                        </a>
                        <button class="btn btn-outline-secondary ms-2 customer-btn">
                            <i class="bi bi-download me-2"></i>엑셀 다운로드
                        </button>
                    </div>
                    
                    <div class="table-responsive">
                        <table class="table table-hover customer-table">
                            <thead class="table-light">
                                <tr>
                                    <th><input type="checkbox"></th>
                                    <th>번호</th>
                                    <th>고객명</th>
                                    <th>연락처</th>
                                    <th>이메일</th>
                                    <th>가입일</th>
                                    <th>상태</th>
                                    <th>관리</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td><input type="checkbox"></td>
                                    <td>1</td>
                                    <td>홍길동</td>
                                    <td>010-1234-5678</td>
                                    <td>hong@example.com</td>
                                    <td>2025-01-15</td>
                                    <td><span class="badge bg-success customer-badge">활성</span></td>
                                    <td>
                                        <button class="btn btn-sm btn-outline-primary" style="border-radius: 8px;">상세</button>
                                        <button class="btn btn-sm btn-outline-secondary" style="border-radius: 8px;">수정</button>
                                    </td>
                                </tr>
                                <tr>
                                    <td><input type="checkbox"></td>
                                    <td>2</td>
                                    <td>김철수</td>
                                    <td>010-2345-6789</td>
                                    <td>kim@example.com</td>
                                    <td>2025-02-20</td>
                                    <td><span class="badge bg-success customer-badge">활성</span></td>
                                    <td>
                                        <button class="btn btn-sm btn-outline-primary" style="border-radius: 8px;">상세</button>
                                        <button class="btn btn-sm btn-outline-secondary" style="border-radius: 8px;">수정</button>
                                    </td>
                                </tr>
                                <tr>
                                    <td><input type="checkbox"></td>
                                    <td>3</td>
                                    <td>이영희</td>
                                    <td>010-3456-7890</td>
                                    <td>lee@example.com</td>
                                    <td>2025-03-10</td>
                                    <td><span class="badge bg-warning customer-badge">대기</span></td>
                                    <td>
                                        <button class="btn btn-sm btn-outline-primary" style="border-radius: 8px;">상세</button>
                                        <button class="btn btn-sm btn-outline-secondary" style="border-radius: 8px;">수정</button>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                    
                    <nav>
                        <ul class="pagination justify-content-center">
                            <li class="page-item disabled"><a class="page-link" href="#">이전</a></li>
                            <li class="page-item active"><a class="page-link" href="#">1</a></li>
                            <li class="page-item"><a class="page-link" href="#">2</a></li>
                            <li class="page-item"><a class="page-link" href="#">3</a></li>
                            <li class="page-item"><a class="page-link" href="#">다음</a></li>
                        </ul>
                    </nav>
                </div>
            </div>
        </div>
    </div>
</div>

