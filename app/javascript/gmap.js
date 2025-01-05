let map;
let routePoints = [];
let directionsService;
let routePolyline;
let totalDistance = 0;

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
    calcRoute();
  });

  // フォームに値を追加
  addValueToForm();
}

initMap();

// !ルート計算
function calcRoute() {
  if (routePoints.length < 2) {
    return;
  } else {
    resetPolyline(routePolyline); // ポリラインのリセット

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

    // 計算
    if (waypts.length > 10) {
      return;
    } else {
      directionsService.route(request, (response, status) => {
        if (status == 'OK') {
          const route = response.routes[0]; // ルート計算の結果からルート情報を取得
          const encodedPolyline = route.overview_polyline; // ルートのポリラインデータを取得
          drawPolyline(encodedPolyline);
          calcTotalDistance(route);
        }
      });
    }
  }
}
window.calcRoute = calcRoute;

// !ポリラインデータをマップ上に描写
function drawPolyline(encodedPolyline) {
  const routeCoordinates = google.maps.geometry.encoding.decodePath(encodedPolyline); // エンコードされたパスをデコード

  // ポリラインオブジェクトの作成
  routePolyline = new google.maps.Polyline({
    path: routeCoordinates,
    geodesic: true, // 地球の曲率を考慮した直線
    strokeColor: "#ff7f50", // ポリラインの色
    strokeOpacity: 0.9, // ポリラインの透過度
    strokeWeight: 7, // ポリラインの太さ
  });

  routePolyline.setMap(map);
}
window.drawPolyline = drawPolyline;

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
  route.legs.forEach((leg) => {
    totalDistance += leg.distance.value / 1_000; // 総距離kmを算出
  });
}
window.calcTotalDistance = calcTotalDistance;

// !フォームに値を追加
function addValueToForm() {
  const form = document.getElementById("course-form");
  form.addEventListener('submit', (e) => {
    // コースの距離
    const distanceField = e.target.querySelector('#course-distance-field');
    distanceField.value = totalDistance;

    // コースの始点の住所
    const addressField = e.target.querySelector('#course-address-field');
    // addressField.value = 
    // console.log(e.target);
  })
}
window.addValueToForm = addValueToForm;
