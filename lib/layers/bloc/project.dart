// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:task_me_flutter/app/bloc/states.dart';
import 'package:task_me_flutter/layers/models/schemes.dart';
import 'package:task_me_flutter/layers/repositories/api/project.dart';
import 'package:task_me_flutter/layers/repositories/api/user.dart';

enum ProjectPageState { tasks, users }

class ProjectState extends AppState {
  final Project? project;
  final List<User> users;
  final ProjectPageState pageState;

  const ProjectState({
    required this.users,
    this.project,
    this.pageState = ProjectPageState.tasks,
  });

  ProjectState copyWith({
    Project? project,
    List<User>? users,
    ProjectPageState? pageState,
  }) {
    return ProjectState(
      project: project ?? this.project,
      users: users ?? this.users,
      pageState: pageState ?? this.pageState,
    );
  }
}

class ProjectCubit extends Cubit<AppState> {
  final int projectId;
  ProjectCubit(this.projectId) : super(const ProjectState(users: [])) {
    load();
  }

  final ProjectApiRepository projectApiRepository = ProjectApiRepository();
  final UserApiRepository userApiRepository = UserApiRepository();

  Future<void> load() async {
    final projectData = await projectApiRepository.getById(projectId);
    final users = await userApiRepository.getUserFromProject(projectId);
    emit(ProjectState(project: projectData.data, users: users.data ?? []));
  }

  Future<void> setPageState(ProjectPageState pageState) async {
    emit((state as ProjectState).copyWith(pageState: pageState));
  }
}
