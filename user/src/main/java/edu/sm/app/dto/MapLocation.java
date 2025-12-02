package edu.sm.app.dto;

import lombok.*;

import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 * MapLocation(지도 장소) 테이블 DTO
 * 노약자 주변의 주요 장소 정보를 저장
 */
@AllArgsConstructor
@NoArgsConstructor
@ToString
@Getter
@Setter
@Builder
public class MapLocation {
    private Integer mapId;              // 장소ID (PK)
    private Integer recId;              // 노약자ID (FK)
    private String mapName;             // 장소이름
    private String mapAddress;          // 주소
    private String mapContent;          // 내용
    private String mapCategory;         // 카테고리 (CUS-014: 병원, 학교 등)
    private BigDecimal mapLatitude;     // 위도 (지도 좌표)
    private BigDecimal mapLongitude;    // 경도 (지도 좌표)
    private String isDeleted;           // 삭제여부 (Y/N)
    private LocalDateTime mapRegdate;   // 등록일자
    private LocalDateTime mapUpdate;    // 수정일자
}

