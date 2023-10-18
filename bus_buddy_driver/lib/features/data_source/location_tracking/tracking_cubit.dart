import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';

class TrackingCubit extends Cubit<Marker?> {
  TrackingCubit() : super(null);

  void setMarkers(Marker marker) {
    emit(marker);
  }
}
