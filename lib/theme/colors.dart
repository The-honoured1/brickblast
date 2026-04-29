import 'package:flutter/material.dart';

class AppColors {
  // Backgrounds
  static const Color background = Color(0xFFF9F9F9); // Clean, Zen background (NYT style)
  static const Color gridBackground = Color(0xFFECECEC); 
  static const Color emptyCell = Color(0xFFF0F0F0); 

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
  static const Color textPrimary = Color(0xFF121212); // Dark text for light background
  static const Color border = Color(0xFF000000); // Sharp black borders
}
