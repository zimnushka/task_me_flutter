// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:task_me_flutter/app/bloc/states.dart';
import 'package:task_me_flutter/layers/models/schemes.dart';

enum TaskDetailPageState { done, edit, creation }

class TaskDetailLoadState extends AppLoadingState {}

class TaskDetailState extends AppLoadedState {
  final int projectId;
  final List<User> users;
  final Task? task;
  final User? assigner;
  final Task editedTask;
  final TaskDetailPageState state;

  TaskDetailState({
    required this.task,
    required this.editedTask,
    required this.users,
    required this.projectId,
    this.assigner,
    this.state = TaskDetailPageState.creation,
  });

  TaskDetailState copyWith({
    int? projectId,
    List<User>? users,
    Task? task,
    Task? editedTask,
    TaskDetailPageState? state,
  }) {
    return TaskDetailState(
      projectId: projectId ?? this.projectId,
      users: users ?? this.users,
      task: task ?? this.task,
      editedTask: editedTask ?? this.editedTask,
      state: state ?? this.state,
    );
  }
}
