package edu.sm.app.service;

import edu.sm.app.dto.Recipient;
import edu.sm.app.dto.RecipientLocation;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import java.util.Random;

/**
 * IoT 기반 돌봄대상자 위치 시뮬레이션 서비스
 * 돌봄대상자의 실시간 위치를 시뮬레이션하고 관리합니다.
 */
@Service
@Slf4j
@RequiredArgsConstructor
public class IotLocationService {

    private final RecipientService recipientService;
    
    // 돌봄대상자별 위치 정보를 메모리에 저장 (실제 운영 시에는 Redis 등 사용 권장)
    private final Map<Integer, RecipientLocation> locationCache = new ConcurrentHashMap<>();
    
    // 돌봄대상자별 집 위치 정보 저장
    private final Map<Integer, RecipientLocation> homeLocationCache = new ConcurrentHashMap<>();
    
    private final Random random = new Random();

    /**
     * 돌봄대상자의 현재 위치를 가져옵니다.
     * 위치가 없으면 집 위치를 기반으로 초기 위치를 생성합니다.
     */
    public RecipientLocation getCurrentLocation(Integer recId) {
        RecipientLocation location = locationCache.get(recId);
        
        if (location == null) {
            // 위치가 없으면 집 위치를 기반으로 초기화
            location = initializeLocation(recId);
        }
        
        return location;
    }

    /**
     * 돌봄대상자의 위치를 초기화합니다 (집 위치 기반)
     */
    public RecipientLocation initializeLocation(Integer recId) {
        Recipient recipient = recipientService.getRecipientById(recId);
        
        if (recipient == null || recipient.getRecAddress() == null) {
            log.warn("돌봄대상자 정보 또는 주소가 없습니다. recId: {}", recId);
            return null;
        }
        
        // 집 위치가 이미 저장되어 있으면 사용
        RecipientLocation homeLocation = homeLocationCache.get(recId);
        if (homeLocation != null) {
            // 집 위치를 복사하여 현재 위치로 설정
            RecipientLocation currentLocation = RecipientLocation.builder()
                    .recId(recId)
                    .latitude(homeLocation.getLatitude())
                    .longitude(homeLocation.getLongitude())
                    .updateTime(LocalDateTime.now())
                    .status("ACTIVE")
                    .build();
            
            locationCache.put(recId, currentLocation);
            return currentLocation;
        }
        
        // 집 위치가 없으면 기본값 반환 (실제로는 주소를 좌표로 변환해야 함)
        // 여기서는 데모용으로 서울 시청 좌표 사용
        double defaultLat = 37.5665;
        double defaultLng = 126.9780;
        
        RecipientLocation homeLoc = RecipientLocation.builder()
                .recId(recId)
                .latitude(defaultLat)
                .longitude(defaultLng)
                .updateTime(LocalDateTime.now())
                .status("ACTIVE")
                .build();
        
        homeLocationCache.put(recId, homeLoc);
        
        RecipientLocation currentLocation = RecipientLocation.builder()
                .recId(recId)
                .latitude(defaultLat)
                .longitude(defaultLng)
                .updateTime(LocalDateTime.now())
                .status("ACTIVE")
                .build();
        
        locationCache.put(recId, currentLocation);
        
        log.info("돌봄대상자 위치 초기화 완료. recId: {}, lat: {}, lng: {}", recId, defaultLat, defaultLng);
        
        return currentLocation;
    }

    /**
     * 돌봄대상자의 집 위치를 설정합니다.
     * 주소를 좌표로 변환하여 저장합니다.
     */
    public void setHomeLocation(Integer recId, Double latitude, Double longitude) {
        RecipientLocation homeLocation = RecipientLocation.builder()
                .recId(recId)
                .latitude(latitude)
                .longitude(longitude)
                .updateTime(LocalDateTime.now())
                .status("HOME")
                .build();
        
        homeLocationCache.put(recId, homeLocation);
        log.info("돌봄대상자 집 위치 설정 완료. recId: {}, lat: {}, lng: {}", recId, latitude, longitude);
    }

    /**
     * 돌봄대상자의 위치를 업데이트합니다 (집 주변 랜덤 이동)
     * IoT 디바이스에서 호출하거나, 시뮬레이션을 위해 주기적으로 호출됩니다.
     */
    public RecipientLocation updateLocation(Integer recId) {
        RecipientLocation homeLocation = homeLocationCache.get(recId);
        
        if (homeLocation == null) {
            // 집 위치가 없으면 초기화
            initializeLocation(recId);
            homeLocation = homeLocationCache.get(recId);
        }
        
        if (homeLocation == null) {
            log.warn("집 위치를 찾을 수 없습니다. recId: {}", recId);
            return null;
        }
        
        // 집 위치 기준으로 100-300m 반경 내 랜덤 위치 생성
        double homeLat = homeLocation.getLatitude();
        double homeLng = homeLocation.getLongitude();
        
        // 랜덤 각도 (0~360도)
        double angle = random.nextDouble() * 2 * Math.PI;
        
        // 랜덤 거리 (100m ~ 300m)
        double distance = 100 + random.nextDouble() * 200; // 미터 단위
        
        // 미터를 위도/경도 차이로 변환
        // 1도 위도 ≈ 111km, 1도 경도 ≈ 111km * cos(위도)
        double latOffset = (distance / 111000.0) * Math.cos(angle);
        double lngOffset = (distance / (111000.0 * Math.cos(Math.toRadians(homeLat)))) * Math.sin(angle);
        
        double newLat = homeLat + latOffset;
        double newLng = homeLng + lngOffset;
        
        RecipientLocation newLocation = RecipientLocation.builder()
                .recId(recId)
                .latitude(newLat)
                .longitude(newLng)
                .updateTime(LocalDateTime.now())
                .status("ACTIVE")
                .build();
        
        locationCache.put(recId, newLocation);
        
        log.debug("돌봄대상자 위치 업데이트. recId: {}, lat: {}, lng: {}", recId, newLat, newLng);
        
        return newLocation;
    }

    /**
     * 돌봄대상자의 위치를 수동으로 설정합니다 (실제 IoT 디바이스에서 전송된 위치)
     */
    public void setLocation(Integer recId, Double latitude, Double longitude) {
        RecipientLocation location = RecipientLocation.builder()
                .recId(recId)
                .latitude(latitude)
                .longitude(longitude)
                .updateTime(LocalDateTime.now())
                .status("ACTIVE")
                .build();
        
        locationCache.put(recId, location);
        log.info("돌봄대상자 위치 수동 설정. recId: {}, lat: {}, lng: {}", recId, latitude, longitude);
    }

    /**
     * 돌봄대상자의 위치 정보를 삭제합니다.
     */
    public void removeLocation(Integer recId) {
        locationCache.remove(recId);
        homeLocationCache.remove(recId);
        log.info("돌봄대상자 위치 정보 삭제. recId: {}", recId);
    }
}

