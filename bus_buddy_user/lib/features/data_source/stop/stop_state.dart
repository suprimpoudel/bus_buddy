import 'package:bus_buddy_user/features/model/stop.dart';
import 'package:equatable/equatable.dart';

abstract class StopState extends Equatable {
  const StopState();

  @override
  List<Object?> get props => [];
}

class StopIdleState extends StopState {}

class StopLoadingState extends StopState {}

class StopListState extends StopState {
  final List<Stop> stops;

  const StopListState(this.stops);
}

class StopErrorState extends StopState {
  final dynamic error;
  const StopErrorState(this.error);
}
