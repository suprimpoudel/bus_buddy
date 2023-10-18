import 'package:bus_buddy_driver/features/feature_login/model/login_request.dart';
import 'package:bus_buddy_driver/features/feature_login/model/login_response.dart';
import 'package:bus_buddy_driver/features/feature_login/repository/login_repository.dart';
import 'package:bus_buddy_driver/network/base_service.dart';
import 'package:bus_buddy_driver/utils/constants/api_constants.dart';
import 'package:bus_buddy_driver/utils/constants/preference_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginRepositoryImpl extends LoginRepository {
  final SharedPreferences _sharedPreferences;
  final BaseService _baseService;

  LoginRepositoryImpl(this._sharedPreferences, this._baseService);

  @override
  Future<LoginResponse> loginUser(LoginRequest loginRequest) async {
    return await _baseService
        .postRequest(url: loginEndPoint)
        .then((value) async {
      var loginResponse = LoginResponse.fromJson(value["data"]);
      await _sharedPreferences.setString(token, loginResponse.jwtToken ?? "");
      await _sharedPreferences.setInt(userId, loginResponse.user?.id ?? -1);
      return loginResponse;
    });
  }
}
