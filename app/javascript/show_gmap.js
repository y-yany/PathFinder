import { getPolylineObject } from "./gmap_common";

let show_map;
let courseEncodedPolyline = gon.course_encoded_polyline;
let startPosition = gon.start_position;

async function initMap() {
  // 必要なライブラリをインポート
  const { Map } = await google.maps.importLibrary("maps");
  const { encoding } = await google.maps.importLibrary("geometry");

  // マップのオプションを設定
  const mapOptions = {
    center: { lat: startPosition.lat, lng: startPosition.lng },
    zoom: 17,
    streetViewControl: false, // ストリートビューのボタン非表示
    mapTypeControl: false, // 地図、航空写真のボタン非表示
    fullscreenControl: false, // フルスクリーンボタン非表示
    mapId: "c051c893a57825fa",
  };

  // マップオブジェクトの作成
  show_map = new Map(document.getElementById("show-map"), mapOptions);

  // ポリラインオブジェクトを作成し、コースをマップに描写
  const routePolyline = getPolylineObject(courseEncodedPolyline);
  routePolyline.setMap(show_map);
}

initMap();
