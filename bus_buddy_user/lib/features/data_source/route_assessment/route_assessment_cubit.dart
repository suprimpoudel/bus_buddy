import 'package:bus_buddy_user/features/data_source/route_assessment/route_assessment_repository.dart';
import 'package:bus_buddy_user/features/data_source/route_assessment/route_assessment_state.dart';
import 'package:bus_buddy_user/features/model/location_update.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RouteAssessmentCubit extends Cubit<RouteAssessmentState> {
  final RouteAssessmentRepository _repository;
  RouteAssessmentCubit(this._repository) : super(RouteAssessmentIdleState());

  Future<void> getRouteAssessmentDetailByVehicleId(int? vehicleId) async {
    emit(RouteAssessmentLoadingState());
    try {
      await _repository
          .getRouteAssessmentDetailByVehicleId(vehicleId)
          .then((value) {
        emit(RouteAssessmentSuccessState(value));
      });
    } catch (e) {
      emit(RouteAssessmentErrorState(e));
      emit(RouteAssessmentIdleState());
    }
  }

  Future<double> calculateEAT(LiveLocationUpdate liveLocationUpdate) async {
    return await _repository.calculateEat(liveLocationUpdate);
  }
}
