import 'package:task_me_flutter/app/bloc/states.dart';
import 'package:task_me_flutter/layers/models/schemes.dart';

class IntervalLoadedState extends AppLoadedState {
  final List<TimeInterval> intervals;
  final List<TimeInterval> notClosedInterval;
  final int? taskId;
  final bool readOnly;
  final User me;

  const IntervalLoadedState({
    required this.intervals,
    required this.taskId,
    required this.readOnly,
    required this.me,
    required this.notClosedInterval,
  });
}

class IntervalLoadingState extends AppLoadingState {}
