class LiveLocation {
  String? timeStamp;
  int? routeId;
  int? driverId;
  double? latitude;
  int? vehicleId;
  double? longitude;

  LiveLocation(
      {this.timeStamp,
      this.routeId,
      this.driverId,
      this.latitude,
      this.vehicleId,
      this.longitude});

  LiveLocation.fromJson(Map<String, dynamic> json) {
    timeStamp = json['timeStamp'];
    routeId = json['routeId'];
    driverId = json['driverId'];
    latitude = json['latitude'];
    vehicleId = json['vehicleId'];
    longitude = json['longitude'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['timeStamp'] = timeStamp;
    data['routeId'] = routeId;
    data['driverId'] = driverId;
    data['latitude'] = latitude;
    data['vehicleId'] = vehicleId;
    data['longitude'] = longitude;
    return data;
  }
}
