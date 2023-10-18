import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';

class LiveLocationCubit extends Cubit<List<Marker>> {
  LiveLocationCubit() : super([]);

  void setMarkers(List<Marker> marker) {
    emit(marker);
  }
}
