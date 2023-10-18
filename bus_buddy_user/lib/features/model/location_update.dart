class LiveLocationUpdate {
  double? latitude;
  double? longitude;
  int? driverId;

  LiveLocationUpdate({this.latitude, this.longitude, this.driverId});

  LiveLocationUpdate.fromJson(Map<String, dynamic> json) {
    latitude = json['latitude'];
    longitude = json['longitude'];
    driverId = json['driverId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['driverId'] = driverId;
    return data;
  }
}
