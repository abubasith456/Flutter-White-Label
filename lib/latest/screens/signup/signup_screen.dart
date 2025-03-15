import 'package:demo_app/latest/app_config.dart';
import 'package:demo_app/latest/screens/signup/components/bloc/signup_bloc.dart';
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
      create: (context) => SignupBloc(),
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: SvgPicture.asset("assets/logo/Shoplon.svg", height: 80),
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
              BlocBuilder<SignupBloc, SignupState>(
                builder: (context, state) {
                  return CustomButton(
                    text: state.isSubmitting ? "Signing Up..." : "Sign Up",
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
}
