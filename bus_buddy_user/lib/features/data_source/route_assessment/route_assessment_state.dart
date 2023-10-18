import 'package:bus_buddy_user/features/model/route_assessment.dart';
import 'package:equatable/equatable.dart';

abstract class RouteAssessmentState extends Equatable {
  const RouteAssessmentState();

  @override
  List<Object?> get props => [];
}

class RouteAssessmentIdleState extends RouteAssessmentState {}

class RouteAssessmentLoadingState extends RouteAssessmentState {}

class RouteAssessmentSuccessState extends RouteAssessmentState {
  final RouteAssessment routeAssessment;

  const RouteAssessmentSuccessState(this.routeAssessment);
}

class RouteAssessmentErrorState extends RouteAssessmentState {
  final dynamic error;
  const RouteAssessmentErrorState(this.error);
}
