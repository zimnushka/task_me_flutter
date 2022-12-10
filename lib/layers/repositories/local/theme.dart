import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_me_flutter/layers/ui/styles/themes.dart';

class ThemeLocalRepository {
  Future<ThemeData> getTheme() async {
    final pref = await SharedPreferences.getInstance();
    final isLightTheme = pref.getBool('isLightTheme') ?? true;
    return isLightTheme ? lightTheme : darkTheme;
  }

  Future<bool> getThemeBool() async {
    final pref = await SharedPreferences.getInstance();
    return pref.getBool('isLightTheme') ?? true;
  }

  Future<void> setTheme({required bool isLight}) async {
    final pref = await SharedPreferences.getInstance();
    await pref.setBool('isLightTheme', isLight);
  }

  Future<void> deleteTheme() async {
    final pref = await SharedPreferences.getInstance();
    await pref.remove('isLightTheme');
  }
}
