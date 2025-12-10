package edu.sm.controller;

import edu.sm.app.dto.MapLocation;
import edu.sm.app.service.MapService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.math.BigDecimal;
import java.util.HashMap;
import java.util.List;

/**
 * MapLocation(지도 장소) Controller
 * 지도 장소 정보 관리를 위한 REST API
 */
@RestController
@RequestMapping("/api/map")
@RequiredArgsConstructor
@Slf4j
public class MapController {

    private final MapService mapService;

    /**
     * 전체 장소 목록 조회
     * GET /api/map
     */
    @GetMapping
    public ResponseEntity<java.util.Map<String, Object>> getAllMaps() {
        java.util.Map<String, Object> response = new HashMap<>();
        try {
            List<MapLocation> maps = mapService.get();
            response.put("success", true);
            response.put("data", maps);
            response.put("count", maps.size());
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            log.error("전체 장소 조회 실패", e);
            response.put("success", false);
            response.put("message", "장소 목록 조회 중 오류가 발생했습니다.");
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
        }
    }

    /**
     * 특정 장소 조회
     * GET /api/map/{mapId}
     */
    @GetMapping("/{mapId}")
    public ResponseEntity<java.util.Map<String, Object>> getMap(@PathVariable Integer mapId) {
        java.util.Map<String, Object> response = new HashMap<>();
        try {
            MapLocation mapLocation = mapService.get(mapId);
            if (mapLocation != null) {
                response.put("success", true);
                response.put("data", mapLocation);
                return ResponseEntity.ok(response);
            } else {
                response.put("success", false);
                response.put("message", "해당 장소를 찾을 수 없습니다.");
                return ResponseEntity.status(HttpStatus.NOT_FOUND).body(response);
            }
        } catch (Exception e) {
            log.error("장소 조회 실패 - mapId: {}", mapId, e);
            response.put("success", false);
            response.put("message", "장소 조회 중 오류가 발생했습니다.");
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
        }
    }

    /**
     * 돌봄대상자별 장소 목록 조회
     * GET /api/map/recipient/{recId}
     */
    @GetMapping("/recipient/{recId}")
    public ResponseEntity<java.util.Map<String, Object>> getMapsByRecipient(@PathVariable Integer recId) {
        java.util.Map<String, Object> response = new HashMap<>();
        try {
            List<MapLocation> maps = mapService.getByRecId(recId);
            response.put("success", true);
            response.put("data", maps);
            response.put("count", maps.size());
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            log.error("돌봄대상자별 장소 조회 실패 - recId: {}", recId, e);
            response.put("success", false);
            response.put("message", "장소 목록 조회 중 오류가 발생했습니다.");
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
        }
    }

    /**
     * 카테고리별 장소 목록 조회
     * GET /api/map/category/{category}
     */
    @GetMapping("/category/{category}")
    public ResponseEntity<java.util.Map<String, Object>> getMapsByCategory(@PathVariable String category) {
        java.util.Map<String, Object> response = new HashMap<>();
        try {
            List<MapLocation> maps = mapService.getByCategory(category);
            response.put("success", true);
            response.put("data", maps);
            response.put("count", maps.size());
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            log.error("카테고리별 장소 조회 실패 - category: {}", category, e);
            response.put("success", false);
            response.put("message", "장소 목록 조회 중 오류가 발생했습니다.");
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
        }
    }

    /**
     * 위치 범위 내 장소 조회
     * GET /api/map/location?minLat=...&maxLat=...&minLng=...&maxLng=...
     */
    @GetMapping("/location")
    public ResponseEntity<java.util.Map<String, Object>> getMapsByLocation(
            @RequestParam BigDecimal minLat,
            @RequestParam BigDecimal maxLat,
            @RequestParam BigDecimal minLng,
            @RequestParam BigDecimal maxLng
    ) {
        java.util.Map<String, Object> response = new HashMap<>();
        try {
            List<MapLocation> maps = mapService.getByLocationRange(minLat, maxLat, minLng, maxLng);
            response.put("success", true);
            response.put("data", maps);
            response.put("count", maps.size());
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            log.error("위치 범위 내 장소 조회 실패", e);
            response.put("success", false);
            response.put("message", "장소 목록 조회 중 오류가 발생했습니다.");
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
        }
    }

    /**
     * 새 장소 등록
     * POST /api/map
     */
    @PostMapping
    public ResponseEntity<java.util.Map<String, Object>> createMap(@RequestBody MapLocation mapLocation) {
        java.util.Map<String, Object> response = new HashMap<>();
        try {
            mapService.register(mapLocation);
            response.put("success", true);
            response.put("message", "장소가 성공적으로 등록되었습니다.");
            response.put("data", mapLocation);
            return ResponseEntity.status(HttpStatus.CREATED).body(response);
        } catch (Exception e) {
            log.error("장소 등록 실패", e);
            response.put("success", false);
            response.put("message", "장소 등록 중 오류가 발생했습니다.");
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
        }
    }

    /**
     * 장소 정보 수정
     * PUT /api/map/{mapId}
     */
    @PutMapping("/{mapId}")
    public ResponseEntity<java.util.Map<String, Object>> updateMap(
            @PathVariable Integer mapId,
            @RequestBody MapLocation mapLocation
    ) {
        java.util.Map<String, Object> response = new HashMap<>();
        try {
            mapLocation.setMapId(mapId);
            mapService.modify(mapLocation);
            response.put("success", true);
            response.put("message", "장소 정보가 성공적으로 수정되었습니다.");
            response.put("data", mapLocation);
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            log.error("장소 수정 실패 - mapId: {}", mapId, e);
            response.put("success", false);
            response.put("message", "장소 정보 수정 중 오류가 발생했습니다.");
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
        }
    }

    /**
     * 장소 삭제 (논리 삭제)
     * DELETE /api/map/{mapId}
     */
    @DeleteMapping("/{mapId}")
    public ResponseEntity<java.util.Map<String, Object>> deleteMap(@PathVariable Integer mapId) {
        java.util.Map<String, Object> response = new HashMap<>();
        try {
            mapService.remove(mapId);
            response.put("success", true);
            response.put("message", "장소가 성공적으로 삭제되었습니다.");
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            log.error("장소 삭제 실패 - mapId: {}", mapId, e);
            response.put("success", false);
            response.put("message", "장소 삭제 중 오류가 발생했습니다.");
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
        }
    }
}

