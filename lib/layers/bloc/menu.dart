import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_me_flutter/app/bloc/states.dart';
import 'package:task_me_flutter/layers/models/api_response.dart';
import 'package:task_me_flutter/layers/models/schemes.dart';
import 'package:task_me_flutter/layers/repositories/api/project.dart';

class MenuState extends AppState {
  final List<Project> projects;

  const MenuState({
    required this.projects,
  });
}

class MenuCubit extends Cubit<AppState> {
  MenuCubit() : super(const MenuState(projects: [])) {
    load();
  }

  final ProjectApiRepository projectApiRepository = ProjectApiRepository();

  Future<void> load() async {
    final projectsData = await projectApiRepository.getAll();
    emit(MenuState(projects: projectsData.data ?? []));
  }
}
