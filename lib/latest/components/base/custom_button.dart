import 'package:flutter/material.dart';
import 'package:demo_app/latest/app_config.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? color;
  final double width;
  final bool isGradient; // Toggle for gradient effect
  final double borderRadius;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.color,
    this.width = double.infinity,
    this.isGradient = false,
    this.borderRadius = 15.0,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          backgroundColor:
              isGradient ? null : (color ?? AppConfig.primaryButtonColor),
          padding: const EdgeInsets.symmetric(vertical: 16),
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
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: Text(
              text,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
                color: AppConfig.primaryButtonTextColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
