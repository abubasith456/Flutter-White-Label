import 'package:flutter/material.dart';
import '../../app_config.dart';

class StatusChip extends StatelessWidget {
  final String status;
  final double fontSize;
  final EdgeInsetsGeometry padding;

  const StatusChip({
    super.key,
    required this.status,
    this.fontSize = 12,
    this.padding = const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
  });

  @override
  Widget build(BuildContext context) {
    final colorData = _getStatusColors(status);

    return Container(
      padding: padding,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            colorData.backgroundColor,
            colorData.backgroundColor.withOpacity(0.8),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: colorData.backgroundColor.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          color: colorData.textColor,
          fontWeight: FontWeight.w700,
          fontSize: fontSize,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  _StatusColors _getStatusColors(String status) {
    switch (status.toLowerCase()) {
      case 'delivered':
        return _StatusColors(
          backgroundColor: const Color(0xFF34C759),
          textColor: Colors.white,
        );
      case 'shipped':
        return _StatusColors(
          backgroundColor: const Color(0xFF007AFF),
          textColor: Colors.white,
        );
      case 'processing':
        return _StatusColors(
          backgroundColor: const Color(0xFFFF9500),
          textColor: Colors.white,
        );
      case 'cancelled':
        return _StatusColors(
          backgroundColor: const Color(0xFFFF3B30),
          textColor: Colors.white,
        );
      case 'pending':
        return _StatusColors(
          backgroundColor: const Color(0xFF8E8E93),
          textColor: Colors.white,
        );
      default:
        return _StatusColors(
          backgroundColor: const Color(0xFF8E8E93),
          textColor: Colors.white,
        );
    }
  }
}

class _StatusColors {
  final Color backgroundColor;
  final Color textColor;

  _StatusColors({required this.backgroundColor, required this.textColor});
}
