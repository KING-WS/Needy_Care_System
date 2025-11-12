<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<style>
    .manage-card {
        border-radius: 15px;
        overflow: hidden;
    }
    
    .manage-card .card-header {
        border-radius: 15px 15px 0 0;
    }
    
    .manage-tab {
        border-radius: 10px 10px 0 0;
    }
    
    .manage-table {
        border-radius: 10px;
        overflow: hidden;
    }
    
    .manage-badge {
        border-radius: 8px;
        padding: 6px 12px;
    }
    
    .manage-btn {
        border-radius: 8px;
    }
    
    .manage-progress-card {
        border-radius: 12px;
    }
</style>

<div class="container-fluid py-4">
    <div class="row">
        <div class="col-12">
            <div class="card shadow-sm manage-card">
                <div class="card-header bg-primary text-white">
                    <h4 class="mb-0"><i class="bi bi-gear me-2"></i>요양사 관리</h4>
                </div>
                <div class="card-body">
                    <!-- 탭 메뉴 -->
                    <ul class="nav nav-tabs mb-4" role="tablist">
                        <li class="nav-item" role="presentation">
                            <button class="nav-link active" data-bs-toggle="tab" data-bs-target="#schedule" type="button">
                                <i class="bi bi-calendar-week me-2"></i>근무 일정
                            </button>
                        </li>
                        <li class="nav-item" role="presentation">
                            <button class="nav-link" data-bs-toggle="tab" data-bs-target="#assignment" type="button">
                                <i class="bi bi-people-fill me-2"></i>담당 배정
                            </button>
                        </li>
                        <li class="nav-item" role="presentation">
                            <button class="nav-link" data-bs-toggle="tab" data-bs-target="#performance" type="button">
                                <i class="bi bi-graph-up me-2"></i>근무 평가
                            </button>
                        </li>
                        <li class="nav-item" role="presentation">
                            <button class="nav-link" data-bs-toggle="tab" data-bs-target="#vacation" type="button">
                                <i class="bi bi-calendar-x me-2"></i>휴가 관리
                            </button>
                        </li>
                    </ul>
                    
                    <!-- 탭 내용 -->
                    <div class="tab-content">
                        <!-- 근무 일정 -->
                        <div class="tab-pane fade show active" id="schedule">
                            <h5 class="mb-3">주간 근무 일정</h5>
                            <div class="table-responsive">
                                <table class="table table-bordered manage-table">
                                    <thead class="table-light">
                                        <tr>
                                            <th>요양사명</th>
                                            <th>월</th>
                                            <th>화</th>
                                            <th>수</th>
                                            <th>목</th>
                                            <th>금</th>
                                            <th>토</th>
                                            <th>일</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <tr>
                                            <td>김미선</td>
                                            <td class="table-success">오전</td>
                                            <td class="table-success">오전</td>
                                            <td class="table-success">오전</td>
                                            <td class="table-success">오전</td>
                                            <td class="table-success">오전</td>
                                            <td>휴무</td>
                                            <td>휴무</td>
                                        </tr>
                                        <tr>
                                            <td>이정희</td>
                                            <td class="table-info">오후</td>
                                            <td class="table-info">오후</td>
                                            <td class="table-info">오후</td>
                                            <td class="table-info">오후</td>
                                            <td class="table-info">오후</td>
                                            <td>휴무</td>
                                            <td>휴무</td>
                                        </tr>
                                        <tr>
                                            <td>박선영</td>
                                            <td class="table-warning">야간</td>
                                            <td class="table-warning">야간</td>
                                            <td class="table-warning">야간</td>
                                            <td>휴무</td>
                                            <td>휴무</td>
                                            <td class="table-warning">야간</td>
                                            <td class="table-warning">야간</td>
                                        </tr>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                        
                        <!-- 담당 배정 -->
                        <div class="tab-pane fade" id="assignment">
                            <h5 class="mb-3">노약자-요양사 매칭</h5>
                            <div class="table-responsive">
                                <table class="table table-hover">
                                    <thead class="table-light">
                                        <tr>
                                            <th>노약자명</th>
                                            <th>담당 요양사</th>
                                            <th>배정일</th>
                                            <th>상태</th>
                                            <th>관리</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <tr>
                                            <td>홍길동 (75세)</td>
                                            <td>김미선 요양사</td>
                                            <td>2025-01-15</td>
                                            <td><span class="badge bg-success">진행중</span></td>
                                            <td>
                                                <button class="btn btn-sm btn-outline-primary">변경</button>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>이순자 (82세)</td>
                                            <td>이정희 요양사</td>
                                            <td>2025-02-01</td>
                                            <td><span class="badge bg-success">진행중</span></td>
                                            <td>
                                                <button class="btn btn-sm btn-outline-primary">변경</button>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>박철수 (78세)</td>
                                            <td>미배정</td>
                                            <td>-</td>
                                            <td><span class="badge bg-warning">대기중</span></td>
                                            <td>
                                                <button class="btn btn-sm btn-primary">배정</button>
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                        
                        <!-- 근무 평가 -->
                        <div class="tab-pane fade" id="performance">
                            <h5 class="mb-3">월간 근무 평가</h5>
                            <div class="row">
                                <div class="col-md-6">
                                    <div class="card mb-3">
                                        <div class="card-body">
                                            <h6>김미선 요양사</h6>
                                            <div class="mb-2">
                                                <small>평가 점수</small>
                                                <div class="progress">
                                                    <div class="progress-bar bg-success" style="width: 95%">95점</div>
                                                </div>
                                            </div>
                                            <div class="mb-2">
                                                <small>출근율</small>
                                                <div class="progress">
                                                    <div class="progress-bar bg-info" style="width: 100%">100%</div>
                                                </div>
                                            </div>
                                            <div>
                                                <small>만족도</small>
                                                <div class="progress">
                                                    <div class="progress-bar bg-warning" style="width: 92%">92%</div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="card mb-3">
                                        <div class="card-body">
                                            <h6>이정희 요양사</h6>
                                            <div class="mb-2">
                                                <small>평가 점수</small>
                                                <div class="progress">
                                                    <div class="progress-bar bg-success" style="width: 88%">88점</div>
                                                </div>
                                            </div>
                                            <div class="mb-2">
                                                <small>출근율</small>
                                                <div class="progress">
                                                    <div class="progress-bar bg-info" style="width: 98%">98%</div>
                                                </div>
                                            </div>
                                            <div>
                                                <small>만족도</small>
                                                <div class="progress">
                                                    <div class="progress-bar bg-warning" style="width: 90%">90%</div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        
                        <!-- 휴가 관리 -->
                        <div class="tab-pane fade" id="vacation">
                            <h5 class="mb-3">휴가 신청 내역</h5>
                            <div class="table-responsive">
                                <table class="table table-hover">
                                    <thead class="table-light">
                                        <tr>
                                            <th>요양사명</th>
                                            <th>휴가 종류</th>
                                            <th>시작일</th>
                                            <th>종료일</th>
                                            <th>일수</th>
                                            <th>상태</th>
                                            <th>관리</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <tr>
                                            <td>박선영</td>
                                            <td>연차</td>
                                            <td>2025-11-20</td>
                                            <td>2025-11-22</td>
                                            <td>3일</td>
                                            <td><span class="badge bg-warning">대기중</span></td>
                                            <td>
                                                <button class="btn btn-sm btn-success">승인</button>
                                                <button class="btn btn-sm btn-danger">거부</button>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>최은주</td>
                                            <td>병가</td>
                                            <td>2025-11-10</td>
                                            <td>2025-11-12</td>
                                            <td>3일</td>
                                            <td><span class="badge bg-success">승인</span></td>
                                            <td>-</td>
                                        </tr>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

