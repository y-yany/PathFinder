let map;
let route_points = [];
let directionsService;

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
  map = new Map(document.getElementById("create_map"), mapOptions);

  // マップをクリックした時の動作
  map.addListener('click', (e) => {
    if (!e.placeId) {
      route_points.push(e.latLng);
    }
    calcRoute();
  });
}

initMap();

// ルート計算
function calcRoute() {
  if (route_points.length < 2) {
    return;
  } else {
    // ルートの条件
    const start = route_points[0];
    const end = route_points[route_points.length - 1];
    const waypts = route_points.slice(1, -1).map(point => ({
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
        }
      });
    }
  }
}
window.calcRoute = calcRoute;
