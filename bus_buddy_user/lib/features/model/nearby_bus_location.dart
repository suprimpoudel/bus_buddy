import 'package:bus_buddy_user/features/model/route_assessment.dart';
import 'package:bus_buddy_user/features/model/user.dart';

class NearbyBusLocation {
  User? user;
  double? latitude;
  double? longitude;
  Vehicle? vehicle;
  int? routeId;
  double? distance;

  NearbyBusLocation(
      {this.user,
      this.latitude,
      this.longitude,
      this.vehicle,
      this.routeId,
      this.distance});

  NearbyBusLocation.fromJson(Map<String, dynamic> json) {
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    latitude = json['latitude'];
    longitude = json['longitude'];
    vehicle =
        json['vehicle'] != null ? Vehicle.fromJson(json['vehicle']) : null;
    routeId = json['routeId'];
    distance = json['distance'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (user != null) {
      data['user'] = user!.toJson();
    }
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    if (vehicle != null) {
      data['vehicle'] = vehicle!.toJson();
    }
    data['routeId'] = routeId;
    data['distance'] = distance;
    return data;
  }
}
