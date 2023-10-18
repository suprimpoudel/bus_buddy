import 'package:bus_buddy_user/features/ui/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

class ChangePasswordScreen extends StatefulWidget {
  static const String routeName = "changePassword";
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();

  bool _currentPasswordVisible = false;
  bool _newPasswordVisible = false;
  bool _confirmPasswordVisible = false;

  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Change Password"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                CustomTextField(
                  hint: "Enter current password",
                  controller: _oldPasswordController,
                  label: "Current Password",
                  validator: (nullValue) {
                    var value = (nullValue ?? "").trim();
                    if (value.isEmpty) {
                      return "Current password is required";
                    } else {
                      return null;
                    }
                  },
                  obscureText: !_currentPasswordVisible,
                  suffixIcon: IconButton(
                      onPressed: () {
                        _currentPasswordVisible = !_currentPasswordVisible;
                        setState(() {});
                      },
                      icon: !_currentPasswordVisible
                          ? const Icon(Icons.visibility)
                          : const Icon(Icons.visibility_off)),
                ),
                const SizedBox(
                  height: 15.0,
                ),
                CustomTextField(
                  hint: "Enter new password",
                  controller: _newPasswordController,
                  label: "New Password",
                  validator: (nullValue) {
                    var value = (nullValue ?? "").trim();
                    if (value.isEmpty) {
                      return "New password is required";
                    } else if (value.length < 6) {
                      return "New password must be at least 6 characters long";
                    } else {
                      return null;
                    }
                  },
                  obscureText: !_newPasswordVisible,
                  suffixIcon: IconButton(
                      onPressed: () {
                        _newPasswordVisible = !_newPasswordVisible;
                        setState(() {});
                      },
                      icon: !_newPasswordVisible
                          ? const Icon(Icons.visibility)
                          : const Icon(Icons.visibility_off)),
                ),
                const SizedBox(
                  height: 15.0,
                ),
                CustomTextField(
                  hint: "Confirm new password",
                  controller: _confirmPasswordController,
                  label: "Confirm Password",
                  validator: (nullValue) {
                    var value = (nullValue ?? "").trim();
                    var newPassword = _newPasswordController.text.trim();
                    if (newPassword.isNotEmpty && value.isNotEmpty) {
                      if (newPassword != value) {
                        return "New Password and Confirm Password doesn't match";
                      }
                    }
                    return null;
                  },
                  obscureText: !_confirmPasswordVisible,
                  suffixIcon: IconButton(
                      onPressed: () {
                        _confirmPasswordVisible = !_confirmPasswordVisible;
                        setState(() {});
                      },
                      icon: !_confirmPasswordVisible
                          ? const Icon(Icons.visibility)
                          : const Icon(Icons.visibility_off)),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          if (_formKey.currentState?.validate() == true) {
            context.pop();
          }
        },
        label: const Text("Update"),
        icon: const Icon(FontAwesomeIcons.floppyDisk),
      ),
    );
  }
}
