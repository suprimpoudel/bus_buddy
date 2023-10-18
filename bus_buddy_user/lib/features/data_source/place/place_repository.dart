import 'package:bus_buddy_user/features/data_source/base/base_repository.dart';
import 'package:bus_buddy_user/features/model/place.dart';
import 'package:bus_buddy_user/network/base_service.dart';
import 'package:bus_buddy_user/utils/constants/api_constants.dart';

class PlaceRepository extends BaseRepository {
  final BaseService _baseService;

  PlaceRepository(this._baseService);

  Future<Place> getPlaceById(int? placeId) async {
    return _baseService
        .getRequest(url: "$placeEndPoint/$placeId")
        .then((value) {
      return Place.fromJson(value["result"]);
    });
  }

  Future<List<Place>> getAllPlace() async {
    return await _baseService.getRequest(url: allPlaceEndPoint).then((value) {
      return convertToDataClass<List<Place>>(value);
    });
  }

  @override
  fromJson<T>(Map<String, dynamic> json) {
    throw UnimplementedError();
  }

  @override
  fromJsonList<T>(List jsonList) {
    if (T == List<Place>) {
      return jsonList.map((model) => Place.fromJson(model)).toList();
    }
  }
}
