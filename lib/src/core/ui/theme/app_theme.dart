import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFFFFFFFF);
  static const Color accentColor = Color(0xFFC61212);
  static const Color fontColor = Color(0xFF00144E);

  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: primaryColor,
    colorScheme: const ColorScheme.light(
      primary: primaryColor,
      secondary: accentColor,
      onPrimary: fontColor,
      onSecondary: Colors.white,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: fontColor,
      elevation: 0,
      iconTheme: const IconThemeData(color: primaryColor),
      titleTextStyle: GoogleFonts.poppins(
        color: primaryColor,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    textTheme: TextTheme(
      displayLarge: GoogleFonts.poppins(
        color: fontColor,
        fontWeight: FontWeight.bold,
      ),
      displayMedium: GoogleFonts.poppins(
        color: fontColor,
        fontWeight: FontWeight.bold,
      ),
      displaySmall: GoogleFonts.poppins(
        color: fontColor,
        fontWeight: FontWeight.bold,
      ),
      headlineLarge: GoogleFonts.poppins(
        color: fontColor,
        fontWeight: FontWeight.bold,
      ),
      headlineMedium: GoogleFonts.poppins(
        color: fontColor,
        fontWeight: FontWeight.bold,
      ),
      headlineSmall: GoogleFonts.poppins(
        color: fontColor,
        fontWeight: FontWeight.bold,
      ),
      titleLarge: GoogleFonts.poppins(
        color: fontColor,
        fontWeight: FontWeight.w600,
      ),
      titleMedium: GoogleFonts.poppins(color: fontColor),
      titleSmall: GoogleFonts.poppins(color: fontColor),
      bodyLarge: GoogleFonts.poppins(color: fontColor),
      bodyMedium: GoogleFonts.poppins(color: fontColor),
      bodySmall: GoogleFonts.poppins(color: fontColor),
      labelLarge: GoogleFonts.poppins(
        color: fontColor,
        fontWeight: FontWeight.w600,
      ),
      labelMedium: GoogleFonts.poppins(color: fontColor),
      labelSmall: GoogleFonts.poppins(color: fontColor),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: accentColor,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        textStyle: GoogleFonts.poppins(fontWeight: FontWeight.bold),
      ),
    ),
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: fontColor,
      selectionColor: fontColor.withAlpha(77),
      selectionHandleColor: accentColor,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: fontColor.withAlpha(13),
      hintStyle: GoogleFonts.poppins(color: fontColor.withAlpha(179)),
      labelStyle: GoogleFonts.poppins(color: fontColor),

      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(color: fontColor),
      ),

      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(color: accentColor),
      ),

      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(color: accentColor),
      ),

      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(color: accentColor),
      ),

      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(color: fontColor),
      ),
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: fontColor,
    colorScheme: const ColorScheme.dark(
      primary: fontColor,
      secondary: accentColor,
      onPrimary: primaryColor,
      onSecondary: primaryColor,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: primaryColor,
      elevation: 0,
      iconTheme: const IconThemeData(color: fontColor),
      titleTextStyle: GoogleFonts.poppins(
        color: fontColor,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    textTheme: TextTheme(
      displayLarge: GoogleFonts.poppins(
        color: primaryColor,
        fontWeight: FontWeight.bold,
      ),
      displayMedium: GoogleFonts.poppins(
        color: primaryColor,
        fontWeight: FontWeight.bold,
      ),
      displaySmall: GoogleFonts.poppins(
        color: primaryColor,
        fontWeight: FontWeight.bold,
      ),
      headlineLarge: GoogleFonts.poppins(
        color: primaryColor,
        fontWeight: FontWeight.bold,
      ),
      headlineMedium: GoogleFonts.poppins(
        color: primaryColor,
        fontWeight: FontWeight.bold,
      ),
      headlineSmall: GoogleFonts.poppins(
        color: primaryColor,
        fontWeight: FontWeight.bold,
      ),
      titleLarge: GoogleFonts.poppins(
        color: primaryColor,
        fontWeight: FontWeight.w600,
      ),
      titleMedium: GoogleFonts.poppins(color: primaryColor),
      titleSmall: GoogleFonts.poppins(color: primaryColor),
      bodyLarge: GoogleFonts.poppins(color: primaryColor),
      bodyMedium: GoogleFonts.poppins(color: primaryColor),
      bodySmall: GoogleFonts.poppins(color: primaryColor),
      labelLarge: GoogleFonts.poppins(
        color: primaryColor,
        fontWeight: FontWeight.w600,
      ),
      labelMedium: GoogleFonts.poppins(color: primaryColor),
      labelSmall: GoogleFonts.poppins(color: primaryColor),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: accentColor,
        foregroundColor: primaryColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        textStyle: GoogleFonts.poppins(fontWeight: FontWeight.bold),
      ),
    ),
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: primaryColor,
      selectionColor: primaryColor.withAlpha(77),
      selectionHandleColor: accentColor,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: primaryColor.withAlpha(13),
      hintStyle: GoogleFonts.poppins(color: primaryColor.withAlpha(179)),
      labelStyle: GoogleFonts.poppins(color: primaryColor),

      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(color: primaryColor),
      ),

      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(color: accentColor),
      ),

      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(color: accentColor),
      ),

      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(color: accentColor),
      ),

      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(color: primaryColor),
      ),
    ),
  );
}
