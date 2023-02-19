import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_me_flutter/layers/repositories/storage.dart';

class UserTokenStorage implements AppStorage<String> {
  @override
  String get storageKey => 'userToken';

  @override
  Future<String?> get() async {
    final pref = await SharedPreferences.getInstance();
    return pref.getString(storageKey);
  }

  @override
  Future<bool> save(String token) async {
    final pref = await SharedPreferences.getInstance();
    try {
      return pref.setString(storageKey, token);
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> delete() async {
    final pref = await SharedPreferences.getInstance();
    try {
      return pref.remove(storageKey);
    } catch (e) {
      return false;
    }
  }
}
