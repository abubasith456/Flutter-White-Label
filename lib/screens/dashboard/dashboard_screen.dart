import 'package:demo_app/app_config.dart';
import 'package:demo_app/screens/dashboard/components/bloc/dashboard_bloc.dart';
import 'package:demo_app/screens/home/home_screen.dart';
import 'package:demo_app/screens/profile/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DashboardBloc(),
      child: BlocBuilder<DashboardBloc, DashboardState>(
        builder: (context, state) {
          return Scaffold(
            body: IndexedStack(
              index: state.currentIndex,
              children: const [HomeScreen(), ProfileScreen()],
            ),
            bottomNavigationBar: _AppBottomNav(context, state.currentIndex),
          );
        },
      ),
    );
  }

  Widget _AppBottomNav(BuildContext ctx, int currentIndex) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      type: BottomNavigationBarType.fixed,
      backgroundColor: AppConfig.backgroundColor,
      selectedItemColor: AppConfig.primaryColor,
      unselectedItemColor: Colors.grey[600],
      showUnselectedLabels: false,
      elevation: 8,
      onTap: (index) => ctx.read<DashboardBloc>().add(UpdateTab(index)),
      items: [
        BottomNavigationBarItem(
          icon: SvgPicture.asset(
            'assets/icons/hut-icon.svg',
            height: 24,
            colorFilter: ColorFilter.mode(
              currentIndex == 0 ? AppConfig.primaryColor : Colors.grey[600]!,
              BlendMode.srcIn,
            ),
          ),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: SvgPicture.asset(
            'assets/icons/corporate-user-icon.svg',
            height: 24,
            colorFilter: ColorFilter.mode(
              currentIndex == 1 ? AppConfig.primaryColor : Colors.grey[600]!,
              BlendMode.srcIn,
            ),
          ),
          label: 'Profile',
        ),
      ],
    );
  }
}
