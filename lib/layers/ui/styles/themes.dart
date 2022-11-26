import 'package:flutter/material.dart';

ThemeData lightTheme = ThemeData.light().copyWith();
ThemeData darkTheme = ThemeData.dark().copyWith();

ThemeData setPrimaryColor(ThemeData data, Color color) {
  return data.copyWith(
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: color,
      selectionColor: Colors.grey,
      selectionHandleColor: Colors.grey,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(radius),
          borderSide: BorderSide(color: Colors.transparent, width: 1)),
      enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(radius),
          borderSide: BorderSide(color: Colors.transparent, width: 1)),
      focusedBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(radius),
          borderSide: BorderSide(color: color, width: 1)),
      disabledBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(radius),
          borderSide: BorderSide(color: color, width: 1)),
    ),
    primaryColor: color,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(radius))),
    ),
    textButtonTheme: TextButtonThemeData(style: TextButton.styleFrom(foregroundColor: color)),
    floatingActionButtonTheme: FloatingActionButtonThemeData(backgroundColor: color),
    backgroundColor: data.scaffoldBackgroundColor,
    scaffoldBackgroundColor: data.scaffoldBackgroundColor,
  );
}

const defaultPrimaryColor = Color.fromARGB(255, 76, 175, 158);

const radius = Radius.circular(10);
