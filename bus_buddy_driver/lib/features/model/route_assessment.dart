import 'package:bus_buddy_driver/features/model/route.dart';
import 'package:bus_buddy_driver/features/model/user.dart';

class RouteAssessment {
  int? id;
  Vehicle? vehicle;
  User? driver;
  RouteModel? route;
  String? createdAt;
  String? updatedAt;

  RouteAssessment(
      {this.id,
      this.vehicle,
      this.driver,
      this.route,
      this.createdAt,
      this.updatedAt});

  RouteAssessment.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    vehicle =
        json['vehicle'] != null ? Vehicle.fromJson(json['vehicle']) : null;
    driver = json['driver'] != null ? User.fromJson(json['driver']) : null;
    route = json['route'] != null ? RouteModel.fromJson(json['route']) : null;
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    if (vehicle != null) {
      data['vehicle'] = vehicle!.toJson();
    }
    if (driver != null) {
      data['driver'] = driver!.toJson();
    }
    if (route != null) {
      data['route'] = route!.toJson();
    }
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}

class Vehicle {
  int? id;
  int? seatingCapacity;
  String? model;
  String? vehicleNumber;
  String? createdAt;
  String? updatedAt;

  Vehicle(
      {this.id,
      this.seatingCapacity,
      this.model,
      this.vehicleNumber,
      this.createdAt,
      this.updatedAt});

  Vehicle.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    seatingCapacity = json['seatingCapacity'];
    model = json['model'];
    vehicleNumber = json['vehicleNumber'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['seatingCapacity'] = seatingCapacity;
    data['model'] = model;
    data['vehicleNumber'] = vehicleNumber;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}
