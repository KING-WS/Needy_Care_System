// 전역 변수
var map;
var markers = [];
var geocoder = new kakao.maps.services.Geocoder();
var tempMarker = null;
var clickedPosition = null;
var homeMarker = null; // 집 마커
var homeInfowindow = null; // 집 인포윈도우
var recipientLocationMarker = null; // 노약자 실시간 위치 마커
var recipientLocationInterval = null; // 노약자 위치 업데이트 인터벌
var homePosition = null; // 집 위치 (노약자 위치 업데이트용)

// 산책코스 모드 관련 변수
var currentMapMode = 'mymap'; // 'mymap' 또는 'course'
var courseMarkers = []; // 산책코스 핀들
var coursePolyline = null; // 산책코스 경로 선
var courseDistances = []; // 구간별 거리
var totalDistance = 0; // 총 거리

// 장소 상세 정보 관련 변수
var currentLocationId = null;
var currentLocationLat = null;
var currentLocationLng = null;

// 산책코스 상세 정보 관련 변수
var currentCourseId = null;
var currentCourseLat = null;
var currentCourseLng = null;

// 위치 검색 함수
var searchMarkers = []; // 검색 결과 마커들

// 지도 초기화 함수
function initializeMap() {
    // 지도 초기화
    var mapContainer = document.getElementById('map');
    var mapOption = {
        center: new kakao.maps.LatLng(37.5665, 126.9780), // 기본 좌표 (곧 집 주소로 변경됨)
        level: 5
    };
    
    map = new kakao.maps.Map(mapContainer, mapOption);
    
    // 지도 클릭 이벤트 - 마커 추가 & 인포윈도우 닫기
    kakao.maps.event.addListener(map, 'click', function(mouseEvent) {
        var latlng = mouseEvent.latLng;
        
        // 산책코스 모드인 경우
        if (currentMapMode === 'course') {
            addCoursePin(latlng);
            return;
        }
        
        // 내 지도 모드 (기존 기능)
        // 모든 인포윈도우 닫기
        markers.forEach(function(item) {
            if (item.infowindow) {
                item.infowindow.close();
            }
        });
        
        searchMarkers.forEach(function(item) {
            if (item.infowindow) {
                item.infowindow.close();
            }
        });
        
        // 집 인포윈도우도 닫기
        if (homeInfowindow) {
            homeInfowindow.close();
        }
        
        // 임시 마커 제거
        if (tempMarker) {
            tempMarker.setMap(null);
        }
        
        // 새 임시 마커 생성
        tempMarker = new kakao.maps.Marker({
            position: latlng,
            map: map,
            image: new kakao.maps.MarkerImage(
                'https://t1.daumcdn.net/localimg/localimages/07/mapapidoc/marker_red.png',
                new kakao.maps.Size(35, 40)
            )
        });
        
        clickedPosition = latlng;
        
        // 모달 열기 및 주소 조회
        openMapModal(latlng.getLat(), latlng.getLng());
    });
}

// 산책코스 핀 추가
function addCoursePin(latlng) {
    var isFirstPin = courseMarkers.length === 0;
    var pinNumber = courseMarkers.length + 1;
    
    // 첫 번째 핀은 집 위치로 설정 (집 마커가 있는 경우)
    if (isFirstPin && homeMarker) {
        var homePos = homeMarker.getPosition();
        latlng = homePos;
        pinNumber = 0; // 집은 0번
    }
    
    // 핀 마커 생성
    var markerImage = new kakao.maps.MarkerImage(
        'https://t1.daumcdn.net/localimg/localimages/07/mapapidoc/marker_number_blue.png',
        new kakao.maps.Size(36, 37),
        {offset: new kakao.maps.Point(18, 37)}
    );
    
    // 집 마커는 특별한 이미지 사용
    if (pinNumber === 0 && homeMarker) {
        markerImage = new kakao.maps.MarkerImage(
            'data:image/svg+xml;base64,' + btoa(
                '<svg xmlns="http://www.w3.org/2000/svg" width="48" height="48" viewBox="0 0 48 48">' +
                '<path d="M24 8L10 20v18h10v-12h8v12h10V20z" fill="#e74c3c"/>' +
                '</svg>'
            ),
            new kakao.maps.Size(48, 48),
            {offset: new kakao.maps.Point(24, 48)}
        );
    }
    
    var marker = new kakao.maps.Marker({
        position: latlng,
        map: map,
        image: markerImage,
        title: pinNumber === 0 ? '출발지 (집)' : '경유지 ' + pinNumber
    });
    
    // 인포윈도우 생성
    var infowindow = new kakao.maps.InfoWindow({
        content: '<div style="padding:10px;font-size:13px;text-align:center;min-width:120px;">' +
                 '<strong>' + (pinNumber === 0 ? '출발지 (집)' : '경유지 ' + pinNumber) + '</strong>' +
                 '</div>',
        removable: false
    });
    
    // 마커 클릭 이벤트 - 인포윈도우 표시 비활성화 (사용자 요청)
    // kakao.maps.event.addListener(marker, 'click', function() {
    //     // 다른 인포윈도우 닫기
    //     courseMarkers.forEach(function(item) {
    //         if (item.infowindow) {
    //             item.infowindow.close();
    //         }
    //     });
    //     infowindow.open(map, marker);
    // });
    
    // 산책코스 마커 배열에 추가
    courseMarkers.push({
        marker: marker,
        infowindow: infowindow,
        position: latlng,
        number: pinNumber
    });
    
    // 경로 업데이트
    updateCoursePath();
    
    // 첫 번째 핀인 경우 인포윈도우 자동 표시 비활성화 (사용자 요청)
    // if (isFirstPin) {
    //     infowindow.open(map, marker);
    // }
}

// 산책코스 경로 업데이트 (폴리라인 및 거리 계산)
function updateCoursePath() {
    if (courseMarkers.length < 2) {
        // 핀이 2개 미만이면 경로 표시 안 함
        if (coursePolyline) {
            coursePolyline.setMap(null);
            coursePolyline = null;
        }
        updateDistanceInfo();
        return;
    }
    
    // 경로 좌표 배열 생성
    var path = courseMarkers.map(function(item) {
        return item.position;
    });
    
    // 기존 폴리라인 제거
    if (coursePolyline) {
        coursePolyline.setMap(null);
    }
    
    // 새 폴리라인 생성
    coursePolyline = new kakao.maps.Polyline({
        path: path,
        strokeWeight: 5,
        strokeColor: '#667eea',
        strokeOpacity: 0.8,
        strokeStyle: 'solid',
        map: map
    });
    
    // 거리 계산 및 업데이트
    calculateCourseDistances();
    updateDistanceInfo();
    
    // 구간별 마커는 표시하지 않음
}

// 산책코스 거리 계산
function calculateCourseDistances() {
    courseDistances = [];
    totalDistance = 0;
    
    if (courseMarkers.length < 2) {
        return;
    }
    
    // 각 구간별 거리 계산
    for (var i = 0; i < courseMarkers.length - 1; i++) {
        var from = courseMarkers[i].position;
        var to = courseMarkers[i + 1].position;
        
        // 하버사인 공식으로 거리 계산 (미터 단위)
        var distance = calculateDistance(
            from.getLat(), from.getLng(),
            to.getLat(), to.getLng()
        );
        
        courseDistances.push({
            from: i,
            to: i + 1,
            distance: distance
        });
        
        totalDistance += distance;
    }
}

// 구간별 마커 추가 (구간 중간 지점에 거리 표시)
var segmentMarkers = []; // 구간별 마커 배열

function addSegmentMarkers() {
    // 기존 구간 마커 제거
    segmentMarkers.forEach(function(item) {
        if (item && item.marker) {
            item.marker.setMap(null);
        }
        if (item && item.infowindow) {
            item.infowindow.close();
        }
    });
    segmentMarkers = [];
    
    if (courseMarkers.length < 2) {
        return;
    }
    
    // 각 구간의 중간 지점에 마커 추가
    for (var i = 0; i < courseMarkers.length - 1; i++) {
        var from = courseMarkers[i].position;
        var to = courseMarkers[i + 1].position;
        
        // 중간 지점 계산
        var midLat = (from.getLat() + to.getLat()) / 2;
        var midLng = (from.getLng() + to.getLng()) / 2;
        var midPosition = new kakao.maps.LatLng(midLat, midLng);
        
        // 구간 거리 계산
        var distance = calculateDistance(
            from.getLat(), from.getLng(),
            to.getLat(), to.getLng()
        );
        
        var distanceText = distance < 1000 
            ? Math.round(distance) + 'm' 
            : (distance / 1000).toFixed(2) + 'km';
        
        // 마커 이미지 - 간단한 원형 마커 (파란색 배경에 흰색 + 표시)
        var markerImage = new kakao.maps.MarkerImage(
            'data:image/svg+xml;base64,' + btoa(
                '<svg xmlns="http://www.w3.org/2000/svg" width="40" height="40" viewBox="0 0 40 40">' +
                '<circle cx="20" cy="20" r="18" fill="#667eea" stroke="white" stroke-width="3"/>' +
                '<path d="M20 12 L20 28 M12 20 L28 20" stroke="white" stroke-width="3" stroke-linecap="round"/>' +
                '</svg>'
            ),
            new kakao.maps.Size(40, 40),
            {offset: new kakao.maps.Point(20, 40)}
        );
        
        // 마커 생성
        var marker = new kakao.maps.Marker({
            position: midPosition,
            map: map,
            image: markerImage,
            title: '구간 ' + (i + 1) + ': ' + distanceText,
            zIndex: 1000 // 다른 마커 위에 표시
        });
        
        // 인포윈도우 생성 (자동으로 표시하지 않음)
        var infowindow = new kakao.maps.InfoWindow({
            content: '<div style="padding:10px;font-size:13px;text-align:center;min-width:120px;background:white;border-radius:5px;">' +
                     '<strong style="color:#667eea;">구간 ' + (i + 1) + '</strong><br/>' +
                     '<span style="color:#666;font-size:12px;">' + distanceText + '</span>' +
                     '</div>',
            removable: false
        });
        
        // 마커 클릭 이벤트 - 인포윈도우 표시 비활성화 (사용자 요청)
        // kakao.maps.event.addListener(marker, 'click', function() {
        //     // 다른 인포윈도우 닫기
        //     segmentMarkers.forEach(function(item) {
        //         if (item.infowindow) {
        //             item.infowindow.close();
        //         }
        //     });
        //     infowindow.open(map, marker);
        // });
        
        segmentMarkers.push({
            marker: marker,
            infowindow: infowindow
        });
    }
}

// 두 좌표 간 거리 계산 (하버사인 공식)
function calculateDistance(lat1, lng1, lat2, lng2) {
    var R = 6371000; // 지구 반지름 (미터)
    var dLat = (lat2 - lat1) * Math.PI / 180;
    var dLng = (lng2 - lng1) * Math.PI / 180;
    var a = Math.sin(dLat / 2) * Math.sin(dLat / 2) +
            Math.cos(lat1 * Math.PI / 180) * Math.cos(lat2 * Math.PI / 180) *
            Math.sin(dLng / 2) * Math.sin(dLng / 2);
    var c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
    return R * c;
}

// 거리 정보 표시 업데이트
function updateDistanceInfo() {
    // 기존 거리 정보 제거
    var existingInfo = document.getElementById('courseDistanceInfo');
    if (existingInfo) {
        existingInfo.remove();
    }
    
    if (courseMarkers.length < 2) {
        return;
    }
    
    // 거리 정보 표시
    var distanceInfo = document.createElement('div');
    distanceInfo.id = 'courseDistanceInfo';
    distanceInfo.style.cssText = 'position: absolute; bottom: 20px; left: 20px; background: rgba(255, 255, 255, 0.95); padding: 15px 20px; border-radius: 10px; z-index: 10; box-shadow: 0 4px 12px rgba(0,0,0,0.2); min-width: 250px;';
    
    var distanceText = '';
    if (totalDistance < 1000) {
        distanceText = Math.round(totalDistance) + 'm';
    } else {
        distanceText = (totalDistance / 1000).toFixed(2) + 'km';
    }
    
    var html = '<div style="font-weight: 600; color: #667eea; margin-bottom: 10px;"><i class="fas fa-route"></i> 총 거리: ' + distanceText + '</div>';
    
    // 구간별 거리 표시 - 마커 이모지 추가
    courseDistances.forEach(function(item, index) {
        var segmentDistance = item.distance < 1000 
            ? Math.round(item.distance) + 'm' 
            : (item.distance / 1000).toFixed(2) + 'km';
        // 구간별 마커 이모지 (📍)
        html += '<div style="font-size: 12px; color: #666; margin-top: 5px; display: flex; align-items: center; gap: 5px;">' +
               '<span style="font-size: 14px;">📍</span>' +
               '<span>구간 ' + (index + 1) + ': ' + segmentDistance + '</span>' +
               '</div>';
    });
    
    distanceInfo.innerHTML = html;
    document.querySelector('.map-right').appendChild(distanceInfo);
    
    // 저장 버튼 표시 (경로 초기화 옆에 있음)
    var saveBtn = document.getElementById('courseSaveBtn');
    if (saveBtn && courseMarkers.length >= 2) {
        saveBtn.style.display = 'inline-flex';
    }
}

// 산책코스 저장
function saveCourse() {
    if (courseMarkers.length < 2) {
        alert('최소 2개 이상의 지점이 필요합니다.');
        return;
    }
    
    // 산책코스 저장 모달 열기
    openCourseModal();
}

// 노약자 집 마커 표시 (최우선)
function loadHomeMarker() {
    if (!recipientAddress || recipientAddress === '' || recipientAddress === 'null') {
        console.log('노약자 주소 정보가 없습니다.');
        return;
    }
    
    console.log('집 주소 검색 시도:', recipientAddress);
    
    // 주소 정제 (상세주소 제거, 쉼표나 괄호 이후 내용 제거)
    var cleanAddress = recipientAddress
        .split(',')[0]      // 쉼표 이후 제거
        .split('(')[0]      // 괄호 이후 제거
        .trim();
    
    console.log('정제된 주소:', cleanAddress);
    
    // 주소로 좌표 검색
    geocoder.addressSearch(cleanAddress, function(result, status) {
        if (status === kakao.maps.services.Status.OK) {
            var coords = new kakao.maps.LatLng(result[0].y, result[0].x);
            
            console.log('✅ 주소 검색 성공! 좌표:', result[0].y, result[0].x);
            
            // 집 마커 이미지 (커스텀 집 아이콘 SVG)
            var homeImageSrc = 'data:image/svg+xml;base64,' + btoa(
                '<svg xmlns="http://www.w3.org/2000/svg" width="48" height="48" viewBox="0 0 48 48">' +
                '<defs>' +
                '<filter id="shadow" x="-50%" y="-50%" width="200%" height="200%">' +
                '<feGaussianBlur in="SourceAlpha" stdDeviation="2"/>' +
                '<feOffset dx="0" dy="2" result="offsetblur"/>' +
                '<feComponentTransfer><feFuncA type="linear" slope="0.3"/></feComponentTransfer>' +
                '<feMerge><feMergeNode/><feMergeNode in="SourceGraphic"/></feMerge>' +
                '</filter>' +
                '</defs>' +
                '<g filter="url(#shadow)">' +
                '<path d="M24 8L10 20v18h10v-12h8v12h10V20z" fill="#e74c3c"/>' +
                '<path d="M24 8L10 20v18h10v-12h8v12h10V20z" fill="none" stroke="#c0392b" stroke-width="2"/>' +
                '<circle cx="24" cy="26" r="3" fill="#fff" opacity="0.8"/>' +
                '<rect x="18" y="38" width="2" height="6" fill="#c0392b"/>' +
                '<rect x="28" y="38" width="2" height="6" fill="#c0392b"/>' +
                '</g>' +
                '<circle cx="24" cy="4" r="2" fill="#ffeb3b"/>' +
                '<path d="M24 6 L26 10 L22 10 Z" fill="#ffeb3b"/>' +
                '</svg>'
            );
            var homeImageSize = new kakao.maps.Size(48, 48);
            var homeImageOption = {offset: new kakao.maps.Point(24, 48)};
            var homeImage = new kakao.maps.MarkerImage(homeImageSrc, homeImageSize, homeImageOption);
            
            // 집 마커 생성
            homeMarker = new kakao.maps.Marker({
                map: map,
                position: coords,
                image: homeImage,
                title: recipientName + '님의 집'
            });
            
            // 집 정보 인포윈도우
            homeInfowindow = new kakao.maps.InfoWindow({
                content: '<div style="padding:15px;font-size:14px;min-width:200px;text-align:center;">' +
                         '<div style="font-weight:700;color:#e74c3c;margin-bottom:5px;">' +
                         '<i class="bi bi-house-heart-fill"></i> ' + recipientName + '님의 집</div>' +
                         '<div style="font-size:12px;color:#666;">' + cleanAddress + '</div>' +
                         '</div>',
                removable: false
            });
            
            // 집 마커 클릭 시 인포윈도우 표시
            kakao.maps.event.addListener(homeMarker, 'click', function() {
                // 다른 모든 인포윈도우 닫기
                markers.forEach(function(item) {
                    if (item.infowindow) {
                        item.infowindow.close();
                    }
                });
                
                searchMarkers.forEach(function(item) {
                    if (item.infowindow) {
                        item.infowindow.close();
                    }
                });
                
                // 집 인포윈도우만 열기
                homeInfowindow.open(map, homeMarker);
            });
            
            // 지도 중심을 집 위치로 설정
            map.setCenter(coords);
            map.setLevel(4); // 적당한 줌 레벨
            
            // 집 위치 저장 (노약자 위치 업데이트용)
            homePosition = coords;
            
            // IoT 서비스에 집 위치 설정
            setHomeLocationToIot(result[0].y, result[0].x);
            
            console.log('✅ 집 마커 표시 완료:', cleanAddress);
        } else {
            console.error('❌ 주소 검색 실패!');
            console.error('원본 주소:', recipientAddress);
            console.error('정제된 주소:', cleanAddress);
            console.error('상태 코드:', status);
            
            // 검색 실패 시 키워드 검색 시도
            console.log('📍 키워드 검색으로 재시도...');
            var ps = new kakao.maps.services.Places();
            ps.keywordSearch(cleanAddress, function(data, status) {
                if (status === kakao.maps.services.Status.OK && data.length > 0) {
                    var coords = new kakao.maps.LatLng(data[0].y, data[0].x);
                    
                    console.log('✅ 키워드 검색 성공! 좌표:', data[0].y, data[0].x);
                    
                    // 집 마커 이미지
                    var homeImageSrc = 'https://t1.daumcdn.net/localimg/localimages/07/mapapidoc/red_b.png';
                    var homeImageSize = new kakao.maps.Size(50, 45);
                    var homeImageOption = {offset: new kakao.maps.Point(15, 43)};
                    var homeImage = new kakao.maps.MarkerImage(homeImageSrc, homeImageSize, homeImageOption);
                    
                    homeMarker = new kakao.maps.Marker({
                        map: map,
                        position: coords,
                        image: homeImage,
                        title: recipientName + '님의 집'
                    });
                    
                    map.setCenter(coords);
                    map.setLevel(4);
                    
                    // 집 위치 저장 (노약자 위치 업데이트용)
                    homePosition = coords;
                    
                    // IoT 서비스에 집 위치 설정
                    setHomeLocationToIot(data[0].y, data[0].x);
                    
                    console.log('✅ 키워드 검색으로 집 마커 표시 완료');
                } else {
                    console.error('❌ 키워드 검색도 실패. 지도를 기본 위치(서울)로 표시합니다.');
                    console.error('💡 팁: 노약자 관리 페이지에서 정확한 주소로 수정해주세요.');
                    // 기본 위치(서울)로 유지
                }
            });
        }
    });
}

// 저장된 마커들 표시 (JSP에서 호출)
function loadSavedMarkersWithData(savedMaps) {
    if (savedMaps && savedMaps.length > 0) {
        savedMaps.forEach(function(mapData) {
            addMarkerToMap(mapData);
        });
        
        // 집 마커가 없고 저장된 마커가 있으면 첫 번째 마커로 이동
        if (!homeMarker && savedMaps.length > 0) {
            map.setCenter(new kakao.maps.LatLng(savedMaps[0].lat, savedMaps[0].lng));
        }
    }
}

// 카테고리별 마커 이미지 URL 반환
function getMarkerImageByCategory(category) {
    var imageInfo = {
        src: '',
        size: new kakao.maps.Size(40, 42),
        offset: new kakao.maps.Point(20, 42)
    };
    
    switch(category) {
        case '병원':
            imageInfo.src = 'https://t1.daumcdn.net/localimg/localimages/07/mapapidoc/markerStar.png';
            imageInfo.size = new kakao.maps.Size(24, 35);
            imageInfo.offset = new kakao.maps.Point(12, 35);
            break;
        case '약국':
            imageInfo.src = 'https://t1.daumcdn.net/localimg/localimages/07/2018/pc/img/marker_spot.png';
            imageInfo.size = new kakao.maps.Size(30, 35);
            imageInfo.offset = new kakao.maps.Point(15, 35);
            break;
        case '마트':
        case '편의점':
            imageInfo.src = 'https://t1.daumcdn.net/localimg/localimages/07/mapapidoc/marker_number_blue.png';
            imageInfo.size = new kakao.maps.Size(36, 37);
            imageInfo.offset = new kakao.maps.Point(18, 37);
            break;
        case '공원':
            imageInfo.src = 'https://t1.daumcdn.net/localimg/localimages/07/mapapidoc/marker_number_green.png';
            imageInfo.size = new kakao.maps.Size(36, 37);
            imageInfo.offset = new kakao.maps.Point(18, 37);
            break;
        case '복지관':
            imageInfo.src = 'https://t1.daumcdn.net/localimg/localimages/07/mapapidoc/marker_number_orange.png';
            imageInfo.size = new kakao.maps.Size(36, 37);
            imageInfo.offset = new kakao.maps.Point(18, 37);
            break;
        default:
            imageInfo.src = 'https://t1.daumcdn.net/localimg/localimages/07/mapapidoc/markerStar.png';
            imageInfo.size = new kakao.maps.Size(24, 35);
            imageInfo.offset = new kakao.maps.Point(12, 35);
            break;
    }
    
    return new kakao.maps.MarkerImage(imageInfo.src, imageInfo.size, {offset: imageInfo.offset});
}

// 지도에 마커 추가
function addMarkerToMap(mapData) {
    var position = new kakao.maps.LatLng(mapData.lat, mapData.lng);
    
    // 카테고리별 마커 이미지 가져오기
    var markerImage = getMarkerImageByCategory(mapData.mapCategory);
    
    var marker = new kakao.maps.Marker({
        position: position,
        map: map,
        image: markerImage,
        title: mapData.mapName
    });
    
    // 인포윈도우 생성
    var infowindow = new kakao.maps.InfoWindow({
        content: '<div style="padding:12px;font-size:13px;min-width:180px;text-align:center;">' +
                 '<div style="font-weight:700;color:#333;margin-bottom:5px;">' + mapData.mapName + '</div>' +
                 '<div style="display:inline-block;padding:3px 10px;background:#e8eaf6;color:#667eea;border-radius:12px;font-size:11px;">' +
                 mapData.mapCategory + '</div>' +
                 '</div>'
    });
    
    // 마커 클릭 이벤트
    kakao.maps.event.addListener(marker, 'click', function() {
        // 다른 모든 인포윈도우 닫기
        markers.forEach(function(item) {
            if (item.infowindow) {
                item.infowindow.close();
            }
        });
        
        searchMarkers.forEach(function(item) {
            if (item.infowindow) {
                item.infowindow.close();
            }
        });
        
        // 집 인포윈도우도 닫기
        if (homeInfowindow) {
            homeInfowindow.close();
        }
        
        // 클릭한 마커의 인포윈도우만 열기
        infowindow.open(map, marker);
    });
    
    markers.push({
        marker: marker,
        infowindow: infowindow,
        mapId: mapData.mapId
    });
}

// 모달 열기
function openMapModal(lat, lng) {
    document.getElementById('modalLat').value = lat;
    document.getElementById('modalLng').value = lng;
    document.getElementById('mapModal').classList.add('show');
    
    // 주소 조회
    geocoder.coord2Address(lng, lat, function(result, status) {
        if (status === kakao.maps.services.Status.OK) {
            var addr = result[0].address.address_name;
            document.getElementById('modalAddress').textContent = addr;
        } else {
            document.getElementById('modalAddress').textContent = '위도: ' + lat.toFixed(6) + ', 경도: ' + lng.toFixed(6);
        }
    });
    
    // 폼 초기화
    document.getElementById('mapLocationForm').reset();
}

// 모달 닫기
function closeMapModal() {
    document.getElementById('mapModal').classList.remove('show');
    
    // 임시 마커 제거
    if (tempMarker) {
        tempMarker.setMap(null);
        tempMarker = null;
    }
}

// 장소 저장
async function saveMapLocation() {
    var form = document.getElementById('mapLocationForm');
    if (!form.checkValidity()) {
        form.reportValidity();
        return;
    }
    
    var saveBtn = document.querySelector('.modal-btn-save');
    saveBtn.disabled = true;
    saveBtn.textContent = '저장 중...';
    
    var formData = {
        recId: parseInt(document.getElementById('modalRecId').value),
        mapName: document.getElementById('modalMapName').value.trim(),
        mapCategory: document.getElementById('modalCategory').value,
        mapContent: document.getElementById('modalContent').value.trim(),
        mapLatitude: parseFloat(document.getElementById('modalLat').value),
        mapLongitude: parseFloat(document.getElementById('modalLng').value)
    };
    
    try {
        const response = await fetch('/api/map', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify(formData)
        });
        
        const result = await response.json();
        
        if (result.success) {
            alert('장소가 성공적으로 저장되었습니다!');
            closeMapModal();
            location.reload(); // 페이지 새로고침
        } else {
            alert('저장 실패: ' + (result.message || '알 수 없는 오류'));
            saveBtn.disabled = false;
            saveBtn.textContent = '저장';
        }
    } catch (error) {
        console.error('저장 오류:', error);
        alert('저장 중 오류가 발생했습니다.');
        saveBtn.disabled = false;
        saveBtn.textContent = '저장';
    }
}

// 장소 삭제
async function deleteLocation(mapId) {
    if (!confirm('이 장소를 삭제하시겠습니까?')) {
        return;
    }
    
    try {
        const response = await fetch('/api/map/' + mapId, {
            method: 'DELETE'
        });
        
        const result = await response.json();
        
        if (result.success) {
            alert('장소가 삭제되었습니다.');
            location.reload();
        } else {
            alert('삭제 실패: ' + (result.message || '알 수 없는 오류'));
        }
    } catch (error) {
        console.error('삭제 오류:', error);
        alert('삭제 중 오류가 발생했습니다.');
    }
}

// 마커에 포커스
function focusMarker(lat, lng) {
    var position = new kakao.maps.LatLng(lat, lng);
    map.setCenter(position);
    map.setLevel(3);
    
    // 해당 마커의 인포윈도우 열기
    markers.forEach(function(item) {
        var markerPos = item.marker.getPosition();
        if (Math.abs(markerPos.getLat() - lat) < 0.0001 && 
            Math.abs(markerPos.getLng() - lng) < 0.0001) {
            item.infowindow.open(map, item.marker);
        }
    });
}

// 집 마커에 포커스
function focusHomeMarker() {
    if (homeMarker && homeInfowindow) {
        var position = homeMarker.getPosition();
        map.setCenter(position);
        map.setLevel(3);
        
        // 다른 모든 인포윈도우 닫기
        markers.forEach(function(item) {
            if (item.infowindow) {
                item.infowindow.close();
            }
        });
        
        searchMarkers.forEach(function(item) {
            if (item.infowindow) {
                item.infowindow.close();
            }
        });
        
        // 집 인포윈도우만 열기
        homeInfowindow.open(map, homeMarker);
    }
}

// 장소 상세 정보 표시
async function showLocationDetail(mapId) {
    currentLocationId = mapId;
    
    try {
        const response = await fetch('/api/map/' + mapId);
        const result = await response.json();
        
        if (result.success && result.data) {
            var location = result.data;
            currentLocationLat = location.mapLatitude;
            currentLocationLng = location.mapLongitude;
            
            // 모달에 정보 표시
            document.getElementById('detailLocationName').textContent = location.mapName || '-';
            document.getElementById('detailLocationCategory').textContent = location.mapCategory || '-';
            document.getElementById('detailLocationContent').textContent = location.mapContent || '메모가 없습니다.';
            
            // 거리 계산 및 표시
            var distanceText = '거리 계산 중...';
            if (homeMarker && homeMarker.getPosition()) {
                var homePos = homeMarker.getPosition();
                var locationLat = parseFloat(location.mapLatitude);
                var locationLng = parseFloat(location.mapLongitude);
                
                var distance = calculateDistance(
                    homePos.getLat(), homePos.getLng(),
                    locationLat, locationLng
                );
                
                if (distance < 1000) {
                    distanceText = Math.round(distance) + 'm';
                } else {
                    distanceText = (distance / 1000).toFixed(2) + 'km';
                }
            } else {
                distanceText = '집 위치 정보가 없습니다.';
            }
            document.getElementById('detailLocationDistance').textContent = distanceText;
            
            // 주소 조회
            geocoder.coord2Address(location.mapLongitude, location.mapLatitude, function(result, status) {
                if (status === kakao.maps.services.Status.OK) {
                    var addr = result[0].address.address_name;
                    document.getElementById('detailAddress').textContent = addr;
                } else {
                    document.getElementById('detailAddress').textContent = '위도: ' + location.mapLatitude.toFixed(6) + ', 경도: ' + location.mapLongitude.toFixed(6);
                }
            });
            
            // 모달 표시
            document.getElementById('locationDetailModal').classList.add('show');
            
            // 지도에 포커스
            focusMarker(location.mapLatitude, location.mapLongitude);
        } else {
            alert('장소 정보를 불러오는 중 오류가 발생했습니다.');
        }
    } catch (error) {
        console.error('장소 정보 로드 실패:', error);
        alert('장소 정보를 불러오는 중 오류가 발생했습니다.');
    }
}

// 장소 상세 모달 닫기
function closeLocationDetailModal() {
    document.getElementById('locationDetailModal').classList.remove('show');
    currentLocationId = null;
    currentLocationLat = null;
    currentLocationLng = null;
}

// 지도에서 장소 보기
function viewLocationOnMap() {
    if (currentLocationLat && currentLocationLng) {
        focusMarker(currentLocationLat, currentLocationLng);
        closeLocationDetailModal();
    }
}

// 모달에서 장소 삭제
async function deleteLocationFromModal() {
    if (!currentLocationId) return;
    
    if (!confirm('이 장소를 삭제하시겠습니까?\n삭제된 장소는 복구할 수 없습니다.')) {
        return;
    }
    
    try {
        const response = await fetch('/api/map/' + currentLocationId, {
            method: 'DELETE'
        });
        
        const result = await response.json();
        
        if (result.success) {
            alert('장소가 삭제되었습니다.');
            closeLocationDetailModal();
            location.reload(); // 페이지 새로고침
        } else {
            alert('삭제 실패: ' + (result.message || '알 수 없는 오류'));
        }
    } catch (error) {
        console.error('삭제 오류:', error);
        alert('삭제 중 오류가 발생했습니다.');
    }
}

// 탭 전환 함수
function switchMapTab(element, tabType) {
    // 모든 탭에서 active 클래스 제거
    document.querySelectorAll('.map-tab').forEach(tab => {
        tab.classList.remove('active');
    });
    
    // 클릭한 탭에 active 클래스 추가
    element.classList.add('active');
    
    // 모드 전환
    currentMapMode = tabType;
    
    if (tabType === 'mymap') {
        // 내 지도 모드: 기존 기능 활성화
        enableMyMapMode();
    } else if (tabType === 'course') {
        // 산책코스 모드: 산책코스 기능 활성화
        enableCourseMode();
    }
    
    console.log('탭 전환:', tabType);
}

// 내 지도 모드 활성화
function enableMyMapMode() {
    // 산책코스 관련 요소 숨기기
    clearCourseMode();
    
    // 산책코스 목록 숨기기
    var courseListContainer = document.getElementById('courseListContainer');
    if (courseListContainer) {
        courseListContainer.style.display = 'none';
    }
    
    // 모든 장소 목록 다시 표시
    var hiddenItems = document.querySelectorAll('.hidden-in-course-mode');
    hiddenItems.forEach(function(item) {
        item.style.display = 'flex';
        item.classList.remove('hidden-in-course-mode');
    });
    
    // 구분선 다시 표시 (집과 장소 목록 사이의 구분선)
    var locationItemsContainer = document.querySelector('#mapLocationList .map-location-items');
    if (locationItemsContainer) {
        var divider = locationItemsContainer.querySelector('.home-location-divider');
        if (divider) {
            divider.style.display = 'block';
        }
    }
    
    // "더 보기" 메시지 제거
    var moreItemsMsg = document.getElementById('moreLocationItemsMsg');
    if (moreItemsMsg) {
        moreItemsMsg.remove();
    }
    
    // 검색창 표시
    document.querySelector('.map-search-container').style.display = 'block';
    document.getElementById('mapSearchInput').placeholder = '병원, 약국, 공원 등 장소를 검색하세요...';
    
    // 경로 초기화 버튼 숨기기
    var resetBtn = document.getElementById('courseResetBtn');
    if (resetBtn) {
        resetBtn.style.display = 'none';
    }
    
    // 저장 버튼 숨기기
    var saveBtn = document.getElementById('courseSaveBtn');
    if (saveBtn) {
        saveBtn.style.display = 'none';
    }
    
    // 기존 지도 클릭 이벤트 복원
    map.setCursor('default');
}

// 산책코스 모드 활성화
function enableCourseMode() {
    // 검색창 숨기기
    document.querySelector('.map-search-container').style.display = 'none';
    
    // 경로 초기화 버튼 표시
    var resetBtn = document.getElementById('courseResetBtn');
    if (resetBtn) {
        resetBtn.style.display = 'inline-flex';
    }
    
    // 지도 커서 변경 (핀 찍기 모드)
    map.setCursor('crosshair');
    
    // 산책코스 모드에서 장소 목록 완전히 숨기기 (집 제외)
    hideLocationItemsInCourseMode();
    
    // 산책코스 목록 표시
    var courseListContainer = document.getElementById('courseListContainer');
    if (courseListContainer) {
        courseListContainer.style.display = 'block';
    }
    
    // 산책코스 목록 로드
    loadCourseList();
}

// 산책코스 모드에서 장소 목록 완전히 숨기기 (집 제외)
function hideLocationItemsInCourseMode() {
    var locationItems = document.querySelectorAll('#mapLocationList .map-location-item:not(.home-location)');
    
    // 기존 "더 보기" 메시지 제거
    var existingMsg = document.getElementById('moreLocationItemsMsg');
    if (existingMsg) {
        existingMsg.remove();
    }
    
    // 모든 장소 목록 숨기기 (집 제외)
    locationItems.forEach(function(item) {
        item.style.display = 'none';
        item.classList.add('hidden-in-course-mode');
    });
    
    // 구분선 숨기기 (집과 장소 목록 사이의 구분선)
    var locationItemsContainer = document.querySelector('#mapLocationList .map-location-items');
    if (locationItemsContainer) {
        var divider = locationItemsContainer.querySelector('.home-location-divider');
        if (divider) {
            divider.style.display = 'none';
        }
    }
}

// 산책코스 모드 초기화
function clearCourseMode() {
    // 산책코스 마커 제거
    courseMarkers.forEach(function(item) {
        if (item.marker) {
            item.marker.setMap(null);
        }
    });
    courseMarkers = [];
    
    // 구간별 마커 제거
    segmentMarkers.forEach(function(item) {
        if (item.marker) {
            item.marker.setMap(null);
        }
        if (item.infowindow) {
            item.infowindow.close();
        }
    });
    segmentMarkers = [];
    
    // 경로 선 제거
    if (coursePolyline) {
        coursePolyline.setMap(null);
        coursePolyline = null;
    }
    
    // 거리 정보 초기화
    courseDistances = [];
    totalDistance = 0;
    
    // 거리 표시 제거
    var distanceInfo = document.getElementById('courseDistanceInfo');
    if (distanceInfo) {
        distanceInfo.remove();
    }
    
    // 저장 버튼 숨기기 (경로 초기화 옆에 있음)
    var saveBtn = document.getElementById('courseSaveBtn');
    if (saveBtn) {
        saveBtn.style.display = 'none';
    }
}

// 산책코스 모드 안내 표시
function showCourseModeGuide() {
    // 기존 안내 제거
    var existingGuide = document.getElementById('courseModeGuide');
    if (existingGuide) {
        existingGuide.remove();
    }
    
    // 안내 메시지 생성
    var guide = document.createElement('div');
    guide.id = 'courseModeGuide';
    guide.style.cssText = 'position: absolute; top: 80px; left: 20px; background: rgba(102, 126, 234, 0.95); color: white; padding: 15px 20px; border-radius: 10px; z-index: 10; box-shadow: 0 4px 12px rgba(0,0,0,0.2); max-width: 300px;';
    guide.innerHTML = '<div style="font-weight: 600; margin-bottom: 8px;"><i class="fas fa-walking"></i> 산책코스 모드</div>' +
                     '<div style="font-size: 13px; line-height: 1.6;">지도를 클릭하여 산책 경로를 만들어보세요!<br/>집에서 시작하여 원하는 곳에 핀을 찍어주세요.</div>';
    
    document.querySelector('.map-right').appendChild(guide);
}

// 현재 산책코스 초기화
function clearCurrentCourse() {
    // 확인 메시지 없이 바로 초기화
    clearCourseMode();
}

// 산책코스 목록 로드
async function loadCourseList() {
    var recId = parseInt(document.getElementById('modalRecId')?.value || defaultRecId);
    if (!recId) return;
    
    try {
        const response = await fetch('/api/course/recipient/' + recId);
        const result = await response.json();
        
        if (result.success && result.data) {
            displayCourseList(result.data);
        }
    } catch (error) {
        console.error('산책코스 목록 로드 실패:', error);
    }
}

// 산책코스 목록 표시
function displayCourseList(courses) {
    // map-address-panel 안의 map-location-items에 산책코스 목록 추가
    var locationItems = document.querySelector('#mapLocationList .map-location-items');
    if (!locationItems) return;
    
    // 기존 산책코스 섹션 제거
    var existingCourseSection = document.getElementById('courseListContainer');
    if (existingCourseSection) {
        existingCourseSection.remove();
    }
    
    // 산책코스 섹션 생성 - 구분선 하나로 통합
    var courseListContainer = document.createElement('div');
    courseListContainer.id = 'courseListContainer';
    courseListContainer.className = 'course-list-container';
    // 첫 번째 산책코스 항목 위에만 구분선 표시 (내 지도 모드와 동일한 간격: margin-top: 10px, padding-top: 0)
    // CSS에서 이미 스타일이 정의되어 있으므로 인라인 스타일 제거
    
    if (courses.length === 0) {
        courseListContainer.innerHTML = '<div style="text-align: center; padding: 15px; color: #999; font-size: 13px;">저장된 산책코스가 없습니다.</div>';
        locationItems.appendChild(courseListContainer);
        return;
    }
    
    var html = '';
    
    courses.forEach(function(course) {
        var pathData = null;
        try {
            pathData = JSON.parse(course.coursePathData || '{}');
        } catch (e) {
            console.error('경로 데이터 파싱 실패:', e);
        }
        
        var distanceText = '';
        if (pathData && pathData.totalDistance) {
            if (pathData.totalDistance < 1000) {
                distanceText = Math.round(pathData.totalDistance) + 'm';
            } else {
                distanceText = (pathData.totalDistance / 1000).toFixed(2) + 'km';
            }
        }
        
        // 서버 객체와 동일한 스타일로 변경
        html += '<div class="map-location-item course-item" data-course-id="' + course.courseId + '" onclick="showCourseDetail(' + course.courseId + ')">' +
               '<div class="location-info">' +
               '<div class="location-name-wrapper">' +
               '<div class="location-name">' + course.courseName + '</div>' +
               '<div class="location-category course-category">' + course.courseType + '</div>' +
               '</div>' +
               '</div>' +
               (distanceText ? '<div class="location-address course-distance">' + distanceText + '</div>' : '') +
               '<button class="location-delete-btn" onclick="event.stopPropagation(); deleteCourse(' + course.courseId + ')">' +
               '<i class="bi bi-x-circle"></i>' +
               '</button>' +
               '</div>';
    });
    
    courseListContainer.innerHTML = html;
    locationItems.appendChild(courseListContainer);
}

// 저장된 산책코스를 지도에 표시
function loadCourseOnMap(courseId) {
    // 기존 산책코스 제거
    clearCourseMode();
    
    // 산책코스 데이터 로드
    fetch('/api/course/' + courseId)
        .then(response => response.json())
        .then(result => {
            if (result.success && result.data) {
                var course = result.data;
                var pathData = JSON.parse(course.coursePathData || '{}');
                
                if (pathData.points && pathData.points.length >= 2) {
                    // 각 지점에 핀 추가
                    pathData.points.forEach(function(point, index) {
                        var latlng = new kakao.maps.LatLng(point.lat, point.lng);
                        addCoursePinFromData(latlng, point.number);
                    });
                    
                    // 경로 업데이트
                    updateCoursePath();
                    
                    // 첫 번째 지점으로 지도 이동
                    if (pathData.points.length > 0) {
                        var firstPoint = pathData.points[0];
                        map.setCenter(new kakao.maps.LatLng(firstPoint.lat, firstPoint.lng));
                        map.setLevel(4);
                    }
                }
            }
        })
        .catch(error => {
            console.error('산책코스 로드 실패:', error);
            alert('산책코스를 불러오는 중 오류가 발생했습니다.');
        });
}

// 데이터에서 산책코스 핀 추가 (저장된 코스 불러오기용)
function addCoursePinFromData(latlng, pinNumber) {
    var markerImage = new kakao.maps.MarkerImage(
        'https://t1.daumcdn.net/localimg/localimages/07/mapapidoc/marker_number_blue.png',
        new kakao.maps.Size(36, 37),
        {offset: new kakao.maps.Point(18, 37)}
    );
    
    if (pinNumber === 0) {
        markerImage = new kakao.maps.MarkerImage(
            'data:image/svg+xml;base64,' + btoa(
                '<svg xmlns="http://www.w3.org/2000/svg" width="48" height="48" viewBox="0 0 48 48">' +
                '<path d="M24 8L10 20v18h10v-12h8v12h10V20z" fill="#e74c3c"/>' +
                '</svg>'
            ),
            new kakao.maps.Size(48, 48),
            {offset: new kakao.maps.Point(24, 48)}
        );
    }
    
    var marker = new kakao.maps.Marker({
        position: latlng,
        map: map,
        image: markerImage,
        title: pinNumber === 0 ? '출발지 (집)' : '경유지 ' + pinNumber
    });
    
    var infowindow = new kakao.maps.InfoWindow({
        content: '<div style="padding:10px;font-size:13px;text-align:center;min-width:120px;">' +
                 '<strong>' + (pinNumber === 0 ? '출발지 (집)' : '경유지 ' + pinNumber) + '</strong>' +
                 '</div>',
        removable: false
    });
    
    // 마커 클릭 이벤트 - 인포윈도우 표시 비활성화 (사용자 요청)
    // kakao.maps.event.addListener(marker, 'click', function() {
    //     courseMarkers.forEach(function(item) {
    //         if (item.infowindow) {
    //             item.infowindow.close();
    //         }
    //     });
    //     infowindow.open(map, marker);
    // });
    
    courseMarkers.push({
        marker: marker,
        infowindow: infowindow,
        position: latlng,
        number: pinNumber
    });
}

// 산책코스 삭제
async function deleteCourse(courseId) {
    if (!confirm('이 산책코스를 삭제하시겠습니까?')) {
        return;
    }
    
    try {
        const response = await fetch('/api/course/' + courseId, {
            method: 'DELETE'
        });
        
        const result = await response.json();
        
        if (result.success) {
            alert('산책코스가 삭제되었습니다.');
            loadCourseList(); // 목록 새로고침
        } else {
            alert('삭제 실패: ' + (result.message || '알 수 없는 오류'));
        }
    } catch (error) {
        console.error('삭제 오류:', error);
        alert('삭제 중 오류가 발생했습니다.');
    }
}

// 산책코스 상세 정보 표시
async function showCourseDetail(courseId) {
    currentCourseId = courseId;
    
    try {
        const response = await fetch('/api/course/' + courseId);
        const result = await response.json();
        
        if (result.success && result.data) {
            var course = result.data;
            var pathData = null;
            try {
                pathData = JSON.parse(course.coursePathData || '{}');
            } catch (e) {
                console.error('경로 데이터 파싱 실패:', e);
            }
            
            // 모달에 정보 표시
            document.getElementById('detailCourseName').textContent = course.courseName || '-';
            document.getElementById('detailCourseType').textContent = course.courseType || '-';
            
            var distanceText = '-';
            if (pathData && pathData.totalDistance) {
                if (pathData.totalDistance < 1000) {
                    distanceText = Math.round(pathData.totalDistance) + 'm';
                } else {
                    distanceText = (pathData.totalDistance / 1000).toFixed(2) + 'km';
                }
            }
            document.getElementById('detailCourseDistance').textContent = distanceText;
            
            var pointsCount = pathData && pathData.points ? pathData.points.length + '개' : '-';
            document.getElementById('detailCoursePoints').textContent = pointsCount;
            
            // 등록일 표시
            if (course.courseRegdate) {
                var regdate = new Date(course.courseRegdate);
                var formattedDate = regdate.getFullYear() + '-' + 
                                   String(regdate.getMonth() + 1).padStart(2, '0') + '-' + 
                                   String(regdate.getDate()).padStart(2, '0');
                document.getElementById('detailCourseRegdate').textContent = formattedDate;
            } else {
                document.getElementById('detailCourseRegdate').textContent = '-';
            }
            
            // 첫 번째 지점 좌표 저장
            if (pathData && pathData.points && pathData.points.length > 0) {
                currentCourseLat = pathData.points[0].lat;
                currentCourseLng = pathData.points[0].lng;
            }
            
            // 모달 표시
            document.getElementById('courseDetailModal').classList.add('show');
        } else {
            alert('산책코스 정보를 불러오는 중 오류가 발생했습니다.');
        }
    } catch (error) {
        console.error('산책코스 정보 로드 실패:', error);
        alert('산책코스 정보를 불러오는 중 오류가 발생했습니다.');
    }
}

// 산책코스 상세 모달 닫기
function closeCourseDetailModal() {
    document.getElementById('courseDetailModal').classList.remove('show');
    currentCourseId = null;
    currentCourseLat = null;
    currentCourseLng = null;
}

// 지도에서 산책코스 보기
function viewCourseOnMap() {
    if (currentCourseId) {
        loadCourseOnMap(currentCourseId);
        closeCourseDetailModal();
    }
}

// 모달에서 산책코스 삭제
async function deleteCourseFromModal() {
    if (!currentCourseId) return;
    
    if (!confirm('이 산책코스를 삭제하시겠습니까?\n삭제된 산책코스는 복구할 수 없습니다.')) {
        return;
    }
    
    try {
        const response = await fetch('/api/course/' + currentCourseId, {
            method: 'DELETE'
        });
        
        const result = await response.json();
        
        if (result.success) {
            alert('산책코스가 삭제되었습니다.');
            closeCourseDetailModal();
            loadCourseList(); // 목록 새로고침
        } else {
            alert('삭제 실패: ' + (result.message || '알 수 없는 오류'));
        }
    } catch (error) {
        console.error('삭제 오류:', error);
        alert('삭제 중 오류가 발생했습니다.');
    }
}

// 위치 검색 함수
function searchLocation() {
    var keyword = document.getElementById('mapSearchInput').value.trim();
    
    if (!keyword) {
        alert('검색어를 입력해주세요.');
        return;
    }
    
    console.log('🔍 검색어:', keyword);
    
    // Places 서비스 객체 생성
    var ps = new kakao.maps.services.Places();
    
    // 현재 지도 중심 좌표 가져오기
    var center = map.getCenter();
    
    // 키워드 검색 (현재 위치 기준)
    ps.keywordSearch(keyword, function(data, status) {
        if (status === kakao.maps.services.Status.OK) {
            console.log('✅ 검색 성공! 결과:', data.length + '개');
            displaySearchResults(data);
        } else if (status === kakao.maps.services.Status.ZERO_RESULT) {
            console.log('❌ 검색 결과 없음');
            displayNoResults();
        } else {
            console.error('❌ 검색 실패:', status);
            alert('검색 중 오류가 발생했습니다.');
        }
    }, {
        location: center,
        radius: 5000, // 5km 반경 검색
        size: 10 // 최대 10개 결과
    });
}

// 검색 결과 표시
function displaySearchResults(places) {
    var resultsContainer = document.getElementById('searchResults');
    resultsContainer.innerHTML = '';
    
    // 이전 검색 마커 제거
    searchMarkers.forEach(function(item) {
        if (item.marker) {
            item.marker.setMap(null);
        }
        if (item.infowindow) {
            item.infowindow.close();
        }
    });
    searchMarkers = [];
    
    places.forEach(function(place, index) {
        // 검색 결과 항목 생성
        var item = document.createElement('div');
        item.className = 'search-result-item';
        item.onclick = function() {
            selectSearchResult(place);
        };
        
        var icon = getCategoryIcon(place.category_name);
        
        item.innerHTML = 
            '<div class="search-result-icon">' +
                '<i class="' + icon + '"></i>' +
            '</div>' +
            '<div class="search-result-info">' +
                '<div class="search-result-name">' + place.place_name + '</div>' +
                '<div class="search-result-address">' + place.address_name + '</div>' +
                '<span class="search-result-category">' + getCategoryText(place.category_name) + '</span>' +
            '</div>';
        
        resultsContainer.appendChild(item);
        
        // 지도에 검색 결과 마커 표시
        var markerPosition = new kakao.maps.LatLng(place.y, place.x);
        var marker = new kakao.maps.Marker({
            position: markerPosition,
            map: map
        });
        
        var infowindow = new kakao.maps.InfoWindow({
            content: '<div style="padding:10px;font-size:13px;text-align:center;min-width:150px;">' +
                     '<strong>' + place.place_name + '</strong><br/>' +
                     '<span style="color:#666;font-size:11px;">' + place.address_name + '</span>' +
                     '</div>'
        });
        
        // 마커 클릭 시 모달 표시
        kakao.maps.event.addListener(marker, 'click', function() {
            // 다른 인포윈도우 모두 닫기
            searchMarkers.forEach(function(item) {
                if (item.infowindow) {
                    item.infowindow.close();
                }
            });
            
            markers.forEach(function(item) {
                if (item.infowindow) {
                    item.infowindow.close();
                }
            });
            
            // 집 인포윈도우도 닫기
            if (homeInfowindow) {
                homeInfowindow.close();
            }
            
            // 검색 결과 상세 모달 표시
            showSearchResultDetailModal(place);
        });
        
        searchMarkers.push({
            marker: marker,
            infowindow: infowindow,
            place: place // place 정보 저장
        });
    });
    
    // 검색 결과 드롭다운 표시
    resultsContainer.classList.add('show');
    
    // 첫 번째 결과로 지도 이동
    if (places.length > 0) {
        var firstPlace = places[0];
        map.setCenter(new kakao.maps.LatLng(firstPlace.y, firstPlace.x));
        map.setLevel(4);
    }
}

// 검색 결과 없음 표시
function displayNoResults() {
    alert('검색 결과가 없습니다.\n다른 검색어로 시도해보세요.');
    
    // 검색 입력창 포커스
    document.getElementById('mapSearchInput').focus();
}

// 검색 결과 선택
function selectSearchResult(place) {
    console.log('📍 선택한 장소:', place.place_name);
    
    // 해당 위치로 지도 이동
    var position = new kakao.maps.LatLng(place.y, place.x);
    map.setCenter(position);
    map.setLevel(3);
    
    // 검색 결과 드롭다운 닫기
    document.getElementById('searchResults').classList.remove('show');
    
    // 해당 마커의 인포윈도우 열기
    searchMarkers.forEach(function(item) {
        var markerPos = item.marker.getPosition();
        if (Math.abs(markerPos.getLat() - place.y) < 0.0001 && 
            Math.abs(markerPos.getLng() - place.x) < 0.0001) {
            
            // 다른 인포윈도우 모두 닫기
            searchMarkers.forEach(function(otherItem) {
                if (otherItem.infowindow) {
                    otherItem.infowindow.close();
                }
            });
            
            // 선택한 마커의 인포윈도우만 열기
            item.infowindow.open(map, item.marker);
        }
    });
}

// 검색 결과 상세 모달 표시
var currentSearchPlace = null; // 현재 선택된 검색 장소 정보 저장

function showSearchResultDetailModal(place) {
    // 현재 선택된 장소 정보 저장
    currentSearchPlace = place;
    
    // 모달에 정보 표시
    document.getElementById('searchResultName').textContent = place.place_name || '-';
    document.getElementById('searchResultCategory').textContent = getCategoryText(place.category_name) || '-';
    document.getElementById('searchResultAddress').textContent = place.address_name || '-';
    
    // 메모 필드 초기화
    document.getElementById('searchResultMemo').value = '';
    
    // 집 주소 표시
    if (recipientAddress && recipientAddress !== '' && recipientAddress !== 'null') {
        document.getElementById('searchResultHomeAddress').textContent = recipientAddress;
    } else {
        document.getElementById('searchResultHomeAddress').textContent = '집 주소 정보가 없습니다.';
    }
    
    // 거리 계산
    var distanceText = '거리 계산 중...';
    if (homeMarker && homeMarker.getPosition()) {
        var homePos = homeMarker.getPosition();
        var placeLat = parseFloat(place.y);
        var placeLng = parseFloat(place.x);
        
        var distance = calculateDistance(
            homePos.getLat(), homePos.getLng(),
            placeLat, placeLng
        );
        
        if (distance < 1000) {
            distanceText = Math.round(distance) + 'm';
        } else {
            distanceText = (distance / 1000).toFixed(2) + 'km';
        }
    } else {
        distanceText = '집 위치 정보가 없습니다.';
    }
    
    document.getElementById('searchResultDistance').textContent = distanceText;
    
    // 모달 표시
    document.getElementById('searchResultDetailModal').classList.add('show');
}

// 검색 결과 상세 모달 닫기
function closeSearchResultDetailModal() {
    document.getElementById('searchResultDetailModal').classList.remove('show');
    currentSearchPlace = null;
    document.getElementById('searchResultMemo').value = '';
}

// 검색 결과 카테고리를 저장용 카테고리로 변환 (병원, 약국, 공원)
function convertCategoryForSave(categoryName) {
    if (!categoryName) return '기타';
    
    var categoryLower = categoryName.toLowerCase();
    
    // 병원 관련
    if (categoryLower.includes('병원') || categoryLower.includes('의원') || 
        categoryLower.includes('의료') || categoryLower.includes('치과') || 
        categoryLower.includes('한의원') || categoryLower.includes('보건소')) {
        return '병원';
    }
    
    // 약국 관련
    if (categoryLower.includes('약국') || categoryLower.includes('한약방')) {
        return '약국';
    }
    
    // 공원 관련
    if (categoryLower.includes('공원') || categoryLower.includes('체육공원') || 
        categoryLower.includes('근린공원') || categoryLower.includes('도시공원')) {
        return '공원';
    }
    
    return '기타';
}

// 검색 결과 장소 저장
async function saveSearchResultLocation() {
    if (!currentSearchPlace) {
        alert('저장할 장소 정보가 없습니다.');
        return;
    }
    
    var saveBtn = document.querySelector('#searchResultDetailModal .modal-btn-save');
    saveBtn.disabled = true;
    saveBtn.textContent = '저장 중...';
    
    // 카테고리 변환 (병원, 약국, 공원)
    var category = convertCategoryForSave(currentSearchPlace.category_name);
    
    var formData = {
        recId: defaultRecId,
        mapName: currentSearchPlace.place_name || '',
        mapCategory: category,
        mapContent: document.getElementById('searchResultMemo').value.trim(),
        mapLatitude: parseFloat(currentSearchPlace.y),
        mapLongitude: parseFloat(currentSearchPlace.x)
    };
    
    try {
        const response = await fetch('/api/map', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify(formData)
        });
        
        const result = await response.json();
        
        if (result.success) {
            alert('장소가 성공적으로 저장되었습니다!');
            closeSearchResultDetailModal();
            location.reload(); // 페이지 새로고침
        } else {
            alert('저장 실패: ' + (result.message || '알 수 없는 오류'));
            saveBtn.disabled = false;
            saveBtn.textContent = '저장';
        }
    } catch (error) {
        console.error('저장 오류:', error);
        alert('저장 중 오류가 발생했습니다.');
        saveBtn.disabled = false;
        saveBtn.textContent = '저장';
    }
}

// 카테고리별 아이콘 반환
function getCategoryIcon(categoryName) {
    if (!categoryName) return 'bi bi-geo-alt-fill';
    
    if (categoryName.includes('병원') || categoryName.includes('의료')) return 'bi bi-hospital';
    if (categoryName.includes('약국')) return 'bi bi-capsule';
    if (categoryName.includes('음식') || categoryName.includes('카페')) return 'bi bi-cup-hot';
    if (categoryName.includes('마트') || categoryName.includes('편의점')) return 'bi bi-cart';
    if (categoryName.includes('공원')) return 'bi bi-tree';
    if (categoryName.includes('은행')) return 'bi bi-bank';
    if (categoryName.includes('주차')) return 'bi bi-p-square';
    
    return 'bi bi-geo-alt-fill';
}

// 카테고리 텍스트 정리
function getCategoryText(categoryName) {
    if (!categoryName) return '기타';
    
    var parts = categoryName.split('>');
    return parts[parts.length - 1].trim() || '기타';
}

// 검색창 외부 클릭 시 드롭다운 닫기
document.addEventListener('click', function(e) {
    var searchContainer = document.querySelector('.map-search-container');
    var searchResults = document.getElementById('searchResults');
    
    if (searchContainer && !searchContainer.contains(e.target)) {
        searchResults.classList.remove('show');
    }
});

// 산책코스 모달 열기
function openCourseModal() {
    if (courseMarkers.length < 2) {
        alert('최소 2개 이상의 지점이 필요합니다.');
        return;
    }
    
    // 총 거리 표시
    var distanceText = '';
    if (totalDistance < 1000) {
        distanceText = Math.round(totalDistance) + 'm';
    } else {
        distanceText = (totalDistance / 1000).toFixed(2) + 'km';
    }
    document.getElementById('courseTotalDistance').value = distanceText;
    
    // 지점 수 표시
    document.getElementById('coursePointCount').value = courseMarkers.length + '개 지점';
    
    // 모달 표시
    document.getElementById('courseModal').classList.add('show');
}

// 산책코스 모달 닫기
function closeCourseModal() {
    document.getElementById('courseModal').classList.remove('show');
    document.getElementById('courseForm').reset();
}

// 산책코스 서버에 저장
async function saveCourseToServer() {
    var form = document.getElementById('courseForm');
    if (!form.checkValidity()) {
        form.reportValidity();
        return;
    }
    
    if (courseMarkers.length < 2) {
        alert('최소 2개 이상의 지점이 필요합니다.');
        return;
    }
    
    var saveBtn = document.querySelector('#courseModal .modal-btn-save');
    saveBtn.disabled = true;
    saveBtn.textContent = '저장 중...';
    
    // 경로 데이터 생성 (JSON 형식)
    var pathData = {
        points: courseMarkers.map(function(item, index) {
            return {
                number: item.number,
                lat: item.position.getLat(),
                lng: item.position.getLng()
            };
        }),
        distances: courseDistances,
        totalDistance: totalDistance
    };
    
    var formData = {
        recId: parseInt(document.getElementById('courseRecId').value),
        courseName: document.getElementById('courseName').value.trim(),
        courseType: document.getElementById('courseType').value,
        coursePathData: JSON.stringify(pathData)
    };
    
    try {
        const response = await fetch('/api/course', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify(formData)
        });
        
        const result = await response.json();
        
        if (result.success) {
            alert('산책코스가 성공적으로 저장되었습니다!');
            closeCourseModal();
            
            // 산책코스 모드 초기화 또는 목록 새로고침
            clearCourseMode();
            loadCourseList();
        } else {
            alert('저장 실패: ' + (result.message || '알 수 없는 오류'));
            saveBtn.disabled = false;
            saveBtn.textContent = '저장';
        }
    } catch (error) {
        console.error('저장 오류:', error);
        alert('저장 중 오류가 발생했습니다.');
        saveBtn.disabled = false;
        saveBtn.textContent = '저장';
    }
}

// 일정 제목 길이 제한 (17자)
function limitScheduleTitleLength() {
    var scheduleItems = document.querySelectorAll('.hourly-schedule-item .hourly-name');
    
    scheduleItems.forEach(function(item) {
        var text = item.textContent || item.innerText;
        
        if (text.length > 17) {
            item.textContent = text.substring(0, 17) + '...';
        }
    });
}

// 식단 메뉴 이름 길이 제한 (17자)
function limitMealMenuLength() {
    var mealMenus = document.querySelectorAll('.meal-item .meal-menu');
    
    mealMenus.forEach(function(item) {
        var text = item.textContent || item.innerText;
        
        if (text.length > 17) {
            item.textContent = text.substring(0, 17) + '...';
        }
    });
}

// 일정 목록 스크롤 설정 (5개 이상일 때만)
function setupScheduleScroll() {
    var scheduleList = document.querySelector('.hourly-schedule-list');
    if (!scheduleList) return;
    
    var scheduleItems = scheduleList.querySelectorAll('.hourly-schedule-item');
    var itemCount = scheduleItems.length;
    
    // 일정 항목 하나의 높이 계산 (실제 높이 + gap)
    if (itemCount > 0) {
        var firstItem = scheduleItems[0];
        var itemHeight = firstItem.offsetHeight;
        var gap = 10; // CSS gap 값
        var maxHeight = (itemHeight * 5) + (gap * 4); // 5개 항목 + 4개 gap
        
        if (itemCount > 5) {
            scheduleList.classList.add('scrollable');
            scheduleList.style.maxHeight = maxHeight + 'px';
        } else {
            scheduleList.classList.remove('scrollable');
            scheduleList.style.maxHeight = 'none';
        }
    }
}

// 페이지 로드 시 초기화
document.addEventListener('DOMContentLoaded', function() {
    // 지도 초기화
    if (typeof kakao !== 'undefined' && kakao.maps) {
        initializeMap();
        
        // 페이지 로드 시 집 마커 먼저, 그 다음 저장된 마커 표시
        window.addEventListener('load', function() {
            loadHomeMarker();      // 1. 집 마커 먼저 표시
        });
    }
    
    // 일정 제목 길이 제한 적용
    limitScheduleTitleLength();
    
    // 식단 메뉴 이름 길이 제한 적용
    limitMealMenuLength();
    
    // 일정 목록 스크롤 설정 (5개 이상일 때만)
    setupScheduleScroll();
});

// 페이지를 떠날 때 인터벌 정리
window.addEventListener('beforeunload', function() {
    stopRecipientLocationUpdate();
});

// IoT 서비스에 집 위치 설정
async function setHomeLocationToIot(latitude, longitude) {
    if (!defaultRecId || defaultRecId === null) {
        console.log('노약자 ID가 없어 집 위치를 설정할 수 없습니다.');
        return;
    }
    
    try {
        const response = await fetch('/api/iot/location/' + defaultRecId + '/home', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({
                latitude: latitude,
                longitude: longitude
            })
        });
        
        const result = await response.json();
        if (result.success) {
            console.log('✅ IoT 서비스에 집 위치 설정 완료');
        } else {
            console.warn('⚠️ IoT 서비스 집 위치 설정 실패:', result.message);
        }
    } catch (error) {
        console.error('❌ IoT 서비스 집 위치 설정 오류:', error);
    }
}

// IoT 서비스에서 노약자 위치 가져오기
async function getRecipientLocationFromIot() {
    if (!defaultRecId || defaultRecId === null) {
        return null;
    }
    
    try {
        const response = await fetch('/api/iot/location/' + defaultRecId);
        const result = await response.json();
        
        if (result.success && result.data) {
            return {
                latitude: result.data.latitude,
                longitude: result.data.longitude
            };
        }
        return null;
    } catch (error) {
        console.error('❌ IoT 서비스 위치 조회 오류:', error);
        return null;
    }
}

// 노약자 실시간 위치 마커 표시
async function loadRecipientLocationMarker() {
    if (!defaultRecId || defaultRecId === null) {
        console.log('노약자 ID가 없어 위치 마커를 표시할 수 없습니다.');
        return;
    }
    
    // IoT 서비스에서 현재 위치 가져오기
    var locationData = await getRecipientLocationFromIot();
    
    if (!locationData) {
        console.log('IoT 서비스에서 위치 정보를 가져올 수 없습니다. 집 위치를 사용합니다.');
        if (!homePosition) {
            console.log('집 위치도 없어 위치 마커를 표시할 수 없습니다.');
            return;
        }
        locationData = {
            latitude: homePosition.getLat(),
            longitude: homePosition.getLng()
        };
    }
    
    // 초기 위치 설정
    var initialPosition = new kakao.maps.LatLng(locationData.latitude, locationData.longitude);
    
    // 노약자 사진 URL이 있으면 커스텀 마커 이미지 생성
    var markerImage = null;
    if (typeof recipientPhotoUrl !== 'undefined' && recipientPhotoUrl && recipientPhotoUrl !== '' && recipientPhotoUrl !== 'null') {
        // Canvas를 사용하여 원형 프로필 이미지 마커 생성
        createCircularMarkerImage(recipientPhotoUrl, function(dataUrl) {
            if (dataUrl) {
                markerImage = new kakao.maps.MarkerImage(
                    dataUrl,
                    new kakao.maps.Size(60, 70),
                    {offset: new kakao.maps.Point(30, 70)}
                );
                createRecipientMarkerWithImage(markerImage, initialPosition);
            } else {
                // 이미지 로드 실패 시 기본 마커 사용
                createDefaultRecipientMarker(initialPosition);
            }
        });
        return; // 비동기 처리이므로 여기서 리턴
    } else {
        // 기본 마커 이미지 (사람 아이콘)
        markerImage = new kakao.maps.MarkerImage(
            'data:image/svg+xml;base64,' + btoa(
                '<svg xmlns="http://www.w3.org/2000/svg" width="50" height="60" viewBox="0 0 50 60">' +
                '<circle cx="25" cy="25" r="20" fill="#667eea" stroke="#fff" stroke-width="3"/>' +
                '<circle cx="25" cy="20" r="7" fill="#fff"/>' +
                '<path d="M10 45 Q25 35 40 45" fill="#fff"/>' +
                '<path d="M25 45 L20 55 L30 55 Z" fill="#667eea" stroke="#fff" stroke-width="2"/>' +
                '</svg>'
            ),
            new kakao.maps.Size(50, 60),
            {offset: new kakao.maps.Point(25, 60)}
        );
        createDefaultRecipientMarker(initialPosition);
    }
}

// Canvas를 사용하여 원형 프로필 이미지 마커 생성
function createCircularMarkerImage(photoUrl, callback) {
    var canvas = document.createElement('canvas');
    canvas.width = 60;
    canvas.height = 70;
    var ctx = canvas.getContext('2d');
    
    var img = new Image();
    img.crossOrigin = 'anonymous'; // CORS 문제 해결 시도
    
    img.onload = function() {
        // 하단 화살표 그리기
        ctx.fillStyle = '#667eea';
        ctx.strokeStyle = '#fff';
        ctx.lineWidth = 2;
        ctx.beginPath();
        ctx.moveTo(30, 55);
        ctx.lineTo(25, 65);
        ctx.lineTo(35, 65);
        ctx.closePath();
        ctx.fill();
        ctx.stroke();
        
        // 원형 프로필 사진 그리기
        ctx.save();
        ctx.beginPath();
        ctx.arc(30, 30, 25, 0, 2 * Math.PI);
        ctx.clip();
        
        // 배경색 (이미지 로드 실패 시 대비)
        ctx.fillStyle = '#667eea';
        ctx.fillRect(5, 5, 50, 50);
        
        // 프로필 사진 그리기
        ctx.drawImage(img, 5, 5, 50, 50);
        ctx.restore();
        
        // 외곽 테두리
        ctx.strokeStyle = '#fff';
        ctx.lineWidth = 3;
        ctx.beginPath();
        ctx.arc(30, 30, 25, 0, 2 * Math.PI);
        ctx.stroke();
        
        // 그림자 효과
        ctx.shadowColor = 'rgba(0, 0, 0, 0.3)';
        ctx.shadowBlur = 5;
        ctx.shadowOffsetX = 0;
        ctx.shadowOffsetY = 2;
        ctx.beginPath();
        ctx.arc(30, 30, 27, 0, 2 * Math.PI);
        ctx.stroke();
        
        var dataUrl = canvas.toDataURL('image/png');
        callback(dataUrl);
    };
    
    img.onerror = function() {
        console.warn('프로필 이미지 로드 실패:', photoUrl);
        callback(null);
    };
    
    img.src = photoUrl;
}

// 노약자 마커 생성 (이미지가 준비된 후)
function createRecipientMarkerWithImage(markerImage, position) {
    var recipientNameDisplay = (typeof recipientName !== 'undefined' && recipientName) ? recipientName : '노약자';
    
    // 노약자 위치 마커 생성
    recipientLocationMarker = new kakao.maps.Marker({
        position: position,
        map: map,
        image: markerImage,
        title: recipientNameDisplay + '님의 현재 위치',
        zIndex: 1000 // 다른 마커보다 위에 표시
    });
    
    // 인포윈도우 생성 및 이벤트 리스너 추가
    setupRecipientMarkerEvents(recipientNameDisplay);
    
    console.log('✅ 노약자 위치 마커 표시 완료 (프로필 이미지)');
    
    // 10초마다 위치 업데이트 시작
    startRecipientLocationUpdate();
}

// 기본 노약자 마커 생성
function createDefaultRecipientMarker(position) {
    var recipientNameDisplay = (typeof recipientName !== 'undefined' && recipientName) ? recipientName : '노약자';
    
    // 기본 마커 이미지 (사람 아이콘)
    var markerImage = new kakao.maps.MarkerImage(
        'data:image/svg+xml;base64,' + btoa(
            '<svg xmlns="http://www.w3.org/2000/svg" width="50" height="60" viewBox="0 0 50 60">' +
            '<circle cx="25" cy="25" r="20" fill="#667eea" stroke="#fff" stroke-width="3"/>' +
            '<circle cx="25" cy="20" r="7" fill="#fff"/>' +
            '<path d="M10 45 Q25 35 40 45" fill="#fff"/>' +
            '<path d="M25 45 L20 55 L30 55 Z" fill="#667eea" stroke="#fff" stroke-width="2"/>' +
            '</svg>'
        ),
        new kakao.maps.Size(50, 60),
        {offset: new kakao.maps.Point(25, 60)}
    );
    
    // 노약자 위치 마커 생성
    recipientLocationMarker = new kakao.maps.Marker({
        position: position,
        map: map,
        image: markerImage,
        title: recipientNameDisplay + '님의 현재 위치',
        zIndex: 1000 // 다른 마커보다 위에 표시
    });
    
    // 인포윈도우 생성 및 이벤트 리스너 추가
    setupRecipientMarkerEvents(recipientNameDisplay);
    
    console.log('✅ 노약자 위치 마커 표시 완료 (기본 아이콘)');
    
    // 10초마다 위치 업데이트 시작
    startRecipientLocationUpdate();
}

// 노약자 마커 이벤트 설정
function setupRecipientMarkerEvents(recipientNameDisplay) {
    // 인포윈도우 생성
    var recipientInfowindow = new kakao.maps.InfoWindow({
        content: '<div style="padding:12px;font-size:13px;min-width:150px;text-align:center;">' +
                 '<div style="font-weight:700;color:#667eea;margin-bottom:5px;">' +
                 '<i class="bi bi-person-walking"></i> ' + recipientNameDisplay + '님</div>' +
                 '<div style="font-size:11px;color:#666;">실시간 위치</div>' +
                 '</div>',
        removable: false
    });
    
    // 마커 클릭 시 인포윈도우 표시
    kakao.maps.event.addListener(recipientLocationMarker, 'click', function() {
        // 다른 모든 인포윈도우 닫기
        markers.forEach(function(item) {
            if (item.infowindow) {
                item.infowindow.close();
            }
        });
        
        searchMarkers.forEach(function(item) {
            if (item.infowindow) {
                item.infowindow.close();
            }
        });
        
        if (homeInfowindow) {
            homeInfowindow.close();
        }
        
        recipientInfowindow.open(map, recipientLocationMarker);
    });
}

// 노약자 위치 업데이트 시작 (10초 간격)
function startRecipientLocationUpdate() {
    // 기존 인터벌이 있으면 제거
    if (recipientLocationInterval) {
        clearInterval(recipientLocationInterval);
    }
    
    // 10초마다 위치 업데이트
    recipientLocationInterval = setInterval(function() {
        updateRecipientLocation();
    }, 10000); // 10초 = 10000ms
    
    console.log('✅ 노약자 위치 업데이트 시작 (10초 간격)');
}

// 노약자 위치 업데이트 (IoT 서비스에서 가져오기)
async function updateRecipientLocation() {
    if (!recipientLocationMarker || !defaultRecId || defaultRecId === null) {
        return;
    }
    
    try {
        // IoT 서비스에 위치 업데이트 요청 (시뮬레이션)
        const updateResponse = await fetch('/api/iot/location/' + defaultRecId + '/update', {
            method: 'POST'
        });
        
        const updateResult = await updateResponse.json();
        
        if (updateResult.success && updateResult.data) {
            var newLat = updateResult.data.latitude;
            var newLng = updateResult.data.longitude;
            var newPosition = new kakao.maps.LatLng(newLat, newLng);
            
            // 마커 위치 업데이트
            if (recipientLocationMarker) {
                recipientLocationMarker.setPosition(newPosition);
                console.log('📍 노약자 위치 업데이트 (IoT):', newLat.toFixed(6), newLng.toFixed(6));
            }
        } else {
            console.warn('⚠️ IoT 서비스 위치 업데이트 실패:', updateResult.message);
        }
    } catch (error) {
        console.error('❌ IoT 서비스 위치 업데이트 오류:', error);
    }
}

// 노약자 위치 업데이트 중지
function stopRecipientLocationUpdate() {
    if (recipientLocationInterval) {
        clearInterval(recipientLocationInterval);
        recipientLocationInterval = null;
        console.log('⏹️ 노약자 위치 업데이트 중지');
    }
}

// ESC 키로 모달 닫기
document.addEventListener('keydown', function(e) {
    if (e.key === 'Escape') {
        if (document.getElementById('mapModal') && document.getElementById('mapModal').classList.contains('show')) {
            closeMapModal();
        }
        if (document.getElementById('courseModal') && document.getElementById('courseModal').classList.contains('show')) {
            closeCourseModal();
        }
        if (document.getElementById('locationDetailModal') && document.getElementById('locationDetailModal').classList.contains('show')) {
            closeLocationDetailModal();
        }
        if (document.getElementById('courseDetailModal') && document.getElementById('courseDetailModal').classList.contains('show')) {
            closeCourseDetailModal();
        }
        if (document.getElementById('searchResultDetailModal') && document.getElementById('searchResultDetailModal').classList.contains('show')) {
            closeSearchResultDetailModal();
        }
    }
});

