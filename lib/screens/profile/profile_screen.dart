import 'dart:io';
import 'package:demo_app/app_config.dart';
import 'package:demo_app/components/base/custom_alert_dialog.dart';
import 'package:demo_app/components/base/custom_dialog.dart';
import 'package:demo_app/components/base_bloc/profile_bloc.dart';
import 'package:demo_app/route/screen_export.dart';
import 'package:demo_app/screens/profile/components/profile_screen_shimmer.dart';
import 'package:demo_app/services/service_locator.dart';
import 'package:demo_app/utils/status_bar_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    StatusBarManager.setLightStatusBar();
  }

  @override
  void dispose() {
    StatusBarManager.resetToDefault();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width > 1024;
    final isTablet = size.width > 768 && size.width <= 1024;
    final isMobile = size.width <= 768;

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: BlocConsumer<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is LogoutSuccess) {
            Navigator.pushNamedAndRemoveUntil(
              context,
              logInScreenRoute,
              (Route<dynamic> route) => false,
            );
          } else if (state is ProfileLoaded) {
            print("state is ProfileLoaded called profile");
          }
        },
        builder: (context, state) {
          if (state is ProfileLoading) {
            return const ProfileScreenShimmer();
          } else if (state is ProfileLoaded) {
            return _buildResponsiveLayout(
              context,
              state,
              isDesktop,
              isTablet,
              isMobile,
            );
          } else {
            return _buildErrorState(context);
          }
        },
      ),
    );
  }

  Widget _buildResponsiveLayout(
    BuildContext context,
    ProfileLoaded state,
    bool isDesktop,
    bool isTablet,
    bool isMobile,
  ) {
    if (isDesktop) {
      return _buildDesktopLayout(context, state);
    } else if (isTablet) {
      return _buildTabletLayout(context, state);
    } else {
      return _buildMobileLayout(context, state);
    }
  }

  Widget _buildDesktopLayout(BuildContext context, ProfileLoaded state) {
    return SafeArea(
      child: Row(
        children: [
          // Left sidebar with profile info
          Container(
            width: 350,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppConfig.primaryColor.withOpacity(0.1), Colors.white],
              ),
            ),
            child: Column(
              children: [
                const SizedBox(height: 40),
                _buildModernProfileHeader(
                  state.user.name,
                  state.user.profilePic,
                  true,
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
          // Right content area
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(40),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 600),
                  child: _buildOptionsList(context, true),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabletLayout(BuildContext context, ProfileLoaded state) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
          child: Column(
            children: [
              _buildModernProfileHeader(
                state.user.name,
                state.user.profilePic,
                false,
              ),
              const SizedBox(height: 40),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 500),
                child: _buildOptionsList(context, false),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context, ProfileLoaded state) {
    return SafeArea(
      child: Column(
        children: [
          _buildModernProfileHeader(
            state.user.name,
            state.user.profilePic,
            false,
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  _buildOptionsList(context, false),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModernProfileHeader(
    String username,
    String profilePicUrl,
    bool isDesktop,
  ) {
    return Container(
      padding: EdgeInsets.all(isDesktop ? 30 : 25),
      margin: EdgeInsets.all(isDesktop ? 0 : 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(isDesktop ? 0 : 25),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppConfig.primaryColor.withOpacity(0.1),
            Colors.white.withOpacity(0.9),
          ],
        ),
        boxShadow:
            isDesktop
                ? []
                : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
      ),
      child: Column(
        children: [
          _buildAnimatedProfilePicture(profilePicUrl, isDesktop),
          SizedBox(height: isDesktop ? 25 : 20),
          Text(
            username,
            style: TextStyle(
              fontSize: isDesktop ? 28 : 24,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Manage your profile and preferences',
            style: TextStyle(
              fontSize: isDesktop ? 16 : 14,
              color: Colors.black54,
              fontWeight: FontWeight.w400,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedProfilePicture(String profilePicUrl, bool isDesktop) {
    final size = isDesktop ? 120.0 : 100.0;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(size / 2),
            boxShadow: [
              BoxShadow(
                color: AppConfig.primaryColor.withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(size / 2),
            child: Stack(
              children: [
                Image.network(
                  profilePicUrl,
                  width: size,
                  height: size,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: size,
                      height: size,
                      decoration: BoxDecoration(
                        color: AppConfig.primaryColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(size / 2),
                      ),
                      child: Icon(
                        Icons.person,
                        size: size * 0.5,
                        color: AppConfig.primaryColor,
                      ),
                    );
                  },
                ),
                // Overlay for hover effect
                if (kIsWeb ||
                    (!kIsWeb &&
                        (Platform.isMacOS ||
                            Platform.isWindows ||
                            Platform.isLinux)))
                  Container(
                    width: size,
                    height: size,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(size / 2),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOptionsList(BuildContext context, bool isDesktop) {
    final options = [
      {
        'icon': Icons.edit_outlined,
        'title': 'Edit Profile',
        'route': editProfileScreenRoute,
      },
      {
        'icon': Icons.location_on_outlined,
        'title': 'Address',
        'route': addressScreenRouter,
      },
      {
        'icon': Icons.history_outlined,
        'title': 'Order History',
        'route': orderHistoryScreenRoute,
      },
      {
        'icon': Icons.notifications_outlined,
        'title': 'Notifications',
        'route': notificationScreenRoute,
      },
      {'icon': Icons.logout_outlined, 'title': 'Logout', 'action': 'logout'},
    ];

    return Column(
      children:
          options.map((option) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _buildModernOptionItem(
                option['icon'] as IconData,
                option['title'] as String,
                () {
                  if (option['action'] == 'logout') {
                    _showLogoutConfirmationDialog(context);
                  } else {
                    Navigator.pushNamed(context, option['route'] as String);
                  }
                },
                isDesktop,
                isLogout: option['action'] == 'logout',
              ),
            );
          }).toList(),
    );
  }

  Widget _buildModernOptionItem(
    IconData icon,
    String title,
    VoidCallback onTap,
    bool isDesktop, {
    bool isLogout = false,
  }) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
            border: Border.all(
              color:
                  isLogout
                      ? Colors.red.withOpacity(0.2)
                      : AppConfig.primaryColor.withOpacity(0.1),
              width: 1,
            ),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(16),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isDesktop ? 24 : 20,
                  vertical: isDesktop ? 20 : 16,
                ),
                child: Row(
                  children: [
                    Container(
                      width: isDesktop ? 48 : 44,
                      height: isDesktop ? 48 : 44,
                      decoration: BoxDecoration(
                        color: (isLogout ? Colors.red : AppConfig.primaryColor)
                            .withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        icon,
                        color: isLogout ? Colors.red : AppConfig.primaryColor,
                        size: isDesktop ? 24 : 22,
                      ),
                    ),
                    SizedBox(width: isDesktop ? 20 : 16),
                    Expanded(
                      child: Text(
                        title,
                        style: TextStyle(
                          fontSize: isDesktop ? 16 : 15,
                          fontWeight: FontWeight.w600,
                          color: isLogout ? Colors.red : Colors.black87,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: isDesktop ? 18 : 16,
                      color: Colors.black38,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: Colors.red.withOpacity(0.6),
          ),
          const SizedBox(height: 16),
          const Text(
            "Failed to load profile",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "Please try again later",
            style: TextStyle(fontSize: 14, color: Colors.black54),
          ),
        ],
      ),
    );
  }

  void _showLogoutConfirmationDialog(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "Logout Dialog",
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation1, animation2) {
        return CustomAlertDialog(
          type: AlertType.confirmation,
          title: 'Logout Confirmation',
          message: 'Are you sure you want to log out of your account?',
          confirmText: 'Logout',
          cancelText: 'Cancel',
          onConfirm: () {
            context.read<ProfileBloc>().add(Logout());
          },
        );
      },
      transitionBuilder: (ctx, anim1, anim2, child) {
        return SlideTransition(
          position: Tween(
            begin: const Offset(0, 0.3),
            end: const Offset(0, 0),
          ).animate(CurvedAnimation(parent: anim1, curve: Curves.elasticOut)),
          child: FadeTransition(
            opacity: Tween(
              begin: 0.0,
              end: 1.0,
            ).animate(CurvedAnimation(parent: anim1, curve: Curves.easeInOut)),
            child: child,
          ),
        );
      },
    );
  }
}
