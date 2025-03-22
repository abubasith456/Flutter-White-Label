import 'package:demo_app/latest/app_config.dart';
import 'package:demo_app/latest/components/base/custom_dialog.dart';
import 'package:demo_app/latest/route/screen_export.dart';
import 'package:demo_app/latest/screens/forgot/components/bloc/forgot_bloc.dart';
import 'package:demo_app/latest/services/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:demo_app/latest/components/base/custom_button.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ForgotPasswordScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();

  ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<ForgotPasswordBloc>(),
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
                    "Forgot Password",
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Enter your email to reset your password",
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 30),
                  _buildTextField(emailController, Icons.email, "Email"),
                  const SizedBox(height: 20),
                  BlocConsumer<ForgotPasswordBloc, ForgotPasswordState>(
                    listener: (context, state) {
                      if (state is ForgotPasswordSuccess) {
                        sl<DialogService>().showSuccessDialog(
                          context,
                          "A reset link has been sent to your email.",
                        );
                        Navigator.pushNamed(context, logInScreenRoute);
                      } else if (state is ForgotPasswordFailure) {
                        sl<DialogService>().showErrorDialog(
                          context,
                          state.errorMessage,
                        );
                      }
                    },
                    builder: (context, state) {
                      return CustomButton(
                        text:
                            state is ForgotPasswordLoading
                                ? "Sending Reset Link..."
                                : "Send Reset Link",
                        onPressed: () {
                          context.read<ForgotPasswordBloc>().add(
                            ForgotPasswordSubmitted(emailController.text),
                          );
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: GestureDetector(
                      onTap:
                          () => Navigator.pushNamedAndRemoveUntil(
                            context,
                            logInScreenRoute,
                            (Route<dynamic> route) => false,
                          ),
                      child: Text(
                        "Remembered your password? Sign In",
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
    String hintText,
  ) {
    return TextField(
      controller: controller,
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
}
