<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<style>
    .senior-card {
        border-radius: 15px;
        overflow: hidden;
    }
    
    .senior-card .card-header {
        border-radius: 15px 15px 0 0;
    }
    
    .senior-btn {
        border-radius: 10px;
        padding: 10px 20px;
    }
    
    .senior-table {
        border-radius: 10px;
        overflow: hidden;
    }
    
    .senior-badge {
        border-radius: 8px;
        padding: 6px 12px;
    }
</style>

<div class="container-fluid py-4">
    <div class="row">
        <div class="col-12">
            <div class="card shadow-sm mb-4 senior-card">
                <div class="card-header bg-primary text-white d-flex justify-content-between align-items-center">
                    <h4 class="mb-0"><i class="bi bi-person-wheelchair me-2"></i>노약자 목록</h4>
                    <a href="<c:url value='/senior/add'/>" class="btn btn-light senior-btn">
                        <i class="bi bi-person-plus me-1"></i>노약자 등록
                    </a>
                </div>
                <div class="card-body">
                    <div class="table-responsive senior-table">
                        <table class="table table-hover">
                            <thead class="table-light">
                                <tr>
                                    <th>번호</th>
                                    <th>이름</th>
                                    <th>나이</th>
                                    <th>성별</th>
                                    <th>담당 요양사</th>
                                    <th>건강 상태</th>
                                    <th>등록일</th>
                                    <th>관리</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td>1</td>
                                    <td>김영희</td>
                                    <td>82세</td>
                                    <td>여</td>
                                    <td>이요양</td>
                                    <td><span class="badge bg-success senior-badge">양호</span></td>
                                    <td>2024-01-15</td>
                                    <td>
                                        <button class="btn btn-sm btn-primary senior-btn">
                                            <i class="bi bi-eye"></i>
                                        </button>
                                        <button class="btn btn-sm btn-warning senior-btn">
                                            <i class="bi bi-pencil"></i>
                                        </button>
                                    </td>
                                </tr>
                                <tr>
                                    <td>2</td>
                                    <td>박철수</td>
                                    <td>75세</td>
                                    <td>남</td>
                                    <td>김요양</td>
                                    <td><span class="badge bg-warning senior-badge">주의</span></td>
                                    <td>2024-02-20</td>
                                    <td>
                                        <button class="btn btn-sm btn-primary senior-btn">
                                            <i class="bi bi-eye"></i>
                                        </button>
                                        <button class="btn btn-sm btn-warning senior-btn">
                                            <i class="bi bi-pencil"></i>
                                        </button>
                                    </td>
                                </tr>
                                <tr>
                                    <td>3</td>
                                    <td>최순자</td>
                                    <td>88세</td>
                                    <td>여</td>
                                    <td>박요양</td>
                                    <td><span class="badge bg-danger senior-badge">위험</span></td>
                                    <td>2024-03-10</td>
                                    <td>
                                        <button class="btn btn-sm btn-primary senior-btn">
                                            <i class="bi bi-eye"></i>
                                        </button>
                                        <button class="btn btn-sm btn-warning senior-btn">
                                            <i class="bi bi-pencil"></i>
                                        </button>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                    
                    <nav aria-label="Page navigation" class="mt-3">
                        <ul class="pagination justify-content-center">
                            <li class="page-item disabled">
                                <a class="page-link" href="#" tabindex="-1">이전</a>
                            </li>
                            <li class="page-item active"><a class="page-link" href="#">1</a></li>
                            <li class="page-item"><a class="page-link" href="#">2</a></li>
                            <li class="page-item"><a class="page-link" href="#">3</a></li>
                            <li class="page-item">
                                <a class="page-link" href="#">다음</a>
                            </li>
                        </ul>
                    </nav>
                </div>
            </div>
        </div>
    </div>
</div>

