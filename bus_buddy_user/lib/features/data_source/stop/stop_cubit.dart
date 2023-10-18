import 'package:bus_buddy_user/features/data_source/stop/stop_repository.dart';
import 'package:bus_buddy_user/features/data_source/stop/stop_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StopCubit extends Cubit<StopState> {
  final StopRepository _stopRepository;
  StopCubit(this._stopRepository) : super(StopIdleState());

  Future<void> getAllStopBasedOnRouteId(int? routeId) async {
    emit(StopLoadingState());
    try {
      await _stopRepository.getAllStopBasedOnRouteId(routeId).then((value) {
        emit(StopListState(value));
      });
    } catch (e) {
      emit(StopErrorState(e));
      emit(StopIdleState());
    }
  }
}
