import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_me_flutter/domain/models/schemes.dart';

part 'config.dart';
part 'user.dart';

class LocalStorage {
  Future<void> clear() async {
    final pref = await SharedPreferences.getInstance();
    await pref.clear();
  }
}
