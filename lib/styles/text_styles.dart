import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_theme.dart';

class AppTextStyles {
  static TextStyle displayLg = GoogleFonts.inter(
    fontSize: 48, height: 56 / 48, letterSpacing: -0.02 * 48, fontWeight: FontWeight.w700, color: AppColors.onBackground,
  );

  static TextStyle headlineLg = GoogleFonts.inter(
    fontSize: 32, height: 40 / 32, letterSpacing: -0.01 * 32, fontWeight: FontWeight.w700, color: AppColors.onBackground,
  );

  static TextStyle headlineLgMobile = GoogleFonts.inter(
    fontSize: 28, height: 34 / 28, letterSpacing: -0.01 * 28, fontWeight: FontWeight.w700, color: AppColors.onBackground,
  );

  static TextStyle headlineMd = GoogleFonts.inter(
    fontSize: 24, height: 32 / 24, fontWeight: FontWeight.w600, color: AppColors.onBackground,
  );

  static TextStyle bodyLg = GoogleFonts.inter(
    fontSize: 18, height: 28 / 18, fontWeight: FontWeight.w400, color: AppColors.onBackground,
  );

  static TextStyle bodyMd = GoogleFonts.inter(
    fontSize: 16, height: 24 / 16, fontWeight: FontWeight.w400, color: AppColors.onBackground,
  );

  static TextStyle labelMd = GoogleFonts.inter(
    fontSize: 14, height: 20 / 14, letterSpacing: 0.05 * 14, fontWeight: FontWeight.w600, color: AppColors.onBackground,
  );

  static TextStyle labelSm = GoogleFonts.inter(
    fontSize: 12, height: 16 / 12, fontWeight: FontWeight.w500, color: AppColors.onBackground,
  );
}

extension TextStyleExtension on TextStyle {
  TextStyle withColor(Color color) => copyWith(color: color);
}
