package edu.sm.app.service;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.util.UriComponentsBuilder;

import java.net.HttpURLConnection;
import java.net.URL;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Scanner;

import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;

/**
 * 네이버 검색 서비스
 * 키워드로 네이버 블로그/전문자료를 검색합니다.
 */
@Service
@Slf4j
public class NaverSearchService {
    
    private final ObjectMapper objectMapper;
    
    @Value("${naver.api.client-id:}")
    private String clientId;
    
    @Value("${naver.api.client-secret:}")
    private String clientSecret;
    
    private static final String NAVER_SEARCH_BLOG_URL = "https://openapi.naver.com/v1/search/blog.json";
    private static final String NAVER_SEARCH_NEWS_URL = "https://openapi.naver.com/v1/search/news.json";
    
    public NaverSearchService(ObjectMapper objectMapper) {
        this.objectMapper = objectMapper;
    }
    
    /**
     * 블로그 검색
     * @param keyword 검색어
     * @return 검색 결과 리스트 (제목, 링크, 요약, 썸네일 등)
     */
    public Map<String, Object> searchBlog(String keyword) {
        return search(keyword, NAVER_SEARCH_BLOG_URL, "blog");
    }

    /**
     * 뉴스 검색
     * @param keyword 검색어
     * @return 검색 결과 리스트
     */
    public Map<String, Object> searchNews(String keyword) {
        return search(keyword, NAVER_SEARCH_NEWS_URL, "news");
    }

    private Map<String, Object> search(String keyword, String searchUrl, String type) {
        Map<String, Object> result = new HashMap<>();
        List<Map<String, String>> items = new ArrayList<>();
        
        try {
            // API 키가 없으면 검색 링크만 제공하는 모드로 동작
            if (clientId == null || clientId.trim().isEmpty() || clientSecret == null) {
                log.warn("네이버 API 키가 설정되지 않았습니다.");
                result.put("success", false);
                result.put("message", "네이버 API 키가 설정되지 않았습니다.");
                return result;
            }
            
            log.info("네이버 {} 검색: {}", type, keyword);
            
            UriComponentsBuilder builder = UriComponentsBuilder.fromUriString(searchUrl)
                    .queryParam("query", keyword)
                    .queryParam("display", 1)  // 1개만 검색
                    .queryParam("start", 1)
                    .queryParam("sort", "sim"); // 정확도순
            
            URL url = new URL(builder.toUriString());
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("GET");
            conn.setRequestProperty("X-Naver-Client-Id", clientId);
            conn.setRequestProperty("X-Naver-Client-Secret", clientSecret);
            
            int responseCode = conn.getResponseCode();
            
            if (responseCode == 200) {
                Scanner scanner = new Scanner(conn.getInputStream(), "UTF-8");
                String responseBody = scanner.useDelimiter("\\A").next();
                scanner.close();
                
                JsonNode jsonNode = objectMapper.readTree(responseBody);
                JsonNode jsonItems = jsonNode.get("items");
                
                if (jsonItems != null && jsonItems.isArray()) {
                    for (JsonNode item : jsonItems) {
                        Map<String, String> searchItem = new HashMap<>();
                        // 태그 제거
                        String title = item.get("title").asText().replaceAll("<[^>]*>", "");
                        String description = item.get("description").asText().replaceAll("<[^>]*>", "");
                        String link = item.get("link").asText();
                        
                        searchItem.put("title", title);
                        searchItem.put("link", link);
                        searchItem.put("description", description);
                        
                        if (type.equals("blog")) {
                            searchItem.put("source", item.get("bloggername").asText());
                            searchItem.put("date", item.get("postdate").asText());
                            // 썸네일 추출 시도 (블로그만)
                            try {
                                String thumbnail = extractThumbnail(link);
                                if (thumbnail != null && !thumbnail.isEmpty()) {
                                    searchItem.put("thumbnail", thumbnail);
                                }
                            } catch (Exception e) {
                                log.warn("썸네일 추출 실패: {}", link);
                            }
                        } else { // news
                            searchItem.put("source", "네이버 뉴스"); // 뉴스는 언론사 정보가 별도 필드가 없거나 originallink에서 유추해야 함. 여기선 단순화
                            searchItem.put("date", item.get("pubDate").asText());
                        }
                        
                        items.add(searchItem);
                    }
                }
                
                result.put("success", true);
                result.put("items", items);
                if (!items.isEmpty()) {
                    result.put("firstItem", items.get(0));
                }
                log.info("네이버 {} 검색 성공 - 키워드: {}, 결과수: {}", type, keyword, items.size());
                
            } else {
                log.error("네이버 API 호출 실패 - 응답 코드: {}", responseCode);
                result.put("success", false);
                result.put("message", "API 호출 실패: " + responseCode);
            }
            
        } catch (Exception e) {
            log.error("네이버 검색 중 오류 발생", e);
            result.put("success", false);
            result.put("message", "오류 발생: " + e.getMessage());
        }
        
        return result;
    }

    /**
     * 블로그 링크에서 썸네일 이미지 URL 추출
     * Jsoup 라이브러리 필요
     */
    private String extractThumbnail(String blogUrl) {
        try {
            // 모바일 페이지로 접속해야 파싱이 쉬운 경우가 많음 (선택사항)
            Document doc = Jsoup.connect(blogUrl)
                    .userAgent("Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36")
                    .timeout(3000) // 3초 타임아웃
                    .get();
            
            // Open Graph 태그 확인
            Element ogImage = doc.selectFirst("meta[property=og:image]");
            if (ogImage != null) {
                return ogImage.attr("content");
            }
            
            // 본문 이미지 확인
            Element firstImage = doc.selectFirst("div#postViewArea img, div.se-main-container img");
            if (firstImage != null) {
                return firstImage.attr("src");
            }
            
        } catch (Exception e) {
            // 로그 생략 (너무 많이 찍힐 수 있음)
        }
        return null;
    }
}

