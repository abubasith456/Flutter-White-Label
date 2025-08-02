import 'package:flutter/material.dart';

class AppConfig {
  static String selectedBrand =
      'Musfi'; // Default brand, can be changed dynamically

  // Explicitly defining types for better access control
  static final Map<String, Map<String, dynamic>> _config = {
    'Musfi': {
      'primaryButtonColor': Colors.blue,
      'primaryButtonTextColor': Colors.white,
      'primaryColor': Colors.blue,
      'primaryTextColor': Colors.black,
      'secondaryColor': Colors.blue.shade50,
      'cardColor': Colors.white,
      'shadowColor': Colors.blue.withOpacity(0.1),
      'gradientColors': [Colors.blue.shade400, Colors.blue.shade600],
      'errorColor': Colors.red,
      'successColor': Colors.green,
      'warningColor': Colors.orange,
      'greyColor': Colors.grey,
      'backgroundColor': const Color(0xFFF8F9FA),
      'appName': 'Brand A App',
      'logo': 'assets/brand_a_logo.png',
    },
    'Hayat': {
      'primaryButtonColor': Colors.green,
      'primaryButtonTextColor': Colors.white,
      'primaryColor': Colors.lightGreen,
      'primaryTextColor': Colors.black,
      'secondaryColor': Colors.green.shade50,
      'cardColor': Colors.white,
      'shadowColor': Colors.green.withOpacity(0.1),
      'gradientColors': [Colors.green.shade400, Colors.green.shade600],
      'errorColor': Colors.red,
      'successColor': Colors.green,
      'warningColor': Colors.orange,
      'greyColor': Colors.grey,
      'backgroundColor': const Color(0xFFF8F9FA),
      'appName': 'Brand B App',
      'logo': 'assets/brand_b_logo.png',
    },
  };

  // Ensure we access a valid brand config
  static Map<String, dynamic> get _brandConfig =>
      _config[selectedBrand] ?? _config['Musfi']!;

  // Getters for config values
  static Color get primaryButtonColor =>
      _brandConfig['primaryButtonColor'] as Color;

  static Color get primaryButtonTextColor =>
      _brandConfig['primaryButtonTextColor'] as Color;

  static Color get primaryColor => _brandConfig['primaryColor'] as Color;

  static Color get secondaryColor => _brandConfig['secondaryColor'] as Color;

  static Color get cardColor => _brandConfig['cardColor'] as Color;

  static Color get shadowColor => _brandConfig['shadowColor'] as Color;

  static List<Color> get gradientColors =>
      _brandConfig['gradientColors'] as List<Color>;

  static Color get errorColor => _brandConfig['errorColor'] as Color;

  static Color get successColor => _brandConfig['successColor'] as Color;

  static Color get warningColor => _brandConfig['warningColor'] as Color;

  static MaterialColor get greyColor =>
      _brandConfig['greyColor'] as MaterialColor;

  static Color get backgroundColor => _brandConfig['backgroundColor'] as Color;

  static String get appName => _brandConfig['appName'] as String;

  static String get logo => _brandConfig['logo'] as String;

  static Color get primaryTextColor =>
      _brandConfig['primaryTextColor'] as Color;

  // Add the missing defaultPadding property
  static const double defaultPadding = 16.0;

  // Add borderRadius if not already defined
  static const double borderRadius = 12.0;

  // Add missing getters referenced in the ProductDetailsScreen
  static List<BoxShadow> get cardShadow => [
    BoxShadow(color: shadowColor, blurRadius: 8, offset: const Offset(0, 2)),
  ];

  // Add color constants
  static const Color textPrimary = Colors.black87;
  static const Color textSecondary = Colors.black54;
  static const Color textMuted = Colors.grey;
  static const Color surfaceColor = Color(0xFFF5F5F5);

  // Add spacing constants
  static const double spacing = 16.0;
  static const double spacingSmall = 8.0;
  static const double spacingLarge = 24.0;

  // Add border radius constants
  static const double borderRadiusLarge = 20.0;

  // Add primary dark color based on primary color
  static Color get primaryDark => primaryColor.withOpacity(0.8);

  // Add accent color
  static const Color accentColor = Colors.orange;

  // Add button shadow
  static List<BoxShadow> get buttonShadow => [
    BoxShadow(
      color: primaryColor.withOpacity(0.25),
      blurRadius: 8,
      offset: const Offset(0, 4),
    ),
  ];
}
