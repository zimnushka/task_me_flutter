import 'package:task_me_flutter/layers/repositories/api/api.dart';
import 'package:task_me_flutter/layers/repositories/local/config.dart';
import 'package:task_me_flutter/layers/repositories/local/user.dart';
import 'package:task_me_flutter/layers/repositories/session/task_me.dart';

class ClearService {
  final _userTokenStorage = UserTokenStorage();
  final _configStorage = ConfigStorage();

  Future<void> clearAllStorage() async {
    await _configStorage.delete();
    await _userTokenStorage.delete();
    ApiRepository.session = const TaskMeSession(token: '');
  }
}
