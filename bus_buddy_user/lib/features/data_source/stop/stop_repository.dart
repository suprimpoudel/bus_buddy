import 'package:bus_buddy_user/features/data_source/base/base_repository.dart';
import 'package:bus_buddy_user/features/model/stop.dart';
import 'package:bus_buddy_user/network/base_service.dart';
import 'package:bus_buddy_user/utils/constants/api_constants.dart';

class StopRepository extends BaseRepository {
  final BaseService _baseService;

  StopRepository(this._baseService);

  Future<List<Stop>> getAllStopBasedOnRouteId(int? routeId) async {
    return await _baseService.getRequest(
        url: stopEndPoint, queryParams: {"routeId": routeId}).then((value) {
      return convertToDataClass<List<Stop>>(value);
    });
  }

  @override
  fromJson<T>(Map<String, dynamic> json) {
    throw UnimplementedError();
  }

  @override
  fromJsonList<T>(List jsonList) {
    if (T == List<Stop>) {
      return jsonList.map((model) => Stop.fromJson(model)).toList();
    }
  }
}
