import 'package:bus_buddy_user/features/data_source/user/user_cubit.dart';
import 'package:bus_buddy_user/features/data_source/user/user_state.dart';
import 'package:bus_buddy_user/features/model/user.dart';
import 'package:bus_buddy_user/features/ui/widgets/custom_text_field.dart';
import 'package:bus_buddy_user/utils/extensions/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

class UpdateProfileScreen extends StatefulWidget {
  static const String routeName = "updateProfileScreen";
  final User user;

  const UpdateProfileScreen({super.key, required this.user});

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneNoController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  void initState() {
    _firstNameController.text = widget.user.firstName ?? "";
    _lastNameController.text = widget.user.lastName ?? "";
    _emailController.text = widget.user.email ?? "";
    _phoneNoController.text = widget.user.phoneNumber ?? "";
    super.initState();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneNoController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserCubit, UserState>(listener: (context, state) {
      if (mounted) {
        if (state is UserAddUpdateState) {
          context.displaySnackbar(
              "Successfully ${state.isUpdate ? "updated" : "created"} user");
          context.pop();
        }
      }
    }, builder: (context, state) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Update Profile"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: state is UserLoadingState
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Align(
                          alignment: Alignment.center,
                          child: CircleAvatar(
                            radius: 60.0,
                            child: Icon(
                              FontAwesomeIcons.user,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 25.0,
                        ),
                        CustomTextField(
                          controller: _firstNameController,
                          hint: "Enter first name",
                          label: "First Name",
                          keyboardType: TextInputType.name,
                          validator: (nullValue) {
                            var value = (nullValue ?? "").trim();
                            if (value.isEmpty) {
                              return "First name cannot be empty";
                            } else {
                              return null;
                            }
                          },
                        ),
                        const SizedBox(
                          height: 15.0,
                        ),
                        CustomTextField(
                          controller: _lastNameController,
                          hint: "Enter last name",
                          label: "Last Name",
                          keyboardType: TextInputType.name,
                          validator: (nullValue) {
                            var value = (nullValue ?? "").trim();
                            if (value.isEmpty) {
                              return "Last name cannot be empty";
                            } else {
                              return null;
                            }
                          },
                        ),
                        const SizedBox(
                          height: 15.0,
                        ),
                        CustomTextField(
                          controller: _phoneNoController,
                          hint: "Enter phone number",
                          label: "Phone Number",
                          keyboardType: TextInputType.phone,
                          prefix: const Text("+977-"),
                          validator: (nullValue) {
                            var value = (nullValue ?? "").trim();
                            if (value.isEmpty) {
                              return "Phone number cannot be empty";
                            } else {
                              return null;
                            }
                          },
                        ),
                        const SizedBox(
                          height: 15.0,
                        ),
                        CustomTextField(
                          controller: _emailController,
                          hint: "Enter email address",
                          label: "Email Address",
                          keyboardType: TextInputType.emailAddress,
                          validator: (nullValue) {
                            var value = (nullValue ?? "").trim();
                            if (value.isEmpty) {
                              return "Email cannot be empty";
                            } else {
                              return null;
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            if (_formKey.currentState?.validate() == true) {
              var user = User(
                id: widget.user.id,
                firstName: _firstNameController.text.trim(),
                lastName: _lastNameController.text.trim(),
                phoneNumber: _phoneNoController.text.trim(),
                email: _emailController.text.trim(),
              );
              context.read<UserCubit>().addUpdateUser(user);
            }
          },
          label: const Text("Update"),
          icon: const Icon(FontAwesomeIcons.floppyDisk),
        ),
      );
    });
  }
}
