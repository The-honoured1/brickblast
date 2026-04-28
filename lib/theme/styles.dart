import 'package:flutter/material.dart';
import 'colors.dart';

class AppStyles {
  static const TextStyle headline = TextStyle(
    fontSize: 48,
    fontWeight: FontWeight.w900,
    color: AppColors.textPrimary,
    letterSpacing: -1.5,
  );

  static const TextStyle scoreText = TextStyle(
    fontSize: 64,
    fontWeight: FontWeight.w900,
    color: AppColors.acidLime,
    letterSpacing: -2.0,
  );

  static const TextStyle subScoreText = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );
}
