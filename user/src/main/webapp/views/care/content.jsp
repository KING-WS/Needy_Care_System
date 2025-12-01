<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<style>
    /* ---------------------------------------------------- */
    /* 1. 글로벌 스타일 및 변수 추가 */
    /* ---------------------------------------------------- */
    :root {
        --primary-color: #007bff; /* 파란색 계열의 주 색상 */
        --secondary-color: #343a40; /* 진한 회색 계열의 보조 색상 */
        --success-color: #28a745;
        --warning-color: #ffc107;
        --danger-color: #dc3545;
        --light-bg: #f8f9fa; /* 밝은 배경색 */
        --card-bg: white;
    }

    body {
        background-color: var(--light-bg);
    }

    /* ---------------------------------------------------- */
    /* 2. 레이아웃 컨테이너 스타일 개선 */
    /* ---------------------------------------------------- */
    .care-container {
        padding: 30px 15px; /* 양쪽 패딩 추가 */
        max-width: 1200px; /* 최대 너비 설정 */
        margin: 0 auto; /* 중앙 정렬 */
    }

    /* ---------------------------------------------------- */
    /* 3. 카드 스타일 개선 */
    /* ---------------------------------------------------- */
    .care-card {
        background: var(--card-bg);
        border-radius: 15px;
        /* box-shadow 강화 및 입체감 부여 */
        box-shadow: 0 10px 30px rgba(0, 0, 0, 0.08);
        border: 1px solid #e9ecef; /* 경계선 추가 */
        padding: 30px;
        margin-bottom: 30px;
        transition: all 0.4s cubic-bezier(0.25, 0.8, 0.25, 1);
    }

    .care-card:hover {
        transform: translateY(-7px); /* 호버 시 이동 거리 증가 */
        box-shadow: 0 15px 40px rgba(0, 0, 0, 0.15); /* 호버 시 그림자 강화 */
    }

    /* ---------------------------------------------------- */
    /* 4. 섹션 헤더 스타일 개선 */
    /* ---------------------------------------------------- */
    .section-header {
        margin-bottom: 25px;
        padding-bottom: 15px;
        /* border-bottom 스타일 변경: 더 굵고 색상 변화 */
        border-bottom: 3px solid var(--primary-color);
        opacity: 0.8; /* 경계선의 투명도 조절 */
        display: flex;
        align-items: center;
        gap: 12px;
    }

    .section-header i {
        color: var(--primary-color);
        font-size: 26px; /* 아이콘 크기 약간 증가 */
    }

    .section-header h3 {
        margin: 0;
        font-size: 24px; /* 제목 크기 약간 증가 */
        font-weight: 700; /* 폰트 두께 강화 */
        color: var(--secondary-color);
    }

    /* ---------------------------------------------------- */
    /* 5. AI 조언 박스 스타일 유지 및 개선 */
    /* ---------------------------------------------------- */
    .advice-box {
        /* 배경 그라데이션 유지 */
        background: linear-gradient(135deg, #f0f8ff 0%, #e3f2fd 100%);
        border-radius: 12px;
        padding: 25px;
        /* border-left 색상 주 색상으로 변경 */
        border-left: 5px solid var(--primary-color);
    }
    .advice-text {
        font-size: 20px; /* 폰트 크기 약간 증가 */
        line-height: 1.7;
        color: var(--secondary-color);
        white-space: pre-line;
    }

    /* ---------------------------------------------------- */
    /* 6. 비디오 그리드/카드 스타일 개선 */
    /* ---------------------------------------------------- */
    .video-grid {
        display: grid;
        grid-template-columns: repeat(auto-fill, minmax(280px, 1fr)); /* 최소 너비 약간 감소 */
        gap: 20px; /* 간격 조정 */
    }
    .video-card {
        background: var(--card-bg);
        border-radius: 12px; /* 둥근 모서리 약간 증가 */
        overflow: hidden;
        box-shadow: 0 3px 10px rgba(0, 0, 0, 0.05);
        transition: all 0.3s ease;
        cursor: pointer;
        border: 1px solid #dee2e6;
    }
    .video-card:hover {
        transform: translateY(-8px);
        box-shadow: 0 15px 30px rgba(0, 0, 0, 0.15);
        border-color: var(--primary-color); /* 호버 시 경계선 색상 변경 */
    }
    .video-thumb {
        width: 100%;
        height: 160px; /* 썸네일 높이 약간 감소 */
        background-color: #000;
        position: relative;
    }
    .video-thumb img {
        width: 100%;
        height: 100%;
        object-fit: cover;
    }
    .video-info {
        padding: 15px;
    }
    .video-title {
        font-weight: 700;
        font-size: 17px;
        margin-bottom: 5px;
        display: -webkit-box;
        -webkit-line-clamp: 2;
        -webkit-box-orient: vertical;
        overflow: hidden;
        height: 44px;
        color: var(--secondary-color);
    }
    .video-channel {
        font-size: 14px;
        color: #6c757d;
        display: flex;
        align-items: center;
        gap: 5px;
    }

    /* ---------------------------------------------------- */
    /* 7. 블로그/혜택 리스트 스타일 개선 */
    /* ---------------------------------------------------- */
    .blog-list {
        display: flex;
        flex-direction: column;
        gap: 15px;
    }
    .blog-item {
        display: flex;
        align-items: center;
        padding: 15px 20px;
        background: var(--card-bg);
        border: 1px solid #e9ecef;
        border-radius: 12px;
        transition: all 0.3s ease;
        text-decoration: none;
        color: inherit;
        box-shadow: 0 2px 10px rgba(0,0,0,0.05);
    }
    .blog-item:hover {
        background: #f8f9fa;
        border-color: var(--primary-color);
        transform: translateX(5px);
        box-shadow: 0 5px 15px rgba(0,0,0,0.1);
    }
    .blog-icon {
        width: 50px; /* 크기 약간 감소 */
        height: 50px;
        background: #e9f5ff; /* 연한 파란색 배경 */
        border-radius: 8px; /* 모서리 둥글게 */
        display: flex;
        align-items: center;
        justify-content: center;
        margin-right: 15px;
        color: var(--primary-color);
        font-size: 20px;
        overflow: hidden;
        flex-shrink: 0;
    }
    .blog-thumbnail {
        width: 100%;
        height: 100%;
        object-fit: cover;
    }
    .blog-content h5 {
        margin: 0 0 5px 0;
        font-size: 17px;
        font-weight: 600;
        color: var(--secondary-color);
    }
    .blog-content p {
        margin: 0;
        font-size: 14px;
        color: #6c757d;
    }
    .blog-content small {
        font-size: 12px;
        color: #adb5bd;
    }

    /* ---------------------------------------------------- */
    /* 8. 로딩 스피너 및 유틸리티 스타일 추가 */
    /* ---------------------------------------------------- */
    .loading-spinner {
        display: none;
        text-align: center;
        padding: 80px;
        position: relative;
        z-index: 1000;
        background: rgba(255, 255, 255, 0.7); /* 반투명 배경 */
        border-radius: 15px;
    }
    .spinner-border {
        width: 4rem;
        height: 4rem;
        border-width: 0.4em;
    }
    .loading-spinner h5 {
        font-size: 1.1rem;
        font-weight: 500;
        color: var(--primary-color) !important;
    }

    /* 혜택 정보 AI 요약 버튼 스타일 */
    .btn-outline-primary.active {
        color: white;
        background-color: var(--primary-color);
        border-color: var(--primary-color);
    }
</style>

<div class="care-container">
    <div class="text-center mb-4">
        <h1 style="font-size: 38px; font-weight: 800; color: var(--secondary-color); text-shadow: 0 1px 2px rgba(0, 0, 0, 0.05);">
            <i class="fas fa-heartbeat" style="color: var(--primary-color);"></i> 맞춤 돌봄 콘텐츠
        </h1>
        <p style="font-size: 16px; color: #666; margin-top: 10px;">
            AI가 분석한 ${selectedRecipient.recName}님을 위한 맞춤 콘텐츠입니다.
        </p>
    </div>

    <div class="d-flex justify-content-end align-items-center mb-4">
        <div class="d-flex gap-2">
            <select id="recipientSelect" class="form-select" style="width: 200px;"
                    onchange="changeRecipient(this.value)">
                <c:forEach var="r" items="${recipientList}">
                    <option value="${r.recId}" ${r.recId == selectedRecipient.recId ?
                            'selected' : ''}>
                            ${r.recName}
                    </option>
                </c:forEach>
            </select>
            <button class="btn btn-primary" onclick="analyzeContent()">
                <i class="fas fa-sync-alt"></i> 분석 새로고침
            </button>
        </div>
    </div>

    <div id="loadingSpinner" class="loading-spinner">
        <div class="spinner-border text-primary" role="status">
            <span class="visually-hidden">Loading...</span>
        </div>
        <h5 class="mt-3 text-muted">AI가 노약자분의 건강 상태를 분석하여<br>최적의 돌봄 콘텐츠를 찾고 있습니다...</h5>
    </div>

    <div id="contentArea" style="display: none;">
        <div class="care-card" data-aos="fade-up">
            <div class="section-header">
                <i class="fas fa-robot"></i>
                <h3>AI 돌봄 가이드</h3>
            </div>
            <div class="advice-box">
                <div id="careAdvice" class="advice-text">
                </div>
            </div>
        </div>

        <div class="care-card" data-aos="fade-up" data-aos-delay="100">
            <div class="section-header">
                <i class="fab fa-youtube text-danger"></i>
                <h3>추천 돌봄 교육 영상</h3>
            </div>
            <div id="videoGrid" class="video-grid">
            </div>
        </div>

        <div class="care-card" data-aos="fade-up" data-aos-delay="200">
            <div class="section-header">
                <i class="fas fa-search text-primary"></i>
                <h3>추천 돌봄 교육 블로그</h3>
            </div>
            <div id="blogList" class="blog-list">
            </div>
        </div>

        <div class="care-card" data-aos="fade-up" data-aos-delay="300">
            <div class="section-header">
                <i class="fas fa-hand-holding-heart text-warning"></i>
                <h3>노약자 혜택 인사이트</h3>
            </div>
            <div id="benefitList" class="blog-list">
            </div>
        </div>
    </div>
</div>

<script>
    const currentRecId = "${selectedRecipient.recId}";

    $(document).ready(function() {
        if (currentRecId) {
            analyzeContent();
        }
    });

    function changeRecipient(recId) {
        location.href = '/care?recId=' + recId;
    }

    function analyzeContent() {
        $('#contentArea').hide();
        $('#loadingSpinner').fadeIn();

        $.ajax({
            url: '/care/api/analyze',
            type: 'POST',
            contentType: 'application/json',
            data: JSON.stringify({ recId: currentRecId }),
            success: function(response) {
                if (response.success) {
                    displayResults(response);
                } else {
                    alert('분석에 실패했습니다: ' + response.message);
                    $('#loadingSpinner').hide();
                    $('#contentArea').show();
                }
            },
            error: function(xhr, status, error) {
                console.error("Error:", error);
                alert('서버 통신 중 오류가 발생했습니다.');
                $('#loadingSpinner').hide();
                $('#contentArea').show();
            }
        });
    }

    function displayResults(data) {
        // 1. 조언 표시
        $('#careAdvice').text(data.careAdvice);

        // 2. 영상 검색 및 표시
        $('#videoGrid').empty();
        if (data.videoKeywords && data.videoKeywords.length > 0) {
            data.videoKeywords.forEach((keyword, index) => {
                searchAndAppendVideo(keyword, index);
            });
        } else {
            $('#videoGrid').html('<p class="text-muted">추천할 영상 키워드가 없습니다.</p>');
        }

        // 3. 블로그 키워드 표시
        $('#blogList').empty();
        if (data.blogKeywords && data.blogKeywords.length > 0) {
            data.blogKeywords.forEach((keyword, index) => {
                searchAndAppendBlog(keyword, index);
            });
        } else {
            $('#blogList').html('<p class="text-muted">추천할 정보 키워드가 없습니다.</p>');
        }

        // 4. 혜택 정보 표시
        $('#benefitList').empty();
        if (data.benefitKeywords && data.benefitKeywords.length > 0) {
            data.benefitKeywords.forEach((keyword, index) => {
                searchAndAppendBenefit(keyword, index);
            });
        } else {
            $('#benefitList').html('<p class="text-muted">추천할 혜택 정보가 없습니다.</p>');
        }

        $('#loadingSpinner').hide();
        $('#contentArea').fadeIn();
    }

    function searchAndAppendVideo(keyword, index) {
        // ID 중복 방지를 위해 문자열 결합 방식 사용
        const placeholderId = 'video-placeholder-' + index;
        const placeholderHtml = `
            <div id="\${placeholderId}" class="video-card placeholder-glow">
                <div class="video-thumb placeholder"></div>
                <div class="video-info">
                    <div class="video-title placeholder col-12"></div>
                    <div class="video-channel placeholder col-8"></div>
                </div>
            </div>
        `;
        $('#videoGrid').append(placeholderHtml);

        $.ajax({
            url: '/care/api/video-search',
            type: 'GET',
            data: { keyword: keyword },
            success: function(response) {
                if (response.success) {
                    const video = response;
                    const html = `
                        <div class="video-card" onclick="window.open('\${video.searchUrl}', '_blank')">
                            <div class="video-thumb">
                                <img src="\${video.thumbnailUrl || 'https://img.youtube.com/vi/' + video.videoId + '/mqdefault.jpg'}" alt="\${video.videoTitle}">
                            </div>
                            <div class="video-info">
                                <div class="video-title" title="\${video.videoTitle}">\${video.videoTitle}</div>
                                <div class="video-channel"><i class="fab fa-youtube text-danger"></i> \${video.channelTitle || 'YouTube'}</div>
                            </div>
                        </div>
                    `;
                    $(`#\${placeholderId}`).replaceWith(html);
                } else {
                    // 검색 실패 또는 결과 없음 시 대체 UI (API 키 없음 등)
                    const searchUrl = 'https://www.youtube.com/results?search_query=' + encodeURIComponent(keyword);
                    $(`#\${placeholderId}`).replaceWith(`
                        <div class="video-card" onclick="window.open('\${searchUrl}', '_blank')" style="cursor: pointer; transition: transform 0.2s;">
                            <div class="video-thumb d-flex flex-column align-items-center justify-content-center" style="background: linear-gradient(45deg, #282828, #3d3d3d);">
                                <i class="fab fa-youtube fa-3x text-danger mb-2" style="filter: drop-shadow(0 2px 5px rgba(0,0,0,0.5));"></i>
                                <span class="text-white badge bg-dark border border-secondary">영상 검색하러 가기</span>
                            </div>
                            <div class="video-info">
                                <div class="video-title text-primary">\${keyword}</div>
                                <div class="video-channel text-muted" style="font-size: 0.85rem;">
                                    <i class="fas fa-search me-1"></i>YouTube 검색 결과 보기
                                </div>
                            </div>
                        </div>
                     `);
                }
            },
            error: function() {
                const searchUrl = 'https://www.youtube.com/results?search_query=' + encodeURIComponent(keyword);
                $(`#\${placeholderId}`).replaceWith(`
                    <div class="video-card" onclick="window.open('\${searchUrl}', '_blank')" style="cursor: pointer;">
                        <div class="video-thumb d-flex flex-column align-items-center justify-content-center" style="background-color: #f8f9fa;">
                            <i class="fas fa-exclamation-circle fa-2x text-secondary mb-2"></i>
                            <span class="text-muted small">검색 정보를 불러올 수 없음</span>
                        </div>
                        <div class="video-info">
                            <div class="video-title">\${keyword}</div>
                            <div class="video-channel text-primary">
                                <i class="fas fa-external-link-alt me-1"></i>직접 검색하기
                            </div>
                        </div>
                    </div>
                `);
            }
        });
    }

    function searchAndAppendBlog(keyword, index) {
        const placeholderId = `blog-placeholder-\${index}`;
        // 로딩 중 표시 (플레이스홀더)
        const placeholderHtml = `
            <div id="\${placeholderId}" class="blog-item placeholder-glow">
                <div class="blog-icon" style="background: #eee;"></div>
                <div class="blog-content w-100">
                    <h5 class="placeholder col-8"></h5>
                    <p class="placeholder col-6"></p>
                </div>
            </div>
        `;
        $('#blogList').append(placeholderHtml);

        $.ajax({
            url: '/care/api/blog-search',
            type: 'GET',
            data: { keyword: keyword },
            success: function(response) {
                if (response.success && response.items && response.items.length > 0) {
                    const item = response.items[0]; // 첫 번째 검색 결과만 사용
                    // 썸네일이 있으면 이미지 표시, 없으면 아이콘 표시
                    const iconHtml = item.thumbnail ?
                        `<img src="\${item.thumbnail}" class="blog-thumbnail" alt="thumbnail" onerror="this.src='';this.parentElement.innerHTML='<i class=\\'fas fa-book-medical\\'></i>'">` :
                        `<i class="fas fa-book-medical"></i>`;

                    const html = `
                        <a href="\${item.link}" target="_blank" class="blog-item">
                            <div class="blog-icon" style="\${item.thumbnail ? 'padding:0; overflow:hidden;' : ''}">
                                \${iconHtml}
                            </div>
                            <div class="blog-content">
                                <h5 title="\${item.title}">\${item.title}</h5>
                                <p title="\${item.description}">\${item.description}</p>
                                <small class="text-muted">블로그: \${item.bloggername}</small>
                            </div>
                            <i class="fas fa-chevron-right ms-auto text-muted"></i>
                        </a>
                    `;
                    $(`#\${placeholderId}`).replaceWith(html);
                } else {
                    // 검색 결과가 없으면 네이버 검색 링크 제공
                    const searchUrl = 'https://search.naver.com/search.naver?query=' + encodeURIComponent(keyword);
                    const html = `
                        <a href="\${searchUrl}" target="_blank" class="blog-item">
                            <div class="blog-icon">
                                <i class="fas fa-search"></i>
                            </div>
                            <div class="blog-content">
                                <h5>\${keyword}</h5>
                                <p>네이버 검색 결과 바로가기</p>
                            </div>
                            <i class="fas fa-chevron-right ms-auto text-muted"></i>
                        </a>
                    `;
                    $(`#\${placeholderId}`).replaceWith(html);
                }
            },
            error: function() {
                // 에러 시에도 네이버 검색 링크 제공
                const searchUrl = 'https://search.naver.com/search.naver?query=' + encodeURIComponent(keyword);
                const html = `
                    <a href="\${searchUrl}" target="_blank" class="blog-item">
                        <div class="blog-icon">
                            <i class="fas fa-search"></i>
                        </div>
                        <div class="blog-content">
                            <h5>\${keyword}</h5>
                            <p>네이버 검색 결과 바로가기 (오류 발생)</p>
                        </div>
                        <i class="fas fa-chevron-right ms-auto text-muted"></i>
                    </a>
                `;
                $(`#\${placeholderId}`).replaceWith(html);
            }
        });
    }

    function searchAndAppendBenefit(keyword, index) {
        // ID 중복 방지를 위해 문자열 결합 방식 사용
        const placeholderId = 'benefit-placeholder-' + index;
        const placeholderHtml = `
            <div id="\${placeholderId}" class="blog-item placeholder-glow">
                <div class="blog-icon" style="background: #fff3cd; color: #ffc107;">
                    <i class="fas fa-gift"></i>
                </div>
                <div class="blog-content w-100">
                    <h5 class="placeholder col-8"></h5>
                    <p class="placeholder col-6"></p>
                </div>
            </div>
        `;
        $('#benefitList').append(placeholderHtml);

        // 순차적 요청을 위해 딜레이 적용
        setTimeout(() => {
            $.ajax({
                url: '/care/api/news-search',
                type: 'GET',
                data: { keyword: keyword },
                success: function(response) {
                    if (response.success && response.items && response.items.length > 0) {
                        const item = response.items[0];
                        const summaryId = 'summary-' + index;
                        const safeTitle = item.title.replace(/"/g, '&quot;');
                        const safeDesc = item.description.replace(/"/g, '&quot;');

                        const html = `
                            <div class="blog-item d-block p-0" id="\${placeholderId}">
                                <div class="d-flex align-items-center p-3" style="background: white; border-radius: 10px;">
                                    <div class="blog-icon" style="background: #fff3cd; color: #ffc107;">
                                        <i class="fas fa-hand-holding-usd"></i>
                                    </div>
                                    <div class="blog-content flex-grow-1">
                                        <div class="d-flex justify-content-between align-items-start">
                                            <div>
                                                <h5 title="\${safeTitle}" style="margin-bottom: 5px;">\${item.title}</h5>
                                                <small class="text-muted">\${item.source ||
                                                    '뉴스'} | \${item.date || ''}</small>
                                            </div>
                                            <button class="btn btn-sm btn-outline-primary ms-2 text-nowrap"
                                                    onclick="toggleSummary(this, '\${summaryId}')"
                                                    data-title="\${safeTitle}"
                                                    data-desc="\${safeDesc}">
                                                <i class="fas fa-robot me-1"></i>AI 요약 보기
                                            </button>
                                        </div>
                                        <div class="mt-2">
                                            <a href="\${item.link}" target="_blank" class="text-decoration-none text-muted" style="font-size: 0.9rem;">
                                                <i class="fas fa-link me-1"></i>원문 보기
                                            </a>
                                        </div>
                                    </div>
                                </div>
                                <div id="\${summaryId}" class="bg-light border-top p-3" style="display: none;">
                                    <div class="d-flex align-items-center mb-2">
                                        <i class="fas fa-magic text-primary me-2"></i>
                                        <strong>AI 핵심 요약</strong>
                                    </div>
                                    <div class="summary-content text-dark" style="font-size: 0.95rem; line-height: 1.6;"></div>
                                </div>
                            </div>
                        `;
                        $(`#\${placeholderId}`).replaceWith(html);
                    } else {
                        const searchUrl = 'https://search.naver.com/search.naver?where=news&query=' + encodeURIComponent(keyword);
                        const html = `
                            <a href="\${searchUrl}" target="_blank" class="blog-item">
                                <div class="blog-icon" style="background: #fff3cd; color: #ffc107;">
                                    <i class="fas fa-search"></i>
                                </div>
                                <div class="blog-content">
                                    <h5>\${keyword}</h5>
                                    <p>관련 혜택 정보 검색하기</p>
                                </div>
                                <i class="fas fa-chevron-right ms-auto text-muted"></i>
                            </a>
                        `;
                        $(`#\${placeholderId}`).replaceWith(html);
                    }
                },
                error: function() {
                    const searchUrl =
                        'https://search.naver.com/search.naver?where=news&query=' + encodeURIComponent(keyword);
                    const html = `
                        <a href="\${searchUrl}" target="_blank" class="blog-item">
                            <div class="blog-icon" style="background: #fff3cd; color: #ffc107;">
                                <i class="fas fa-exclamation-triangle"></i>
                            </div>
                            <div class="blog-content">
                                <h5>\${keyword}</h5>
                                <p>검색 중 오류가 발생했습니다. 직접 검색하기</p>
                            </div>
                            <i class="fas fa-chevron-right ms-auto text-muted"></i>
                        </a>
                    `;
                    $(`#\${placeholderId}`).replaceWith(html);
                }
            });
        }, index * 300); // 0.3초 간격으로 순차 실행
    }

    function toggleSummary(btn, summaryId) {
        const container = $(`#\${summaryId}`);
        const contentDiv = container.find('.summary-content');
        const $btn = $(btn);
        const title = $btn.data('title');
        const desc = $btn.data('desc');

        if (container.is(':visible')) {
            container.slideUp();
            $btn.html('<i class="fas fa-robot me-1"></i>AI 요약 보기');
            $btn.removeClass('active');
        } else {
            container.slideDown();
            $btn.html('<i class="fas fa-chevron-up me-1"></i>접기');
            $btn.addClass('active');

            // 이미 로드된 내용이 없으면 AI 요청
            if (contentDiv.text().trim() === '') {
                contentDiv.html('<div class="d-flex align-items-center"><div class="spinner-border spinner-border-sm text-primary me-2" role="status"></div> AI가 혜택 정보를 분석하고 있습니다...</div>');
                $.ajax({
                    url: '/care/api/summarize-benefit',
                    type: 'POST',
                    contentType: 'application/json',
                    data: JSON.stringify({
                        benefitName: title,
                        description: desc
                    }),
                    success: function(response) {
                        if (response.success) {
                            contentDiv.html(response.summary.replace(/\n/g, '<br>'));
                        } else {
                            contentDiv.html('<span class="text-danger"><i class="fas fa-exclamation-circle me-1"></i>요약을 불러오지 못했습니다.</span>');
                        }
                    },
                    error: function() {
                        contentDiv.html('<span class="text-danger"><i class="fas fa-exclamation-circle me-1"></i>오류가 발생했습니다.</span>');
                    }
                });
            }
        }
    }
</script>