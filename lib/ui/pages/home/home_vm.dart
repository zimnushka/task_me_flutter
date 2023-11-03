import 'dart:async';
import 'package:flutter/material.dart';
import 'package:task_me_flutter/bloc/main_bloc.dart';
import 'package:task_me_flutter/domain/models/schemes.dart';
import 'package:task_me_flutter/repositories/api/api.dart';
import 'package:task_me_flutter/ui/pages/settings/settings.dart';
import 'package:task_me_flutter/ui/pages/task_detail/task_detail.dart';

class HomeVM extends ChangeNotifier {
  final MainBloc mainBloc;

  HomeVM({required this.mainBloc}) {
    _init();
  }

  List<Task> _tasks = [];
  List<Task> get tasks => _tasks;

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  Future<void> _init() async {
    _isLoading = true;
    notifyListeners();

    final responce = await mainBloc.state.repo.getTasksAll();
    responce.data?.sort((a, b) => a.status.index.compareTo(b.status.index));
    if (responce.data != null) {
      _tasks = responce.data!;
      _isLoading = false;
    }
    notifyListeners();
  }

  Future<void> onHeaderButtonTap() async {
    await mainBloc.router.goTo(SettingsPage.route());
  }

  Future<void> onTaskTap(int id) async {
    final task = _tasks.firstWhere((element) => element.id == id);
    await mainBloc.router.goTo(
      TaskPage.route(
        task.projectId,
        taskId: task.id,
        onTaskUpdate: updateTasks,
      ),
    );
  }

  Future<void> updateTasks() async {
    final responce = await mainBloc.state.repo.getTasksAll();
    responce.data?.sort((a, b) => a.status.index.compareTo(b.status.index));
    if (responce.data != null) {
      _tasks = responce.data!;
      notifyListeners();
    }
  }
}
