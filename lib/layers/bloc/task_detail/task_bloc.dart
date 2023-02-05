import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_me_flutter/app/bloc/states.dart';
import 'package:task_me_flutter/app/service/router.dart';
import 'package:task_me_flutter/app/service/snackbar.dart';
import 'package:task_me_flutter/layers/bloc/task_detail/task_event.dart';
import 'package:task_me_flutter/layers/bloc/task_detail/task_state.dart';
import 'package:task_me_flutter/layers/models/schemes.dart';
import 'package:task_me_flutter/layers/repositories/api/task.dart';
import 'package:task_me_flutter/layers/repositories/api/user.dart';
import 'package:task_me_flutter/layers/ui/kit/overlays/hour_selector.dart';

class TaskDetailBloc extends Bloc<TaskDetailEvent, AppState> {
  final _taskApiRepository = TaskApiRepository();
  final _userApiRepository = UserApiRepository();

  TaskDetailBloc() : super(TaskDetailLoadState()) {
    on<Load>(_load);
    on<OnDeleteTask>(_delete);
    on<OnSubmit>(_submit);
    on<OnTaskStatusSwap>(_onTaskStatusSwap);
    on<OnUserSwap>(_onUserSwap);
    on<OnDescriptionUpdate>(_onDescriptionUpdate);
    on<OnTitleUpdate>(_onTitleUpdate);
  }

  Future<void> _load(Load event, Emitter emit) async {
    emit(TaskDetailLoadState());
    final usersData = await _userApiRepository.getUserFromProject(event.projectId);
    if (event.taskId != null) {
      final taskData = await _taskApiRepository.getById(event.taskId!);
      if (taskData.data != null) {
        final users = usersData.data ?? [];
        final _usersWithAssignerId = users.where((user) => user.id == taskData.data!.assignerId);
        final User? selectedUser = _usersWithAssignerId.isEmpty ? null : _usersWithAssignerId.first;
        emit(TaskDetailState(
            assigner: selectedUser,
            task: taskData.data,
            editedTask: taskData.data!,
            users: users,
            projectId: event.projectId,
            state: taskData.data!.status == TaskStatus.done
                ? TaskDetailPageState.done
                : TaskDetailPageState.edit));
        return;
      }
    }
    emit(
      TaskDetailState(
        task: null,
        editedTask: Task(
          title: '',
          description: '',
          projectId: event.projectId,
          dueDate: DateTime.now(),
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
      await _taskApiRepository.delete(currentState.task!.id!);
      add(Load(projectId: currentState.projectId));
    } else {
      AppSnackBar.show(AppRouter.context, 'Task was not save, can`t delete', AppSnackBarType.info);
    }
  }

  Future<void> _submit(OnSubmit event, Emitter emit) async {
    final currentState = state as TaskDetailState;

    if (currentState.editedTask.status == TaskStatus.done && currentState.assigner == null) {
      AppSnackBar.show(AppRouter.context, 'Add assigner before close task', AppSnackBarType.info);
      return;
    }

    int hourCount = -1;

    if (currentState.editedTask.status == TaskStatus.done) {
      await AppRouter.dialog(
        (context) => SelectHourCountDialog(
          onSetHourCount: (value) {
            hourCount = value;
          },
        ),
      );
      //TODO: add snack 'add work hour'
      if (hourCount == -1) {
        return;
      }
    } else {
      hourCount = 0;
    }
    final task = currentState.editedTask.copyWith(
      dueDate: currentState.task?.dueDate ?? DateTime.now(),
      cost: currentState.assigner != null ? hourCount * currentState.assigner!.cost : 0,
    );

    if (task.id != null) {
      await _taskApiRepository.edit(task);
      AppSnackBar.show(AppRouter.context, 'Edited', AppSnackBarType.success);
      add(Load(projectId: task.projectId, taskId: task.id));
    } else {
      final newTask = (await _taskApiRepository.create(task)).data;
      if (newTask != null) {
        AppSnackBar.show(AppRouter.context, 'Created', AppSnackBarType.success);
        add(Load(projectId: newTask.projectId, taskId: newTask.id));
      } else {
        AppSnackBar.show(AppRouter.context, 'Create error', AppSnackBarType.error);
      }
    }
  }

  Future<void> _onTaskStatusSwap(OnTaskStatusSwap event, Emitter emit) async {
    final currentState = state as TaskDetailState;
    final task = currentState.editedTask.copyWith(status: event.status);
    emit(currentState.copyWith(editedTask: task));
  }

  Future<void> _onUserSwap(OnUserSwap event, Emitter emit) async {
    final currentState = state as TaskDetailState;

    emit(TaskDetailState(
      assigner: event.user,
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
