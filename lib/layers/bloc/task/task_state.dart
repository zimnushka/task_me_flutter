import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
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

class TaskState {
  final List<TaskUi> tasks;
  final List<TaskUi> filteredTasks;
  final TaskViewFilterModel filter;
  final TaskViewState state;

  TaskState({
    required this.tasks,
    required this.state,
    required this.filteredTasks,
    required this.filter,
  });

  TaskState copyWith({
    List<TaskUi>? tasks,
    TaskViewState? state,
    List<TaskUi>? filteredTasks,
    TaskViewFilterModel? filter,
  }) {
    return TaskState(
      state: state ?? this.state,
      tasks: tasks ?? this.tasks,
      filter: filter ?? this.filter,
      filteredTasks: filteredTasks ?? this.filteredTasks,
    );
  }
}
