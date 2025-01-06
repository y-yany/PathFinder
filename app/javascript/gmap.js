let map;
let routePoints = []; // ルートを構成する座標データ
let directionsService;
let routePolyline; // ルートのポリラインオブジェクト

async function initMap() {
  // 必要なライブラリをインポート
  const { Map } = await google.maps.importLibrary("maps");
  const { AdvancedMarkerElement } = await google.maps.importLibrary("marker");
  directionsService = await new google.maps.DirectionsService();

  // マップのオプションを設定
  const defaultLocation = { lat: 35.6809591, lng: 139.7673068 };
  const mapOptions = {
    center: { lat: defaultLocation.lat, lng: defaultLocation.lng },
    zoom: 15,
    streetViewControl: false, // ストリートビューのボタン非表示
    mapTypeControl: false, // 地図、航空写真のボタン非表示
    fullscreenControl: false, // フルスクリーンボタン非表示
    mapId: gon.google_map_id,
  };

  // マップオブジェクトの作成
  map = new Map(document.getElementById("create-map"), mapOptions);

  // マップをクリックした時の動作
  map.addListener('click', (e) => {
    if (!e.placeId) {
      routePoints.push(e.latLng);
    }

    if (routePoints.length >= 2) {
      resetPolyline(routePolyline); // マップに描写されているポリラインを削除

      calcRoute(routePoints) // ルートを計算
        .then(route => {
          const encodedPolyline = getEncodedPolyline(route); // ポリラインデータを取得
          drawPolyline(encodedPolyline); // ポリラインをマップ上に描写
          addValueToForm(route, routePoints); // フォームにデータを追加
        });
    }
  });
}

initMap();

// !ルート計算
function calcRoute(routePoints) {
  // ルートの条件
  const start = routePoints[0];
  const end = routePoints[routePoints.length - 1];
  const waypts = routePoints.slice(1, -1).map(point => ({
    location: point,
    stopover: true,
  }));
  const request = {
    origin: start,
    destination: end,
    waypoints: waypts,
    travelMode: 'WALKING',
  };

  if (waypts.length > 10) {
    return;
  }
  
  // 計算
  return new Promise((resolve) => {
    directionsService.route(request, (response, status) => {
      if (status == 'OK') {
        const route = response.routes[0]; // ルート計算の結果からルート情報を取得
        resolve(route);
      }
    });
  })
}
window.calcRoute = calcRoute;

// !ポリラインデータを取得
function getEncodedPolyline(route) {
  const encodedPolyline = route.overview_polyline; // ルートのポリラインデータを取得
  
  return encodedPolyline;
}
window.getEncodedPolyline = getEncodedPolyline;

// !ポリラインデータをマップ上に描写
function drawPolyline(encodedPolyline) {
  const routeCoordinates = google.maps.geometry.encoding.decodePath(encodedPolyline); // エンコードされたパスをデコード

  routePolyline = getPolylineObject(routeCoordinates); // ポリラインオブジェクトを作成
  routePolyline.setMap(map);
}
window.drawPolyline = drawPolyline;

// !ポリラインオブジェクトの作成
function getPolylineObject(routeCoordinates) {
  const polylineObject = new google.maps.Polyline({
    path: routeCoordinates,
    geodesic: true, // 地球の曲率を考慮した直線
    strokeColor: "#ff7f50", // ポリラインの色
    strokeOpacity: 0.9, // ポリラインの透過度
    strokeWeight: 7, // ポリラインの太さ
  });

  return polylineObject;
}
window.getPolylineObject = getPolylineObject;

// !ポリラインをマップ上から除去
function resetPolyline(routePolyline) {
  if (routePolyline) {
    routePolyline.setMap(null);
    routePolyline = null;
  }
}
window.resetPolyline = resetPolyline;

// !ルートの総距離を計算
function calcTotalDistance(route) {
  let totalDistance = 0;

  route.legs.forEach((leg) => {
    totalDistance += leg.distance.value / 1_000; // 総距離kmを算出
  });

  return totalDistance;
}
window.calcTotalDistance = calcTotalDistance;

// !フォームに値を追加
function addValueToForm(route, routePoints) {
  const form = document.getElementById("course-form");
  if (form) {
    form.addEventListener('submit', (e) => {
      // コースの距離
      const distanceField = e.target.querySelector('#course-distance-field');
      distanceField.value = calcTotalDistance(route);
  
      // コースの始点の住所
      const addressField = e.target.querySelector('#course-address-field');
      addressField.value = route.legs[0].start_address;
      
      // ポリラインデータ
      const encodedPolylineField = e.target.querySelector('#course-encoded-polyline-field');
      encodedPolylineField.value = getEncodedPolyline(route);
  
      // コースを構成する座標データ
      const positionsField = e.target.querySelector('#marker-positions-field');
      positionsField.value = JSON.stringify(routePoints);
    })
  }
}
window.addValueToForm = addValueToForm;
