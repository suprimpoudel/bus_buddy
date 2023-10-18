import 'package:bus_buddy_driver/features/model/user.dart';

class LoginResponse {
  User? user;
  String? jwtToken;

  LoginResponse({this.user, this.jwtToken});

  LoginResponse.fromJson(Map<String, dynamic> json) {
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    jwtToken = json['jwtToken'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (user != null) {
      data['user'] = user!.toJson();
    }
    data['jwtToken'] = jwtToken;
    return data;
  }
}
