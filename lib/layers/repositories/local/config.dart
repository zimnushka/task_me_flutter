import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_me_flutter/layers/models/schemes.dart';
import 'package:task_me_flutter/layers/repositories/storage.dart';

class ConfigStorage implements AppStorage<Config> {
  @override
  String get storageKey => 'configStorageKey';

  @override
  Future<Config?> get() async {
    final pref = await SharedPreferences.getInstance();
    try {
      final configData = (pref.getString(storageKey)) ?? '';
      final Map<String, dynamic> json = jsonDecode(configData);
      return Config.fromJson(json);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<bool> save(Config config) async {
    final pref = await SharedPreferences.getInstance();
    try {
      return await pref.setString(storageKey, jsonEncode(config.toJson()));
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> delete() async {
    final pref = await SharedPreferences.getInstance();
    try {
      return await pref.remove(storageKey);
    } catch (e) {
      return false;
    }
  }
}
