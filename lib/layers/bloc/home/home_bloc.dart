import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_me_flutter/app/bloc/states.dart';
import 'package:task_me_flutter/app/service/router.dart';
import 'package:task_me_flutter/layers/bloc/home/home_event.dart';
import 'package:task_me_flutter/layers/bloc/home/home_state.dart';
import 'package:task_me_flutter/layers/repositories/api/task.dart';
import 'package:task_me_flutter/layers/ui/kit/overlays/user_editor.dart';
import 'package:task_me_flutter/layers/ui/pages/task_detail/task_detail.dart';

class HomeBloc extends Bloc<HomeEvent, AppState> {
  HomeBloc() : super(HomeLoadingState()) {
    on<Load>(_load);
    on<OnTaskTap>(_onTaskTap);
    on<Refresh>(_updateTasks);
    on<OnHeaderButtonTap>(_onHeaderButtonTap);
  }

  final TaskApiRepository taskApiRepository = TaskApiRepository();

  Future<void> _load(Load event, Emitter emit) async {
    final tasks = await taskApiRepository.getAll();
    tasks.data?.sort((a, b) => a.status.index.compareTo(b.status.index));
    emit(
      HomeLoadedState(
        tasks: tasks.data ?? [],
      ),
    );
  }

  Future<void> _onHeaderButtonTap(OnHeaderButtonTap event, Emitter emit) async {
    await AppRouter.dialog((context) => const UserEditDialog());
  }

  Future<void> _onTaskTap(OnTaskTap event, Emitter emit) async {
    final currentState = state as HomeLoadedState;
    final task = currentState.tasks.firstWhere((element) => element.id == event.id);
    await AppRouter.goTo(TaskPage.route(task.projectId, taskId: task.id));
  }

  Future<void> _updateTasks(Refresh event, Emitter emit) async {
    final tasks = await taskApiRepository.getAll();
    tasks.data?.sort((a, b) => a.status.index.compareTo(b.status.index));
    final newState = (state as HomeLoadedState).copyWith(tasks: tasks.data ?? []);
    emit(newState);
  }
}
