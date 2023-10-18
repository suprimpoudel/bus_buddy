import 'package:bus_buddy_driver/features/data_source/home_screen/bottom_navigation_cubit.dart';
import 'package:bus_buddy_driver/features/data_source/location_tracking/location_tracking_service_cubit.dart';
import 'package:bus_buddy_driver/features/feature_dashboard/data_source/dashboard_cubit.dart';
import 'package:bus_buddy_driver/features/feature_dashboard/data_source/dashboard_state.dart';
import 'package:bus_buddy_driver/features/feature_home/presentation/bottom_nav_items/bus_tracking_item.dart';
import 'package:bus_buddy_driver/features/feature_home/presentation/bottom_nav_items/home_item.dart';
import 'package:bus_buddy_driver/features/feature_home/presentation/bottom_nav_items/settings_item.dart';
import 'package:bus_buddy_driver/features/presentation/location_permission_denied_screen.dart';
import 'package:bus_buddy_driver/utils/extension/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';

var _bottomNavigationItems = [
  const BusTrackingItem(),
  const HomeItem(),
  const SettingsItem(),
];

class HomeScreen extends StatefulWidget {
  static const String route = "homeScreen";
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LocationTrackingServiceCubit, bool>(
      listener: (context, locationState) {},
      builder: (context, locationState) =>
          BlocBuilder<BottomNavigationCubit, int>(builder: (context, state) {
        return WillPopScope(
          onWillPop: () async {
            if (locationState) {
              context.displaySnackbar(
                  "Cannot exit application when location is being tracked");
              return false;
            }
            return true;
          },
          child: Scaffold(
            body: _bottomNavigationItems[state],
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: state,
              showSelectedLabels: true,
              showUnselectedLabels: false,
              onTap: (index) async {
                if (locationState) {
                  context.handleException(
                      "Cannot change to different view when location is being tracked");
                } else {
                  if (index == 0) {
                    if (context.read<DashboardCubit>().state
                        is DashboardSuccessState) {
                      await Permission.location.isGranted.then((status) {
                        if (status) {
                          context.read<LocationTrackingServiceCubit>().updateService(true);
                          context
                              .read<BottomNavigationCubit>()
                              .changeBottomNavigationIndex(index);
                        } else {
                          context
                              .push("/${LocationPermissionDeniedScreen.route}");
                        }
                      });
                    } else {
                      context.handleException("You have not been assigned any routes");
                    }
                  } else {
                    context
                        .read<BottomNavigationCubit>()
                        .changeBottomNavigationIndex(index);
                  }
                }
              },
              items: const [
                BottomNavigationBarItem(
                    icon: Icon(
                      FontAwesomeIcons.map,
                    ),
                    label: "Nearby Bus"),
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
          ),
        );
      }),
    );
  }
}
