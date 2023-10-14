part of 'local_storage.dart';

extension TokenStorage on LocalStorage {
  String get storageKey => 'userToken';

  Future<String?> getToken() async {
    final pref = await SharedPreferences.getInstance();
    return pref.getString(storageKey);
  }

  Future<bool> saveToken(String token) async {
    final pref = await SharedPreferences.getInstance();
    try {
      return pref.setString(storageKey, token);
    } catch (e) {
      return false;
    }
  }

  Future<bool> deleteToken() async {
    final pref = await SharedPreferences.getInstance();
    try {
      return pref.remove(storageKey);
    } catch (e) {
      return false;
    }
  }
}
