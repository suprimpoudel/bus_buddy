import 'package:bus_buddy_user/features/model/place.dart';
import 'package:bus_buddy_user/features/model/route.dart';

class Stop {
  int? id;
  int? stopTime;
  int? orderNo;
  Place? place;
  RouteModel? route;
  String? createdAt;
  String? updatedAt;

  Stop(
      {this.id,
      this.stopTime,
      this.orderNo,
      this.place,
      this.route,
      this.createdAt,
      this.updatedAt});

  Stop.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    stopTime = json['stopTime'];
    orderNo = json['orderNo'];
    place = json['place'] != null ? Place.fromJson(json['place']) : null;
    route = json['route'] != null ? RouteModel.fromJson(json['route']) : null;
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['stopTime'] = stopTime;
    data['orderNo'] = orderNo;
    if (place != null) {
      data['place'] = place!.toJson();
    }
    if (route != null) {
      data['route'] = route!.toJson();
    }
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}
