import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart'; // If using Google Fonts

class AppTheme {
  static ThemeData lightTheme(BuildContext context) {
    // We'll let main.dart handle the system UI overlay style
    // to ensure consistency across the app

    return ThemeData(
      fontFamily: 'CustomFont', // Use your custom font if added in pubspec.yaml
      textTheme: GoogleFonts.poppinsTextTheme(), // Or use Google Fonts
      primarySwatch: Colors.blue,
      scaffoldBackgroundColor: Colors.white,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.blue,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
        titleTextStyle: TextStyle(
          color: Colors.black,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
