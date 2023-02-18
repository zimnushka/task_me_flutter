// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:task_me_flutter/app/bloc/states.dart';
import 'package:task_me_flutter/layers/models/schemes.dart';

enum TaskViewState { board, list }

class TaskState extends AppLoadedState {
  final List<TaskUi> tasks;
  final List<TaskStatus> openedStatuses;
  final TaskViewState state;

  TaskState({required this.tasks, required this.openedStatuses, required this.state});

  TaskState copyWith(
      {List<TaskUi>? tasks, List<TaskStatus>? openedStatuses, TaskViewState? state}) {
    return TaskState(
      state: state ?? this.state,
      tasks: tasks ?? this.tasks,
      openedStatuses: openedStatuses ?? this.openedStatuses,
    );
  }
}
