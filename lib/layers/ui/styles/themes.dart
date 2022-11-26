import 'package:flutter/material.dart';

ThemeData lightTheme = ThemeData.light().copyWith();
ThemeData darkTheme = ThemeData.dark().copyWith();

ThemeData setPrimaryColor(ThemeData data, Color color) {
  return data.copyWith(
    primaryColor: color,
    buttonTheme: ButtonThemeData(buttonColor: color),
    floatingActionButtonTheme: FloatingActionButtonThemeData(backgroundColor: color),
    backgroundColor: data.scaffoldBackgroundColor,
    scaffoldBackgroundColor: data.scaffoldBackgroundColor,
  );
}

const defaultPrimaryColor = Colors.green;

const radius = Radius.circular(10);
