import 'package:bus_buddy_user/features/ui/screens/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationPermissionDeniedScreen extends StatelessWidget {
  static const String routeName = "locationPermissionDenied";
  const LocationPermissionDeniedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset('assets/lottie/location.json', height: height * .5),
          const SizedBox(
            height: 32.0,
          ),
          Text(
            "Location Permission is denied. Please grant location permission to proceed",
            style: GoogleFonts.lato().copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 24.0,
            ),
            textAlign: TextAlign.center,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(
            height: 32.0,
          ),
          ElevatedButton(
            onPressed: () async {
              await Permission.location.request().then((value) async {
                if (value.isGranted) {
                  if (context.canPop()) {
                    context.pop();
                  } else {
                    context.pushReplacement("/${HomeScreen.routeName}");
                  }
                } else {
                  await showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text("Permission Denied"),
                      content: const Text(
                          "Location permission is required for this feature"),
                      actions: [
                        TextButton(
                          onPressed: () {
                            context.pop();
                          },
                          child: const Text("OK"),
                        )
                      ],
                    ),
                  ).then((value) {
                    if (context.canPop()) {
                      context.pop();
                    }
                  });
                }
              });
            },
            child: const Text("Grant Permission"),
          ),
        ],
      ),
    );
  }
}
