import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_me_flutter/app/bloc/states.dart';
import 'package:task_me_flutter/app/models/error.dart';
import 'package:task_me_flutter/app/service/router.dart';
import 'package:task_me_flutter/app/service/snackbar.dart';
import 'package:task_me_flutter/layers/bloc/task_detail/task_event.dart';
import 'package:task_me_flutter/layers/bloc/task_detail/task_state.dart';
import 'package:task_me_flutter/layers/models/schemes.dart';
import 'package:task_me_flutter/layers/repositories/api/user.dart';
import 'package:task_me_flutter/layers/service/task.dart';

class TaskDetailBloc extends Bloc<TaskDetailEvent, AppState> {
  final _taskService = TaskService();
  final _userApiRepository = UserApiRepository();

  TaskDetailBloc() : super(TaskDetailLoadState()) {
    on<Load>(_load);
    on<OnDeleteTask>(_delete);
    on<OnSubmit>(_submit);
    on<OnTaskStatusSwap>(_onTaskStatusSwap);
    on<OnUserListChange>(_onUserSwap);
    on<OnDescriptionUpdate>(_onDescriptionUpdate);
    on<OnTitleUpdate>(_onTitleUpdate);
  }

  Future<void> _load(Load event, Emitter emit) async {
    emit(TaskDetailLoadState());
    final usersData = await _userApiRepository.getUserFromProject(event.projectId);
    if (event.taskId != null) {
      final assigners = await _taskService.getTaskMembers(event.taskId!);
      final task = await _taskService.getTaskById(event.taskId!);
      if (task != null) {
        final users = usersData.data ?? [];

        emit(TaskDetailState(
            assigners: assigners,
            task: task,
            editedTask: task,
            users: users,
            projectId: event.projectId,
            state: task.status == TaskStatus.closed
                ? TaskDetailPageState.view
                : TaskDetailPageState.edit));
        return;
      }
    }
    emit(
      TaskDetailState(
        task: null,
        assigners: [],
        editedTask: Task(
          stopDate: null,
          title: '',
          description: '',
          projectId: event.projectId,
          startDate: DateTime.now(),
          cost: 0,
          status: TaskStatus.open,
        ),
        users: usersData.data ?? [],
        projectId: event.projectId,
        state: TaskDetailPageState.creation,
      ),
    );
  }

  Future<void> _delete(OnDeleteTask event, Emitter emit) async {
    final currentState = state as TaskDetailState;
    if (currentState.task != null) {
      final responce = await _taskService.deleteTask(currentState.task!.id!);
      if (responce) {
        add(Load(projectId: currentState.projectId));
      } else {
        AppSnackBar.show(AppRouter.context, 'Delete error', AppSnackBarType.error);
      }
    }
  }

  Future<void> _submit(OnSubmit event, Emitter emit) async {
    final currentState = state as TaskDetailState;
    try {
      if (currentState.editedTask.id != null) {
        await _taskService.editTask(currentState.editedTask, currentState.users);
        AppSnackBar.show(AppRouter.context, 'Edited', AppSnackBarType.success);
        add(Load(projectId: currentState.editedTask.projectId, taskId: currentState.editedTask.id));
      } else {
        final newTask = await _taskService.addTask(currentState.editedTask);
        AppSnackBar.show(AppRouter.context, 'Created', AppSnackBarType.success);
        add(Load(projectId: newTask.projectId, taskId: newTask.id));
      }
    } on LogicalException catch (e) {
      AppSnackBar.show(AppRouter.context, e.message, AppSnackBarType.error);
    } catch (e) {
      AppSnackBar.show(AppRouter.context, e.toString(), AppSnackBarType.error);
    }
  }

  Future<void> _onTaskStatusSwap(OnTaskStatusSwap event, Emitter emit) async {
    final currentState = state as TaskDetailState;
    final task = currentState.editedTask.copyWith(status: event.status);
    emit(currentState.copyWith(editedTask: task));
  }

  Future<void> _onUserSwap(OnUserListChange event, Emitter emit) async {
    final currentState = state as TaskDetailState;
    try {
      await _taskService.editTaskMemberList(currentState.task!, event.users);
      // ignore: empty_catches
    } catch (e) {}

    emit(TaskDetailState(
      assigners: List.of(event.users),
      state: currentState.state,
      task: currentState.task,
      editedTask: currentState.editedTask,
      users: currentState.users,
      projectId: currentState.projectId,
    ));
  }

  Future<void> _onTitleUpdate(OnTitleUpdate event, Emitter emit) async {
    final currentState = state as TaskDetailState;

    emit(currentState.copyWith(editedTask: currentState.editedTask.copyWith(title: event.value)));
  }

  Future<void> _onDescriptionUpdate(OnDescriptionUpdate event, Emitter emit) async {
    final currentState = state as TaskDetailState;

    emit(
      currentState.copyWith(
        editedTask: currentState.editedTask.copyWith(
          description: event.value,
        ),
      ),
    );
  }
}
