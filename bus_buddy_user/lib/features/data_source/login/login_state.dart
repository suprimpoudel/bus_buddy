import 'package:bus_buddy_user/features/model/login.dart';
import 'package:equatable/equatable.dart';

abstract class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object?> get props => [];
}

class LoginIdleState extends LoginState {}

class LoginLoadingState extends LoginState {}

class LoginSuccessState extends LoginState {
  final LoginResponse loginResponse;

  const LoginSuccessState(this.loginResponse);
}

class LoginErrorState extends LoginState {
  final dynamic error;
  const LoginErrorState(this.error);
}
