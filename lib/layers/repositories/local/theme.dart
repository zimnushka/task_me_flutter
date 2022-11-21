import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_me_flutter/layers/ui/styles/themes.dart';

class ThemeLocalRepository {
  Future<ThemeData> getTheme() async {
    final pref = await SharedPreferences.getInstance();
    final isLightTheme = pref.getBool('isLightTheme') ?? true;
    return isLightTheme ? lightTheme : darkTheme;
  }

  Future<Color> getColor() async {
    final pref = await SharedPreferences.getInstance();
    final colorValue = pref.getInt('primaryColor');
    return colorValue != null ? Color(colorValue) : defaultPrimaryColor;
  }

  Future<void> setTheme({required bool isLight}) async {
    final pref = await SharedPreferences.getInstance();
    await pref.setBool('isLightTheme', isLight);
  }

  Future<void> setColor(int value) async {
    final pref = await SharedPreferences.getInstance();
    await pref.setInt('primaryColor', value);
  }

  Future<void> deleteTheme() async {
    final pref = await SharedPreferences.getInstance();
    await pref.remove('isLightTheme');
  }

  Future<void> deleteColor() async {
    final pref = await SharedPreferences.getInstance();
    await pref.remove('primaryColor');
  }
}
