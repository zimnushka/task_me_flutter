import 'package:task_me_flutter/bloc/main_event.dart';
import 'package:task_me_flutter/domain/models/schemes.dart';

class SetConfigEvent extends MainEvent {
  SetConfigEvent(this.config);
  final Config config;
}
