import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:demo_app/app_config.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String? subtitle;
  final VoidCallback? onBack;
  final VoidCallback? onAction;
  final IconData actionIcon;
  final bool showBackButton;
  final bool showActionButton;
  final List<Color>? gradientColors;
  final Color? iconColor;
  final Color? textColor;
  final bool enableGlassMorphism;

  const CustomAppBar({
    super.key,
    required this.title,
    this.subtitle,
    this.onBack,
    this.onAction,
    this.actionIcon = Icons.more_vert,
    this.showBackButton = true,
    this.showActionButton = false,
    this.gradientColors,
    this.iconColor,
    this.textColor,
    this.enableGlassMorphism = true,
  });

  @override
  Widget build(BuildContext context) {
    // Use AppConfig colors or provided colors
    final defaultGradientColors =
        gradientColors ??
        [
          AppConfig.primaryColor.withOpacity(0.9),
          AppConfig.primaryColor,
          AppConfig.primaryColor.withOpacity(0.8),
        ];

    final defaultIconColor = iconColor ?? Colors.white;
    final defaultTextColor = textColor ?? Colors.white;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: defaultGradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: AppConfig.primaryColor.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: defaultTextColor,
                letterSpacing: 0.5,
              ),
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 2),
              Text(
                subtitle!,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: defaultTextColor.withOpacity(0.8),
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ],
        ),
        centerTitle: true,
        leading:
            showBackButton
                ? Container(
                  margin: const EdgeInsets.only(left: 12),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: onBack ?? () => Navigator.pop(context),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white.withOpacity(0.2),
                            width: 1,
                          ),
                        ),
                        child: Icon(
                          Icons.arrow_back_ios_new,
                          color: defaultIconColor,
                          size: 18,
                        ),
                      ),
                    ),
                  ),
                )
                : null,
        actions:
            showActionButton
                ? [
                  Container(
                    margin: const EdgeInsets.only(right: 12),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(20),
                        onTap: onAction,
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white.withOpacity(0.2),
                              width: 1,
                            ),
                          ),
                          child: Icon(
                            actionIcon,
                            color: defaultIconColor,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ),
                ]
                : null,
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(subtitle != null ? 70 : 60);
}

// Modern AppBar variants for different use cases
class ModernAppBarVariants {
  static CustomAppBar primary({
    required String title,
    String? subtitle,
    VoidCallback? onBack,
    VoidCallback? onAction,
    IconData actionIcon = Icons.more_vert,
    bool showBackButton = true,
    bool showActionButton = false,
  }) {
    return CustomAppBar(
      title: title,
      subtitle: subtitle,
      onBack: onBack,
      onAction: onAction,
      actionIcon: actionIcon,
      showBackButton: showBackButton,
      showActionButton: showActionButton,
    );
  }

  static CustomAppBar success({
    required String title,
    String? subtitle,
    VoidCallback? onBack,
    VoidCallback? onAction,
    IconData actionIcon = Icons.more_vert,
    bool showBackButton = true,
    bool showActionButton = false,
  }) {
    return CustomAppBar(
      title: title,
      subtitle: subtitle,
      onBack: onBack,
      onAction: onAction,
      actionIcon: actionIcon,
      showBackButton: showBackButton,
      showActionButton: showActionButton,
      gradientColors: const [Color(0xFF56ab2f), Color(0xFFa8e6cf)],
    );
  }

  static CustomAppBar warning({
    required String title,
    String? subtitle,
    VoidCallback? onBack,
    VoidCallback? onAction,
    IconData actionIcon = Icons.more_vert,
    bool showBackButton = true,
    bool showActionButton = false,
  }) {
    return CustomAppBar(
      title: title,
      subtitle: subtitle,
      onBack: onBack,
      onAction: onAction,
      actionIcon: actionIcon,
      showBackButton: showBackButton,
      showActionButton: showActionButton,
      gradientColors: const [Color(0xFFf093fb), Color(0xFFf5576c)],
    );
  }

  static CustomAppBar dark({
    required String title,
    String? subtitle,
    VoidCallback? onBack,
    VoidCallback? onAction,
    IconData actionIcon = Icons.more_vert,
    bool showBackButton = true,
    bool showActionButton = false,
  }) {
    return CustomAppBar(
      title: title,
      subtitle: subtitle,
      onBack: onBack,
      onAction: onAction,
      actionIcon: actionIcon,
      showBackButton: showBackButton,
      showActionButton: showActionButton,
      gradientColors: const [Color(0xFF2C3E50), Color(0xFF34495E)],
    );
  }
}
