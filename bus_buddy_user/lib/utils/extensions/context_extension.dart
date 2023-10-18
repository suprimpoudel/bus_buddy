import 'package:bus_buddy_user/features/ui/screens/login/login_screen.dart';
import 'package:bus_buddy_user/utils/constants/preference_constants.dart';
import 'package:bus_buddy_user/utils/helper/custom_exception.dart';
import 'package:bus_buddy_user/utils/helper/logger.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

extension DisplaySnackbar on BuildContext {
  Future<void> displaySnackbar(String? snackbarMessage,
      {SnackBarAction? action}) async {
    if (snackbarMessage != null ||
        snackbarMessage?.isNotEmpty == true && mounted) {
      try {
        ScaffoldMessenger.of(this).hideCurrentSnackBar();
        ScaffoldMessenger.of(this).showSnackBar(
          SnackBar(
            content: Text(snackbarMessage ?? ""),
            action: action,
          ),
        );
      } catch (e) {
        Logging.log(e);
      }
    }
  }
}

extension HandleException on BuildContext {
  Future<void> handleException(dynamic error) async {
    if (error is UnauthorizedException ||
        error.toString().contains("UnauthorizedException")) {
      await SharedPreferences.getInstance().then((value) async {
        value.remove(token);
        value.remove(userId);
        value.remove(firstName);
        value.remove(lastName);

        await showGeneralDialog(
          context: this,
          barrierLabel: "Barrier",
          barrierDismissible: true,
          barrierColor: Colors.black.withOpacity(0.5),
          transitionDuration: const Duration(milliseconds: 250),
          transitionBuilder: (_, anim, __, child) {
            Tween<Offset> tween;
            if (anim.status == AnimationStatus.reverse) {
              tween = Tween(begin: const Offset(-1, 0), end: Offset.zero);
            } else {
              tween = Tween(begin: const Offset(1, 0), end: Offset.zero);
            }
            return WillPopScope(
              onWillPop: () async {
                return false;
              },
              child: SlideTransition(
                position: tween.animate(anim),
                child: FadeTransition(
                  opacity: anim,
                  child: child,
                ),
              ),
            );
          },
          pageBuilder: (_, __, ___) {
            return WillPopScope(
              onWillPop: () async {
                return false;
              },
              child: AlertDialog(
                shape: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.0),
                  borderSide: BorderSide.none,
                ),
                title: const Text("Session Expired"),
                content: const Text(
                    "Session expired. Please login again to continue"),
                actions: [
                  TextButton(
                    child: const Text('OK'),
                    onPressed: () async {
                      while (canPop()) {
                        pop();
                      }
                      pushReplacement("/${LoginScreen.routeName}");
                    },
                  )
                ],
              ),
            );
          },
        );
      });
    } else {
      await showGeneralDialog(
        context: this,
        barrierLabel: "Barrier",
        barrierDismissible: true,
        barrierColor: Colors.black.withOpacity(0.5),
        transitionDuration: const Duration(milliseconds: 250),
        transitionBuilder: (_, anim, __, child) {
          return ScaleTransition(
            scale: anim,
            child: FadeTransition(opacity: anim, child: child),
          );
        },
        pageBuilder: (_, __, ___) {
          return AlertDialog(
            shape: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.0),
              borderSide: BorderSide.none,
            ),
            title: const Text("Error"),
            content: Text(error.toString()),
            actions: [
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  if (mounted) {
                    Navigator.of(this).pop();
                  }
                },
              )
            ],
          );
        },
      );
    }
  }
}
