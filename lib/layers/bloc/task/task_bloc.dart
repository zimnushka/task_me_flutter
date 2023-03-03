import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_me_flutter/app/bloc/states.dart';
import 'package:task_me_flutter/app/models/error.dart';
import 'package:task_me_flutter/app/service/router.dart';
import 'package:task_me_flutter/app/service/snackbar.dart';
import 'package:task_me_flutter/layers/bloc/task/task_event.dart';
import 'package:task_me_flutter/layers/bloc/task/task_state.dart';
import 'package:task_me_flutter/layers/models/schemes.dart';
import 'package:task_me_flutter/layers/repositories/api/user.dart';
import 'package:task_me_flutter/layers/service/task.dart';

class TaskBloc extends Bloc<TaskEvent, AppState> {
  final Function(int) _onTaskClick;
  final _taskService = TaskService();
  final _userApiRepository = UserApiRepository();

  TaskBloc(
    this._onTaskClick,
    List<TaskUi> tasks,
    TaskViewState state,
  ) : super(TaskState(
          tasks: tasks,
          filteredTasks: tasks,
          filter: const TaskViewFilterModel(openedStatuses: TaskStatus.values),
          state: state,
        )) {
    on<OnTaskTap>(_onTaskTap);
    on<OnTaskStatusTap>(_onTaskStatusTap);
    on<OnChangeViewState>(_onChangeViewState);
    on<OnChangeTaskStatus>(_onChangeTaskStatus);
    on<OnTaskFilterChange>(_onTaskFilterChange);
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

    if (currentState.filter.openedStatuses.contains(event.status)) {
      final statuses = List.of(currentState.filter.openedStatuses);
      statuses.remove(event.status);
      emit(
        currentState.copyWith(
          filter: currentState.filter.copyWith(openedStatuses: statuses),
        ),
      );
    } else {
      final statuses = List.of(currentState.filter.openedStatuses);
      statuses.add(event.status);
      emit(
        currentState.copyWith(
          filter: currentState.filter.copyWith(openedStatuses: statuses),
        ),
      );
    }
  }

  Future<void> _onChangeTaskStatus(OnChangeTaskStatus event, Emitter emit) async {
    final currentState = state as TaskState;
    try {
      final projectUsers =
          (await _userApiRepository.getUserFromProject(event.taskUi.task.projectId)).data ?? [];
      if (await _taskService.editTaskStatus(event.taskUi.task, event.status, projectUsers)) {
        final List<TaskUi> taskUIList = List.of(currentState.tasks);
        taskUIList.removeWhere((element) => element.task.id == event.taskUi.task.id);
        taskUIList
            .add(event.taskUi.copyWith(task: event.taskUi.task.copyWith(status: event.status)));
        taskUIList.sort((a, b) => a.task.status.index.compareTo(b.task.status.index));
        emit(
          TaskState(
            tasks: taskUIList,
            filteredTasks: currentState.filteredTasks,
            state: currentState.state,
            filter: currentState.filter,
          ),
        );
      }
    } on LogicalException catch (e) {
      AppSnackBar.show(AppRouter.context, e.message, AppSnackBarType.error);
    } catch (e) {
      AppSnackBar.show(AppRouter.context, e.toString(), AppSnackBarType.error);
    }
  }

  Future<void> _onTaskFilterChange(OnTaskFilterChange event, Emitter emit) async {
    final currentState = state as TaskState;
    if (event.filter != currentState.filter) {
      final filteredTasks = event.filter.getTaskByFilter(currentState.tasks);
      emit(
        currentState.copyWith(
          filteredTasks: filteredTasks,
          filter: event.filter,
        ),
      );
    }
  }
}
