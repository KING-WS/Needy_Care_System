package edu.sm.app.service;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.util.UriComponentsBuilder;

import java.net.HttpURLConnection;
import java.net.URL;
import java.util.HashMap;
import java.util.Map;
import java.util.Scanner;

/**
 * YouTube 검색 서비스
 * 음식명으로 YouTube 영상을 검색합니다.
 */
@Service
@Slf4j
public class YouTubeService {
    
    private final ObjectMapper objectMapper;
    
    // YouTube Data API v3 키 (application.properties에서 설정)
    @Value("${youtube.api.key:}")
    private String youtubeApiKey;
    
    // YouTube Data API v3 기본 URL
    private static final String YOUTUBE_SEARCH_URL = "https://www.googleapis.com/youtube/v3/search";
    
    public YouTubeService(ObjectMapper objectMapper) {
        this.objectMapper = objectMapper;
    }
    
    /**
     * 음식명으로 YouTube 영상 검색
     * @param foodName 음식명 (예: "김치찌개")
     * @return 비디오 ID와 제목이 포함된 맵
     */
    public Map<String, Object> searchVideo(String foodName) {
        Map<String, Object> result = new HashMap<>();
        
        try {
            // API 키가 없으면 기본 검색 링크만 제공
            if (youtubeApiKey == null || youtubeApiKey.trim().isEmpty()) {
                log.warn("YouTube API 키가 설정되지 않았습니다. 검색 링크만 제공합니다.");
                result.put("success", false);
                result.put("videoId", null);
                result.put("videoTitle", null);
                result.put("searchUrl", "https://www.youtube.com/results?search_query=" + 
                    java.net.URLEncoder.encode(foodName + " 만드는 방법", "UTF-8"));
                result.put("message", "YouTube API 키가 설정되지 않았습니다.");
                return result;
            }
            
            // 검색 쿼리 생성 (음식명 + "만드는 방법")
            String query = foodName + " 만드는 방법";
            
            // YouTube Data API v3 호출
            UriComponentsBuilder builder = UriComponentsBuilder.fromUriString(YOUTUBE_SEARCH_URL)
                    .queryParam("part", "snippet")
                    .queryParam("q", query)
                    .queryParam("type", "video")
                    .queryParam("maxResults", "1")
                    .queryParam("key", youtubeApiKey)
                    .queryParam("regionCode", "KR")  // 한국 지역 우선
                    .queryParam("relevanceLanguage", "ko");  // 한국어 우선
            
            URL url = new URL(builder.toUriString());
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("GET");
            conn.setRequestProperty("Accept", "application/json");
            
            int responseCode = conn.getResponseCode();
            
            if (responseCode == 200) {
                Scanner scanner = new Scanner(conn.getInputStream(), "UTF-8");
                String responseBody = scanner.useDelimiter("\\A").next();
                scanner.close();
                
                // JSON 파싱
                JsonNode jsonNode = objectMapper.readTree(responseBody);
                JsonNode items = jsonNode.get("items");
                
                if (items != null && items.isArray() && items.size() > 0) {
                    JsonNode firstItem = items.get(0);
                    JsonNode idNode = firstItem.get("id");
                    JsonNode snippetNode = firstItem.get("snippet");
                    
                    if (idNode != null && snippetNode != null) {
                        String videoId = idNode.get("videoId").asText();
                        String videoTitle = snippetNode.get("title").asText();
                        
                        result.put("success", true);
                        result.put("videoId", videoId);
                        result.put("videoTitle", videoTitle);
                        result.put("searchUrl", "https://www.youtube.com/watch?v=" + videoId);
                        
                        log.info("YouTube 영상 검색 성공 - 음식명: {}, 비디오 ID: {}", foodName, videoId);
                        return result;
                    }
                }
            } else {
                log.warn("YouTube API 호출 실패 - 응답 코드: {}", responseCode);
            }
            
            // 검색 실패 시 검색 링크만 제공
            result.put("success", false);
            result.put("videoId", null);
            result.put("videoTitle", null);
            result.put("searchUrl", "https://www.youtube.com/results?search_query=" + 
                java.net.URLEncoder.encode(query, "UTF-8"));
            result.put("message", "영상을 찾을 수 없습니다.");
            
        } catch (Exception e) {
            log.error("YouTube 영상 검색 실패 - 음식명: {}", foodName, e);
            result.put("success", false);
            result.put("videoId", null);
            result.put("videoTitle", null);
            try {
                result.put("searchUrl", "https://www.youtube.com/results?search_query=" + 
                    java.net.URLEncoder.encode(foodName + " 만드는 방법", "UTF-8"));
            } catch (Exception ex) {
                result.put("searchUrl", "https://www.youtube.com");
            }
            result.put("message", "검색 중 오류가 발생했습니다: " + e.getMessage());
        }
        
        return result;
    }
}

