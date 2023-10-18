import 'package:bus_buddy_user/features/data_source/route/route_repository.dart';
import 'package:bus_buddy_user/features/data_source/route/route_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RouteCubit extends Cubit<RouteState> {
  final RouteRepository _repository;

  RouteCubit(this._repository) : super(RouteIdleState());

  Future<void> getPlaceBetweenRoutes(String placeOne, String placeTwo) async {
    emit(RouteLoadingState());
    try {
      await _repository.getPlaceBetweenRoutes(placeOne, placeTwo).then((value) {
        emit(RouteSearchSuccessState(value));
      });
    } catch (e) {
      emit(RouteErrorState(e));
      emit(RouteIdleState());
    }
  }

  Future<void> getRouteInfo(int? routeId) async {
    emit(RouteSingleLoadingState());
    try {
      await _repository.getRouteInfo(routeId).then((value) {
        emit(RouteSuccessState(value));
      });
    } catch (e) {
      emit(RouteSingleErrorState(e));
      emit(RouteIdleState());
    }
  }

  Future<void> getAllRoutes() async {
    emit(RouteListLoadingState());
    try {
      await _repository.getAllRoutes().then((value) {
        emit(RouteListSuccessState(value));
      });
    } catch (e) {
      emit(RouteListErrorState(e));
      emit(RouteIdleState());
    }
  }
}
