import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_me_flutter/app/bloc/states.dart';
import 'package:task_me_flutter/app/service/router.dart';
import 'package:task_me_flutter/layers/bloc/project/project_event.dart';
import 'package:task_me_flutter/layers/bloc/project/project_state.dart';
import 'package:task_me_flutter/layers/models/schemes.dart';
import 'package:task_me_flutter/layers/repositories/api/project.dart';
import 'package:task_me_flutter/layers/repositories/api/task.dart';
import 'package:task_me_flutter/layers/repositories/api/user.dart';
import 'package:task_me_flutter/layers/ui/kit/overlays/invite_member.dart';
import 'package:task_me_flutter/layers/ui/kit/overlays/project_dialog.dart';
import 'package:task_me_flutter/layers/ui/pages/home.dart';
import 'package:task_me_flutter/layers/ui/pages/task_page.dart';

enum ProjectPageState { tasks, users, info }

extension ProjectPageStateExt on ProjectPageState {
  String get headerButtonLabel {
    switch (this) {
      case ProjectPageState.tasks:
        return 'Create task';
      case ProjectPageState.users:
        return 'Invite user';
      case ProjectPageState.info:
        return 'Edit project';
    }
  }
}

class ProjectBloc extends Bloc<ProjectEvent, AppState> {
  final ProjectApiRepository projectApiRepository = ProjectApiRepository();
  final UserApiRepository userApiRepository = UserApiRepository();
  final TaskApiRepository taskApiRepository = TaskApiRepository();

  ProjectBloc() : super(ProjectLoadingState()) {
    on<Load>(_load);
    on<OnHeaderButtonTap>(_onHeaderButtonTap);
    on<OnTabTap>(_onTabTap);
    on<OnTaskTap>(_onTaskTap);
    on<Refresh>(_refresh);
    on<OnTaskStatusTap>(_onTaskStatusTap);
    on<OnDeleteProject>(_onDeleteProject);
  }

  Future<void> _load(Load event, Emitter emit) async {
    final projectData = await projectApiRepository.getById(event.projectId);
    final users = await userApiRepository.getUserFromProject(event.projectId);
    final tasks = await taskApiRepository.getByProject(event.projectId);
    tasks.data?.sort((a, b) => a.status.index.compareTo(b.status.index));
    emit(
      ProjectLoadedState(
        project: projectData.data!,
        users: users.data ?? [],
        tasks: tasks.data ?? [],
        openedStatuses: TaskStatus.values,
      ),
    );
  }

  Future<void> _refresh(Refresh event, Emitter emit) async {
    final currentState = state as ProjectLoadedState;

    final projectData = await projectApiRepository.getById(currentState.project.id!);
    final users = await userApiRepository.getUserFromProject(currentState.project.id!);
    final tasks = await taskApiRepository.getByProject(currentState.project.id!);
    tasks.data?.sort((a, b) => a.status.index.compareTo(b.status.index));

    emit(currentState.copyWith(
      project: projectData.data,
      users: users.data,
      tasks: tasks.data,
    ));
  }

  Future<void> _onDeleteProject(OnDeleteProject event, Emitter emit) async {
    final currentState = state as ProjectLoadedState;
    await projectApiRepository.delete(currentState.project.id!);
    await AppRouter.goTo(HomePage.route());
    //TODO(kirill zima): fix deletion from side bar
  }

  Future<void> _onHeaderButtonTap(OnHeaderButtonTap event, Emitter emit) async {
    final currentState = state as ProjectLoadedState;
    switch (currentState.pageState) {
      case ProjectPageState.tasks:
        await AppRouter.goTo(TaskPage.route(currentState.project.id!));
        break;
      case ProjectPageState.users:
        await AppRouter.dialog(
          (context) => InviteMemberDialog(
            projectId: currentState.project.id!,
            onInvite: () => add(Refresh()),
          ),
        );
        break;
      case ProjectPageState.info:
        await AppRouter.dialog((context) => ProjectDialog(
              project: currentState.project,
              onUpdate: () => add(Refresh()),
            ));
        break;
    }
  }

  Future<void> _onTaskTap(OnTaskTap event, Emitter emit) async {
    final currentState = state as ProjectLoadedState;
    await AppRouter.goTo(TaskPage.route(currentState.project.id!, taskId: event.taskId));
  }

  Future<void> _onTabTap(OnTabTap event, Emitter emit) async {
    final currentState = state as ProjectLoadedState;
    if (event.page == currentState.pageState) {
      return;
    }
    emit(currentState.copyWith(pageState: event.page));
  }

  Future<void> _onTaskStatusTap(OnTaskStatusTap event, Emitter emit) async {
    final currentState = state as ProjectLoadedState;

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
