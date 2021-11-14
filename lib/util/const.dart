import 'dart:ui';
import 'package:flutter/material.dart';

class Constants {
  static String appName = "MedCert";

  //Colors for theme
  static Color lightPrimary = Colors.blue.shade600;
  static Color lightTextPrimary = Colors.white;
  static Color darkTextPrimary = Colors.white;
  static Color darkNavbarBackGround = Color(0xff424242);
  static Color primaryVariant = Color(0xfffdfdff);
  static Color darkPrimary = Colors.black;
  static Color onDarkPrimary = Colors.white;
  static Color lightAccent = Color(0xff5563ff);
  static Color darkAccent = Color(0xff5563ff);
  static Color lightBG = Color(0xfffcfcff);
  static Color darkBG = Colors.black;
  static Color onDarkBG = Colors.white;
  static Color ratingBG = Colors.yellow.shade700;
  static Color error = Colors.red.shade700;

  static ThemeData lightTheme = ThemeData(
    backgroundColor: lightBG,
    primaryColor: lightPrimary,
    scaffoldBackgroundColor: lightBG,
    colorScheme: ColorScheme(
        primary: lightPrimary,
        primaryVariant: primaryVariant,
        secondary: lightAccent,
        secondaryVariant: darkAccent,
        surface: lightBG,
        background: lightBG,
        error: error,
        onPrimary: lightTextPrimary,
        onSecondary: lightPrimary,
        onSurface: darkBG,
        onBackground: darkBG,
        onError: lightBG,
        brightness: Brightness.light),
    appBarTheme: AppBarTheme(
      toolbarTextStyle: TextStyle(
        color: lightTextPrimary,
        fontSize: 18.0,
        fontWeight: FontWeight.w800,
      ),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    backgroundColor: darkBG,
    primaryColor: darkPrimary,
    accentColor: darkAccent,
    scaffoldBackgroundColor: darkBG,
    cursorColor: darkAccent,
    appBarTheme: AppBarTheme(
        toolbarTextStyle: TextStyle(
          color: lightBG,
          fontSize: 18.0,
          fontWeight: FontWeight.w800,
        ),
        backgroundColor: darkNavbarBackGround),
    colorScheme: ColorScheme(
        primary: darkPrimary,
        primaryVariant: primaryVariant,
        secondary: darkAccent,
        secondaryVariant: darkAccent,
        surface: darkBG,
        background: darkBG,
        error: error,
        onPrimary: onDarkPrimary,
        onSecondary: onDarkPrimary,
        onSurface: onDarkBG,
        onBackground: onDarkBG,
        onError: darkBG,
        brightness: Brightness.dark),
  );
}
