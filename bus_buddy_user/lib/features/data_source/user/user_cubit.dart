import 'package:bus_buddy_user/features/data_source/user/user_repository.dart';
import 'package:bus_buddy_user/features/data_source/user/user_state.dart';
import 'package:bus_buddy_user/features/model/user.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserCubit extends Cubit<UserState> {
  final UserRepository _userRepository;
  UserCubit(this._userRepository) : super(UserIdleState());

  void getUserById() async {
    emit(const UserLoadingState(false));
    try {
      await _userRepository.getUserById().then((value) {
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
}
