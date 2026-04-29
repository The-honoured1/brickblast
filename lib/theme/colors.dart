import 'package:flutter/material.dart';

class AppColors {
  // Backgrounds
  static const Color backgroundDark = Color(0xFF0F0B1E);
  static const Color bottomNavDark = Color(0xFF161129);
  
  // Neon Palette
  static const Color neonPink = Color(0xFFFF1E56);
  static const Color neonCyan = Color(0xFF05D9E8);
  static const Color neonYellow = Color(0xFFFFD600);
  static const Color neonGreen = Color(0xFF39FF14);
  static const Color neonPurple = Color(0xFFB100E8);
  static const Color neonRed = Color(0xFFFF003C);
  
  // Text UI
  static const Color textWhite = Color(0xFFF0F0F0);
  static const Color textMuted = Color(0xFF8A84A3);
  static const Color borderNeon = Color(0xFF1E1738);

  static Color background(bool isDark) => backgroundDark;
  static Color gridBackground(bool isDark) => backgroundDark;
  static Color emptyCell(bool isDark) => const Color(0xFF1A1A1A);
  static Color textPrimary(bool isDark) => textWhite;
  static Color border(bool isDark) => borderNeon;

  static const List<Color> blockColors = [
    neonPink,
    neonCyan,
    neonYellow,
    neonGreen,
    neonPurple,
    neonRed,
  ];
}
