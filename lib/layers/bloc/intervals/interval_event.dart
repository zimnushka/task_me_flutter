import 'package:task_me_flutter/layers/models/schemes.dart';

abstract class IntervalEvent {}

class Load extends IntervalEvent {
  final int? taskId;
  final bool readOnly;
  final User me;

  // ignore: avoid_positional_boolean_parameters
  Load(this.taskId, this.readOnly, this.me);
}

class OnTapStart extends IntervalEvent {
  final int taskId;
  OnTapStart(this.taskId);
}

class OpenTask extends IntervalEvent {
  final int taskId;
  final int projectId;
  OpenTask(this.taskId, this.projectId);
}

class OnTapStop extends IntervalEvent {
  OnTapStop();
}
