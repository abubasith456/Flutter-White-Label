import 'package:flutter/material.dart';

enum AlertType { success, error, info, warning, confirmation }

class CustomAlertDialog extends StatelessWidget {
  final AlertType type;
  final String title;
  final String message;
  final VoidCallback? onClose;
  final VoidCallback? onConfirm;
  final String? confirmText;
  final String? cancelText;

  const CustomAlertDialog({
    super.key,
    required this.type,
    required this.title,
    required this.message,
    this.onClose,
    this.onConfirm,
    this.confirmText,
    this.cancelText,
  });

  Color _getColor() {
    switch (type) {
      case AlertType.success:
        return Colors.green;
      case AlertType.error:
        return Colors.red;
      case AlertType.info:
        return Colors.blue;
      case AlertType.warning:
        return Colors.orange;
      case AlertType.confirmation:
        return Colors.blue;
    }
  }

  List<Color> _getGradient() {
    switch (type) {
      case AlertType.success:
        return [Colors.greenAccent, Colors.green];
      case AlertType.error:
        return [Colors.redAccent, Colors.red];
      case AlertType.info:
        return [Colors.lightBlueAccent, Colors.blue];
      case AlertType.warning:
        return [Colors.orangeAccent, Colors.deepOrange];
      case AlertType.confirmation:
        return [Colors.lightBlueAccent, Colors.blue];
    }
  }

  IconData _getIcon() {
    switch (type) {
      case AlertType.success:
        return Icons.check_circle_rounded;
      case AlertType.error:
        return Icons.error_rounded;
      case AlertType.info:
        return Icons.info_rounded;
      case AlertType.warning:
        return Icons.warning_amber_rounded;
      case AlertType.confirmation:
        return Icons.help_outline_rounded;
    }
  }

  Widget _buildButtons(BuildContext context) {
    if (type == AlertType.confirmation) {
      return Row(
        children: [
          Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[100],
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                cancelText ?? 'Cancel',
                style: const TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.w600,
                  fontSize: 17,
                  letterSpacing: 0.1,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: _getColor(),
                elevation: 4,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                shadowColor: _getColor().withOpacity(0.25),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                onConfirm?.call();
              },
              child: Text(
                confirmText ?? 'Confirm',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 17,
                  letterSpacing: 0.1,
                ),
              ),
            ),
          ),
        ],
      );
    }

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: _getColor(),
          elevation: 4,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          shadowColor: _getColor().withOpacity(0.25),
        ),
        onPressed: () {
          Navigator.of(context).pop();
          onClose?.call();
        },
        child: const Text(
          'OK',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 17,
            letterSpacing: 0.1,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final maxDialogWidth = 380.0;
    final screenWidth = MediaQuery.of(context).size.width;
    final dialogWidth =
        screenWidth < maxDialogWidth ? screenWidth * 0.92 : maxDialogWidth;

    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: dialogWidth, minWidth: 0),
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: _getColor().withOpacity(0.18),
                    blurRadius: 32,
                    offset: const Offset(0, 16),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0.8, end: 1.0),
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.elasticOut,
                    builder:
                        (context, scale, child) =>
                            Transform.scale(scale: scale, child: child),
                    child: Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: _getGradient(),
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: _getColor().withOpacity(0.25),
                            blurRadius: 16,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Icon(_getIcon(), color: Colors.white, size: 44),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: _getColor(),
                      letterSpacing: 0.2,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    message,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16.5,
                      color: Colors.black87,
                      height: 1.5,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 32),
                  _buildButtons(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
