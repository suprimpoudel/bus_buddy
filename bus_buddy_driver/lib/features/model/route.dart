import 'package:bus_buddy_driver/features/model/place.dart';

class RouteModel {
  int? id;
  String? name;
  bool? isRoundAboutRoute;
  Place? startDestination;
  Place? endDestination;
  int? totalStops;
  int? totalDrivers;
  int? totalVehicles;

  RouteModel(
      {this.id,
      this.name,
      this.isRoundAboutRoute,
      this.startDestination,
      this.endDestination,
      this.totalStops,
      this.totalDrivers,
      this.totalVehicles});

  RouteModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    isRoundAboutRoute = json['isRoundAboutRoute'];
    startDestination = json['startDestination'] != null
        ? Place.fromJson(json['startDestination'])
        : null;
    endDestination = json['endDestination'] != null
        ? Place.fromJson(json['endDestination'])
        : null;
    totalStops = json['totalStops'];
    totalDrivers = json['totalDrivers'];
    totalVehicles = json['totalVehicles'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['isRoundAboutRoute'] = isRoundAboutRoute;
    if (startDestination != null) {
      data['startDestination'] = startDestination!.toJson();
    }
    if (endDestination != null) {
      data['endDestination'] = endDestination!.toJson();
    }
    data['totalStops'] = totalStops;
    data['totalDrivers'] = totalDrivers;
    data['totalVehicles'] = totalVehicles;
    return data;
  }
}
