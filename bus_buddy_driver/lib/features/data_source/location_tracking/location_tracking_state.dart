import 'package:equatable/equatable.dart';

abstract class LocationTrackingState extends Equatable {
  const LocationTrackingState();

  @override
  List<Object?> get props => [];
}

class LocationIdleState extends LocationTrackingState {}
