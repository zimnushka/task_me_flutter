// ignore_for_file: avoid_positional_boolean_parameters

import 'package:flutter/material.dart';
import 'package:task_me_flutter/app/configs.dart';
import 'package:task_me_flutter/layers/models/schemes.dart';
import 'package:task_me_flutter/layers/repositories/local/config.dart';

class ConfigService {
  final _configStorage = ConfigStorage();

  Future<ThemeData> getTheme() async {
    final config = await getConfig() ?? defaultConfig;
    return config.theme;
  }

  Future<Config> setNewBright(bool isLight) async {
    final config = await getConfig() ?? defaultConfig;
    final newConfig = config.copyWith(isLightTheme: isLight);
    await setConfig(newConfig);
    return newConfig;
  }

  Future<Config?> getConfig() async {
    return _configStorage.get();
  }

  Future<bool> setConfig(Config data) async {
    return _configStorage.save(data);
  }

  Future<bool> clear() async {
    return _configStorage.delete();
  }
}
