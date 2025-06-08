import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class ResponsiveLayout extends StatelessWidget {
  final Widget child;

  const ResponsiveLayout({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    // Determine max width based on platform and screen size
    double maxWidth;
    if (kIsWeb) {
      maxWidth = screenWidth > 1200 ? 800 : screenWidth * 0.9;
    } else {
      maxWidth = screenWidth > 600 ? 600 : double.infinity;
    }

    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: child,
      ),
    );
  }
}
