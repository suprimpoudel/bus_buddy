import 'package:bus_buddy_user/features/data_source/home_screen/bottom_navigation_cubit.dart';
import 'package:bus_buddy_user/features/ui/screens/home/bottom_nav_items/home_item.dart';
import 'package:bus_buddy_user/features/ui/screens/home/bottom_nav_items/nearby_bus_item.dart';
import 'package:bus_buddy_user/features/ui/screens/home/bottom_nav_items/settings_item.dart';
import 'package:bus_buddy_user/features/ui/screens/shared/location_permission_denied_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';

var _bottomNavigationItems = [
  const NearbyBusItem(),
  const HomeItem(),
  const SettingsItem(),
];

class HomeScreen extends StatefulWidget {
  static const String routeName = "home";
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BottomNavigationCubit, int>(builder: (context, state) {
      return Scaffold(
        body: _bottomNavigationItems[state],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: state,
          showSelectedLabels: true,
          showUnselectedLabels: false,
          onTap: (index) async {
            if (index == 0) {
              await Permission.location.isGranted.then((status) {
                if (status) {
                  context
                      .read<BottomNavigationCubit>()
                      .changeBottomNavigationIndex(index);
                } else {
                  context.push("/${LocationPermissionDeniedScreen.routeName}");
                }
              });
            } else {
              context
                  .read<BottomNavigationCubit>()
                  .changeBottomNavigationIndex(index);
            }
          },
          items: const [
            BottomNavigationBarItem(
                icon: Icon(
                  FontAwesomeIcons.map,
                ),
                label: "Live Tracking"),
            BottomNavigationBarItem(
                icon: Icon(
                  FontAwesomeIcons.house,
                ),
                label: "Home"),
            BottomNavigationBarItem(
                icon: Icon(
                  FontAwesomeIcons.gear,
                ),
                label: "Settings"),
          ],
        ),
      );
    });
  }
}
