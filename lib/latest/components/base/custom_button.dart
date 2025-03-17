import 'package:flutter/material.dart';
import 'package:demo_app/latest/app_config.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? color;
  final double width;
  final bool isGradient; // Toggle for gradient effect
  final double borderRadius;
  final double height; // Static height for the button
  final Icon? icon; // Optional icon parameter

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.color,
    this.width = double.infinity,
    this.isGradient = false,
    this.borderRadius = 15.0,
    this.height = 60.0, // Default height is set to 50.0
    this.icon, // Optional icon
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height, // Fixed height for the button
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          backgroundColor:
              isGradient ? null : (color ?? AppConfig.primaryButtonColor),
          elevation: 6, // Adds shadow effect
          shadowColor: Colors.black45, // Soft shadow
        ).copyWith(
          backgroundColor:
              isGradient
                  ? WidgetStateProperty.all(Colors.transparent)
                  : WidgetStateProperty.all(
                    color ?? AppConfig.primaryButtonColor,
                  ),
          overlayColor: WidgetStateProperty.all(Colors.white24), // Press effect
        ),
        child: Ink(
          decoration:
              isGradient
                  ? BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppConfig.primaryButtonColor,
                        AppConfig.primaryColor,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(borderRadius),
                  )
                  : null,
          child: Container(
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (icon != null) ...[
                  icon!,
                  const SizedBox(width: 8), // Space between icon and text
                ],
                Text(
                  text,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                    color: AppConfig.primaryButtonTextColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
