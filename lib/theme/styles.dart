import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'colors.dart';

class AppStyles {
  static TextStyle headline = GoogleFonts.teko(
    fontSize: 48,
    fontWeight: FontWeight.w700,
    color: AppColors.textWhite,
    letterSpacing: 2.0,
  );

  static TextStyle scoreText = GoogleFonts.teko(
    fontSize: 64,
    fontWeight: FontWeight.w700,
    color: AppColors.textWhite,
  );

  static TextStyle labelText = GoogleFonts.rajdhani(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.textMuted,
    letterSpacing: 1.5,
  );
  
  static TextStyle buttonText = GoogleFonts.teko(
    fontSize: 28,
    fontWeight: FontWeight.w600,
    color: AppColors.textWhite,
    letterSpacing: 2.0,
  );
}
