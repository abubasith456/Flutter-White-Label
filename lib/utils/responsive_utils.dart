import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ResponsiveUtils {
  static const double mobileBreakpoint = 768;
  static const double tabletBreakpoint = 1024;
  static const double desktopBreakpoint = 1440;

  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < mobileBreakpoint;
  }

  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= mobileBreakpoint && width < tabletBreakpoint;
  }

  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= tabletBreakpoint;
  }

  static bool isLargeDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= desktopBreakpoint;
  }

  static bool isWeb() {
    return kIsWeb;
  }

  static bool isMacOS() {
    return !kIsWeb && Platform.isMacOS;
  }

  static bool isWindows() {
    return !kIsWeb && Platform.isWindows;
  }

  static bool isLinux() {
    return !kIsWeb && Platform.isLinux;
  }

  static bool isDesktopPlatform() {
    return kIsWeb ||
        (!kIsWeb &&
            (Platform.isMacOS || Platform.isWindows || Platform.isLinux));
  }

  static bool isMobilePlatform() {
    return !kIsWeb && (Platform.isAndroid || Platform.isIOS);
  }

  static double getResponsivePadding(BuildContext context) {
    if (isMobile(context)) return 16.0;
    if (isTablet(context)) return 24.0;
    return 32.0;
  }

  static double getResponsiveFontSize(
    BuildContext context,
    double baseFontSize,
  ) {
    if (isMobile(context)) return baseFontSize;
    if (isTablet(context)) return baseFontSize * 1.1;
    return baseFontSize * 1.2;
  }

  static EdgeInsets getResponsiveMargin(BuildContext context) {
    if (isMobile(context)) {
      return const EdgeInsets.all(16.0);
    } else if (isTablet(context)) {
      return const EdgeInsets.all(24.0);
    } else {
      return const EdgeInsets.all(32.0);
    }
  }

  static double getMaxContentWidth(BuildContext context) {
    if (isMobile(context)) return double.infinity;
    if (isTablet(context)) return 600;
    return 800;
  }
}
