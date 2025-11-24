package edu.sm.controller;

import edu.sm.app.dto.RecipientLocation;
import edu.sm.app.service.IotLocationService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;

/**
 * IoT 기반 노약자 위치 관리 컨트롤러
 * 실시간 위치 조회 및 업데이트 API를 제공합니다.
 */
@RestController
@RequestMapping("/api/iot")
@RequiredArgsConstructor
@Slf4j
public class IotController {

    private final IotLocationService iotLocationService;

    /**
     * 노약자의 현재 위치를 조회합니다.
     * GET /api/iot/location/{recId}
     */
    @GetMapping("/location/{recId}")
    public ResponseEntity<Map<String, Object>> getLocation(@PathVariable Integer recId) {
        Map<String, Object> response = new HashMap<>();
        
        try {
            RecipientLocation location = iotLocationService.getCurrentLocation(recId);
            
            if (location == null) {
                response.put("success", false);
                response.put("message", "위치 정보를 찾을 수 없습니다.");
                return ResponseEntity.ok(response);
            }
            
            response.put("success", true);
            response.put("data", location);
            
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            log.error("위치 조회 실패. recId: {}", recId, e);
            response.put("success", false);
            response.put("message", "위치 조회 중 오류가 발생했습니다.");
            return ResponseEntity.ok(response);
        }
    }

    /**
     * 노약자의 위치를 업데이트합니다 (시뮬레이션)
     * POST /api/iot/location/{recId}/update
     */
    @PostMapping("/location/{recId}/update")
    public ResponseEntity<Map<String, Object>> updateLocation(@PathVariable Integer recId) {
        Map<String, Object> response = new HashMap<>();
        
        try {
            RecipientLocation location = iotLocationService.updateLocation(recId);
            
            if (location == null) {
                response.put("success", false);
                response.put("message", "위치 업데이트 실패");
                return ResponseEntity.ok(response);
            }
            
            response.put("success", true);
            response.put("data", location);
            
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            log.error("위치 업데이트 실패. recId: {}", recId, e);
            response.put("success", false);
            response.put("message", "위치 업데이트 중 오류가 발생했습니다.");
            return ResponseEntity.ok(response);
        }
    }

    /**
     * IoT 디바이스에서 노약자의 위치를 전송합니다.
     * POST /api/iot/location/{recId}/set
     */
    @PostMapping("/location/{recId}/set")
    public ResponseEntity<Map<String, Object>> setLocation(
            @PathVariable Integer recId,
            @RequestBody Map<String, Object> locationData) {
        Map<String, Object> response = new HashMap<>();
        
        try {
            Double latitude = null;
            Double longitude = null;
            
            if (locationData.containsKey("latitude")) {
                latitude = Double.parseDouble(locationData.get("latitude").toString());
            }
            if (locationData.containsKey("longitude")) {
                longitude = Double.parseDouble(locationData.get("longitude").toString());
            }
            
            if (latitude == null || longitude == null) {
                response.put("success", false);
                response.put("message", "위도와 경도가 필요합니다.");
                return ResponseEntity.ok(response);
            }
            
            iotLocationService.setLocation(recId, latitude, longitude);
            
            response.put("success", true);
            response.put("message", "위치가 성공적으로 설정되었습니다.");
            
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            log.error("위치 설정 실패. recId: {}", recId, e);
            response.put("success", false);
            response.put("message", "위치 설정 중 오류가 발생했습니다.");
            return ResponseEntity.ok(response);
        }
    }

    /**
     * 노약자의 집 위치를 설정합니다.
     * POST /api/iot/location/{recId}/home
     */
    @PostMapping("/location/{recId}/home")
    public ResponseEntity<Map<String, Object>> setHomeLocation(
            @PathVariable Integer recId,
            @RequestBody Map<String, Object> locationData) {
        Map<String, Object> response = new HashMap<>();
        
        try {
            Double latitude = null;
            Double longitude = null;
            
            if (locationData.containsKey("latitude")) {
                latitude = Double.parseDouble(locationData.get("latitude").toString());
            }
            if (locationData.containsKey("longitude")) {
                longitude = Double.parseDouble(locationData.get("longitude").toString());
            }
            
            if (latitude == null || longitude == null) {
                response.put("success", false);
                response.put("message", "위도와 경도가 필요합니다.");
                return ResponseEntity.ok(response);
            }
            
            iotLocationService.setHomeLocation(recId, latitude, longitude);
            
            response.put("success", true);
            response.put("message", "집 위치가 성공적으로 설정되었습니다.");
            
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            log.error("집 위치 설정 실패. recId: {}", recId, e);
            response.put("success", false);
            response.put("message", "집 위치 설정 중 오류가 발생했습니다.");
            return ResponseEntity.ok(response);
        }
    }
}

