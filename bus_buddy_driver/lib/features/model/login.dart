import 'package:bus_buddy_driver/features/model/user.dart';

class LoginResponse {
  String? jwtToken;
  User? user;

  LoginResponse({this.jwtToken, this.user});

  LoginResponse.fromJson(Map<String, dynamic> json) {
    jwtToken = json['jwtToken'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['jwtToken'] = jwtToken;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    return data;
  }
}
