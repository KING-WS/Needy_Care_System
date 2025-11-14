<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<style>
    .caregiver-card {
        transition: transform 0.3s ease, box-shadow 0.3s ease;
        cursor: pointer;
        height: 100%;
    }
    
    .caregiver-card:hover {
        transform: translateY(-5px);
        box-shadow: 0 10px 20px rgba(0,0,0,0.1);
    }
    
    .caregiver-photo {
        width: 100%;
        height: 200px;
        object-fit: cover;
        border-radius: 8px 8px 0 0;
    }
    
    .caregiver-info {
        padding: 1rem;
        background: white;
        border-radius: 0 0 8px 8px;
    }
    
    .caregiver-name {
        font-size: 1.1rem;
        font-weight: 600;
        margin-bottom: 0.5rem;
        color: #333;
    }
    
    .caregiver-details {
        font-size: 0.9rem;
        color: #666;
    }
    
    .status-badge {
        position: absolute;
        top: 10px;
        right: 10px;
        z-index: 1;
    }
</style>

<div class="container-fluid py-4">
    <div class="row mb-4">
        <div class="col-12">
            <div class="d-flex justify-content-between align-items-center">
                <div>
                    <h3 class="mb-1"><i class="bi bi-hospital me-2"></i>요양사 목록</h3>
                    <p class="text-muted mb-0">등록된 요양사를 확인하고 관리할 수 있습니다</p>
                </div>
                <div>
                    <button class="btn btn-primary" onclick="location.href='<c:url value="/caregiver-add"/>'">
                        <i class="bi bi-person-plus-fill me-2"></i>요양사 등록
                    </button>
                </div>
            </div>
        </div>
    </div>
    
    <!-- 검색 및 필터 -->
    <div class="row mb-4">
        <div class="col-12">
            <div class="card shadow-sm">
                <div class="card-body">
                    <div class="row g-3">
                        <div class="col-md-3">
                            <input type="text" class="form-control" placeholder="이름 검색...">
                        </div>
                        <div class="col-md-3">
                            <select class="form-select">
                                <option>전체 상태</option>
                                <option>근무중</option>
                                <option>휴무</option>
                                <option>퇴사</option>
                            </select>
                        </div>
                        <div class="col-md-3">
                            <select class="form-select">
                                <option>전체 자격증</option>
                                <option>요양보호사 1급</option>
                                <option>요양보호사 2급</option>
                                <option>간호조무사</option>
                            </select>
                        </div>
                        <div class="col-md-3">
                            <button class="btn btn-primary w-100">
                                <i class="bi bi-search me-2"></i>검색
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <!-- 통계 요약 -->
    <div class="row mb-4">
        <div class="col-md-3">
            <div class="card bg-primary text-white shadow-sm">
                <div class="card-body">
                    <h6 class="mb-2">전체 요양사</h6>
                    <h3 class="mb-0">24명</h3>
                </div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="card bg-success text-white shadow-sm">
                <div class="card-body">
                    <h6 class="mb-2">근무중</h6>
                    <h3 class="mb-0">18명</h3>
                </div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="card bg-warning text-white shadow-sm">
                <div class="card-body">
                    <h6 class="mb-2">휴무</h6>
                    <h3 class="mb-0">4명</h3>
                </div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="card bg-info text-white shadow-sm">
                <div class="card-body">
                    <h6 class="mb-2">신규 등록 (이번달)</h6>
                    <h3 class="mb-0">2명</h3>
                </div>
            </div>
        </div>
    </div>
    
    <!-- 요양사 카드 그리드 -->
    <div class="row g-4">
        <!-- 요양사 1 -->
        <div class="col-lg-4 col-md-6">
            <div class="card caregiver-card shadow-sm position-relative">
                <span class="badge bg-success status-badge">근무중</span>
                <img src="<c:url value='/assets/images/avatar-placeholder.svg'/>" 
                     class="caregiver-photo" 
                     alt="요양사 사진"
                     onerror="this.src='https://via.placeholder.com/400x300?text=Photo'">
                <div class="caregiver-info">
                    <div class="caregiver-name">김미선 요양사</div>
                    <div class="caregiver-details">
                        <p class="mb-1"><i class="bi bi-patch-check me-2"></i>요양보호사 1급</p>
                        <p class="mb-1"><i class="bi bi-calendar me-2"></i>경력: 5년</p>
                        <p class="mb-1"><i class="bi bi-telephone me-2"></i>010-1234-5678</p>
                        <p class="mb-1"><i class="bi bi-geo-alt me-2"></i>서울 강남구</p>
                    </div>
                    <div class="mt-3 d-flex gap-2">
                        <button class="btn btn-sm btn-outline-primary flex-fill">
                            <i class="bi bi-eye me-1"></i>상세보기
                        </button>
                        <button class="btn btn-sm btn-outline-secondary flex-fill">
                            <i class="bi bi-pencil me-1"></i>수정
                        </button>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- 요양사 2 -->
        <div class="col-lg-4 col-md-6">
            <div class="card caregiver-card shadow-sm position-relative">
                <span class="badge bg-success status-badge">근무중</span>
                <img src="<c:url value='/assets/images/avatar-placeholder.svg'/>" 
                     class="caregiver-photo" 
                     alt="요양사 사진"
                     onerror="this.src='https://via.placeholder.com/400x300?text=Photo'">
                <div class="caregiver-info">
                    <div class="caregiver-name">이정희 요양사</div>
                    <div class="caregiver-details">
                        <p class="mb-1"><i class="bi bi-patch-check me-2"></i>요양보호사 1급</p>
                        <p class="mb-1"><i class="bi bi-calendar me-2"></i>경력: 3년</p>
                        <p class="mb-1"><i class="bi bi-telephone me-2"></i>010-2345-6789</p>
                        <p class="mb-1"><i class="bi bi-geo-alt me-2"></i>서울 송파구</p>
                    </div>
                    <div class="mt-3 d-flex gap-2">
                        <button class="btn btn-sm btn-outline-primary flex-fill">
                            <i class="bi bi-eye me-1"></i>상세보기
                        </button>
                        <button class="btn btn-sm btn-outline-secondary flex-fill">
                            <i class="bi bi-pencil me-1"></i>수정
                        </button>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- 요양사 3 -->
        <div class="col-lg-4 col-md-6">
            <div class="card caregiver-card shadow-sm position-relative">
                <span class="badge bg-success status-badge">근무중</span>
                <img src="<c:url value='/assets/images/avatar-placeholder.svg'/>" 
                     class="caregiver-photo" 
                     alt="요양사 사진"
                     onerror="this.src='https://via.placeholder.com/400x300?text=Photo'">
                <div class="caregiver-info">
                    <div class="caregiver-name">박선영 요양사</div>
                    <div class="caregiver-details">
                        <p class="mb-1"><i class="bi bi-patch-check me-2"></i>간호조무사</p>
                        <p class="mb-1"><i class="bi bi-calendar me-2"></i>경력: 7년</p>
                        <p class="mb-1"><i class="bi bi-telephone me-2"></i>010-3456-7890</p>
                        <p class="mb-1"><i class="bi bi-geo-alt me-2"></i>서울 서초구</p>
                    </div>
                    <div class="mt-3 d-flex gap-2">
                        <button class="btn btn-sm btn-outline-primary flex-fill">
                            <i class="bi bi-eye me-1"></i>상세보기
                        </button>
                        <button class="btn btn-sm btn-outline-secondary flex-fill">
                            <i class="bi bi-pencil me-1"></i>수정
                        </button>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- 요양사 4 -->
        <div class="col-lg-4 col-md-6">
            <div class="card caregiver-card shadow-sm position-relative">
                <span class="badge bg-warning status-badge">휴무</span>
                <img src="<c:url value='/assets/images/avatar-placeholder.svg'/>" 
                     class="caregiver-photo" 
                     alt="요양사 사진"
                     onerror="this.src='https://via.placeholder.com/400x300?text=Photo'">
                <div class="caregiver-info">
                    <div class="caregiver-name">최은주 요양사</div>
                    <div class="caregiver-details">
                        <p class="mb-1"><i class="bi bi-patch-check me-2"></i>요양보호사 2급</p>
                        <p class="mb-1"><i class="bi bi-calendar me-2"></i>경력: 2년</p>
                        <p class="mb-1"><i class="bi bi-telephone me-2"></i>010-4567-8901</p>
                        <p class="mb-1"><i class="bi bi-geo-alt me-2"></i>서울 마포구</p>
                    </div>
                    <div class="mt-3 d-flex gap-2">
                        <button class="btn btn-sm btn-outline-primary flex-fill">
                            <i class="bi bi-eye me-1"></i>상세보기
                        </button>
                        <button class="btn btn-sm btn-outline-secondary flex-fill">
                            <i class="bi bi-pencil me-1"></i>수정
                        </button>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- 요양사 5 -->
        <div class="col-lg-4 col-md-6">
            <div class="card caregiver-card shadow-sm position-relative">
                <span class="badge bg-success status-badge">근무중</span>
                <img src="<c:url value='/assets/images/avatar-placeholder.svg'/>" 
                     class="caregiver-photo" 
                     alt="요양사 사진"
                     onerror="this.src='https://via.placeholder.com/400x300?text=Photo'">
                <div class="caregiver-info">
                    <div class="caregiver-name">정미숙 요양사</div>
                    <div class="caregiver-details">
                        <p class="mb-1"><i class="bi bi-patch-check me-2"></i>요양보호사 1급</p>
                        <p class="mb-1"><i class="bi bi-calendar me-2"></i>경력: 4년</p>
                        <p class="mb-1"><i class="bi bi-telephone me-2"></i>010-5678-9012</p>
                        <p class="mb-1"><i class="bi bi-geo-alt me-2"></i>서울 용산구</p>
                    </div>
                    <div class="mt-3 d-flex gap-2">
                        <button class="btn btn-sm btn-outline-primary flex-fill">
                            <i class="bi bi-eye me-1"></i>상세보기
                        </button>
                        <button class="btn btn-sm btn-outline-secondary flex-fill">
                            <i class="bi bi-pencil me-1"></i>수정
                        </button>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- 요양사 6 -->
        <div class="col-lg-4 col-md-6">
            <div class="card caregiver-card shadow-sm position-relative">
                <span class="badge bg-success status-badge">근무중</span>
                <img src="<c:url value='/assets/images/avatar-placeholder.svg'/>" 
                     class="caregiver-photo" 
                     alt="요양사 사진"
                     onerror="this.src='https://via.placeholder.com/400x300?text=Photo'">
                <div class="caregiver-info">
                    <div class="caregiver-name">한영희 요양사</div>
                    <div class="caregiver-details">
                        <p class="mb-1"><i class="bi bi-patch-check me-2"></i>요양보호사 1급</p>
                        <p class="mb-1"><i class="bi bi-calendar me-2"></i>경력: 6년</p>
                        <p class="mb-1"><i class="bi bi-telephone me-2"></i>010-6789-0123</p>
                        <p class="mb-1"><i class="bi bi-geo-alt me-2"></i>서울 강서구</p>
                    </div>
                    <div class="mt-3 d-flex gap-2">
                        <button class="btn btn-sm btn-outline-primary flex-fill">
                            <i class="bi bi-eye me-1"></i>상세보기
                        </button>
                        <button class="btn btn-sm btn-outline-secondary flex-fill">
                            <i class="bi bi-pencil me-1"></i>수정
                        </button>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <!-- 페이지네이션 -->
    <div class="row mt-4">
        <div class="col-12">
            <nav aria-label="Page navigation">
                <ul class="pagination justify-content-center">
                    <li class="page-item disabled">
                        <a class="page-link" href="#" tabindex="-1">이전</a>
                    </li>
                    <li class="page-item active"><a class="page-link" href="#">1</a></li>
                    <li class="page-item"><a class="page-link" href="#">2</a></li>
                    <li class="page-item"><a class="page-link" href="#">3</a></li>
                    <li class="page-item"><a class="page-link" href="#">4</a></li>
                    <li class="page-item">
                        <a class="page-link" href="#">다음</a>
                    </li>
                </ul>
            </nav>
        </div>
    </div>
</div>

