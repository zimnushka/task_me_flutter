import 'package:task_me_flutter/app/configs.dart';
import 'package:task_me_flutter/layers/models/schemes.dart';
import 'package:task_me_flutter/layers/repositories/local/config.dart';

class ConfigService {
  final _configStorage = ConfigStorage();

  // ignore: avoid_positional_boolean_parameters
  Future<Config> setNewBrightness(bool isLight) async {
    final config = await getConfig() ?? defaultConfig;
    final newConfig = config.copyWith(isLightTheme: isLight);
    await setConfig(newConfig);
    return newConfig;
  }

  Future<Config?> getConfig() async {
    return _configStorage.getConfig();
  }

  Future<bool> setConfig(Config data) async {
    return _configStorage.setConfig(data);
  }

  Future<bool> clear() async {
    return _configStorage.deleteConfig();
  }
}
