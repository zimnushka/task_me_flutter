import 'package:flutter/material.dart';

ThemeData lightTheme =
    ThemeData.light().copyWith(scaffoldBackgroundColor: const Color.fromARGB(255, 225, 225, 225));
ThemeData darkTheme = ThemeData.dark().copyWith();

ThemeData setPrimaryColor(ThemeData data, Color color) {
  return data.copyWith(
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: color,
        selectionColor: Colors.grey.withOpacity(0.3),
        selectionHandleColor: Colors.grey.withOpacity(0.3),
      ),
      cardTheme:
          const CardTheme(shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(radius))),
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
      colorScheme: data.colorScheme.copyWith(background: data.scaffoldBackgroundColor),
      scaffoldBackgroundColor: data.scaffoldBackgroundColor,
      listTileTheme: ListTileThemeData(
          selectedColor: color,
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(radius))));
}

const defaultPrimaryColor = Color.fromARGB(255, 76, 175, 158);

const radius = Radius.circular(10);
const double defaultPadding = 20;

const double kSideBarWidth = 230;
