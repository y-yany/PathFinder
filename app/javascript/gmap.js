let map;
let markers = [];
let googleMapId = gon.google_map_id;
// ライブラリ
let advancedMarkerElement;
let directionsService;
let autocompleteSessionToken;
let autocompleteSuggestion;
let geocoder;

async function initMap() {
  // 必要なライブラリをインポート
  const { Map } = await google.maps.importLibrary("maps");
  const { AdvancedMarkerElement } = await google.maps.importLibrary("marker");
  const { encoding } = await google.maps.importLibrary("geometry");
  directionsService = await new google.maps.DirectionsService();
  const { AutocompleteSessionToken, AutocompleteSuggestion } = await google.maps.importLibrary("places");
  geocoder = await new google.maps.Geocoder();

  advancedMarkerElement = AdvancedMarkerElement;
  autocompleteSessionToken = AutocompleteSessionToken;
  autocompleteSuggestion = AutocompleteSuggestion;

  // 変数を定義
  const routePoints = []; // ルートを構成する座標データ
  let routePolyline; // ポリラインオブジェクト

  // マップのオプションを設定
  const defaultLocation = { lat: 35.6809591, lng: 139.7673068 };
  const mapOptions = {
    center: { lat: defaultLocation.lat, lng: defaultLocation.lng },
    zoom: 15,
    streetViewControl: false, // ストリートビューのボタン非表示
    mapTypeControl: false, // 地図、航空写真のボタン非表示
    fullscreenControl: false, // フルスクリーンボタン非表示
    mapId: googleMapId,
  };

  // マップオブジェクトの作成
  map = new Map(document.getElementById("create-map"), mapOptions);

  // ルート作成
  map.addListener('click', async (e) => {
    if (!e.placeId) {
      routePoints.push(e.latLng);

      // クリックした地点にマーカーを作成
      createRouteMarker(e.latLng, map);
    }

    if (routePoints.length >= 2) {
      resetPolyline(routePolyline); // マップに描写されているポリラインを削除

      const route = await calcRoute(routePoints) // ルートを計算

      routePolyline = getPolylineObject(route.overview_polyline); // ポリラインオブジェクトを作成
      routePolyline.setMap(map); // ルートをマップ上に描写

      // マーカーをルート上に表示
      clearRouteMarkers(markers);
      setMarkerOnPolyline(route);

      addValueToForm(route, routePoints); // フォームにデータを追加
    }
  });

  // マップ検索
  // autocomplete apiのオプション
  let autocompleteOptions = {
    input: "",
    locationBias: map.getBounds(),
    includedRegionCodes: ["JP"],
    language: "ja",
    region: "JP",
  };

  // ズームレベル変更時の操作
  map.addListener('bounds_changed', () => {
    // マップ表示範囲を更新
    autocompleteOptions.locationBias = map.getBounds();

    // マーカーの表示非表示を制御
    if (!markers) { return; }

    const zoomLevel = map.getZoom();
    if (zoomLevel < 13.5) {
      markers.forEach(marker => {
        marker.setMap(null);
      })
    } else {
      markers.forEach(marker => {
        marker.setMap(map);
      })
    }
  });

  // マップ上の検索
  let input = document.querySelector("#search-input");
  let suggestedLocations = document.getElementById("suggested-locations")
  input.addEventListener('input', (e) => makeAcRequest(autocompleteOptions, e, suggestedLocations));
  autocompleteOptions = refreshToken(autocompleteOptions);
}

import { getPolylineObject } from "./gmap_common";

initMap();

// !ルート計算
async function calcRoute(routePoints) {
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
  return new Promise((resolve, reject) => {
    directionsService.route(request, (response, status) => {
      if (status == 'OK') {
        const route = response.routes[0]; // ルート計算の結果からルート情報を取得
        resolve(route);
      }
    });
  })
}

// !ポリラインをマップ上から除去
function resetPolyline(routePolyline) {
  if (routePolyline) {
    routePolyline.setMap(null);
    routePolyline = null;
  }
}

// !コース上にマーカーを作成
function createRouteMarker(latLng, map) {
  const routeCreateMarkerView = new advancedMarkerElement({
    map,
    position: latLng,
  });
  markers.push(routeCreateMarkerView);
}

// !ルート上のマーカーを削除
function clearRouteMarkers(markers) {
  markers.forEach(marker => {
    marker.setMap(null);
  })
  markers.length = 0;
}

// !ポリライン上にマーカーを設置
function setMarkerOnPolyline(route) {
  const legs = route.legs;
  for (let i = 0; i < legs.length; i++) {
    const legStartLocation = legs[i].start_location;
    createRouteMarker(legStartLocation, map);
  }

  const legEndLocation = legs[legs.length - 1].end_location;
  createRouteMarker(legEndLocation, map);
}

// !ルートの総距離を計算
function calcTotalDistance(route) {
  let totalDistance = 0;

  route.legs.forEach((leg) => {
    totalDistance += leg.distance.value / 1_000; // 総距離kmを算出
  });

  return totalDistance;
}

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
      encodedPolylineField.value = route.overview_polyline;
  
      // コースを構成する座標データ
      const positionsField = e.target.querySelector('#marker-positions-field');
      positionsField.value = JSON.stringify(routePoints);
    })
  }
}

// !autocompleteを用いて検索結果を表示
async function makeAcRequest(request, input, results) {
  // 入力値が空文字の場合、検索結果をリセット
  if (input.target.value == "") {
    results.replaceChildren();
    return;
  }

  // 検索結果をリセット
  results.replaceChildren();

  // 入力文字をautocompleteのinputに設定
  request.input = input.target.value;

  // 検索結果を取得
  const { suggestions } =
  await autocompleteSuggestion.fetchAutocompleteSuggestions(
    request,
  );

  for (const suggestion of suggestions) {
    const placePrediction = suggestion.placePrediction;
    // 検索結果を表示するための要素を生成
    const a = document.createElement("a");
    a.classList.add("block");

    // 検索候補選択時の処理
    a.addEventListener("click", () => {
      onPlaceSelected(placePrediction.toPlace());
      input.target.value = "";
      results.replaceChildren();
      refreshToken(request);
    });

    a.innerText = placePrediction.mainText.toString();

    // 詳細な住所を表示するための領域を生成
    if (placePrediction.secondaryText) {
      const span = document.createElement("span");
      span.classList.add("text-xs", "text-gray-500", "truncate", "block");

      span.innerText = placePrediction.secondaryText.toString();
      a.appendChild(span);
    }

    // 検索候補を表示
    const li = document.createElement("li");
    li.appendChild(a);
    results.appendChild(li);
  }
}

// !検索候補クリック時の処理
async function onPlaceSelected(place) {
  await place.fetchFields ({
    fields: ["id"],
  });

  // placeIdから緯度経度を取得
  geocoder.geocode({ placeId: place.id })
    .then(({ results }) => {
      if(results[0]) {
        map.setZoom(16);
        map.setCenter(results[0].geometry.location);

        const marker = new advancedMarkerElement({
          map,
          position: results[0].geometry.location,
        })
      }
    })
}

// !session tokenをリセット
function refreshToken(request) {
  let token = new autocompleteSessionToken();
  request.sessionToken = token;
  return(request);
}
