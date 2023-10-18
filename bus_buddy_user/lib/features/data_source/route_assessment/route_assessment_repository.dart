import 'package:bus_buddy_user/features/data_source/base/base_repository.dart';
import 'package:bus_buddy_user/features/model/location_update.dart';
import 'package:bus_buddy_user/features/model/route_assessment.dart';
import 'package:bus_buddy_user/features/model/stop.dart';
import 'package:bus_buddy_user/network/base_service.dart';
import 'package:bus_buddy_user/utils/constants/api_constants.dart';

class RouteAssessmentRepository extends BaseRepository {
  final BaseService _baseService;

  RouteAssessmentRepository(this._baseService);

  Future<RouteAssessment> getRouteAssessmentDetailByVehicleId(
      int? vehicleId) async {
    return await _baseService.getRequest(
        url: routeAssessmentEndPoint,
        queryParams: {"vehicleId": vehicleId}).then((value) {
      return convertToDataClass<RouteAssessment>(value);
    });
  }

  Future<double> calculateEat(LiveLocationUpdate liveLocationUpdate) async {
    try {
      return await _baseService
          .postRequest(url: calculateEAT, body: liveLocationUpdate.toJson())
          .then((value) {
        return double.tryParse(value["result"].toString()) ?? 0.0;
      });
    } catch (e) {
      rethrow;
    }
  }

  @override
  fromJson<T>(Map<String, dynamic> json) {
    if (T == RouteAssessment) {
      return RouteAssessment.fromJson(json);
    } else if (T == LiveLocationUpdate) {
      return LiveLocationUpdate.fromJson(json);
    }
  }

  @override
  fromJsonList<T>(List jsonList) {
    if (T == List<Stop>) {
      return jsonList.map((model) => Stop.fromJson(model)).toList();
    }
  }
}
