// 전역 변수
var map;
var markers = [];
var geocoder = new kakao.maps.services.Geocoder();
var tempMarker = null;
var clickedPosition = null;
var homeMarker = null; // 집 마커
var homeInfowindow = null; // 집 인포윈도우
var recipientLocationMarker = null; // 노약자 실시간 위치 마커
var homePosition = null; // 집 위치 (노약자 위치 업데이트용)

// 산책코스 모드 관련 변수
var currentMapMode = 'mymap'; // 'mymap' 또는 'course'
var courseMarkers = []; // 산책코스 핀들
var coursePolyline = null; // 산책코스 경로 선

// 장소 상세 정보 관련 변수
var currentLocationId = null;
var currentLocationLat = null;
var currentLocationLng = null;

// 산책코스 상세 정보 관련 변수
var currentCourseId = null;

// 위치 검색 함수
var searchMarkers = []; // 검색 결과 마커들

// 지도 초기화 함수
function initializeMap() {
    var mapContainer = document.getElementById('map');
    var mapOption = {
        center: new kakao.maps.LatLng(37.5665, 126.9780),
        level: 5
    };
    map = new kakao.maps.Map(mapContainer, mapOption);

    kakao.maps.event.addListener(map, 'click', function(mouseEvent) {
        if (currentMapMode === 'course') {
            // 산책 코스 모드에서는 클릭 이벤트 비활성화
            return;
        }

        var latlng = mouseEvent.latLng;
        markers.forEach(item => item.infowindow && item.infowindow.close());
        searchMarkers.forEach(item => item.infowindow && item.infowindow.close());
        if (homeInfowindow) homeInfowindow.close();
        if (tempMarker) tempMarker.setMap(null);

        tempMarker = new kakao.maps.Marker({
            position: latlng,
            map: map,
            image: new kakao.maps.MarkerImage(
                'https://t1.daumcdn.net/localimg/localimages/07/mapapidoc/marker_red.png',
                new kakao.maps.Size(35, 40)
            )
        });
        clickedPosition = latlng;
        openMapModal(latlng.getLat(), latlng.getLng());
    });
}

// 노약자 집 마커 표시
function loadHomeMarker() {
    if (!recipientAddress || recipientAddress === '' || recipientAddress === 'null') return;
    var cleanAddress = recipientAddress.split(',')[0].split('(')[0].trim();
    geocoder.addressSearch(cleanAddress, function(result, status) {
        if (status === kakao.maps.services.Status.OK) {
            var coords = new kakao.maps.LatLng(result[0].y, result[0].x);
            var homeImageSrc = 'data:image/svg+xml;base64,' + btoa(
                '<svg xmlns="http://www.w3.org/2000/svg" width="48" height="48" viewBox="0 0 48 48">' +
                '<defs><filter id="shadow" x="-50%" y="-50%" width="200%" height="200%"><feGaussianBlur in="SourceAlpha" stdDeviation="2"/><feOffset dx="0" dy="2" result="offsetblur"/><feComponentTransfer><feFuncA type="linear" slope="0.3"/></feComponentTransfer><feMerge><feMergeNode/><feMergeNode in="SourceGraphic"/></feMerge></filter></defs>' +
                '<g filter="url(#shadow)"><path d="M24 8L10 20v18h10v-12h8v12h10V20z" fill="#e74c3c"/><path d="M24 8L10 20v18h10v-12h8v12h10V20z" fill="none" stroke="#c0392b" stroke-width="2"/><circle cx="24" cy="26" r="3" fill="#fff" opacity="0.8"/><rect x="18" y="38" width="2" height="6" fill="#c0392b"/><rect x="28" y="38" width="2" height="6" fill="#c0392b"/></g>' +
                '<circle cx="24" cy="4" r="2" fill="#ffeb3b"/><path d="M24 6 L26 10 L22 10 Z" fill="#ffeb3b"/></svg>'
            );
            var homeImageSize = new kakao.maps.Size(48, 48);
            var homeImageOption = {offset: new kakao.maps.Point(24, 48)};
            var homeImage = new kakao.maps.MarkerImage(homeImageSrc, homeImageSize, homeImageOption);
            homeMarker = new kakao.maps.Marker({ map: map, position: coords, image: homeImage, title: recipientName + '님의 집' });
            homeInfowindow = new kakao.maps.InfoWindow({
                content: `<div style="padding:15px;font-size:14px;min-width:200px;text-align:center;">
                <div style="font-weight:700;color:#333;margin-bottom:8px;">${recipientName}님의 집</div>
                <div style="display:inline-block;padding:5px 12px;background:#e74c3c;color:white;border-radius:20px;font-size:12px;font-weight:600;margin-bottom:8px;">집</div>
                <div style="font-size:12px;color:#666;">${cleanAddress}</div>
                </div>`,
                removable: false
            });
            kakao.maps.event.addListener(homeMarker, 'click', function() {
                markers.forEach(item => item.infowindow && item.infowindow.close());
                searchMarkers.forEach(item => item.infowindow && item.infowindow.close());
                homeInfowindow.open(map, homeMarker);
            });
            map.setCenter(coords);
            map.setLevel(4);
            homePosition = coords;
            setHomeLocationToIot(result[0].y, result[0].x);
        }
    });
}

// 저장된 마커들 표시
function loadSavedMarkersWithData(savedMaps) {
    if (savedMaps && savedMaps.length > 0) {
        savedMaps.forEach(mapData => addMarkerToMap(mapData));
        if (!homeMarker && savedMaps.length > 0) {
            map.setCenter(new kakao.maps.LatLng(savedMaps[0].lat, savedMaps[0].lng));
        }
    }
}

// 카테고리별 마커 이미지 생성 (SVG 아이콘 사용)
function getMarkerImageByCategory(category) {
    var iconColor = '#3498db'; // 모든 마커에 사용할 기본 파란색
    var iconSymbol = '<circle cx="24" cy="24" r="16" fill="' + iconColor + '"/><circle cx="24" cy="24" r="8" fill="#fff"/>'; // 기본 원형 아이콘

    // SVG 마커 이미지 생성
    var svgString = '<svg xmlns="http://www.w3.org/2000/svg" width="48" height="56" viewBox="0 0 48 56">' +
        '<defs><filter id="shadow' + category + '" x="-50%" y="-50%" width="200%" height="200%">' +
        '<feGaussianBlur in="SourceAlpha" stdDeviation="2"/>' +
        '<feOffset dx="0" dy="2" result="offsetblur"/>' +
        '<feComponentTransfer><feFuncA type="linear" slope="0.3"/></feComponentTransfer>' +
        '<feMerge><feMergeNode/><feMergeNode in="SourceGraphic"/></feMerge></filter></defs>' +
        '<g filter="url(#shadow' + category + ')">' +
        '<path d="M24 0C10.7 0 0 10.7 0 24c0 16 24 32 24 32s24-16 24-32C48 10.7 37.3 0 24 0z" fill="' + iconColor + '"/>' +
        iconSymbol +
        '</g></svg>';

    var imageSrc = 'data:image/svg+xml;base64,' + btoa(unescape(encodeURIComponent(svgString)));
    var imageSize = new kakao.maps.Size(50, 45);
    var imageOption = {offset: new kakao.maps.Point(15, 43)};
    var markerImage = new kakao.maps.MarkerImage(imageSrc, imageSize, imageOption);

    return markerImage;
}

// 수정 버튼 클릭 핸들러 (이벤트 전파 방지)
function handleEditButtonClick(mapId, event) {
    if (event) {
        event.stopPropagation();
        event.preventDefault();
    }
    openEditModal(mapId);
}

// 지도에 마커 추가
function addMarkerToMap(mapData) {
    var position = new kakao.maps.LatLng(mapData.lat, mapData.lng);
    var markerImage = getMarkerImageByCategory(mapData.mapCategory);
    var marker = new kakao.maps.Marker({ position: position, map: map, image: markerImage, title: mapData.mapName });
    
    var infowindowContent = `<div style="padding:12px;font-size:13px;min-width:180px;text-align:center;"><div style="font-weight:700;color:#333;margin-bottom:5px;">${mapData.mapName}</div><div style="display:inline-block;padding:3px 10px;background:#e8eaf6;color:#667eea;border-radius:12px;font-size:11px;margin-bottom:8px;">${mapData.mapCategory}</div><button onclick="handleEditButtonClick(${mapData.mapId}, event)" style="display:block;margin-top:10px;background:#667eea;color:white;border:none;padding:6px 12px;border-radius:5px;cursor:pointer;width:100%;font-size:12px;transition:background 0.2s;">수정</button></div>`;
    
    var infowindow = new kakao.maps.InfoWindow({
        content: infowindowContent
    });
    
    kakao.maps.event.addListener(marker, 'click', function() {
        // 다른 모든 인포윈도우 닫기
        markers.forEach(item => {
            if (item.infowindow && item !== markers.find(m => m.mapId === mapData.mapId)) {
                item.infowindow.close();
            }
        });
        searchMarkers.forEach(item => {
            if (item.infowindow) item.infowindow.close();
        });
        if (homeInfowindow) homeInfowindow.close();
        // 산책코스 마커의 인포윈도우도 닫기
        courseMarkers.forEach(item => {
            if (item.infowindow) item.infowindow.close();
        });
        map.setCenter(position);
        map.setLevel(3);
        infowindow.open(map, marker);
    });
    markers.push({ marker: marker, infowindow: infowindow, mapId: mapData.mapId });
}

// 모달 열기
function openMapModal(lat, lng) {
    document.querySelector('#mapModal .map-modal-title span').textContent = '장소 추가';
    document.getElementById('modalLat').value = lat;
    document.getElementById('modalLng').value = lng;
    document.getElementById('mapModal').classList.add('show');
    geocoder.coord2Address(lng, lat, function(result, status) {
        if (status === kakao.maps.services.Status.OK) {
            document.getElementById('modalAddress').textContent = result[0].address.address_name;
        } else {
            document.getElementById('modalAddress').textContent = `위도: ${lat.toFixed(6)}, 경도: ${lng.toFixed(6)}`;
        }
    });
    document.getElementById('mapLocationForm').reset();
}

// 검색 결과로부터 장소 추가 모달 열기
function openAddPlaceModalFromSearch(place) {
    // 모든 InfoWindow 닫기
    searchMarkers.forEach(item => item.infowindow && item.infowindow.close());

    const lat = place.y;
    const lng = place.x;

    // '장소 수정'과 동일한 모달을 사용하되, 제목을 '장소 추가'로 설정
    document.querySelector('#mapModal .map-modal-title span').textContent = '장소 추가';
    
    // 좌표 및 주소 정보 설정
    document.getElementById('modalLat').value = lat;
    document.getElementById('modalLng').value = lng;
    document.getElementById('modalAddress').textContent = place.address_name || `위도: ${lat.toFixed(6)}, 경도: ${lng.toFixed(6)}`;
    
    // 장소 이름, 카테고리 등 폼 데이터 설정
    document.getElementById('modalMapName').value = place.place_name || '';
    document.getElementById('modalCategory').value = convertCategoryForSave(place.category_name); // 카테고리 자동 변환
    document.getElementById('modalContent').value = ''; // 메모는 비워둠

    // 모달 표시
    document.getElementById('mapModal').classList.add('show');
    
    // 임시 마커가 있다면 제거
    if (tempMarker) {
        tempMarker.setMap(null);
        tempMarker = null;
    }
}

// 모달 닫기
function closeMapModal() {
    document.getElementById('mapModal').classList.remove('show');
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
    var saveBtn = document.querySelector('#mapModal .modal-btn-save');
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
        const response = await fetch('/api/map', { method: 'POST', headers: {'Content-Type': 'application/json'}, body: JSON.stringify(formData) });
        const result = await response.json();
        if (result.success) {
            alert('장소가 성공적으로 저장되었습니다!');
            closeMapModal();
            location.reload();
        } else {
            alert(`저장 실패: ${result.message || '알 수 없는 오류'}`);
            saveBtn.disabled = false;
            saveBtn.textContent = '저장';
        }
    } catch (error) {
        alert('저장 중 오류가 발생했습니다.');
        saveBtn.disabled = false;
        saveBtn.textContent = '저장';
    }
}

// 장소 삭제
async function deleteLocation(mapId) {
    if (!confirm('이 장소를 삭제하시겠습니까?')) return;
    try {
        const response = await fetch(`/api/map/${mapId}`, { method: 'DELETE' });
        const result = await response.json();
        if (result.success) {
            alert('장소가 삭제되었습니다.');
            location.reload();
        } else {
            alert(`삭제 실패: ${result.message || '알 수 없는 오류'}`);
        }
    } catch (error) {
        alert('삭제 중 오류가 발생했습니다.');
    }
}

// 마커에 포커스
function focusMarker(lat, lng) {
    // 먼저 모든 인포윈도우 닫기
    markers.forEach(item => {
        if (item.infowindow) item.infowindow.close();
    });
    searchMarkers.forEach(item => {
        if (item.infowindow) item.infowindow.close();
    });
    if (homeInfowindow) homeInfowindow.close();
    courseMarkers.forEach(item => {
        if (item.infowindow) item.infowindow.close();
    });

    var position = new kakao.maps.LatLng(lat, lng);
    map.setCenter(position);
    map.setLevel(3);
    // 해당 위치의 마커만 인포윈도우 열기
    markers.forEach(item => {
        var markerPos = item.marker.getPosition();
        if (Math.abs(markerPos.getLat() - lat) < 0.0001 && Math.abs(markerPos.getLng() - lng) < 0.0001) {
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
        markers.forEach(item => item.infowindow && item.infowindow.close());
        searchMarkers.forEach(item => item.infowindow && item.infowindow.close());
        homeInfowindow.open(map, homeMarker);
    }
}

// 장소 상세 정보 표시 (목록 클릭 시 지도 이동)
function showLocationDetail(mapId) {
    // 다른 모든 인포윈도우 닫기
    markers.forEach(item => {
        if (item.infowindow) item.infowindow.close();
    });
    searchMarkers.forEach(item => {
        if (item.infowindow) item.infowindow.close();
    });
    if (homeInfowindow) homeInfowindow.close();
    // 산책코스 마커의 인포윈도우도 닫기
    courseMarkers.forEach(item => {
        if (item.infowindow) item.infowindow.close();
    });

    const item = markers.find(m => m.mapId === mapId);
    if (item) {
        const position = item.marker.getPosition();
        focusMarker(position.getLat(), position.getLng());
    }
}

// 수정 모달 열기
async function openEditModal(mapId) {
    currentLocationId = mapId;
    try {
        const response = await fetch(`/api/map/${mapId}`);
        const result = await response.json();
        if (result.success && result.data) {
            var location = result.data;
            document.querySelector('#mapModal .map-modal-title span').textContent = '장소 수정';
            document.getElementById('modalLat').value = location.mapLatitude;
            document.getElementById('modalLng').value = location.mapLongitude;
            document.getElementById('modalMapName').value = location.mapName;
            document.getElementById('modalCategory').value = location.mapCategory;
            document.getElementById('modalContent').value = location.mapContent;
            document.getElementById('modalAddress').textContent = location.mapAddress || '주소 정보 없음';
            document.getElementById('mapModal').classList.add('show');
        } else {
            alert('장소 정보를 불러오는 중 오류가 발생했습니다.');
        }
    } catch (error) {
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
    if (!confirm('이 장소를 삭제하시겠습니까?\n삭제된 장소는 복구할 수 없습니다.')) return;
    try {
        const response = await fetch(`/api/map/${currentLocationId}`, { method: 'DELETE' });
        const result = await response.json();
        if (result.success) {
            alert('장소가 삭제되었습니다.');
            closeLocationDetailModal();
            location.reload();
        } else {
            alert(`삭제 실패: ${result.message || '알 수 없는 오류'}`);
        }
    } catch (error) {
        alert('삭제 중 오류가 발생했습니다.');
    }
}

// 탭 전환 함수
function switchMapTab(element, tabType) {
    document.querySelectorAll('.map-tab').forEach(tab => tab.classList.remove('active'));
    element.classList.add('active');
    currentMapMode = tabType;
    if (tabType === 'mymap') {
        enableMyMapMode();
    } else if (tabType === 'course') {
        enableCourseMode();
    }
}

// 내 지도 모드 활성화
function enableMyMapMode() {
    clearCourseMode();
    var courseListContainer = document.getElementById('courseListContainer');
    if (courseListContainer) courseListContainer.style.display = 'none';
    var hiddenItems = document.querySelectorAll('.hidden-in-course-mode');
    hiddenItems.forEach(item => {
        item.style.display = 'flex';
        item.classList.remove('hidden-in-course-mode');
    });
    var locationItemsContainer = document.querySelector('#mapLocationList .map-location-items');
    if (locationItemsContainer) {
        var divider = locationItemsContainer.querySelector('.home-location-divider');
        if (divider) divider.style.display = 'block';
    }
    document.querySelector('.map-search-container').style.display = 'block';
    map.setCursor('default');
}

// 산책코스 모드 활성화
function enableCourseMode() {
    clearCourseMode();
    document.querySelector('.map-search-container').style.display = 'none';
    map.setCursor('default'); // 커서 기본으로 변경
    hideLocationItemsInCourseMode();
    var courseListContainer = document.getElementById('courseListContainer');
    if (courseListContainer) courseListContainer.style.display = 'block';
    loadCourseList();
}

// 산책코스 모드에서 장소 목록 숨기기
function hideLocationItemsInCourseMode() {
    var locationItems = document.querySelectorAll('#mapLocationList .map-location-item:not(.home-location)');
    locationItems.forEach(item => {
        item.style.display = 'none';
        item.classList.add('hidden-in-course-mode');
    });
    var locationItemsContainer = document.querySelector('#mapLocationList .map-location-items');
    if (locationItemsContainer) {
        var divider = locationItemsContainer.querySelector('.home-location-divider');
        if (divider) divider.style.display = 'none';
    }
}

// 산책코스 모드 초기화
function clearCourseMode() {
    courseMarkers.forEach(item => item.marker && item.marker.setMap(null));
    courseMarkers = [];
    if (coursePolyline) {
        coursePolyline.setMap(null);
        coursePolyline = null;
    }
}

// 산책코스 목록 로드
async function loadCourseList() {
    var recId = defaultRecId || (document.getElementById('modalRecId') && parseInt(document.getElementById('modalRecId').value));
    if (!recId) return;
    try {
        const response = await fetch(`/api/course/recipient/${recId}`);
        const result = await response.json();
        displayCourseList(result.success && result.data ? result.data : []);
    } catch (error) {
        displayCourseList([]);
    }
}

// 코스 이름 줄 바꿈
function formatCourseName(name) {
    if (!name) return '';
    const parts = name.split(' ');
    return parts.length > 2 ? `${parts.slice(0, 2).join(' ')}<br>${parts.slice(2).join(' ')}` : name;
}

// 산책코스 목록 표시
function displayCourseList(courses) {
    var locationItems = document.querySelector('#mapLocationList .map-location-items');
    if (!locationItems) return;
    var existingCourseSection = document.getElementById('courseListContainer');
    if (existingCourseSection) existingCourseSection.remove();
    var courseListContainer = document.createElement('div');
    courseListContainer.id = 'courseListContainer';
    courseListContainer.className = 'course-list-container';
    if (courses.length === 0) {
        courseListContainer.innerHTML = '<div style="text-align: center; padding: 15px; color: #999; font-size: 13px;">저장된 산책코스가 없습니다.</div>';
        locationItems.appendChild(courseListContainer);
        return;
    }
    var html = '';
    courses.forEach(course => {
        var pathData = null;
        try {
            pathData = JSON.parse(course.coursePathData || '{}');
        } catch (e) {}
        var distanceText = '';
        if (pathData && pathData.totalDistance) {
            distanceText = pathData.totalDistance < 1000 ? `${Math.round(pathData.totalDistance)}m` : `${(pathData.totalDistance / 1000).toFixed(2)}km`;
        }
        html += `<div class="map-location-item course-item" data-course-id="${course.courseId}" onclick="showCourseDetail(${course.courseId})"><div class="location-info"><div class="location-name-wrapper"><div class="location-name">${formatCourseName(course.courseName)}</div><div class="location-category course-category">${course.courseType}</div></div></div>${distanceText ? `<div class="location-address course-distance">${distanceText}</div>` : ''}<button class="location-delete-btn" onclick="event.stopPropagation(); deleteCourse(${course.courseId})"><i class="bi bi-x-circle"></i></button></div>`;
    });
    courseListContainer.innerHTML = html;
    locationItems.appendChild(courseListContainer);
}

// 저장된 산책코스를 지도에 표시
function loadCourseOnMap(courseId) {
    clearCourseMode();
    fetch(`/api/course/${courseId}`)
        .then(response => response.json())
        .then(result => {
            if (result.success && result.data) {
                var course = result.data;
                var pathData = JSON.parse(course.coursePathData || '{}');
                if (pathData.path && Array.isArray(pathData.path)) {
                    var linePath = pathData.path.map(p => new kakao.maps.LatLng(p.lat, p.lng));
                    coursePolyline = new kakao.maps.Polyline({ path: linePath, strokeWeight: 6, strokeColor: '#3498db', strokeOpacity: 0.8, strokeStyle: 'solid', map: map });
                    if (pathData.markers) {
                        pathData.markers.forEach(m => addSpecialMarker(new kakao.maps.LatLng(m.lat, m.lng), m.type, m.title));
                    }
                    var bounds = new kakao.maps.LatLngBounds();
                    linePath.forEach(p => bounds.extend(p));
                    map.setBounds(bounds);
                }
            }
        });
}

// 출발/도착 마커 추가
function addSpecialMarker(position, type, title) {
    var imageSrc, imageSize, imageOption;
    if (type === 'START') {
        imageSrc = 'https://t1.daumcdn.net/localimg/localimages/07/mapapidoc/red_b.png';
        imageSize = new kakao.maps.Size(50, 45);
        imageOption = {offset: new kakao.maps.Point(15, 43)};
    } else {
        imageSrc = 'https://t1.daumcdn.net/localimg/localimages/07/mapapidoc/blue_b.png';
        imageSize = new kakao.maps.Size(50, 45);
        imageOption = {offset: new kakao.maps.Point(15, 43)};
    }
    var markerImage = new kakao.maps.MarkerImage(imageSrc, imageSize, imageOption);
    var marker = new kakao.maps.Marker({ position: position, map: map, image: markerImage, title: title, zIndex: 100 });
    // 상태창(인포윈도우)을 표시하지 않도록 주석 처리
    // var infowindow = new kakao.maps.InfoWindow({ content: `<div style="padding:5px;font-size:12px;text-align:center;min-width:80px;"><strong>${title}</strong></div>`, removable: false });
    // infowindow.open(map, marker);
    // 마커 클릭 이벤트 리스너를 추가하지 않음 (상태창이 뜨지 않도록)
    courseMarkers.push({ marker: marker, infowindow: null, position: position });
}

// 산책코스 삭제
async function deleteCourse(courseId) {
    if (!confirm('이 산책코스를 삭제하시겠습니까?')) return;
    try {
        const response = await fetch(`/api/course/${courseId}`, { method: 'DELETE' });
        const result = await response.json();
        if (result.success) {
            alert('산책코스가 삭제되었습니다.');
            loadCourseList();
        } else {
            alert(`삭제 실패: ${result.message || '알 수 없는 오류'}`);
        }
    } catch (error) {
        alert('삭제 중 오류가 발생했습니다.');
    }
}

// 산책코스 상세 정보 표시
async function showCourseDetail(courseId) {
    loadCourseOnMap(courseId);
}

// 위치 검색 함수
function searchLocation() {
    var keyword = document.getElementById('mapSearchInput').value.trim();
    if (!keyword) {
        alert('검색어를 입력해주세요.');
        return;
    }
    var ps = new kakao.maps.services.Places();
    var center = map.getCenter();
    ps.keywordSearch(keyword, function(data, status) {
        if (status === kakao.maps.services.Status.OK) {
            const filterKeywords = ['주차장', '전기차', '충전소', '후문', '정문', '별관', '부설'];
            const filteredPlaces = data.filter(place => !filterKeywords.some(fk => place.place_name.includes(fk))).sort((a, b) => a.place_name === keyword ? -1 : b.place_name === keyword ? 1 : 0);
            const finalPlaces = filteredPlaces.length > 0 ? filteredPlaces : data;
            displaySearchResults(finalPlaces);
        } else if (status === kakao.maps.services.Status.ZERO_RESULT) {
            displayNoResults();
        } else {
            alert('검색 중 오류가 발생했습니다.');
        }
    }, { location: center, radius: 5000, size: 15 });
}

// 검색 결과 표시
function displaySearchResults(places) {
    var resultsContainer = document.getElementById('searchResults');
    resultsContainer.innerHTML = '';
    searchMarkers.forEach(item => {
        item.marker && item.marker.setMap(null);
        item.infowindow && item.infowindow.close();
    });
    searchMarkers = [];

    // 빨간색 마커 이미지 생성
    var imageSrc = 'https://t1.daumcdn.net/localimg/localimages/07/mapapidoc/marker_red.png',
        imageSize = new kakao.maps.Size(31, 35),
        imageOption = {offset: new kakao.maps.Point(15, 34)};
    var markerImage = new kakao.maps.MarkerImage(imageSrc, imageSize, imageOption);

    places.forEach(place => {
        var item = document.createElement('div');
        item.className = 'search-result-item';
        item.onclick = () => selectSearchResult(place);
        var icon = getCategoryIcon(place.category_name);
        item.innerHTML = `<div class="search-result-icon"><i class="${icon}"></i></div><div class="search-result-info"><div class="search-result-name">${place.place_name}</div><div class="search-result-address">${place.address_name}</div><span class="search-result-category">${getCategoryText(place.category_name)}</span></div>`;
        resultsContainer.appendChild(item);
        var markerPosition = new kakao.maps.LatLng(place.y, place.x);
        
        // 생성된 빨간색 마커 이미지로 마커 생성
        var marker = new kakao.maps.Marker({ 
            position: markerPosition, 
            map: map,
            image: markerImage 
        });
        
        // 인포윈도우 컨텐츠 수정
        const placeCategory = getCategoryText(place.category_name);
        const infowindowContent = `
            <div style="padding:12px;font-size:13px;min-width:180px;text-align:center;">
                <div style="font-weight:700;color:#333;margin-bottom:5px;">${place.place_name}</div>
                <div style="display:inline-block;padding:3px 10px;background:#e8eaf6;color:#667eea;border-radius:12px;font-size:11px;margin-bottom:8px;">
                    ${placeCategory}
                </div>
                <button onclick='openAddPlaceModalFromSearch(${JSON.stringify(place)})' 
                        style="display:block;margin-top:10px;background:#667eea;color:white;border:none;padding:6px 12px;border-radius:5px;cursor:pointer;width:100%;font-size:12px;transition:background 0.2s;">
                    장소 추가
                </button>
            </div>`;

        var infowindow = new kakao.maps.InfoWindow({
            content: infowindowContent
        });
        
        kakao.maps.event.addListener(marker, 'click', () => {
            // 다른 모든 인포윈도우 닫기
            searchMarkers.forEach(item => item.infowindow && item.infowindow.close());
            markers.forEach(item => item.infowindow && item.infowindow.close());
            if (homeInfowindow) homeInfowindow.close();

            // 현재 마커의 인포윈도우 열기
            infowindow.open(map, marker);
        });
        
        searchMarkers.push({ marker: marker, infowindow: infowindow, place: place });
    });
    
    resultsContainer.classList.add('show');
    if (places.length > 0) {
        map.setCenter(new kakao.maps.LatLng(places[0].y, places[0].x));
        map.setLevel(4);
    }
}

// 검색 결과 없음 표시
function displayNoResults() {
    alert('검색 결과가 없습니다.\n다른 검색어로 시도해보세요.');
    document.getElementById('mapSearchInput').focus();
}

// 검색 결과 선택
function selectSearchResult(place) {
    var position = new kakao.maps.LatLng(place.y, place.x);
    map.setCenter(position);
    map.setLevel(3);
    document.getElementById('searchResults').classList.remove('show');
    searchMarkers.forEach(item => {
        var markerPos = item.marker.getPosition();
        if (Math.abs(markerPos.getLat() - place.y) < 0.0001 && Math.abs(markerPos.getLng() - place.x) < 0.0001) {
            searchMarkers.forEach(otherItem => otherItem.infowindow && otherItem.infowindow.close());
            item.infowindow.open(map, item.marker);
        }
    });
}

// 검색 결과 상세 모달 표시
var currentSearchPlace = null;
function showSearchResultDetailModal(place) {
    currentSearchPlace = place;
    document.getElementById('searchResultName').textContent = place.place_name || '-';
    document.getElementById('searchResultCategory').textContent = getCategoryText(place.category_name) || '-';
    document.getElementById('searchResultAddress').textContent = place.address_name || '-';
    document.getElementById('searchResultMemo').value = '';
    document.getElementById('searchResultHomeAddress').textContent = (recipientAddress && recipientAddress !== '' && recipientAddress !== 'null') ? recipientAddress : '집 주소 정보가 없습니다.';
    var distanceText = '거리 계산 중...';
    if (homeMarker && homeMarker.getPosition()) {
        var distance = calculateDistance(homeMarker.getPosition().getLat(), homeMarker.getPosition().getLng(), parseFloat(place.y), parseFloat(place.x));
        distanceText = distance < 1000 ? `${Math.round(distance)}m` : `${(distance / 1000).toFixed(2)}km`;
    } else {
        distanceText = '집 위치 정보가 없습니다.';
    }
    document.getElementById('searchResultDistance').textContent = distanceText;
    document.getElementById('searchResultDetailModal').classList.add('show');
}

// 검색 결과 상세 모달 닫기
function closeSearchResultDetailModal() {
    document.getElementById('searchResultDetailModal').classList.remove('show');
    currentSearchPlace = null;
    document.getElementById('searchResultMemo').value = '';
}

// 검색 결과 카테고리 변환
function convertCategoryForSave(categoryName) {
    if (!categoryName) return '기타';
    var categoryLower = categoryName.toLowerCase();
    if (categoryLower.includes('병원') || categoryLower.includes('의원') || categoryLower.includes('의료') || categoryLower.includes('치과') || categoryLower.includes('한의원') || categoryLower.includes('보건소')) return '병원';
    if (categoryLower.includes('약국') || categoryLower.includes('한약방')) return '약국';
    if (categoryLower.includes('공원') || categoryLower.includes('체육공원') || categoryLower.includes('근린공원') || categoryLower.includes('도시공원')) return '공원';
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
        const response = await fetch('/api/map', { method: 'POST', headers: {'Content-Type': 'application/json'}, body: JSON.stringify(formData) });
        const result = await response.json();
        if (result.success) {
            alert('장소가 성공적으로 저장되었습니다!');
            closeSearchResultDetailModal();
            location.reload();
        } else {
            alert(`저장 실패: ${result.message || '알 수 없는 오류'}`);
            saveBtn.disabled = false;
            saveBtn.textContent = '저장';
        }
    } catch (error) {
        alert('저장 중 오류가 발생했습니다.');
        saveBtn.disabled = false;
        saveBtn.textContent = '저장';
    }
}

// 카테고리 아이콘 반환
function getCategoryIcon(categoryName) {
    if (!categoryName) return 'bi bi-geo-alt-fill';
    if (categoryName.includes('병원') || categoryName.includes('의료')) return 'bi bi-hospital';
    if (categoryName.includes('약국')) return 'bi bi-capsule';
    if (categoryName.includes('음식') || categoryName.includes('카페')) return 'bi bi-cup-hot';
    if (categoryName.includes('마트') || categoryName.includes('편의점')) return 'bi bi-cart';
    if (categoryName.includes('공원')) return 'bi bi-tree';
    if (categoryName.includes('은행')) return 'bi bi-bank';
    return 'bi bi-geo-alt-fill';
}

// 카테고리 텍스트 정리
function getCategoryText(categoryName) {
    if (!categoryName) return '기타';
    var parts = categoryName.split('>');
    return parts[parts.length - 1].trim() || '기타';
}

// 외부 클릭 시 드롭다운 닫기
document.addEventListener('click', function(e) {
    var searchContainer = document.querySelector('.map-search-container');
    var searchResults = document.getElementById('searchResults');
    if (searchContainer && !searchContainer.contains(e.target)) {
        searchResults.classList.remove('show');
    }
});

// ESC 키로 모달 닫기
document.addEventListener('keydown', function(e) {
    if (e.key === 'Escape') {
        if (document.getElementById('mapModal')?.classList.contains('show')) closeMapModal();
        if (document.getElementById('locationDetailModal')?.classList.contains('show')) closeLocationDetailModal();
        if (document.getElementById('searchResultDetailModal')?.classList.contains('show')) closeSearchResultDetailModal();
    }
});

// IoT 서비스에 집 위치 설정
async function setHomeLocationToIot(latitude, longitude) {
    if (!defaultRecId) return;
    try {
        const response = await fetch(`/api/iot/location/${defaultRecId}/home`, { method: 'POST', headers: {'Content-Type': 'application/json'}, body: JSON.stringify({ latitude, longitude }) });
        const result = await response.json();
        if (result.success) console.log('✅ IoT 서비스에 집 위치 설정 완료');
        else console.warn('⚠️ IoT 서비스 집 위치 설정 실패:', result.message);
    } catch (error) {
        console.error('❌ IoT 서비스 집 위치 설정 오류:', error);
    }
}

// IoT 서비스에서 노약자 위치 가져오기
async function getRecipientLocationFromIot() {
    if (!defaultRecId) return null;
    try {
        const response = await fetch(`/api/iot/location/${defaultRecId}`);
        const result = await response.json();
        return result.success && result.data ? { latitude: result.data.latitude, longitude: result.data.longitude } : null;
    } catch (error) {
        console.error('❌ IoT 서비스 위치 조회 오류:', error);
        return null;
    }
}

// 실시간 노약자 위치 추적
function updateRecipientMarker(lat, lng) {
    if (!map || typeof kakao === 'undefined') return;
    var moveLatLon = new kakao.maps.LatLng(lat, lng);
    if (!recipientLocationMarker) {
        if (typeof recipientPhotoUrl !== 'undefined' && recipientPhotoUrl && recipientPhotoUrl !== 'null') {
            createCircularMarkerImageForRealtime(recipientPhotoUrl, dataUrl => {
                var markerImage = dataUrl ? new kakao.maps.MarkerImage(dataUrl, new kakao.maps.Size(60, 70), {offset: new kakao.maps.Point(30, 70)}) : getDefaultRecipientMarkerImage();
                createRecipientMarkerOnMap(moveLatLon, markerImage);
            });
            return;
        } else {
            var markerImage = getDefaultRecipientMarkerImage();
            createRecipientMarkerOnMap(moveLatLon, markerImage);
        }
    } else {
        recipientLocationMarker.setPosition(moveLatLon);
    }
}

// 기본 마커 이미지 반환
function getDefaultRecipientMarkerImage() {
    return new kakao.maps.MarkerImage(
        'data:image/svg+xml;base64,' + btoa('<svg xmlns="http://www.w3.org/2000/svg" width="50" height="60" viewBox="0 0 50 60"><circle cx="25" cy="25" r="20" fill="#667eea" stroke="#fff" stroke-width="3"/><circle cx="25" cy="20" r="7" fill="#fff"/><path d="M10 45 Q25 35 40 45" fill="#fff"/><path d="M25 45 L20 55 L30 55 Z" fill="#667eea" stroke="#fff" stroke-width="2"/></svg>'),
        new kakao.maps.Size(50, 60),
        {offset: new kakao.maps.Point(25, 60)}
    );
}

// 실시간 위치용 원형 프로필 이미지 생성
function createCircularMarkerImageForRealtime(photoUrl, callback) {
    var canvas = document.createElement('canvas');
    canvas.width = 60;
    canvas.height = 70;
    var ctx = canvas.getContext('2d');
    var img = new Image();
    img.crossOrigin = 'anonymous';
    img.onload = function() {
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
        ctx.save();
        ctx.beginPath();
        ctx.arc(30, 30, 25, 0, 2 * Math.PI);
        ctx.clip();
        ctx.fillStyle = '#667eea';
        ctx.fillRect(5, 5, 50, 50);
        ctx.drawImage(img, 5, 5, 50, 50);
        ctx.restore();
        ctx.strokeStyle = '#fff';
        ctx.lineWidth = 3;
        ctx.beginPath();
        ctx.arc(30, 30, 25, 0, 2 * Math.PI);
        ctx.stroke();
        ctx.shadowColor = 'rgba(0, 0, 0, 0.3)';
        ctx.shadowBlur = 5;
        ctx.shadowOffsetX = 0;
        ctx.shadowOffsetY = 2;
        ctx.beginPath();
        ctx.arc(30, 30, 27, 0, 2 * Math.PI);
        ctx.stroke();
        callback(canvas.toDataURL('image/png'));
    };
    img.onerror = () => callback(null);
    img.src = photoUrl;
}

// 지도에 마커 생성
function createRecipientMarkerOnMap(position, markerImage) {
    var recipientNameDisplay = (typeof recipientName !== 'undefined' && recipientName) ? recipientName : '노약자';
    recipientLocationMarker = new kakao.maps.Marker({ position: position, map: map, image: markerImage, zIndex: 999, title: `${recipientNameDisplay}님의 현재 위치` });
    var infowindow = new kakao.maps.InfoWindow({ content: `<div style="padding:10px; text-align:center; min-width:150px;"><div style="font-weight:700; color:#667eea; margin-bottom:5px;"><i class="bi bi-person-walking"></i> ${recipientNameDisplay}님</div><div style="font-size:11px; color:#666;">실시간 위치</div></div>`, removable: false });
    kakao.maps.event.addListener(recipientLocationMarker, 'click', () => {
        markers.forEach(item => item.infowindow && item.infowindow.close());
        searchMarkers.forEach(item => item.infowindow && item.infowindow.close());
        if (homeInfowindow) homeInfowindow.close();
        infowindow.open(map, recipientLocationMarker);
    });
}
