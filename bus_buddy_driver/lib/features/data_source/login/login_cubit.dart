import 'package:bus_buddy_driver/features/data_source/login/login_repository.dart';
import 'package:bus_buddy_driver/features/data_source/login/login_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginCubit extends Cubit<LoginState> {
  final LoginRepository _repository;
  LoginCubit(this._repository) : super(LoginIdleState());

  Future<void> loginUser(String email, String password) async {
    emit(LoginLoadingState());
    try {
      await _repository.login(email, password).then((value) {
        emit(LoginSuccessState(value));
      });
    } catch (e) {
      emit(LoginErrorState(e));
      emit(LoginIdleState());
    }
  }
}
