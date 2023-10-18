import 'package:geolocator/geolocator.dart';

abstract class LocationTrackingRepository {
  void updateLiveLocation(Position position);
}
