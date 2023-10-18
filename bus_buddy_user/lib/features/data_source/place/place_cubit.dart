import 'package:bus_buddy_user/features/data_source/place/place_repository.dart';
import 'package:bus_buddy_user/features/data_source/place/place_state.dart';
import 'package:bus_buddy_user/features/model/place.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PlaceCubit extends Cubit<PlaceState> {
  final PlaceRepository _placeRepository;
  PlaceCubit(this._placeRepository) : super(PlaceIdleState());

  Future<List<Place>> getAllPlace() async {
    return await _placeRepository.getAllPlace();
  }
}
