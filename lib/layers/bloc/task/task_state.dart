// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:task_me_flutter/app/bloc/states.dart';
import 'package:task_me_flutter/layers/models/schemes.dart';

class TaskState extends AppLoadedState {
  final List<TaskUi> tasks;
  final List<TaskStatus> openedStatuses;

  TaskState({required this.tasks, required this.openedStatuses});

  TaskState copyWith({
    List<TaskUi>? tasks,
    List<TaskStatus>? openedStatuses,
  }) {
    return TaskState(
      tasks: tasks ?? this.tasks,
      openedStatuses: openedStatuses ?? this.openedStatuses,
    );
  }
}
