import 'package:bus_buddy_driver/features/data_source/app_theme/app_theme_cubit.dart';
import 'package:bus_buddy_driver/features/data_source/app_theme/app_theme_state.dart';
import 'package:bus_buddy_driver/features/data_source/user/user_cubit.dart';
import 'package:bus_buddy_driver/features/data_source/user/user_state.dart';
import 'package:bus_buddy_driver/features/feature_change_password/presentation/change_password_screen.dart';
import 'package:bus_buddy_driver/features/feature_home/presentation/widgets/user_details_widget.dart';
import 'package:bus_buddy_driver/features/feature_login/presentation/login_screen.dart';
import 'package:bus_buddy_driver/utils/constants/preference_constants.dart';
import 'package:bus_buddy_driver/utils/enum/app_theme_enum.dart';
import 'package:bus_buddy_driver/utils/extension/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsItem extends StatefulWidget {
  const SettingsItem({super.key});

  @override
  State<SettingsItem> createState() => _SettingsItemState();
}

class _SettingsItemState extends State<SettingsItem> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  const UserDetailsWidget(),
                  ListTile(
                    title: const Text("Change Password"),
                    leading: const Icon(FontAwesomeIcons.key),
                    onTap: () {
                      context.push("/${ChangePasswordScreen.route}");
                    },
                  ),
                  BlocBuilder<AppThemeCubit, AppThemeState>(
                      builder: (context, state) {
                    return ListTile(
                      leading: state is ThemeLight
                          ? const Icon(FontAwesomeIcons.sun)
                          : const Icon(FontAwesomeIcons.moon),
                      title: const Text("Dark Theme"),
                      trailing: Switch(
                        value: state is ThemeDark,
                        onChanged: (value) async {
                          context.read<AppThemeCubit>().changeAppTheme(value
                              ? AppThemeEnum.themeDark
                              : AppThemeEnum.themeLight);
                        },
                      ),
                    );
                  }),
                  FutureBuilder(
                      future: SharedPreferences.getInstance(),
                      builder: (context, snapshot) {
                        return ListTile(
                          leading: const Icon(FontAwesomeIcons.bell),
                          title: const Text("Push Notifications"),
                          trailing: Switch(
                            value: snapshot.data
                                    ?.getBool(pushNotificationEnabled) ??
                                false,
                            onChanged: (value) async {
                              await snapshot.data
                                  ?.setBool(pushNotificationEnabled, value)
                                  .then((value) {
                                setState(() {});
                              });
                            },
                          ),
                        );
                      }),
                ],
              ),
            ),
            BlocConsumer<UserCubit, UserState>(listener: (context, state) {
              if (mounted) {
                if (state is UserLogoutState) {
                  context.displaySnackbar("Successfully logged out");
                  while (context.canPop()) {
                    context.pop();
                  }
                  context.pushReplacement("/${LoginScreen.routeName}");
                }
              }
            }, builder: (context, state) {
              return Card(
                child: InkWell(
                  onTap: () async {
                    return await showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text("Logout"),
                          content:
                              const Text("Are you sure you want to logout"),
                          actions: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton(
                                  onPressed: () {
                                    context.pop(false);
                                  },
                                  child: const Text(
                                    "Cancel",
                                    style: TextStyle(
                                      color: Colors.red,
                                    ),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    context.pop(true);
                                  },
                                  child: const Text(
                                    "Yes",
                                    style: TextStyle(
                                      color: Colors.green,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ],
                        );
                      },
                    ).then((value) {
                      if (value != null) {
                        if (value is bool && value) {
                          context.read<UserCubit>().logoutUser();
                        }
                      }
                    });
                  },
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          context.read<UserCubit>().logoutUser();
                        },
                        icon: const Icon(
                          FontAwesomeIcons.rightFromBracket,
                        ),
                        tooltip: "Logout",
                      ),
                      Expanded(
                        child: Text(
                          "Logout",
                          style: GoogleFonts.lato().copyWith(
                            fontSize: 16.0,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
