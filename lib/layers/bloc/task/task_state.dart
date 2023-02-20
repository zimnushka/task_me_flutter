// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:task_me_flutter/app/bloc/states.dart';
import 'package:task_me_flutter/layers/models/schemes.dart';

enum TaskViewState {
  @JsonValue(0)
  board,
  @JsonValue(1)
  list
}

extension TaskViewStateInfo on TaskViewState {
  String get label {
    switch (this) {
      case TaskViewState.board:
        return 'Board';
      case TaskViewState.list:
        return 'List';
    }
  }

  IconData get icon {
    switch (this) {
      case TaskViewState.board:
        return Icons.auto_awesome_mosaic_outlined;
      case TaskViewState.list:
        return Icons.sort;
    }
  }
}

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
