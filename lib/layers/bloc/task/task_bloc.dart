import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_me_flutter/app/bloc/states.dart';
import 'package:task_me_flutter/layers/bloc/task/task_event.dart';
import 'package:task_me_flutter/layers/bloc/task/task_state.dart';
import 'package:task_me_flutter/layers/models/schemes.dart';

class TaskBloc extends Bloc<TaskEvent, AppState> {
  final Function(int) _onTaskClick;

  TaskBloc(this._onTaskClick, List<TaskUi> tasks)
      : super(TaskState(
          tasks: tasks,
          openedStatuses: TaskStatus.values,
          state: TaskViewState.list,
        )) {
    on<OnTaskTap>(_onTaskTap);
    on<OnTaskStatusTap>(_onTaskStatusTap);
    on<OnChangeViewState>(_onChangeViewState);
  }

  Future<void> _onTaskTap(OnTaskTap event, Emitter emit) async {
    _onTaskClick(event.id);
  }

  Future<void> _onChangeViewState(OnChangeViewState event, Emitter emit) async {
    final currentState = state as TaskState;
    if (currentState.state != event.state) {
      emit(currentState.copyWith(state: event.state));
    }
  }

  Future<void> _onTaskStatusTap(OnTaskStatusTap event, Emitter emit) async {
    final currentState = state as TaskState;

    if (currentState.openedStatuses.contains(event.status)) {
      final statuses = List.of(currentState.openedStatuses);
      statuses.remove(event.status);
      emit(currentState.copyWith(openedStatuses: statuses));
    } else {
      final statuses = List.of(currentState.openedStatuses);
      statuses.add(event.status);
      emit(currentState.copyWith(openedStatuses: statuses));
    }
  }
}
