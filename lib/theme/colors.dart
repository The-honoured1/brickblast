import 'package:flutter/material.dart';

class AppColors {
  // Dynamic Backgrounds
  static Color background(bool isDark) => isDark ? const Color(0xFF1A1A1A) : const Color(0xFFF9F9F9);
  static Color gridBackground(bool isDark) => isDark ? const Color(0xFF121212) : const Color(0xFFECECEC);
  static Color emptyCell(bool isDark) => isDark ? const Color(0xFF222222) : const Color(0xFFF0F0F0);

  // Dynamic Text / UI
  static Color textPrimary(bool isDark) => isDark ? const Color(0xFFF0F0F0) : const Color(0xFF121212);
  static Color border(bool isDark) => isDark ? const Color(0xFF000000) : const Color(0xFF000000); // Black works for both!

  // Vibrant Block Colors (Constant)
  static const Color neonPink = Color(0xFFFF2A6D);
  static const Color electricBlue = Color(0xFF05D9E8);
  static const Color acidLime = Color(0xFFD1F232);
  static const Color brightOrange = Color(0xFFFF6D00);
  static const Color pureYellow = Color(0xFFFFD700);
  static const Color deepPurple = Color(0xFF7A00FF);

  static const List<Color> blockColors = [
    neonPink,
    electricBlue,
    acidLime,
    brightOrange,
    pureYellow,
    deepPurple,
  ];
}
