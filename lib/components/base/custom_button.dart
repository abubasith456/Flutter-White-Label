import 'package:flutter/material.dart';
import 'package:demo_app/app_config.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? color;
  final double width;
  final bool isGradient; // Toggle for gradient effect
  final double borderRadius;
  final double height; // Static height for the button
  final Icon? icon; // Optional icon parameter
  final double? fontSize; // Optional font size parameter for smaller screens
  final bool isEnabled; // Toggle for button enabled/disabled state

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.color,
    this.width = double.infinity,
    this.isGradient = false,
    this.borderRadius = 15.0,
    this.height = 60.0, // Default height is set to 60.0
    this.icon, // Optional icon
    this.fontSize, // Optional font size
    this.isEnabled = true, // Default value is true (enabled)
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height, // Fixed height for the button
      child: ElevatedButton(
        onPressed: isEnabled ? onPressed : null,
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          backgroundColor:
              isGradient ? null : (color ?? AppConfig.primaryButtonColor),
          elevation: isEnabled ? 6 : 0, // Reduced elevation when disabled
          shadowColor: Colors.black45, // Soft shadow
          disabledBackgroundColor: Colors.grey.shade300, // Color when disabled
          disabledForegroundColor:
              Colors.grey.shade600, // Text color when disabled
        ).copyWith(
          backgroundColor:
              isEnabled
                  ? (isGradient
                      ? WidgetStateProperty.all(Colors.transparent)
                      : WidgetStateProperty.all(
                        color ?? AppConfig.primaryButtonColor,
                      ))
                  : WidgetStateProperty.all(Colors.grey.shade300),
          overlayColor: WidgetStateProperty.all(Colors.white24), // Press effect
        ),
        child: Ink(
          decoration:
              isGradient && isEnabled
                  ? BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppConfig.primaryButtonColor,
                        AppConfig.primaryColor,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(borderRadius),
                  )
                  : isGradient && !isEnabled
                  ? BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(borderRadius),
                  )
                  : null,
          child: Container(
            alignment: Alignment.center,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null) ...[
                    icon!,
                    SizedBox(
                      width: MediaQuery.of(context).size.width < 375 ? 4 : 8,
                    ),
                  ],
                  Text(
                    text,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: TextStyle(
                      fontSize:
                          fontSize ??
                          (MediaQuery.of(context).size.width < 375 ? 12 : 14),
                      fontWeight: FontWeight.bold,
                      letterSpacing:
                          MediaQuery.of(context).size.width < 375 ? 0.5 : 1.2,
                      height: 1.2, // Reduced height for smaller screens
                      leadingDistribution: TextLeadingDistribution.even,
                      textBaseline: TextBaseline.alphabetic,
                      color:
                          isEnabled
                              ? AppConfig.primaryButtonTextColor
                              : Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
