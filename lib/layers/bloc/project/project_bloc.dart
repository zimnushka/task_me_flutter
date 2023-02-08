import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_me_flutter/app/bloc/states.dart';
import 'package:task_me_flutter/app/service/router.dart';
import 'package:task_me_flutter/layers/bloc/app_provider.dart';
import 'package:task_me_flutter/layers/bloc/project/project_event.dart';
import 'package:task_me_flutter/layers/bloc/project/project_state.dart';
import 'package:task_me_flutter/layers/models/schemes.dart';
import 'package:task_me_flutter/layers/repositories/api/project.dart';
import 'package:task_me_flutter/layers/repositories/api/task.dart';
import 'package:task_me_flutter/layers/repositories/api/user.dart';
import 'package:task_me_flutter/layers/ui/kit/overlays/invite_member.dart';
import 'package:task_me_flutter/layers/ui/kit/overlays/project_dialog.dart';
import 'package:task_me_flutter/layers/ui/pages/home.dart';
import 'package:task_me_flutter/layers/ui/pages/task_detail/task_detail.dart';

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
    on<OnDeleteProject>(_onDeleteProject);
    on<OnDeleteUser>(_onDeleteUser);
  }

  Future<void> _load(Load event, Emitter emit) async {
    final projectData = await projectApiRepository.getById(event.projectId);
    final users = await userApiRepository.getUserFromProject(event.projectId);
    final tasksData = await taskApiRepository.getByProject(event.projectId);
    final tasks = tasksData.data ?? [];
    tasks.sort((a, b) => a.status.index.compareTo(b.status.index));

    emit(
      ProjectLoadedState(
        project: projectData.data!,
        users: users.data ?? [],
        tasks: tasks
            .map((task) => TaskUi(task, user: _getUserTask(task.assignerId, users.data ?? [])))
            .toList(),
      ),
    );
  }

  Future<void> _refresh(Refresh event, Emitter emit) async {
    final currentState = state as ProjectLoadedState;

    ProjectLoadedState newState = currentState;

    if (event.user) {
      final users = await userApiRepository.getUserFromProject(currentState.project.id!);
      newState = newState.copyWith(users: users.data);
    }
    if (event.project) {
      final projectData = await projectApiRepository.getById(currentState.project.id!);
      final provider = AppRouter.context.read<AppProvider>();
      await provider.load();
      newState = newState.copyWith(project: projectData.data);
    }
    if (event.tasks) {
      final tasksData = await taskApiRepository.getByProject(currentState.project.id!);
      final tasks = tasksData.data ?? [];
      tasks.sort((a, b) => a.status.index.compareTo(b.status.index));
      newState = newState.copyWith(
        tasks: tasks
            .map((task) => TaskUi(task, user: _getUserTask(task.assignerId, currentState.users)))
            .toList(),
      );
    }

    emit(newState);
  }

  Future<void> _onDeleteUser(OnDeleteUser event, Emitter emit) async {
    final currentState = state as ProjectLoadedState;
    await userApiRepository.deleteMemberFromProject(event.userId, currentState.project.id!);
    add(Refresh(user: true));
  }

  Future<void> _onDeleteProject(OnDeleteProject event, Emitter emit) async {
    final currentState = state as ProjectLoadedState;
    await projectApiRepository.delete(currentState.project.id!);
    final provider = AppRouter.context.read<AppProvider>();
    await provider.load();
    await AppRouter.goTo(HomePage.route());
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
            onInvite: () => add(Refresh(user: true)),
          ),
        );
        break;
      case ProjectPageState.info:
        await AppRouter.dialog((context) => ProjectDialog(
              project: currentState.project,
              onUpdate: () => add(Refresh(project: true)),
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

  User? _getUserTask(int? id, List<User> users) {
    if (id == null) {
      return null;
    }
    final usersTask = users.where((element) => element.id == id);
    if (usersTask.isEmpty) {
      return null;
    }
    return usersTask.first;
  }
}
