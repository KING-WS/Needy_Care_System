<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<style>
    .search-card {
        border-radius: 15px;
        overflow: hidden;
    }
    
    .search-card .card-header {
        border-radius: 15px 15px 0 0;
    }
    
    .search-input {
        border-radius: 10px;
    }
    
    .search-btn {
        border-radius: 10px;
        padding: 10px 24px;
    }
    
    .result-table {
        border-radius: 10px;
        overflow: hidden;
    }
</style>

<div class="container-fluid py-4">
    <div class="row">
        <div class="col-12">
            <div class="card shadow-sm mb-4 search-card">
                <div class="card-header bg-primary text-white">
                    <h4 class="mb-0"><i class="bi bi-search me-2"></i>고객 검색</h4>
                </div>
                <div class="card-body">
                    <form id="customerSearchForm">
                        <div class="row mb-3">
                            <div class="col-md-4">
                                <label for="searchType" class="form-label">검색 조건</label>
                                <select class="form-select search-input" id="searchType">
                                    <option value="name">고객명</option>
                                    <option value="email">이메일</option>
                                    <option value="phone">연락처</option>
                                </select>
                            </div>
                            <div class="col-md-6">
                                <label for="searchKeyword" class="form-label">검색어</label>
                                <input type="text" class="form-control search-input" id="searchKeyword" placeholder="검색어를 입력하세요">
                            </div>
                            <div class="col-md-2 d-flex align-items-end">
                                <button type="submit" class="btn btn-primary search-btn w-100">
                                    <i class="bi bi-search me-1"></i>검색
                                </button>
                            </div>
                        </div>
                    </form>
                    
                    <hr>
                    
                    <div id="searchResults">
                        <div class="alert alert-info">
                            <i class="bi bi-info-circle me-2"></i>검색 조건을 입력하고 검색 버튼을 클릭하세요.
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    document.getElementById('customerSearchForm').addEventListener('submit', function(e) {
        e.preventDefault();
        const keyword = document.getElementById('searchKeyword').value;
        
        if(!keyword) {
            alert('검색어를 입력하세요.');
            return;
        }
        
        // 검색 결과 표시 (예시)
        document.getElementById('searchResults').innerHTML = `
            <div class="table-responsive result-table">
                <table class="table table-hover">
                    <thead class="table-light">
                        <tr>
                            <th>고객명</th>
                            <th>이메일</th>
                            <th>연락처</th>
                            <th>구독 등급</th>
                            <th>가입일</th>
                            <th>상태</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td colspan="6" class="text-center text-muted">검색 결과가 없습니다.</td>
                        </tr>
                    </tbody>
                </table>
            </div>
        `;
    });
</script>

