import 'package:demo_app/latest/app_config.dart';
import 'package:demo_app/latest/components/base/custom_dialog.dart';
import 'package:demo_app/latest/components/base_bloc/profile_bloc.dart';
import 'package:demo_app/latest/route/screen_export.dart';
import 'package:demo_app/latest/screens/signup/components/bloc/signup_bloc.dart';
import 'package:demo_app/latest/services/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:demo_app/latest/components/base/custom_button.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SignupScreen extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController dobController = TextEditingController();

  SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<SignupBloc>(),
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
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
                    "Create an Account",
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Sign up to get started",
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 30),
                  _buildTextField(nameController, Icons.person, "Full Name"),
                  const SizedBox(height: 20),
                  _buildTextField(emailController, Icons.email, "Email"),
                  const SizedBox(height: 20),
                  _buildTextField(
                    passwordController,
                    Icons.lock,
                    "Password",
                    isPassword: true,
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(
                    dobController,
                    Icons.calendar_today,
                    "Date of Birth",
                  ),
                  const SizedBox(height: 20),
                  BlocConsumer<SignupBloc, SignupState>(
                    listener: (context, state) {
                      if (state is SignupSuccess) {
                        final userId =
                            state.user.id; // Assuming User has an 'id' field
                        context.read<ProfileBloc>().add(
                          LoadProfile(userId: userId),
                        );
                        Navigator.pushNamed(context, dashboardScreenRoute);
                      } else if (state is SignupFailure) {
                        print("Signup Result => ${state.errorMessage}");
                        sl<DialogService>().showErrorDialog(
                          context,
                          state.errorMessage,
                        );
                      }
                    },
                    builder: (context, state) {
                      // Show error messages from state if any
                      if (state is SignupFieldError) {
                        return Column(
                          children: [
                            Text(
                              state.errorMessage,
                              style: TextStyle(color: Colors.red),
                            ),
                            const SizedBox(height: 20),
                            _buildSignupButton(context, state),
                          ],
                        );
                      } else if (state is SignupLoading) {
                        return _buildSignupButton(context, state);
                      } else {
                        return _buildSignupButton(context, state);
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Text(
                        "Already have an account? Sign In",
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

  Widget _buildSignupButton(BuildContext context, SignupState state) {
    return CustomButton(
      text: state is SignupLoading ? "Signing Up..." : "Sign Up",
      onPressed: () {
        context.read<SignupBloc>().add(
          SignupSubmitted(
            nameController.text,
            emailController.text,
            passwordController.text,
            dobController.text,
          ),
        );
      },
    );
  }
}
