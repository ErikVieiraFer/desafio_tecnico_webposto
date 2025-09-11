import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color backgroundBlue = Color(0xFF00144E);
  static const Color detailRed = Color(0xFFC61212);
  static const Color fontWhite = Color(0xFFFFFFFF);

  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: fontWhite,
    colorScheme: const ColorScheme.light(
      primary: fontWhite,
      secondary: detailRed,
      onPrimary: backgroundBlue,
      onSecondary: fontWhite,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: backgroundBlue,
      elevation: 0,
      iconTheme: const IconThemeData(color: fontWhite),
      titleTextStyle: GoogleFonts.poppins(
        color: fontWhite,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    textTheme: TextTheme(
      displayLarge: GoogleFonts.poppins(color: backgroundBlue, fontWeight: FontWeight.bold),
      displayMedium: GoogleFonts.poppins(color: backgroundBlue, fontWeight: FontWeight.bold),
      displaySmall: GoogleFonts.poppins(color: backgroundBlue, fontWeight: FontWeight.bold),
      headlineLarge: GoogleFonts.poppins(color: backgroundBlue, fontWeight: FontWeight.bold),
      headlineMedium: GoogleFonts.poppins(color: backgroundBlue, fontWeight: FontWeight.bold),
      headlineSmall: GoogleFonts.poppins(color: backgroundBlue, fontWeight: FontWeight.bold),
      titleLarge: GoogleFonts.poppins(color: backgroundBlue, fontWeight: FontWeight.w600),
      titleMedium: GoogleFonts.poppins(color: backgroundBlue),
      titleSmall: GoogleFonts.poppins(color: backgroundBlue),
      bodyLarge: GoogleFonts.poppins(color: backgroundBlue),
      bodyMedium: GoogleFonts.poppins(color: backgroundBlue),
      bodySmall: GoogleFonts.poppins(color: backgroundBlue),
      labelLarge: GoogleFonts.poppins(color: backgroundBlue, fontWeight: FontWeight.w600),
      labelMedium: GoogleFonts.poppins(color: backgroundBlue),
      labelSmall: GoogleFonts.poppins(color: backgroundBlue),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: detailRed,
        foregroundColor: fontWhite,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        textStyle: GoogleFonts.poppins(fontWeight: FontWeight.bold),
      ),
    ),
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: backgroundBlue,
      selectionColor: backgroundBlue.withOpacity(0.3),
      selectionHandleColor: detailRed,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: backgroundBlue.withOpacity(0.05),
      hintStyle: GoogleFonts.poppins(color: backgroundBlue.withOpacity(0.7)),
      labelStyle: GoogleFonts.poppins(color: backgroundBlue),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(color: backgroundBlue),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(color: detailRed),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(color: detailRed),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(color: detailRed),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(color: backgroundBlue),
      ),
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: backgroundBlue,
    colorScheme: const ColorScheme.dark(
      primary: backgroundBlue,
      secondary: detailRed,
      onPrimary: fontWhite,
      onSecondary: fontWhite,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: fontWhite,
      elevation: 0,
      iconTheme: const IconThemeData(color: backgroundBlue),
      titleTextStyle: GoogleFonts.poppins(
        color: backgroundBlue,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    textTheme: TextTheme(
      displayLarge: GoogleFonts.poppins(color: fontWhite, fontWeight: FontWeight.bold),
      displayMedium: GoogleFonts.poppins(color: fontWhite, fontWeight: FontWeight.bold),
      displaySmall: GoogleFonts.poppins(color: fontWhite, fontWeight: FontWeight.bold),
      headlineLarge: GoogleFonts.poppins(color: fontWhite, fontWeight: FontWeight.bold),
      headlineMedium: GoogleFonts.poppins(color: fontWhite, fontWeight: FontWeight.bold),
      headlineSmall: GoogleFonts.poppins(color: fontWhite, fontWeight: FontWeight.bold),
      titleLarge: GoogleFonts.poppins(color: fontWhite, fontWeight: FontWeight.w600),
      titleMedium: GoogleFonts.poppins(color: fontWhite),
      titleSmall: GoogleFonts.poppins(color: fontWhite),
      bodyLarge: GoogleFonts.poppins(color: fontWhite),
      bodyMedium: GoogleFonts.poppins(color: fontWhite),
      bodySmall: GoogleFonts.poppins(color: fontWhite),
      labelLarge: GoogleFonts.poppins(color: fontWhite, fontWeight: FontWeight.w600),
      labelMedium: GoogleFonts.poppins(color: fontWhite),
      labelSmall: GoogleFonts.poppins(color: fontWhite),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: detailRed,
        foregroundColor: fontWhite,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        textStyle: GoogleFonts.poppins(fontWeight: FontWeight.bold),
      ),
    ),
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: fontWhite,
      selectionColor: fontWhite.withOpacity(0.3),
      selectionHandleColor: detailRed,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: fontWhite.withOpacity(0.05),
      hintStyle: GoogleFonts.poppins(color: fontWhite.withOpacity(0.7)),
      labelStyle: GoogleFonts.poppins(color: fontWhite),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(color: fontWhite),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(color: detailRed),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(color: detailRed),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(color: detailRed),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(color: fontWhite),
      ),
    ),
  );
}
