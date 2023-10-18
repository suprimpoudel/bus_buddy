import 'package:bus_buddy_user/features/model/nearby_bus_location.dart';
import 'package:equatable/equatable.dart';

abstract class NearbyBusLocationState extends Equatable {
  const NearbyBusLocationState();

  @override
  List<Object?> get props => [];
}

class NearbyBusLocationIdleState extends NearbyBusLocationState {}

class NearbyBusLocationLoadingState extends NearbyBusLocationState {}

class NearbyBusLocationListState extends NearbyBusLocationState {
  final List<NearbyBusLocation> nearbyBusLocations;

  const NearbyBusLocationListState(this.nearbyBusLocations);
}

class NearbyBusLocationErrorState extends NearbyBusLocationState {
  final dynamic error;
  const NearbyBusLocationErrorState(this.error);
}
