import 'package:task_me_flutter/layers/bloc/project/project_bloc.dart';
import 'package:task_me_flutter/layers/models/schemes.dart';

abstract class ProjectEvent {}

class Load extends ProjectEvent {
  final int projectId;

  Load(this.projectId);
}

class OnTaskTap extends ProjectEvent {
  final int taskId;

  OnTaskTap(this.taskId);
}

class OnTabTap extends ProjectEvent {
  final ProjectPageState page;

  OnTabTap(this.page);
}

class OnHeaderButtonTap extends ProjectEvent {}

class Refresh extends ProjectEvent {
  final bool user;
  final bool tasks;
  final bool project;

  Refresh({this.project = false, this.tasks = false, this.user = false});
}

class OnDeleteProject extends ProjectEvent {}

class OnDeleteUser extends ProjectEvent {
  final int userId;

  OnDeleteUser(this.userId);
}
