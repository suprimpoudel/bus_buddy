import 'package:bus_buddy_driver/features/model/login.dart';
import 'package:bus_buddy_driver/network/base_service.dart';
import 'package:bus_buddy_driver/utils/constants/api_constants.dart';
import 'package:bus_buddy_driver/utils/constants/preference_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginRepository {
  final BaseService _baseService;
  final SharedPreferences _sharedPreferences;

  LoginRepository(this._baseService, this._sharedPreferences);

  Future<LoginResponse> login(String email, String password) async {
    return await _baseService
        .postRequest(
            url: loginEndPoint,
            body: {"email": email, "password": password},
            isAuthorization: true)
        .then((value) async {
      var login = LoginResponse.fromJson(value["result"]);
      if (login.user?.userType == "DRIVER") {
        await _sharedPreferences.setString(token, login.jwtToken ?? "");
        await _sharedPreferences.setInt(userId, login.user?.id ?? -1);
        return login;
      } else {
        throw Exception("Normal users cannot login");
      }
    });
  }
}
