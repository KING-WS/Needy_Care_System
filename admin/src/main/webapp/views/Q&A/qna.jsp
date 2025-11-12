<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<style>
    .qna-card {
        border-radius: 15px;
        overflow: hidden;
    }
    
    .qna-card .card-header {
        border-radius: 15px 15px 0 0;
    }
    
    .qna-new-btn {
        border-radius: 12px;
        padding: 12px 24px;
    }
    
    .qna-table {
        border-radius: 10px;
        overflow: hidden;
    }
    
    .qna-table thead th {
        background-color: #f8f9fa;
        border: none;
        padding: 15px;
    }
    
    .qna-table tbody td {
        padding: 15px;
        vertical-align: middle;
    }
    
    .qna-badge {
        border-radius: 8px;
        padding: 6px 12px;
    }
</style>

<div class="container-fluid py-4">
    <div class="row">
        <div class="col-12">
            <div class="card shadow-sm qna-card">
                <div class="card-header bg-primary text-white">
                    <h4 class="mb-0"><i class="bi bi-question-circle me-2"></i>Q&A</h4>
                </div>
                <div class="card-body">
                    <div class="mb-4">
                        <button class="btn btn-primary qna-new-btn" data-bs-toggle="modal" data-bs-target="#qnaModal">
                            <i class="bi bi-plus-circle me-2"></i>새 질문 작성
                        </button>
                    </div>
                    
                    <div class="table-responsive">
                        <table class="table table-hover qna-table">
                            <thead class="table-light">
                                <tr>
                                    <th width="60">번호</th>
                                    <th>제목</th>
                                    <th width="120">작성자</th>
                                    <th width="120">작성일</th>
                                    <th width="80">상태</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td>1</td>
                                    <td><a href="#" class="text-decoration-none">시스템 사용 방법 문의</a></td>
                                    <td>홍길동</td>
                                    <td>2025-11-11</td>
                                    <td><span class="badge bg-success qna-badge">답변완료</span></td>
                                </tr>
                                <tr>
                                    <td>2</td>
                                    <td><a href="#" class="text-decoration-none">결제 오류 문의</a></td>
                                    <td>김철수</td>
                                    <td>2025-11-10</td>
                                    <td><span class="badge bg-warning qna-badge">대기중</span></td>
                                </tr>
                                <tr>
                                    <td>3</td>
                                    <td><a href="#" class="text-decoration-none">회원가입 문제</a></td>
                                    <td>이영희</td>
                                    <td>2025-11-09</td>
                                    <td><span class="badge bg-success qna-badge">답변완료</span></td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Q&A 작성 모달 -->
<div class="modal fade" id="qnaModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content" style="border-radius: 15px;">
            <div class="modal-header" style="border-radius: 15px 15px 0 0;">
                <h5 class="modal-title">새 질문 작성</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <form>
                    <div class="mb-3">
                        <label class="form-label">제목</label>
                        <input type="text" class="form-control" placeholder="질문 제목을 입력하세요" style="border-radius: 10px;">
                    </div>
                    <div class="mb-3">
                        <label class="form-label">내용</label>
                        <textarea class="form-control" rows="5" placeholder="질문 내용을 입력하세요" style="border-radius: 10px;"></textarea>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal" style="border-radius: 10px;">취소</button>
                <button type="button" class="btn btn-primary" style="border-radius: 10px;">등록</button>
            </div>
        </div>
    </div>
</div>

