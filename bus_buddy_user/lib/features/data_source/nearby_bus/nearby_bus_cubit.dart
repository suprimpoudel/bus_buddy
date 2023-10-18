import 'package:bus_buddy_user/features/data_source/nearby_bus/nearby_bus_repository.dart';
import 'package:bus_buddy_user/features/data_source/nearby_bus/nearby_bus_state.dart';
import 'package:bus_buddy_user/features/model/nearby_bus_request.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NearbyBusCubit extends Cubit<NearbyBusLocationState> {
  final NearbyBusRepository _repository;
  NearbyBusCubit(this._repository) : super(NearbyBusLocationIdleState());

  Future<void> getNearbyBus(NearbyBusRequest nearbyBusRequest) async {
    emit(NearbyBusLocationLoadingState());
    try {
      await _repository.getNearbyBuses(nearbyBusRequest).then((value) {
        emit(NearbyBusLocationListState(value));
      });
    } catch (e) {
      emit(NearbyBusLocationErrorState(e));
      emit(NearbyBusLocationIdleState());
    }
  }
}
