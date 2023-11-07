import 'package:task_me_flutter/bloc/main_event.dart';
import 'package:task_me_flutter/domain/models/schemes.dart';

class EditUserEvent extends MainEvent {
  final User user;

  EditUserEvent({required this.user});
}
