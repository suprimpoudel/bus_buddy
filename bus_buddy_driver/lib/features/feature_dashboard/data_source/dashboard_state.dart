import 'package:bus_buddy_driver/features/model/route_assessment.dart';
import 'package:equatable/equatable.dart';

abstract class DashboardState extends Equatable {
  const DashboardState();

  @override
  List<Object?> get props => [];
}

class DashboardIdleState extends DashboardState {}

class DashboardLoadingState extends DashboardState {}

class DashboardSuccessState extends DashboardState {
  final RouteAssessment routeAssessment;

  const DashboardSuccessState(this.routeAssessment);
}

class DashboardErrorState extends DashboardState {
  final dynamic error;

  const DashboardErrorState(this.error);
}
