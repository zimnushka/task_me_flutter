import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_me_flutter/layers/models/schemes.dart';

class ConfigStorage {
  static const String storageKet = 'configStorageKey';

  Future<Config?> getConfig() async {
    final pref = await SharedPreferences.getInstance();
    try {
      final configData = (pref.getString(storageKet)) ?? '';
      final Map<String, dynamic> json = jsonDecode(configData);
      return Config.fromJson(json);
    } catch (e) {
      return null;
    }
  }

  Future<bool> setConfig(Config config) async {
    final pref = await SharedPreferences.getInstance();
    try {
      return await pref.setString(storageKet, jsonEncode(config.toJson()));
    } catch (e) {
      return false;
    }
  }

  Future<bool> deleteConfig() async {
    final pref = await SharedPreferences.getInstance();
    try {
      return await pref.remove(storageKet);
    } catch (e) {
      return false;
    }
  }
}
