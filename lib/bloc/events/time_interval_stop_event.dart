import 'package:task_me_flutter/bloc/main_event.dart';

class TimeIntervalStopEvent extends MainEvent {
  TimeIntervalStopEvent({this.desc});
  final String? desc;
}
