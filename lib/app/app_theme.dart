import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  const AppTheme._();

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: false,
      primarySwatch: Colors.brown,
      textTheme: GoogleFonts.soraTextTheme(),
      scaffoldBackgroundColor: Colors.white,
      appBarTheme: const AppBarTheme(centerTitle: true, elevation: 0),
    );
  }
}
