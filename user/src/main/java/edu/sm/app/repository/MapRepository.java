package edu.sm.app.repository;

import edu.sm.app.dto.MapLocation;
import edu.sm.common.frame.SmRepository;
import org.apache.ibatis.annotations.Mapper;
import org.springframework.stereotype.Repository;

import java.util.List;

/**
 * MapLocation(지도 장소) Repository
 * 지도 장소 정보에 대한 데이터베이스 접근 인터페이스
 */
@Repository
@Mapper
public interface MapRepository extends SmRepository<MapLocation, Integer> {
    
    /**
     * 노약자 ID로 장소 목록 조회
     * @param recId 노약자 ID
     * @return 해당 노약자의 장소 목록
     */
    List<MapLocation> selectByRecId(Integer recId) throws Exception;
    
    /**
     * 카테고리별 장소 목록 조회
     * @param category 카테고리 (예: 병원, 학교 등)
     * @return 해당 카테고리의 장소 목록
     */
    List<MapLocation> selectByCategory(String category) throws Exception;
    
    /**
     * 특정 범위 내의 장소 조회 (위도/경도 기반)
     * @param minLat 최소 위도
     * @param maxLat 최대 위도
     * @param minLng 최소 경도
     * @param maxLng 최대 경도
     * @return 해당 범위 내의 장소 목록
     */
    List<MapLocation> selectByLocationRange(
        java.math.BigDecimal minLat, 
        java.math.BigDecimal maxLat,
        java.math.BigDecimal minLng, 
        java.math.BigDecimal maxLng
    ) throws Exception;
    
    /**
     * 노약자 ID와 카테고리로 장소 조회
     * @param recId 노약자 ID
     * @param category 카테고리
     * @return 해당 노약자의 특정 카테고리 장소 목록
     */
    List<MapLocation> selectByRecIdAndCategory(Integer recId, String category) throws Exception;
    
    /**
     * 노약자 ID, 이름, 주소로 기존 장소 조회 (중복 체크용)
     * @param recId 노약자 ID
     * @param mapName 장소 이름
     * @param mapAddress 장소 주소
     * @return 기존 장소 정보 (없으면 null)
     */
    MapLocation selectByRecIdAndNameAndAddress(Integer recId, String mapName, String mapAddress) throws Exception;
}

