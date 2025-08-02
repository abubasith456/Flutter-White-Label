import 'package:flutter/material.dart';

class AppTextStyles {
  // Base font families
  static const String _primaryFont = 'Plus Jakarta';
  static const String _secondaryFont = 'Grandis Extended';

  // Category text styles
  static const TextStyle categoryName = TextStyle(
    fontFamily: _primaryFont,
    fontWeight: FontWeight.w600,
    fontSize: 10,
    color: Color(0xFF2A2A2A),
    height: 1.2,
    letterSpacing: 0.2,
  );

  // Product card text styles
  static const TextStyle productTitle = TextStyle(
    fontFamily: _primaryFont,
    fontWeight: FontWeight.w600,
    fontSize: 11,
    color: Color(0xFF1A1A1A),
    height: 1.2,
  );

  static const TextStyle productPrice = TextStyle(
    fontFamily: _secondaryFont,
    color: Colors.white,
    fontWeight: FontWeight.w700,
    fontSize: 9,
  );

  // Header text styles
  static const TextStyle sectionHeader = TextStyle(
    fontFamily: _secondaryFont,
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: Color(0xFF1A1A1A),
  );

  // Large header text styles for welcome messages
  static const TextStyle welcomeHeader = TextStyle(
    fontFamily: _secondaryFont,
    fontSize: 22,
    fontWeight: FontWeight.w300,
    color: Color(0xFF1A1A1A),
  );

  static const TextStyle welcomeHeaderBold = TextStyle(
    fontFamily: _secondaryFont,
    fontSize: 22,
    fontWeight: FontWeight.w900,
    letterSpacing: -0.5,
  );

  // App bar title
  static const TextStyle appBarTitle = TextStyle(
    fontFamily: _primaryFont,
    fontSize: 15,
    fontWeight: FontWeight.w700,
    color: Color(0xFF1A1A1A),
  );

  // Search field styles
  static const TextStyle searchInput = TextStyle(
    fontFamily: _primaryFont,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: Color(0xFF1A1A1A),
  );

  static const TextStyle searchHint = TextStyle(
    fontFamily: _primaryFont,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: Color(0xFF666666),
  );

  // Category chip text
  static const TextStyle categoryChip = TextStyle(
    fontFamily: _primaryFont,
    fontWeight: FontWeight.w500,
    fontSize: 12,
  );

  // Product card text styles
  static const TextStyle productCardTitle = TextStyle(
    fontFamily: _primaryFont,
    fontWeight: FontWeight.w600,
    fontSize: 14,
    color: Color(0xFF1A1A1A),
  );

  static const TextStyle productCardPrice = TextStyle(
    fontFamily: _secondaryFont,
    fontWeight: FontWeight.w700,
    fontSize: 14,
  );

  // Error text styles
  static const TextStyle errorText = TextStyle(
    fontFamily: _primaryFont,
    fontSize: 10,
    fontWeight: FontWeight.w600,
    color: Color(0x66666666),
  );

  // Body text styles
  static const TextStyle bodyMedium = TextStyle(
    fontFamily: _primaryFont,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: Color(0xFF666666),
  );

  static const TextStyle bodyLarge = TextStyle(
    fontFamily: _primaryFont,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: Color(0xFF666666),
  );

  // Results header
  static const TextStyle resultsHeader = TextStyle(
    fontFamily: _secondaryFont,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Color(0xFF1A1A1A),
  );

  // Empty state text
  static const TextStyle emptyStateTitle = TextStyle(
    fontFamily: _secondaryFont,
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: Color(0xFF1A1A1A),
  );

  static const TextStyle emptyStateSubtitle = TextStyle(
    fontFamily: _primaryFont,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: Color(0xFF666666),
  );

  // Badge text
  static const TextStyle badgeText = TextStyle(
    fontFamily: _primaryFont,
    fontWeight: FontWeight.w500,
    fontSize: 10,
  );

  // Address text styles
  static const TextStyle addressText = TextStyle(
    fontFamily: _primaryFont,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: Color(0xFF333333),
    height: 1.4,
  );

  static const TextStyle addressName = TextStyle(
    fontFamily: _secondaryFont,
    fontSize: 14,
    fontWeight: FontWeight.w700,
    color: Color(0xFF1A1A1A),
    height: 1.4,
  );
}
