import 'package:bus_buddy_driver/features/model/user.dart';

abstract class UserRepository {
  Future<User> getUserDetails();
  Future<User> addUpdateUser(User user);
  Future<void> logoutUser();
}
