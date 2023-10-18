import 'package:bus_buddy_user/features/model/route.dart';
import 'package:equatable/equatable.dart';

abstract class RouteState extends Equatable {
  const RouteState();

  @override
  List<Object?> get props => [];
}

class RouteIdleState extends RouteState {}

class RouteLoadingState extends RouteState {}

class RouteSingleLoadingState extends RouteState {}

class RouteListLoadingState extends RouteState {}

class RouteSearchSuccessState extends RouteState {
  final List<RouteModel> routeList;

  const RouteSearchSuccessState(this.routeList);
}

class RouteListSuccessState extends RouteState {
  final List<RouteModel> routeList;

  const RouteListSuccessState(this.routeList);
}

class RouteSuccessState extends RouteState {
  final RouteModel routeModel;

  const RouteSuccessState(this.routeModel);
}

class RouteErrorState extends RouteState {
  final dynamic error;

  const RouteErrorState(this.error);
}

class RouteListErrorState extends RouteState {
  final dynamic error;

  const RouteListErrorState(this.error);
}

class RouteSingleErrorState extends RouteState {
  final dynamic error;

  const RouteSingleErrorState(this.error);
}
