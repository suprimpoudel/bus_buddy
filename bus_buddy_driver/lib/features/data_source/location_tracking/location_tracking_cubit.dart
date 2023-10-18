import 'package:bus_buddy_driver/features/data_source/location_tracking/location_tracking_state.dart';
import 'package:bus_buddy_driver/features/repository/location_tracking/location_tracking_repository_impl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';

class LocationTrackingCubit extends Cubit<LocationTrackingState> {
  final LocationTrackingRepositoryImpl _repository;

  LocationTrackingCubit(this._repository) : super(LocationIdleState());

  void updateDriverLocation(Position position) {
    _repository.updateLiveLocation(position);
  }
}
