import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; // If using Google Fonts

class AppTheme {
  static ThemeData lightTheme(BuildContext context) {
    return ThemeData(
      fontFamily: 'CustomFont', // Use your custom font if added in pubspec.yaml
      textTheme: GoogleFonts.poppinsTextTheme(), // Or use Google Fonts
      primarySwatch: Colors.blue,
      scaffoldBackgroundColor: Colors.white,
    );
  }
}
