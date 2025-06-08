import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:demo_app/app_config.dart';

class ResponsiveProfileCard extends StatefulWidget {
  final String username;
  final String profilePicUrl;
  final bool isDesktop;
  final VoidCallback? onProfilePicTap;

  const ResponsiveProfileCard({
    super.key,
    required this.username,
    required this.profilePicUrl,
    this.isDesktop = false,
    this.onProfilePicTap,
  });

  @override
  State<ResponsiveProfileCard> createState() => _ResponsiveProfileCardState();
}

class _ResponsiveProfileCardState extends State<ResponsiveProfileCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _onHover(true),
      onExit: (_) => _onHover(false),
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              padding: EdgeInsets.all(widget.isDesktop ? 30 : 25),
              margin: EdgeInsets.all(widget.isDesktop ? 0 : 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(widget.isDesktop ? 0 : 25),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppConfig.primaryColor.withOpacity(_isHovered ? 0.15 : 0.1),
                    AppConfig.cardColor.withOpacity(0.9),
                  ],
                ),
                boxShadow:
                    widget.isDesktop
                        ? []
                        : [
                          BoxShadow(
                            color: AppConfig.shadowColor.withOpacity(
                              _isHovered ? 0.3 : 0.2,
                            ),
                            blurRadius: _isHovered ? 25 : 20,
                            offset: Offset(0, _isHovered ? 15 : 10),
                          ),
                        ],
              ),
              child: Column(
                children: [
                  _buildProfilePicture(),
                  SizedBox(height: widget.isDesktop ? 25 : 20),
                  _buildUserInfo(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfilePicture() {
    final size = widget.isDesktop ? 120.0 : 100.0;

    return GestureDetector(
      onTap: widget.onProfilePicTap,
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
                widget.profilePicUrl,
                width: size,
                height: size,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return _buildProfilePlaceholder(size);
                },
                errorBuilder: (context, error, stackTrace) {
                  return _buildProfilePlaceholder(size);
                },
              ),
              if (_isHovered && _supportsHover())
                Container(
                  width: size,
                  height: size,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(size / 2),
                  ),
                  child: const Icon(
                    Icons.camera_alt,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfilePlaceholder(double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppConfig.secondaryColor,
        borderRadius: BorderRadius.circular(size / 2),
      ),
      child: Icon(
        Icons.person,
        size: size * 0.5,
        color: AppConfig.primaryColor,
      ),
    );
  }

  Widget _buildUserInfo() {
    return Column(
      children: [
        Text(
          widget.username,
          style: TextStyle(
            fontSize: widget.isDesktop ? 28 : 24,
            fontWeight: FontWeight.w700,
            color: AppConfig.primaryTextColor,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Manage your profile and preferences',
          style: TextStyle(
            fontSize: widget.isDesktop ? 16 : 14,
            color: AppConfig.primaryTextColor.withOpacity(0.7),
            fontWeight: FontWeight.w400,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  void _onHover(bool isHovered) {
    if (!_supportsHover()) return;

    setState(() {
      _isHovered = isHovered;
    });

    if (isHovered) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  bool _supportsHover() {
    return kIsWeb ||
        (!kIsWeb &&
            (Platform.isMacOS || Platform.isWindows || Platform.isLinux));
  }
}
