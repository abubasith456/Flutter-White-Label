import 'package:demo_app/latest/app_config.dart';
import 'package:demo_app/latest/screens/dashboard/components/bloc/dashboard_bloc.dart';
import 'package:demo_app/latest/screens/home/home_screen.dart';
import 'package:demo_app/latest/screens/profile/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DashboardBloc(),
      child: BlocBuilder<DashboardBloc, DashboardState>(
        builder: (context, state) {
          return Scaffold(
            body: Stack(
              children: [
                IndexedStack(
                  index: state.currentIndex,
                  children: const [HomeScreen(), ProfileScreen()],
                ),
                Positioned(
                  bottom: 5,
                  left: 20,
                  right: 20,
                  child: _buildFloatingTabBar(context, state.currentIndex),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildFloatingTabBar(BuildContext context, int currentIndex) {
    return SafeArea(
      child: Container(
        height: 70,
        decoration: BoxDecoration(
          color: Color.alphaBlend(
            Colors.white.withAlpha(240), // Adjust transparency
            Colors.white,
          ),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(25),
              blurRadius: 15,
              spreadRadius: 2,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: BottomNavigationBar(
            currentIndex: currentIndex,
            onTap: (index) {
              context.read<DashboardBloc>().add(UpdateTab(index));
            },
            backgroundColor: Colors.transparent,
            selectedItemColor: Colors.blueAccent,
            unselectedItemColor: Colors.grey,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            elevation: 0,
            items: [
              _buildNavItem(
                "assets/icons/Message.svg",
                "Home",
                0,
                currentIndex,
              ),
              _buildNavItem(
                "assets/icons/Emoji.svg",
                "Profile",
                1,
                currentIndex,
              ),
            ],
          ),
        ),
      ),
    );
  }

  BottomNavigationBarItem _buildNavItem(
    String iconPath,
    String label,
    int index,
    int currentIndex,
  ) {
    return BottomNavigationBarItem(
      icon: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            iconPath,
            height: 30,
            colorFilter: ColorFilter.mode(
              index == currentIndex ? AppConfig.primaryColor : Colors.grey,
              BlendMode.srcIn,
            ),
          ),
        ],
      ),
      label: label,
    );
  }
}
