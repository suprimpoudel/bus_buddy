import 'package:bus_buddy_user/features/data_source/app_theme/app_theme_cubit.dart';
import 'package:bus_buddy_user/features/data_source/app_theme/app_theme_state.dart';
import 'package:bus_buddy_user/features/ui/screens/change_password/change_password_screen.dart';
import 'package:bus_buddy_user/features/ui/screens/home/widgets/nearby_bus_widget.dart';
import 'package:bus_buddy_user/features/ui/screens/home/widgets/user_details_widget.dart';
import 'package:bus_buddy_user/features/ui/screens/login/login_screen.dart';
import 'package:bus_buddy_user/utils/constants/preference_constants.dart';
import 'package:bus_buddy_user/utils/enum/app_theme_enum.dart';
import 'package:bus_buddy_user/utils/extensions/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:package_info_plus/package_info_plus.dart';
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
                      context.push("/${ChangePasswordScreen.routeName}");
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
                  // FutureBuilder(
                  //     future: SharedPreferences.getInstance(),
                  //     builder: (context, snapshot) {
                  //       return ListTile(
                  //         leading: const Icon(FontAwesomeIcons.bell),
                  //         title: const Text("Push Notifications"),
                  //         trailing: Switch(
                  //           value: snapshot.data
                  //               ?.getBool(pushNotificationEnabled) ??
                  //               false,
                  //           onChanged: (value) async {
                  //             await snapshot.data
                  //                 ?.setBool(pushNotificationEnabled, value)
                  //                 .then((value) {
                  //               setState(() {});
                  //             });
                  //           },
                  //         ),
                  //       );
                  //     }),
                  const NearbyBusRadiusWidget(),
                  FutureBuilder(
                      future: PackageInfo.fromPlatform(),
                      builder: (context, snapshot) {
                        return ListTile(
                          leading: const Icon(FontAwesomeIcons.circleInfo),
                          title: Text("View ${snapshot.data?.appName} Info"),
                          onTap: () async {
                            return await showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text("Info"),
                                content: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                        "App Version: ${snapshot.data?.version}"),
                                    const SizedBox(
                                      height: 8.0,
                                    ),
                                    Text(
                                        "Build Version: ${snapshot.data?.buildNumber}"),
                                    const SizedBox(
                                      height: 8.0,
                                    ),
                                    RichText(
                                      text: TextSpan(
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium,
                                        children: [
                                          const TextSpan(text: "Built By: \t"),
                                          TextSpan(
                                            text: "Suprim Poudel",
                                            style: GoogleFonts.lato().copyWith(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      context.pop();
                                    },
                                    child: const Text("OK"),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      }),
                ],
              ),
            ),
            Card(
              child: InkWell(
                onTap: () async {
                  return await showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text("Logout"),
                        content: const Text("Are you sure you want to logout"),
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
                  ).then((value) async {
                    if (value != null) {
                      if (value is bool && value) {
                        await SharedPreferences.getInstance().then((value) {
                          value.remove(token);
                          value.remove(userId);
                          value.remove(firstName);
                          value.remove(lastName);
                        }).then((value) {
                          context.displaySnackbar("Successfully logged out");
                          while (context.canPop()) {
                            context.pop();
                          }
                          context.pushReplacement("/${LoginScreen.routeName}");
                        });
                      }
                    }
                  });
                },
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {},
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
            ),
          ],
        ),
      ),
    );
  }
}
