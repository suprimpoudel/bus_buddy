import 'package:bus_buddy_user/features/data_source/base/base_repository.dart';
import 'package:bus_buddy_user/features/model/nearby_bus_location.dart';
import 'package:bus_buddy_user/features/model/nearby_bus_request.dart';
import 'package:bus_buddy_user/network/base_service.dart';
import 'package:bus_buddy_user/utils/constants/api_constants.dart';

class NearbyBusRepository extends BaseRepository {
  final BaseService _baseService;

  NearbyBusRepository(this._baseService);

  Future<List<NearbyBusLocation>> getNearbyBuses(
      NearbyBusRequest nearbyBusRequest) async {
    return await _baseService
        .postRequest(
            url: nearbyVehiclesEndPoint, body: nearbyBusRequest.toJson())
        .then((value) {
      return convertToDataClass<List<NearbyBusLocation>>(value);
    });
  }

  @override
  fromJson<T>(Map<String, dynamic> json) {
    throw UnimplementedError();
  }

  @override
  fromJsonList<T>(List jsonList) {
    if (T == List<NearbyBusLocation>) {
      return jsonList
          .map((model) => NearbyBusLocation.fromJson(model))
          .toList();
    }
  }
}
