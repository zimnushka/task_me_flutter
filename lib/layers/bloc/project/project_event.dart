import 'package:task_me_flutter/app/bloc/states.dart';
import 'package:task_me_flutter/layers/bloc/project/project_bloc.dart';
import 'package:task_me_flutter/layers/models/schemes.dart';

abstract class ProjectEvent extends AppState {}

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

class OnTaskStatusTap extends ProjectEvent {
  final TaskStatus status;
  OnTaskStatusTap(this.status);
}

class Refresh extends ProjectEvent {}

class OnDeleteProject extends ProjectEvent {}
