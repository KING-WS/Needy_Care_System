package edu.sm.app.service;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.util.UriComponentsBuilder;

import java.math.BigDecimal;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Scanner;

@Service
@Slf4j
public class KakaoMapService {

    @Value("${kakao.api.key:}")
    private String apiKey;

    private static final String KAKAO_SEARCH_KEYWORD_URL = "https://dapi.kakao.com/v2/local/search/keyword.json";
    private static final String KAKAO_SEARCH_ADDRESS_URL = "https://dapi.kakao.com/v2/local/search/address.json";

    private final ObjectMapper objectMapper;

    public KakaoMapService(ObjectMapper objectMapper) {
        this.objectMapper = objectMapper;
    }

    /**
     * 키워드로 장소 검색 (거리순 정렬 가능)
     */
    public List<Map<String, Object>> searchPlace(String keyword, String userLat, String userLng) {
        List<Map<String, Object>> places = new ArrayList<>();
        try {
            if (apiKey == null || apiKey.trim().isEmpty()) {
                log.warn("Kakao API Key is missing");
                return places;
            }

            UriComponentsBuilder builder = UriComponentsBuilder.fromUriString(KAKAO_SEARCH_KEYWORD_URL)
                    .queryParam("query", keyword)
                    .queryParam("size", 5); // 상위 5개만

            if (userLat != null && userLng != null) {
                builder.queryParam("y", userLat)
                       .queryParam("x", userLng)
                       .queryParam("sort", "distance"); // 거리순 정렬
            }

            String jsonResponse = sendRequest(builder.toUriString());
            if (jsonResponse != null) {
                JsonNode root = objectMapper.readTree(jsonResponse);
                JsonNode documents = root.path("documents");
                if (documents.isArray()) {
                    for (JsonNode doc : documents) {
                        Map<String, Object> place = new HashMap<>();
                        place.put("place_name", doc.path("place_name").asText());
                        place.put("address_name", doc.path("address_name").asText());
                        place.put("road_address_name", doc.path("road_address_name").asText());
                        place.put("x", doc.path("x").asText());
                        place.put("y", doc.path("y").asText());
                        place.put("phone", doc.path("phone").asText());
                        place.put("place_url", doc.path("place_url").asText());
                        place.put("distance", doc.path("distance").asText()); // 미터 단위
                        places.add(place);
                    }
                }
            }
        } catch (Exception e) {
            log.error("Kakao Search Failed: {}", e.getMessage(), e);
        }
        return places;
    }

    /**
     * 주소로 좌표 검색
     */
    public Map<String, String> getCoordinates(String address) {
        Map<String, String> coords = new HashMap<>();
        try {
            if (apiKey == null || apiKey.trim().isEmpty()) return coords;

            UriComponentsBuilder builder = UriComponentsBuilder.fromUriString(KAKAO_SEARCH_ADDRESS_URL)
                    .queryParam("query", address);

            String jsonResponse = sendRequest(builder.toUriString());
            if (jsonResponse != null) {
                JsonNode root = objectMapper.readTree(jsonResponse);
                JsonNode documents = root.path("documents");
                if (documents.isArray() && documents.size() > 0) {
                    JsonNode doc = documents.get(0);
                    coords.put("x", doc.path("x").asText()); // 경도 (Longitude)
                    coords.put("y", doc.path("y").asText()); // 위도 (Latitude)
                }
            }
        } catch (Exception e) {
            log.error("Kakao Address Search Failed: {}", e.getMessage(), e);
        }
        return coords;
    }

    private String sendRequest(String urlStr) throws Exception {
        URL url = new URL(urlStr);
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("GET");
        conn.setRequestProperty("Authorization", "KakaoAK " + apiKey);

        int responseCode = conn.getResponseCode();
        if (responseCode == 200) {
            try (Scanner scanner = new Scanner(conn.getInputStream(), "UTF-8")) {
                return scanner.useDelimiter("\\A").next();
            }
        } else {
            log.error("Kakao API Error Code: {}", responseCode);
            return null;
        }
    }
}

