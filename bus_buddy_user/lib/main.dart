import 'dart:ui';

import 'package:bus_buddy_user/features/data_source/app_theme/app_theme_cubit.dart';
import 'package:bus_buddy_user/features/data_source/app_theme/app_theme_state.dart';
import 'package:bus_buddy_user/features/data_source/home_screen/bottom_navigation_cubit.dart';
import 'package:bus_buddy_user/features/data_source/location/live_location_cubit.dart';
import 'package:bus_buddy_user/features/data_source/login/login_cubit.dart';
import 'package:bus_buddy_user/features/data_source/login/login_repository.dart';
import 'package:bus_buddy_user/features/data_source/nearby_bus/nearby_bus_cubit.dart';
import 'package:bus_buddy_user/features/data_source/nearby_bus/nearby_bus_repository.dart';
import 'package:bus_buddy_user/features/data_source/place/place_cubit.dart';
import 'package:bus_buddy_user/features/data_source/place/place_repository.dart';
import 'package:bus_buddy_user/features/data_source/route/route_cubit.dart';
import 'package:bus_buddy_user/features/data_source/route/route_repository.dart';
import 'package:bus_buddy_user/features/data_source/route_assessment/route_assessment_cubit.dart';
import 'package:bus_buddy_user/features/data_source/route_assessment/route_assessment_repository.dart';
import 'package:bus_buddy_user/features/data_source/stop/stop_cubit.dart';
import 'package:bus_buddy_user/features/data_source/stop/stop_repository.dart';
import 'package:bus_buddy_user/features/data_source/user/user_cubit.dart';
import 'package:bus_buddy_user/features/data_source/user/user_repository.dart';
import 'package:bus_buddy_user/features/model/nearby_bus_request.dart';
import 'package:bus_buddy_user/features/model/route.dart';
import 'package:bus_buddy_user/features/model/user.dart';
import 'package:bus_buddy_user/features/ui/screens/all_route/all_route_screen.dart';
import 'package:bus_buddy_user/features/ui/screens/all_stops/all_stops_screen.dart';
import 'package:bus_buddy_user/features/ui/screens/change_password/change_password_screen.dart';
import 'package:bus_buddy_user/features/ui/screens/home/home_screen.dart';
import 'package:bus_buddy_user/features/ui/screens/login/login_screen.dart';
import 'package:bus_buddy_user/features/ui/screens/searched_route_screen/searched_route_screen.dart';
import 'package:bus_buddy_user/features/ui/screens/shared/location_permission_denied_screen.dart';
import 'package:bus_buddy_user/features/ui/screens/splash/splash_screen.dart';
import 'package:bus_buddy_user/features/ui/screens/update_profile/update_profile_screen.dart';
import 'package:bus_buddy_user/firebase_options.dart';
import 'package:bus_buddy_user/network/base_service.dart';
import 'package:bus_buddy_user/utils/constants/preference_constants.dart';
import 'package:bus_buddy_user/utils/enum/app_theme_enum.dart';
import 'package:bus_buddy_user/utils/helper/firebase_api.dart';
import 'package:bus_buddy_user/utils/helper/logger.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'features/ui/screens/all_nearby_vehicles/all_nearby_vehicles.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  var baseService = BaseService();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    FlutterError.onError = (errorDetails) {
      FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
    };
    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };
    await FirebaseApi().initNotifications();
  } catch (e) {
    Logging.log(e);
  }

  var sharedPreference = await SharedPreferences.getInstance();

  String appThemeString =
      sharedPreference.getString(appTheme) ?? AppThemeEnum.themeLight.name;
  runApp(
    MultiRepositoryProvider(providers: [
      RepositoryProvider(
        create: (_) => AppThemeCubit(
            getAppThemeStateFromValue(appThemeString), sharedPreference),
      ),
      RepositoryProvider(
        create: (_) => BottomNavigationCubit(),
      ),
      RepositoryProvider(
        create: (_) => LiveLocationCubit(),
      ),
      RepositoryProvider(
        create: (_) => UserCubit(UserRepository(sharedPreference, baseService)),
      ),
      RepositoryProvider(
        create: (_) => PlaceCubit(PlaceRepository(baseService)),
      ),
      RepositoryProvider(
        create: (_) => RouteCubit(RouteRepository(baseService)),
      ),
      RepositoryProvider(
        create: (_) => StopCubit(StopRepository(baseService)),
      ),
      RepositoryProvider(
        create: (_) => StopCubit(StopRepository(baseService)),
      ),
      RepositoryProvider(
        create: (_) =>
            RouteAssessmentCubit(RouteAssessmentRepository(baseService)),
      ),
      RepositoryProvider(
        create: (_) => NearbyBusCubit(NearbyBusRepository(baseService)),
      ),
      RepositoryProvider(
        create: (_) =>
            LoginCubit(LoginRepository(baseService, sharedPreference)),
      ),
    ], child: const MyApp()),
  );
}

final GoRouter _router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: "/",
      builder: (BuildContext context, GoRouterState state) {
        return const SplashScreen();
      },
      routes: <RouteBase>[
        GoRoute(
          path: LoginScreen.routeName,
          builder: (BuildContext context, GoRouterState state) {
            return const LoginScreen();
          },
        ),
        GoRoute(
          path: SearchedRouteScreen.routeName,
          builder: (BuildContext context, GoRouterState state) {
            Map<String, String> args = state.extra as Map<String, String>;
            return SearchedRouteScreen(
              placeOneId: args['placeOne'],
              placeTwoId: args['placeTwo'],
            );
          },
        ),
        GoRoute(
          path: HomeScreen.routeName,
          builder: (BuildContext context, GoRouterState state) {
            return const HomeScreen();
          },
        ),
        GoRoute(
          path: LocationPermissionDeniedScreen.routeName,
          builder: (BuildContext context, GoRouterState state) {
            return const LocationPermissionDeniedScreen();
          },
        ),
        GoRoute(
          path: UpdateProfileScreen.routeName,
          builder: (BuildContext context, GoRouterState state) {
            User user = state.extra as User;

            return UpdateProfileScreen(
              user: user,
            );
          },
        ),
        GoRoute(
          path: AllRouteScreen.routeName,
          builder: (BuildContext context, GoRouterState state) {
            List<RouteModel> routes = state.extra as List<RouteModel>;

            return AllRouteScreen(
              routes: routes,
            );
          },
        ),
        GoRoute(
          path: AllNearbyVehicles.routeName,
          builder: (BuildContext context, GoRouterState state) {
            NearbyBusRequest nearbyRequest = state.extra as NearbyBusRequest;

            return AllNearbyVehicles(
              nearbyBusRequest: nearbyRequest,
            );
          },
        ),
        GoRoute(
          path: AllStopsScreen.routeName,
          builder: (BuildContext context, GoRouterState state) {
            int? routeId = state.extra as int?;

            return AllStopsScreen(
              routeId: routeId,
            );
          },
        ),
        GoRoute(
          path: ChangePasswordScreen.routeName,
          builder: (BuildContext context, GoRouterState state) {
            return const ChangePasswordScreen();
          },
        ),
      ],
    ),
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppThemeCubit, AppThemeState>(builder: (context, state) {
      return MaterialApp.router(
        title: 'Bus Buddy User',
        debugShowCheckedModeBanner: false,
        theme: state is ThemeLight
            ? ThemeData(
                colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
                useMaterial3: true,
              )
            : ThemeData.dark().copyWith(
                useMaterial3: true,
                colorScheme: ColorScheme.fromSeed(
                    error: Colors.orangeAccent.shade100,
                    seedColor: Colors.blue,
                    brightness: Brightness.dark),
              ),
        routerConfig: _router,
      );
    });
  }
}
