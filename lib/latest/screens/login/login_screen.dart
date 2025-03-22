import 'package:demo_app/latest/app_config.dart';
import 'package:demo_app/latest/components/base/custom_dialog.dart';
import 'package:demo_app/latest/components/base_bloc/profile_bloc.dart';
import 'package:demo_app/latest/route/screen_export.dart';
import 'package:demo_app/latest/screens/login/components/bloc/login_bloc.dart';
import 'package:demo_app/latest/services/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:demo_app/latest/components/base/custom_button.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<LoginBloc>(),
      child: Scaffold(
        body: SafeArea(
          // Add SafeArea to avoid system UI overlap
          child: SingleChildScrollView(
            // Wrap only the scrollable content
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: SvgPicture.asset(
                      "assets/logo/Shoplon.svg",
                      height: 40,
                    ),
                  ),
                  const SizedBox(height: 40),
                  Text(
                    "Welcome Back!",
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Sign in to continue",
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 30),
                  _buildTextField(emailController, Icons.email, "Email"),
                  const SizedBox(height: 20),
                  _buildTextField(
                    passwordController,
                    Icons.lock,
                    "Password",
                    isPassword: true,
                  ),
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, forgotPassRoute);
                      },
                      child: Text(
                        "Forgot Password?",
                        style: TextStyle(color: AppConfig.primaryButtonColor),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  BlocConsumer<LoginBloc, LoginState>(
                    listener: (context, state) {
                      if (state is LoginSuccess) {
                        final userId =
                            state.user.id; // Assuming User has an 'id' field
                        context.read<ProfileBloc>().add(
                          LoadProfile(userId: userId),
                        );
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          dashboardScreenRoute,
                          (Route<dynamic> route) => false,
                        );
                      } else if (state is LoginFailure) {
                        sl<DialogService>().showErrorDialog(
                          context,
                          state.errorMessage,
                        );
                      }
                    },
                    builder: (context, state) {
                      return CustomButton(
                        text:
                            state is LoginLoading ? "Signing In..." : "Sign In",
                        onPressed: () {
                          context.read<LoginBloc>().add(
                            LoginSubmitted(
                              emailController.text,
                              passwordController.text,
                            ),
                          );
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  Center(child: Text("or continue with")),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildSocialButton("assets/icons/twitter.svg"),
                      const SizedBox(width: 20),
                      _buildSocialButton("assets/icons/Facebook.svg"),
                    ],
                  ),
                  const SizedBox(height: 30),
                  Center(
                    child: GestureDetector(
                      onTap:
                          () => Navigator.pushNamed(context, signUpScreenRoute),
                      child: Text(
                        "Don't have an account? Sign Up",
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    IconData icon,
    String hintText, {
    bool isPassword = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(
        prefixIcon: Icon(icon),
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: AppConfig.primaryButtonColor),
        ),
      ),
    );
  }

  Widget _buildSocialButton(String asset) {
    return InkWell(onTap: () {}, child: SvgPicture.asset(asset, height: 40));
  }
}
