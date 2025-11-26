<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<style>
    #admin-map {
        width: 100%;
        height: 700px;
        border-radius: 8px;
        border: 1px solid #e0e0e0;
    }
    .map-container {
        background: white;
        border-radius: 8px;
        padding: 20px;
        box-shadow: 0 2px 4px rgba(0,0,0,0.1);
    }
    .map-header {
        margin-bottom: 20px;
    }
</style>

<div class="container-fluid p-4 p-lg-5">
    <div class="map-header">
        <h1 class="h3 mb-2">지도</h1>
        <p class="text-muted mb-0">위치 정보를 확인할 수 있습니다.</p>
    </div>

    <div class="map-container">
        <div id="admin-map"></div>
    </div>
</div>

<script>
    // 전역 지도 객체 (다른 페이지에서도 사용 가능)
    window.adminMap = null;
    window.adminMapMarkers = [];
    window.adminMapGeocoder = null;
    
    // 내부 변수 (하위 호환성)
    let map = null;
    let markers = [];
    let geocoder = null;
    let seniorMarkers = []; // 노약자 마커 배열

    function initMap() {
        const mapContainer = document.getElementById('admin-map');
        
        if (!mapContainer) {
            console.error('지도 컨테이너를 찾을 수 없습니다.');
            return;
        }

        // 카카오맵 API가 완전히 로드되었는지 확인
        if (typeof kakao === 'undefined' || !kakao.maps || typeof kakao.maps.LatLng !== 'function') {
            console.error('카카오맵 API가 아직 준비되지 않았습니다.');
            console.log('kakao:', typeof kakao);
            console.log('kakao.maps:', typeof kakao !== 'undefined' ? kakao.maps : 'undefined');
            console.log('kakao.maps.LatLng:', typeof kakao !== 'undefined' && kakao.maps ? typeof kakao.maps.LatLng : 'undefined');
            return;
        }

        console.log('지도 초기화 시작...');
        
        // 한반도 전체가 보이도록 중심점과 레벨 설정
        const mapOption = {
            center: new kakao.maps.LatLng(36.5, 127.5), // 한반도 중앙 좌표
            level: 4 // 한반도 전체와 주변 국가까지 보이는 넓은 범위 (레벨이 낮을수록 넓게 보임)
        };

        try {
            map = new kakao.maps.Map(mapContainer, mapOption);
            geocoder = new kakao.maps.services.Geocoder();
            
            // 전역 객체에 할당
            window.adminMap = map;
            window.adminMapGeocoder = geocoder;
            window.adminMapMarkers = markers;
            
            console.log('지도 초기화 완료 - 전역 객체에 할당됨');
        } catch (error) {
            console.error('지도 초기화 오류:', error);
            alert('지도를 불러오는데 실패했습니다: ' + error.message);
            return;
        }

        // 지도 타입 컨트롤 추가
        const mapTypeControl = new kakao.maps.MapTypeControl();
        map.addControl(mapTypeControl, kakao.maps.ControlPosition.TOPRIGHT);

        // 줌 컨트롤 추가
        const zoomControl = new kakao.maps.ZoomControl();
        map.addControl(zoomControl, kakao.maps.ControlPosition.RIGHT);

        // 노약자 마커 로드
        loadSeniorMarkers();
    }

    function addMarker(lat, lng, title) {
        // map이 없으면 전역 객체 사용
        const currentMap = map || window.adminMap;
        if (!currentMap) {
            console.error('지도가 초기화되지 않았습니다.');
            return;
        }
        
        // 기존 마커 제거
        markers.forEach(marker => marker.setMap(null));
        markers = [];
        window.adminMapMarkers = [];

        const markerPosition = new kakao.maps.LatLng(lat, lng);
        const marker = new kakao.maps.Marker({
            position: markerPosition,
            map: currentMap
        });

        markers.push(marker);
        window.adminMapMarkers.push(marker);

        // 인포윈도우 생성
        const infowindow = new kakao.maps.InfoWindow({
            content: '<div style="padding:5px;font-size:12px;">' + title + '</div>'
        });

        // 마커 클릭 이벤트
        kakao.maps.event.addListener(marker, 'click', function() {
            infowindow.open(currentMap, marker);
        });

        // 지도 중심 이동
        currentMap.setCenter(markerPosition);
    }

    function searchLocation(keyword) {
        const currentGeocoder = geocoder || window.adminMapGeocoder;
        if (!currentGeocoder) {
            alert('지도가 아직 로드되지 않았습니다.');
            return;
        }

        currentGeocoder.addressSearch(keyword, function(result, status) {
            if (status === kakao.maps.services.Status.OK) {
                const coords = new kakao.maps.LatLng(result[0].y, result[0].x);
                addMarker(coords.getLat(), coords.getLng(), keyword);
            } else {
                alert('검색 결과가 없습니다.');
            }
        });
    }

    function resetMap() {
        const currentMap = map || window.adminMap;
        if (currentMap) {
            currentMap.setCenter(new kakao.maps.LatLng(36.5, 127.5)); // 한반도 중앙
            currentMap.setLevel(4); // 한반도 전체 보기
            markers.forEach(marker => marker.setMap(null));
            window.adminMapMarkers.forEach(marker => marker.setMap(null));
            seniorMarkers.forEach(item => {
                if (item.marker) item.marker.setMap(null);
                if (item.infowindow) item.infowindow.close();
            });
            markers = [];
            window.adminMapMarkers = [];
            seniorMarkers = [];
            // 노약자 마커 다시 로드
            loadSeniorMarkers();
        }
    }
    
    // 전역 함수로 노출 (다른 페이지에서 사용 가능)
    window.initAdminMap = initMap;
    window.addAdminMapMarker = addMarker;
    window.searchAdminMapLocation = searchLocation;
    window.resetAdminMap = resetMap;

    // 카카오맵 API 동적 로드 및 초기화
    function loadKakaoMap() {
        console.log('카카오맵 로드 함수 실행');
        
        // 이미 로드되어 있으면 바로 초기화
        if (typeof kakao !== 'undefined' && kakao.maps) {
            console.log('카카오맵 API 이미 로드됨');
            initMap();
            return;
        }

        // 이미 스크립트가 추가되었는지 확인
        const existingScript = document.querySelector('script[src*="dapi.kakao.com"]');
        if (existingScript) {
            console.log('카카오맵 스크립트 이미 존재, 로드 대기 중...');
            // 스크립트가 있지만 아직 로드되지 않은 경우 대기
            const checkInterval = setInterval(function() {
                if (typeof kakao !== 'undefined' && kakao.maps && typeof kakao.maps.LatLng === 'function') {
                    clearInterval(checkInterval);
                    initMap();
                }
            }, 100);
            
            // 10초 후 타임아웃
            setTimeout(function() {
                clearInterval(checkInterval);
                if (typeof kakao === 'undefined' || !kakao.maps || typeof kakao.maps.LatLng !== 'function') {
                    console.error('카카오맵 API 로드 타임아웃');
                    alert('지도를 불러오는데 시간이 오래 걸립니다. 페이지를 새로고침해주세요.');
                }
            }, 10000);
            return;
        }

        console.log('카카오맵 API 스크립트 동적 로드 시작');
        
        // 카카오맵 API 스크립트 동적 로드 (autoload=false 사용)
        const script = document.createElement('script');
        script.type = 'text/javascript';
        script.src = '//dapi.kakao.com/v2/maps/sdk.js?appkey=${kakaoMapKey}&libraries=services&autoload=false';
        script.async = true;
        
        script.onload = function() {
            console.log('카카오맵 API 스크립트 로드 완료');
            // autoload=false를 사용했으므로 kakao.maps.load()로 명시적으로 로드
            if (typeof kakao !== 'undefined' && kakao.maps && kakao.maps.load) {
                kakao.maps.load(function() {
                    console.log('카카오맵 API 완전히 로드됨');
                    // LatLng 생성자가 준비되었는지 확인
                    if (typeof kakao.maps.LatLng === 'function') {
                        initMap();
                    } else {
                        console.error('카카오맵 API 초기화 실패 - LatLng 생성자 없음');
                        alert('지도를 불러오는데 실패했습니다.');
                    }
                });
            } else {
                // autoload=false를 사용하지 않는 경우 대비
                setTimeout(function() {
                    if (typeof kakao !== 'undefined' && kakao.maps && typeof kakao.maps.LatLng === 'function') {
                        initMap();
                    } else {
                        // LatLng가 아직 준비되지 않았으면 재시도
                        const retryInterval = setInterval(function() {
                            if (typeof kakao !== 'undefined' && kakao.maps && typeof kakao.maps.LatLng === 'function') {
                                clearInterval(retryInterval);
                                initMap();
                            }
                        }, 50);
                        
                        // 5초 후 타임아웃
                        setTimeout(function() {
                            clearInterval(retryInterval);
                            if (typeof kakao.maps.LatLng !== 'function') {
                                console.error('카카오맵 API 초기화 실패 - LatLng 생성자 없음');
                                alert('지도를 불러오는데 실패했습니다.');
                            }
                        }, 5000);
                    }
                }, 500);
            }
        };
        
        script.onerror = function() {
            console.error('카카오맵 API 스크립트 로드 실패');
            alert('지도를 불러오는데 실패했습니다. 네트워크 연결을 확인해주세요.');
        };
        
        document.head.appendChild(script);
    }

    // 페이지 로드 시 지도 초기화
    function startMapLoad() {
        // 지도 컨테이너가 존재하는지 확인
        const mapContainer = document.getElementById('admin-map');
        if (!mapContainer) {
            console.log('지도 컨테이너 아직 없음, 재시도...');
            setTimeout(startMapLoad, 100);
            return;
        }
        
        console.log('지도 컨테이너 확인됨, 카카오맵 로드 시작');
        loadKakaoMap();
    }

    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', startMapLoad);
    } else {
        // DOM이 이미 로드된 경우
        startMapLoad();
    }

    // Canvas를 사용하여 원형 프로필 이미지 마커 생성
    function createCircularMarkerImage(photoUrl, callback) {
        const canvas = document.createElement('canvas');
        canvas.width = 60;
        canvas.height = 70;
        const ctx = canvas.getContext('2d');
        
        const img = new Image();
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
            
            const dataUrl = canvas.toDataURL('image/png');
            callback(dataUrl);
        };
        
        img.onerror = function() {
            console.warn('프로필 이미지 로드 실패:', photoUrl);
            callback(null);
        };
        
        // 이미지 경로 처리
        // /imgs/로 시작하는 경로는 각 서버의 WebMvcConfig에서 처리하므로 그대로 사용
        // 상대 경로를 절대 경로로 변환
        if (photoUrl && !photoUrl.startsWith('http') && !photoUrl.startsWith('data:')) {
            if (photoUrl.startsWith('/imgs/')) {
                // /imgs/로 시작하면 현재 서버의 origin 사용 (각 서버의 WebMvcConfig가 처리)
                photoUrl = window.location.origin + photoUrl;
            } else if (photoUrl.startsWith('/')) {
                photoUrl = window.location.origin + photoUrl;
            } else {
                photoUrl = window.location.origin + '/' + photoUrl;
            }
        }
        
        console.log('이미지 로드 시도:', photoUrl);
        img.src = photoUrl;
    }

    // 기본 노약자 마커 이미지 생성
    function createDefaultSeniorMarkerImage() {
        return new kakao.maps.MarkerImage(
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
    }

    // 노약자 마커 추가
    function addSeniorMarker(senior, position) {
        const currentMap = map || window.adminMap;
        if (!currentMap) {
            console.error('지도가 초기화되지 않았습니다.');
            return;
        }

        const recName = senior.recName || '노약자';
        const recPhotoUrl = senior.recPhotoUrl;
        
        // 사진이 있으면 원형 마커 생성, 없으면 기본 마커 사용
        if (recPhotoUrl && recPhotoUrl !== '' && recPhotoUrl !== 'null') {
            createCircularMarkerImage(recPhotoUrl, function(dataUrl) {
                if (dataUrl) {
                    const markerImage = new kakao.maps.MarkerImage(
                        dataUrl,
                        new kakao.maps.Size(60, 70),
                        {offset: new kakao.maps.Point(30, 70)}
                    );
                    createSeniorMarkerWithImage(markerImage, position, senior);
                } else {
                    // 이미지 로드 실패 시 기본 마커 사용
                    const defaultMarkerImage = createDefaultSeniorMarkerImage();
                    createSeniorMarkerWithImage(defaultMarkerImage, position, senior);
                }
            });
        } else {
            // 기본 마커 이미지 사용
            const defaultMarkerImage = createDefaultSeniorMarkerImage();
            createSeniorMarkerWithImage(defaultMarkerImage, position, senior);
        }
    }

    // 노약자 마커 생성 (이미지가 준비된 후)
    function createSeniorMarkerWithImage(markerImage, position, senior) {
        const currentMap = map || window.adminMap;
        const recName = senior.recName || '노약자';
        const recAddress = senior.recAddress || '주소 정보 없음';
        
        // 노약자 마커 생성
        const marker = new kakao.maps.Marker({
            position: position,
            map: currentMap,
            image: markerImage,
            title: recName + '님',
            zIndex: 1000
        });

        // 인포윈도우 생성
        const infowindow = new kakao.maps.InfoWindow({
            content: '<div style="padding:10px;min-width:150px;">' +
                     '<div style="font-weight:bold;font-size:14px;margin-bottom:5px;">' + recName + '</div>' +
                     '<div style="font-size:12px;color:#666;">' + recAddress + '</div>' +
                     '</div>',
            removable: true
        });

        // 마커 클릭 이벤트
        kakao.maps.event.addListener(marker, 'click', function() {
            // 다른 인포윈도우 닫기
            seniorMarkers.forEach(function(item) {
                if (item.infowindow) {
                    item.infowindow.close();
                }
            });
            infowindow.open(currentMap, marker);
        });

        // 마커 배열에 추가
        seniorMarkers.push({
            marker: marker,
            infowindow: infowindow,
            senior: senior
        });
    }

    // 노약자 목록 로드 및 마커 표시
    function loadSeniorMarkers() {
        fetch('<c:url value="/senior/api/list"/>')
            .then(response => {
                if (!response.ok) {
                    throw new Error('노약자 목록을 불러오는데 실패했습니다.');
                }
                return response.json();
            })
            .then(seniors => {
                console.log('노약자 목록 로드 완료:', seniors);
                
                if (!seniors || seniors.length === 0) {
                    console.log('등록된 노약자가 없습니다.');
                    return;
                }

                const currentGeocoder = geocoder || window.adminMapGeocoder;
                if (!currentGeocoder) {
                    console.error('지오코더가 초기화되지 않았습니다.');
                    return;
                }

                // 모든 노약자의 주소를 좌표로 변환하여 마커 표시
                let processedCount = 0;
                const totalCount = seniors.length;
                let bounds = new kakao.maps.LatLngBounds();

                seniors.forEach(function(senior) {
                    if (!senior.recAddress || senior.recAddress.trim() === '') {
                        processedCount++;
                        if (processedCount === totalCount) {
                            adjustMapBounds(bounds);
                        }
                        return;
                    }

                    // 주소를 좌표로 변환
                    currentGeocoder.addressSearch(senior.recAddress, function(result, status) {
                        processedCount++;
                        
                        if (status === kakao.maps.services.Status.OK) {
                            const coords = new kakao.maps.LatLng(result[0].y, result[0].x);
                            bounds.extend(coords);
                            addSeniorMarker(senior, coords);
                        } else {
                            console.warn('주소 검색 실패:', senior.recName, senior.recAddress);
                        }

                        // 모든 노약자 처리 완료 시 지도 범위 조정
                        if (processedCount === totalCount) {
                            adjustMapBounds(bounds);
                        }
                    });
                });
            })
            .catch(error => {
                console.error('노약자 목록 로드 오류:', error);
            });
    }

    // 지도 범위 조정 (모든 마커가 보이도록)
    function adjustMapBounds(bounds) {
        const currentMap = map || window.adminMap;
        if (!currentMap || seniorMarkers.length === 0) {
            return;
        }

        // 마커가 하나 이상 있으면 범위 조정
        if (seniorMarkers.length > 0) {
            try {
                currentMap.setBounds(bounds);
            } catch (e) {
                console.warn('지도 범위 조정 실패:', e);
                // 실패 시 한반도 전체 보기로
                currentMap.setCenter(new kakao.maps.LatLng(36.5, 127.5));
                currentMap.setLevel(4);
            }
        } else {
            // 마커가 없으면 한반도 전체 보기
            currentMap.setCenter(new kakao.maps.LatLng(36.5, 127.5));
            currentMap.setLevel(4);
        }
    }
</script>

