import 'package:flutter/material.dart';

class AppTheme {
  // Define color constants
  static const Color _primaryColor = Color(0xFF4CAF50);
  static const Color _accentColor = Color(0xFF8BC34A);
  static const Color _backgroundColor = Color(0xFFF5F5F5);
  static const Color _textColor = Color(0xFF333333);
  static const Color _secondaryTextColor = Color(0xFF757575);

  // Light Theme
  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: _primaryColor,
      colorScheme: const ColorScheme.light(
        primary: _primaryColor,
        secondary: _accentColor,
        background: _backgroundColor,
      ),
      scaffoldBackgroundColor: _backgroundColor,
      appBarTheme: const AppBarTheme(
        backgroundColor: _primaryColor,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      textTheme: const TextTheme(
        headline1: TextStyle(
            fontSize: 24, fontWeight: FontWeight.bold, color: _textColor),
        headline2: TextStyle(
            fontSize: 22, fontWeight: FontWeight.bold, color: _textColor),
        headline3: TextStyle(
            fontSize: 20, fontWeight: FontWeight.bold, color: _textColor),
        headline4: TextStyle(
            fontSize: 18, fontWeight: FontWeight.bold, color: _textColor),
        headline5: TextStyle(
            fontSize: 16, fontWeight: FontWeight.bold, color: _textColor),
        headline6: TextStyle(
            fontSize: 14, fontWeight: FontWeight.bold, color: _textColor),
        bodyText1: TextStyle(fontSize: 16, color: _textColor),
        bodyText2: TextStyle(fontSize: 14, color: _secondaryTextColor),
      ),
      buttonTheme: ButtonThemeData(
        buttonColor: _primaryColor,
        textTheme: ButtonTextTheme.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: _primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: _primaryColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: _primaryColor, width: 2),
        ),
        labelStyle: const TextStyle(color: _secondaryTextColor),
      ),
      cardTheme: CardTheme(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  // Dark Theme (if needed)
  static ThemeData get darkTheme {
    // Implement dark theme here
    // For now, we'll return the light theme
    return lightTheme;
  }
}
