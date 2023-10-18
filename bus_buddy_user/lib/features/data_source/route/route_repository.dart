import 'package:bus_buddy_user/features/data_source/base/base_repository.dart';
import 'package:bus_buddy_user/features/model/route.dart';
import 'package:bus_buddy_user/network/base_service.dart';
import 'package:bus_buddy_user/utils/constants/api_constants.dart';

class RouteRepository extends BaseRepository {
  final BaseService _baseService;

  RouteRepository(this._baseService);

  Future<List<RouteModel>> getPlaceBetweenRoutes(
      String placeOne, String placeTwo) async {
    return await _baseService.getRequest(url: routeEndPoint, queryParams: {
      "placeOne": placeOne,
      "placeTwo": placeTwo
    }).then((value) {
      return convertToDataClass<List<RouteModel>>(value);
    });
  }

  Future<List<RouteModel>> getAllRoutes() async {
    return await _baseService.getRequest(url: allRouteEndPoint).then((value) {
      return convertToDataClass<List<RouteModel>>(value);
    });
  }

  Future<RouteModel> getRouteInfo(int? routeId) async {
    return await _baseService
        .getRequest(url: "$routeEndPoint/$routeId")
        .then((value) {
      return convertToDataClass<RouteModel>(value);
    });
  }

  @override
  fromJson<T>(Map<String, dynamic> json) {
    return RouteModel.fromJson(json);
  }

  @override
  fromJsonList<T>(List jsonList) {
    if (T == List<RouteModel>) {
      return jsonList.map((model) => RouteModel.fromJson(model)).toList();
    }
  }
}
