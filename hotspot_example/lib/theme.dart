import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryPurple = Color(0xFF6A1B9A);
  static const Color lightPurple = Color(0xFFF3E5F5);

  static ThemeData get light {
    final base = ThemeData.light();

    return base.copyWith(
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryPurple,
        brightness: Brightness.light,
      ),
      scaffoldBackgroundColor: Colors.white,
      appBarTheme: const AppBarTheme(
        backgroundColor: primaryPurple,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      textTheme: base.textTheme.apply(
        bodyColor: primaryPurple,
        displayColor: primaryPurple,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: lightPurple,
          foregroundColor: primaryPurple,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(color: primaryPurple, width: 2),
          ),
        ),
      ),
    );
  }
}
