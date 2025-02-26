import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const Color primary = Color(0xFFC67C4E);
  static const Color color2 = Color(0xFFEDD6C8);
  static const Color color3 = Color(0xFF313131);
  static const Color color4 = Color(0xFFE3E3E3);
  static const Color color5 = Color(0xFFF9F2ED);
  static const Color color6 = Color(0xFF963939);
  static const Color color7 = Color(0xFF4C9639);
}

class AppFonts {
  static TextStyle default_font = GoogleFonts.sora();
  static TextStyle title_screen = GoogleFonts.sora(
    fontSize: 36,
    fontWeight: FontWeight.bold,
    color: AppColors.color5,
  );
  static TextStyle qoute = GoogleFonts.sora(
    fontSize: 32,
    fontWeight: FontWeight.w600,
    color: AppColors.color4,
  );

  static TextStyle sub_qoute = GoogleFonts.sora(
    fontSize: 16,
    color: AppColors.color4,
  );
}
