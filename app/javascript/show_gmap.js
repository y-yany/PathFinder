let show_map;
let googleMapId = gon.google_map_id;
let courseEncodedPolyline = gon.course_encoded_polyline;
let startPosition = gon.start_position;

async function initMap() {
  // 必要なライブラリをインポート
  const { Map } = await google.maps.importLibrary("maps");
  const {encoding} = await google.maps.importLibrary("geometry");
  const {Polyline} = await google.maps.importLibrary("maps")

  // マップのオプションを設定
  const mapOptions = {
    center: { lat: startPosition.lat, lng: startPosition.lng },
    zoom: 17,
    streetViewControl: false, // ストリートビューのボタン非表示
    mapTypeControl: false, // 地図、航空写真のボタン非表示
    fullscreenControl: false, // フルスクリーンボタン非表示
    mapId: googleMapId,
  };

  // マップオブジェクトの作成
  show_map = new Map(document.getElementById("show-map"), mapOptions);

  // ポリラインオブジェクトを作成し、コースをマップに描写
  const routeCoordinates = new encoding.decodePath(courseEncodedPolyline);

  const routePolyline = new Polyline({
    path: routeCoordinates,
    geodesic: true,
    strokeColor: "#ff7f50",
    strokeOpacity: 0.9,
    strokeWeight: 7,
  });
  routePolyline.setMap(show_map);
}

initMap();
