import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class DarkTheme {
  static ThemeData dark() {
    return ThemeData(
      scaffoldBackgroundColor: Colors.black,
      primaryColor: const Color.fromRGBO(91, 87, 186, 1),
      textTheme: TextTheme(
        headlineSmall: TextStyle(
            fontSize: 34.sp,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.14,
            color: Colors.white),
        titleLarge: TextStyle(
            fontSize: 17.sp,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.14,
            color: Colors.white),
        titleMedium: TextStyle(
            fontSize: 17.sp,
            fontWeight: FontWeight.w500,
            letterSpacing: -0.14,
            color: Colors.white),
        titleSmall: TextStyle(
            fontSize: 17.sp,
            fontWeight: FontWeight.w400,
            letterSpacing: -0.14,
            color: Colors.white),
        bodyLarge: TextStyle(
            fontSize: 15.sp,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.24,
            color: Colors.white),
        bodyMedium: TextStyle(
            fontSize: 15.sp,
            fontWeight: FontWeight.w500,
            letterSpacing: -0.24,
            color: Colors.white),
        bodySmall: TextStyle(
            fontSize: 15.sp,
            fontWeight: FontWeight.w400,
            letterSpacing: -0.24,
            color: Colors.white70),
        labelMedium: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.w400,
            letterSpacing: -0.08,
            color: Colors.white70),
        labelSmall: TextStyle(
            fontSize: 10.sp,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.12,
            color: Colors.white70),

        /// added because of i have no choice this is required
        labelLarge: const TextStyle(
            fontSize: 10, fontWeight: FontWeight.w500, letterSpacing: 0.12),
        headlineLarge: const TextStyle(
            fontSize: 34, fontWeight: FontWeight.w700, letterSpacing: 0.14),
        headlineMedium: const TextStyle(
            fontSize: 34, fontWeight: FontWeight.w700, letterSpacing: 0.14),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color.fromRGBO(251, 211, 81, 1),
      ),
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color.fromRGBO(251, 211, 81, 1),
        primary: const Color.fromRGBO(91, 87, 186, 1),
        secondary: const Color.fromRGBO(251, 211, 81, 1),
      ),
      fontFamily: GoogleFonts.roboto().fontFamily,
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Color.fromRGBO(43, 42, 42, 1.0),
        isDense: true,
        contentPadding: const EdgeInsets.fromLTRB(15, 13, 15, 13),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: Color.fromRGBO(91, 87, 186, 1),
            width: 1.6,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: Color.fromRGBO(91, 87, 186, 1),
            width: 1.6,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: Colors.redAccent,
            width: 1.6,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: Colors.redAccent,
            width: 1.6,
          ),
        ),
      ),
      buttonTheme: const ButtonThemeData(
        height: 32,
        buttonColor: Color.fromRGBO(91, 87, 186, 1),
      ),
    );
  }
}
