import 'package:flutter/material.dart';
import 'package:task_me_flutter/domain/configs.dart';
import 'package:task_me_flutter/domain/models/schemes.dart';
import 'package:task_me_flutter/repositories/local/config.dart';

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

  Future<Config> setNewTaskView(TaskViewState state) async {
    final config = await getConfig() ?? defaultConfig;
    final newConfig = config.copyWith(taskView: state);
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
