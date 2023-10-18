import 'package:bus_buddy_driver/features/repository/location_tracking/location_tracking_repository.dart';
import 'package:bus_buddy_driver/utils/constants/api_constants.dart';
import 'package:bus_buddy_driver/utils/constants/preference_constants.dart';
import 'package:bus_buddy_driver/utils/helper/logger.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocationTrackingRepositoryImpl extends LocationTrackingRepository {
  final DatabaseReference _databaseReference;
  final SharedPreferences _preference;

  LocationTrackingRepositoryImpl(this._databaseReference, this._preference);

  @override
  void updateLiveLocation(Position position) async {
    var driverId = _preference.getInt(userId) ?? -1;
    var reference =
        _databaseReference.child(liveLocation).child("Driver $driverId").push();
    await reference.set({
      "driverId": driverId,
      "vehicleId": 1,
      "routeId": 1,
      "latitude": position.latitude,
      "longitude": position.longitude,
      "timeStamp": (position.timestamp ?? DateTime.now()).toString(),
    });
    Logging.log("Here now");
  }
}
