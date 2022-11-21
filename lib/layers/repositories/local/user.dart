import 'package:shared_preferences/shared_preferences.dart';

class UserLocalRepository {
  Future<String?> getUser() async {
    final pref = await SharedPreferences.getInstance();
    return pref.getString('userToken');
  }

  Future<void> setUser(String token) async {
    final pref = await SharedPreferences.getInstance();
    await pref.setString('userToken', token);
  }

  Future<void> deleteUser() async {
    final pref = await SharedPreferences.getInstance();
    await pref.remove('userToken');
  }
}
