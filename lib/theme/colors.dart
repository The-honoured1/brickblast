import 'package:flutter/material.dart';

class AppColors {
  // Backgrounds
  static const Color background = Color(0xFF0F0F0F); // Very dark, punchy background
  static const Color gridBackground = Color(0xFF1A1A1A); // Slightly lighter for grid base
  static const Color emptyCell = Color(0xFF232323); // Empty spot

  // Vibrant, shocking Block Colors (Flat design)
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

  // Text / UI
  static const Color textPrimary = Color(0xFFF9F9F9);
  static const Color border = Color(0xFF333333);
}
