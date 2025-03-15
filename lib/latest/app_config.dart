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
      'appName': 'Brand A App',
      'logo': 'assets/brand_a_logo.png',
    },
    'Hayat': {
      'primaryButtonColor': Colors.green,
      'primaryButtonTextColor': Colors.white,
      'primaryColor': Colors.lightGreen,
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

  static String get appName => _brandConfig['appName'] as String;

  static String get logo => _brandConfig['logo'] as String;
}
