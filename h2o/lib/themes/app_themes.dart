import 'package:flutter/material.dart';

enum AppTheme {
  LightTheme,
  DarkTheme,
  BlueTheme
}

final appThemeData = {
  AppTheme.LightTheme:ThemeData(
    brightness: Brightness.light,
    primaryColor: Colors.white,
    textTheme: TextTheme(
        headline1: TextStyle(
      color: Colors.black,
    ),
      headline2: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.grey[600])
    )
  ),
  AppTheme.DarkTheme:ThemeData(
    brightness: Brightness.dark,
    primaryColor: Colors.black,
      textTheme: TextTheme(
          headline1: TextStyle(
          color: Colors.white,
      ),
        headline2: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white)
      )
  ),
};