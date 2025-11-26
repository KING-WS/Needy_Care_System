<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<style>
    .care-container {
        padding: 30px;
    }
    .care-card {
        background: white;
        border-radius: 15px;
        box-shadow: 0 5px 20px rgba(0,0,0,0.05);
        padding: 30px;
        margin-bottom: 30px;
        transition: transform 0.3s;
    }
    .care-card:hover {
        transform: translateY(-5px);
    }
    .section-header {
        margin-bottom: 25px;
        padding-bottom: 15px;
        border-bottom: 2px solid #f0f0f0;
        display: flex;
        align-items: center;
        gap: 10px;
    }
    .section-header i {
        color: var(--primary-color);
        font-size: 24px;
    }
    .section-header h3 {
        margin: 0;
        font-size: 22px;
        font-weight: 600;
        color: var(--secondary-color);
    }
    .advice-box {
        background: linear-gradient(135deg, #f6f9fc 0%, #f1f4f8 100%);
        border-radius: 12px;
        padding: 25px;
        border-left: 5px solid var(--primary-color);
    }
    .advice-text {
        font-size: 16px;
        line-height: 1.8;
        color: #444;
        white-space: pre-line;
    }
    .video-grid {
        display: grid;
        grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
        gap: 25px;
    }
    .video-card {
        background: white;
        border-radius: 10px;
        overflow: hidden;
        box-shadow: 0 3px 10px rgba(0,0,0,0.1);
        transition: all 0.3s;
        cursor: pointer;
        border: 1px solid #eee;
    }
    .video-card:hover {
        transform: translateY(-5px);
        box-shadow: 0 10px 20px rgba(0,0,0,0.15);
    }
    .video-thumb {
        width: 100%;
        height: 180px;
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
        font-weight: 600;
        font-size: 16px;
        margin-bottom: 8px;
        display: -webkit-box;
        -webkit-line-clamp: 2;
        -webkit-box-orient: vertical;
        overflow: hidden;
        height: 48px;
    }
    .video-channel {
        font-size: 13px;
        color: #666;
    }
    .blog-list {
        display: flex;
        flex-direction: column;
        gap: 15px;
    }
    .blog-item {
        display: flex;
        align-items: center;
        padding: 15px;
        background: white;
        border: 1px solid #eee;
        border-radius: 10px;
        transition: all 0.2s;
        text-decoration: none;
        color: inherit;
    }
    .blog-item:hover {
        background: #f8f9fa;
        border-color: var(--primary-color);
        transform: translateX(5px);
    }
    .blog-icon {
        width: 60px;
        height: 60px;
        background: #e3f2fd;
        border-radius: 10px;
        display: flex;
        align-items: center;
        justify-content: center;
        margin-right: 15px;
        color: var(--primary-color);
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
        font-size: 16px;
        font-weight: 600;
    }
    .blog-content p {
        margin: 0;
        font-size: 13px;
        color: #666;
    }
    .loading-spinner {
        display: none;
        text-align: center;
        padding: 50px;
    }
    .spinner-border {
        width: 3rem;
        height: 3rem;
    }
</style>

<div class="care-container">
    <!-- 상단: 대상자 선택 -->
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2><i class="fas fa-heartbeat text-danger me-2"></i>맞춤 돌봄 콘텐츠</h2>
        <div class="d-flex gap-2">
            <select id="recipientSelect" class="form-select" style="width: 200px;" onchange="changeRecipient(this.value)">
                <c:forEach var="r" items="${recipientList}">
                    <option value="${r.recId}" ${r.recId == selectedRecipient.recId ? 'selected' : ''}>
                        ${r.recName}
                    </option>
                </c:forEach>
            </select>
            <button class="btn btn-primary" onclick="analyzeContent()">
                <i class="fas fa-sync-alt"></i> 분석 새로고침
            </button>
        </div>
    </div>

    <!-- 로딩 스피너 -->
    <div id="loadingSpinner" class="loading-spinner">
        <div class="spinner-border text-primary" role="status">
            <span class="visually-hidden">Loading...</span>
        </div>
        <h5 class="mt-3 text-muted">AI가 노약자분의 건강 상태를 분석하여<br>최적의 돌봄 콘텐츠를 찾고 있습니다...</h5>
    </div>

    <!-- 메인 콘텐츠 영역 -->
    <div id="contentArea" style="display: none;">
        <!-- 1. AI 돌봄 조언 -->
        <div class="care-card" data-aos="fade-up">
            <div class="section-header">
                <i class="fas fa-robot"></i>
                <h3>AI 돌봄 가이드</h3>
            </div>
            <div class="advice-box">
                <div id="careAdvice" class="advice-text">
                    <!-- AI 조언 내용이 여기에 들어갑니다 -->
                </div>
            </div>
        </div>

        <!-- 2. 추천 영상 -->
        <div class="care-card" data-aos="fade-up" data-aos-delay="100">
            <div class="section-header">
                <i class="fab fa-youtube text-danger"></i>
                <h3>추천 돌봄 교육 영상</h3>
            </div>
            <div id="videoGrid" class="video-grid">
                <!-- 영상 카드들이 여기에 동적으로 추가됩니다 -->
            </div>
        </div>

        <!-- 3. 관련 정보 검색 -->
        <div class="care-card" data-aos="fade-up" data-aos-delay="200">
            <div class="section-header">
                <i class="fas fa-search text-primary"></i>
                <h3>관련 정보 검색</h3>
            </div>
            <div id="blogList" class="blog-list">
                <!-- 블로그/정보 링크들이 여기에 동적으로 추가됩니다 -->
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

        $('#loadingSpinner').hide();
        $('#contentArea').fadeIn();
    }

    function searchAndAppendVideo(keyword, index) {
        const placeholderId = `video-placeholder-\${index}`;
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
                     $(`#\${placeholderId}`).replaceWith(`
                        <div class="video-card p-3 text-center text-muted">
                            <i class="fas fa-exclamation-circle mb-2"></i><br>
                            '\${keyword}' 검색 결과 없음
                        </div>
                     `);
                }
            },
            error: function() {
                $(`#\${placeholderId}`).remove();
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
</script>