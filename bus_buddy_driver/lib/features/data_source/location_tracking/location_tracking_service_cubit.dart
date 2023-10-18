import 'package:flutter_bloc/flutter_bloc.dart';

class LocationTrackingServiceCubit extends Cubit<bool> {
  LocationTrackingServiceCubit() : super(false);

  void updateService(bool status) {
    emit(status);
  }
}
