import 'package:bus_buddy_user/features/ui/screens/login/login_screen.dart';
import 'package:bus_buddy_user/utils/constants/preference_constants.dart';
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
    SharedPreferences.getInstance().then((value) {
      var accessToken = value.getString(token) ?? "";
      if (mounted) {
        if (accessToken.trim().isEmpty) {
          context.pushReplacement("/${LoginScreen.routeName}");
        } else {
          context.pushReplacement("/${LoginScreen.routeName}");
        }
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Center(
        child: SizedBox(
          width: width * 0.3,
          child: Image.asset(
            "assets/images/app_icon.png",
            errorBuilder: (context, object, stack) {
              return const SizedBox();
            },
          ),
        ),
      ),
    );
  }
}
