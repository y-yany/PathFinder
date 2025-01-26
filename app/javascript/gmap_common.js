// !ポリラインオブジェクトを作成
export function getPolylineObject(encodedPolyline) {
  const routeCoordinates = google.maps.geometry.encoding.decodePath(encodedPolyline); // エンコードされたパスをデコード

  // ポリラインオブジェクトを作成
  const polylineObject = new google.maps.Polyline({
    path: routeCoordinates,
    geodesic: true, // 地球の曲率を考慮した直線
    strokeColor: "#ff7f50", // ポリラインの色
    strokeOpacity: 0.9, // ポリラインの透過度
    strokeWeight: 7, // ポリラインの太さ
  })

  return polylineObject;
}
