import 'package:bus_buddy_user/features/data_source/base/base_repository.dart';
import 'package:bus_buddy_user/features/model/login.dart';
import 'package:bus_buddy_user/network/base_service.dart';
import 'package:bus_buddy_user/utils/constants/api_constants.dart';
import 'package:bus_buddy_user/utils/constants/preference_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginRepository extends BaseRepository {
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
      var login = convertToDataClass<LoginResponse>(value);
      await _sharedPreferences.setString(token, login.jwtToken ?? "");
      await _sharedPreferences.setString(
          firstName, login.user?.firstName ?? "");
      await _sharedPreferences.setString(lastName, login.user?.lastName ?? "");
      await _sharedPreferences.setInt(userId, login.user?.id ?? -1);
      return login;
    });
  }

  @override
  fromJson<T>(Map<String, dynamic> json) {
    return LoginResponse.fromJson(json);
  }

  @override
  fromJsonList<T>(List jsonList) {}
}
