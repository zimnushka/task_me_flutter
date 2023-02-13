import 'package:task_me_flutter/layers/models/schemes.dart';

abstract class IntervalEvent {}

class Load extends IntervalEvent {
  final int taskId;
  final bool readOnly;
  final List<User> users;
  final User me;

  // ignore: avoid_positional_boolean_parameters
  Load(this.taskId, this.readOnly, this.users, this.me);
}

class OnTapStart extends IntervalEvent {}

class OnTapStop extends IntervalEvent {}
