part of 'local_storage.dart';

extension ConfigStorage on LocalStorage {
  String get storageKey => 'configStorageKey';

  Future<Config?> getConfig() async {
    final pref = await SharedPreferences.getInstance();
    try {
      final configData = (pref.getString(storageKey)) ?? '';
      final Map<String, dynamic> json = jsonDecode(configData);
      return Config.fromJson(json);
    } catch (e) {
      return null;
    }
  }

  Future<bool> saveConfig(Config config) async {
    final pref = await SharedPreferences.getInstance();
    try {
      return await pref.setString(storageKey, jsonEncode(config.toJson()));
    } catch (e) {
      return false;
    }
  }

  Future<bool> deleteConfig() async {
    final pref = await SharedPreferences.getInstance();
    try {
      return await pref.remove(storageKey);
    } catch (e) {
      return false;
    }
  }
}
