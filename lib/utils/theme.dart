import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const heroRed = Color(0xFFD62828);
  static const heroBlue = Color(0xFF0C1B55);
  static const inkNavy = Color(0xFF0D1730);
  static const paper = Color(0xFFF7F3E9);
  static const alertAmber = Color(0xFFFFB703);
}

ThemeData buildAppTheme() {
  final base = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.heroRed,
      primary: AppColors.heroRed,
      secondary: AppColors.heroBlue,
      surface: AppColors.paper,
    ),
    scaffoldBackgroundColor: AppColors.paper,
  );

  final textTheme = GoogleFonts.robotoCondensedTextTheme(base.textTheme);

  return base.copyWith(
    textTheme: textTheme,
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.inkNavy,
      foregroundColor: Colors.white,
      elevation: 0,
      titleTextStyle: GoogleFonts.robotoCondensed(
        fontSize: 22,
        fontWeight: FontWeight.w800,
        letterSpacing: 0.5,
        color: Colors.white,
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.inkNavy,
      selectedItemColor: AppColors.alertAmber,
      unselectedItemColor: Colors.white70,
      type: BottomNavigationBarType.fixed,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.heroRed,
      foregroundColor: Colors.white,
    ),
    cardTheme: CardThemeData(
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.heroRed,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
  );
}
