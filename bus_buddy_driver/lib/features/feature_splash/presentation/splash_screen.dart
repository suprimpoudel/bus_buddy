import 'package:bus_buddy_driver/features/feature_home/presentation/home_screen.dart';
import 'package:bus_buddy_driver/features/feature_login/presentation/login_screen.dart';
import 'package:bus_buddy_driver/utils/constants/preference_constants.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    _initSetup();
    super.initState();
  }

  Future<void> _initSetup() async {
    await SharedPreferences.getInstance().then((value) {
      var accessToken = value.getString(token) ?? "";
      if (accessToken.isEmpty) {
        context.pushReplacement("/${LoginScreen.routeName}");
      } else {
        context.pushReplacement("/${HomeScreen.route}");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
