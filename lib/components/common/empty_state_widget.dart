import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../app_config.dart';

class EmptyStateWidget extends StatelessWidget {
  final String title;
  final String subtitle;
  final String? iconPath;
  final IconData? icon;
  final String buttonText;
  final VoidCallback onButtonPressed;
  final Color? primaryColor;

  const EmptyStateWidget({
    super.key,
    required this.title,
    required this.subtitle,
    this.iconPath,
    this.icon,
    required this.buttonText,
    required this.onButtonPressed,
    this.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    final effectivePrimaryColor = primaryColor ?? AppConfig.primaryColor;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    effectivePrimaryColor.withOpacity(0.1),
                    effectivePrimaryColor.withOpacity(0.05),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
              ),
              child: _buildIcon(context, effectivePrimaryColor),
            ),
            const SizedBox(height: 32),
            Text(
              title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1A1A1A),
                letterSpacing: -0.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Color(0xFF8E8E93),
                height: 1.4,
              ),
            ),
            const SizedBox(height: 40),
            Container(
              width: double.infinity,
              height: 56,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    effectivePrimaryColor,
                    effectivePrimaryColor.withOpacity(0.8),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: effectivePrimaryColor.withOpacity(0.3),
                    blurRadius: 16,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: onButtonPressed,
                  borderRadius: BorderRadius.circular(16),
                  child: Center(
                    child: Text(
                      buttonText,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        letterSpacing: -0.2,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIcon(BuildContext context, Color primaryColor) {
    if (iconPath != null) {
      return SvgPicture.asset(
        iconPath!,
        height: 60,
        width: 60,
        fit: BoxFit.contain,
        colorFilter: ColorFilter.mode(
          primaryColor.withOpacity(0.6),
          BlendMode.srcIn,
        ),
        placeholderBuilder:
            (context) => Icon(
              icon ?? Icons.shopping_bag_outlined,
              size: 60,
              color: primaryColor.withOpacity(0.6),
            ),
      );
    }

    return Icon(
      icon ?? Icons.shopping_bag_outlined,
      size: 60,
      color: primaryColor.withOpacity(0.6),
    );
  }
}
