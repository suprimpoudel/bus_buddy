import 'package:bus_buddy_driver/features/feature_login/model/login_request.dart';
import 'package:bus_buddy_driver/features/feature_login/model/login_response.dart';

abstract class LoginRepository {
  Future<LoginResponse> loginUser(LoginRequest loginRequest);
}
