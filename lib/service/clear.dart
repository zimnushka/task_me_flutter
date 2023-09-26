import 'package:task_me_flutter/repositories/api/api.dart';
import 'package:task_me_flutter/repositories/local/config.dart';
import 'package:task_me_flutter/repositories/local/user.dart';
import 'package:task_me_flutter/repositories/session/task_me.dart';

class ClearService {
  final _userTokenStorage = UserTokenStorage();
  final _configStorage = ConfigStorage();

  Future<void> clearAllStorage() async {
    await _configStorage.delete();
    await _userTokenStorage.delete();
    ApiRepository.session = const TaskMeSession(token: '');
  }
}
