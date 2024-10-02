import 'package:flutter/material.dart';

class AppColors {
  static const Color primaryColor = Color(0xFF00a6ff); // Blue ?? Add
  static const Color secondaryColor = Color(0xFF00a6ff); // Blue ?? Add
  static const Color accentColor = Color(0xFF03DAC6); // Teal
  static const Color backgroundColor = Color(0xFFffffff); // white ?? Add
  static const Color whiteColor = Color(0xFFffffff); // white ?? Add
  static const Color blackColor = Colors.black; // white ?? Add
  static const Color lightTextColor =
      Color.fromARGB(255, 212, 209, 209); // Light Grey
  static const Color errorColor = Color(0xFFB00020); // Red ?? Add
  static const Color buttonColor = Color(0xFF018786); // Teal
  static const Color cardColor = Color(0xFFFFFFFF); // White ?? Add
  static const Color dividerColor = Color(0xFFBDBDBD); // Light Grey ?? Add
  static const Color successColor = Color(0xFF4CAF50); // Green ?? Add
  static const Color warningColor = Color(0xFFFFC107); // Amber ?? Add

  // Gradient Color
  static const Gradient primaryGradient = LinearGradient(
    colors: [
      Colors.blueAccent,
      Color.fromARGB(255, 225, 190, 231),
    ],
    begin: Alignment.topLeft,
    end: Alignment.topRight,
  );
}
