import 'package:task_me_flutter/layers/repositories/session/session.dart';

class TaskMeSession implements Session {
  final String token;

  const TaskMeSession({required this.token});

  @override
  Map<String, String> sign() {
    return {'Authorization': token};
  }
}
