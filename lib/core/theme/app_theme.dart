import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFF6200EE); // Deep purple
  static const Color secondaryColor = Color(0xFF03DAC6); // Teal
  static const Color backgroundColor = Color(0xFFF5F5F5); // Light gray
  static const Color cardColor = Colors.white;
  static const Color errorColor = Color(0xFFB00020); // Red

  static ThemeData lightTheme = ThemeData(
    colorScheme: ColorScheme.light(
      primary: primaryColor,
      secondary: secondaryColor,
      error: errorColor,
      surface: cardColor,
      onPrimary: Colors.white,
      onSecondary: Colors.black,
      onError: Colors.white,
      onSurface: Colors.black87,
    ),
    brightness: Brightness.light,
    fontFamily: 'Roboto',
    scaffoldBackgroundColor: backgroundColor,
    appBarTheme: AppBarTheme(
      backgroundColor: primaryColor,
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white, backgroundColor: primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
    textTheme: TextTheme(
      displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.black87),
      bodyLarge: TextStyle(fontSize: 16, color: Colors.black87),
      bodyMedium: TextStyle(fontSize: 14, color: Colors.black54),
    ),
    useMaterial3: true,
  );

  static ThemeData darkTheme = ThemeData(
    colorScheme: ColorScheme.dark(
      primary: primaryColor,
      secondary: secondaryColor,
      background: Color(0xFF121212), // Dark gray
      error: errorColor,
      surface: Color(0xFF1E1E1E), // Slightly lighter than background
      onPrimary: Colors.white,
      onSecondary: Colors.black,
      onBackground: Colors.white,
      onError: Colors.white,
      onSurface: Colors.white,
    ),
    brightness: Brightness.dark,
    fontFamily: 'Roboto',
    scaffoldBackgroundColor: Color(0xFF121212),
    appBarTheme: AppBarTheme(
      backgroundColor: primaryColor,
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white, backgroundColor: primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
    textTheme: TextTheme(
      displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
      bodyLarge: TextStyle(fontSize: 16, color: Colors.white),
      bodyMedium: TextStyle(fontSize: 14, color: Colors.white70),
    ),
    useMaterial3: true,
  );
}