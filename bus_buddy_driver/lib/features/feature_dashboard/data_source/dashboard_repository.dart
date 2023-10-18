import 'package:bus_buddy_driver/features/model/route_assessment.dart';
import 'package:bus_buddy_driver/network/base_service.dart';
import 'package:bus_buddy_driver/utils/constants/preference_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashboardRepository {
  final BaseService _baseService;
  final SharedPreferences _sharedPreferences;

  DashboardRepository(this._baseService, this._sharedPreferences);

  Future<RouteAssessment> getRouteAssessmentByDriver() async {
    var id = _sharedPreferences.getInt(userId);
    return await _baseService.getRequest(
        url: "routeAssessment/driver",
        queryParams: {"driverId": id}).then((value) {
      return RouteAssessment.fromJson(value["result"]);
    });
  }
}
