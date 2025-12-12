package edu.sm.app.service;

import edu.sm.app.dto.MapLocation;
import edu.sm.app.repository.MapRepository;
import edu.sm.common.frame.SmService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.util.List;

/**
 * MapLocation(지도 장소) Service
 * 지도 장소 정보에 대한 비즈니스 로직 처리
 */
@Service
@RequiredArgsConstructor
@Slf4j
public class MapService implements SmService<MapLocation, Integer> {

    private final MapRepository mapRepository;

    /**
     * 새 장소 등록
     * @param mapLocation 장소 정보
     */
    @Override
    public void register(MapLocation mapLocation) throws Exception {
        log.info("장소 등록 - 이름: {}, 카테고리: {}", mapLocation.getMapName(), mapLocation.getMapCategory());
        mapRepository.insert(mapLocation);
    }

    /**
     * 장소 정보 수정
     * @param mapLocation 수정할 장소 정보
     */
    @Override
    public void modify(MapLocation mapLocation) throws Exception {
        log.info("장소 수정 - ID: {}, 이름: {}", mapLocation.getMapId(), mapLocation.getMapName());
        mapRepository.update(mapLocation);
    }

    /**
     * 장소 삭제 (논리 삭제)
     * @param mapId 장소 ID
     */
    @Override
    public void remove(Integer mapId) throws Exception {
        log.info("장소 삭제 - ID: {}", mapId);
        mapRepository.delete(mapId);
    }

    /**
     * 전체 장소 목록 조회
     * @return 모든 장소 목록
     */
    @Override
    public List<MapLocation> get() throws Exception {
        log.debug("전체 장소 목록 조회");
        return mapRepository.selectAll();
    }

    /**
     * 특정 장소 조회
     * @param mapId 장소 ID
     * @return 장소 정보
     */
    @Override
    public MapLocation get(Integer mapId) throws Exception {
        log.debug("장소 조회 - ID: {}", mapId);
        return mapRepository.select(mapId);
    }

    /**
     * 돌봄대상자별 장소 목록 조회
     * @param recId 돌봄대상자 ID
     * @return 해당 돌봄대상자의 장소 목록
     */
    public List<MapLocation> getByRecId(Integer recId) throws Exception {
        log.debug("돌봄대상자별 장소 조회 - recId: {}", recId);
        return mapRepository.selectByRecId(recId);
    }

    /**
     * 카테고리별 장소 목록 조회
     * @param category 카테고리 (예: 병원, 학교 등)
     * @return 해당 카테고리의 장소 목록
     */
    public List<MapLocation> getByCategory(String category) throws Exception {
        log.debug("카테고리별 장소 조회 - category: {}", category);
        return mapRepository.selectByCategory(category);
    }

    /**
     * 특정 범위 내의 장소 조회 (위도/경도 기반)
     * @param minLat 최소 위도
     * @param maxLat 최대 위도
     * @param minLng 최소 경도
     * @param maxLng 최대 경도
     * @return 해당 범위 내의 장소 목록
     */
    public List<MapLocation> getByLocationRange(
        BigDecimal minLat, 
        BigDecimal maxLat,
        BigDecimal minLng, 
        BigDecimal maxLng
    ) throws Exception {
        log.debug("위치 범위 내 장소 조회 - 위도: {} ~ {}, 경도: {} ~ {}", 
            minLat, maxLat, minLng, maxLng);
        return mapRepository.selectByLocationRange(minLat, maxLat, minLng, maxLng);
    }

    /**
     * 돌봄대상자 ID와 카테고리로 장소 조회
     * @param recId 돌봄대상자 ID
     * @param category 카테고리
     * @return 해당 돌봄대상자의 특정 카테고리 장소 목록
     */
    public List<MapLocation> getByRecIdAndCategory(Integer recId, String category) throws Exception {
        log.debug("돌봄대상자별 카테고리 장소 조회 - recId: {}, category: {}", recId, category);
        return mapRepository.selectByRecIdAndCategory(recId, category);
    }

    /**
     * 노약자 ID, 이름, 주소로 기존 장소 조회 (중복 체크용)
     * @param recId 노약자 ID
     * @param mapName 장소 이름
     * @param mapAddress 장소 주소
     * @return 기존 장소 정보 (없으면 null)
     */
    public MapLocation getByRecIdAndNameAndAddress(Integer recId, String mapName, String mapAddress) throws Exception {
        log.debug("기존 장소 조회 - recId: {}, 이름: {}, 주소: {}", recId, mapName, mapAddress);
        return mapRepository.selectByRecIdAndNameAndAddress(recId, mapName, mapAddress);
    }
}

