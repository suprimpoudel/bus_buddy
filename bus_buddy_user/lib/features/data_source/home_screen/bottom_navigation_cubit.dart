import 'package:flutter_bloc/flutter_bloc.dart';

class BottomNavigationCubit extends Cubit<int> {
  BottomNavigationCubit() : super(1);

  void changeBottomNavigationIndex(int index) {
    emit(index);
  }
}
