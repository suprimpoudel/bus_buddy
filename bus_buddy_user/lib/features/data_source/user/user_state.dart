import 'package:bus_buddy_user/features/model/user.dart';
import 'package:equatable/equatable.dart';

abstract class UserState extends Equatable {
  const UserState();

  @override
  List<Object?> get props => [];
}

class UserIdleState extends UserState {}

class UserSelectState extends UserState {
  final User user;

  const UserSelectState(this.user);
}

class UserLoadingState extends UserState {
  final bool isInnerLoading;

  const UserLoadingState(this.isInnerLoading);
}

class UserErrorState extends UserState {
  final dynamic error;

  const UserErrorState(this.error);
}

class UserAddUpdateState extends UserState {
  final User user;
  final bool isUpdate;

  const UserAddUpdateState(this.isUpdate, this.user);
}
