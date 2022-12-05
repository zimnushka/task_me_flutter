// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:task_me_flutter/app/bloc/states.dart';
import 'package:task_me_flutter/layers/models/schemes.dart';
import 'package:task_me_flutter/layers/repositories/api/project.dart';
import 'package:task_me_flutter/layers/repositories/api/task.dart';
import 'package:task_me_flutter/layers/repositories/api/user.dart';

enum ProjectPageState { tasks, users }

class ProjectState extends AppState {
  final Project? project;
  final List<User> users;
  final List<Task> tasks;
  final ProjectPageState pageState;

  const ProjectState({
    required this.users,
    required this.tasks,
    this.project,
    this.pageState = ProjectPageState.tasks,
  });

  ProjectState copyWith({
    Project? project,
    List<User>? users,
    List<Task>? tasks,
    ProjectPageState? pageState,
  }) {
    return ProjectState(
      tasks: tasks ?? this.tasks,
      project: project ?? this.project,
      users: users ?? this.users,
      pageState: pageState ?? this.pageState,
    );
  }
}

class ProjectCubit extends Cubit<AppState> {
  final int projectId;
  ProjectCubit(this.projectId) : super(const ProjectState(users: [], tasks: [])) {
    load();
  }

  final ProjectApiRepository projectApiRepository = ProjectApiRepository();
  final UserApiRepository userApiRepository = UserApiRepository();
  final TaskApiRepository taskApiRepository = TaskApiRepository();

  Future<void> load() async {
    final projectData = await projectApiRepository.getById(projectId);
    final users = await userApiRepository.getUserFromProject(projectId);
    final tasks = await taskApiRepository.getByProject(projectId);
    emit(ProjectState(project: projectData.data, users: users.data ?? [], tasks: tasks.data ?? []));
  }

  Future<void> setPageState(ProjectPageState pageState) async {
    if (pageState == (state as ProjectState).pageState) {
      return;
    }
    emit((state as ProjectState).copyWith(pageState: pageState));
  }

  Future<void> updateTasks() async {
    final tasks = await taskApiRepository.getByProject(projectId);
    final newState = (state as ProjectState).copyWith(tasks: tasks.data ?? []);
    emit(newState);
  }

  Future<void> updateUsers() async {
    final users = await userApiRepository.getUserFromProject(projectId);
    emit((state as ProjectState).copyWith(users: users.data ?? []));
  }
}
