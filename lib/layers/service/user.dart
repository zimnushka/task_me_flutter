import 'package:task_me_flutter/layers/models/schemes.dart';
import 'package:task_me_flutter/layers/repositories/api/api.dart';
import 'package:task_me_flutter/layers/repositories/api/user.dart';
import 'package:task_me_flutter/layers/repositories/local/user.dart';
import 'package:task_me_flutter/layers/repositories/session/task_me.dart';
import 'package:task_me_flutter/layers/service/clear.dart';

class UserService {
  final _userTokenStorage = UserTokenStorage();
  final _userApiRepository = UserApiRepository();
  final _clearService = ClearService();

  Future<User?> getUserFromToken() async {
    try {
      final token = await _userTokenStorage.get();
      if (token != null) {
        ApiRepository.session = TaskMeSession(token: token);
        final userData = await _userApiRepository.getUserMe();
        return userData.data;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<User?> editUser(User user) async {
    try {
      return (await _userApiRepository.editUser(user)).data;
    } catch (e) {
      return null;
    }
  }

  Future<bool> saveToken(String token) async {
    try {
      return _userTokenStorage.save(token);
    } catch (e) {
      return false;
    }
  }

  Future<void> logOut() async {
    await _clearService.clearAllStorage();
  }
}
