// ignore_for_file: public_member_api_docs, sort_constructors_first, avoid_equals_and_hash_code_on_mutable_classes
import 'package:flutter/foundation.dart';

import 'package:task_me_flutter/app/bloc/states.dart';
import 'package:task_me_flutter/layers/models/schemes.dart';

enum TaskDetailPageState { view, edit, creation }

class TaskDetailLoadState extends AppLoadingState {}

class TaskDetailState extends AppLoadedState {
  final int projectId;
  final List<User> users;
  final Task? task;
  final List<User> assigners;
  final Task editedTask;
  final TaskDetailPageState state;

  const TaskDetailState({
    required this.task,
    required this.editedTask,
    required this.users,
    required this.projectId,
    required this.assigners,
    this.state = TaskDetailPageState.creation,
  });

  TaskDetailState copyWith({
    int? projectId,
    List<User>? users,
    List<User>? assigners,
    Task? task,
    Task? editedTask,
    TaskDetailPageState? state,
  }) {
    return TaskDetailState(
      assigners: assigners ?? this.assigners,
      projectId: projectId ?? this.projectId,
      users: users ?? this.users,
      task: task ?? this.task,
      editedTask: editedTask ?? this.editedTask,
      state: state ?? this.state,
    );
  }

  @override
  bool operator ==(covariant AppState other) {
    if (other is TaskDetailState) {
      if (identical(this, other)) {
        return true;
      }

      return other.projectId == projectId &&
          listEquals(other.users, users) &&
          other.task == task &&
          listEquals(other.assigners, assigners) &&
          other.editedTask == editedTask &&
          other.state == state;
    }
    return false;
  }

  @override
  int get hashCode {
    return projectId.hashCode ^
        users.hashCode ^
        task.hashCode ^
        assigners.hashCode ^
        editedTask.hashCode ^
        state.hashCode;
  }
}
