import 'package:task_me_flutter/bloc/main_event.dart';

class LoginEvent extends MainEvent {
  final String token;

  LoginEvent({required this.token});
}
