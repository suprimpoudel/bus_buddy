import 'package:bus_buddy_driver/features/model/user.dart';
import 'package:bus_buddy_driver/features/repository/user/user_repository.dart';
import 'package:bus_buddy_driver/network/base_service.dart';
import 'package:bus_buddy_driver/utils/constants/api_constants.dart';
import 'package:bus_buddy_driver/utils/constants/preference_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserRepositoryImpl extends UserRepository {
  final SharedPreferences _sharedPreferences;
  final BaseService _baseService;

  UserRepositoryImpl(this._sharedPreferences, this._baseService);

  @override
  Future<User> addUpdateUser(User user) async {
    if (user.id == null) {
      return _baseService
          .postRequest(url: userEndPoint, body: user.toJson())
          .then((value) {
        return User.fromJson(value["result"]);
      });
    } else {
      return _baseService
          .putRequest(url: "$userEndPoint/${user.id}", body: user.toJson())
          .then((value) {
        return User.fromJson(value["result"]);
      });
    }
  }

  @override
  Future<User> getUserDetails() {
    var user = _sharedPreferences.getInt(userId) ?? -1;
    return _baseService.getRequest(url: "$userEndPoint/$user").then((value) {
      return User.fromJson(value["result"]);
    });
  }

  @override
  Future<void> logoutUser() async {
    await _sharedPreferences.remove(userId);
    await _sharedPreferences.remove(token);
  }
}
