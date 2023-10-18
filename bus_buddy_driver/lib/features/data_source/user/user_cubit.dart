import 'package:bus_buddy_driver/features/data_source/user/user_state.dart';
import 'package:bus_buddy_driver/features/model/user.dart';
import 'package:bus_buddy_driver/features/repository/user/user_repository_impl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserCubit extends Cubit<UserState> {
  final UserRepositoryImpl _userRepository;
  UserCubit(this._userRepository) : super(UserIdleState());

  void getUserById() async {
    emit(const UserLoadingState(false));
    try {
      await _userRepository.getUserDetails().then((value) {
        emit(UserSelectState(value));
      });
    } catch (e) {
      emit(UserErrorState(e));
      emit(UserIdleState());
    }
  }

  void addUpdateUser(User user) async {
    emit(const UserLoadingState(true));
    try {
      await _userRepository.addUpdateUser(user).then((value) {
        emit(UserAddUpdateState(user.id != null, value));
      });
    } catch (e) {
      emit(UserErrorState(e));
      emit(UserIdleState());
    }
  }

  void logoutUser() async {
    emit(const UserLoadingState(false));
    try {
      await _userRepository.logoutUser().then((value) {
        emit(UserLogoutState());
      });
    } catch (e) {
      emit(UserErrorState(e));
      emit(UserIdleState());
    }
  }
}
