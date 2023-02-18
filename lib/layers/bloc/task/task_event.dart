import 'package:task_me_flutter/layers/bloc/task/task_state.dart';
import 'package:task_me_flutter/layers/models/schemes.dart';

abstract class TaskEvent {}

class OnTaskTap extends TaskEvent {
  final int id;
  OnTaskTap(this.id);
}

class OnChangeViewState extends TaskEvent {
  final TaskViewState state;
  OnChangeViewState(this.state);
}

class OnChangeTaskStatus extends TaskEvent {
  final TaskStatus status;
  final TaskUi taskUi;
  OnChangeTaskStatus(this.taskUi, this.status);
}

class OnTaskStatusTap extends TaskEvent {
  final TaskStatus status;
  OnTaskStatusTap(this.status);
}
