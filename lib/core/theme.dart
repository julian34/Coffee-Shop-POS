import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: AppColors.color4,
  );

  static TextStyle sub_qoute = GoogleFonts.sora(
    fontSize: 16,
    color: AppColors.color4,
  );

  static TextStyle navBarText = GoogleFonts.sora(color: AppColors.color4);
}

class SvgCustomApp {
  static SvgPicture getIcon(
    String name, {
    double h = 24,
    double w = 24,
    c = AppColors.primary,
  }) {
    return SvgPicture.asset(
      'assets/icons/' + name + ".svg",
      width: w,
      height: h,
      color: c,
    );
  }
}
