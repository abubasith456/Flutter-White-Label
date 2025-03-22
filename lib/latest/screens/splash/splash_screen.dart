import 'package:demo_app/latest/components/base_bloc/profile_bloc.dart';
import 'package:demo_app/latest/route/route_constants.dart';
import 'package:demo_app/latest/screens/splash/components/bloc/splash_bloc.dart';
import 'package:demo_app/latest/services/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AnimatedSplashScreen extends StatefulWidget {
  const AnimatedSplashScreen({super.key});

  @override
  _AnimatedSplashScreenState createState() => _AnimatedSplashScreenState();
}

class _AnimatedSplashScreenState extends State<AnimatedSplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    // Initialize the animation controller
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    // Fade-in animation
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (_) =>
              sl<SplashBloc>()..add(
                SplashStarted(),
              ), // Ensure SplashBloc is properly provided
      child: BlocConsumer<SplashBloc, SplashState>(
        listener: (context, state) {
          if (state is NavigateToOnBoard) {
            Navigator.pushNamedAndRemoveUntil(
              context,
              onbordingScreenRoute,
              (Route<dynamic> route) => false,
            );
          } else if (state is NavigateToDashBoard) {
            context.read<ProfileBloc>().add(
              LoadProfile(userId: state.activatedUser.id),
            );
            Navigator.pushNamedAndRemoveUntil(
              context,
              dashboardScreenRoute,
              (Route<dynamic> route) => false,
            );
          } else {
            Navigator.pushNamedAndRemoveUntil(
              context,
              logInScreenRoute,
              (Route<dynamic> route) => false,
            );
          }
        },
        builder: (context, state) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: FadeTransition(
                  opacity: _animation,
                  child: SvgPicture.asset(
                    "assets/logo/Shoplon.svg",
                    width: 50,
                    height: 50,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
