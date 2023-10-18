import 'package:bus_buddy_driver/features/feature_dashboard/data_source/dashboard_repository.dart';
import 'package:bus_buddy_driver/features/feature_dashboard/data_source/dashboard_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DashboardCubit extends Cubit<DashboardState> {
  final DashboardRepository _dashboardRepository;
  DashboardCubit(this._dashboardRepository) : super(DashboardIdleState());

  Future<void> getRouteAssessmentByDriver() async {
    emit(DashboardLoadingState());
    try {
      await _dashboardRepository.getRouteAssessmentByDriver().then((value) {
        emit(DashboardSuccessState(value));
      });
    } catch (e) {
      emit(DashboardErrorState(e));
      emit(DashboardIdleState());
    }
  }
}
