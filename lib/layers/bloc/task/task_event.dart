import 'package:task_me_flutter/layers/models/schemes.dart';

abstract class TaskEvent {}

class OnTaskTap extends TaskEvent {
  final int id;
  OnTaskTap(this.id);
}

class OnTaskStatusTap extends TaskEvent {
  final TaskStatus status;
  OnTaskStatusTap(this.status);
}
