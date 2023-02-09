import 'package:task_me_flutter/layers/models/schemes.dart';

abstract class TaskDetailEvent {}

class Load extends TaskDetailEvent {
  final int projectId;
  final int? taskId;

  Load({required this.projectId, this.taskId});
}

class OnTaskStatusSwap extends TaskDetailEvent {
  final TaskStatus status;
  OnTaskStatusSwap(this.status);
}

class OnUserListChange extends TaskDetailEvent {
  final List<User> users;
  OnUserListChange(this.users);
}

class OnDeleteTask extends TaskDetailEvent {}

class OnDescriptionUpdate extends TaskDetailEvent {
  final String value;
  OnDescriptionUpdate(this.value);
}

class OnTitleUpdate extends TaskDetailEvent {
  final String value;
  OnTitleUpdate(this.value);
}

class OnSubmit extends TaskDetailEvent {}
