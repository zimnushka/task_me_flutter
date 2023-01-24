import 'package:task_me_flutter/app/bloc/states.dart';
import 'package:task_me_flutter/layers/bloc/project/project_bloc.dart';
import 'package:task_me_flutter/layers/models/schemes.dart';

class ProjectLoadedState extends AppLoadedState {
  final Project project;
  final List<User> users;
  final List<TaskUi> tasks;
  final ProjectPageState pageState;

  const ProjectLoadedState({
    required this.users,
    required this.tasks,
    required this.project,
    this.pageState = ProjectPageState.tasks,
  });

  ProjectLoadedState copyWith({
    Project? project,
    List<User>? users,
    List<TaskUi>? tasks,
    ProjectPageState? pageState,
    List<TaskStatus>? openedStatuses,
  }) {
    return ProjectLoadedState(
      project: project ?? this.project,
      users: users ?? this.users,
      tasks: tasks ?? this.tasks,
      pageState: pageState ?? this.pageState,
    );
  }
}

class ProjectLoadingState extends AppLoadingState {}
