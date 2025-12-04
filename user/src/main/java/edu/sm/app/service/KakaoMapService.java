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

@Service
@Slf4j
public class KakaoMapService {

    @Value("${kakao.api.key:}")
    private String apiKey;

    private static final String KAKAO_SEARCH_KEYWORD_URL = "https://dapi.kakao.com/v2/local/search/keyword.json";
    private static final String KAKAO_SEARCH_ADDRESS_URL = "https://dapi.kakao.com/v2/local/search/address.json";
    private static final String KAKAO_DIRECTIONS_URL = "https://apis-navi.kakaomobility.com/v1/directions";

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

    /**
     * 길찾기 (자동차 경로) - Kakao Mobility Directions API
     */
    public Map<String, Object> getRoute(String startLng, String startLat, String endLng, String endLat) {
        Map<String, Object> result = new HashMap<>();
        try {
            if (apiKey == null || apiKey.trim().isEmpty()) return result;

            String origin = startLng + "," + startLat;
            String destination = endLng + "," + endLat;

            UriComponentsBuilder builder = UriComponentsBuilder.fromUriString(KAKAO_DIRECTIONS_URL)
                    .queryParam("origin", origin)
                    .queryParam("destination", destination)
                    .queryParam("priority", "RECOMMEND"); // 추천 경로

            String jsonResponse = sendRequest(builder.toUriString());
            if (jsonResponse != null) {
                JsonNode root = objectMapper.readTree(jsonResponse);
                JsonNode routes = root.path("routes");
                if (routes.isArray() && routes.size() > 0) {
                    JsonNode route = routes.get(0);
                    JsonNode summary = route.path("summary");
                    int totalDistance = summary.path("distance").asInt();
                    int duration = summary.path("duration").asInt();

                    result.put("totalDistance", totalDistance);
                    result.put("duration", duration);

                    // 경로 좌표 추출 (vertexes)
                    List<Map<String, Double>> pathPoints = new ArrayList<>();
                    JsonNode sections = route.path("sections");
                    if (sections.isArray()) {
                        for (JsonNode section : sections) {
                            JsonNode roads = section.path("roads");
                            if (roads.isArray()) {
                                for (JsonNode road : roads) {
                                    JsonNode vertexes = road.path("vertexes");
                                    if (vertexes.isArray()) {
                                        for (int i = 0; i < vertexes.size(); i += 2) {
                                            double lng = vertexes.get(i).asDouble();
                                            double lat = vertexes.get(i + 1).asDouble();
                                            
                                            Map<String, Double> point = new HashMap<>();
                                            point.put("lng", lng);
                                            point.put("lat", lat);
                                            pathPoints.add(point);
                                        }
                                    }
                                }
                            }
                        }
                    }
                    result.put("path", pathPoints);
                }
            }
        } catch (Exception e) {
            log.error("Kakao Directions API Failed: {}", e.getMessage(), e);
        }
        return result;
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

