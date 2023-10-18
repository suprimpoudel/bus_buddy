import 'dart:ui';

import 'package:bus_buddy_driver/features/data_source/app_theme/app_theme_cubit.dart';
import 'package:bus_buddy_driver/features/data_source/app_theme/app_theme_state.dart';
import 'package:bus_buddy_driver/features/data_source/home_screen/bottom_navigation_cubit.dart';
import 'package:bus_buddy_driver/features/data_source/location_tracking/location_tracking_cubit.dart';
import 'package:bus_buddy_driver/features/data_source/location_tracking/location_tracking_service_cubit.dart';
import 'package:bus_buddy_driver/features/data_source/location_tracking/tracking_cubit.dart';
import 'package:bus_buddy_driver/features/data_source/login/login_cubit.dart';
import 'package:bus_buddy_driver/features/data_source/login/login_repository.dart';
import 'package:bus_buddy_driver/features/data_source/user/user_cubit.dart';
import 'package:bus_buddy_driver/features/feature_change_password/presentation/change_password_screen.dart';
import 'package:bus_buddy_driver/features/feature_dashboard/data_source/dashboard_cubit.dart';
import 'package:bus_buddy_driver/features/feature_dashboard/data_source/dashboard_repository.dart';
import 'package:bus_buddy_driver/features/feature_home/presentation/home_screen.dart';
import 'package:bus_buddy_driver/features/feature_login/presentation/login_screen.dart';
import 'package:bus_buddy_driver/features/feature_splash/presentation/splash_screen.dart';
import 'package:bus_buddy_driver/features/feature_update_profile/presentation/update_profile_screen.dart';
import 'package:bus_buddy_driver/features/model/user.dart';
import 'package:bus_buddy_driver/features/presentation/location_permission_denied_screen.dart';
import 'package:bus_buddy_driver/features/repository/location_tracking/location_tracking_repository_impl.dart';
import 'package:bus_buddy_driver/features/repository/user/user_repository_impl.dart';
import 'package:bus_buddy_driver/firebase_options.dart';
import 'package:bus_buddy_driver/network/base_service.dart';
import 'package:bus_buddy_driver/utils/constants/preference_constants.dart';
import 'package:bus_buddy_driver/utils/enum/app_theme_enum.dart';
import 'package:bus_buddy_driver/utils/helper/logger.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var baseService = BaseService();
  DatabaseReference? databaseReference;
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    databaseReference = FirebaseDatabase.instance.ref();
    FlutterError.onError = (errorDetails) {
      FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
    };
    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };
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
        create: (_) => LoginCubit(
          LoginRepository(baseService, sharedPreference),
        ),
      ),
      RepositoryProvider(
        create: (_) => DashboardCubit(
          DashboardRepository(baseService, sharedPreference),
        ),
      ),
      RepositoryProvider(
        create: (_) => UserCubit(
          UserRepositoryImpl(sharedPreference, baseService),
        ),
      ),
      RepositoryProvider(
        create: (_) => BottomNavigationCubit(),
      ),
      RepositoryProvider(
        create: (_) => TrackingCubit(),
      ),
      RepositoryProvider(
        create: (_) =>
            LoginCubit(LoginRepository(baseService, sharedPreference)),
      ),
      RepositoryProvider(
        create: (_) => LocationTrackingServiceCubit(),
      ),
      if (databaseReference != null)
        RepositoryProvider(
          create: (_) => LocationTrackingCubit(LocationTrackingRepositoryImpl(
              databaseReference!, sharedPreference)),
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
          path: HomeScreen.route,
          builder: (BuildContext context, GoRouterState state) {
            return const HomeScreen();
          },
        ),
        GoRoute(
          path: LocationPermissionDeniedScreen.route,
          builder: (BuildContext context, GoRouterState state) {
            return const LocationPermissionDeniedScreen();
          },
        ),
        GoRoute(
          path: ChangePasswordScreen.route,
          builder: (BuildContext context, GoRouterState state) {
            return const ChangePasswordScreen();
          },
        ),
        GoRoute(
          path: UpdateProfileScreen.route,
          builder: (BuildContext context, GoRouterState state) {
            User user = state.extra as User;
            return UpdateProfileScreen(
              user: user,
            );
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
