import 'package:bus_buddy_user/features/data_source/user/user_cubit.dart';
import 'package:bus_buddy_user/features/data_source/user/user_state.dart';
import 'package:bus_buddy_user/features/model/user.dart';
import 'package:bus_buddy_user/features/ui/screens/update_profile/update_profile_screen.dart';
import 'package:bus_buddy_user/utils/extensions/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class UserDetailsWidget extends StatefulWidget {
  const UserDetailsWidget({super.key});

  @override
  State<UserDetailsWidget> createState() => _UserDetailsWidgetState();
}

class _UserDetailsWidgetState extends State<UserDetailsWidget> {
  @override
  void initState() {
    context.read<UserCubit>().getUserById();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var user = User();
    return BlocConsumer<UserCubit, UserState>(listener: (context, state) {
      if (mounted) {
        if (state is UserErrorState) {
          context.handleException(state.error);
        } else if (state is UserSelectState) {
          user = state.user;
        } else if (state is UserAddUpdateState && state.isUpdate) {
          user = state.user;
        }
      }
    }, builder: (context, state) {
      return state is UserIdleState && user.id == null
          ? const SizedBox()
          : Card(
              child: state is UserLoadingState && !state.isInnerLoading
                  ? const Padding(
                      padding: EdgeInsets.all(32.0),
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          const CircleAvatar(
                            radius: 60.0,
                            child: Icon(
                              FontAwesomeIcons.user,
                            ),
                          ),
                          const SizedBox(
                            width: 10.0,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${user.firstName} ${user.lastName}",
                                  style: GoogleFonts.lato().copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18.0,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(
                                  height: 8.0,
                                ),
                                Text(
                                  "${user.email}",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.lato(),
                                ),
                                const SizedBox(
                                  height: 8.0,
                                ),
                                Text(
                                  "+977-${user.phoneNumber}",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.lato(),
                                ),
                                const SizedBox(
                                  height: 8.0,
                                ),
                                const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.check_circle,
                                      color: Colors.green,
                                    ),
                                    SizedBox(
                                      width: 5.0,
                                    ),
                                    Expanded(
                                      child: Text(
                                        "Verified",
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            tooltip: "Edit Profile",
                            onPressed: () {
                              context.push("/${UpdateProfileScreen.routeName}",
                                  extra: user);
                            },
                            icon: const Icon(
                              Icons.edit,
                            ),
                          ),
                        ],
                      ),
                    ),
            );
    });
  }
}
