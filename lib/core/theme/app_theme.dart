import 'package:flutter/material.dart';

class AppTheme {
  // Palet Warna Alami/Hutan (IKN Nusantara Theme)
  static const Color primaryColor = Color(0xFF1E5631); // Forest Green Utama
  static const Color primaryLightColor = Color(0xFF4C9A2A); // Olive/Light Green
  static const Color accentColor = Color(0xFFD4AF37); // Gold / Nusantara Sun
  static const Color backgroundColor = Color(0xFFF4F7F4); // Off-White Nature
  static const Color cardColor = Colors.white;
  static const Color textDarkColor = Color(0xFF2C3E2B); // Dark Moss Gray
  static const Color textLightColor = Color(0xFF708070); // Soft Sage Gray
  static const Color errorColor = Color(0xFFD32F2F);

  static ThemeData get natureTheme {
    return ThemeData(
      useMaterial3: true,
      primaryColor: primaryColor,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        primary: primaryColor,
        secondary: accentColor,
        background: backgroundColor,
        error: errorColor,
      ),
      scaffoldBackgroundColor: backgroundColor,
      appBarTheme: const AppBarTheme(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
      cardTheme: CardTheme(
        color: cardColor,
        elevation: 2,
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryColor,
          side: const BorderSide(color: primaryColor, width: 1.5),
          minimumSize: const Size(double.infinity, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: errorColor, width: 1.5),
        ),
        labelStyle: const TextStyle(color: textLightColor),
      ),
      textTheme: const TextTheme(
        titleLarge: TextStyle(color: textDarkColor, fontSize: 22, fontWeight: FontWeight.bold),
        titleMedium: TextStyle(color: textDarkColor, fontSize: 18, fontWeight: FontWeight.w600),
        bodyLarge: TextStyle(color: textDarkColor, fontSize: 16),
        bodyMedium: TextStyle(color: textLightColor, fontSize: 14),
      ),
    );
  }
}
