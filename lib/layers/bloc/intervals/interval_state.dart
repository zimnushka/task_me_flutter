import 'package:task_me_flutter/app/bloc/states.dart';
import 'package:task_me_flutter/layers/models/schemes.dart';

class TimeIntervalUi {
  final TimeInterval interval;
  final User user;

  const TimeIntervalUi(this.interval, this.user);
}

class IntervalLoadedState extends AppLoadedState {
  final List<TimeIntervalUi> intervals;
  final int taskId;
  final bool readOnly;
  final User me;
  final TimeInterval? notClosedInterval;

  const IntervalLoadedState({
    required this.intervals,
    required this.taskId,
    required this.readOnly,
    required this.me,
    this.notClosedInterval,
  });
}

class IntervalLoadingState extends AppLoadingState {}
