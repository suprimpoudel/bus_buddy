import 'package:bus_buddy_user/features/data_source/login/login_cubit.dart';
import 'package:bus_buddy_user/features/data_source/login/login_state.dart';
import 'package:bus_buddy_user/features/ui/screens/home/home_screen.dart';
import 'package:bus_buddy_user/features/ui/screens/home/widgets/loading_widget.dart';
import 'package:bus_buddy_user/utils/extensions/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = "login";
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _confirmPasswordObscureText = true;

  @override
  void dispose() {
    super.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: null,
      body: BlocConsumer<LoginCubit, LoginState>(listener: (context, state) {
        if (state is LoginErrorState) {
          if (mounted) {
            context.handleException(state.error);
          }
        } else if (state is LoginSuccessState) {
          if (mounted) {
            context.pushReplacement("/${HomeScreen.routeName}");
          }
        }
      }, builder: (context, state) {
        return SafeArea(
          child: Stack(
            children: [
              Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: AutofillGroup(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(
                            height: 32,
                          ),
                          Center(
                            child: SizedBox(
                              width: width * 0.3,
                              child: Image.asset(
                                "assets/images/app_icon.png",
                                errorBuilder: (context, object, stack) {
                                  return const SizedBox();
                                },
                              ),
                            ),
                          ),
                          Text(
                            "Login",
                            style: GoogleFonts.lato().copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                            height: 24,
                          ),
                          TextFormField(
                            textInputAction: TextInputAction.next,
                            controller: _usernameController,
                            autofillHints: const [
                              AutofillHints.username,
                            ],
                            decoration: const InputDecoration(
                              hintText: "Enter email",
                              label: Text("Email"),
                              prefixIcon: Icon(
                                Icons.alternate_email_outlined,
                              ),
                              filled: true,
                              border: OutlineInputBorder(),
                            ),
                            validator: (valueNull) {
                              var value = (valueNull ?? "").trim();
                              if (value.isEmpty) {
                                return "Username is required";
                              } else {
                                return null;
                              }
                            },
                          ),
                          const SizedBox(
                            height: 15.0,
                          ),
                          TextFormField(
                            autofillHints: const [
                              AutofillHints.password,
                            ],
                            controller: _passwordController,
                            textInputAction: TextInputAction.go,
                            onFieldSubmitted: (value) async {
                              await _loginUser();
                            },
                            decoration: InputDecoration(
                              prefixIcon: const Icon(
                                Icons.lock,
                              ),
                              hintText: "Enter password",
                              filled: true,
                              border: OutlineInputBorder(),
                              suffixIcon: IconButton(
                                onPressed: () {
                                  if (mounted) {
                                    setState(() {
                                      _confirmPasswordObscureText =
                                          !_confirmPasswordObscureText;
                                    });
                                  }
                                },
                                icon: Icon(
                                  _confirmPasswordObscureText
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                ),
                              ),
                            ),
                            keyboardType: TextInputType.visiblePassword,
                            obscureText: _confirmPasswordObscureText,
                            validator: (valueNull) {
                              var value = (valueNull ?? "").trim();
                              if (value.isEmpty) {
                                return "Password is required";
                              } else if (value.length < 6) {
                                return "Password must be at least 6 characters long";
                              } else {
                                return null;
                              }
                            },
                          ),
                          const SizedBox(
                            height: 15.0,
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: OutlinedButton(
                              child: const Text("Login"),
                              onPressed: () async {
                                await _loginUser();
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              state is LoginLoadingState
                  ? const Align(
                      alignment: Alignment.center,
                      child: LoadingWidget(),
                    )
                  : const SizedBox(),
            ],
          ),
        );
      }),
    );
  }

  Future<void> _loginUser() async {
    String username = _usernameController.text.trim();
    String password = _passwordController.text.trim();

    if (_formKey.currentState != null && _formKey.currentState!.validate()) {
      await _proceedToLogin(username: username, password: password);
    }
  }

  Future<void> _proceedToLogin({
    required String username,
    required String password,
  }) async {
    context.read<LoginCubit>().loginUser(username, password);
  }
}
