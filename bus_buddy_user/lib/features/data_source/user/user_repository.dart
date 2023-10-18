import 'package:bus_buddy_user/features/model/user.dart';
import 'package:bus_buddy_user/network/base_service.dart';
import 'package:bus_buddy_user/utils/constants/api_constants.dart';
import 'package:bus_buddy_user/utils/constants/preference_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserRepository {
  final SharedPreferences _sharedPreferences;
  final BaseService _baseService;

  UserRepository(this._sharedPreferences, this._baseService);

  Future<User> getUserById() async {
    var userIdPrefs = _sharedPreferences.getInt(userId) ?? -1;
    return _baseService
        .getRequest(url: "$userEndPoint/$userIdPrefs")
        .then((value) {
      return User.fromJson(value["result"]);
    });
  }

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
}
