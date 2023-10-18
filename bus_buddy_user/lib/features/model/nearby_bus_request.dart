class NearbyBusRequest {
  double? latitude;
  double? longitude;
  int? distance;

  NearbyBusRequest({this.latitude, this.longitude, this.distance});

  NearbyBusRequest.fromJson(Map<String, dynamic> json) {
    latitude = json['latitude'];
    longitude = json['longitude'];
    distance = json['distance'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['distance'] = distance;
    return data;
  }
}
