let map;

async function initMap() {
  // 必要なライブラリをインポート
  const { Map } = await google.maps.importLibrary("maps");

  // マップのオプションを設定
  const defaultLocation = { lat: 35.6809591, lng: 139.7673068 };
  const mapOptions = {
    center: { lat: defaultLocation.lat, lng: defaultLocation.lng },
    zoom: 15,
    streetViewControl: false, // ストリートビューのボタン非表示
    mapTypeControl: false, // 地図、航空写真のボタン非表示
    fullscreenControl: false, // フルスクリーンボタン非表示
  };

  // マップオブジェクトの作成
  map = new Map(document.getElementById("create_map"), mapOptions);
}

initMap();
