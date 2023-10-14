import 'package:task_me_flutter/bloc/main_event.dart';

class TimeIntervalStartEvent extends MainEvent {
  final int taskId;

  TimeIntervalStartEvent({required this.taskId});
}
